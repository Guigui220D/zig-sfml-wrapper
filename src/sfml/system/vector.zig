//! Utility struct for manipulating 2-dimensional vectors.

usingnamespace @import("../sfml_import.zig");

pub fn Vector2(comptime T: type) type {
    return struct {
        const Self = @This();

        /// The CSFML vector type equivalent
        const CsfmlEquivalent = switch (T) {
            u32 => Sf.sfVector2u,
            i32 => Sf.sfVector2i,
            f32 => Sf.sfVector2f,
            else => void,
        };

        /// Makes a CSFML vector with this vector (only if the corresponding type exists)
        /// This is mainly for the inner workings of this wrapper
        pub fn toCSFML(self: Self) CsfmlEquivalent {
            if (CsfmlEquivalent == void) @compileError("This vector type doesn't have a CSFML equivalent.");
            return CsfmlEquivalent{ .x = self.x, .y = self.y };
        }

        /// Creates a vector from a CSFML one (only if the corresponding type exists)
        /// This is mainly for the inner workings of this wrapper
        pub fn fromCSFML(vec: CsfmlEquivalent) Self {
            if (CsfmlEquivalent == void) @compileError("This vector type doesn't have a CSFML equivalent.");
            return Self{ .x = vec.x, .y = vec.y };
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
        pub fn scale(self: Self, factor: T) Self {
            return Self{ .x = self.x * factor, .y = self.y * factor };
        }

        /// x component of the vector
        x: T,
        /// y component of the vector
        y: T
    };
}

// Common vector types
pub const Vector2u = Vector2(u32);
pub const Vector2i = Vector2(i32);
pub const Vector2f = Vector2(f32);
