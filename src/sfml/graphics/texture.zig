//! Image living on the graphics card that can be used for drawing.

usingnamespace @import("../sfml_import.zig");
const sf = @import("../sfml.zig");

pub const Texture = struct {
    const Self = @This();

    // Constructor/destructor

    // TODO : create from image
    // TODO : create from stream
    // TODO : create from memory
    /// Creates a texture from nothing
    pub fn init(size: sf.Vector2u) !Self {
        var tex = Sf.sfTexture_create(@intCast(c_uint, size.x), @intCast(c_uint, size.y));
        if (tex == null)
            return sf.Error.nullptrUnknownReason;
        return Self{.ptr = tex};
    }
    /// Loads a texture from a file
    pub fn initFromFile(path: [:0]const u8) !Self {
        var tex = Sf.sfTexture_createFromFile(path, null);
        if (tex == null)
            return sf.Error.resourceLoadingError;
        return Self{.ptr = tex.?};
    }

    pub fn deinit(self: Self) void {
        Sf.sfTexture_destroy(self.ptr);
    }

    // Getters/Setters

    /// Gets the size of this image
    pub fn getSize(self: Self) sf.Vector2u {
        return sf.Vector2u.fromCSFML(Sf.sfTexture_getSize(self.ptr));
    }

    // TODO: many things

    /// Pointer to the csfml structure
    ptr: *Sf.sfTexture
};
