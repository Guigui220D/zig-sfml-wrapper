//! Utility class for manipulating RGBA colors.

const sf = @import("../sfml_import.zig");
const math = @import("std").math;

pub const Color = packed struct {
    /// Converts a color from a csfml object
    /// For inner workings
    pub fn fromCSFML(col: sf.c.sfColor) Color {
        return Color{
            .r = col.r,
            .g = col.g,
            .b = col.b,
            .a = col.a,
        };
    }

    /// Converts this color to a csfml one
    /// For inner workings
    pub fn toCSFML(self: Color) sf.c.sfColor {
        return sf.c.sfColor{
            .r = self.r,
            .g = self.g,
            .b = self.b,
            .a = self.a,
        };
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
            .r = @truncate(u8, (int & 0xff000000) >> 24),
            .g = @truncate(u8, (int & 0x00ff0000) >> 16),
            .b = @truncate(u8, (int & 0x0000ff00) >> 8),
            .a = @truncate(u8, (int & 0x000000ff) >> 0),
        };
    }

    /// Gets a 32 bit integer representing the color
    pub fn toInteger(self: Color) u32 {
        return (@intCast(u32, self.r) << 24) |
            (@intCast(u32, self.g) << 16) |
            (@intCast(u32, self.b) << 8) |
            (@intCast(u32, self.a) << 0);
    }

    /// Creates a color with rgba floats from 0 to 1
    fn fromFloats(red: f32, green: f32, blue: f32, alpha: f32) Color {
        return Color{
            .r = @floatToInt(u8, math.clamp(red, 0.0, 1.0) * 255.0),
            .g = @floatToInt(u8, math.clamp(green, 0.0, 1.0) * 255.0),
            .b = @floatToInt(u8, math.clamp(blue, 0.0, 1.0) * 255.0),
            .a = @floatToInt(u8, math.clamp(alpha, 0.0, 1.0) * 255.0),
        };
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

        var ff: f32 = hh - math.floor(hh);

        var p: f32 = v * (1.0 - s);
        var q: f32 = v * (1.0 - (s * ff));
        var t: f32 = v * (1.0 - (s * (1.0 - ff)));

        return switch (@floatToInt(usize, hh)) {
            0 => fromFloats(v, t, p, a),
            1 => fromFloats(q, v, p, a),
            2 => fromFloats(p, v, t, a),
            3 => fromFloats(p, q, v, a),
            4 => fromFloats(t, p, v, a),
            else => fromFloats(v, p, q, a),
        };
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

    var code: u32 = 0x4BDA9CFF;
    var col = Color.fromInteger(code);

    tst.expectEqual(Color.fromRGB(75, 218, 156), col);
    tst.expectEqual(code, col.toInteger());

    var csfml_col = sf.c.sfColor_fromInteger(@as(c_uint, code));

    // TODO : issue #2
    //tst.expectEqual(Color.fromCSFML(csfml_col), col);
}

test "color: hsv to rgb" {
    const tst = @import("std").testing;
    
    var col = Color.fromHSVA(10, 20, 100, 255);

    tst.expectEqual(Color.fromRGB(255, 212, 204), col);
}

