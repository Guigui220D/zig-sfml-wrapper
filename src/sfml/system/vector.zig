//! Utility struct for manipulating 2-dimensional vectors.

const sf = @import("../sfml_import.zig");

/// Template for a 2 dimensional vector
pub fn Vector2(comptime T: type) type {
    return packed struct {
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

        /// Makes a CSFML vector with this vector (only if the corresponding type exists)
        /// This is mainly for the inner workings of this wrapper
        pub fn _toCSFML(self: Self) CsfmlEquivalent {
            if (CsfmlEquivalent == void) @compileError("This vector type doesn't have a CSFML equivalent.");
            return @bitCast(CsfmlEquivalent, self);
        }

        /// Creates a vector from a CSFML one (only if the corresponding type exists)
        /// This is mainly for the inner workings of this wrapper
        pub fn _fromCSFML(vec: CsfmlEquivalent) Self {
            if (CsfmlEquivalent == void) @compileError("This vector type doesn't have a CSFML equivalent.");
            return @bitCast(Self, vec);
        }

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

        /// x component of the vector
        x: T = 0,
        /// y component of the vector
        y: T = 0,
    };
}

/// Template for a 3 dimensional vector
pub fn Vector3(comptime T: type) type {
    return packed struct {
        const Self = @This();

        pub fn new(x: T, y: T, z: T) Self {
            return .{ .x = x, .y = y, .z = z };
        }

        /// Makes a CSFML vector with this vector (only if the corresponding type exists)
        /// This is mainly for the inner workings of this wrapper
        pub fn _toCSFML(self: Self) sf.c.sfVector3f {
            if (T != f32) @compileError("This vector type doesn't have a CSFML equivalent.");
            return @bitCast(sf.c.sfVector3f, self);
        }

        /// Creates a vector from a CSFML one (only if the corresponding type exists)
        /// This is mainly for the inner workings of this wrapper
        pub fn _fromCSFML(vec: sf.c.sfVector3f) Self {
            if (T != f32) @compileError("This vector type doesn't have a CSFML equivalent.");
            return @bitCast(Self, vec);
        }

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

        /// x component of the vector
        x: T = 0,
        /// y component of the vector
        y: T = 0,
        /// z component of the vector
        z: T = 0,
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
        x: T = 0,
        /// y component of the vector
        y: T = 0,
        /// z component of the vector
        z: T = 0,
        /// w component of the vector
        w: T = 0,
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
