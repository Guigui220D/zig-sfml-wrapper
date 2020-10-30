//! Window that can serve as a target for 2D drawing. 

usingnamespace @import("../sfml_import.zig");
const sf = @import("../sfml.zig");

pub const RenderWindow = struct {
    const Self = @This();
    
    // Constructor/destructor

    // TODO : choose style of window
    /// Inits a render window with a size, a bits per pixel (most put 32) and a title
    /// The window will have the default style
    pub fn init(size: sf.Vector2u, bpp: usize, title: [:0]const u8) !Self {
        var ret: Self = undefined;

        var mode: Sf.sfVideoMode = .{ 
            .width = @intCast(c_uint, size.x), 
            .height = @intCast(c_uint, size.y), 
            .bitsPerPixel = @intCast(c_uint, bpp)
        };

        var window = Sf.sfRenderWindow_create(mode, @ptrCast([*c]const u8, title), Sf.sfDefaultStyle, 0);

        if (window) |w| {
            ret.ptr = w;
        } else {
            return sf.Error.windowCreationFailed;
        }

        return ret;
    }

    /// Destroys this window object
    pub fn deinit(self: Self) void {
        Sf.sfRenderWindow_destroy(self.ptr);
    }

    // Event related

    /// Returns true if this window is still open
    pub fn isOpen(self: Self) bool {
        return Sf.sfRenderWindow_isOpen(self.ptr) != 0;
    }

    /// Closes this window
    pub fn close(self: Self) void {
        Sf.sfRenderWindow_close(self.ptr);
    }

    /// Gets an event from the queue, returns null is theres none
    /// Use while on this to get all the events in your game loop
    pub fn pollEvent(self: Self) ?Sf.sfEvent {
        var event: Sf.sfEvent = undefined;
        if (Sf.sfRenderWindow_pollEvent(self.ptr, &event) == 0)
            return null;
        return event;
    }

    // Drawing functions

    /// Clears the drawing screen with a color
    pub fn clear(self: Self, color: Sf.sfColor) void {
        Sf.sfRenderWindow_clear(self.ptr, color);
    }

    /// Displays what has been drawn on the render area
    pub fn display(self: Self) void {
        Sf.sfRenderWindow_display(self.ptr);
    }

    /// Draw something on the screen (won't be visible until display is called)
    /// Object must be a SFML object from the wrapper
    /// You can pass a render state or null for default
    pub fn draw(self: Self, to_draw: anytype, states: ?*Sf.sfRenderStates) void {
        switch (@TypeOf(to_draw)) {
            sf.CircleShape => Sf.sfRenderWindow_drawCircleShape(self.ptr, to_draw.ptr, states),
            else => @compileError("You must provide a drawable object")
        }
    }

    // Getters/setters
    /// Gets the current view of the window
    /// Unlike in SFML, you don't get a const pointer but a copy
    pub fn getView(self: Self) sf.View {
        return sf.View.fromCSFML(Sf.sfRenderWindow_getView(self.ptr).?);
    }
    /// Gets the default view of this window
    /// Unlike in SFML, you don't get a const pointer but a copy
    pub fn getDefaultView(self: Self) sf.View {
        return sf.View.fromCSFML(Sf.sfRenderWindow_getDefaultView(self.ptr).?);
    }
    /// Sets the view of this window
    pub fn setView(self: Self, view: sf.View) void {
        var cview = view.toCSFML();
        defer Sf.sfView_destroy(cview);
        Sf.sfRenderWindow_setView(self.ptr, cview);
    }

    /// Gets the size of this window
    pub fn getSize(self: Self) sf.Vector2u {
        return  sf.Vector2u.fromCSFML(Sf.sfRenderWindow_getSize(self.ptr));
    }
    /// Sets the size of this window
    pub fn setSize(self: Self, size: sf.Vector2u) void {
        Sf.sfRenderWindow_setSize(self.ptr, size.toCSFML());
    }
    
    /// Gets the position of this window
    pub fn getPosition(self: Self) sf.Vector2u {
        return sf.Vector2u.fromCSFML(Sf.sfRenderWindow_getPosition(self.ptr));
    }
    /// Sets the position of this window
    pub fn setPosition(self: Self, pos: sf.Vector2u) void {
        Sf.sfRenderWindow_setPosition(self.ptr, pos.toCSFML());
    }

    // TODO : unicode title?
    /// Sets the title of this window
    pub fn setTitle(self: Self, title: [:0]const u8) void {
        Sf.sfRenderWindow_setTitle(self.ptr, title);
    }

    /// Pointer to the csfml structure
    ptr: *Sf.sfRenderWindow
};