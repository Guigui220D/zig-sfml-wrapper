//! Specialized shape representing a rectangle.

usingnamespace @import("../sfml_import.zig");
const sf = @import("../sfml.zig");

pub const RectangleShape = struct {
    const Self = @This();

    // Constructor/destructor

    pub fn init(radius: f32) !Self {
        var circle = Sf.sfCircleShape_create();
        if (circle == null)
            return sf.Error.nullptrUnknownReason;
        
        Sf.sfCircleShape_setFillColor(circle, Sf.sfWhite);
        Sf.sfCircleShape_setRadius(circle, radius);

        return Self{ .ptr = circle.? };
    }

    pub fn deinit(self: Self) void {
        Sf.sfCircleShape_destroy(self.ptr);
    }

    // Getters/setters

    pub fn getFillColor(self: Self) Sf.sfColor {
        return Sf.sfCircleShape_getFillColor(self.ptr);
    }
    pub fn setFillColor(self: Self, color: Sf.sfColor) void {
        Sf.sfCircleShape_setFillColor(self.ptr, color);
    }

    pub fn getRadius(self: Self) f32 {
        return Sf.sfCircleShape_getRadius(self.ptr);
    }
    pub fn setRadius(self: Self, radius: f32) void {
        Sf.sfCircleShape_setRadius(self.ptr, radius);
    }

    pub fn getPosition(self: Self) sf.Vector2f {
        return sf.Vector2f.fromCSFML(Sf.sfCircleShape_getPosition(self.ptr));
    }
    pub fn setPosition(self: Self, pos: sf.Vector2f) void {
        Sf.sfCircleShape_setPosition(self.ptr, pos.toCSFML());
    }

    pub fn getOrigin(self: Self) sf.Vector2f {
        return sf.Vector2f.fromCSFML(Sf.sfCircleShape_getOrigin(self.ptr));
    }
    pub fn setOrigin(self: Self, origin: sf.Vector2f) void {
        Sf.sfCircleShape_setOrigin(self.ptr, origin.toCSFML());
    }

    // Pointer to the csfml structure
    ptr: *Sf.sfRectangleShape
};

const tst = @import("std").testing;

test "rectangle shape: sane getters and setters" {
    
}