//! Utility class for manipulating RGBA colors.

usingnamespace @import("../sfml_import.zig");

pub const Color = struct {
    const Self = @This();

    /// Converts a color from a csfml object
    pub fn fromCSFML(col: Sf.sfColor) Self {
        return Self{
            .r = col.r,
            .g = col.g,
            .b = col.b,
            .a = col.a
        };
    }

    /// Converts this color to a csfml one
    pub fn toCSFML(self: Self) Sf.sfColor {
        return Sf.sfColor{
            .r = self.r,
            .g = self.g,
            .b = self.b,
            .a = self.a
        };
    }

    /// Inits a color with rgb components
    pub fn rgb(red: u8, green: u8, blue: u8) Self {
        return Self{
            .r = red,
            .g = green,
            .b = blue,
            .a = 0xff
        };
    }

    /// Inits a color with rgba components
    pub fn rgba(red: u8, green: u8, blue: u8, alpha: u8) Self {
        return Self{
            .r = red,
            .g = green,
            .b = blue,
            .a = alpha
        };
    }

    /// Inits a color from a 32bits value (RGBA in that order)
    pub fn fromInteger(int: u32) Self {
        return Self{
            .r = @truncate(u8, (int & 0xff000000) >> 24),
            .g = @truncate(u8, (int & 0x00ff0000) >> 16),
            .b = @truncate(u8, (int & 0x0000ff00) >> 8),
            .a = @truncate(u8, (int & 0x000000ff) >> 0)
        };
    }

    /// Gets a 32 bit integer representing the color
    pub fn toInteger(self: Self) u32 {
        return
            (@intCast(u32, self.r) << 24) |
            (@intCast(u32, self.g) << 16) |
            (@intCast(u32, self.b) << 8) |
            (@intCast(u32, self.a) << 0);
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

    // TODO : color from HSV?

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

    var csfml_col = Sf.sfColor_fromInteger(@as(c_uint, code));

    // TODO : issue #2
    //tst.expectEqual(Color.fromCSFML(csfml_col), col);
}
