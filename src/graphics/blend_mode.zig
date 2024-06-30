//! Blending modes for drawing (for render states)

pub const BlendMode = extern struct {
    // Enums
    pub const Factor = enum(c_int) {
        zero,
        one,
        src_color,
        one_minus_src_color,
        dst_color,
        one_minus_dst_color,
        src_alpha,
        one_minus_src_alpha,
        dst_alpha,
        one_minus_dst_alpha,
    };

    pub const Equation = enum(c_int) {
        add,
        subtract,
        reverseSubtract,
        min,
        max,
    };

    // Preset blend modes
    pub const BlendAlpha = BlendMode{
        .color_src_factor = .src_alpha,
        .color_dst_factor = .one_minus_src_alpha,
        .color_equation = .add,
        .alpha_src_factor = .one,
        .alpha_dst_factor = .one_minus_src_alpha,
        .alpha_equation = .add,
    };

    pub const BlendAdd = BlendMode{
        .color_src_factor = .src_alpha,
        .color_dst_factor = .one,
        .color_equation = .add,
        .alpha_src_factor = .one,
        .alpha_dst_factor = .one,
        .alpha_equation = .add,
    };

    pub const BlendMultiply = BlendMode{
        .color_src_factor = .dst_color,
        .color_dst_factor = .zero,
        .color_equation = .add,
        .alpha_src_factor = .dst_color,
        .alpha_dst_factor = .zero,
        .alpha_equation = .add,
    };

    pub const BlendMin = BlendMode{
        .color_src_factor = .one,
        .color_dst_factor = .one,
        .color_equation = .min,
        .alpha_src_factor = .one,
        .alpha_dst_factor = .one,
        .alpha_equation = .min,
    };

    pub const BlendMax = BlendMode{
        .color_src_factor = .one,
        .color_dst_factor = .one,
        .color_equation = .max,
        .alpha_src_factor = .one,
        .alpha_dst_factor = .one,
        .alpha_equation = .max,
    };

    pub const BlendNone = BlendMode{
        .color_src_factor = .one,
        .color_dst_factor = .zero,
        .color_equation = .add,
        .alpha_src_factor = .one,
        .alpha_dst_factor = .zero,
        .alpha_equation = .add,
    };

    const sfBlendMode = @import("../root.zig").c.sfBlendMode;
    /// Bitcasts this blendmode to the csfml struct
    /// For inner workings
    pub fn _toCSFML(self: BlendMode) sfBlendMode {
        return @as(sfBlendMode, @bitCast(self));
    }

    color_src_factor: Factor,
    color_dst_factor: Factor,
    color_equation: Equation,
    alpha_src_factor: Factor,
    alpha_dst_factor: Factor,
    alpha_equation: Equation,
};
