//! Give access to the real-time state of the mouse.

const sf = @import("../sfml.zig");

/// Mouse buttons
pub const Button = enum(c_uint) { Left, Right, Middle, XButton1, XButton2 };
/// Mouse wheels
pub const Wheel = enum(c_uint) { Vertical, Horizontal };

/// Returns true if the specified mouse button is pressed
pub fn isButtonPressed(button: Button) bool {
    return sf.c.sfMouse_isButtonPressed(@intToEnum(sf.c.sfMouseButton, @enumToInt(button))) == 1;
}

/// Gets the position of the mouse cursor relative to the window passed or desktop
pub fn getPosition(window: ?sf.graphics.RenderWindow) sf.system.Vector2i {
    if (window) |w| {
        return sf.system.Vector2i._fromCSFML(sf.c.sfMouse_getPosition(@ptrCast(*sf.c.sfWindow, w._ptr)));
    } else return sf.system.Vector2i._fromCSFML(sf.c.sfMouse_getPosition(null));
}
/// Set the position of the mouse cursor relative to the window passed or desktop
pub fn setPosition(position: sf.system.Vector2i, window: ?sf.graphics.RenderWindow) void {
    if (window) |w| {
        sf.c.sfMouse_setPosition(position._toCSFML(), @ptrCast(*sf.c.sfWindow, w._ptr));
    } else sf.c.sfMouse_setPosition(position._toCSFML(), null);
}
