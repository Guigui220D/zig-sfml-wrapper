//! Regular sound that can be played in the audio environment.

const sf = struct {
    const sfml = @import("../root.zig");
    pub usingnamespace sfml;
    pub usingnamespace sfml.audio;
    pub usingnamespace sfml.system;
};

const Sound = @This();

// Constructor/destructor

/// Inits an empty sound
pub fn create() !Sound {
    const sound = sf.c.sfSound_create();
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
/// Not valid if a buffer was never assigned (but not null?)
pub fn getBuffer(self: Sound) ?sf.SoundBuffer {
    const buf = sf.c.sfSound_getBuffer(self._ptr);
    if (buf) |buffer| {
        return .{ ._const_ptr = buffer };
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
    sf.c.sfSound_setLoop(self._ptr, @intFromBool(loop));
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

/// Get the current status of a sound (stopped, paused, playing)
pub fn getStatus(self: Sound) sf.SoundStatus {
    return @enumFromInt(sf.c.sfSound_getStatus(self._ptr));
}

/// Tell whether the sound's position is relative to the listener or is absolute
pub fn isRelativeToListener(self: Sound) bool {
    return sf.c.sfSound_isRelativeToListener(self._ptr) != 0;
}
/// Make the sound's position relative to the listener or absolute
pub fn setRelativeToListener(self: *Sound, loop: bool) void {
    sf.c.sfSound_setRelativeToListener(self._ptr, @intFromBool(loop));
}

/// Set the minimum distance of a sound
pub fn setMinDistance(self: *Sound, min_distance: f32) void {
    sf.c.sfSound_setMinDistance(self._ptr, min_distance);
}
/// Get the minimum distance of a sound
pub fn getMinDistance(self: Sound) f32 {
    return sf.c.sfSound_getMinDistance(self._ptr);
}

/// Set the attenuation factor of a sound
pub fn setAttenuation(self: *Sound, attenuation: f32) void {
    sf.c.sfSound_setAttenuation(self._ptr, attenuation);
}
/// Get the attenuation factor of a sound
pub fn getAttenuation(self: Sound) f32 {
    return sf.c.sfSound_getAttenuation(self._ptr);
}

/// Set the 3D position of a sound in the audio scene
pub fn setPosition(self: *Sound, position: sf.Vector3f) void {
    sf.c.sfSound_setPosition(self._ptr, position._toCSFML());
}
/// Get the 3D position of a sound in the audio scene
pub fn getPosition(self: Sound) sf.Vector3f {
    return sf.Vector3f._fromCSFML(sf.c.sfSound_getPosition(self._ptr));
}

/// Pointer to the csfml sound
_ptr: *sf.c.sfSound,

test "Sound: sane getters and setters" {
    const tst = @import("std").testing;

    var sound = try Sound.create();
    defer sound.destroy();

    sound.setLoop(true);
    sound.setAttenuation(0.5);
    sound.setMinDistance(10.0);
    sound.setPitch(1.2);
    sound.setRelativeToListener(true);
    sound.setVolume(2.0);
    sound.setPosition(sf.vector3f(1.0, 2.0, 3.0));

    try tst.expectEqual(sf.SoundStatus.stopped, sound.getStatus());
    try tst.expectEqual(sf.Time.seconds(0), sound.getPlayingOffset());
    try tst.expect(sound.getLoop());
    try tst.expectApproxEqAbs(0.5, sound.getAttenuation(), 0.001);
    try tst.expectApproxEqAbs(10.0, sound.getMinDistance(), 0.001);
    try tst.expectApproxEqAbs(1.2, sound.getPitch(), 0.001);
    try tst.expect(sound.isRelativeToListener());
    try tst.expectApproxEqAbs(2.0, sound.getVolume(), 0.001);

    const pos = sound.getPosition();
    try tst.expectApproxEqAbs(1.0, pos.x, 0.001);
    try tst.expectApproxEqAbs(2.0, pos.y, 0.001);
    try tst.expectApproxEqAbs(3.0, pos.z, 0.001);
}
