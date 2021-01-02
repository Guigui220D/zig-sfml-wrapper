//! Streamed music played from an audio file.

const sf = @import("../sfml.zig");

pub const Music = struct {
    const Self = @This();

    // Constructor/destructor

    /// Loads music from a file
    pub fn initFromFile(path: [:0]const u8) !Self {
        var music = sf.c.sfMusic_createFromFile(path);
        if (music == null)
            return sf.Error.resourceLoadingError;
        return Self{ .ptr = music.? };
    }

    pub const initFromMemory = @compileError("Function is not implemented yet.");
    pub const initFromStream = @compileError("Function is not implemented yet.");

    /// Destroys this music object
    pub fn deinit(self: Self) void {
        sf.c.sfMusic_destroy(self.ptr);
    }

    // Music control functions

    /// Plays the music
    pub fn play(self: Self) void {
        sf.c.sfMusic_play(self.ptr);
    }
    /// Pauses the music
    pub fn pause(self: Self) void {
        sf.c.sfMusic_pause(self.ptr);
    }
    /// Stops the music and resets the player position
    pub fn stop(self: Self) void {
        sf.c.sfMusic_stop(self.ptr);
    }

    // Getters / Setters

    /// Gets the total duration of the music
    pub fn getDuration(self: Self) sf.Time {
        return sf.Time.fromCSFML(sf.c.sfMusic_getDuration(self.ptr));
    }

    /// Gets the current stream position of the music
    pub fn getPlayingOffset(self: Self) sf.Time {
        return sf.Time.fromCSFML(sf.c.sfMusic_getPlayingOffset(self.ptr));
    }
    /// Sets the current stream position of the music
    pub fn setPlayingOffset(self: Self, offset: sf.Time) void {
        sf.c.sfMusic_setPlayingOffset(self.ptr, offset.toCSFML());
    }

    /// Gets the loop points of the music
    pub fn getLoopPoints(self: Self) sf.TimeSpan {
        return sf.TimeSpan.fromCSFML(sf.c.sfMusic_getLoopPoints(self.ptr));
    }
    /// Gets the loop points of the music
    pub fn setLoopPoints(self: Self, span: sf.TimeSpan) void {
        sf.c.sfMusic_setLoopPoints(self.ptr, span.toCSFML());
    }

    /// Tells whether or not this stream is in loop mode
    pub fn getLoop(self: Self) bool {
        return sf.c.sfMusic_getLoop(self.ptr) != 0;
    }
    /// Enable or disable auto loop
    pub fn setLoop(self: Self, loop: bool) void {
        sf.c.sfMusic_setLoop(self.ptr, if (loop) 1 else 0);
    }

    /// Sets the pitch of the music
    pub fn getPitch(self: Self) f32 {
        return sf.c.sfMusic_getPitch(self.ptr);
    }
    /// Gets the pitch of the music
    pub fn setPitch(self: Self, pitch: f32) void {
        sf.c.sfMusic_setPitch(self.ptr, pitch);
    }

    /// Sets the volume of the music
    pub fn getVolume(self: Self) f32 {
        return sf.c.sfMusic_getVolume(self.ptr);
    }
    /// Gets the volume of the music
    pub fn setVolume(self: Self, volume: f32) void {
        sf.c.sfMusic_setVolume(self.ptr, volume);
    }

    /// Gets the sample rate of this music
    pub fn getSampleRate(self: Self) usize {
        return @intCast(usize, sf.c.sfMusic_getSampleRate(self.ptr));
    }

    /// Gets the channel count of the music
    pub fn getChannelCount(self: Self) usize {
        return @intCast(usize, sf.c.sfMusic_getChannelCount(self.ptr));
    }

    pub const getStatus = @compileError("Function is not implemented yet.");
    pub const setRelativeToListener = @compileError("Function is not implemented yet.");
    pub const isRelativeToListener = @compileError("Function is not implemented yet.");
    pub const setMinDistance = @compileError("Function is not implemented yet.");
    pub const setAttenuation = @compileError("Function is not implemented yet.");
    pub const getMinDistance = @compileError("Function is not implemented yet.");
    pub const getAttenuation = @compileError("Function is not implemented yet.");

    /// Pointer to the csfml music
    ptr: *sf.c.sfMusic,
};
