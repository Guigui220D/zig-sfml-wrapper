//! Graphical text that can be drawn to a render target.

const sf = struct {
    pub usingnamespace @import("../sfml.zig");
    pub usingnamespace system;
    pub usingnamespace graphics;
};

const Text = @This();

// Constructor/destructor

/// Inits an empty text
pub fn create() !Text {
    var text = sf.c.sfText_create();
    if (text == null)
        return sf.Error.nullptrUnknownReason;
    return Text{ .ptr = text.? };
}
/// Inits a text with content
pub fn createWithText(string: [:0]const u8, font: sf.Font, character_size: usize) !Text {
    var text = sf.c.sfText_create();
    if (text == null)
        return sf.Error.nullptrUnknownReason;
    sf.c.sfText_setFont(text, font.ptr);
    sf.c.sfText_setCharacterSize(text, @intCast(c_uint, character_size));
    sf.c.sfText_setString(text, string);
    return Text{ .ptr = text.? };
}
/// Destroys a text
pub fn destroy(self: Text) void {
    sf.c.sfText_destroy(self.ptr);
}

// Getters/setters

/// Sets the content of this text
pub fn setString(self: Text, string: [:0]const u8) void {
    sf.c.sfText_setString(self.ptr, string);
}

/// Sets the font of this text
pub fn setFont(self: Text, font: sf.Font) void {
    sf.c.sfText_setFont(self.ptr, font.ptr);
}

/// Gets the character size of this text
pub fn getCharacterSize(self: Text) usize {
    return @intCast(usize, sf.c.sfText_getCharacterSize(self.ptr));
}
/// Sets the character size of this text
pub fn setCharacterSize(self: Text, character_size: usize) void {
    sf.c.sfText_setCharacterSize(self.ptr, @intCast(c_uint, character_size));
}

/// Gets the fill color of this text
pub fn getFillColor(self: Text) sf.Color {
    return sf.Color.fromCSFML(sf.c.sfText_getFillColor(self.ptr));
}
/// Sets the fill color of this text
pub fn setFillColor(self: Text, color: sf.Color) void {
    sf.c.sfText_setFillColor(self.ptr, color.toCSFML());
}

/// Gets the outline color of this text
pub fn getOutlineColor(self: Text) sf.Color {
    return sf.Color.fromCSFML(sf.c.sfText_getOutlineColor(self.ptr));
}
/// Sets the outline color of this text
pub fn setOutlineColor(self: Text, color: sf.Color) void {
    sf.c.sfText_setOutlineColor(self.ptr, color.toCSFML());
}

/// Gets the outline thickness of this text
pub fn getOutlineThickness(self: Text) f32 {
    return sf.c.sfText_getOutlineThickness(self.ptr);
}
/// Sets the outline thickness of this text
pub fn setOutlineThickness(self: Text, thickness: f32) void {
    sf.c.sfText_setOutlineThickness(self.ptr, thickness);
}

/// Gets the position of this text
pub fn getPosition(self: Text) sf.Vector2f {
    return sf.Vector2f.fromCSFML(sf.c.sfText_getPosition(self.ptr));
}
/// Sets the position of this text
pub fn setPosition(self: Text, pos: sf.Vector2f) void {
    sf.c.sfText_setPosition(self.ptr, pos.toCSFML());
}
/// Adds the offset to this text
pub fn move(self: Text, offset: sf.Vector2f) void {
    sf.c.sfText_move(self.ptr, offset.toCSFML());
}

/// Gets the origin of this text
pub fn getOrigin(self: Text) sf.Vector2f {
    return sf.Vector2f.fromCSFML(sf.c.sfText_getOrigin(self.ptr));
}
/// Sets the origin of this text
pub fn setOrigin(self: Text, origin: sf.Vector2f) void {
    sf.c.sfText_setOrigin(self.ptr, origin.toCSFML());
}

