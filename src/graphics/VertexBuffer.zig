//! Define a set of one or more 2D primitives. The vertices are stored in the graphic memory.

const sf = @import("../root.zig");

const VertexBuffer = @This();

pub const Usage = enum(c_uint) { static = 0, dynamic = 1, stream = 2 };

// Constructors/destructors

/// Creates a vertex buffer of a given size. Specify its usage and the primitive type.
pub fn createFromSlice(vertices: []const sf.graphics.Vertex, primitive: sf.graphics.PrimitiveType, usage: Usage) !VertexBuffer {
    const ptr = sf.c.sfVertexBuffer_create(@as(c_uint, @truncate(vertices.len)), @intFromEnum(primitive), @intFromEnum(usage)) orelse return sf.Error.nullptrUnknownReason;
    if (sf.c.sfVertexBuffer_update(ptr, @as([*]const sf.c.sfVertex, @ptrCast(@alignCast(vertices.ptr))), @as(c_uint, @truncate(vertices.len)), 0) != 1)
        return sf.Error.resourceLoadingError;
    return VertexBuffer{ ._ptr = ptr };
}

/// Destroyes this vertex buffer
pub fn destroy(self: *VertexBuffer) void {
    sf.c.sfVertexBuffer_destroy(self._ptr);
    self._ptr = undefined;
}

// Getters/setters and methods

/// Updates the vertex buffer with new data
pub fn updateFromSlice(self: VertexBuffer, vertices: []const sf.graphics.Vertex) !void {
    if (sf.c.sfVertexBuffer_update(self._ptr, @as([*]const sf.c.sfVertex, @ptrCast(@alignCast(vertices.ptr))), @as(c_uint, @truncate(vertices.len)), 0) != 1)
        return sf.Error.resourceLoadingError;
}

/// Gets the vertex count of this vertex buffer
pub fn getVertexCount(self: VertexBuffer) usize {
    return sf.c.sfVertexBuffer_getVertexCount(self._ptr);
}

/// Gets the primitive type of this vertex buffer
pub fn getPrimitiveType(self: VertexBuffer) sf.graphics.PrimitiveType {
    return @as(sf.graphics.PrimitiveType, @enumFromInt(sf.c.sfVertexBuffer_getPrimitiveType(self._ptr)));
}

/// Gets the usage of this vertex buffer
pub fn getUsage(self: VertexBuffer) Usage {
    return @as(Usage, @enumFromInt(sf.c.sfVertexBuffer_getUsage(self._ptr)));
}

/// Tells whether or not vertex buffers are available in the system
pub fn isAvailable() bool {
    return sf.c.sfVertexBuffer_isAvailable() != 0;
}

pub const draw_suffix = "VertexBuffer";

/// Pointer to the csfml structure
_ptr: *sf.c.sfVertexBuffer,

test "VertexBuffer: sane getters and setters" {
    const tst = @import("std").testing;

    const va_slice = [_]sf.graphics.Vertex{
        .{ .position = .{ .x = -1, .y = 0 }, .color = sf.graphics.Color.Red },
        .{ .position = .{ .x = 1, .y = 0 }, .color = sf.graphics.Color.Green },
        .{ .position = .{ .x = -1, .y = 1 }, .color = sf.graphics.Color.Blue },
    };
    var va = try createFromSlice(va_slice[0..], sf.graphics.PrimitiveType.triangles, Usage.static);
    defer va.destroy();

    try tst.expectEqual(@as(usize, 3), va.getVertexCount());
    try tst.expectEqual(sf.graphics.PrimitiveType.triangles, va.getPrimitiveType());
    try tst.expectEqual(Usage.static, va.getUsage());
}
