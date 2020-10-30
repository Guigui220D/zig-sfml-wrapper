usingnamespace @import("../sfml_import.zig");

pub fn Vector2(comptime T: type) type {
    return struct {
        const Self = @This();

        const CsfmlEquivalent = switch (T) {
            u32 => Sf.sfVector2u,
            i32 => Sf.sfVector2i,
            f32 => Sf.sfVector2f,
            else => void
        };

        pub fn toCSFML(self: Self) CsfmlEquivalent {
            return CsfmlEquivalent{.x = self.x, .y = self.y};
        }

        pub fn fromCSFML(vec: CsfmlEquivalent) Self {
            return Self{.x = vec.x, .y = vec.y};
        }

        x: T,
        y: T
    };
}

pub const Vector2u = Vector2(u32);
pub const Vector2i = Vector2(i32);
pub const Vector2f = Vector2(f32);