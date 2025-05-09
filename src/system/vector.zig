//! Utility struct for manipulating 2-dimensional vectors.

const std = @import("std");
const sf = @import("../root.zig");

fn isNum(comptime T: type) bool {
    return switch (@typeInfo(T)) {
        .int, .float, .comptime_float, .comptime_int => true,
        else => false,
    };
}

/// Template for a 2 dimensional vector
pub fn Vector2(comptime T: type) type {
    return extern struct {
        const Self = @This();

        /// The CSFML vector type equivalent
        const CsfmlEquivalent = switch (T) {
            c_uint => sf.c.sfVector2u,
            c_int => sf.c.sfVector2i,
            f32 => sf.c.sfVector2f,
            else => void,
        };

        pub fn new(x: T, y: T) Self {
            return .{ .x = x, .y = y };
        }

        pub usingnamespace if (CsfmlEquivalent != void) struct {
            /// Makes a CSFML vector with this vector (only if the corresponding type exists)
            /// This is mainly for the inner workings of this wrapper
            pub fn _toCSFML(self: Self) CsfmlEquivalent {
                if (CsfmlEquivalent == void) @compileError("This vector type doesn't have a CSFML equivalent.");
                return @as(CsfmlEquivalent, @bitCast(self));
            }

            /// Creates a vector from a CSFML one (only if the corresponding type exists)
            /// This is mainly for the inner workings of this wrapper
            pub fn _fromCSFML(vec: CsfmlEquivalent) Self {
                if (CsfmlEquivalent == void) @compileError("This vector type doesn't have a CSFML equivalent.");
                return @as(Self, @bitCast(vec));
            }
        } else struct {};

        pub usingnamespace if (isNum(T)) struct {
            /// Adds two vectors
            pub fn add(self: Self, other: Self) Self {
                return Self{ .x = self.x + other.x, .y = self.y + other.y };
            }

            /// Substracts two vectors
            pub fn substract(self: Self, other: Self) Self {
                return Self{ .x = self.x - other.x, .y = self.y - other.y };
            }

            /// Scales a vector
            pub fn scale(self: Self, scalar: T) Self {
                return Self{ .x = self.x * scalar, .y = self.y * scalar };
            }
        } else struct {};

        /// x component of the vector
        x: T,
        /// y component of the vector
        y: T,
    };
}

/// Template for a 3 dimensional vector
pub fn Vector3(comptime T: type) type {
    return packed struct {
        const Self = @This();

        pub fn new(x: T, y: T, z: T) Self {
            return .{ .x = x, .y = y, .z = z };
        }

        pub usingnamespace if (T == f32) struct {
            /// Makes a CSFML vector with this vector (only if the corresponding type exists)
            /// This is mainly for the inner workings of this wrapper
            pub fn _toCSFML(self: Self) sf.c.sfVector3f {
                if (T != f32) @compileError("This vector type doesn't have a CSFML equivalent.");
                return @as(sf.c.sfVector3f, @bitCast(self));
            }

            /// Creates a vector from a CSFML one (only if the corresponding type exists)
            /// This is mainly for the inner workings of this wrapper
            pub fn _fromCSFML(vec: sf.c.sfVector3f) Self {
                if (T != f32) @compileError("This vector type doesn't have a CSFML equivalent.");
                return @as(Self, @bitCast(vec));
            }
        } else struct {};

        pub usingnamespace if (isNum(T)) struct {
            /// Adds two vectors
            pub fn add(self: Self, other: Self) Self {
                return Self{ .x = self.x + other.x, .y = self.y + other.y, .z = self.z + other.z };
            }

            /// Substracts two vectors
            pub fn substract(self: Self, other: Self) Self {
                return Self{ .x = self.x - other.x, .y = self.y - other.y, .z = self.z - other.z };
            }

            /// Scales a vector
            pub fn scale(self: Self, scalar: T) Self {
                return Self{ .x = self.x * scalar, .y = self.y * scalar, .z = self.z * scalar };
            }
        } else struct {};

        /// x component of the vector
        x: T,
        /// y component of the vector
        y: T,
        /// z component of the vector
        z: T,
    };
}

/// Template for a 4 dimensional vector
/// SFML doesn't really have this but as shaders use such vectors it can be here anyways
pub fn Vector4(comptime T: type) type {
    return packed struct {
        const Self = @This();

        pub fn new(x: T, y: T, z: T, w: T) Self {
            return .{ .x = x, .y = y, .z = z, .w = w };
        }

        /// x component of the vector
        x: T,
        /// y component of the vector
        y: T,
        /// z component of the vector
        z: T,
        /// w component of the vector
        w: T,
    };
}

test "vector: sane from/to CSFML vectors" {
    const tst = @import("std").testing;

    inline for ([_]type{ c_int, c_uint, f32 }) |T| {
        const VecT = Vector2(T);
        const vec = VecT{ .x = 1, .y = 3 };
        const cvec = vec._toCSFML();

        try tst.expectEqual(vec.x, cvec.x);
        try tst.expectEqual(vec.y, cvec.y);

        const vec2 = VecT._fromCSFML(cvec);

        try tst.expectEqual(vec, vec2);
    }

    {
        const vec = Vector3(f32){ .x = 1, .y = 3.5, .z = -12 };
        const cvec = vec._toCSFML();

        try tst.expectEqual(vec.x, cvec.x);
        try tst.expectEqual(vec.y, cvec.y);
        try tst.expectEqual(vec.z, cvec.z);

        const vec2 = Vector3(f32)._fromCSFML(cvec);

        try tst.expectEqual(vec, vec2);
    }
}
