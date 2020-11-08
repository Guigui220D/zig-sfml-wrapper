//! Image living on the graphics card that can be used for drawing.

const sf = @import("../sfml.zig");

const TextureType = enum {
    ptr, const_ptr
};

pub const Texture = union(TextureType) {
    const Self = @This();

    // Constructor/destructor

    /// Creates a texture from nothing
    pub fn init(size: sf.Vector2u) !Self {
        var tex = sf.c.sfTexture_create(@intCast(c_uint, size.x), @intCast(c_uint, size.y));
        if (tex == null)
            return sf.Error.nullptrUnknownReason;
        return Self{ .ptr = tex.? };
    }
    /// Loads a texture from a file
    pub fn initFromFile(path: [:0]const u8) !Self {
        var tex = sf.c.sfTexture_createFromFile(path, null);
        if (tex == null)
            return sf.Error.resourceLoadingError;
        return Self{ .ptr = tex.? };
    }
    /// Destroys a texture
    /// Be careful, you can only destroy non const textures
    pub fn deinit(self: Self) void {
        // TODO : is it possible to detect that comptime?
        // Should this panic?
        if (self == .const_ptr)
            @panic("Can't destroy a const texture pointer");
        sf.c.sfTexture_destroy(self.ptr);
    }

    // Getters/Setters

    /// Gets a const pointer to this texture
    pub fn get(self: Self) *const sf.c.sfTexture {
        return switch (self) {
            .ptr => self.ptr,
            .const_ptr => self.const_ptr,
        };
    }
    /// Clones this texture (the clone won't be const)
    pub fn copy(self: Self) !Self {
        var cpy = sf.c.sfTexture_copy(self.get());
        if (cpy == null)
            return sf.Error.nullptrUnknownReason;
        return Self{ .ptr = cpy.? };
    }

    /// Gets the size of this image
    pub fn getSize(self: Self) sf.Vector2u {
        // This is a hack
        _ = sf.c.sfTexture_getSize(self.get());
        // Register Rax holds the return val of function calls that can fit in a register
        const rax: usize = asm volatile (""
            : [ret] "={rax}" (-> usize)
        );
        var x: u32 = @truncate(u32, (rax & 0x00000000FFFFFFFF) >> 00);
        var y: u32 = @truncate(u32, (rax & 0xFFFFFFFF00000000) >> 32);
        return sf.Vector2u{.x = x, .y = y};
    }
    /// Gets the pixel count of this image
    pub fn getPixelCount(self: Self) usize {
        var dim = self.getSize();
        return dim.x * dim.y;
    }

    /// Updates the pixels of the image from an array of pixels (colors)
    pub fn updateFromPixels(self: Self, pixels: []const sf.Color, zone: ?sf.UintRect) !void {
        if (self == .const_ptr)
            @panic("Can't set pixels on a const texture");

        var real_zone: sf.UintRect = undefined;
        var size = self.getSize();

        if (zone) |z| {
            // Check if the given zone is fully inside the image
            var intersection = z.intersects(sf.UintRect.init(0, 0, size.x, size.y));

            if (intersection) |i| {
                if (!i.equals(z))
                    return sf.Error.areaDoesNotFit;
            }
            else 
                return sf.Error.areaDoesNotFit;

            real_zone = z;
        }
        else {
            real_zone.left = 0;
            real_zone.top = 0;
            real_zone.width = size.x;
            real_zone.height = size.y;
        }
        // Check if there is enough data
        if (pixels.len < real_zone.width * real_zone.height)
            return sf.Error.notEnoughData;
        
        sf.c.sfTexture_updateFromPixels(self.ptr, @ptrCast([*]const u8, pixels.ptr), real_zone.width, real_zone.height, real_zone.left, real_zone.top); 
    }

    // TODO: many things

    /// Pointer to the csfml texture
    ptr: *sf.c.sfTexture,
    /// Const pointer to the csfml texture
    const_ptr: *const sf.c.sfTexture
};
