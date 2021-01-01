//! This example generates sound buffer on its own to play them

const sf = @import("sfml");
const std = @import("std");
const allocator = std.heap.page_allocator;

pub fn main() !void {
    const sample_rate: usize = 44100;   //Samples per second, standard for CD
    const channel_count: usize = 1;     //Mono

    //Allocation of samples
    var samples = try allocator.alloc(i16, sample_rate * 5);
    defer allocator.free(samples);

    //Generation of samples
    for (samples) |*sample, index| {
        sample.* = if (index % 441 < 220) -30000 else 30000;
    }

    //Sound buffer initialization
    var sound_buffer = try sf.SoundBuffer.initFromSamples(samples, channel_count, sample_rate);
    defer sound_buffer.deinit();
}
