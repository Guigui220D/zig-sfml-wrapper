//! Specialized shape representing a rectangle.

const sf = struct {
    pub usingnamespace @import("../sfml.zig");
    pub usingnamespace sf.system;
    pub usingnamespace sf.graphics;
};

const RectangleShape = @This();

// Constructor/destructor

/// Creates a rectangle shape with a size. The rectangle will be white
pub fn create(size: sf.Vector2f) !RectangleShape {
    var rect = sf.c.sfRectangleShape_create();
    if (rect == null)
        return sf.Error.nullptrUnknownReason;

    sf.c.sfRectangleShape_setFillColor(rect, sf.c.sfWhite);
    sf.c.sfRectangleShape_setSize(rect, size._toCSFML());

    return RectangleShape{ ._ptr = rect.? };
}

/// Destroys a rectangle shape
pub fn destroy(self: *RectangleShape) void {
    sf.c.sfRectangleShape_destroy(self._ptr);
    self._ptr = undefined;
}

// Draw function

/// The draw function of this shape
/// Meant to be called by your_target.draw(your_shape, .{});
pub fn sfDraw(self: RectangleShape, target: anytype, states: ?*sf.c.sfRenderStates) void {
    switch (@TypeOf(target)) {
        sf.RenderWindow => sf.c.sfRenderWindow_drawRectangleShape(target._ptr, self._ptr, states),
        sf.RenderTexture => sf.c.sfRenderTexture_drawRectangleShape(target._ptr, self._ptr, states),
        else => @compileError("target must be a render target"),
    }
}

// Getters/setters

/// Gets the fill color of this rectangle shape
pub fn getFillColor(self: RectangleShape) sf.Color {
    return sf.Color._fromCSFML(sf.c.sfRectangleShape_getFillColor(self._ptr));
}
/// Sets the fill color of this rectangle shape
pub fn setFillColor(self: *RectangleShape, color: sf.Color) void {
    sf.c.sfRectangleShape_setFillColor(self._ptr, color._toCSFML());
}

/// Gets the outline color of this rectangle shape
pub fn getOutlineColor(self: RectangleShape) sf.Color {
    return sf.Color._fromCSFML(sf.c.sfRectangleShape_getOutlineColor(self._ptr));
}
/// Sets the outline color of this rectangle shape
pub fn setOutlineColor(self: *RectangleShape, color: sf.Color) void {
    sf.c.sfRectangleShape_setOutlineColor(self._ptr, color._toCSFML());
}

/// Gets the outline thickness of this rectangle shape
pub fn getOutlineThickness(self: RectangleShape) f32 {
    return sf.c.sfRectangleShape_getOutlineThickness(self._ptr);
}
/// Sets the outline thickness of this rectangle shape
pub fn setOutlineThickness(self: *RectangleShape, thickness: f32) void {
    sf.c.sfRectangleShape_setOutlineThickness(self._ptr, thickness);
}

/// Gets the size of this rectangle shape
pub fn getSize(self: RectangleShape) sf.Vector2f {
    return sf.Vector2f._fromCSFML(sf.c.sfRectangleShape_getSize(self._ptr));
}
/// Sets the size of this rectangle shape
pub fn setSize(self: *RectangleShape, size: sf.Vector2f) void {
    sf.c.sfRectangleShape_setSize(self._ptr, size._toCSFML());
}

/// Gets the position of this rectangle shape
pub fn getPosition(self: RectangleShape) sf.Vector2f {
    return sf.Vector2f._fromCSFML(sf.c.sfRectangleShape_getPosition(self._ptr));
}
/// Sets the position of this rectangle shape
pub fn setPosition(self: *RectangleShape, pos: sf.Vector2f) void {
    sf.c.sfRectangleShape_setPosition(self._ptr, pos._toCSFML());
}
/// Adds the offset to this shape's position
pub fn move(self: *RectangleShape, offset: sf.Vector2f) void {
    sf.c.sfRectangleShape_move(self._ptr, offset._toCSFML());
}

/// Gets the origin of this rectangle shape
pub fn getOrigin(self: RectangleShape) sf.Vector2f {
    return sf.Vector2f._fromCSFML(sf.c.sfRectangleShape_getOrigin(self._ptr));
}
/// Sets the origin of this rectangle shape
pub fn setOrigin(self: *RectangleShape, origin: sf.Vector2f) void {
    sf.c.sfRectangleShape_setOrigin(self._ptr, origin._toCSFML());
}

