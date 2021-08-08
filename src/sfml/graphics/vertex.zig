//! Define a point with color and texture coordinates.

const sf = @import("../sfml.zig");

pub const Vertex = packed struct {
    position: sf.system.Vector2f,
    color: sf.graphics.Color,
    tex_coords: sf.system.Vector2f,
};
