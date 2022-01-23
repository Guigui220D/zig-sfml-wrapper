const vector = @import("vector.zig");
pub const Vector2 = vector.Vector2;
pub const Vector3 = vector.Vector3;
pub const Vector4 = vector.Vector4;
pub const Vector2i = Vector2(c_int);
pub const Vector2u = Vector2(c_uint);
pub const Vector2f = Vector2(f32);
pub const Vector3f = Vector3(f32);

pub const Time = @import("Time.zig");
pub const Clock = @import("Clock.zig");
