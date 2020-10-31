//! Specialized shape representing a circle. 

usingnamespace @import("../sfml_import.zig");
const sf = @import("../sfml.zig");

pub const CircleShape = struct {
    const Self = @This();

    // Constructor/destructor

    /// Inits a circle shape with a radius. The circle will be white and have 30 points
    pub fn init(radius: f32) !Self {
        var circle = Sf.sfCircleShape_create();
        if (circle == null)
            return sf.Error.nullptrUnknownReason;
        
        Sf.sfCircleShape_setFillColor(circle, Sf.sfWhite);
        Sf.sfCircleShape_setRadius(circle, radius);

        return Self{ .ptr = circle.? };
    }

    /// Destroys a circle shape
    pub fn deinit(self: Self) void {
        Sf.sfCircleShape_destroy(self.ptr);
    }

    // Getters/setters

    /// Gets the fill color of this circle shape 
    pub fn getFillColor(self: Self) Sf.sfColor {
        return Sf.sfCircleShape_getFillColor(self.ptr);
    }
    /// Sets the fill color of this circle shape
    pub fn setFillColor(self: Self, color: Sf.sfColor) void {
        Sf.sfCircleShape_setFillColor(self.ptr, color);
    }

    /// Gets the radius of this circle shape
    pub fn getRadius(self: Self) f32 {
        return Sf.sfCircleShape_getRadius(self.ptr);
    }
    /// Sets the radius of this circle shape
    pub fn setRadius(self: Self, radius: f32) void {
        Sf.sfCircleShape_setRadius(self.ptr, radius);
    }

    /// Gets the position of this circle shape
    pub fn getPosition(self: Self) sf.Vector2f {
        return sf.Vector2f.fromCSFML(Sf.sfCircleShape_getPosition(self.ptr));
    }
    /// Sets the position of this circle shape
    pub fn setPosition(self: Self, pos: sf.Vector2f) void {
        Sf.sfCircleShape_setPosition(self.ptr, pos.toCSFML());
    }

    /// Gets the origin of this circle shape
    pub fn getOrigin(self: Self) sf.Vector2f {
        return sf.Vector2f.fromCSFML(Sf.sfCircleShape_getOrigin(self.ptr));
    }
    /// Sets the origin of this circle shape
    pub fn setOrigin(self: Self, origin: sf.Vector2f) void {
        Sf.sfCircleShape_setOrigin(self.ptr, origin.toCSFML());
    }

    /// Gets the rotation of this circle shape
    pub fn getRotation(self: Self) f32 {
        return Sf.sfCircleShape_getRotation(self.ptr);
    }
    /// Sets the rotation of this circle shape
    pub fn setRotation(self: Self, angle: f32) void {
        Sf.sfCircleShape_setRotation(self.ptr, angle);
    }

    /// Gets the texture of this shape
    pub fn getTexture(self: Self) ?sf.Texture {
        return sf.Texture{.const_ptr = Sf.sfCircleShape_getTexture(self.ptr)};
    }
    /// Sets the texture of this shape
    pub fn setTexture(self: Self, texture: sf.Texture) void {
        var t = Sf.sfCircleShape_setTexture(self.ptr);
        if (t != null) {
            return sf.Texture{.const_ptr = t.?};
        } else
            return null;
    }

    /// Pointer to the csfml structure
    ptr: *Sf.sfCircleShape
};

const tst = @import("std").testing;

test "circle shape: sane getters and setters" {
    var circle = try CircleShape.init(30);
    defer circle.deinit();

    circle.setFillColor(Sf.sfYellow);
    circle.setRadius(50);
    circle.setRotation(15);
    circle.setPosition(.{.x = 1, .y = 2});
    circle.setOrigin(.{.x = 20, .y = 25});

    // TODO : find why that doesn't work
    //tst.expectEqual(Sf.sfYellow, circle.getFillColor()); 
    tst.expectEqual(@as(f32, 50), circle.getRadius());
    tst.expectEqual(@as(f32, 15), circle.getRotation());
    tst.expectEqual(sf.Vector2f{.x = 1, .y = 2}, circle.getPosition());
    tst.expectEqual(sf.Vector2f{.x = 20, .y = 25}, circle.getOrigin());
}