//! Define a set of one or more 2D primitives. 

const sf = @import("../sfml.zig");

// CONSTRUCTION ZONE

const VertexArray = @This();

/// Creates a vertex array from a slice of vertices
pub fn createFromSlice(vertex: []const sf.graphics.Vertex, primitive: sf.graphics.PrimitiveType) !VertexArray {
    var va = sf.c.sfVertexArray_create();
    if (va) |vert| {
        sf.c.sfVertexArray_setPrimitiveType(vert, @intToEnum(sf.c.sfPrimitiveType, @enumToInt(primitive)));
        sf.c.sfVertexArray_resize(vert, vertex.len);
        for (vertex) |v, i|
            sf.c.sfVertexArray_getVertex(vert, i).* = @bitCast(sf.c.sfVertex, v);
        return VertexArray{ .ptr = vert };
    } else
        return sf.Error.nullptrUnknownReason;
}

/// Destroys a vertex array
pub fn destroy(self: VertexArray) void {
    sf.c.sfVertexArray_destroy(self.ptr);
}

// Draw function
pub fn sfDraw(self: VertexArray, window: sf.graphics.RenderWindow, states: ?*sf.c.sfRenderStates) void {
    sf.c.sfRenderWindow_drawVertexArray(window.ptr, self.ptr, states);
}

/// Pointer to the csfml structure
ptr: *sf.c.sfVertexArray,