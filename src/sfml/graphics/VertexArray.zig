//! Define a set of one or more 2D primitives. 

const sf = @import("../sfml.zig");

pub const PrimitiveType = enum {
    Points,
    Lines,
    LineStrip,
    Triangles,
    TriangleStrip,
    TriangleFan,
    Quads
}

vertices: []sf.Vertex,
primitive_type: PrimitiveType,