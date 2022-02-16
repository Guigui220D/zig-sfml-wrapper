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
    // Constructor/destructor

    /// Creates a texture from nothing
    pub fn create(size: sf.Vector2u) !Texture {
        const tex = sf.c.sfTexture_create(@intCast(c_uint, size.x), @intCast(c_uint, size.y));
        if (tex) |t| {
            return Texture{ ._ptr = t };
        } else return sf.Error.resourceLoadingError;
    }
    /// Loads a texture from a file
    pub fn createFromFile(path: [:0]const u8) !Texture {
        const tex = sf.c.sfTexture_createFromFile(path, null);
        if (tex) |t| {
            return Texture{ ._ptr = t };
        } else return sf.Error.resourceLoadingError;
    }
    /// Loads a texture from a file in memory
    pub fn createFromMemory(data: []const u8) !Texture {
        const tex = sf.c.sfTexture_createFromMemory(@ptrCast(?*const anyopaque, data.ptr), data.len);
        if (tex) |t| {
            return Texture{ ._ptr = t };
        } else return sf.Error.resourceLoadingError;
    }
    /// Creates an texture from an image
    pub fn createFromImage(image: sf.Image, area: ?sf.IntRect) !Texture {
        const tex = if (area) |a|
            sf.c.sfTexture_createFromImage(image._ptr, &a._toCSFML())
        else
            sf.c.sfTexture_createFromImage(image._ptr, null);

        if (tex) |t| {
            return Texture{ ._ptr = t };
        } else return sf.Error.nullptrUnknownReason;
    }

    /// Destroys a texture
    /// Be careful, you can only destroy non const textures
    pub fn destroy(self: *Texture) void {
        // TODO: is it possible to detect that comptime?
        if (self.* == ._ptr) {
            sf.c.sfTexture_destroy(self._ptr);
        } else
            std.debug.print("SFML Debug: Trying to destroy a const texture!", .{});
        
        self._ptr = undefined;
    }

    // Getters/Setters

    /// Gets a const pointer to this texture
    /// For inner workings
    pub fn _get(self: Texture) *const sf.c.sfTexture {
        return switch (self) {
            ._ptr => self._ptr,
            ._const_ptr => self._const_ptr,
        };
    }

    /// Clones this texture (the clone won't be const)
    pub fn copy(self: Texture) !Texture {
        const cpy = sf.c.sfTexture_copy(self._get());
        if (cpy == null)
            return sf.Error.nullptrUnknownReason;
        return Texture{ ._ptr = cpy.? };
    }
    /// Copy this texture to an image in ram
    pub fn copyToImage(self: Texture) sf.Image {
        return .{ ._ptr = sf.c.sfTexture_copyToImage(self._get()).? };
    }

    /// Makes this texture constant (I don't know why you would do that)
    pub fn makeConst(self: *Texture) void {
        self.* = Texture{ ._const_ptr = self._get() };
    }

    /// Gets a const reference to this texture
    pub fn getConst(self: Texture) void {
        var cpy = self;
        cpy.makeConst();
        return cpy;
    }

    /// Gets the size of this image
    pub fn getSize(self: Texture) sf.Vector2u {
        const size = sf.c.sfTexture_getSize(self._get());
        return sf.Vector2u{ .x = size.x, .y = size.y };
    }
    /// Gets the pixel count of this image
    pub fn getPixelCount(self: Texture) usize {
        const dim = self.getSize();
        return dim.x * dim.y;
    }

    /// Updates the pixels of the image from an array of pixels (colors)
    pub fn updateFromPixels(self: *Texture, pixels: []const sf.Color, zone: ?sf.Rect(c_uint)) !void {
        if (self.* == ._const_ptr)
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
    pub fn updateFromTexture(self: *Texture, other: Texture, copy_pos: ?sf.Vector2u) void {
        if (self == ._const_ptr)
            @panic("Can't set pixels on a const texture");

        var pos = if (copy_pos) |a| a else sf.Vector2u{ .x = 0, .y = 0 };
        var max = other.getSize().add(pos);
        var size = self.getSize();

        assert(max.x <= size.x and max.y <= size.y);

        sf.c.sfTexture_updateFromTexture(self._ptr, other._get(), pos.x, pos.y);
    }
    /// Updates the pixels of the image from an image
    pub fn updateFromImage(self: *Texture, image: sf.Image, copy_pos: ?sf.Vector2u) void {
        if (self.* == ._const_ptr)
            @panic("Can't set pixels on a const texture");

        var pos = if (copy_pos) |a| a else sf.Vector2u{ .x = 0, .y = 0 };
        var max = image.getSize().add(pos);
        var size = self.getSize();

        assert(max.x <= size.x and max.y <= size.y);

        sf.c.sfTexture_updateFromImage(self._ptr, image._ptr, pos.x, pos.y);
    }

    /// Tells whether or not this texture is to be smoothed
    pub fn isSmooth(self: Texture) bool {
        return sf.c.sfTexture_isSmooth(self._ptr) != 0;
    }
    /// Enables or disables texture smoothing
    pub fn setSmooth(self: *Texture, smooth: bool) void {
        if (self.* == ._const_ptr)
            @panic("Can't set properties on a const texture");

        sf.c.sfTexture_setSmooth(self._ptr, @boolToInt(smooth));
    }

    /// Tells whether or not this texture should repeat when rendering outside its bounds
    pub fn isRepeated(self: Texture) bool {
        return sf.c.sfTexture_isRepeated(self._ptr) != 0;
    }
    /// Enables or disables texture repeating
    pub fn setRepeated(self: *Texture, repeated: bool) void {
        if (self.* == ._const_ptr)
            @panic("Can't set properties on a const texture");

        sf.c.sfTexture_setRepeated(self._ptr, @boolToInt(repeated));
    }

    /// Tells whether or not this texture has colors in the SRGB format
    /// SRGB functions arent implemented yet
    pub fn isSrgb(self: Texture) bool {
        return sf.c.sfTexture_isSrgb(self._ptr) != 0;
    }
    /// Enables or disables SRGB
    pub fn setSrgb(self: *Texture, srgb: bool) void {
        if (self.* == ._const_ptr)
            @panic("Can't set properties on a const texture");

        sf.c.sfTexture_setSrgb(self._ptr, @boolToInt(srgb));
    }

    /// Swaps this texture's contents with an other texture
    pub fn swap(self: *Texture, other: *Texture) void {
        if (self.* == ._const_ptr or other.* == ._const_ptr)
            @panic("Texture swapping must be done between two non const textures");

        sf.c.sfTexture_swap(self._ptr, other._ptr);
    }

    // Others

    /// Generates a mipmap for the current texture data, returns true if the operation succeeded
    pub fn generateMipmap(self: *Texture) bool {
        if (self == ._const_ptr)
            @panic("Can't act on a const texture");

        return sf.c.sfTexture_generateMipmap(self._ptr) != 0;
    }

    /// Pointer to the csfml texture
    _ptr: *sf.c.sfTexture,
    /// Const pointer to the csfml texture
    _const_ptr: *const sf.c.sfTexture,
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

    pixel_data[0] = sf.Color.Green;

    try tex.updateFromPixels(pixel_data, null);

    try tst.expect(!tex.isSrgb());
    try tst.expect(tex.isSmooth());
    try tst.expect(tex.isRepeated());

    var img = tex.copyToImage();
    defer img.destroy();

    try tst.expectEqual(sf.Color.Green, img.getPixel(.{ .x = 0, .y = 0 }));

    tex.updateFromImage(img, null);

    var t = tex;
    t.makeConst();

    var copy = try t.copy();

    try tst.expectEqual(@as(usize, 120), copy.getPixelCount());

    var tex2 = try Texture.create(.{ .x = 100, .y = 100 });
    defer tex2.destroy();

    copy.swap(&tex2);

    try tst.expectEqual(@as(usize, 100 * 100), copy.getPixelCount());
    try tst.expectEqual(@as(usize, 120), tex2.getPixelCount());
}
