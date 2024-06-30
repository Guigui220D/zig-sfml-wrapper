//! The type of primitives in a vertex array of buffer

const Vertex = @import("vertex.zig").Vertex;

pub const PrimitiveType = enum(c_uint) {
    points,
    lines,
    line_strip,
    triangles,
    triangle_strip,
    triangle_fan,
    quads,

    /// Gives the corresponding primitive type for primitive iteration
    /// See Vertex.verticesAsPrimitives()
    pub fn Type(comptime primitive_type: PrimitiveType) type {
        return switch (primitive_type) {
            .points => PointPrimitive,
            .lines => LinePrimitive,
            .triangles => TrianglePrimitive,
            .quads => QuadPrimitive,
            else => @compileError("Primitive type not supported"),
        };
    }
    /// Says how many vertices each primitive is composed of
    pub fn vertexCount(primitive_type: PrimitiveType) usize {
        return switch (primitive_type) {
            .points => 1,
            .lines => 2,
            .triangles => 3,
            .quads => 4,
            else => @panic("Primitive type not supported"),
        };
    }

    //TODO: Note: these structs should be packed but zig has bugs with that as of now and it doesn't work

    /// A single point
    pub const PointPrimitive = struct { a: Vertex };
    /// A line between two points
    pub const LinePrimitive = struct { a: Vertex, b: Vertex };
    /// A triangle between three points
    pub const TrianglePrimitive = struct { a: Vertex, b: Vertex, c: Vertex };
    /// A quad between four points
    pub const QuadPrimitive = struct { a: Vertex, b: Vertex, c: Vertex, d: Vertex };
};
