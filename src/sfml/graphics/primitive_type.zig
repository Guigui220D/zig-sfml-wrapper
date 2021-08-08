pub const PrimitiveType = enum(c_uint) {
    Points,
    Lines,
    LineStrip,
    Triangles,
    TriangleStrip,
    TriangleFan,
    Quads,
};
