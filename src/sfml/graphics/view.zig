//! 2D camera that defines what region is shown on screen.

const sf = struct {
    pub usingnamespace @import("../sfml.zig");
    pub usingnamespace system;
    pub usingnamespace graphics;
};

const Self = @This();

/// Creates a view from a rectangle
pub fn fromRect(rect: sf.FloatRect) Self {
    var ret: Self = undefined;
    ret.center = rect.getCorner();
    ret.size = rect.getSize();
    ret.center = ret.center.add(ret.size.scale(0.5));
    ret.viewport = sf.FloatRect.init(0, 0, 1, 1);
    return ret;
}

/// Creates a view from a CSFML object
/// This is mainly for the inner workings of this wrapper
pub fn fromCSFML(view: *const sf.c.sfView) Self {
    var ret: Self = undefined;
    ret.center = sf.Vector2f.fromCSFML(sf.c.sfView_getCenter(view));
    ret.size = sf.Vector2f.fromCSFML(sf.c.sfView_getSize(view));
    ret.viewport = sf.FloatRect.fromCSFML(sf.c.sfView_getViewport(view));
    return ret;
}

/// Creates a CSFML view from this view
/// This is mainly for the inner workings of this wrapper
/// The resulting view must be destroyed!
pub fn toCSFML(self: Self) *sf.c.sfView {
    var view = sf.c.sfView_create().?;
    sf.c.sfView_setCenter(view, self.center.toCSFML());
    sf.c.sfView_setSize(view, self.size.toCSFML());
    sf.c.sfView_setViewport(view, self.viewport.toCSFML());
    return view;
}

pub fn getRect(self: Self) sf.FloatRect {
    return sf.FloatRect.init(
        self.center.x - self.size.x / 2,
        self.center.y - self.size.y / 2,
        self.size.x,
        self.size.y
    );
}

// View variables
/// Center of the view, what this view "looks" at
center: sf.Vector2f,
/// Width and height of the view
size: sf.Vector2f,
/// The viewport of this view
viewport: sf.FloatRect,

test "view: from rect" {
    const tst = @import("std").testing;

    // Testing if the view from rect initialization works
    var rect = sf.FloatRect.init(10, -15, 700, 600);

    var view = sf.c.sfView_createFromRect(rect.toCSFML());
    defer sf.c.sfView_destroy(view);

    var view2 = View.fromRect(rect);

    var center = sf.Vector2f.fromCSFML(sf.c.sfView_getCenter(view));
    var size = sf.Vector2f.fromCSFML(sf.c.sfView_getSize(view));

    tst.expectWithinMargin(center.x, view2.center.x, 0.00001);
    tst.expectWithinMargin(center.y, view2.center.y, 0.00001);
    tst.expectWithinMargin(size.x, view2.size.x, 0.00001);
    tst.expectWithinMargin(size.y, view2.size.y, 0.00001);

    var rect_ret = view2.getRect();
    
    tst.expectWithinMargin(rect.left, rect_ret.left, 0.00001);
    tst.expectWithinMargin(rect.top, rect_ret.top, 0.00001);
    tst.expectWithinMargin(rect.width, rect_ret.width, 0.00001);
    tst.expectWithinMargin(rect.height, rect_ret.height, 0.00001);
}
