//! 2D camera that defines what region is shown on screen.

usingnamespace @import("../sfml_import.zig");
const sf = @import("../sfml.zig");

pub const View = struct {
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
    pub fn fromCSFML(view: *const Sf.sfView) Self {
        var ret: Self = undefined;
        ret.center = sf.Vector2f.fromCSFML(Sf.sfView_getCenter(view));
        ret.size = sf.Vector2f.fromCSFML(Sf.sfView_getSize(view));
        ret.viewport = sf.FloatRect.fromCSFML(Sf.sfView_getViewport(view));
        return ret;
    }

    /// Creates a CSFML view from this view
    /// This is mainly for the inner workings of this wrapper
    /// The resulting view must be destroyed!
    pub fn toCSFML(self: Self) *Sf.sfView {
        var view = Sf.sfView_create().?;
        Sf.sfView_setCenter(view, self.center.toCSFML());
        Sf.sfView_setSize(view, self.size.toCSFML());
        Sf.sfView_setViewport(view, self.viewport.toCSFML());
        return view;
    }

    // View variables
    /// Center of the view, what this view "looks" at
    center: sf.Vector2f,
    /// Width and height of the view
    size: sf.Vector2f,
    /// The viewport of this view
    viewport: sf.FloatRect
};

const tst = @import("std").testing;

test "view: from rect" {
    // Testing if the view from rect initialization works
    var rect = sf.FloatRect.init(10, -15, 700, 600);

    var view = Sf.sfView_createFromRect(rect.toCSFML());
    defer Sf.sfView_destroy(view);

    var view2 = View.fromRect(rect);

    var center = sf.Vector2f.fromCSFML(Sf.sfView_getCenter(view));
    var size = sf.Vector2f.fromCSFML(Sf.sfView_getSize(view));

    tst.expectWithinMargin(center.x, view2.center.x, 0.00001);
    tst.expectWithinMargin(center.y, view2.center.y, 0.00001);
    tst.expectWithinMargin(size.x, view2.size.x, 0.00001);
    tst.expectWithinMargin(size.y, view2.size.y, 0.00001);
}