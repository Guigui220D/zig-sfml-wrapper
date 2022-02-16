//! Define a set of one or more 2D primitives. The vertices are stored in the graphic memory.

const sf = @import("../sfml.zig");

const VertexBuffer = @This();

pub const Usage = enum(c_uint) { Static = 0, Dynamic = 1, Stream = 2 };

// Constructors/destructors

/// Creates a vertex buffer of a given size. Specify its usage and the primitive type.
pub fn createFromSlice(vertices: []const sf.graphics.Vertex, primitive: sf.graphics.PrimitiveType, usage: Usage) !VertexBuffer {
    var ptr = sf.c.sfVertexBuffer_create(@truncate(c_uint, vertices.len), @enumToInt(primitive), @enumToInt(usage)) orelse return sf.Error.nullptrUnknownReason;
    if (sf.c.sfVertexBuffer_update(ptr, @ptrCast([*]const sf.c.sfVertex, @alignCast(4, vertices.ptr)), @truncate(c_uint, vertices.len), 0) != 1)
        return sf.Error.resourceLoadingError;
    return VertexBuffer{ ._ptr = ptr };
}

/// Destroyes this vertex buffer
pub fn destroy(self: *VertexBuffer) void {
    sf.c.sfVertexBuffer_destroy(self._ptr);
    self._ptr = undefined;
}

// Draw function

/// The draw function of this vertex buffer
/// Meant to be called by your_target.draw(your_vertices, .{});
pub fn sfDraw(self: VertexBuffer, target: anytype, states: ?*sf.c.sfRenderStates) void {
    switch (@TypeOf(target)) {
        sf.graphics.RenderWindow => sf.c.sfRenderWindow_drawVertexBuffer(target._ptr, self._ptr, states),
        sf.graphics.RenderTexture => sf.c.sfRenderTexture_drawVertexBuffer(target._ptr, self._ptr, states),
        else => @compileError("target must be a render target"),
    }
}

// Getters/setters and methods

/// Updates the vertex buffer with new data
pub fn updateFromSlice(self: VertexBuffer, vertices: []const sf.graphics.Vertex) !void {
    if (sf.c.sfVertexBuffer_update(self._ptr, @ptrCast([*]const sf.c.sfVertex, @alignCast(4, vertices.ptr)), @truncate(c_uint, vertices.len), 0) != 1)
        return sf.Error.resourceLoadingError;
}

/// Gets the vertex count of this vertex buffer
pub fn getVertexCount(self: VertexBuffer) usize {
    return sf.c.sfVertexBuffer_getVertexCount(self._ptr);
}

/// Gets the primitive type of this vertex buffer
pub fn getPrimitiveType(self: VertexBuffer) sf.graphics.PrimitiveType {
    return @intToEnum(sf.graphics.PrimitiveType, sf.c.sfVertexBuffer_getPrimitiveType(self._ptr));
}

/// Gets the usage of this vertex buffer
pub fn getUsage(self: VertexBuffer) Usage {
    return @intToEnum(Usage, sf.c.sfVertexBuffer_getUsage(self._ptr));
}

/// Tells whether or not vertex buffers are available in the system
pub fn isAvailable() bool {
    return sf.c.sfVertexBuffer_isAvailable() != 0;
}

/// Pointer to the csfml structure
_ptr: *sf.c.sfVertexBuffer,

test "VertexBuffer: sane getters and setters" {
    const tst = @import("std").testing;

    const va_slice = [_]sf.graphics.Vertex{
        .{ .position = .{ .x = -1, .y = 0 }, .color = sf.graphics.Color.Red },
        .{ .position = .{ .x = 1, .y = 0 }, .color = sf.graphics.Color.Green },
        .{ .position = .{ .x = -1, .y = 1 }, .color = sf.graphics.Color.Blue },
    };
    var va = try createFromSlice(va_slice[0..], sf.graphics.PrimitiveType.Triangles, Usage.Static);
    defer va.destroy();

    try tst.expectEqual(@as(usize, 3), va.getVertexCount());
    try tst.expectEqual(sf.graphics.PrimitiveType.Triangles, va.getPrimitiveType());
    try tst.expectEqual(Usage.Static, va.getUsage());
}
