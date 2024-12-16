const sf = struct {
    const sfml = @import("../root.zig");
    pub usingnamespace sfml;
    pub usingnamespace sfml.window;
};

const std = @import("std");

pub const Clipboard = struct {
    pub fn getString() ?[]const u8 {
        const c_str = sf.c.sfClipboard_getString();
        return if (c_str != null) std.mem.span(c_str) else null;
    }

    pub fn setString(text: []const u8) void {
        sf.c.sfClipboard_setString(text.ptr);
    }
};
