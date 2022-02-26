//! Window that can serve as a target for 2D drawing.

const sf = struct {
    pub usingnamespace @import("../sfml.zig");
    pub usingnamespace sf.system;
    pub usingnamespace sf.graphics;
    pub usingnamespace sf.window;
};

const RenderWindow = @This();

// Constructor/destructor

/// Inits a render window with a size, a bits per pixel (most put 32) a title, a style and context settings
pub fn create(size: sf.Vector2u, bpp: usize, title: [:0]const u8, style: u32, settings: ?sf.ContextSettings) !RenderWindow {
    var ret: RenderWindow = undefined;

    var mode: sf.c.sfVideoMode = .{
        .width = @intCast(c_uint, size.x),
        .height = @intCast(c_uint, size.y),
        .bitsPerPixel = @intCast(c_uint, bpp),
    };

    const c_settings = if (settings) |s| s._toCSFML() else null;
    var window = sf.c.sfRenderWindow_create(mode, @ptrCast([*c]const u8, title), style, if (c_settings) |s| &s else null);

    if (window) |w| {
        ret._ptr = w;
    } else return sf.Error.windowCreationFailed;

    return ret;
}
/// Inits a render window with a size and a title
/// The window will have the default style
pub fn createDefault(size: sf.Vector2u, title: [:0]const u8) !RenderWindow {
    var ret: RenderWindow = undefined;

    var mode: sf.c.sfVideoMode = .{
        .width = @intCast(c_uint, size.x),
        .height = @intCast(c_uint, size.y),
        .bitsPerPixel = 32,
    };

    var window = sf.c.sfRenderWindow_create(mode, @ptrCast([*c]const u8, title), sf.window.Style.defaultStyle, null);

    if (window) |w| {
        ret._ptr = w;
    } else return sf.Error.windowCreationFailed;

    return ret;
}
/// Inits a rendering plane from a window handle. The handle can actually be to any drawing surface.
pub fn createFromHandle(handle: sf.WindowHandle, settings: ?sf.ContextSettings) !RenderWindow {
    const c_settings = if (settings) |s| s._toCSFML() else null;
    const window = sf.c.sfRenderWindow_createFromHandle(handle, if (c_settings) |s| &s else null);

    if (window) |w| {
        return .{ ._ptr = w };
    } else return sf.Error.windowCreationFailed;
}

/// Destroys this window object
pub fn destroy(self: *RenderWindow) void {
    sf.c.sfRenderWindow_destroy(self._ptr);
    self._ptr = undefined;
}

// Event related

/// Returns true if this window is still open
pub fn isOpen(self: RenderWindow) bool {
    return sf.c.sfRenderWindow_isOpen(self._ptr) != 0;
}

/// Closes this window
pub fn close(self: *RenderWindow) void {
    sf.c.sfRenderWindow_close(self._ptr);
}

/// Gets an event from the queue, returns null is theres none
/// Use while on this to get all the events in your game loop
pub fn pollEvent(self: *RenderWindow) ?sf.window.Event {
    var event: sf.c.sfEvent = undefined;
    if (sf.c.sfRenderWindow_pollEvent(self._ptr, &event) == 0)
        return null;

    // Skip sfEvtMouseWheelMoved to avoid sending mouseWheelScrolled twice
    if (event.type == sf.c.sfEvtMouseWheelMoved) {
        return self.pollEvent();
    }
    return sf.window.Event._fromCSFML(event);
}

// Drawing functions

/// Clears the drawing screen with a color
pub fn clear(self: *RenderWindow, color: sf.Color) void {
    sf.c.sfRenderWindow_clear(self._ptr, color._toCSFML());
}

/// Displays what has been drawn on the render area
pub fn display(self: *RenderWindow) void {
    sf.c.sfRenderWindow_display(self._ptr);
}

/// Draw something on the screen (won't be visible until display is called)
/// Object must have a sfDraw function (look at CircleShape for reference)
/// You can pass a render state or null for default
pub fn draw(self: *RenderWindow, to_draw: anytype, states: ?sf.RenderStates) void {
    const T = @TypeOf(to_draw);
    if (comptime @import("std").meta.trait.hasFn("sfDraw")(T)) {
        // Inline call of object's draw function
        if (states) |s| {
            var cstates = s._toCSFML();
            @call(.{ .modifier = .always_inline }, T.sfDraw, .{ to_draw, self.*, &cstates });
        } else @call(.{ .modifier = .always_inline }, T.sfDraw, .{ to_draw, self.*, null });
        // to_draw.sfDraw(self, states);
    } else @compileError("You must provide a drawable object (struct with \"sfDraw\" method).");
}

// Getters/setters

