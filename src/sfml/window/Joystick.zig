//! Give access to the real-time state of the joysticks. 

const std = @import("std");
const sf = @import("../sfml_import.zig");

const Joystick = @This();

/// Constants related to joysticks capabilities
pub const MaxJoystickCount = 8;
pub const MaxButtonCount = 32;
pub const MaxAxisCount = 8;

/// Joystick axis
pub const Axis = enum(c_uint) { X, Y, Z, R, U, V, PovX, PovY };

/// Gets a joystick if it is connected, null if it is not
/// Technically, you can use a joystick's getters if it's not connected or before it connects
/// If you wish to do so, just construct the joystick struct by setting _joystick_number to what you want.
pub fn get(joystick: c_uint) ?Joystick {
    std.debug.assert(joystick < MaxJoystickCount);
    if (sf.c.sfJoystick_isConnected(joystick) != 0) {
        return Joystick{ ._joystick_number = joystick };
    } else return null;
}

/// Check if this joystick is still connected
pub fn isConnected(self: Joystick) bool {
    return sf.c.sfJoystick_isConnected(self._joystick_number) != 0;
}

/// Gets the button count of this joystick
pub fn getButtonCount(joystick: Joystick) usize {
    return sf.c.sfJoystick_getButtonCount(joystick._joystick_number);
}
/// Checks if the joystick has a given axis
pub fn hasAxis(self: Joystick, axis: Axis) bool {
    return sf.c.sfJoystick_hasAxis(self._joystick_number, @enumToInt(axis)) != 0;
}

/// Gets the value of an axis
pub fn getAxisPosition(self: Joystick, axis: Axis) f32 {
    return sf.c.sfJoystick_getAxisPosition(self._joystick_number, @enumToInt(axis));
}
/// Checks if a joystick button is pressed
pub fn isButtonPressed(self: Joystick, button: c_uint) bool {
    std.debug.assert(button < MaxButtonCount);
    return sf.c.sfJoystick_isButtonPressed(self._joystick_number, button) != 0;
}

/// ID of this joystick
_joystick_number: c_uint
