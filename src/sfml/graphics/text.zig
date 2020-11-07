//! Graphical text that can be drawn to a render target. 

const sf = @import("../sfml.zig");

pub const Text = struct {
    const Self = @This();

    // Constructor/destructor

    /// Inits an empty text
    pub fn init() !Self {
        var text = sf.c.sfText_create();
        if (text == null)
            return sf.Error.nullptrUnknownReason;
        return Self{ .ptr = text.? };
    }
    /// Inits a text with content
    pub fn initWithText(string: [:0]const u8, font: sf.Font, characterSize: usize) !Self {
        var text = sf.c.sfText_create();
        if (text == null)
            return sf.Error.nullptrUnknownReason;
        sf.c.sfText_setFont(text, font.ptr);
        sf.c.sfText_setCharacterSize(text, @intCast(c_uint, characterSize));
        sf.c.sfText_setString(text, string);
        return Self{ .ptr = text.? };
    }
    /// Destroys a text
    pub fn deinit(self: Self) void {
        sf.c.sfText_destroy(self.ptr);
    }

    /// Pointer to the csfml font
    ptr: *sf.c.sfText,
};
