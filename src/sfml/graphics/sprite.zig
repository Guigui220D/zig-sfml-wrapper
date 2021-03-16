//! Drawable representation of a texture, with its own transformations, color, etc.

const sf = struct {
    pub usingnamespace @import("../sfml.zig");
    pub usingnamespace system;
    pub usingnamespace graphics;
};

const Self = @This();

// Constructor/destructor

/// Inits a sprite with no texture
pub fn create() !Self {
    var sprite = sf.c.sfSprite_create();
    if (sprite == null)
        return sf.Error.nullptrUnknownReason;

    return Self{ .ptr = sprite.? };
}

/// Inits a sprite with a texture
pub fn createFromTexture(texture: sf.Texture) !Self {
    var sprite = sf.c.sfSprite_create();
    if (sprite == null)
        return sf.Error.nullptrUnknownReason;

    sf.c.sfSprite_setTexture(sprite, texture.get(), 1);

    return Self{ .ptr = sprite.? };
}

/// Destroys this sprite
pub fn destroy(self: Self) void {
    sf.c.sfSprite_destroy(self.ptr);
}

// Getters/setters

/// Gets the position of this sprite
pub fn getPosition(self: Self) sf.Vector2f {
    return sf.Vector2f.fromCSFML(sf.c.sfSprite_getPosition(self.ptr));
}
/// Sets the position of this sprite
pub fn setPosition(self: Self, pos: sf.Vector2f) void {
    sf.c.sfSprite_setPosition(self.ptr, pos.toCSFML());
}
/// Adds the offset to this shape's position
pub fn move(self: Self, offset: sf.Vector2f) void {
    sf.c.sfSprite_move(self.ptr, offset.toCSFML());
}

/// Gets the scale of this sprite
pub fn getScale(self: Self) sf.Vector2f {
    return sf.Vector2f.fromCSFML(sf.c.sfSprite_getScale(self.ptr));
}
/// Sets the scale of this sprite
pub fn setScale(self: Self, factor: sf.Vector2f) void {
    sf.c.sfSprite_setScale(self.ptr, factor.toCSFML());
}
/// Scales this sprite
pub fn scale(self: Self, factor: sf.Vector2f) void {
    sf.c.sfSprite_scale(self.ptr, factor.toCSFML());
}

/// Gets the origin of this sprite
pub fn getOrigin(self: Self) sf.Vector2f {
    return sf.Vector2f.fromCSFML(sf.c.sfSprite_getOrigin(self.ptr));
}
/// Sets the origin of this sprite
pub fn setOrigin(self: Self, origin: sf.Vector2f) void {
    sf.c.sfSprite_setOrigin(self.ptr, origin.toCSFML());
}

/// Gets the rotation of this sprite
pub fn getRotation(self: Self) f32 {
    return sf.c.sfSprite_getRotation(self.ptr);
}
/// Sets the rotation of this sprite
pub fn setRotation(self: Self, angle: f32) void {
    sf.c.sfSprite_setRotation(self.ptr, angle);
}
/// Rotates this shape by a given amount
pub fn rotate(self: Self, angle: f32) void {
    sf.c.sfSprite_rotate(self.ptr, angle);
}

/// Gets the color of this sprite
pub fn getColor(self: Self) sf.Color {
    return sf.Color.fromCSFML(sf.c.sfSprite_getColor(self.ptr));
}
/// Sets the color of this sprite
pub fn setColor(self: Self, color: sf.Color) void {
    sf.c.sfSprite_setColor(self.ptr, color.toCSFML());
}

/// Gets the texture of this shape
pub fn getTexture(self: Self) ?sf.Texture {
    var t = sf.c.sfSprite_getTexture(self.ptr);
    if (t != null) {
        return sf.Texture{ .const_ptr = t.? };
    } else
        return null;
}
/// Sets this sprite's texture (the sprite will take the texture's dimensions)
pub fn setTexture(self: Self, texture: ?sf.Texture) void {
    var tex = if (texture) |t| t.get() else null;
    sf.c.sfSprite_setTexture(self.ptr, tex, 1);
}
/// Gets the sub-rectangle of the texture that the sprite will display
pub fn getTextureRect(self: Self) sf.FloatRect {
    return sf.FloatRect.fromCSFML(sf.c.sfSprite_getTextureRect(self.ptr));
}
/// Sets the sub-rectangle of the texture that the sprite will display
pub fn setTextureRect(self: Self, rect: sf.FloatRect) void {
    sf.c.sfSprite_getCircleRect(self.ptr, rect.toCSFML());
}

/// Pointer to the csfml structure
ptr: *sf.c.sfSprite,

test "sprite: sane getters and setters" {
    const tst = @import("std").testing;
    
    var spr = try Sprite.init();
    defer spr.deinit();

    spr.setColor(sf.Color.Yellow);
    spr.setRotation(15);
    spr.setPosition(.{ .x = 1, .y = 2 });
    spr.setOrigin(.{ .x = 20, .y = 25 });
    spr.setScale(.{ .x = 2, .y = 2 });

    // TODO : issue #2
    //tst.expectEqual(sf.Color.Yellow, spr.getColor());
    tst.expectEqual(sf.Vector2f{ .x = 1, .y = 2 }, spr.getPosition());
    tst.expectEqual(sf.Vector2f{ .x = 20, .y = 25 }, spr.getOrigin());
    tst.expectEqual(@as(?sf.Texture, null), spr.getTexture());
    tst.expectEqual(sf.Vector2f{ .x = 2, .y = 2 }, spr.getScale());

    spr.rotate(5);
    spr.move(.{ .x = -5, .y = 5 });
    spr.scale(.{ .x = 5, .y = 5 });

    tst.expectEqual(@as(f32, 20), spr.getRotation());
    tst.expectEqual(sf.Vector2f{ .x = -4, .y = 7 }, spr.getPosition());
    tst.expectEqual(sf.Vector2f{ .x = 10, .y = 10 }, spr.getScale());
}