/// Gets the current view of the window
/// Unlike in SFML, you don't get a const pointer but a copy
pub fn getView(self: RenderWindow) sf.View {
    return sf.View._fromCSFML(sf.c.sfRenderWindow_getView(self._ptr).?);
}
/// Gets the default view of this window
/// Unlike in SFML, you don't get a const pointer but a copy
pub fn getDefaultView(self: RenderWindow) sf.View {
    return sf.View._fromCSFML(sf.c.sfRenderWindow_getDefaultView(self._ptr).?);
}
/// Sets the view of this window
pub fn setView(self: *RenderWindow, view: sf.View) void {
    var cview = view._toCSFML();
    defer sf.c.sfView_destroy(cview);
    sf.c.sfRenderWindow_setView(self._ptr, cview);
}
/// Gets the viewport of this render target
pub fn getViewport(self: RenderWindow, view: sf.View) sf.IntRect {
    return sf.IntRect._fromCSFML(sf.c.sfRenderWindow_getViewPort(self._ptr, view._ptr));
}

/// Set mouse cursor grabbing
pub fn setMouseCursorGrabbed(self: *RenderWindow, grab: bool) void {
    sf.c.sfRenderWindow_setMouseCursorGrabbed(self._ptr, @boolToInt(grab));
}

/// Set mouse cursor visibility
pub fn setMouseCursorVisible(self: *RenderWindow, visible: bool) void {
    sf.c.sfRenderWindow_setMouseCursorVisible(self._ptr, @boolToInt(visible));
}

/// Gets the size of this window
pub fn getSize(self: RenderWindow) sf.Vector2u {
    return sf.Vector2u._fromCSFML(sf.c.sfRenderWindow_getSize(self._ptr));
}
/// Sets the size of this window
pub fn setSize(self: *RenderWindow, size: sf.Vector2u) void {
    sf.c.sfRenderWindow_setSize(self._ptr, size._toCSFML());
}

/// Gets the position of this window
pub fn getPosition(self: RenderWindow) sf.Vector2i {
    return sf.Vector2i._fromCSFML(sf.c.sfRenderWindow_getPosition(self._ptr));
}
/// Sets the position of this window
pub fn setPosition(self: *RenderWindow, pos: sf.Vector2i) void {
    sf.c.sfRenderWindow_setPosition(self._ptr, pos._toCSFML());
}

/// Sets the title of this window
pub fn setTitle(self: *RenderWindow, title: [:0]const u8) void {
    sf.c.sfRenderWindow_setTitle(self._ptr, title);
}
/// Sets the title of this window, in unicode
pub fn setUnicodeTitle(self: *RenderWindow, comptime title_utf8: []const u8) void {
    const utils = @import("../utils.zig");
    const u32string = utils.utf8toUnicode(title_utf8);
    sf.c.sfRenderWindow_setUnicodeTitle(self._ptr, u32string.ptr);
}

/// Sets the windows's framerate limit
pub fn setFramerateLimit(self: *RenderWindow, fps: c_uint) void {
    sf.c.sfRenderWindow_setFramerateLimit(self._ptr, fps);
}
/// Enables or disables vertical sync
pub fn setVerticalSyncEnabled(self: *RenderWindow, enabled: bool) void {
    sf.c.sfRenderWindow_setVerticalSyncEnabled(self._ptr, @boolToInt(enabled));
}

/// Convert a point from target coordinates to world coordinates, using the current view (or the specified view)
pub fn mapPixelToCoords(self: RenderWindow, pixel: sf.Vector2i, view: ?sf.View) sf.Vector2f {
    if (view) |v| {
        var cview = v._toCSFML();
        defer sf.c.sfView_destroy(cview);
        return sf.Vector2f._fromCSFML(sf.c.sfRenderWindow_mapPixelToCoords(self._ptr, pixel._toCSFML(), cview));
    } else return sf.Vector2f._fromCSFML(sf.c.sfRenderWindow_mapPixelToCoords(self._ptr, pixel._toCSFML(), null));
}
/// Convert a point from world coordinates to target coordinates, using the current view (or the specified view)
pub fn mapCoordsToPixel(self: RenderWindow, coords: sf.Vector2f, view: ?sf.View) sf.Vector2i {
    if (view) |v| {
        var cview = v._toCSFML();
        defer sf.c.sfView_destroy(cview);
        return sf.Vector2i._fromCSFML(sf.c.sfRenderWindow_mapCoordsToPixel(self._ptr, coords._toCSFML(), cview));
    } else return sf.Vector2i._fromCSFML(sf.c.sfRenderWindow_mapCoordsToPixel(self._ptr, coords._toCSFML(), null));
}

/// Pointer to the csfml structure
_ptr: *sf.c.sfRenderWindow
