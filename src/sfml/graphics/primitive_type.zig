//! The type of primitives in a vertex array of buffer

pub const PrimitiveType = enum(c_uint) {
    Points,
    Lines,
    LineStrip,
    Triangles,
    TriangleStrip,
    TriangleFan,
    Quads,
};
