//! Import this to get all the sfml wrapper classes

pub const c = @import("sfml_import.zig").c;

pub const Error = @import("sfml_errors.zig").Error;

pub const system = struct {
    const vector = @import("system/vector.zig");
    pub const Vector2 = vector.Vector2;
    pub const Vector3 = vector.Vector3;
    pub const Vector4 = vector.Vector4;
    pub const Vector2i = Vector2(c_int);
    pub const Vector2u = Vector2(c_uint);
    pub const Vector2f = Vector2(f32);
    pub const Vector3f = Vector3(f32);

    pub const Time = @import("system/Time.zig");
    pub const Clock = @import("system/Clock.zig");
};

pub const window = struct {
    pub const Event = @import("window/event.zig").Event;
    pub const Style = @import("window/Style.zig");
    pub const WindowHandle = c.sfWindowHandle;
    pub const ContextSettings = @import("window/context_settings.zig").ContextSettings;
    pub const keyboard = @import("window/keyboard.zig");
    pub const mouse = @import("window/mouse.zig");
};

pub const graphics = struct {
    pub const Color = @import("graphics/color.zig").Color;

    pub const RenderWindow = @import("graphics/RenderWindow.zig");
    pub const RenderTexture = @import("graphics/RenderTexture.zig");

    pub const View = @import("graphics/View.zig");

    pub const Image = @import("graphics/Image.zig");
    pub const Texture = @import("graphics/texture.zig").Texture;

    pub const Sprite = @import("graphics/Sprite.zig");
    pub const CircleShape = @import("graphics/CircleShape.zig");
    pub const RectangleShape = @import("graphics/RectangleShape.zig");

    pub const Vertex = @import("graphics/vertex.zig").Vertex;
    pub const VertexArray = @import("graphics/VertexArray.zig");
    pub const PrimitiveType = @import("graphics/primitive_type.zig").PrimitiveType;

    pub const Rect = @import("graphics/rect.zig").Rect;
    pub const IntRect = Rect(c_int);
    pub const FloatRect = Rect(f32);
    
    pub const Font = @import("graphics/Font.zig");
    pub const Text = @import("graphics/Text.zig");
    
    pub const glsl = @import("graphics/glsl.zig");
    pub const Shader = @import("graphics/Shader.zig");
    pub const BlendMode = @import("graphics/BlendMode.zig");
    pub const RenderStates = @import("graphics/RenderStates.zig");
};

pub const audio = struct {
    pub const Music = @import("audio/Music.zig");
    pub const SoundBuffer = @import("audio/SoundBuffer.zig");
    pub const Sound = @import("audio/Sound.zig");
};

pub const network = @compileError("network module: to be implemented one day");

pub const VertexBuffer = @compileError("VertexArray not available yet");
pub const Transform = @compileError("Transform not available yet");

pub const touch = @compileError("touch not available yet");
pub const joystick = @compileError("Joystick not available yet");
pub const sensor = @compileError("Sensor not available yet");
pub const clipboard = @compileError("Clipboard not available yet");
pub const Cursor = @compileError("Cursor not available yet");
