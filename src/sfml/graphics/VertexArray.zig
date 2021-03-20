//! Define a set of one or more 2D primitives. 

const sf = @import("../sfml.zig");

// CONSTRUCTION ZONE

const VertexArray = @This();

pub const PrimitiveType = enum(c_int) {
    Points,
    Lines,
    LineStrip,
    Triangles,
    TriangleStrip,
    TriangleFan,
    Quads
}

pub fn createFromSlice(vertex: []const sf.graphics.Vertex) !VertexArray {
    var va = sf.c.sfVertexArray_create();
    if (va) |vert| {
        sf.c.sfVertexArray_resize(vert, vertex.len);
        for (vertex) |v, i|
            sf.c.sfVertexArray_getVertex(vert, i).* = @bitCast(sf.c.sfVertex, v);
    } else
        return sf.Error.nullptrUnknownReason;
}

ptr: *sf.c.sfSoundBuffer,