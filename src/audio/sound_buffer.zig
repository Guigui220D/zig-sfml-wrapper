//! Storage for audio samples defining a sound.

const sf = @import("../root.zig");
const std = @import("std");

pub const SoundBuffer = union(enum) {
    // Constructor/destructor
    /// Loads sound from a file
    pub fn createFromFile(path: [:0]const u8) !SoundBuffer {
        const sound = sf.c.sfSoundBuffer_createFromFile(path);
        if (sound) |s| {
            return SoundBuffer{ ._ptr = s };
        } else return sf.Error.resourceLoadingError;
    }
    /// Loads sound from a file in memory
    pub fn createFromMemory(data: []const u8) !SoundBuffer {
        const sound = sf.c.sfSoundBuffer_createFromMemory(@as(?*const anyopaque, @ptrCast(data.ptr)), data.len);
        if (sound) |s| {
            return SoundBuffer{ ._ptr = s };
        } else return sf.Error.resourceLoadingError;
    }
    /// Creates a sound buffer from sample data
    pub fn createFromSamples(samples: []const i16, channel_count: usize, sample_rate: usize) !SoundBuffer {
        const sound = sf.c.sfSoundBuffer_createFromSamples(@as([*c]const c_short, @ptrCast(samples.ptr)), samples.len, @as(c_uint, @intCast(channel_count)), @as(c_uint, @intCast(sample_rate)));
        if (sound == null)
            return sf.Error.resourceLoadingError;
        return SoundBuffer{ ._ptr = sound.? };
    }

    // TODO
    //pub const initFromStream = @compileError("Function is not implemented yet.");

    /// Destroys this sound buffer
    /// You can only destroy non const sound buffers
    pub fn destroy(self: *SoundBuffer) void {
        std.debug.assert(self.* == ._ptr);
        sf.c.sfSoundBuffer_destroy(self._ptr);
        self._ptr = undefined;
    }

    // Getters / Setters

    /// Gets the duration of the sound
    pub fn getDuration(self: SoundBuffer) sf.system.Time {
        return sf.system.Time._fromCSFML(sf.c.sfSoundBuffer_getDuration(self._get()));
    }

    /// Gets the sample count of this sound
    pub fn getSampleCount(self: SoundBuffer) usize {
        return @as(usize, @intCast(sf.c.sfSoundBuffer_getSampleCount(self._get())));
    }

    /// Gets the sample rate of this sound (n° of samples per second, often 44100)
    pub fn getSampleRate(self: SoundBuffer) usize {
        return @as(usize, @intCast(sf.c.sfSoundBuffer_getSampleRate(self._get())));
    }

    /// Gets the channel count (2 is stereo for instance)
    pub fn getChannelCount(self: SoundBuffer) usize {
        return @as(usize, @intCast(sf.c.sfSoundBuffer_getChannelCount(self._get())));
    }

    // Misc

    /// Save the sound buffer to an audio file
    pub fn saveToFile(self: SoundBuffer, path: [:0]const u8) !void {
        if (sf.c.sfSoundBuffer_saveToFile(self._get(), path) != 1)
            return sf.Error.savingInFileFailed;
    }

    /// Makes this sound bufer constant (I don't know why you would do that)
    pub fn makeConst(self: *SoundBuffer) void {
        self.* = SoundBuffer{ ._const_ptr = self._get() };
    }

    /// Gets a const reference to this sound buffer
    pub fn getConst(self: SoundBuffer) SoundBuffer {
        var cpy = self;
        cpy.makeConst();
        return cpy;
    }

    /// Gets a const pointer to this sound buffer
    /// For inner workings
    pub fn _get(self: SoundBuffer) *const sf.c.sfSoundBuffer {
        return switch (self) {
            ._ptr => self._ptr,
            ._const_ptr => self._const_ptr,
        };
    }

    /// Pointer to the csfml texture
    _ptr: *sf.c.sfSoundBuffer,
    /// Const pointer to the csfml texture
    _const_ptr: *const sf.c.sfSoundBuffer,
};

test "sound buffer: sane getter and setters" {
    const tst = std.testing;
    const allocator = std.heap.page_allocator;

    const samples = try allocator.alloc(i16, 44100 * 3);
    defer allocator.free(samples);

    var buffer = try SoundBuffer.createFromSamples(samples, 1, 44100);
    defer buffer.destroy();

    try tst.expectApproxEqAbs(@as(f32, 3), buffer.getDuration().asSeconds(), 0.001);
    try tst.expectEqual(@as(usize, 44100 * 3), buffer.getSampleCount());
    try tst.expectEqual(@as(usize, 44100), buffer.getSampleRate());
    try tst.expectEqual(@as(usize, 1), buffer.getChannelCount());
}
