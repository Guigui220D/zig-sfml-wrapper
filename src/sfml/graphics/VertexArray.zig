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

pub fn create() !VertexArray {
    var va = sf.c.sfVertexArray_create();
    if (va == null)
        return sf.Error.nullptrUnknownReason;
    return VertexArray{ .ptr = va.? };
}

pub fn createFromSlice(vertex: []const sf.graphics.Vertex) !VertexArray {
    var va = sf.c.sfVertexArray_create();
    if (va) |vert| {
        for (vertex) {

        }
    } else
        return sf.Error.nullptrUnknownReason;
}

ptr: *sf.c.sfSoundBuffer,