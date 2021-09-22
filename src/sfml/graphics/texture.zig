//! Image living on the graphics card that can be used for drawing.

const sf = struct {
    pub usingnamespace @import("../sfml.zig");
    pub usingnamespace sf.system;
    pub usingnamespace sf.graphics;
};

const std = @import("std");
const assert = std.debug.assert;

const TextureType = enum { _ptr, _const_ptr };

pub const Texture = union(TextureType) {
    const Self = @This();

    // Constructor/destructor

    /// Creates a texture from nothing
    pub fn create(size: sf.Vector2u) !Self {
        var tex = sf.c.sfTexture_create(@intCast(c_uint, size.x), @intCast(c_uint, size.y));
        if (tex == null)
            return sf.Error.nullptrUnknownReason;
        return Self{ ._ptr = tex.? };
    }
    /// Loads a texture from a file
    pub fn createFromFile(path: [:0]const u8) !Self {
        var tex = sf.c.sfTexture_createFromFile(path, null);
        if (tex == null)
            return sf.Error.resourceLoadingError;
        return Self{ ._ptr = tex.? };
    }
    /// Creates an texture from an image
    pub fn createFromImage(image: sf.Image, area: ?sf.IntRect) !Self {
        var tex = if (area) |a|
            sf.c.sfTexture_createFromImage(image._ptr, &a._toCSFML())
        else
            sf.c.sfTexture_createFromImage(image._ptr, null);

        if (tex == null)
            return sf.Error.nullptrUnknownReason;
        return Self{ ._ptr = tex.? };
    }

    /// Destroys a texture
    /// Be careful, you can only destroy non const textures
    pub fn destroy(self: Self) void {
        // TODO : is it possible to detect that comptime?
        // Should this panic?
        if (self == ._const_ptr)
            @panic("Can't destroy a const texture pointer");
        sf.c.sfTexture_destroy(self._ptr);
    }

    // Getters/Setters

    /// Gets a const pointer to this texture
    pub fn get(self: Self) *const sf.c.sfTexture {
        return switch (self) {
            ._ptr => self._ptr,
            ._const_ptr => self._const_ptr,
        };
    }
    /// Clones this texture (the clone won't be const)
    pub fn copy(self: Self) !Self {
        var cpy = sf.c.sfTexture_copy(self.get());
        if (cpy == null)
            return sf.Error.nullptrUnknownReason;
        return Self{ ._ptr = cpy.? };
    }
    /// Makes this texture constant (I don't know why you would do that)
    pub fn makeConst(self: *Self) void {
        self.* = Self{ ._const_ptr = self.get() };
    }

    /// Gets the size of this image
    pub fn getSize(self: Self) sf.Vector2u {
        const size = sf.c.sfTexture_getSize(self.get());
        return sf.Vector2u{ .x = size.x, .y = size.y };
    }
    /// Gets the pixel count of this image
    pub fn getPixelCount(self: Self) usize {
        var dim = self.getSize();
        return dim.x * dim.y;
    }

    /// Updates the pixels of the image from an array of pixels (colors)
    pub fn updateFromPixels(self: Self, pixels: []const sf.Color, zone: ?sf.Rect(c_uint)) !void {
        if (self == ._const_ptr)
            @panic("Can't set pixels on a const texture");
        if (self.isSrgb())
            @panic("Updating an srgb from a pixel array isn't implemented");

        var real_zone: sf.Rect(c_uint) = undefined;
        var size = self.getSize();

        if (zone) |z| {
            // Check if the given zone is fully inside the image
            var intersection = z.intersects(sf.Rect(c_uint).init(0, 0, size.x, size.y));

            if (intersection) |i| {
                if (!i.equals(z))
                    return sf.Error.areaDoesNotFit;
            } else return sf.Error.areaDoesNotFit;

            real_zone = z;
        } else {
            real_zone.left = 0;
            real_zone.top = 0;
            real_zone.width = size.x;
            real_zone.height = size.y;
        }
        // Check if there is enough data
        if (pixels.len < real_zone.width * real_zone.height)
            return sf.Error.notEnoughData;

        sf.c.sfTexture_updateFromPixels(self._ptr, @ptrCast([*]const u8, pixels.ptr), real_zone.width, real_zone.height, real_zone.left, real_zone.top);
    }
    /// Updates the pixels of the image from an other texture
    pub fn updateFromTexture(self: Self, other: Texture, copy_pos: ?sf.Vector2u) void {
        var pos = if (copy_pos) |a| a else sf.Vector2u{ .x = 0, .y = 0 };
        var max = other.getSize().add(pos);
        var size = self.getSize();

        assert(max.x < size.x and max.y < size.y);

        sf.c.sfTexture_updateFromTexture(self._ptr, other.get(), pos.x, pos.y);
    }
    /// Updates the pixels of the image from an image
    pub fn updateFromImage(self: Self, image: sf.Image, copy_pos: ?sf.Vector2u) void {
        var pos = if (copy_pos) |a| a else sf.Vector2u{ .x = 0, .y = 0 };
        var max = image.getSize().add(pos);
        var size = self.getSize();

        assert(max.x < size.x and max.y < size.y);

        sf.c.sfTexture_updateFromImage(self._ptr, image._ptr, pos.x, pos.y);
    }

    /// Tells whether or not this texture is to be smoothed
    pub fn isSmooth(self: Self) bool {
        return sf.c.sfTexture_isSmooth(self._ptr) != 0;
    }
    /// Enables or disables texture smoothing
    pub fn setSmooth(self: Self, smooth: bool) void {
        if (self == ._const_ptr)
            @panic("Can't set properties on a const texture");

        sf.c.sfTexture_setSmooth(self._ptr, if (smooth) 1 else 0);
    }

    /// Tells whether or not this texture should repeat when rendering outside its bounds
    pub fn isRepeated(self: Self) bool {
        return sf.c.sfTexture_isRepeated(self._ptr) != 0;
    }
    /// Enables or disables texture repeating
    pub fn setRepeated(self: Self, repeated: bool) void {
        if (self == ._const_ptr)
            @panic("Can't set properties on a const texture");

        sf.c.sfTexture_setRepeated(self._ptr, if (repeated) 1 else 0);
    }

    /// Tells whether or not this texture has colors in the SRGB format
    /// SRGB functions arent implemented yet
    pub fn isSrgb(self: Self) bool {
        return sf.c.sfTexture_isSrgb(self._ptr) != 0;
    }
    /// Enables or disables SRGB
    pub fn setSrgb(self: Self, srgb: bool) void {
        if (self == ._const_ptr)
            @panic("Can't set properties on a const texture");

        sf.c.sfTexture_setSrgb(self._ptr, if (srgb) 1 else 0);
    }

    /// Swaps this texture's contents with an other texture
    pub fn swap(self: Self, other: Texture) void {
        if (self == ._const_ptr or other == ._const_ptr)
            @panic("Texture swapping must be done between two non const textures");

        sf.c.sfTexture_swap(self._ptr, other._ptr);
    }

    /// Pointer to the csfml texture
    _ptr: *sf.c.sfTexture,
    /// Const pointer to the csfml texture
    _const_ptr: *const sf.c.sfTexture
};

