//! Specialized shape representing a circle.

const sf = struct {
    pub usingnamespace @import("../sfml.zig");
    pub usingnamespace sf.system;
    pub usingnamespace sf.graphics;
};

const CircleShape = @This();

// Constructor/destructor

/// Inits a circle shape with a radius. The circle will be white and have 30 points
pub fn create(radius: f32) !CircleShape {
    var circle = sf.c.sfCircleShape_create();
    if (circle == null)
        return sf.Error.nullptrUnknownReason;

    sf.c.sfCircleShape_setFillColor(circle, sf.c.sfWhite);
    sf.c.sfCircleShape_setRadius(circle, radius);

    return CircleShape{ ._ptr = circle.? };
}

/// Destroys a circle shape
pub fn destroy(self: *CircleShape) void {
    sf.c.sfCircleShape_destroy(self._ptr);
    self._ptr = undefined;
}

// Draw function

/// The draw function of this shape
/// Meant to be called by your_target.draw(your_shape, .{});
pub fn sfDraw(self: CircleShape, target: anytype, states: ?*sf.c.sfRenderStates) void {
    switch (@TypeOf(target)) {
        sf.RenderWindow => sf.c.sfRenderWindow_drawCircleShape(target._ptr, self._ptr, states),
        sf.RenderTexture => sf.c.sfRenderTexture_drawCircleShape(target._ptr, self._ptr, states),
        else => @compileError("target must be a render target"),
    }
}

// Getters/setters

/// Gets the fill color of this circle shape
pub fn getFillColor(self: CircleShape) sf.Color {
    return sf.Color._fromCSFML(sf.c.sfCircleShape_getFillColor(self._ptr));
}
/// Sets the fill color of this circle shape
pub fn setFillColor(self: *CircleShape, color: sf.Color) void {
    sf.c.sfCircleShape_setFillColor(self._ptr, color._toCSFML());
}

/// Gets the outline color of this circle shape
pub fn getOutlineColor(self: CircleShape) sf.Color {
    return sf.Color._fromCSFML(sf.c.sfCircleShape_getOutlineColor(self._ptr));
}
/// Sets the outline color of this circle shape
pub fn setOutlineColor(self: *CircleShape, color: sf.Color) void {
    sf.c.sfCircleShape_setOutlineColor(self._ptr, color._toCSFML());
}

/// Gets the outline thickness of this circle shape
pub fn getOutlineThickness(self: CircleShape) f32 {
    return sf.c.sfCircleShape_getOutlineThickness(self._ptr);
}
/// Sets the outline thickness of this circle shape
pub fn setOutlineThickness(self: *CircleShape, thickness: f32) void {
    sf.c.sfCircleShape_setOutlineThickness(self._ptr, thickness);
}

/// Gets the radius of this circle shape
pub fn getRadius(self: CircleShape) f32 {
    return sf.c.sfCircleShape_getRadius(self._ptr);
}
/// Sets the radius of this circle shape
pub fn setRadius(self: *CircleShape, radius: f32) void {
    sf.c.sfCircleShape_setRadius(self._ptr, radius);
}

/// Gets the position of this circle shape
pub fn getPosition(self: CircleShape) sf.Vector2f {
    return sf.Vector2f._fromCSFML(sf.c.sfCircleShape_getPosition(self._ptr));
}
/// Sets the position of this circle shape
pub fn setPosition(self: *CircleShape, pos: sf.Vector2f) void {
    sf.c.sfCircleShape_setPosition(self._ptr, pos._toCSFML());
}
/// Adds the offset to this shape's position
pub fn move(self: *CircleShape, offset: sf.Vector2f) void {
    sf.c.sfCircleShape_move(self._ptr, offset._toCSFML());
}

/// Gets the origin of this circle shape
pub fn getOrigin(self: CircleShape) sf.Vector2f {
    return sf.Vector2f._fromCSFML(sf.c.sfCircleShape_getOrigin(self._ptr));
}
/// Sets the origin of this circle shape
pub fn setOrigin(self: *CircleShape, origin: sf.Vector2f) void {
    sf.c.sfCircleShape_setOrigin(self._ptr, origin._toCSFML());
}

