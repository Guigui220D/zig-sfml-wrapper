//! Class for loading and manipulating character fonts.

const sf = @import("../sfml.zig");

const Font = @This();

// Constructor/destructor

/// Loads a font from a file
pub fn createFromFile(path: [:0]const u8) !Font {
    var font = sf.c.sfFont_createFromFile(path);
    if (font == null)
        return sf.Error.resourceLoadingError;
    return Font{ ._ptr = font.? };
}
/// Destroys a font
pub fn destroy(self: *Font) void {
    sf.c.sfFont_destroy(self._ptr);
}

/// Gets the family name of this font
/// Normally, this is done through getInfo, but as info only contains this data, this makes more sense
pub fn getFamily(self: Font) [*:0]const u8 {
    return sf.c.sfFont_getInfo(self._ptr).family;
} 

/// Gets the kerning offset of two glyphs
pub fn getKerning(self: Font, first: u32, second: u32, character_size: usize) f32 {
    return sf.c.sfFont_getKerning(self._ptr, first, second, @intCast(c_uint, character_size));
}

/// Gets the default spacing between two lines
pub fn getLineSpacing(self: Font, character_size: usize) f32 {
    return sf.c.sfFont_getLineSpacing(self._ptr, @intCast(c_uint, character_size));
}

/// Gets the vertical offset of the underline
pub fn getUnderlinePosition(self: Font, character_size: usize) f32 {
    return sf.c.sfFont_getUnderlinePosition(self._ptr, @intCast(c_uint, character_size));
}
/// Gets the underline thickness
pub fn getUnderlineThickness(self: Font, character_size: usize) f32 {
    return sf.c.sfFont_getUnderlineThickness(self._ptr, @intCast(c_uint, character_size));
}

pub const getGlyph = @compileError("Function is not implemented yet.");
pub const initFromMemory = @compileError("Function is not implemented yet.");
pub const initFromStream = @compileError("Function is not implemented yet.");

/// Pointer to the csfml font
_ptr: *sf.c.sfFont,
