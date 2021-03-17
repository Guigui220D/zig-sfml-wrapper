//! Class for loading and manipulating character fonts.

const sf = @import("../sfml.zig");

const Font = @This();

// Constructor/destructor

/// Loads a font from a file
pub fn createFromFile(path: [:0]const u8) !Font {
    var font = sf.c.sfFont_createFromFile(path);
    if (font == null)
        return sf.Error.resourceLoadingError;
    return Font{ .ptr = font.? };
}
/// Destroys a font
pub fn destroy(self: Font) void {
    sf.c.sfFont_destroy(self.ptr);
}

pub const initFromMemory = @compileError("Function is not implemented yet.");
pub const initFromStream = @compileError("Function is not implemented yet.");

/// Pointer to the csfml font
ptr: *sf.c.sfFont,
