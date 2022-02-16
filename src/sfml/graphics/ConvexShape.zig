//! Specialized shape representing a convex polygon

const assert = @import("std").debug.assert;
const sf = struct {
    pub usingnamespace @import("../sfml.zig");
    pub usingnamespace sf.system;
    pub usingnamespace sf.graphics;
};

const ConvexShape = @This();

// Constructor/destructor

/// Creates a new empty convex shape
pub fn create() !ConvexShape {
    var shape = sf.c.sfConvexShape_create();
    if (shape == null)
        return sf.Error.nullptrUnknownReason;

    return ConvexShape{ ._ptr = shape.? };
}

/// Destroys a convex shape
pub fn destroy(self: *ConvexShape) void {
    sf.c.sfConvexShape_destroy(self._ptr);
    self._ptr = undefined;
}

// Draw function

/// The draw function of this shape
/// Meant to be called by your_target.draw(your_shape, .{});
pub fn sfDraw(self: ConvexShape, target: anytype, states: ?*sf.c.sfRenderStates) void {
    switch (@TypeOf(target)) {
        sf.RenderWindow => sf.c.sfRenderWindow_drawConvexShape(target._ptr, self._ptr, states),
        sf.RenderTexture => sf.c.sfRenderTexture_drawConvexShape(target._ptr, self._ptr, states),
        else => @compileError("target must be a render target"),
    }
}

// Getters/setters

/// Gets how many points this convex polygon shape has
pub fn getPointCount(self: ConvexShape) usize {
    return sf.c.sfConvexShape_getPointCount(self._ptr);
}
/// Sets how many points this convex polygon shape has
/// Must be greater than 2 to get a valid shape
pub fn setPointCount(self: *ConvexShape, count: usize) void {
    sf.c.sfConvexShape_setPointCount(self._ptr, count);
}
/// Gets a point using its index (asserts the index is within range)
pub fn getPoint(self: ConvexShape, index: usize) sf.Vector2f {
    assert(index < self.getPointCount());
    return sf.Vector2f._fromCSFML(sf.c.sfConvexShape_getPoint(self._ptr, index));
}
/// Sets a point using its index (asserts the index is within range)
/// setPointCount must be called first
/// Shape must remain convex and the points have to be ordered!
pub fn setPoint(self: *ConvexShape, index: usize, point: sf.Vector2f) void {
    assert(index < self.getPointCount());
    sf.c.sfConvexShape_setPoint(self._ptr, index, point._toCSFML());
}

/// Gets the fill color of this convex shape
pub fn getFillColor(self: ConvexShape) sf.Color {
    return sf.Color._fromCSFML(sf.c.sfConvexShape_getFillColor(self._ptr));
}
/// Sets the fill color of this convex shape
pub fn setFillColor(self: *ConvexShape, color: sf.Color) void {
    sf.c.sfConvexShape_setFillColor(self._ptr, color._toCSFML());
}

/// Gets the outline color of this convex shape
pub fn getOutlineColor(self: ConvexShape) sf.Color {
    return sf.Color._fromCSFML(sf.c.sfConvexShape_getOutlineColor(self._ptr));
}
/// Sets the outline color of this convex shape
pub fn setOutlineColor(self: *ConvexShape, color: sf.Color) void {
    sf.c.sfConvexShape_setOutlineColor(self._ptr, color._toCSFML());
}

/// Gets the outline thickness of this convex shape
pub fn getOutlineThickness(self: ConvexShape) f32 {
    return sf.c.sfConvexShape_getOutlineThickness(self._ptr);
}
/// Sets the outline thickness of this convex shape
pub fn setOutlineThickness(self: *ConvexShape, thickness: f32) void {
    sf.c.sfConvexShape_setOutlineThickness(self._ptr, thickness);
}

/// Gets the position of this convex shape
pub fn getPosition(self: ConvexShape) sf.Vector2f {
    return sf.Vector2f._fromCSFML(sf.c.sfConvexShape_getPosition(self._ptr));
}
/// Sets the position of this convex shape
pub fn setPosition(self: *ConvexShape, pos: sf.Vector2f) void {
    sf.c.sfConvexShape_setPosition(self._ptr, pos._toCSFML());
}
/// Adds the offset to this shape's position
pub fn move(self: *ConvexShape, offset: sf.Vector2f) void {
    sf.c.sfConvexShape_move(self._ptr, offset._toCSFML());
}

