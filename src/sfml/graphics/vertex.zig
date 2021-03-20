//! Define a point with color and texture coordinates.

const sf = @import("../sfml.zig");

// Construction Zone

pub const Vertex = packed struct {
    position: sf.Vector2f,
    color: sf.Color,
    tex_coords: sf.Vector2f,

    pub const toCSFML(self: Vertex) sf.c.sfVertexArray {
        return @bitCast(sf.c.sfVertexArray, self);
    }

    pub const fromCSFML(vert: sf.c.sfVertexArray) Vertex {
        return @bitCast(Vertex, vert);
    }
};