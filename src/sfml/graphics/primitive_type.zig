//! The type of primitives in a vertex array of buffer

const Vertex = @import("vertex.zig").Vertex;

pub const PrimitiveType = enum(c_uint) {
    Points,
    Lines,
    LineStrip,
    Triangles,
    TriangleStrip,
    TriangleFan,
    Quads,

    /// Gives the corresponding primitive type for primitive iteration
    /// See Vertex.verticesAsPrimitives()
    pub fn Type(comptime primitive_type: PrimitiveType) type {
        return switch (primitive_type) {
            .Points => PointPrimitive,
            .Lines => LinePrimitive,
            .Triangles => TrianglePrimitive,
            .Quads => QuadPrimitive,
            else => @compileError("Primitive type not supported")
        };
    }
    /// Says how many vertices each primitive is composed of
    pub fn packedBy(primitive_type: PrimitiveType) usize {
        return switch (primitive_type) {
            .Points => 1,
            .Lines => 2,
            .Triangles => 3,
            .Quads => 4,
            else => @panic("Primitive type not supported")
        };
    }
    /// A single point
    pub const PointPrimitive = packed struct {
        a: Vertex
    };
    /// A line between two points
    pub const LinePrimitive = packed struct {
        a: Vertex,
        b: Vertex
    };
    /// A triangle between three points
    pub const TrianglePrimitive = packed struct {
        a: Vertex,
        b: Vertex,
        c: Vertex
    };
    /// A quad between four points
    pub const QuadPrimitive = packed struct {
        a: Vertex,
        b: Vertex,
        c: Vertex,
        d: Vertex
    };
};