/// Gets the rotation of this rectangle shape
pub fn getRotation(self: RectangleShape) f32 {
    return sf.c.sfRectangleShape_getRotation(self._ptr);
}
/// Sets the rotation of this rectangle shape
pub fn setRotation(self: *RectangleShape, angle: f32) void {
    sf.c.sfRectangleShape_setRotation(self._ptr, angle);
}
/// Rotates this shape by a given amount
pub fn rotate(self: *RectangleShape, angle: f32) void {
    sf.c.sfRectangleShape_rotate(self._ptr, angle);
}

/// Gets the texture of this shape
pub fn getTexture(self: RectangleShape) ?sf.Texture {
    const t = sf.c.sfRectangleShape_getTexture(self._ptr);
    if (t) |tex| {
        return sf.Texture{ ._const_ptr = tex };
    } else return null;
}
/// Sets the texture of this shape
pub fn setTexture(self: *RectangleShape, texture: ?sf.Texture) void {
    var tex = if (texture) |t| t._get() else null;
    sf.c.sfRectangleShape_setTexture(self._ptr, tex, 0);
}
/// Gets the sub-rectangle of the texture that the shape will display
pub fn getTextureRect(self: RectangleShape) sf.IntRect {
    return sf.IntRect._fromCSFML(sf.c.sfRectangleShape_getTextureRect(self._ptr));
}
/// Sets the sub-rectangle of the texture that the shape will display
pub fn setTextureRect(self: *RectangleShape, rect: sf.IntRect) void {
    sf.c.sfRectangleShape_getTextureRect(self._ptr, rect._toCSFML());
}

/// Gets the bounds in the local coordinates system
pub fn getLocalBounds(self: RectangleShape) sf.FloatRect {
    return sf.FloatRect._fromCSFML(sf.c.sfRectangleShape_getLocalBounds(self._ptr));
}

/// Gets the bounds in the global coordinates
pub fn getGlobalBounds(self: RectangleShape) sf.FloatRect {
    return sf.FloatRect._fromCSFML(sf.c.sfRectangleShape_getGlobalBounds(self._ptr));
}

/// Pointer to the csfml structure
_ptr: *sf.c.sfRectangleShape,

test "rectangle shape: sane getters and setters" {
    const tst = @import("std").testing;

    var rect = try RectangleShape.create(sf.Vector2f{ .x = 30, .y = 50 });
    defer rect.destroy();

    try tst.expectEqual(sf.Vector2f{ .x = 30, .y = 50 }, rect.getSize());

    rect.setFillColor(sf.Color.Yellow);
    rect.setOutlineColor(sf.Color.Red);
    rect.setOutlineThickness(3);
    rect.setSize(.{ .x = 15, .y = 510 });
    rect.setRotation(15);
    rect.setPosition(.{ .x = 1, .y = 2 });
    rect.setOrigin(.{ .x = 20, .y = 25 });
    rect.setTexture(null); //Weirdly, getTexture if texture wasn't set gives a wrong pointer

    try tst.expectEqual(sf.Color.Yellow, rect.getFillColor());
    try tst.expectEqual(sf.Color.Red, rect.getOutlineColor());
    try tst.expectEqual(@as(f32, 3), rect.getOutlineThickness());
    try tst.expectEqual(sf.Vector2f{ .x = 15, .y = 510 }, rect.getSize());
    try tst.expectEqual(@as(f32, 15), rect.getRotation());
    try tst.expectEqual(sf.Vector2f{ .x = 1, .y = 2 }, rect.getPosition());
    try tst.expectEqual(sf.Vector2f{ .x = 20, .y = 25 }, rect.getOrigin());
    try tst.expectEqual(@as(?sf.Texture, null), rect.getTexture());

    rect.rotate(5);
    rect.move(.{ .x = -5, .y = 5 });

    try tst.expectEqual(@as(f32, 20), rect.getRotation());
    try tst.expectEqual(sf.Vector2f{ .x = -4, .y = 7 }, rect.getPosition());

    _ = rect.getGlobalBounds();
    _ = rect.getLocalBounds();
    _ = rect.getTextureRect();
}