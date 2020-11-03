//! Utility class for manipulating RGBA colors.

const sf = @import("../sfml_import.zig");
const math = @import("std").math;

pub const Color = struct {
    const Self = @This();

    /// Converts a color from a csfml object
    pub fn fromCSFML(col: sf.c.sfColor) Self {
        return Self{
            .r = col.r,
            .g = col.g,
            .b = col.b,
            .a = col.a,
        };
    }

    /// Converts this color to a csfml one
    pub fn toCSFML(self: Self) sf.c.sfColor {
        return sf.c.sfColor{
            .r = self.r,
            .g = self.g,
            .b = self.b,
            .a = self.a,
        };
    }

    /// Inits a color with rgb components
    pub fn rgb(red: u8, green: u8, blue: u8) Self {
        return Self{
            .r = red,
            .g = green,
            .b = blue,
            .a = 0xff,
        };
    }

    /// Inits a color with rgba components
    pub fn rgba(red: u8, green: u8, blue: u8, alpha: u8) Self {
        return Self{
            .r = red,
            .g = green,
            .b = blue,
            .a = alpha,
        };
    }

    /// Inits a color from a 32bits value (RGBA in that order)
    pub fn fromInteger(int: u32) Self {
        return Self{
            .r = @truncate(u8, (int & 0xff000000) >> 24),
            .g = @truncate(u8, (int & 0x00ff0000) >> 16),
            .b = @truncate(u8, (int & 0x0000ff00) >> 8),
            .a = @truncate(u8, (int & 0x000000ff) >> 0),
        };
    }

    /// Gets a 32 bit integer representing the color
    pub fn toInteger(self: Self) u32 {
        return (@intCast(u32, self.r) << 24) |
            (@intCast(u32, self.g) << 16) |
            (@intCast(u32, self.b) << 8) |
            (@intCast(u32, self.a) << 0);
    }

    fn fromFloats(red: f32, green: f32, blue: f32, alpha: f32) Self {
        return Self{
            .r = @floatToInt(u8, math.clamp(red, 0.0, 1.0) * 255.0),
            .g = @floatToInt(u8, math.clamp(green, 0.0, 1.0) * 255.0),
            .b = @floatToInt(u8, math.clamp(blue, 0.0, 1.0) * 255.0),
            .a = @floatToInt(u8, math.clamp(alpha, 0.0, 1.0) * 255.0),
        };
    }

    /// Creates a color from HSV and transparency components (this is not part of the SFML)
    pub fn fromHSVA(hue: f32, saturation: f32, value: f32, alpha: f32) Self {
        const h = hue;
        const s = saturation;
        const v = value;

        var hh: f32 = h;

        if (v <= 0.0)
            return fromFloats(0, 0, 0, alpha);

        if (hh >= 360.0)
            hh = 0;
        hh /= 60.0;

        var ff: f32 = hh - math.floor(hh);

        var p: f32 = v * (1.0 - s);
        var q: f32 = v * (1.0 - (s * ff));
        var t: f32 = v * (1.0 - (s * (1.0 - ff)));

        return switch (@floatToInt(usize, hh)) {
            0 => fromFloats(v, t, p, alpha),
            1 => fromFloats(q, v, p, alpha),
            2 => fromFloats(p, v, t, alpha),
            3 => fromFloats(p, q, v, alpha),
            4 => fromFloats(t, p, v, alpha),
            else => fromFloats(v, p, q, alpha),
        };
    }

    // Colors
    /// Black color
    pub const Black = Self.rgb(0, 0, 0);
    /// White color
    pub const White = Self.rgb(255, 255, 255);
    /// Red color
    pub const Red = Self.rgb(255, 0, 0);
    /// Green color
    pub const Green = Self.rgb(0, 255, 0);
    /// Blue color
    pub const Blue = Self.rgb(0, 0, 255);
    /// Yellow color
    pub const Yellow = Self.rgb(255, 255, 0);
    /// Magenta color
    pub const Magenta = Self.rgb(255, 0, 255);
    /// Cyan color
    pub const Cyan = Self.rgb(0, 255, 255);
    /// Transparent color
    pub const Transparent = Self.rgba(0, 0, 0, 0);

    /// Red component
    r: u8,
    /// Green component
    g: u8,
    /// Blue component
    b: u8,
    /// Alpha (opacity) component
    a: u8
};

const tst = @import("std").testing;

test "color: conversions" {
    var code: u32 = 0x4BDA9CFF;
    var col = Color.fromInteger(code);

    tst.expectEqual(Color.rgb(75, 218, 156), col);
    tst.expectEqual(code, col.toInteger());

    var csfml_col = sf.c.sfColor_fromInteger(@as(c_uint, code));

    // TODO : issue #2
    //tst.expectEqual(Color.fromCSFML(csfml_col), col);
}

test "color: hsv to rgb" {
    var col = Color.fromHSVA(240, 100, 100, 255);

    tst.expectEqual(Color.Blue, col);
}