/// Gets the rotation of this circle shape
pub fn getRotation(self: CircleShape) f32 {
    return sf.c.sfCircleShape_getRotation(self._ptr);
}
/// Sets the rotation of this circle shape
pub fn setRotation(self: *CircleShape, angle: f32) void {
    sf.c.sfCircleShape_setRotation(self._ptr, angle);
}
/// Rotates this shape by a given amount
pub fn rotate(self: *CircleShape, angle: f32) void {
    sf.c.sfCircleShape_rotate(self._ptr, angle);
}

/// Gets the texture of this shape
pub fn getTexture(self: CircleShape) ?sf.Texture {
    const t = sf.c.sfCircleShape_getTexture(self._ptr);
    if (t) |tex| {
        return sf.Texture{ ._const_ptr = tex };
    } else return null;
}
/// Sets the texture of this shape
pub fn setTexture(self: *CircleShape, texture: ?sf.Texture) void {
    var tex = if (texture) |t| t._get() else null;
    sf.c.sfCircleShape_setTexture(self._ptr, tex, 0);
}
/// Gets the sub-rectangle of the texture that the shape will display
pub fn getTextureRect(self: CircleShape) sf.IntRect {
    return sf.IntRect._fromCSFML(sf.c.sfCircleShape_getTextureRect(self._ptr));
}
/// Sets the sub-rectangle of the texture that the shape will display
pub fn setTextureRect(self: *CircleShape, rect: sf.IntRect) void {
    sf.c.sfCircleShape_getCircleRect(self._ptr, rect._toCSFML());
}

/// Gets the bounds in the local coordinates system
pub fn getLocalBounds(self: CircleShape) sf.FloatRect {
    return sf.FloatRect._fromCSFML(sf.c.sfCircleShape_getLocalBounds(self._ptr));
}

/// Gets the bounds in the global coordinates
pub fn getGlobalBounds(self: CircleShape) sf.FloatRect {
    return sf.FloatRect._fromCSFML(sf.c.sfCircleShape_getGlobalBounds(self._ptr));
}

/// Pointer to the csfml structure
_ptr: *sf.c.sfCircleShape,

test "circle shape: sane getters and setters" {
    const tst = @import("std").testing;

    var circle = try CircleShape.create(30);
    defer circle.destroy();

    circle.setFillColor(sf.Color.Yellow);
    circle.setOutlineColor(sf.Color.Red);
    circle.setOutlineThickness(3);
    circle.setRadius(50);
    circle.setRotation(15);
    circle.setPosition(.{ .x = 1, .y = 2 });
    circle.setOrigin(.{ .x = 20, .y = 25 });
    circle.setTexture(null);

    try tst.expectEqual(sf.Color.Yellow, circle.getFillColor());
    try tst.expectEqual(sf.Color.Red, circle.getOutlineColor());
    try tst.expectEqual(@as(f32, 3), circle.getOutlineThickness());
    try tst.expectEqual(@as(f32, 50), circle.getRadius());
    try tst.expectEqual(@as(f32, 15), circle.getRotation());
    try tst.expectEqual(sf.Vector2f{ .x = 1, .y = 2 }, circle.getPosition());
    try tst.expectEqual(sf.Vector2f{ .x = 20, .y = 25 }, circle.getOrigin());
    try tst.expectEqual(@as(?sf.Texture, null), circle.getTexture());

    circle.rotate(5);
    circle.move(.{ .x = -5, .y = 5 });

    try tst.expectEqual(@as(f32, 20), circle.getRotation());
    try tst.expectEqual(sf.Vector2f{ .x = -4, .y = 7 }, circle.getPosition());

    _ = circle.getGlobalBounds();
    _ = circle.getLocalBounds();
    _ = circle.getTextureRect();
}
