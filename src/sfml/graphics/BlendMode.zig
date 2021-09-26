pub const Factor = enum(c_int) {
    zero,
    one,
    srcColor,
    oneMinusSrcColor,
    dstColor,
    oneMinusDstColor,
    srcAlpha,
    oneMinusSrcAlpha,
    dstAlpha,
    oneMinusDstAlpha 
};

pub const Equation = enum(c_int) {
    add,
    subtract,
    reverseSubtract
};

const BlendMode = @This();

pub const BlendAlpha = .{
    .color_src_factor = .srcAlpha,
    .color_dst_factor = .oneMinusSrcAlpha,
    .color_equation = .add,
    .alpha_src_factor = .one,
    .alpha_dst_factor = .oneMinusSrcAlpha,
    .alpha_equation = .add
};

pub const BlendAdd = .{
    .color_src_factor = .srcAlpha,
    .color_dst_factor = .one,
    .color_equation = .add,
    .alpha_src_factor = .one,
    .alpha_dst_factor = .one,
    .alpha_equation = .add
};

pub const BlendMultiply = .{
    .color_src_factor = .dstColor,
    .color_dst_factor = .zero,
    .color_equation = .add,
    .alpha_src_factor = .dstColor,
    .alpha_dst_factor = .zero,
    .alpha_equation = .add
};

pub const BlendMin = .{
    .color_src_factor = .one,
    .color_dst_factor = .one,
    .color_equation = .min,
    .alpha_src_factor = .one,
    .alpha_dst_factor = .one,
    .alpha_equation = .min
};

pub const BlendMax = .{
    .color_src_factor = .one,
    .color_dst_factor = .one,
    .color_equation = .max,
    .alpha_src_factor = .one,
    .alpha_dst_factor = .one,
    .alpha_equation = .max
};

pub const BlendNone = .{
    .color_src_factor = .one,
    .color_dst_factor = .zero,
    .color_equation = .add,
    .alpha_src_factor = .one,
    .alpha_dst_factor = .zero,
    .alpha_equation = .add
};

color_src_factor: Factor,
color_dst_factor: Factor,
color_equation: Equation,
alpha_src_factor: Factor,
alpha_dst_factor: Factor,
alpha_equation: Equation