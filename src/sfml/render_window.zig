usingnamespace @import("sfml_import.zig");
const sf = @import("sfml.zig");

pub const RenderWindow = struct {
    const Self = @This();

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
            return error.windowCreationFailed;
        }

        return ret;
    }

    pub fn deinit(self: Self) void {
        Sf.sfRenderWindow_destroy(self.ptr);
    }

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

    ptr: *Sf.sfRenderWindow
};