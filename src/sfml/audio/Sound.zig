//! Regular sound that can be played in the audio environment.

const sf = struct {
    pub usingnamespace @import("../sfml.zig");
    pub usingnamespace sf.audio;
};

const Sound = @This();

// Constructor/destructor

/// Inits an empty sound
pub fn create() !Sound {
    var sound = sf.c.sfSound_create();
    if (sound) |s| {
        return Sound{ ._ptr = s };
    } else return sf.Error.nullptrUnknownReason;
}

/// Inits a sound with a SoundBuffer object
pub fn createFromBuffer(buffer: sf.SoundBuffer) !Sound {
    var sound = try Sound.create();
    sound.setBuffer(buffer);
    return sound;
}

/// Destroys this sound object
pub fn destroy(self: *Sound) void {
    sf.c.sfSound_destroy(self._ptr);
    self._ptr = undefined;
}

// Sound control functions

/// Plays the sound
pub fn play(self: *Sound) void {
    sf.c.sfSound_play(self._ptr);
}
/// Pauses the sound
pub fn pause(self: *Sound) void {
    sf.c.sfSound_pause(self._ptr);
}
/// Stops the sound and resets the player position
pub fn stop(self: *Sound) void {
    sf.c.sfSound_stop(self._ptr);
}

// Getters / Setters

/// Gets the buffer this sound is attached to
pub fn getBuffer(self: Sound) ?sf.SoundBuffer {
    var buf = sf.c.sfSound_getBuffer(self._ptr);
    if (buf) |buffer| {
        return .{ ._ptr = buffer };
    } else return null;
}

/// Sets the buffer this sound will play
pub fn setBuffer(self: *Sound, buffer: sf.SoundBuffer) void {
    sf.c.sfSound_setBuffer(self._ptr, buffer._ptr);
}

/// Gets the current playing offset of the sound
pub fn getPlayingOffset(self: Sound) sf.Time {
    return sf.Time._fromCSFML(sf.c.sfSound_getPlayingOffset(self._ptr));
}
/// Sets the current playing offset of the sound
pub fn setPlayingOffset(self: *Sound, offset: sf.Time) void {
    sf.c.sfSound_setPlayingOffset(self._ptr, offset._toCSFML());
}

/// Tells whether or not this sound is in loop mode
pub fn getLoop(self: Sound) bool {
    return sf.c.sfSound_getLoop(self._ptr) != 0;
}
/// Enable or disable auto loop
pub fn setLoop(self: *Sound, loop: bool) void {
    sf.c.sfSound_setLoop(self._ptr, @boolToInt(loop));
}

/// Sets the pitch of the sound
pub fn getPitch(self: Sound) f32 {
    return sf.c.sfSound_getPitch(self._ptr);
}
/// Gets the pitch of the sound
pub fn setPitch(self: *Sound, pitch: f32) void {
    sf.c.sfSound_setPitch(self._ptr, pitch);
}

/// Sets the volume of the sound
pub fn getVolume(self: Sound) f32 {
    return sf.c.sfSound_getVolume(self._ptr);
}
/// Gets the volume of the sound
pub fn setVolume(self: *Sound, volume: f32) void {
    sf.c.sfSound_setVolume(self._ptr, volume);
}

pub const getStatus = @compileError("Function is not implemented yet.");
pub const setRelativeToListener = @compileError("Function is not implemented yet.");
pub const isRelativeToListener = @compileError("Function is not implemented yet.");
pub const setMinDistance = @compileError("Function is not implemented yet.");
pub const setAttenuation = @compileError("Function is not implemented yet.");
pub const getMinDistance = @compileError("Function is not implemented yet.");
pub const getAttenuation = @compileError("Function is not implemented yet.");

/// Pointer to the csfml sound
_ptr: *sf.c.sfSound,
