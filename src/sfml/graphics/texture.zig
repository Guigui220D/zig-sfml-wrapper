//! Image living on the graphics card that can be used for drawing.

const sf = @import("../sfml.zig");

const TextureType = enum {
    ptr, const_ptr
};

pub const Texture = union(TextureType) {
    const Self = @This();

    // Constructor/destructor

    // TODO : create from image
    // TODO : create from stream
    // TODO : create from memory
    /// Creates a texture from nothing
    pub fn init(size: sf.Vector2u) !Self {
        var tex = sf.c.sfTexture_create(@intCast(c_uint, size.x), @intCast(c_uint, size.y));
        if (tex == null)
            return sf.Error.nullptrUnknownReason;
        return Self{ .ptr = tex };
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
        return sf.Vector2u.fromCSFML(sf.c.sfTexture_getSize(self.get()));
    }

    // TODO: many things

    /// Pointer to the csfml structure
    ptr: *sf.c.sfTexture,
    const_ptr: *const sf.c.sfTexture
};
