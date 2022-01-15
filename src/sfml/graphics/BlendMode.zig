//! Blending modes for drawing (for render states)

// Enums
pub const Factor = enum(c_int) { zero, one, srcColor, oneMinusSrcColor, dstColor, oneMinusDstColor, srcAlpha, oneMinusSrcAlpha, dstAlpha, oneMinusDstAlpha };

pub const Equation = enum(c_int) { add, subtract, reverseSubtract };

const BlendMode = @This();

// Preset blend modes
pub const BlendAlpha = BlendMode{ .color_src_factor = .srcAlpha, .color_dst_factor = .oneMinusSrcAlpha, .color_equation = .add, .alpha_src_factor = .one, .alpha_dst_factor = .oneMinusSrcAlpha, .alpha_equation = .add };

pub const BlendAdd = BlendMode{ .color_src_factor = .srcAlpha, .color_dst_factor = .one, .color_equation = .add, .alpha_src_factor = .one, .alpha_dst_factor = .one, .alpha_equation = .add };

pub const BlendMultiply = BlendMode{ .color_src_factor = .dstColor, .color_dst_factor = .zero, .color_equation = .add, .alpha_src_factor = .dstColor, .alpha_dst_factor = .zero, .alpha_equation = .add };

pub const BlendMin = BlendMode{ .color_src_factor = .one, .color_dst_factor = .one, .color_equation = .min, .alpha_src_factor = .one, .alpha_dst_factor = .one, .alpha_equation = .min };

pub const BlendMax = BlendMode{ .color_src_factor = .one, .color_dst_factor = .one, .color_equation = .max, .alpha_src_factor = .one, .alpha_dst_factor = .one, .alpha_equation = .max };

pub const BlendNone = BlendMode{ .color_src_factor = .one, .color_dst_factor = .zero, .color_equation = .add, .alpha_src_factor = .one, .alpha_dst_factor = .zero, .alpha_equation = .add };

const sfBlendMode = @import("../sfml_import.zig").c.sfBlendMode;
/// Bitcasts this blendmode to the csfml struct
/// For inner workings
pub fn _toCSFML(self: BlendMode) sfBlendMode {
    return @bitCast(sfBlendMode, self);
}

color_src_factor: Factor,
color_dst_factor: Factor,
color_equation: Equation,
alpha_src_factor: Factor,
alpha_dst_factor: Factor,
alpha_equation: Equation
