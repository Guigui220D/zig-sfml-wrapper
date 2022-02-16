const vector = @import("vector.zig");
pub const Vector2 = vector.Vector2;
pub const Vector3 = vector.Vector3;
pub const Vector4 = vector.Vector4;
pub const Vector2i = Vector2(c_int);
pub const vector2i = Vector2i.new;
pub const Vector2u = Vector2(c_uint);
pub const vector2u = Vector2u.new;
pub const Vector2f = Vector2(f32);
pub const vector2f = Vector2f.new;
pub const Vector3f = Vector3(f32);
pub const vector3f = Vector3f.new;

pub const Time = @import("Time.zig");
pub const Clock = @import("Clock.zig");
