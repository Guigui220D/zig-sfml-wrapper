const sf = @import("../sfml.zig").system;

pub const FVec2 = sf.Vector2(f32);
pub const FVec3 = sf.Vector3(f32);
pub const FVec4 = sf.Vector4(f32);

pub const IVec2 = sf.Vector2(c_int);
pub const IVec3 = sf.Vector3(c_int);
pub const IVec4 = sf.Vector4(c_int);

pub const BVec2 = sf.Vector2(bool);
pub const BVec3 = sf.Vector3(bool);
pub const BVec4 = sf.Vector4(bool);

pub const Mat3 = [3 * 3]f32;
pub const Mat4 = [4 * 4]f32;
