//! Specialized shape representing a rectangle.

usingnamespace @import("../sfml_import.zig");
const sf = @import("../sfml.zig");

pub const RectangleShape = struct {
    const Self = @This();

    // Constructor/destructor

    /// Creates a rectangle shape with a size. The rectangle will be white
    pub fn init(size: sf.Vector2f) !Self {
        var rect = Sf.sfRectangleShape_create();
        if (rect == null)
            return sf.Error.nullptrUnknownReason;
        
        Sf.sfRectangleShape_setFillColor(rect, Sf.sfWhite);
        Sf.sfRectangleShape_setSize(rect, size.toCSFML());

        return Self{ .ptr = rect.? };
    }

    /// Destroys a rectangle shape
    pub fn deinit(self: Self) void {
        Sf.sfRectangleShape_destroy(self.ptr);
    }

    // Getters/setters

    /// Gets the fill color of this rectangle shape
    pub fn getFillColor(self: Self) Sf.sfColor {
        return Sf.sfRectangleShape_getFillColor(self.ptr);
    }
    /// Sets the fill color of this rectangle shape
    pub fn setFillColor(self: Self, color: Sf.sfColor) void {
        Sf.sfRectangleShape_setFillColor(self.ptr, color);
    }

    /// Gets the size of this rectangle shape
    pub fn getSize(self: Self) sf.Vector2f {
        return sf.Vector2f.fromCSFML(Sf.sfRectangleShape_getSize(self.ptr));
    }
    /// Sets the size of this rectangle shape
    pub fn setSize(self: Self, size: sf.Vector2f) void {
        Sf.sfRectangleShape_setSize(self.ptr, size.toCSFML());
    }

    /// Gets the position of this rectangle shape
    pub fn getPosition(self: Self) sf.Vector2f {
        return sf.Vector2f.fromCSFML(Sf.sfRectangleShape_getPosition(self.ptr));
    }
    /// Sets the position of this rectangle shape
    pub fn setPosition(self: Self, pos: sf.Vector2f) void {
        Sf.sfRectangleShape_setPosition(self.ptr, pos.toCSFML());
    }

    /// Gets the origin of this rectangle shape
    pub fn getOrigin(self: Self) sf.Vector2f {
        return sf.Vector2f.fromCSFML(Sf.sfRectangleShape_getOrigin(self.ptr));
    }
    /// Sets the origin of this rectangle shape
    pub fn setOrigin(self: Self, origin: sf.Vector2f) void {
        Sf.sfRectangleShape_setOrigin(self.ptr, origin.toCSFML());
    }

    /// Gets the rotation of this rectangle shape
    pub fn getRotation(self: Self) f32 {
        return Sf.sfRectangleShape_getRotation(self.ptr);
    }
    /// Sets the rotation of this rectangle shape
    pub fn setRotation(self: Self, angle: f32) void {
        Sf.sfRectangleShape_setRotation(self.ptr, angle);
    }

    /// Pointer to the csfml structure
    ptr: *Sf.sfRectangleShape
};

const tst = @import("std").testing;

test "rectangle shape: sane getters and setters" {
    var rect = try RectangleShape.init(sf.Vector2f{.x = 30, .y = 50});
    defer rect.deinit();

    tst.expectEqual(sf.Vector2f{.x = 30, .y = 50}, rect.getSize());

    rect.setFillColor(Sf.sfYellow);
    rect.setSize(.{.x = 15, .y = 510});
    rect.setRotation(15);
    rect.setPosition(.{.x = 1, .y = 2});
    rect.setOrigin(.{.x = 20, .y = 25});

    // TODO : find why that doesn't work
    //tst.expectEqual(Sf.sfYellow, rect.getFillColor()); 
    tst.expectEqual(sf.Vector2f{.x = 15, .y = 510}, rect.getSize());
    tst.expectEqual(@as(f32, 15), rect.getRotation());
    tst.expectEqual(sf.Vector2f{.x = 1, .y = 2}, rect.getPosition());
    tst.expectEqual(sf.Vector2f{.x = 20, .y = 25}, rect.getOrigin());
}