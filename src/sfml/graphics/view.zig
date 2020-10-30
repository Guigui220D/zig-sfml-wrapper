//! 2D camera that defines what region is shown on screen.

usingnamespace @import("../sfml_import.zig");
const sf = @import("../sfml.zig");

pub const View = struct {
    const Self = @This();
    
    pub fn fromRect(rect: Sf.sfFloatRect) Self {
        var ret: Self = undefined;
        ret.center = .{.x = rect.left, .y = rect.top};
        ret.size = .{.x = rect.width, .y = rect.height};
        ret.center = ret.center.plus(ret.size.scale(0.5));
        return ret;
    }

    pub fn fromCSFML(view: *const Sf.sfView) Self {
        var ret: Self = undefined;
        ret.center = sf.Vector2f.fromCSFML(Sf.sfView_getCenter(view));
        ret.size = sf.Vector2f.fromCSFML(Sf.sfView_getSize(view));
        return ret;
    }

    pub fn toCSFML(self: Self) *Sf.sfView {
        var view = Sf.sfView_create().?;
        Sf.sfView_setCenter(view, self.center.toCSFML());
        Sf.sfView_setSize(view, self.size.toCSFML());
        return view;
    }

    // Pointer to the csfml structure
    center: sf.Vector2f,
    size: sf.Vector2f
};

const tst = @import("std").testing;

test "view: comparison with csfml views" {
    var rect = Sf.sfFloatRect{.left = 10, .top = -15, .width = 700, .height = 600};

    var view = Sf.sfView_createFromRect(rect);
    defer Sf.sfView_destroy(view);

    var view2 = View.fromRect(rect);

    var center = sf.Vector2f.fromCSFML(Sf.sfView_getCenter(view));
    var size = sf.Vector2f.fromCSFML(Sf.sfView_getSize(view));

    tst.expectWithinMargin(center.x, view2.center.x, 0.00001);
    tst.expectWithinMargin(center.y, view2.center.y, 0.00001);
    tst.expectWithinMargin(size.x, view2.size.x, 0.00001);
    tst.expectWithinMargin(size.y, view2.size.y, 0.00001);
}