//! Import this to get all the sfml wrapper classes

pub const c = @import("sfml_import.zig").c;

pub const Error = @import("sfml_errors.zig").Error;

pub const system = struct {
    pub usingnamespace @import("system/vector.zig");
    pub const Time = @import("system/Time.zig");
    pub const Clock = @import("system/Clock.zig");
};

pub const window = struct {
    usingnamespace @import("window/event.zig");
    pub const keyboard = @import("window/Keyboard.zig");
    pub const mouse = @import("window/Mouse.zig");
};

pub const graphics = struct {
    pub const Color = @import("graphics/color.zig").Color;
    pub const RenderWindow = @import("graphics/RenderWindow.zig");
    pub const Image = @import("graphics/Image.zig");
    pub const Texture = @import("graphics/texture.zig").Texture;
    pub const Sprite = @import("graphics/Sprite.zig");
    pub const CircleShape = @import("graphics/CircleShape.zig");
    pub const RectangleShape = @import("graphics/RectangleShape.zig");
    pub usingnamespace @import("graphics/rect.zig");
    pub const View = @import("graphics/View.zig");
    pub const Font = @import("graphics/Font.zig");
    pub const Text = @import("graphics/Text.zig");
    pub const Vertex = @import("graphics/vertex.zig").Vertex;
};

pub const audio = struct {
    pub const Music = @import("audio/Music.zig");
    pub const SoundBuffer = @import("audio/SoundBuffer.zig");
    pub const Sound = @import("audio/Sound.zig");
};

pub const network = @compileError("network module: to be implemented one day");

pub const touch = @compileError("touch not available yet");
pub const joystick = @compileError("Joystick not available yet");
pub const sensor = @compileError("Sensor not available yet");
pub const clipboard = @compileError("Clipboard not available yet");
pub const Cursor = @compileError("Cursor not available yet");

pub const VertexArray = @compileError("VertexArray not available yet");
pub const VertexBuffer = @compileError("VertexArray not available yet");
pub const BlendMode = @compileError("BlendMode not available yet");
pub const RenderStates = @compileError("RenderStates not available yet");
pub const RenderTexture = @compileError("RenderTexture not available yet");
pub const Shader = @compileError("Shader not available yet");
pub const Transform = @compileError("Transform not available yet");
