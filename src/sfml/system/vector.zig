//! Utility struct for manipulating 2-dimensional vectors.

const sf = @import("../sfml_import.zig");

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

        /// Makes a CSFML vector with this vector (only if the corresponding type exists)
        /// This is mainly for the inner workings of this wrapper
        pub fn toCSFML(self: Self) CsfmlEquivalent {
            if (CsfmlEquivalent == void) @compileError("This vector type doesn't have a CSFML equivalent.");
            return @bitCast(CsfmlEquivalent, self);
        }

        /// Creates a vector from a CSFML one (only if the corresponding type exists)
        /// This is mainly for the inner workings of this wrapper
        pub fn fromCSFML(vec: CsfmlEquivalent) Self {
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
        x: T,
        /// y component of the vector
        y: T
    };
}

pub const Vector3f = struct {
    const Self = @This();

    /// Makes a CSFML vector with this vector (only if the corresponding type exists)
    /// This is mainly for the inner workings of this wrapper
    pub fn toCSFML(self: Self) sf.c.sfVector3f {
        return @bitCast(sf.c.sfVector3f, self);
    }

    /// Creates a vector from a CSFML one (only if the corresponding type exists)
    /// This is mainly for the inner workings of this wrapper
    pub fn fromCSFML(vec: sf.c.sfVector3f) Self {
        return @bitCast(Self, vec);
    }

    /// x component of the vector
    x: f32,
    /// y component of the vector
    y: f32,
    /// z component of the vector
    z: f32,
};

test "vector: sane from/to CSFML vectors" {
    const tst = @import("std").testing;

    inline for ([_]type{ c_int, c_uint, f32 }) |T| {
        const VecT = Vector2(T);
        const vec = VecT{ .x = 1, .y = 3 };
        const cvec = vec.toCSFML();
    
        tst.expectEqual(vec.x, cvec.x);
        tst.expectEqual(vec.y, cvec.y);

        const vec2 = VecT.fromCSFML(cvec);

        tst.expectEqual(vec, vec2);
    }

    {
        const vec = Vector3f{ .x = 1, .y = 3.5, .z = -12 };
        const cvec = vec.toCSFML();

        tst.expectEqual(vec.x, cvec.x);
        tst.expectEqual(vec.y, cvec.y);
        tst.expectEqual(vec.z, cvec.z);

        const vec2 = Vector3f.fromCSFML(cvec);

        tst.expectEqual(vec, vec2);
    }
}


