//! Utility class for manipulating RGBA colors.

const sf = @import("../root.zig");
const std = @import("std");
const math = std.math;

pub const Color = packed struct {
    /// Converts a color from a csfml object
    /// For inner workings
    pub fn _fromCSFML(col: sf.c.sfColor) Color {
        return @as(Color, @bitCast(col));
    }

    /// Converts this color to a csfml one
    /// For inner workings
    pub fn _toCSFML(self: Color) sf.c.sfColor {
        return @as(sf.c.sfColor, @bitCast(self));
    }

    /// Inits a color with rgb components
    pub fn fromRGB(red: u8, green: u8, blue: u8) Color {
        return Color{
            .r = red,
            .g = green,
            .b = blue,
            .a = 0xff,
        };
    }

    /// Inits a color with rgba components
    pub fn fromRGBA(red: u8, green: u8, blue: u8, alpha: u8) Color {
        return Color{
            .r = red,
            .g = green,
            .b = blue,
            .a = alpha,
        };
    }

    /// Inits a color from a 32bits value (RGBA in that order)
    pub fn fromInteger(int: u32) Color {
        return Color{
            .r = @as(u8, @truncate((int & 0xff000000) >> 24)),
            .g = @as(u8, @truncate((int & 0x00ff0000) >> 16)),
            .b = @as(u8, @truncate((int & 0x0000ff00) >> 8)),
            .a = @as(u8, @truncate((int & 0x000000ff) >> 0)),
        };
    }

    /// Gets a 32 bit integer representing the color
    pub fn toInteger(self: Color) u32 {
        return (@as(u32, @intCast(self.r)) << 24) |
            (@as(u32, @intCast(self.g)) << 16) |
            (@as(u32, @intCast(self.b)) << 8) |
            (@as(u32, @intCast(self.a)) << 0);
    }

    /// Creates a color with rgba floats from 0 to 1
    fn fromFloats(red: f32, green: f32, blue: f32, alpha: f32) Color {
        return Color{
            .r = @as(u8, @intFromFloat(math.clamp(red, 0.0, 1.0) * 255.0)),
            .g = @as(u8, @intFromFloat(math.clamp(green, 0.0, 1.0) * 255.0)),
            .b = @as(u8, @intFromFloat(math.clamp(blue, 0.0, 1.0) * 255.0)),
            .a = @as(u8, @intFromFloat(math.clamp(alpha, 0.0, 1.0) * 255.0)),
        };
    }

    /// Comptime helper function to create a color from a hexadecimal string
    pub fn fromHex(comptime hex: []const u8) Color {
        if (hex.len != 7 or hex[0] != '#')
            @compileError("Invalid hexadecimal color");

        const int = comptime try std.fmt.parseInt(u32, hex[1..7], 16);

        return comptime fromInteger((int << 8) | 0xff);
    }

    /// Creates a color from HSV and transparency components (this is not part of the SFML)
    /// hue is in degrees, saturation and value are in percents
    pub fn fromHSVA(hue: f32, saturation: f32, value: f32, alpha: f32) Color {
        const h = hue;
        const s = saturation / 100;
        const v = value / 100;
        const a = alpha;

        var hh: f32 = h;

        if (v <= 0.0)
            return fromFloats(0, 0, 0, a);

        if (hh >= 360.0)
            hh = 0;
        hh /= 60.0;

        const ff: f32 = hh - math.floor(hh);

        const p: f32 = v * (1.0 - s);
        const q: f32 = v * (1.0 - (s * ff));
        const t: f32 = v * (1.0 - (s * (1.0 - ff)));

        return switch (@as(usize, @intFromFloat(hh))) {
            0 => fromFloats(v, t, p, a),
            1 => fromFloats(q, v, p, a),
            2 => fromFloats(p, v, t, a),
            3 => fromFloats(p, q, v, a),
            4 => fromFloats(t, p, v, a),
            else => fromFloats(v, p, q, a),
        };
    }

    /// Get a GLSL float vector for this color (for shaders)
    pub fn toFVec4(self: Color) sf.graphics.glsl.FVec4 {
        return .{ .x = @as(f32, @floatFromInt(self.r)) / 255.0, .y = @as(f32, @floatFromInt(self.g)) / 255.0, .z = @as(f32, @floatFromInt(self.b)) / 255.0, .w = @as(f32, @floatFromInt(self.a)) / 255.0 };
    }
    /// Get a GLSL int vector for this color (for shaders)
    pub fn toIVec4(self: Color) sf.graphics.glsl.IVec4 {
        return .{ .x = self.r, .y = self.g, .z = self.b, .w = self.a };
    }

    // Colors
    /// Black color
    pub const Black = Color.fromRGB(0, 0, 0);
    /// White color
    pub const White = Color.fromRGB(255, 255, 255);
    /// Red color
    pub const Red = Color.fromRGB(255, 0, 0);
    /// Green color
    pub const Green = Color.fromRGB(0, 255, 0);
    /// Blue color
    pub const Blue = Color.fromRGB(0, 0, 255);
    /// Yellow color
    pub const Yellow = Color.fromRGB(255, 255, 0);
    /// Magenta color
    pub const Magenta = Color.fromRGB(255, 0, 255);
    /// Cyan color
    pub const Cyan = Color.fromRGB(0, 255, 255);
    /// Transparent color
    pub const Transparent = Color.fromRGBA(0, 0, 0, 0);

    /// Red component
    r: u8,
    /// Green component
    g: u8,
    /// Blue component
    b: u8,
    /// Alpha (opacity) component
    a: u8,
};

test "color: conversions" {
    const tst = @import("std").testing;

    const code: u32 = 0x4BDA9CFF;
    var col = Color.fromInteger(code);

    try tst.expectEqual(Color.fromHex("#4BDA9C"), col);
    try tst.expectEqual(Color.fromRGB(75, 218, 156), col);
    try tst.expectEqual(code, col.toInteger());

    const csfml_col = sf.c.sfColor_fromInteger(@as(c_uint, code));

    try tst.expectEqual(Color._fromCSFML(csfml_col), col);
}

test "color: hsv to rgb" {
    const tst = @import("std").testing;

    const col = Color.fromHSVA(10, 20, 100, 255);

    try tst.expectEqual(Color.fromRGB(255, 212, 204), col);
}

test "color: sane from/to CSFML color" {
    const tst = @import("std").testing;

    const col = Color.fromRGBA(5, 12, 28, 127);
    const ccol = col._toCSFML();

    try tst.expectEqual(col.r, ccol.r);
    try tst.expectEqual(col.g, ccol.g);
    try tst.expectEqual(col.b, ccol.b);
    try tst.expectEqual(col.a, ccol.a);

    const col2 = Color._fromCSFML(ccol);

    try tst.expectEqual(col, col2);
}
