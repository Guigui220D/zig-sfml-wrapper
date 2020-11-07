//! Class for loading and manipulating character fonts.

const sf = @import("../sfml.zig");

pub const Font = struct {
    const Self = @This();

    // Constructor/destructor

    /// Loads a font from a file
    pub fn initFromFile(path: [:0]const u8) !Self {
        var font = sf.c.sfFont_createFromFile(path);
        if (font == null)
            return sf.Error.resourceLoadingError;
        return Self{ .ptr = font.? };
    }
    /// Destroys a font
    pub fn deinit(self: Self) void {
        sf.c.sfFont_destroy(self.ptr);
    }

    /// Pointer to the csfml font
    ptr: *sf.c.sfFont,
};
