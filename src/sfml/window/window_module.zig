const c = @import("../sfml_import.zig").c;

pub const Event = @import("event.zig").Event;
pub const Style = @import("Style.zig");
pub const WindowHandle = c.sfWindowHandle;
pub const ContextSettings = @import("context_settings.zig").ContextSettings;
pub const keyboard = @import("keyboard.zig");
pub const mouse = @import("mouse.zig");
pub const Joystick = @import("Joystick.zig");

//pub const touch = @compileError("touch not available yet");
//pub const sensor = @compileError("Sensor not available yet");
//pub const clipboard = @compileError("Clipboard not available yet");
//pub const Cursor = @compileError("Cursor not available yet");
