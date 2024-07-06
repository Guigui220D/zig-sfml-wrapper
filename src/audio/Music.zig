//! Streamed music played from an audio file.

const sf = struct {
    const sfml = @import("../root.zig");
    pub usingnamespace sfml;
    pub usingnamespace sfml.audio;
    pub usingnamespace sfml.system;
};

const Music = @This();

// Constructor/destructor

/// Loads music from a file
pub fn createFromFile(path: [:0]const u8) !Music {
    const music = sf.c.sfMusic_createFromFile(path);
    if (music) |m| {
        return Music{ ._ptr = m };
    } else return sf.Error.resourceLoadingError;
}
/// Loads music from a file in memory
pub fn createFromMemory(data: []const u8) !Music {
    const music = sf.c.sfMusic_createFromMemory(@as(?*const anyopaque, @ptrCast(data.ptr)), data.len);
    if (music) |m| {
        return Music{ ._ptr = m };
    } else return sf.Error.resourceLoadingError;
}

// TODO
//pub const initFromStream = @compileError("Function is not implemented yet.");

/// Destroys this music object
pub fn destroy(self: *Music) void {
    sf.c.sfMusic_destroy(self._ptr);
    self._ptr = undefined;
}

// Music control functions

/// Plays the music
pub fn play(self: *Music) void {
    sf.c.sfMusic_play(self._ptr);
}
/// Pauses the music
pub fn pause(self: *Music) void {
    sf.c.sfMusic_pause(self._ptr);
}
/// Stops the music and resets the player position
pub fn stop(self: *Music) void {
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
pub fn setPlayingOffset(self: *Music, offset: sf.Time) void {
    sf.c.sfMusic_setPlayingOffset(self._ptr, offset._toCSFML());
}

/// Gets the loop points of the music
pub fn getLoopPoints(self: Music) sf.TimeSpan {
    return sf.TimeSpan._fromCSFML(sf.c.sfMusic_getLoopPoints(self._ptr));
}
/// Gets the loop points of the music
pub fn setLoopPoints(self: *Music, span: sf.TimeSpan) void {
    sf.c.sfMusic_setLoopPoints(self._ptr, span._toCSFML());
}

/// Tells whether or not this stream is in loop mode
pub fn getLoop(self: Music) bool {
    return sf.c.sfMusic_getLoop(self._ptr) != 0;
}
/// Enable or disable auto loop
pub fn setLoop(self: *Music, loop: bool) void {
    sf.c.sfMusic_setLoop(self._ptr, @intFromBool(loop));
}

/// Sets the pitch of the music
pub fn getPitch(self: Music) f32 {
    return sf.c.sfMusic_getPitch(self._ptr);
}
/// Gets the pitch of the music
pub fn setPitch(self: *Music, pitch: f32) void {
    sf.c.sfMusic_setPitch(self._ptr, pitch);
}

/// Sets the volume of the music
pub fn getVolume(self: Music) f32 {
    return sf.c.sfMusic_getVolume(self._ptr);
}
/// Gets the volume of the music
pub fn setVolume(self: *Music, volume: f32) void {
    sf.c.sfMusic_setVolume(self._ptr, volume);
}

/// Gets the sample rate of this music
pub fn getSampleRate(self: Music) usize {
    return @as(usize, @intCast(sf.c.sfMusic_getSampleRate(self._ptr)));
}

/// Gets the channel count of the music
pub fn getChannelCount(self: Music) usize {
    return @as(usize, @intCast(sf.c.sfMusic_getChannelCount(self._ptr)));
}

/// Get the current status of a music (stopped, paused, playing)
pub fn getStatus(self: Music) sf.SoundStatus {
    return @enumFromInt(sf.c.sfMusic_getStatus(self._ptr));
}

/// Tell whether the music's position is relative to the listener or is absolute
pub fn isRelativeToListener(self: Music) bool {
    return sf.c.sfMusic_isRelativeToListener(self._ptr) != 0;
}
/// Make the music's position relative to the listener or absolute
pub fn setRelativeToListener(self: *Music, loop: bool) void {
    sf.c.sfMusic_setRelativeToListener(self._ptr, @intFromBool(loop));
}

/// Set the minimum distance of a music
pub fn setMinDistance(self: *Music, min_distance: f32) void {
    sf.c.sfMusic_setMinDistance(self._ptr, min_distance);
}
/// Get the minimum distance of a music
pub fn getMinDistance(self: Music) f32 {
    return sf.c.sfMusic_getMinDistance(self._ptr);
}

/// Set the attenuation factor of a music
pub fn setAttenuation(self: *Music, attenuation: f32) void {
    sf.c.sfMusic_setAttenuation(self._ptr, attenuation);
}
/// Get the attenuation factor of a music
pub fn getAttenuation(self: Music) f32 {
    return sf.c.sfMusic_getAttenuation(self._ptr);
}

/// Set the 3D position of a music in the audio scene
pub fn setPosition(self: *Music, position: sf.Vector3f) void {
    sf.c.sfMusic_setPosition(self._ptr, position._toCSFML());
}
/// Get the 3D position of a music in the audio scene
pub fn getPosition(self: Music) sf.Vector3f {
    return sf.Vector3f._fromCSFML(sf.c.sfMusic_getPosition(self._ptr));
}

/// Pointer to the csfml music
_ptr: *sf.c.sfMusic,
