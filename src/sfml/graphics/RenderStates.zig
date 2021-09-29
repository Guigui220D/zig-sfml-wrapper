//! Defines settings for drawing things on a target

const sf = struct {
    pub usingnamespace @import("../sfml.zig");
    pub usingnamespace sf.graphics;
};

blend_mode: sf.BlendMode = sf.BlendMode.BlendAlpha,
//transform: null, // TODO: implement transforms (#25)
texture: ?sf.Texture = null,
shader: ?sf.Shader = null,

pub fn _toCSFML(self: @This()) sf.c.sfRenderStates {
    return .{
        .blendMode = self.blend_mode._toCSFML(),
        .transform = .{ .matrix = .{ 1, 0, 0, 0, 1, 0, 0, 0, 1} },
        .texture = if (self.texture) |t| t._get() else null,
        .shader = if (self.shader) |s| s._ptr else null
    };
}