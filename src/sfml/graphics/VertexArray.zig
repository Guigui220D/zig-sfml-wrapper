//! Define a set of one or more 2D primitives. 

const sf = @import("../sfml.zig");

// CONSTRUCTION ZONE

const VertexArray = @This();

/// Creates a vertex array from a slice of vertices
pub fn createFromSlice(vertex: []const sf.graphics.Vertex, primitive: sf.graphics.PrimitiveType) !VertexArray {
    var va = sf.c.sfVertexArray_create();
    if (va) |vert| {
        sf.c.sfVertexArray_setPrimitiveType(vert, @enumToInt(primitive));
        sf.c.sfVertexArray_resize(vert, vertex.len);
        for (vertex) |v, i|
            sf.c.sfVertexArray_getVertex(vert, i).* = @bitCast(sf.c.sfVertex, v);
        return VertexArray{ ._ptr = vert };
    } else return sf.Error.nullptrUnknownReason;
}

/// Destroys a vertex array
pub fn destroy(self: VertexArray) void {
    sf.c.sfVertexArray_destroy(self._ptr);
}

// Draw function
pub fn sfDraw(self: VertexArray, window: anytype, states: ?*sf.c.sfRenderStates) void {
    switch (@TypeOf(window)) {
        sf.graphics.RenderWindow => sf.c.sfRenderWindow_drawVertexArray(window._ptr, self._ptr, states),
        sf.graphics.RenderTexture => sf.c.sfRenderTexture_drawVertexArray(window._ptr, self._ptr, states),
        else => @compileError("window must be a render target"),
    }
}

/// Pointer to the csfml structure
_ptr: *sf.c.sfVertexArray,
