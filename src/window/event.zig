//! Defines a system event and its parameters.

const sf = struct {
    const sfml = @import("../root.zig");
    pub usingnamespace sfml;
    pub usingnamespace sfml.system;
};

pub const Event = union(enum) {
    const Self = @This();

    // Big oof
    /// Creates this event from a csfml one
    pub fn _fromCSFML(event: sf.c.sfEvent) Self {
        return switch (event.type) {
            sf.c.sfEvtClosed => .closed,
            sf.c.sfEvtResized => .{ .resized = .{ .size = .{ .x = event.size.width, .y = event.size.height } } },
            sf.c.sfEvtLostFocus => .lost_focus,
            sf.c.sfEvtGainedFocus => .gained_focus,
            sf.c.sfEvtTextEntered => .{ .text_entered = .{ .unicode = event.text.unicode } },
            sf.c.sfEvtKeyPressed => .{ .key_pressed = .{ .code = @as(sf.window.keyboard.KeyCode, @enumFromInt(event.key.code)), .alt = (event.key.alt != 0), .control = (event.key.control != 0), .shift = (event.key.shift != 0), .system = (event.key.system != 0) } },
            sf.c.sfEvtKeyReleased => .{ .key_released = .{ .code = @as(sf.window.keyboard.KeyCode, @enumFromInt(event.key.code)), .alt = (event.key.alt != 0), .control = (event.key.control != 0), .shift = (event.key.shift != 0), .system = (event.key.system != 0) } },
            sf.c.sfEvtMouseWheelScrolled => .{ .mouse_wheel_scrolled = .{ .wheel = @as(sf.window.mouse.Wheel, @enumFromInt(event.mouseWheelScroll.wheel)), .delta = event.mouseWheelScroll.delta, .pos = .{ .x = event.mouseWheelScroll.x, .y = event.mouseWheelScroll.y } } },
            sf.c.sfEvtMouseButtonPressed => .{ .mouse_button_pressed = .{ .button = @as(sf.window.mouse.Button, @enumFromInt(event.mouseButton.button)), .pos = .{ .x = event.mouseButton.x, .y = event.mouseButton.y } } },
            sf.c.sfEvtMouseButtonReleased => .{ .mouse_button_released = .{ .button = @as(sf.window.mouse.Button, @enumFromInt(event.mouseButton.button)), .pos = .{ .x = event.mouseButton.x, .y = event.mouseButton.y } } },
            sf.c.sfEvtMouseMoved => .{ .mouse_moved = .{ .pos = .{ .x = event.mouseMove.x, .y = event.mouseMove.y } } },
            sf.c.sfEvtMouseEntered => .mouse_entered,
            sf.c.sfEvtMouseLeft => .mouse_left,
            sf.c.sfEvtJoystickButtonPressed => .{ .joystick_button_pressed = .{ .joystickId = event.joystickButton.joystickId, .button = event.joystickButton.button } },
            sf.c.sfEvtJoystickButtonReleased => .{ .joystick_button_released = .{ .joystickId = event.joystickButton.joystickId, .button = event.joystickButton.button } },
            sf.c.sfEvtJoystickMoved => .{ .joystick_moved = .{ .joystickId = event.joystickMove.joystickId, .axis = event.joystickMove.axis, .position = event.joystickMove.position } },
            sf.c.sfEvtJoystickConnected => .{ .joystick_connected = .{ .joystickId = event.joystickConnect.joystickId } },
            sf.c.sfEvtJoystickDisconnected => .{ .joystick_disconnected = .{ .joystickId = event.joystickConnect.joystickId } },
            sf.c.sfEvtTouchBegan => .{ .touch_began = .{ .finger = event.touch.finger, .pos = .{ .x = event.touch.x, .y = event.touch.y } } },
            sf.c.sfEvtTouchMoved => .{ .touch_moved = .{ .finger = event.touch.finger, .pos = .{ .x = event.touch.x, .y = event.touch.y } } },
            sf.c.sfEvtTouchEnded => .{ .touch_ended = .{ .finger = event.touch.finger, .pos = .{ .x = event.touch.x, .y = event.touch.y } } },
            sf.c.sfEvtSensorChanged => .{ .sensor_changed = .{ .sensorType = event.sensor.sensorType, .vector = .{ .x = event.sensor.x, .y = event.sensor.y, .z = event.sensor.z } } },
            sf.c.sfEvtCount => @panic("sfEvtCount should't exist as an event!"),
            else => @panic("Unknown event!"),
        };
    }

    /// Gets how many types of event exist
    pub fn getEventCount() usize {
        return @intCast(sf.c.sfEvtCount);
    }

    /// Size events parameters
    pub const SizeEvent = struct {
        size: sf.Vector2u,
    };

    /// Keyboard event parameters
    pub const KeyEvent = struct {
        code: sf.window.keyboard.KeyCode,
        alt: bool,
        control: bool,
        shift: bool,
        system: bool,
    };

    /// Text event parameters
    pub const TextEvent = struct {
        unicode: u32,
    };

    /// Mouse move event parameters
    pub const MouseMoveEvent = struct {
        pos: sf.Vector2i,
    };

    /// Mouse buttons events parameters
    pub const MouseButtonEvent = struct {
        button: sf.window.mouse.Button,
        pos: sf.Vector2i,
    };

    /// Mouse wheel events parameters
    pub const MouseWheelScrollEvent = struct {
        wheel: sf.window.mouse.Wheel,
        delta: f32,
        pos: sf.Vector2i,
    };

    /// Joystick axis move event parameters
    pub const JoystickMoveEvent = struct {
        joystickId: c_uint,
        axis: sf.c.sfJoystickAxis,
        position: f32,
    };

    /// Joystick buttons events parameters
    pub const JoystickButtonEvent = struct {
        joystickId: c_uint,
        button: c_uint,
    };

    /// Joystick connection/disconnection event parameters
    pub const JoystickConnectEvent = struct {
        joystickId: c_uint,
    };

    /// Touch events parameters
    pub const TouchEvent = struct {
        finger: c_uint,
        pos: sf.Vector2i,
    };

    /// Sensor event parameters
    pub const SensorEvent = struct {
        sensorType: sf.c.sfSensorType,
        vector: sf.Vector3f,
    };

    // An event is one of those
    closed,
    resized: SizeEvent,
    lost_focus,
    gained_focus,
    text_entered: TextEvent,
    key_pressed: KeyEvent,
    key_released: KeyEvent,
    mouse_wheel_scrolled: MouseWheelScrollEvent,
    mouse_button_pressed: MouseButtonEvent,
    mouse_button_released: MouseButtonEvent,
    mouse_moved: MouseMoveEvent,
    mouse_entered,
    mouse_left,
    joystick_button_pressed: JoystickButtonEvent,
    joystick_button_released: JoystickButtonEvent,
    joystick_moved: JoystickMoveEvent,
    joystick_connected: JoystickConnectEvent,
    joystick_disconnected: JoystickConnectEvent,
    touch_began: TouchEvent,
    touch_moved: TouchEvent,
    touch_ended: TouchEvent,
    sensor_changed: SensorEvent,
};
