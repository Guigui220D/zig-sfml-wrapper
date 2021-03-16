//! Defines a system event and its parameters.

const sf = struct {
    pub usingnamespace @import("../sfml.zig");
    pub usingnamespace system;
};

pub const Event = union(Event.Type) {
    const Self = @This();

    pub const Type = enum(c_int) {
        closed,
        resized,
        lostFocus,
        gainedFocus,
        textEntered,
        keyPressed,
        keyReleased,
        mouseWheelScrolled,
        mouseButtonPressed,
        mouseButtonReleased,
        mouseMoved,
        mouseEntered,
        mouseLeft,
        joystickButtonPressed,
        joystickButtonReleased,
        joystickMoved,
        joystickConnected,
        joystickDisconnected,
        touchBegan,
        touchMoved,
        touchEnded,
        sensorChanged,
    };

    // Big oof
    /// Creates this event from a csfml one
    pub fn fromCSFML(event: sf.c.sfEvent) Self {
        return switch (event.type) {
            sf.c.sfEventType.sfEvtClosed => .{ .closed = {} },
            sf.c.sfEventType.sfEvtResized => .{ .resized = .{ .size = .{ .x = event.size.width, .y = event.size.height } } },
            sf.c.sfEventType.sfEvtLostFocus => .{ .lostFocus = {} },
            sf.c.sfEventType.sfEvtGainedFocus => .{ .gainedFocus = {} },
            sf.c.sfEventType.sfEvtTextEntered => .{ .textEntered = .{ .unicode = event.text.unicode } },
            sf.c.sfEventType.sfEvtKeyPressed => .{ .keyPressed = .{ .code = @intToEnum(sf.window.keyboard.KeyCode, @enumToInt(event.key.code)), .alt = (event.key.alt != 0), .control = (event.key.control != 0), .shift = (event.key.shift != 0), .system = (event.key.system != 0) } },
            sf.c.sfEventType.sfEvtKeyReleased => .{ .keyReleased = .{ .code = @intToEnum(sf.window.keyboard.KeyCode, @enumToInt(event.key.code)), .alt = (event.key.alt != 0), .control = (event.key.control != 0), .shift = (event.key.shift != 0), .system = (event.key.system != 0) } },
            sf.c.sfEventType.sfEvtMouseWheelMoved, sf.c.sfEventType.sfEvtMouseWheelScrolled => .{ .mouseWheelScrolled = .{ .wheel = @intToEnum(sf.window.mouse.Wheel, @enumToInt(event.mouseWheelScroll.wheel)), .delta = event.mouseWheelScroll.delta, .pos = .{ .x = event.mouseWheelScroll.x, .y = event.mouseWheelScroll.y } } },
            sf.c.sfEventType.sfEvtMouseButtonPressed => .{ .mouseButtonPressed = .{ .button = @intToEnum(sf.window.mouse.Button, @enumToInt(event.mouseButton.button)), .pos = .{ .x = event.mouseButton.x, .y = event.mouseButton.y } } },
            sf.c.sfEventType.sfEvtMouseButtonReleased => .{ .mouseButtonReleased = .{ .button = @intToEnum(sf.window.mouse.Button, @enumToInt(event.mouseButton.button)), .pos = .{ .x = event.mouseButton.x, .y = event.mouseButton.y } } },
            sf.c.sfEventType.sfEvtMouseMoved => .{ .mouseMoved = .{ .pos = .{ .x = event.mouseMove.x, .y = event.mouseMove.y } } },
            sf.c.sfEventType.sfEvtMouseEntered => .{ .mouseEntered = {} },
            sf.c.sfEventType.sfEvtMouseLeft => .{ .mouseLeft = {} },
            sf.c.sfEventType.sfEvtJoystickButtonPressed => .{ .joystickButtonPressed = .{ .joystickId = event.joystickButton.joystickId, .button = event.joystickButton.button } },
            sf.c.sfEventType.sfEvtJoystickButtonReleased => .{ .joystickButtonReleased = .{ .joystickId = event.joystickButton.joystickId, .button = event.joystickButton.button } },
            sf.c.sfEventType.sfEvtJoystickMoved => .{ .joystickMoved = .{ .joystickId = event.joystickMove.joystickId, .axis = event.joystickMove.axis, .position = event.joystickMove.position } },
            sf.c.sfEventType.sfEvtJoystickConnected => .{ .joystickConnected = .{ .joystickId = event.joystickConnect.joystickId } },
            sf.c.sfEventType.sfEvtJoystickDisconnected => .{ .joystickDisconnected = .{ .joystickId = event.joystickConnect.joystickId } },
            sf.c.sfEventType.sfEvtTouchBegan => .{ .touchBegan = .{ .finger = event.touch.finger, .pos = .{ .x = event.touch.x, .y = event.touch.y } } },
            sf.c.sfEventType.sfEvtTouchMoved => .{ .touchMoved = .{ .finger = event.touch.finger, .pos = .{ .x = event.touch.x, .y = event.touch.y } } },
            sf.c.sfEventType.sfEvtTouchEnded => .{ .touchEnded = .{ .finger = event.touch.finger, .pos = .{ .x = event.touch.x, .y = event.touch.y } } },
            sf.c.sfEventType.sfEvtSensorChanged => .{ .sensorChanged = .{ .sensorType = event.sensor.sensorType, .vector = .{ .x = event.sensor.x, .y = event.sensor.y, .z = event.sensor.z } } },
            sf.c.sfEventType.sfEvtCount => @panic("sfEvtCount should't exist as an event!"),
            else => @panic("Unknown event!"),
        };
    }

    /// Gets how many types of event exist
    pub fn getEventCount() c_uint {
        return @enumToInt(sf.c.sfEventType.sfEvtCount);
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
    closed: void,
    resized: SizeEvent,
    lostFocus: void,
    gainedFocus: void,
    textEntered: TextEvent,
    keyPressed: KeyEvent,
    keyReleased: KeyEvent,
    mouseWheelScrolled: MouseWheelScrollEvent,
    mouseButtonPressed: MouseButtonEvent,
    mouseButtonReleased: MouseButtonEvent,
    mouseMoved: MouseMoveEvent,
    mouseEntered: void,
    mouseLeft: void,
    joystickButtonPressed: JoystickButtonEvent,
    joystickButtonReleased: JoystickButtonEvent,
    joystickMoved: JoystickMoveEvent,
    joystickConnected: JoystickConnectEvent,
    joystickDisconnected: JoystickConnectEvent,
    touchBegan: TouchEvent,
    touchMoved: TouchEvent,
    touchEnded: TouchEvent,
    sensorChanged: SensorEvent,
};
