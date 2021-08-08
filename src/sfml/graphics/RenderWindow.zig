//! Window that can serve as a target for 2D drawing.

const sf = struct {
    pub usingnamespace @import("../sfml.zig");
    pub usingnamespace system;
    pub usingnamespace graphics;
};

const RenderWindow = @This();

// Constructor/destructor

/// Inits a render window with a size, a bits per pixel (most put 32), a title and a style
/// The window will have the default style
pub fn create(size: sf.Vector2u, bpp: usize, title: [:0]const u8, style: u32) !RenderWindow {
    var ret: RenderWindow = undefined;

    var mode: sf.c.sfVideoMode = .{
        .width = @intCast(c_uint, size.x),
        .height = @intCast(c_uint, size.y),
        .bitsPerPixel = @intCast(c_uint, bpp),
    };

    var window = sf.c.sfRenderWindow_create(mode, @ptrCast([*c]const u8, title), style, null);

    if (window) |w| {
        ret.ptr = w;
    } else {
        return sf.Error.windowCreationFailed;
    }

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
        ret.ptr = w;
    } else {
        return sf.Error.windowCreationFailed;
    }

    return ret;
}

/// Destroys this window object
pub fn destroy(self: RenderWindow) void {
    sf.c.sfRenderWindow_destroy(self.ptr);
}

// Event related

/// Returns true if this window is still open
pub fn isOpen(self: RenderWindow) bool {
    return sf.c.sfRenderWindow_isOpen(self.ptr) != 0;
}

/// Closes this window
pub fn close(self: RenderWindow) void {
    sf.c.sfRenderWindow_close(self.ptr);
}

/// Gets an event from the queue, returns null is theres none
/// Use while on this to get all the events in your game loop
pub fn pollEvent(self: RenderWindow) ?sf.window.Event {
    var event: sf.c.sfEvent = undefined;
    if (sf.c.sfRenderWindow_pollEvent(self.ptr, &event) == 0)
        return null;

    // Skip sfEvtMouseWheelMoved to avoid sending mouseWheelScrolled twice
    if (event.type == sf.c.sfEvtMouseWheelMoved) {
        return self.pollEvent();
    }
    return sf.window.Event.fromCSFML(event);
}

// Drawing functions

/// Clears the drawing screen with a color
pub fn clear(self: RenderWindow, color: sf.Color) void {
    sf.c.sfRenderWindow_clear(self.ptr, color.toCSFML());
}

/// Displays what has been drawn on the render area
pub fn display(self: RenderWindow) void {
    sf.c.sfRenderWindow_display(self.ptr);
}

/// Draw something on the screen (won't be visible until display is called)
/// Object must have a sfDraw function (look at CircleShape for reference)
/// You can pass a render state or null for default
pub fn draw(self: RenderWindow, to_draw: anytype, states: ?*sf.c.sfRenderStates) void {
    const T = @TypeOf(to_draw);
    if (comptime @import("std").meta.trait.hasFn("sfDraw")(T)) {
        // Inline call of object's draw function
        @call(.{ .modifier = .always_inline }, T.sfDraw, .{ to_draw, self, states });
        // to_draw.sfDraw(self, states);
    } else @compileError("You must provide a drawable object (struct with \"sfDraw\" method).");
}

// Getters/setters
/// Gets the current view of the window
/// Unlike in SFML, you don't get a const pointer but a copy
pub fn getView(self: RenderWindow) sf.View {
    return sf.View.fromCSFML(sf.c.sfRenderWindow_getView(self.ptr).?);
}
/// Gets the default view of this window
/// Unlike in SFML, you don't get a const pointer but a copy
pub fn getDefaultView(self: RenderWindow) sf.View {
    return sf.View.fromCSFML(sf.c.sfRenderWindow_getDefaultView(self.ptr).?);
}
/// Sets the view of this window
pub fn setView(self: RenderWindow, view: sf.View) void {
    var cview = view.toCSFML();
    defer sf.c.sfView_destroy(cview);
    sf.c.sfRenderWindow_setView(self.ptr, cview);
}

/// Gets the size of this window
pub fn getSize(self: RenderWindow) sf.Vector2u {
    return sf.Vector2u.fromCSFML(sf.c.sfRenderWindow_getSize(self.ptr));
}
/// Sets the size of this window
pub fn setSize(self: RenderWindow, size: sf.Vector2u) void {
    sf.c.sfRenderWindow_setSize(self.ptr, size.toCSFML());
}

/// Gets the position of this window
pub fn getPosition(self: RenderWindow) sf.Vector2i {
    return sf.Vector2i.fromCSFML(sf.c.sfRenderWindow_getPosition(self.ptr));
}
/// Sets the position of this window
pub fn setPosition(self: RenderWindow, pos: sf.Vector2i) void {
    sf.c.sfRenderWindow_setPosition(self.ptr, pos.toCSFML());
}

// TODO : unicode title?
/// Sets the title of this window
pub fn setTitle(self: RenderWindow, title: [:0]const u8) void {
    sf.c.sfRenderWindow_setTitle(self.ptr, title);
}

/// Sets the windows's framerate limit
pub fn setFramerateLimit(self: RenderWindow, fps: c_uint) void {
    sf.c.sfRenderWindow_setFramerateLimit(self.ptr, fps);
}
/// Enables or disables vertical sync
pub fn setVerticalSyncEnabled(self: RenderWindow, enabled: bool) void {
    sf.c.sfRenderWindow_setFramerateLimit(self.ptr, if (enabled) 1 else 0);
}

/// Convert a point from target coordinates to world coordinates, using the current view (or the specified view)
pub fn mapPixelToCoords(self: RenderWindow, pixel: sf.Vector2i, view: ?sf.View) sf.Vector2f {
    if (view) |v| {
        var cview = v.toCSFML();
        defer sf.c.sfView_destroy(cview);
        return sf.Vector2f.fromCSFML(sf.c.sfRenderWindow_mapPixelToCoords(self.ptr, pixel.toCSFML(), cview));
    } else return sf.Vector2f.fromCSFML(sf.c.sfRenderWindow_mapPixelToCoords(self.ptr, pixel.toCSFML(), null));
}

/// Convert a point from world coordinates to target coordinates, using the current view (or the specified view)
pub fn mapCoordsToPixel(self: RenderWindow, coords: sf.Vector2f, view: ?sf.View) sf.Vector2i {
    if (view) |v| {
        var cview = v.toCSFML();
        defer sf.c.sfView_destroy(cview);
        return sf.Vector2i.fromCSFML(sf.c.sfRenderWindow_mapCoordsToPixel(self.ptr, coords.toCSFML(), cview));
    } else return sf.Vector2i.fromCSFML(sf.c.sfRenderWindow_mapCoordsToPixel(self.ptr, coords.toCSFML(), null));
}

/// Pointer to the csfml structure
ptr: *sf.c.sfRenderWindow
