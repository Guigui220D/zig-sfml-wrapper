//! Define a set of one or more 2D primitives. The vertices are stored in ram.

const sf = @import("../sfml.zig");
const std = @import("std");

const VertexArray = @This();

// Constructors/destructors

/// Creates an empty vertex array
pub fn create() !VertexArray {
    const va = sf.c.sfVertexArray_create();
    if (va) |vert| {
        return VertexArray{ ._ptr = vert };
    } else return sf.Error.nullptrUnknownReason;
}
/// Creates a vertex array from a slice of vertices
pub fn createFromSlice(vertex: []const sf.graphics.Vertex, primitive: sf.graphics.PrimitiveType) !VertexArray {
    const va = sf.c.sfVertexArray_create();
    if (va) |vert| {
        sf.c.sfVertexArray_setPrimitiveType(vert, @intFromEnum(primitive));
        sf.c.sfVertexArray_resize(vert, vertex.len);
        for (vertex, 0..) |v, i|
            sf.c.sfVertexArray_getVertex(vert, i).* = @as(sf.c.sfVertex, @bitCast(v));
        return VertexArray{ ._ptr = vert };
    } else return sf.Error.nullptrUnknownReason;
}

/// Destroys a vertex array
pub fn destroy(self: *VertexArray) void {
    sf.c.sfVertexArray_destroy(self._ptr);
    self._ptr = undefined;
}

/// Copies the vertex array
pub fn copy(self: VertexArray) !VertexArray {
    const va = sf.c.sfVertexArray_copy(self._ptr);
    if (va) |vert| {
        return VertexArray{ ._ptr = vert };
    } else return sf.Error.nullptrUnknownReason;
}

// Wtf github copilot wrote that for me (all of the functions below here)
// Methods and getters/setters

/// Gets the vertex count of the vertex array
pub fn getVertexCount(self: VertexArray) usize {
    return sf.c.sfVertexArray_getVertexCount(self._ptr);
}

/// Gets a a pointer to a vertex using its index
/// Don't keep the returned pointer, it can be invalidated by other functions
pub fn getVertex(self: VertexArray, index: usize) *sf.graphics.Vertex {
    // TODO: Should this use a pointer to the vertexarray?
    // Me, later, what did that comment even mean? ^
    const ptr = sf.c.sfVertexArray_getVertex(self._ptr, index);
    std.debug.assert(index < self.getVertexCount());
    return @as(*sf.graphics.Vertex, @ptrCast(ptr.?));
}

/// Gets a slice to the vertices of the vertex array
/// Don't keep the returned pointer, it can be invalidated by other function
pub fn getSlice(self: VertexArray) []sf.graphics.Vertex {
    // TODO: Should this use a pointer to the vertexarray?
    var ret: []sf.graphics.Vertex = undefined;

    ret.len = self.getVertexCount();
    ret.ptr = @as([*]sf.graphics.Vertex, @ptrCast(self.getVertex(0)));

    return ret;
}

/// Clears the vertex array
pub fn clear(self: *VertexArray) void {
    sf.c.sfVertexArray_clear(self._ptr);
}

/// Resizes the vertex array to a given size
pub fn resize(self: *VertexArray, vertexCount: usize) void {
    sf.c.sfVertexArray_resize(self._ptr, vertexCount);
}

/// Appends a vertex to the array
pub fn append(self: *VertexArray, vertex: sf.graphics.Vertex) void {
    sf.c.sfVertexArray_append(self._ptr, @as(sf.c.sfVertex, @bitCast(vertex)));
}

/// Gets the primitives' type of this array
pub fn getPrimitiveType(self: VertexArray) sf.graphics.PrimitiveType {
    return @as(sf.graphics.PrimitiveType, @enumFromInt(sf.c.sfVertexArray_getPrimitiveType(self._ptr)));
}

/// Sets the primitives' type of this array
pub fn setPrimitiveType(self: *VertexArray, primitive: sf.graphics.PrimitiveType) void {
    sf.c.sfVertexArray_setPrimitiveType(self._ptr, @intFromEnum(primitive));
}

/// Gets the bounding rectangle of the vertex array
pub fn getBounds(self: VertexArray) sf.graphics.FloatRect {
    return sf.graphics.FloatRect._fromCSFML(sf.c.sfVertexArray_getBounds(self._ptr));
}

pub const draw_suffix = "VertexArray";

/// Pointer to the csfml structure
_ptr: *sf.c.sfVertexArray,

test "VertexArray: sane getters and setters" {
    const tst = std.testing;

    const va_slice = [_]sf.graphics.Vertex{
        .{ .position = .{ .x = -1, .y = 0 }, .color = sf.graphics.Color.Red },
        .{ .position = .{ .x = 1, .y = 0 }, .color = sf.graphics.Color.Green },
        .{ .position = .{ .x = -1, .y = 1 }, .color = sf.graphics.Color.Blue },
    };
    var va = try createFromSlice(va_slice[0..], sf.graphics.PrimitiveType.Triangles);
    defer va.destroy();

    va.append(.{ .position = .{ .x = 1, .y = 1 }, .color = sf.graphics.Color.Yellow });
    va.setPrimitiveType(sf.graphics.PrimitiveType.Quads);

    try tst.expectEqual(@as(usize, 4), va.getVertexCount());
    try tst.expectEqual(sf.graphics.PrimitiveType.Quads, va.getPrimitiveType());
    try tst.expectEqual(sf.graphics.FloatRect{ .left = -1, .top = 0, .width = 2, .height = 1 }, va.getBounds());

    va.resize(3);
    va.setPrimitiveType(sf.graphics.PrimitiveType.TriangleFan);
    try tst.expectEqual(@as(usize, 3), va.getVertexCount());

    const vert = va.getVertex(0).*;
    try tst.expectEqual(sf.system.Vector2f{ .x = -1, .y = 0 }, vert.position);
    try tst.expectEqual(sf.graphics.Color.Red, vert.color);

    va.getVertex(1).* = .{ .position = .{ .x = 1, .y = 1 }, .color = sf.graphics.Color.Yellow };

    const slice = va.getSlice();
    try tst.expectEqual(sf.graphics.Color.Yellow, slice[1].color);
    try tst.expectEqual(@as(usize, 3), slice.len);

    va.clear();
    try tst.expectEqual(@as(usize, 0), va.getVertexCount());

    var va2 = try create();
    defer va2.destroy();

    try tst.expectEqual(@as(usize, 0), va2.getVertexCount());
}
