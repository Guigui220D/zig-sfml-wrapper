//! Defines settings for drawing things on a target

const sf = struct {
    pub usingnamespace @import("../sfml.zig");
    pub usingnamespace sf.graphics;
};

blend_mode: sf.BlendMode = sf.BlendMode.BlendAlpha,
transform: sf.Transform = sf.Transform.Identity,
texture: ?sf.Texture = null,
shader: ?sf.Shader = null,

pub fn _toCSFML(self: @This()) sf.c.sfRenderStates {
    return .{ .blendMode = self.blend_mode._toCSFML(), .transform = self.transform._toCSFML(), .texture = if (self.texture) |t| t._get() else null, .shader = if (self.shader) |s| s._ptr else null };
}
