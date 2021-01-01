//! Specialized shape representing a circle.

const sf = @import("../sfml.zig");

pub const CircleShape = struct {
    const Self = @This();

    // Constructor/destructor

    /// Inits a circle shape with a radius. The circle will be white and have 30 points
    pub fn init(radius: f32) !Self {
        var circle = sf.c.sfCircleShape_create();
        if (circle == null)
            return sf.Error.nullptrUnknownReason;

        sf.c.sfCircleShape_setFillColor(circle, sf.c.sfWhite);
        sf.c.sfCircleShape_setRadius(circle, radius);

        return Self{ .ptr = circle.? };
    }

    /// Destroys a circle shape
    pub fn deinit(self: Self) void {
        sf.c.sfCircleShape_destroy(self.ptr);
    }

    // Getters/setters

    /// Gets the fill color of this circle shape
    pub fn getFillColor(self: Self) sf.Color {
        _ = sf.c.sfCircleShape_getFillColor(self.ptr);

        // Register Rax holds the return val of function calls that can fit in a register
        const rax: usize = asm volatile (""
            : [ret] "={rax}" (-> usize)
        );

        std.debug.print("{}\n", rax);
        
        var x: u32 = @truncate(u32, (rax & 0x00000000FFFFFFFF) >> 00);
        var y: u32 = @truncate(u32, (rax & 0xFFFFFFFF00000000) >> 32);
        return sf.Color.fromInteger(x);
    }
    /// Sets the fill color of this circle shape
    pub fn setFillColor(self: Self, color: sf.Color) void {
        sf.c.sfCircleShape_setFillColor(self.ptr, color.toCSFML());
    }

    /// Gets the radius of this circle shape
    pub fn getRadius(self: Self) f32 {
        return sf.c.sfCircleShape_getRadius(self.ptr);
    }
    /// Sets the radius of this circle shape
    pub fn setRadius(self: Self, radius: f32) void {
        sf.c.sfCircleShape_setRadius(self.ptr, radius);
    }

    /// Gets the position of this circle shape
    pub fn getPosition(self: Self) sf.Vector2f {
        return sf.Vector2f.fromCSFML(sf.c.sfCircleShape_getPosition(self.ptr));
    }
    /// Sets the position of this circle shape
    pub fn setPosition(self: Self, pos: sf.Vector2f) void {
        sf.c.sfCircleShape_setPosition(self.ptr, pos.toCSFML());
    }
    /// Adds the offset to this shape's position
    pub fn move(self: Self, offset: sf.Vector2f) void {
        sf.c.sfCircleShape_move(self.ptr, offset.toCSFML());
    }

    /// Gets the origin of this circle shape
    pub fn getOrigin(self: Self) sf.Vector2f {
        return sf.Vector2f.fromCSFML(sf.c.sfCircleShape_getOrigin(self.ptr));
    }
    /// Sets the origin of this circle shape
    pub fn setOrigin(self: Self, origin: sf.Vector2f) void {
        sf.c.sfCircleShape_setOrigin(self.ptr, origin.toCSFML());
    }

    /// Gets the rotation of this circle shape
    pub fn getRotation(self: Self) f32 {
        return sf.c.sfCircleShape_getRotation(self.ptr);
    }
    /// Sets the rotation of this circle shape
    pub fn setRotation(self: Self, angle: f32) void {
        sf.c.sfCircleShape_setRotation(self.ptr, angle);
    }
    /// Rotates this shape by a given amount
    pub fn rotate(self: Self, angle: f32) void {
        sf.c.sfCircleShape_rotate(self.ptr, angle);
    }

    /// Gets the texture of this shape
    pub fn getTexture(self: Self) ?sf.Texture {
        var t = sf.c.sfCircleShape_getTexture(self.ptr);
        if (t != null) {
            return sf.Texture{ .const_ptr = t.? };
        } else
            return null;
    }
    /// Sets the texture of this shape
    pub fn setTexture(self: Self, texture: sf.Texture) void {
        sf.c.sfCircleShape_setTexture(self.ptr, texture.get(), 0);
    }
    /// Gets the sub-rectangle of the texture that the shape will display
    pub fn getTextureRect(self: Self) sf.FloatRect {
        return sf.FloatRect.fromCSFML(sf.c.sfCircleShape_getTextureRect(self.ptr));
    }
    /// Sets the sub-rectangle of the texture that the shape will display
    pub fn setTextureRect(self: Self, rect: sf.FloatRect) void {
        sf.c.sfCircleShape_getCircleRect(self.ptr, rect.toCSFML());
    }

    /// Gets the bounds in the local coordinates system
    pub fn getLocalBounds(self: Self) sf.FloatRect {
        return sf.FloatRect.fromCSFML(sf.c.sfCircleShape_getLocalBounds(self.ptr));
    }

    /// Gets the bounds in the global coordinates
    pub fn getGlobalBounds(self: Self) sf.FloatRect {
        return sf.FloatRect.fromCSFML(sf.c.sfCircleShape_getGlobalBounds(self.ptr));
    }

    /// Pointer to the csfml structure
    ptr: *sf.c.sfCircleShape
};

test "circle shape: sane getters and setters" {
    const tst = @import("std").testing;
    
    var circle = try CircleShape.init(30);
    defer circle.deinit();

    circle.setFillColor(sf.Color.Yellow);
    circle.setRadius(50);
    circle.setRotation(15);
    circle.setPosition(.{ .x = 1, .y = 2 });
    circle.setOrigin(.{ .x = 20, .y = 25 });

    // TODO : issue #2
    //tst.expectEqual(sf.Color.Yellow, circle.getFillColor());
    tst.expectEqual(@as(f32, 50), circle.getRadius());
    tst.expectEqual(@as(f32, 15), circle.getRotation());
    tst.expectEqual(sf.Vector2f{ .x = 1, .y = 2 }, circle.getPosition());
    tst.expectEqual(sf.Vector2f{ .x = 20, .y = 25 }, circle.getOrigin());
    tst.expectEqual(@as(?sf.Texture, null), circle.getTexture());

    circle.rotate(5);
    circle.move(.{ .x = -5, .y = 5 });

    tst.expectEqual(@as(f32, 20), circle.getRotation());
    tst.expectEqual(sf.Vector2f{ .x = -4, .y = 7 }, circle.getPosition());
}
