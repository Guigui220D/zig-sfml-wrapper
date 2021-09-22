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
    sf.c.sfRectangleShape_setSize(rect, size.toCSFML());

    return RectangleShape{ .ptr = rect.? };
}

/// Destroys a rectangle shape
pub fn destroy(self: RectangleShape) void {
    sf.c.sfRectangleShape_destroy(self.ptr);
}

// Draw function
pub fn sfDraw(self: RectangleShape, window: sf.RenderWindow, states: ?*sf.c.sfRenderStates) void {
    sf.c.sfRenderWindow_drawRectangleShape(window.ptr, self.ptr, states);
}

// Getters/setters

/// Gets the fill color of this rectangle shape
pub fn getFillColor(self: RectangleShape) sf.Color {
    return sf.Color.fromCSFML(sf.c.sfRectangleShape_getFillColor(self.ptr));
}
/// Sets the fill color of this rectangle shape
pub fn setFillColor(self: RectangleShape, color: sf.Color) void {
    sf.c.sfRectangleShape_setFillColor(self.ptr, color.toCSFML());
}

/// Gets the outline color of this rectangle shape
pub fn getOutlineColor(self: RectangleShape) sf.Color {
    return sf.Color.fromCSFML(sf.c.sfRectangleShape_getOutlineColor(self.ptr));
}
/// Sets the outline color of this rectangle shape
pub fn setOutlineColor(self: RectangleShape, color: sf.Color) void {
    sf.c.sfRectangleShape_setOutlineColor(self.ptr, color.toCSFML());
}

/// Gets the outline thickness of this rectangle shape
pub fn getOutlineThickness(self: RectangleShape) f32 {
    return sf.c.sfRectangleShape_getOutlineThickness(self.ptr);
}
/// Sets the outline thickness of this rectangle shape
pub fn setOutlineThickness(self: RectangleShape, thickness: f32) void {
    sf.c.sfRectangleShape_setOutlineThickness(self.ptr, thickness);
}

/// Gets the size of this rectangle shape
pub fn getSize(self: RectangleShape) sf.Vector2f {
    return sf.Vector2f.fromCSFML(sf.c.sfRectangleShape_getSize(self.ptr));
}
/// Sets the size of this rectangle shape
pub fn setSize(self: RectangleShape, size: sf.Vector2f) void {
    sf.c.sfRectangleShape_setSize(self.ptr, size.toCSFML());
}

/// Gets the position of this rectangle shape
pub fn getPosition(self: RectangleShape) sf.Vector2f {
    return sf.Vector2f.fromCSFML(sf.c.sfRectangleShape_getPosition(self.ptr));
}
/// Sets the position of this rectangle shape
pub fn setPosition(self: RectangleShape, pos: sf.Vector2f) void {
    sf.c.sfRectangleShape_setPosition(self.ptr, pos.toCSFML());
}
/// Adds the offset to this shape's position
pub fn move(self: RectangleShape, offset: sf.Vector2f) void {
    sf.c.sfRectangleShape_move(self.ptr, offset.toCSFML());
}

/// Gets the origin of this rectangle shape
pub fn getOrigin(self: RectangleShape) sf.Vector2f {
    return sf.Vector2f.fromCSFML(sf.c.sfRectangleShape_getOrigin(self.ptr));
}
/// Sets the origin of this rectangle shape
pub fn setOrigin(self: RectangleShape, origin: sf.Vector2f) void {
    sf.c.sfRectangleShape_setOrigin(self.ptr, origin.toCSFML());
}

/// Gets the rotation of this rectangle shape
pub fn getRotation(self: RectangleShape) f32 {
    return sf.c.sfRectangleShape_getRotation(self.ptr);
}
/// Sets the rotation of this rectangle shape
pub fn setRotation(self: RectangleShape, angle: f32) void {
    sf.c.sfRectangleShape_setRotation(self.ptr, angle);
}
/// Rotates this shape by a given amount
pub fn rotate(self: RectangleShape, angle: f32) void {
    sf.c.sfRectangleShape_rotate(self.ptr, angle);
}

/// Gets the texture of this shape
pub fn getTexture(self: RectangleShape) ?sf.Texture {
    const t = sf.c.sfRectangleShape_getTexture(self.ptr);
    if (t) |tex| {
        return sf.Texture{ .const_ptr = tex };
    } else
        return null;
}
/// Sets the texture of this shape
pub fn setTexture(self: RectangleShape, texture: ?sf.Texture) void {
    var tex = if (texture) |t| t.get() else null;
    sf.c.sfRectangleShape_setTexture(self.ptr, tex, 0);
}
/// Gets the sub-rectangle of the texture that the shape will display
pub fn getTextureRect(self: RectangleShape) sf.FloatRect {
    return sf.FloatRect.fromCSFML(sf.c.sfRectangleShape_getTextureRect(self.ptr));
}
/// Sets the sub-rectangle of the texture that the shape will display
pub fn setTextureRect(self: RectangleShape, rect: sf.FloatRect) void {
    sf.c.sfRectangleShape_getTextureRect(self.ptr, rect.toCSFML());
}

/// Gets the bounds in the local coordinates system
pub fn getLocalBounds(self: RectangleShape) sf.FloatRect {
    return sf.FloatRect.fromCSFML(sf.c.sfRectangleShape_getLocalBounds(self.ptr));
}

/// Gets the bounds in the global coordinates
pub fn getGlobalBounds(self: RectangleShape) sf.FloatRect {
    return sf.FloatRect.fromCSFML(sf.c.sfRectangleShape_getGlobalBounds(self.ptr));
}

/// Pointer to the csfml structure
ptr: *sf.c.sfRectangleShape,

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
    rect.setTexture(null);  //Weirdly, getTexture if texture wasn't set gives a wrong pointer

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
}
