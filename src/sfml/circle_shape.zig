//! Specialized shape representing a circle. 

usingnamespace @import("sfml_import.zig");
const sf = @import("sfml_errors.zig");

pub const CircleShape = struct {
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

    pub fn getPosition(self: Self) Sf.sfVector2f {
        return Sf.sfCircleShape_getPosition(self.ptr);
    }
    pub fn setPosition(self: Self, pos: Sf.sfVector2f) void {
        Sf.sfCircleShape_setPosition(self.ptr, pos);
    }

    pub fn getOrigin(self: Self) Sf.sfVector2f {
        return Sf.sfCircleShape_getOrigin(self.ptr);
    }
    pub fn setOrigin(self: Self, origin: Sf.sfVector2f) void {
        Sf.sfCircleShape_setOrigin(self.ptr, origin);
    }

    // Pointer to the csfml structure
    ptr: *Sf.sfCircleShape
};

const tst = @import("std").testing;

test "circle shape: sane getters and setters" {
    var circle = try CircleShape.init(30);
    defer circle.deinit();

    circle.setFillColor(Sf.sfYellow);
    circle.setRadius(50);
    circle.setPosition(.{.x = 1, .y = 2});
    circle.setOrigin(.{.x = 20, .y = 25});

    // TODO : find why that doesn't work
    //tst.expectEqual(Sf.sfYellow, circle.getFillColor()); 
    tst.expectEqual(@as(f32, 50.0), circle.getRadius());
    tst.expectEqual(Sf.sfVector2f{.x = 1, .y = 2}, circle.getPosition());
    tst.expectEqual(Sf.sfVector2f{.x = 20, .y = 25}, circle.getOrigin());
}