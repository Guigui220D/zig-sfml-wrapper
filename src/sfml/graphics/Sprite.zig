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

    return Sprite{ ._ptr = sprite.? };
}

/// Inits a sprite with a texture
pub fn createFromTexture(texture: sf.Texture) !Sprite {
    var sprite = sf.c.sfSprite_create();
    if (sprite == null)
        return sf.Error.nullptrUnknownReason;

    sf.c.sfSprite_setTexture(sprite, texture._get(), 1);

    return Sprite{ ._ptr = sprite.? };
}

/// Destroys this sprite
pub fn destroy(self: *Sprite) void {
    sf.c.sfSprite_destroy(self._ptr);
    self._ptr = undefined;
}

// Draw function
/// The draw function of this sprite
/// Meant to be called by your_target.draw(your_sprite, .{});
pub fn sfDraw(self: Sprite, target: anytype, states: ?*sf.c.sfRenderStates) void {
    switch (@TypeOf(target)) {
        sf.RenderWindow => sf.c.sfRenderWindow_drawSprite(target._ptr, self._ptr, states),
        sf.RenderTexture => sf.c.sfRenderTexture_drawSprite(target._ptr, self._ptr, states),
        else => @compileError("target must be a render target"),
    }
}

// Getters/setters

/// Gets the position of this sprite
pub fn getPosition(self: Sprite) sf.Vector2f {
    return sf.Vector2f._fromCSFML(sf.c.sfSprite_getPosition(self._ptr));
}
/// Sets the position of this sprite
pub fn setPosition(self: *Sprite, pos: sf.Vector2f) void {
    sf.c.sfSprite_setPosition(self._ptr, pos._toCSFML());
}
/// Adds the offset to this shape's position
pub fn move(self: *Sprite, offset: sf.Vector2f) void {
    sf.c.sfSprite_move(self._ptr, offset._toCSFML());
}

/// Gets the scale of this sprite
pub fn getScale(self: Sprite) sf.Vector2f {
    return sf.Vector2f._fromCSFML(sf.c.sfSprite_getScale(self._ptr));
}
/// Sets the scale of this sprite
pub fn setScale(self: *Sprite, factor: sf.Vector2f) void {
    sf.c.sfSprite_setScale(self._ptr, factor._toCSFML());
}
/// Scales this sprite
pub fn scale(self: *Sprite, factor: sf.Vector2f) void {
    sf.c.sfSprite_scale(self._ptr, factor._toCSFML());
}

/// Gets the origin of this sprite
pub fn getOrigin(self: Sprite) sf.Vector2f {
    return sf.Vector2f._fromCSFML(sf.c.sfSprite_getOrigin(self._ptr));
}
/// Sets the origin of this sprite
pub fn setOrigin(self: *Sprite, origin: sf.Vector2f) void {
    sf.c.sfSprite_setOrigin(self._ptr, origin._toCSFML());
}

/// Gets the rotation of this sprite
pub fn getRotation(self: Sprite) f32 {
    return sf.c.sfSprite_getRotation(self._ptr);
}
/// Sets the rotation of this sprite
pub fn setRotation(self: *Sprite, angle: f32) void {
    sf.c.sfSprite_setRotation(self._ptr, angle);
}
/// Rotates this shape by a given amount
pub fn rotate(self: *Sprite, angle: f32) void {
    sf.c.sfSprite_rotate(self._ptr, angle);
}

/// Gets the color of this sprite
pub fn getColor(self: Sprite) sf.Color {
    return sf.Color._fromCSFML(sf.c.sfSprite_getColor(self._ptr));
}
/// Sets the color of this sprite
pub fn setColor(self: *Sprite, color: sf.Color) void {
    sf.c.sfSprite_setColor(self._ptr, color._toCSFML());
}

/// Gets the texture of this shape
pub fn getTexture(self: Sprite) ?sf.Texture {
    const t = sf.c.sfSprite_getTexture(self._ptr);
    if (t) |tex| {
        return sf.Texture{ ._const_ptr = tex };
    } else return null;
}
/// Sets this sprite's texture (the sprite will take the texture's dimensions)
pub fn setTexture(self: *Sprite, texture: ?sf.Texture) void {
    var tex = if (texture) |t| t._get() else null;
    sf.c.sfSprite_setTexture(self._ptr, tex, 1);
}
/// Gets the sub-rectangle of the texture that the sprite will display
pub fn getTextureRect(self: Sprite) sf.IntRect {
    return sf.IntRect._fromCSFML(sf.c.sfSprite_getTextureRect(self._ptr));
}
/// Sets the sub-rectangle of the texture that the sprite will display
pub fn setTextureRect(self: *Sprite, rect: sf.IntRect) void {
    sf.c.sfSprite_setTextureRect(self._ptr, rect._toCSFML());
}

/// Gets the bounds in the local coordinates system
pub fn getLocalBounds(self: Sprite) sf.FloatRect {
    return sf.FloatRect._fromCSFML(sf.c.sfSprite_getLocalBounds(self._ptr));
}

/// Gets the bounds in the global coordinates
pub fn getGlobalBounds(self: Sprite) sf.FloatRect {
    return sf.FloatRect._fromCSFML(sf.c.sfSprite_getGlobalBounds(self._ptr));
}

/// Pointer to the csfml structure
_ptr: *sf.c.sfSprite,

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
