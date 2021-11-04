//! Define a point with color and texture coordinates.

const sf = @import("../sfml.zig");

pub const Vertex = packed struct { position: sf.system.Vector2f = sf.system.Vector2f{ .x = 0, .y = 0 }, color: sf.graphics.Color = sf.graphics.Color.White, tex_coords: sf.system.Vector2f = sf.system.Vector2f{ .x = 0, .y = 0 } };
