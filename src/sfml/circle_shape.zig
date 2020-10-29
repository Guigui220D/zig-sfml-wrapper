usingnamespace @import("sfml_import.zig");

pub const CircleShape = struct {
    const Self = @This();

    pub fn init(radius: f32) !Self {
        var circle = Sf.sfCircleShape_create();
        if (circle == null)
            return error.unknown;
        
        Sf.sfCircleShape_setFillColor(circle, Sf.sfWhite);
        Sf.sfCircleShape_setRadius(circle, radius);

        return Self{ .ptr = circle.? };
    }

    pub fn deinit(self: Self) void {
        Sf.sfCircleShape_destroy(self.ptr);
    }

    pub fn setFillColor(self: Self, color: Sf.sfColor) void {
        Sf.sfCircleShape_setFillColor(self.ptr, color);
    }

    pub fn setRadius(self: Self, radius: f32) void {
        Sf.sfCircleShape_setRadius(self.ptr, radius);
    }

    pub fn setPosition(self: Self, pos: Sf.sfVector2f) void {
        Sf.sfCircleShape_setPosition(self.ptr, pos);
    }

    ptr: *Sf.sfCircleShape
}
;