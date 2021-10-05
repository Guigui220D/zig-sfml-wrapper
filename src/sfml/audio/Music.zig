//! Streamed music played from an audio file.

const sf = @import("../sfml.zig");

const Music = @This();

// Constructor/destructor

/// Loads music from a file
pub fn createFromFile(path: [:0]const u8) !Music {
    var music = sf.c.sfMusic_createFromFile(path);
    if (music == null)
        return sf.Error.resourceLoadingError;
    return Music{ ._ptr = music.? };
}

pub const initFromMemory = @compileError("Function is not implemented yet.");
pub const initFromStream = @compileError("Function is not implemented yet.");

/// Destroys this music object
pub fn destroy(self: Music) void {
    sf.c.sfMusic_destroy(self._ptr);
}

// Music control functions

/// Plays the music
pub fn play(self: Music) void {
    sf.c.sfMusic_play(self._ptr);
}
/// Pauses the music
pub fn pause(self: Music) void {
    sf.c.sfMusic_pause(self._ptr);
}
/// Stops the music and resets the player position
pub fn stop(self: Music) void {
    sf.c.sfMusic_stop(self._ptr);
}

// Getters / Setters

/// Gets the total duration of the music
pub fn getDuration(self: Music) sf.Time {
    return sf.Time._fromCSFML(sf.c.sfMusic_getDuration(self._ptr));
}

/// Gets the current stream position of the music
pub fn getPlayingOffset(self: Music) sf.Time {
    return sf.Time._fromCSFML(sf.c.sfMusic_getPlayingOffset(self._ptr));
}
/// Sets the current stream position of the music
pub fn setPlayingOffset(self: Music, offset: sf.Time) void {
    sf.c.sfMusic_setPlayingOffset(self._ptr, offset._toCSFML());
}

/// Gets the loop points of the music
pub fn getLoopPoints(self: Music) sf.TimeSpan {
    return sf.TimeSpan._fromCSFML(sf.c.sfMusic_getLoopPoints(self._ptr));
}
/// Gets the loop points of the music
pub fn setLoopPoints(self: Music, span: sf.TimeSpan) void {
    sf.c.sfMusic_setLoopPoints(self._ptr, span._toCSFML());
}

/// Tells whether or not this stream is in loop mode
pub fn getLoop(self: Music) bool {
    return sf.c.sfMusic_getLoop(self._ptr) != 0;
}
/// Enable or disable auto loop
pub fn setLoop(self: Music, loop: bool) void {
    sf.c.sfMusic_setLoop(self._ptr, @boolToInt(loop));
}

/// Sets the pitch of the music
pub fn getPitch(self: Music) f32 {
    return sf.c.sfMusic_getPitch(self._ptr);
}
/// Gets the pitch of the music
pub fn setPitch(self: Music, pitch: f32) void {
    sf.c.sfMusic_setPitch(self._ptr, pitch);
}

/// Sets the volume of the music
pub fn getVolume(self: Music) f32 {
    return sf.c.sfMusic_getVolume(self._ptr);
}
/// Gets the volume of the music
pub fn setVolume(self: Music, volume: f32) void {
    sf.c.sfMusic_setVolume(self._ptr, volume);
}

/// Gets the sample rate of this music
pub fn getSampleRate(self: Music) usize {
    return @intCast(usize, sf.c.sfMusic_getSampleRate(self._ptr));
}

/// Gets the channel count of the music
pub fn getChannelCount(self: Music) usize {
    return @intCast(usize, sf.c.sfMusic_getChannelCount(self._ptr));
}

pub const getStatus = @compileError("Function is not implemented yet.");
pub const setRelativeToListener = @compileError("Function is not implemented yet.");
pub const isRelativeToListener = @compileError("Function is not implemented yet.");
pub const setMinDistance = @compileError("Function is not implemented yet.");
pub const setAttenuation = @compileError("Function is not implemented yet.");
pub const getMinDistance = @compileError("Function is not implemented yet.");
pub const getAttenuation = @compileError("Function is not implemented yet.");

/// Pointer to the csfml music
_ptr: *sf.c.sfMusic,