test "texture: sane getters and setters" {
    const tst = std.testing;
    const allocator = std.heap.page_allocator;

    var tex = try Texture.create(.{ .x = 12, .y = 10 });
    defer tex.destroy();

    var size = tex.getSize();

    tex.setSrgb(false);
    tex.setSmooth(true);
    tex.setRepeated(true);

    try tst.expectEqual(@as(u32, 12), size.x);
    try tst.expectEqual(@as(u32, 10), size.y);
    try tst.expectEqual(@as(usize, 120), tex.getPixelCount());

    var pixel_data = try allocator.alloc(sf.Color, 120);
    defer allocator.free(pixel_data);

    for (pixel_data) |*c, i| {
        c.* = sf.graphics.Color.fromHSVA(@intToFloat(f32, i) / 144 * 360, 100, 100, 1);
    }

    try tex.updateFromPixels(pixel_data, null);

    try tst.expect(!tex.isSrgb());
    try tst.expect(tex.isSmooth());
    try tst.expect(tex.isRepeated());

    var t = tex;
    t.makeConst();

    var copy = try t.copy();

    try tst.expectEqual(@as(usize, 120), copy.getPixelCount());

    var tex2 = try Texture.create(.{ .x = 100, .y = 100 });
    defer tex2.destroy();

    copy.swap(tex2);

    try tst.expectEqual(@as(usize, 100 * 100), copy.getPixelCount());
    try tst.expectEqual(@as(usize, 120), tex2.getPixelCount());
}
