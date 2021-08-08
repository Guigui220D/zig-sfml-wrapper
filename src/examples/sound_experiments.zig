//! This example generates sound buffer on its own to play them

const sf = @import("sfml");
const std = @import("std");
const allocator = std.heap.page_allocator;

pub fn main() !void {
    const sample_rate: usize = 44100; //Samples per second, standard for CD
    const channel_count: usize = 1; //Mono

    //Allocation of samples
    var samples = try allocator.alloc(i16, sample_rate * 1);
    defer allocator.free(samples);

    //Generation of samples
    sineWave(samples, 44100, 20000, 440);

    //Sound buffer initialization
    var sound_buffer = try sf.audio.SoundBuffer.createFromSamples(samples, channel_count, sample_rate);
    defer sound_buffer.destroy();

    //Sound initializaion
    var sound = try sf.audio.Sound.createFromBuffer(sound_buffer);
    defer sound.destroy();

    //Playing the sound
    sound.setVolume(10); //So it doesn't break your ears
    sound.setPitch(2);
    sound.play();

    sf.system.Time.sleep(sound_buffer.getDuration());

    try sound_buffer.saveToFile("test.wav");
}

pub fn sineWave(buffer: []i16, sample_rate: u32, height: f32, freq: f32) void {
    for (buffer) |*sample, index| {
        sample.* = @floatToInt(i16, (1.0 + @sin(@intToFloat(f32, index) / @intToFloat(f32, sample_rate) * 2 * 3.1415 * freq) / 2.0 * height));
    }
}
