//! 2D camera that defines what region is shown on screen.

usingnamespace @import("../sfml_import.zig");
const sf = @import("../sfml_errors.zig");

// TODO : some functions return const views, how to handle that?
// Should this struct contain the view data (center and size) instead of a pointer to a csfml object?

pub const View = struct {
    const Self = @This();
    
    // Constructor/destructor

    pub fn init() !Self {
        var view = Sf.sfView_create();
        if (view == null)
            return sf.Error.nullptrUnknownReason;

        return Self{ .ptr = view.? };
    }

    pub fn initFromRect(rect: Sf.sfFloatRect) !Self {
        var view = Sf.sfView_createFromRect(rect);
        if (view == null)
            return sf.Error.nullptrUnknownReason;

        return Self{ .ptr = view.? };
    }

    pub fn deinit(self: Self) void {
        Sf.sfView_destroy(self.ptr);
    }

    // Getters/setters

    pub fn getSize(self: Self) Sf.sfVector2f {
        return Sf.sfView_getSize(self.ptr);
    }
    pub fn setSize(self: Self, size: Sf.sfVector2f) void {
        Sf.sfView_setSize(self.ptr, size);
    }

    pub fn getCenter(self: Self) Sf.sfVector2f {
        return Sf.sfView_getCenter(self.ptr);
    }
    pub fn setCenter(self: Self, pos: Sf.sfVector2f) void {
        Sf.sfView_setCenter(self.ptr, pos);
    }

    // Pointer to the csfml structure
    ptr: *Sf.sfView
};

const tst = @import("std").testing;

test "view: sane getters and setters" {
    var view = try View.init();
    defer view.deinit();

    tst.expectEqual(Sf.sfVector2f{.x = 500, .y = 500}, view.getCenter());
    tst.expectEqual(Sf.sfVector2f{.x = 1000, .y = 1000}, view.getSize());

    var view2 = try View.initFromRect(Sf.sfFloatRect{.left = -10, .top = -10, .width = 20, .height = 20});
    defer view2.deinit();

    tst.expectEqual(Sf.sfVector2f{.x = 0, .y = 0}, view2.getCenter());
    tst.expectEqual(Sf.sfVector2f{.x = 20, .y = 20}, view2.getSize());

    view2.setCenter(Sf.sfVector2f{.x = 30, .y = -15});
    view2.setSize(Sf.sfVector2f{.x = 1200, .y = 1200});

    tst.expectEqual(Sf.sfVector2f{.x = 30, .y = -15}, view2.getCenter());
    tst.expectEqual(Sf.sfVector2f{.x = 1200, .y = 1200}, view2.getSize());
}