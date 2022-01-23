//! Import this to get all the sfml wrapper classes

pub const c = @import("sfml_import.zig").c;

pub const Error = @import("sfml_errors.zig").Error;

pub const system = @import("system/system_module.zig");
pub const window = @import("window/window_module.zig");
pub const graphics = @import("graphics/graphics_module.zig");
pub const audio = @import("audio/audio_module.zig");

pub const network = @compileError("network module: to be implemented one day");
