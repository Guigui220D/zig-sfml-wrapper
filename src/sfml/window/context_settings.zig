const sf = @import("../sfml.zig");

pub const ContextSettings = packed struct {
    const PaddingType = @import("std").meta.Int(.unsigned, @bitSizeOf(c_int) - @bitSizeOf(bool));

    depth_bits: c_uint = 0,
    stencil_bits: c_uint = 0,
    antialiasing_level: c_uint = 0,
    major_version: c_uint = 1,
    minor_version: c_uint = 1,
    attribute_flags: u32 = 0,
    srgb_capable: bool = false,
    _padding: PaddingType = 0,

    pub const Attribute = struct {
        pub const default: u32 = 0;
        pub const core: u32 = 1;
        pub const debug: u32 = 4;
    };

    pub fn _toCSFML(self: ContextSettings) sf.c.sfContextSettings {
        return @bitCast(sf.c.sfContextSettings, self);
    }

    pub fn _fromCSFML(context_settings: sf.c.sfContextSettings) ContextSettings {
        return @bitCast(ContextSettings, context_settings);
    }
};
