//! Define a 3x3 transformation matrix

const sf = @import("../sfml.zig");

const Transform = @This();

/// Identity matrix (doesn't do anything)
pub const Identity = Transform{ .matrix = .{ 1, 0, 0, 0, 1, 0, 0, 0, 1 } };

/// Converts this transform to a csfml one
/// For inner workings
pub fn _toCSFML(self: Transform) sf.c.sfTransform {
    return @bitCast(sf.c.sfTransform, self);
}
/// Converts a transform from a csfml object
/// For inner workings
pub fn _fromCSFML(transform: sf.c.sfTransform) Transform {
    return @bitCast(Transform, transform);
}

// Matrix transformations
/// Transforms a point by this matrix
pub fn transformPoint(self: Transform, point: sf.system.Vector2f) sf.system.Vector2f {
    const ptr = @ptrCast(*const sf.c.sfTransform, &self);
    return sf.system.Vector2f._fromCSFML(sf.c.sfTransform_transformPoint(ptr, point._toCSFML()));
}
/// Transforms a rectangle by this matrix
pub fn transformRect(self: Transform, rect: sf.graphics.FloatRect) sf.graphics.FloatRect {
    const ptr = @ptrCast(*const sf.c.sfTransform, &self);
    return sf.system.Vector2f._fromCSFML(sf.c.sfTransform_transformRect(ptr, rect._toCSFML()));
}

// Operations

/// Gets the inverse of this transformation
/// Returns the identity if it can't be calculated
pub fn getInverse(self: Transform) Transform {
    const ptr = @ptrCast(*const sf.c.sfTransform, &self);
    return _fromCSFML(sf.c.sfTransform_getInverse(ptr));
}
/// Combines two transformations
pub fn combine(self: Transform, other: Transform) Transform {
    const ptr = @ptrCast(*const sf.c.sfTransform, &self);
    return _fromCSFML(sf.c.sfTransform_combine(ptr, other._toCSFML(other)));
}

/// Translates this transform by x and y
pub fn translate(self: *Transform, translation: sf.system.Vector2f) void {
    const ptr = @ptrCast(*sf.c.sfTransform, self);
    sf.c.sfTransform_translate(ptr, translation.x, translation.y);
}
/// Rotates this transform
pub fn rotate(self: *Transform, angle: f32) void {
    const ptr = @ptrCast(*sf.c.sfTransform, self);
    sf.c.sfTransform_rotate(ptr, angle);
}
/// Scales this transform
pub fn scale(self: *Transform, factor: sf.system.Vector2f) void {
    const ptr = @ptrCast(*sf.c.sfTransform, self);
    sf.c.sfTransform_scale(ptr, factor.x, factor.y);
}

/// Transform comparison
pub const equal = @compileError("Use std.mem.eql instead");

/// The matrix defining this transform
matrix: [9]f32
