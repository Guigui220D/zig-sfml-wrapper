//! Graphical text that can be drawn to a render target.

const std = @import("std");
const sf = struct {
    pub usingnamespace @import("../sfml.zig");
    pub usingnamespace sf.system;
    pub usingnamespace sf.graphics;
};

const Text = @This();

// Constructor/destructor

/// Inits an empty text
pub fn create() !Text {
    var text = sf.c.sfText_create();
    if (text == null)
        return sf.Error.nullptrUnknownReason;
    return Text{ ._ptr = text.? };
}
/// Inits a text with content
pub fn createWithText(string: [:0]const u8, font: sf.Font, character_size: usize) !Text {
    var text = sf.c.sfText_create();
    if (text == null)
        return sf.Error.nullptrUnknownReason;
    sf.c.sfText_setFont(text, font._ptr);
    sf.c.sfText_setCharacterSize(text, @intCast(c_uint, character_size));
    sf.c.sfText_setString(text, string);
    return Text{ ._ptr = text.? };
}
/// Destroys a text
pub fn destroy(self: *Text) void {
    sf.c.sfText_destroy(self._ptr);
    self._ptr = undefined;
}

// Draw function

/// The draw function of this shape
/// Meant to be called by your_target.draw(your_shape, .{});
pub fn sfDraw(self: Text, target: anytype, states: ?*sf.c.sfRenderStates) void {
    switch (@TypeOf(target)) {
        sf.RenderWindow => sf.c.sfRenderWindow_drawText(target._ptr, self._ptr, states),
        sf.RenderTexture => sf.c.sfRenderTexture_drawText(target._ptr, self._ptr, states),
        else => @compileError("target must be a render target"),
    }
}

// Getters/setters

/// Sets the content of this text
pub fn setString(self: *Text, string: [:0]const u8) void {
    sf.c.sfText_setString(self._ptr, string);
}
/// Sets the content of this text, but using fmt
pub fn setStringFmt(self: *Text, comptime format: []const u8, args: anytype) std.fmt.AllocPrintError!void {
    const alloc = std.heap.c_allocator;

    const buf = try std.fmt.allocPrintZ(alloc, format, args);
    defer alloc.free(buf);

    sf.c.sfText_setString(self._ptr, buf);
}

/// Sets the font of this text
pub fn setFont(self: *Text, font: sf.Font) void {
    sf.c.sfText_setFont(self._ptr, font._ptr);
}

/// Gets the character size of this text
pub fn getCharacterSize(self: Text) usize {
    return @intCast(usize, sf.c.sfText_getCharacterSize(self._ptr));
}
/// Sets the character size of this text
pub fn setCharacterSize(self: *Text, character_size: usize) void {
    sf.c.sfText_setCharacterSize(self._ptr, @intCast(c_uint, character_size));
}

/// Gets the fill color of this text
pub fn getFillColor(self: Text) sf.Color {
    return sf.Color._fromCSFML(sf.c.sfText_getFillColor(self._ptr));
}
/// Sets the fill color of this text
pub fn setFillColor(self: *Text, color: sf.Color) void {
    sf.c.sfText_setFillColor(self._ptr, color._toCSFML());
}

/// Gets the outline color of this text
pub fn getOutlineColor(self: Text) sf.Color {
    return sf.Color._fromCSFML(sf.c.sfText_getOutlineColor(self._ptr));
}
/// Sets the outline color of this text
pub fn setOutlineColor(self: *Text, color: sf.Color) void {
    sf.c.sfText_setOutlineColor(self._ptr, color._toCSFML());
}

/// Gets the outline thickness of this text
pub fn getOutlineThickness(self: Text) f32 {
    return sf.c.sfText_getOutlineThickness(self._ptr);
}
/// Sets the outline thickness of this text
pub fn setOutlineThickness(self: *Text, thickness: f32) void {
    sf.c.sfText_setOutlineThickness(self._ptr, thickness);
}

/// Gets the position of this text
pub fn getPosition(self: Text) sf.Vector2f {
    return sf.Vector2f._fromCSFML(sf.c.sfText_getPosition(self._ptr));
}
/// Sets the position of this text
pub fn setPosition(self: *Text, pos: sf.Vector2f) void {
    sf.c.sfText_setPosition(self._ptr, pos._toCSFML());
}
/// Adds the offset to this text
pub fn move(self: *Text, offset: sf.Vector2f) void {
    sf.c.sfText_move(self._ptr, offset._toCSFML());
}

