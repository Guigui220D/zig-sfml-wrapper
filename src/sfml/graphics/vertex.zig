//! Define a point with color and texture coordinates.

const sf = @import("../sfml.zig");

pub const Vertex = packed struct {
    /// Position of the vertex
    position: sf.system.Vector2f = sf.system.Vector2f{ .x = 0, .y = 0 },
    /// Color of the vertex
    color: sf.graphics.Color = sf.graphics.Color.White,
    /// Texture coordinates of the vertex
    tex_coords: sf.system.Vector2f = sf.system.Vector2f{ .x = 0, .y = 0 },

    /// Allows iterating over a slice of vertices as if they were primitives
    /// See primitive_type
    pub fn verticesAsPrimitives(vertices: []Vertex, comptime primitive_type: sf.graphics.PrimitiveType) []primitive_type.Type() {
        if (vertices.len % (comptime primitive_type.packedBy()) != 0)
            @panic("The total number of vertices must be a multiple of the primitive type number of vertices");

        var ret: []primitive_type.Type() = undefined;
        ret.len = vertices.len / (comptime primitive_type.packedBy());
        ret.ptr = @ptrCast([*]primitive_type.Type(), vertices.ptr);

        return ret;
    }
};
