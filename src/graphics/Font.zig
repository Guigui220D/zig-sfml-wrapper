//! Class for loading and manipulating character fonts.

const sf = @import("../root.zig");

const Font = @This();

// Constructor/destructor

/// Loads a font from a file
pub fn createFromFile(path: [:0]const u8) !Font {
    const font = sf.c.sfFont_createFromFile(path);
    if (font) |f| {
        return Font{ ._ptr = f };
    } else return sf.Error.resourceLoadingError;
}
/// Loads a font from a file in memory
pub fn createFromMemory(data: []const u8) !Font {
    const font = sf.c.sfFont_createFromMemory(@as(?*const anyopaque, @ptrCast(data.ptr)), data.len);
    if (font) |f| {
        return Font{ ._ptr = f };
    } else return sf.Error.resourceLoadingError;
}
/// Destroys a font
pub fn destroy(self: *Font) void {
    sf.c.sfFont_destroy(self._ptr);
    self._ptr = undefined;
}

/// Gets the family name of this font
/// Normally, this is done through getInfo, but as info only contains this data, this makes more sense
pub fn getFamily(self: Font) [*:0]const u8 {
    return sf.c.sfFont_getInfo(self._ptr).family;
}

/// Gets the kerning offset of two glyphs
pub fn getKerning(self: Font, first: u32, second: u32, character_size: usize) f32 {
    return sf.c.sfFont_getKerning(self._ptr, first, second, @as(c_uint, @intCast(character_size)));
}

/// Gets the default spacing between two lines
pub fn getLineSpacing(self: Font, character_size: usize) f32 {
    return sf.c.sfFont_getLineSpacing(self._ptr, @as(c_uint, @intCast(character_size)));
}

/// Gets the vertical offset of the underline
pub fn getUnderlinePosition(self: Font, character_size: usize) f32 {
    return sf.c.sfFont_getUnderlinePosition(self._ptr, @as(c_uint, @intCast(character_size)));
}
/// Gets the underline thickness
pub fn getUnderlineThickness(self: Font, character_size: usize) f32 {
    return sf.c.sfFont_getUnderlineThickness(self._ptr, @as(c_uint, @intCast(character_size)));
}

/// Check if the font has the following glyph
pub fn hasGlyph(self: Font, codepoint: u21) bool {
    return sf.c.sfFont_hasGlyph(self._ptr, @intCast(codepoint)) != 0;
}

/// Enable or disable the smooth filter
pub fn setSmooth(self: *Font, smooth: bool) void {
    sf.c.sfFont_setSmooth(self._ptr, @intFromBool(smooth));
}
/// Tell whether the smooth filter is enabled or disabled
pub fn isSmooth(self: Font) bool {
    return sf.c.sfFont_isSmooth(self._ptr) != 0;
}

// TODO
//pub const getGlyph = @compileError("Function is not implemented yet.");
//pub const initFromStream = @compileError("Function is not implemented yet.");

/// Pointer to the csfml font
_ptr: *sf.c.sfFont,

test "Font: sane getters and setters" {
    const std = @import("std");
    const tst = std.testing;

    // TODO: is it a good idea to have a test rely on resources?
    var font = try createFromFile("res/arial.ttf");
    defer font.destroy();

    font.setSmooth(true);

    try tst.expect(std.mem.eql(u8, "Arial", std.mem.span(font.getFamily())));
    // TODO: how to test that?
    _ = font.getLineSpacing(12);
    _ = font.getUnderlinePosition(12);
    _ = font.getUnderlineThickness(12);
    _ = font.getKerning('a', 'b', 12);

    try tst.expect(font.hasGlyph('a'));
    try tst.expect(font.isSmooth());
}