/// Gets the origin of this convex shape
pub fn getOrigin(self: ConvexShape) sf.Vector2f {
    return sf.Vector2f._fromCSFML(sf.c.sfConvexShape_getOrigin(self._ptr));
}
/// Sets the origin of this convex shape
pub fn setOrigin(self: *ConvexShape, origin: sf.Vector2f) void {
    sf.c.sfConvexShape_setOrigin(self._ptr, origin._toCSFML());
}

/// Gets the rotation of this convex shape
pub fn getRotation(self: ConvexShape) f32 {
    return sf.c.sfConvexShape_getRotation(self._ptr);
}
/// Sets the rotation of this convex shape
pub fn setRotation(self: *ConvexShape, angle: f32) void {
    sf.c.sfConvexShape_setRotation(self._ptr, angle);
}
/// Rotates this shape by a given amount
pub fn rotate(self: *ConvexShape, angle: f32) void {
    sf.c.sfConvexShape_rotate(self._ptr, angle);
}

/// Gets the texture of this shape
pub fn getTexture(self: ConvexShape) ?sf.Texture {
    const t = sf.c.sfConvexShape_getTexture(self._ptr);
    if (t) |tex| {
        return sf.Texture{ ._const_ptr = tex };
    } else return null;
}
/// Sets the texture of this shape
pub fn setTexture(self: *ConvexShape, texture: ?sf.Texture) void {
    var tex = if (texture) |t| t._get() else null;
    sf.c.sfConvexShape_setTexture(self._ptr, tex, 0);
}
/// Gets the sub-shapeangle of the texture that the shape will display
pub fn getTextureRect(self: ConvexShape) sf.IntRect {
    return sf.IntRect._fromCSFML(sf.c.sfConvexShape_getTextureRect(self._ptr));
}
/// Sets the sub-shapeangle of the texture that the shape will display
pub fn setTextureRect(self: *ConvexShape, shape: sf.IntRect) void {
    sf.c.sfConvexShape_getTextureRect(self._ptr, shape._toCSFML());
}

/// Gets the bounds in the local coordinates system
pub fn getLocalBounds(self: ConvexShape) sf.FloatRect {
    return sf.FloatRect._fromCSFML(sf.c.sfConvexShape_getLocalBounds(self._ptr));
}

/// Gets the bounds in the global coordinates
pub fn getGlobalBounds(self: ConvexShape) sf.FloatRect {
    return sf.FloatRect._fromCSFML(sf.c.sfConvexShape_getGlobalBounds(self._ptr));
}

/// Pointer to the csfml structure
_ptr: *sf.c.sfConvexShape,

test "convex shape: sane getters and setters" {
    const tst = @import("std").testing;

    var shape = try ConvexShape.create();
    defer shape.destroy();

    shape.setPointCount(3);
    shape.setPoint(0, .{ .x = 0, .y = 0 });
    shape.setPoint(1, .{ .x = 1, .y = 1 });
    shape.setPoint(2, .{ .x = -1, .y = 1 });

    try tst.expectEqual(@as(usize, 3), shape.getPointCount());
    // TODO: find out why that doesn't work
    //try tst.expectEqual(sf.Vector2f{ .x = 1, .y = 1 }, shape.getPoint(1));
    _ = shape.getPoint(0); 

    shape.setFillColor(sf.Color.Yellow);
    shape.setOutlineColor(sf.Color.Red);
    shape.setOutlineThickness(3);
    shape.setRotation(15);
    shape.setPosition(.{ .x = 1, .y = 2 });
    shape.setOrigin(.{ .x = 20, .y = 25 });
    shape.setTexture(null); //Weirdly, getTexture if texture wasn't set gives a wrong pointer

    try tst.expectEqual(sf.Color.Yellow, shape.getFillColor());
    try tst.expectEqual(sf.Color.Red, shape.getOutlineColor());
    try tst.expectEqual(@as(f32, 3), shape.getOutlineThickness());
    try tst.expectEqual(@as(f32, 15), shape.getRotation());
    try tst.expectEqual(sf.Vector2f{ .x = 1, .y = 2 }, shape.getPosition());
    try tst.expectEqual(sf.Vector2f{ .x = 20, .y = 25 }, shape.getOrigin());
    try tst.expectEqual(@as(?sf.Texture, null), shape.getTexture());

    shape.rotate(5);
    shape.move(.{ .x = -5, .y = 5 });

    try tst.expectEqual(@as(f32, 20), shape.getRotation());
    try tst.expectEqual(sf.Vector2f{ .x = -4, .y = 7 }, shape.getPosition());

    _ = shape.getTextureRect();
    _ = shape.getGlobalBounds();
    _ = shape.getLocalBounds();
}