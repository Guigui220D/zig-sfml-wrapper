//! 2D camera that defines what region is shown on screen.

const sf = struct {
    pub usingnamespace @import("../sfml.zig");
    pub usingnamespace sf.system;
    pub usingnamespace sf.graphics;
};

const View = @This();

/// Creates a view from a rectangle
pub fn fromRect(rect: sf.FloatRect) View {
    var ret: View = undefined;
    ret.center = rect.getCorner();
    ret.size = rect.getSize();
    ret.center = ret.center.add(ret.size.scale(0.5));
    ret.viewport = sf.FloatRect.init(0, 0, 1, 1);
    return ret;
}

/// Creates a view from a CSFML object
/// This is mainly for the inner workings of this wrapper
pub fn _fromCSFML(view: *const sf.c.sfView) View {
    var ret: View = undefined;
    ret.center = sf.Vector2f._fromCSFML(sf.c.sfView_getCenter(view));
    ret.size = sf.Vector2f._fromCSFML(sf.c.sfView_getSize(view));
    ret.viewport = sf.FloatRect._fromCSFML(sf.c.sfView_getViewport(view));
    return ret;
}

/// Creates a CSFML view from this view
/// This is mainly for the inner workings of this wrapper
/// The resulting view must be destroyed!
pub fn _toCSFML(self: View) *sf.c.sfView {
    var view = sf.c.sfView_create().?;
    sf.c.sfView_setCenter(view, self.center._toCSFML());
    sf.c.sfView_setSize(view, self.size._toCSFML());
    sf.c.sfView_setViewport(view, self.viewport._toCSFML());
    return view;
}

pub fn getRect(self: View) sf.FloatRect {
    return sf.FloatRect.init(
        self.center.x - self.size.x / 2,
        self.center.y - self.size.y / 2,
        self.size.x,
        self.size.y,
    );
}

pub fn setSize(self: *View, size: sf.Vector2f) void {
    self.size = size;
}

pub fn setCenter(self: *View, center: sf.Vector2f) void {
    self.center = center;
}

pub fn zoom(self: *View, factor: f32) void {
    self.size = .{ .x = self.size.x * factor, .y = self.size.y * factor };
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

    var view = sf.c.sfView_createFromRect(rect._toCSFML());
    defer sf.c.sfView_destroy(view);

    var view2 = View.fromRect(rect);

    var center = sf.Vector2f._fromCSFML(sf.c.sfView_getCenter(view));
    var size = sf.Vector2f._fromCSFML(sf.c.sfView_getSize(view));

    try tst.expectApproxEqAbs(center.x, view2.center.x, 0.00001);
    try tst.expectApproxEqAbs(center.y, view2.center.y, 0.00001);
    try tst.expectApproxEqAbs(size.x, view2.size.x, 0.00001);
    try tst.expectApproxEqAbs(size.y, view2.size.y, 0.00001);

    var rect_ret = view2.getRect();

    try tst.expectApproxEqAbs(rect.left, rect_ret.left, 0.00001);
    try tst.expectApproxEqAbs(rect.top, rect_ret.top, 0.00001);
    try tst.expectApproxEqAbs(rect.width, rect_ret.width, 0.00001);
    try tst.expectApproxEqAbs(rect.height, rect_ret.height, 0.00001);

    view2.setCenter(.{ .x = 400, .y = 300 });
    view2.setSize(.{ .x = 800, .y = 600 });
    rect_ret = view2.getRect();
    try tst.expectApproxEqAbs(@as(f32, 0), rect_ret.left, 0.00001);
    try tst.expectApproxEqAbs(@as(f32, 0), rect_ret.top, 0.00001);
    try tst.expectApproxEqAbs(@as(f32, 800), rect_ret.width, 0.00001);
    try tst.expectApproxEqAbs(@as(f32, 600), rect_ret.height, 0.00001);
}
