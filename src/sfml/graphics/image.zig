//! Class for loading, manipulating and saving images.

const sf = @import("../sfml.zig");
const std = @import("std");
const assert = std.debug.assert;

pub const Image = struct {
    const Self = @This();

    // Constructor/destructor

    /// Creates a new image
    pub fn init(size: sf.Vector2u, color: sf.Color) !Self {
        var img = sf.c.sfImage_createFromColor(size.x, size.y, color.toCSFML());
        if (img == null)
            return sf.Error.nullptrUnknownReason;
        return Self{ .img = tex.? };
    }

    /// Creates an image from a pixel array
    pub fn initFromPixels(size: sf.Vector2u, pixels: []const sf.Color) !Self {
        // Check if there is enough data
        if (pixels.len < size.x * size.y)
            return sf.Error.notEnoughData;

        var img = sf.c.sfImage_createFromPixels(size.x, size.y, @ptrCast([*]const u8, pixels.ptr));

        if (img == null)
            return sf.Error.nullptrUnknownReason;
        return Self{ .ptr = img.? };
    }

    /// Loads an image from a file
    pub fn initFromFile(path: [:0]const u8) !Self {
        var img = sf.c.sfImage_createFromFile(path);
        if (img == null)
            return sf.Error.resourceLoadingError;
        return Self{ .ptr = img.? };
    }

    /// Destroys an image
    pub fn deinit(self: Self) void {
        sf.c.sfImage_destroy(self.ptr);
    }

    // Getters/setters

    /// Gets a pixel from this image (bounds are only checked in an assertion)
    pub fn getPixel(self: Self, pixel_pos: sf.Vector2u) sf.Color {
        @compileError("This function causes a segfault, comment this out if you thing it will work (issue #2)");

        const size = self.getSize();
        assert(pixel_pos.x < size.x and pixel_pos.y < size.y);

        return sf.Color.fromCSFML(sf.c.sfImage_getPixel(self.ptr, pixel_pos.x, pixel_pos.y));
    }
    /// Sets a pixel on this image (bounds are only checked in an assertion)
    pub fn setPixel(self: Self, pixel_pos: sf.Vector2u, color: sf.Color) void {
        const size = self.getSize();
        assert(pixel_pos.x < size.x and pixel_pos.y < size.y);

        sf.c.sfImage_setPixel(self.ptr, pixel_pos.x, pixel_pos.y, color.toCSFML());
    }

    /// Gets the size of this image
    pub fn getSize(self: Self) sf.Vector2u {
        // This is a hack
        _ = sf.c.sfImage_getSize(self.ptr);
        // Register Rax holds the return val of function calls that can fit in a register
        const rax: usize = asm volatile (""
            : [ret] "={rax}" (-> usize)
        );
        var x: u32 = @truncate(u32, (rax & 0x00000000FFFFFFFF) >> 00);
        var y: u32 = @truncate(u32, (rax & 0xFFFFFFFF00000000) >> 32);
        return sf.Vector2u{ .x = x, .y = y };
    }

    /// Pointer to the csfml texture
    ptr: *sf.c.sfImage
};

const tst = std.testing;
const allocator = std.heap.page_allocator;

test "image: sane getters and setters" {
    var pixel_data = try allocator.alloc(sf.Color, 30);
    defer allocator.free(pixel_data);

    for (pixel_data) |c, i| {
        pixel_data[i] = sf.Color.fromHSVA(@intToFloat(f32, i) / 30 * 360, 100, 100, 1);
    }

    var img = try sf.Image.initFromPixels(.{.x = 5, .y = 6}, pixel_data);
    defer img.deinit();

    tst.expectEqual(sf.Vector2u{.x = 5, .y = 6}, img.getSize());

    img.setPixel(.{.x = 1, .y = 2}, sf.Color.Cyan);
    //tst.expectEqual(sf.Color.Cyan, img.getPixel(.{.x = 1, .y = 2}));

    var tex = try sf.Texture.initFromImage(img, null);
    defer tex.deinit();
}
