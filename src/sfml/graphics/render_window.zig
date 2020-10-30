//! Window that can serve as a target for 2D drawing. 

usingnamespace @import("../sfml_import.zig");
const sf = @import("../sfml.zig");

pub const RenderWindow = struct {
    const Self = @This();
    
    // Constructor/destructor

    pub fn init(width: usize, height: usize, bpp: usize, title: [:0]const u8) !Self {
        var ret: Self = undefined;

        var mode: Sf.sfVideoMode = .{ 
            .width = @intCast(c_uint, width), 
            .height = @intCast(c_uint, height), 
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

    pub fn deinit(self: Self) void {
        Sf.sfRenderWindow_destroy(self.ptr);
    }

    // Event related

    pub fn isOpen(self: Self) bool {
        return Sf.sfRenderWindow_isOpen(self.ptr) != 0;
    }

    pub fn close(self: Self) void {
        Sf.sfRenderWindow_close(self.ptr);
    }

    pub fn pollEvent(self: Self) ?Sf.sfEvent {
        var event: Sf.sfEvent = undefined;
        if (Sf.sfRenderWindow_pollEvent(self.ptr, &event) == 0)
            return null;
        return event;
    }

    // Drawing functions

    pub fn clear(self: Self, color: Sf.sfColor) void {
        Sf.sfRenderWindow_clear(self.ptr, color);
    }

    pub fn display(self: Self) void {
        Sf.sfRenderWindow_display(self.ptr);
    }

    pub fn draw(self: Self, to_draw: anytype, states: ?*Sf.sfRenderStates) void {
        switch (@TypeOf(to_draw)) {
            sf.CircleShape => Sf.sfRenderWindow_drawCircleShape(self.ptr, to_draw.ptr, states),
            else => @compileError("You must provide a drawable object")
        }
    }

    // Getters/setters
    pub fn getView(self: Self) sf.View {
        var view = Sf.sfRenderWindow_getDefaultView(self.ptr);
        return sf.View{.ptr = Sf.sfView_copy(view).?};
    }
    pub fn getDefaultView(self: Self) sf.View {
        var view = Sf.sfRenderWindow_getView(self.ptr);
        return sf.View{.ptr = Sf.sfView_copy(view).?};
    }
    pub fn setView(self: Self, view: sf.View) void {
        Sf.sfRenderWindow_setView(self.ptr, view.ptr);
    }

    pub fn getSize(self: Self) sf.Vector2u {
        return  sf.Vector2u.fromCSFML(Sf.sfRenderWindow_getSize(self.ptr));
    }
    pub fn setSize(self: Self, size: sf.Vector2u) void {
        Sf.sfRenderWindow_setSize(self.ptr, size.toCSFML());
    }

    pub fn getPosition(self: Self) sf.Vector2u {
        return sf.Vector2u.fromCSFML(Sf.sfRenderWindow_getPosition(self.ptr));
    }
    pub fn setPosition(self: Self, pos: sf.Vector2u) void {
        Sf.sfRenderWindow_setPosition(self.ptr, pos.toCSFML());
    }

    pub fn setTitle(self: Self, title: [:0]const u8) void {
        Sf.sfRenderWindow_setTitle(self.ptr, title);
    }

    // Pointer to the csfml structure
    ptr: *Sf.sfRenderWindow
};