/// Gets the rotation of this text
pub fn getRotation(self: Text) f32 {
    return sf.c.sfText_getRotation(self.ptr);
}
/// Sets the rotation of this text
pub fn setRotation(self: Text, angle: f32) void {
    sf.c.sfText_setRotation(self.ptr, angle);
}
/// Rotates this text by a given amount
pub fn rotate(self: Text, angle: f32) void {
    sf.c.sfText_rotate(self.ptr, angle);
}

/// Gets the scale of this text
pub fn getScale(self: Text) sf.Vector2f {
    return sf.Vector2f.fromCSFML(sf.c.sfText_getScale(self.ptr));
}
/// Sets the scale of this text
pub fn setScale(self: Text, factor: sf.Vector2f) void {
    sf.c.sfText_setScale(self.ptr, factor.toCSFML());
}
/// Scales this text
pub fn scale(self: Text, factor: sf.Vector2f) void {
    sf.c.sfText_scale(self.ptr, factor.toCSFML());
}

/// return the position of the index-th character
pub fn findCharacterPos(self: Text, index: usize) sf.Vector2f {
    return sf.Vector2f.fromCSFML(sf.c.sfText_findCharacterPos(self.ptr));
}

/// Gets the letter spacing factor
pub fn getLetterSpacing(self: Text) f32 {
    return sf.c.sfText_getLetterSpacing(self.ptr);
} 
/// Sets the letter spacing factor
pub fn setLetterSpacing(self: Text, spacing_factor: f32) void {
    sf.c.sfText_setLetterSpacing(self.ptr, spacing_factor);
} 

/// Gets the line spacing factor
pub fn getLineSpacing(self: Text) f32 {
    return sf.c.sfText_getLineSpacing(self.ptr);
} 
/// Sets the line spacing factor
pub fn setLineSpacing(self: Text, spacing_factor: f32) void {
    sf.c.sfText_setLineSpacing(self.ptr, spacing_factor);
} 

/// Gets the local bounding rectangle of the text
pub fn getLocalBounds(self: Text) sf.FloatRect {
    return sf.FloatRect.fromCSFML(sf.c.sfText_getLocalBounds(self.ptr));
}
/// Gets the global bounding rectangle of the text
pub fn getGlobalBounds(self: Text) sf.FloatRect {
    return sf.FloatRect.fromCSFML(sf.c.sfText_getGlobalBounds(self.ptr));
}

pub const getTransform = @compileError("Function is not implemented yet.");
pub const getInverseTransform = @compileError("Function is not implemented yet.");

/// Pointer to the csfml font
ptr: *sf.c.sfText,

test "text: sane getters and setters" {
    const tst = @import("std").testing;
    
    var text = try Text.create();
    defer text.destroy();

    text.setText("hello");
    text.setFillColor(sf.Color.Yellow);
    text.setOutlineColor(sf.Color.Red);
    text.setOutlineThickness(2);
    text.setCharacterSize(10);
    text.setRotation(15);
    text.setPosition(.{ .x = 1, .y = 2 });
    text.setOrigin(.{ .x = 20, .y = 25 });
    text.setScale(.{ .x = 2, .y = 2 });

    text.rotate(5);
    text.move(.{ .x = -5, .y = 5 });
    text.scale(.{ .x = 2, .y = 3 });
    
    //getfillcolor
    //getoutlinecolor
    tst.expectEqual(@as(f32, 2), text.getOutlineThickness());
    tst.expectEqual(@as(usize, 10), text.getCharacterSize());
    tst.expectEqual(@as(f32, 20), text.getRotation());
    tst.expectEqual(sf.Vector2f{ .x = -4, .y = 7 }, text.getPosition());
    tst.expectEqual(sf.Vector2f{ .x = 20, .y = 25 }, text.getOrigin());
    tst.expectEqual(sf.Vector2f{ .x = 4, .y = 6 }, text.getScale());

    _ = text.getLocalBounds();
    _ = text.getGlobalBounds();
}
