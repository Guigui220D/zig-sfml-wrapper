pub const PrimitiveType = enum(c_int) {
    Points,
    Lines,
    LineStrip,
    Triangles,
    TriangleStrip,
    TriangleFan,
    Quads
};