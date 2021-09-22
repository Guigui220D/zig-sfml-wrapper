//! Class for loading, manipulating and saving images.

const sf = struct {
    pub usingnamespace @import("../sfml.zig");
    pub usingnamespace sf.system;
    pub usingnamespace sf.graphics;
};

const std = @import("std");
const assert = std.debug.assert;

const Image = @This();

// Constructor/destructor

/// Creates a new image
pub fn create(size: sf.Vector2u, color: sf.Color) !Image {
    var img = sf.c.sfImage_createFromColor(size.x, size.y, color._toCSFML());
    if (img == null)
        return sf.Error.nullptrUnknownReason;
    return Image{ ._ptr = img.? };
}

/// Creates an image from a pixel array
pub fn createFromPixels(size: sf.Vector2u, pixels: []const sf.Color) !Image {
    // Check if there is enough data
    if (pixels.len < size.x * size.y)
        return sf.Error.notEnoughData;

    var img = sf.c.sfImage_createFromPixels(size.x, size.y, @ptrCast([*]const u8, pixels.ptr));

    if (img == null)
        return sf.Error.nullptrUnknownReason;
    return Image{ ._ptr = img.? };
}

/// Loads an image from a file
pub fn createFromFile(path: [:0]const u8) !Image {
    var img = sf.c.sfImage_createFromFile(path);
    if (img == null)
        return sf.Error.resourceLoadingError;
    return Image{ ._ptr = img.? };
}

/// Destroys an image
pub fn destroy(self: Image) void {
    sf.c.sfImage_destroy(self._ptr);
}

// Save an image to a file
pub fn saveToFile(self: Image, path: [:0]const u8) !void {
    if (sf.c.sfImage_saveToFile(self._ptr, path) != 1)
        return sf.Error.savingInFileFailed;
}

// Getters/setters

/// Gets a pixel from this image (bounds are only checked in an assertion)
pub fn getPixel(self: Image, pixel_pos: sf.Vector2u) sf.Color {
    const size = self.getSize();
    assert(pixel_pos.x < size.x and pixel_pos.y < size.y);

    return sf.Color._fromCSFML(sf.c.sfImage_getPixel(self._ptr, pixel_pos.x, pixel_pos.y));
}
/// Sets a pixel on this image (bounds are only checked in an assertion)
pub fn setPixel(self: Image, pixel_pos: sf.Vector2u, color: sf.Color) void {
    const size = self.getSize();
    assert(pixel_pos.x < size.x and pixel_pos.y < size.y);

    sf.c.sfImage_setPixel(self._ptr, pixel_pos.x, pixel_pos.y, color._toCSFML());
}

/// Gets the size of this image
pub fn getSize(self: Image) sf.Vector2u {
    const size = sf.c.sfImage_getSize(self._ptr);
    return sf.Vector2u{ .x = size.x, .y = size.y };
}

/// Pointer to the csfml texture
_ptr: *sf.c.sfImage,

test "image: sane getters and setters" {
    const tst = std.testing;
    const allocator = std.heap.page_allocator;

    var pixel_data = try allocator.alloc(sf.Color, 30);
    defer allocator.free(pixel_data);

    for (pixel_data) |*c, i| {
        c.* = sf.Color.fromHSVA(@intToFloat(f32, i) / 30 * 360, 100, 100, 1);
    }

    var img = try Image.createFromPixels(.{ .x = 5, .y = 6 }, pixel_data);
    defer img.destroy();

    try tst.expectEqual(sf.Vector2u{ .x = 5, .y = 6 }, img.getSize());

    img.setPixel(.{ .x = 1, .y = 2 }, sf.Color.Cyan);
    try tst.expectEqual(sf.Color.Cyan, img.getPixel(.{ .x = 1, .y = 2 }));

    var tex = try sf.Texture.createFromImage(img, null);
    defer tex.destroy();
}
