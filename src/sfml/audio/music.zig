//! Streamed music played from an audio file.

const sf = @import("../sfml.zig");

pub const Music = struct {
    const Self = @This();

    // TODO : Very incomplete

    // Constructor/destructor

    /// Loads music from a file
    pub fn initFromFile(path: [:0]const u8) !Self {
        var music = sf.c.sfMusic_createFromFile(path);
        if (music == null)
            return sf.Error.resourceLoadingError;
        return Self{ .ptr = music.? };
    }

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

    /// Pointer to the csfml texture
    ptr: *sf.c.sfMusic,
};