/// Gets the origin of this text
pub fn getOrigin(self: Text) sf.Vector2f {
    return sf.Vector2f._fromCSFML(sf.c.sfText_getOrigin(self._ptr));
}
/// Sets the origin of this text
pub fn setOrigin(self: *Text, origin: sf.Vector2f) void {
    sf.c.sfText_setOrigin(self._ptr, origin._toCSFML());
}

/// Gets the rotation of this text
pub fn getRotation(self: Text) f32 {
    return sf.c.sfText_getRotation(self._ptr);
}
/// Sets the rotation of this text
pub fn setRotation(self: *Text, angle: f32) void {
    sf.c.sfText_setRotation(self._ptr, angle);
}
/// Rotates this text by a given amount
pub fn rotate(self: *Text, angle: f32) void {
    sf.c.sfText_rotate(self._ptr, angle);
}

/// Gets the scale of this text
pub fn getScale(self: Text) sf.Vector2f {
    return sf.Vector2f._fromCSFML(sf.c.sfText_getScale(self._ptr));
}
/// Sets the scale of this text
pub fn setScale(self: *Text, factor: sf.Vector2f) void {
    sf.c.sfText_setScale(self._ptr, factor._toCSFML());
}
/// Scales this text
pub fn scale(self: *Text, factor: sf.Vector2f) void {
    sf.c.sfText_scale(self._ptr, factor._toCSFML());
}

/// return the position of the index-th character
pub fn findCharacterPos(self: Text, index: usize) sf.Vector2f {
    return sf.Vector2f._fromCSFML(sf.c.sfText_findCharacterPos(self._ptr, index));
}

/// Gets the letter spacing factor
pub fn getLetterSpacing(self: Text) f32 {
    return sf.c.sfText_getLetterSpacing(self._ptr);
}
/// Sets the letter spacing factor
pub fn setLetterSpacing(self: *Text, spacing_factor: f32) void {
    sf.c.sfText_setLetterSpacing(self._ptr, spacing_factor);
}

/// Gets the line spacing factor
pub fn getLineSpacing(self: Text) f32 {
    return sf.c.sfText_getLineSpacing(self._ptr);
}
/// Sets the line spacing factor
pub fn setLineSpacing(self: *Text, spacing_factor: f32) void {
    sf.c.sfText_setLineSpacing(self._ptr, spacing_factor);
}

/// Gets the local bounding rectangle of the text
pub fn getLocalBounds(self: Text) sf.FloatRect {
    return sf.FloatRect._fromCSFML(sf.c.sfText_getLocalBounds(self._ptr));
}
/// Gets the global bounding rectangle of the text
pub fn getGlobalBounds(self: Text) sf.FloatRect {
    return sf.FloatRect._fromCSFML(sf.c.sfText_getGlobalBounds(self._ptr));
}

/// Puts the origin at the center of the bounding box
pub fn centerOrigin(self: *Text) void {
    const bounds = self.getLocalBounds();
    self.setOrigin(sf.Vector2f{ .x = bounds.width / 2, .y = bounds.height / 2 });
}

pub const getTransform = @compileError("Function is not implemented yet.");
pub const getInverseTransform = @compileError("Function is not implemented yet.");

/// Pointer to the csfml font
_ptr: *sf.c.sfText,

test "text: sane getters and setters" {
    const tst = std.testing;

    var text = try Text.create();
    defer text.destroy();

    text.setString("hello");
    try text.setStringFmt("An int: {}", .{42});
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

    try tst.expectEqual(sf.Color.Yellow, text.getFillColor());
    try tst.expectEqual(sf.Color.Red, text.getOutlineColor());
    try tst.expectEqual(@as(f32, 2), text.getOutlineThickness());
    try tst.expectEqual(@as(usize, 10), text.getCharacterSize());
    try tst.expectEqual(@as(f32, 20), text.getRotation());
    try tst.expectEqual(sf.Vector2f{ .x = -4, .y = 7 }, text.getPosition());
    try tst.expectEqual(sf.Vector2f{ .x = 20, .y = 25 }, text.getOrigin());
    try tst.expectEqual(sf.Vector2f{ .x = 4, .y = 6 }, text.getScale());

    _ = text.getLocalBounds();
    _ = text.getGlobalBounds();
}
