//! Storage for audio samples defining a sound. 

const sf = @import("../sfml.zig");

const SoundBuffer = @This();

// Constructor/destructor
/// Loads music from a file
pub fn createFromFile(path: [:0]const u8) !SoundBuffer {
    var sound = sf.c.sfSoundBuffer_createFromFile(path);
    if (sound == null)
        return sf.Error.resourceLoadingError;
    return SoundBuffer{ .ptr = sound.? };
}
/// Creates a sound buffer from sample data
pub fn createFromSamples(samples: []const i16, channel_count: usize, sample_rate: usize) !SoundBuffer {
    var sound = sf.c.sfSoundBuffer_createFromSamples(@ptrCast([*c]const c_short, samples.ptr), samples.len, @intCast(c_uint, channel_count), @intCast(c_uint, sample_rate));
    if (sound == null)
        return sf.Error.resourceLoadingError;
    return SoundBuffer{ .ptr = sound.? };
}

pub const initFromMemory = @compileError("Function is not implemented yet.");
pub const initFromStream = @compileError("Function is not implemented yet.");

/// Destroys this music object
pub fn destroy(self: SoundBuffer) void {
    sf.c.sfSoundBuffer_destroy(self.ptr);
}

// Getters / Setters

/// Gets the duration of the sound
pub fn getDuration(self: SoundBuffer) sf.system.Time {
    return sf.system.Time.fromCSFML(sf.c.sfSoundBuffer_getDuration(self.ptr));
}

/// Gets the sample count of this sound
pub fn getSampleCount(self: SoundBuffer) usize {
    return @intCast(usize, sf.c.sfSoundBuffer_getSampleCount(self.ptr));
}

/// Gets the sample rate of this sound (n° of samples per second, often 44100)
pub fn getSampleRate(self: SoundBuffer) usize {
    return @intCast(usize, sf.c.sfSoundBuffer_getSampleRate(self.ptr));
}

/// Gets the channel count (2 is stereo for instance)
pub fn getChannelCount(self: SoundBuffer) usize {
    return @intCast(usize, sf.c.sfSoundBuffer_getChannelCount(self.ptr));
}

// Misc

/// Save the sound buffer to an audio file
pub fn saveToFile(self: SoundBuffer, path: [:0]const u8) !void {
    if (sf.c.sfSoundBuffer_saveToFile(self.ptr, path) != 1)
        return sf.Error.savingInFileFailed;
}

/// Pointer to the csfml texture
ptr: *sf.c.sfSoundBuffer,

test "sound buffer: sane getter and setters" {
    const std = @import("std");
    const tst = std.testing;
    const allocator = std.heap.page_allocator;

    var samples = try allocator.alloc(i16, 44100 * 3);
    defer allocator.free(samples);

    var buffer = try SoundBuffer.createFromSamples(samples, 1, 44100);
    defer buffer.destroy();

    try tst.expectApproxEqAbs(@as(f32, 3), buffer.getDuration().asSeconds(), 0.001);
    try tst.expectEqual(@as(usize, 44100 * 3), buffer.getSampleCount());
    try tst.expectEqual(@as(usize, 44100), buffer.getSampleRate());
    try tst.expectEqual(@as(usize, 1), buffer.getChannelCount());
}
