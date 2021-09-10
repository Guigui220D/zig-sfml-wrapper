//! Drawable representation of a texture, with its own transformations, color, etc.

const sf = struct {
    pub usingnamespace @import("../sfml.zig");
    pub usingnamespace sf.system;
    pub usingnamespace sf.graphics;
};

const Sprite = @This();

// Constructor/destructor

/// Inits a sprite with no texture
pub fn create() !Sprite {
    var sprite = sf.c.sfSprite_create();
    if (sprite == null)
        return sf.Error.nullptrUnknownReason;

    return Sprite{ .ptr = sprite.? };
}

/// Inits a sprite with a texture
pub fn createFromTexture(texture: sf.Texture) !Sprite {
    var sprite = sf.c.sfSprite_create();
    if (sprite == null)
        return sf.Error.nullptrUnknownReason;

    sf.c.sfSprite_setTexture(sprite, texture.get(), 1);

    return Sprite{ .ptr = sprite.? };
}

/// Destroys this sprite
pub fn destroy(self: Sprite) void {
    sf.c.sfSprite_destroy(self.ptr);
}

// Draw function
pub fn sfDraw(self: Sprite, window: sf.RenderWindow, states: ?*sf.c.sfRenderStates) void {
    sf.c.sfRenderWindow_drawSprite(window.ptr, self.ptr, states);
}

// Getters/setters

/// Gets the position of this sprite
pub fn getPosition(self: Sprite) sf.Vector2f {
    return sf.Vector2f.fromCSFML(sf.c.sfSprite_getPosition(self.ptr));
}
/// Sets the position of this sprite
pub fn setPosition(self: Sprite, pos: sf.Vector2f) void {
    sf.c.sfSprite_setPosition(self.ptr, pos.toCSFML());
}
/// Adds the offset to this shape's position
pub fn move(self: Sprite, offset: sf.Vector2f) void {
    sf.c.sfSprite_move(self.ptr, offset.toCSFML());
}

/// Gets the scale of this sprite
pub fn getScale(self: Sprite) sf.Vector2f {
    return sf.Vector2f.fromCSFML(sf.c.sfSprite_getScale(self.ptr));
}
/// Sets the scale of this sprite
pub fn setScale(self: Sprite, factor: sf.Vector2f) void {
    sf.c.sfSprite_setScale(self.ptr, factor.toCSFML());
}
/// Scales this sprite
pub fn scale(self: Sprite, factor: sf.Vector2f) void {
    sf.c.sfSprite_scale(self.ptr, factor.toCSFML());
}

/// Gets the origin of this sprite
pub fn getOrigin(self: Sprite) sf.Vector2f {
    return sf.Vector2f.fromCSFML(sf.c.sfSprite_getOrigin(self.ptr));
}
/// Sets the origin of this sprite
pub fn setOrigin(self: Sprite, origin: sf.Vector2f) void {
    sf.c.sfSprite_setOrigin(self.ptr, origin.toCSFML());
}

/// Gets the rotation of this sprite
pub fn getRotation(self: Sprite) f32 {
    return sf.c.sfSprite_getRotation(self.ptr);
}
/// Sets the rotation of this sprite
pub fn setRotation(self: Sprite, angle: f32) void {
    sf.c.sfSprite_setRotation(self.ptr, angle);
}
/// Rotates this shape by a given amount
pub fn rotate(self: Sprite, angle: f32) void {
    sf.c.sfSprite_rotate(self.ptr, angle);
}

/// Gets the color of this sprite
pub fn getColor(self: Sprite) sf.Color {
    return sf.Color.fromCSFML(sf.c.sfSprite_getColor(self.ptr));
}
/// Sets the color of this sprite
pub fn setColor(self: Sprite, color: sf.Color) void {
    sf.c.sfSprite_setColor(self.ptr, color.toCSFML());
}

/// Gets the texture of this shape
pub fn getTexture(self: Sprite) ?sf.Texture {
    const t = sf.c.sfSprite_getTexture(self.ptr);
    if (t) |tex| {
        return sf.Texture{ .const_ptr = tex };
    } else return null;
}
/// Sets this sprite's texture (the sprite will take the texture's dimensions)
pub fn setTexture(self: Sprite, texture: ?sf.Texture) void {
    var tex = if (texture) |t| t.get() else null;
    sf.c.sfSprite_setTexture(self.ptr, tex, 1);
}
/// Gets the sub-rectangle of the texture that the sprite will display
pub fn getTextureRect(self: Sprite) sf.IntRect {
    return sf.IntRect.fromCSFML(sf.c.sfSprite_getTextureRect(self.ptr));
}
/// Sets the sub-rectangle of the texture that the sprite will display
pub fn setTextureRect(self: Sprite, rect: sf.IntRect) void {
    sf.c.sfSprite_setTextureRect(self.ptr, rect.toCSFML());
}

/// Pointer to the csfml structure
ptr: *sf.c.sfSprite,

test "sprite: sane getters and setters" {
    const tst = @import("std").testing;

    var spr = try Sprite.create();
    defer spr.destroy();

    spr.setColor(sf.Color.Yellow);
    spr.setRotation(15);
    spr.setPosition(.{ .x = 1, .y = 2 });
    spr.setOrigin(.{ .x = 20, .y = 25 });
    spr.setScale(.{ .x = 2, .y = 2 });
    spr.setTexture(null);

    try tst.expectEqual(sf.Color.Yellow, spr.getColor());
    try tst.expectEqual(sf.Vector2f{ .x = 1, .y = 2 }, spr.getPosition());
    try tst.expectEqual(sf.Vector2f{ .x = 20, .y = 25 }, spr.getOrigin());
    try tst.expectEqual(@as(?sf.Texture, null), spr.getTexture());
    try tst.expectEqual(sf.Vector2f{ .x = 2, .y = 2 }, spr.getScale());

    spr.rotate(5);
    spr.move(.{ .x = -5, .y = 5 });
    spr.scale(.{ .x = 5, .y = 5 });

    try tst.expectEqual(@as(f32, 20), spr.getRotation());
    try tst.expectEqual(sf.Vector2f{ .x = -4, .y = 7 }, spr.getPosition());
    try tst.expectEqual(sf.Vector2f{ .x = 10, .y = 10 }, spr.getScale());
}
