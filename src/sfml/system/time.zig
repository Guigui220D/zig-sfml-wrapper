//! Represents a time value.

usingnamespace @import("../sfml_import.zig");

pub const Time = struct {
    const Self = @This();

    // Constructors

    /// Creates a time object from a seconds count
    pub fn seconds(s: f32) Time {
        return Self{ .us = @floatToInt(i64, s * 1_000) * 1_000 };
    }

    /// Creates a time object from milliseconds
    pub fn milliseconds(ms: i32) Time {
        return Self{ .us = @intCast(i64, ms) * 1_000 };
    }

    /// Creates a time object from microseconds
    pub fn microseconds(us: i64) Time {
        return Self{ .us = us };
    }

    // Getters

    /// Gets this time measurement as microseconds
    pub fn asMicroseconds(self: Time) i64 {
        return self.us;
    }

    /// Gets this time measurement as milliseconds
    pub fn asMilliseconds(self: Time) i32 {
        return @truncate(i32, @divFloor(self.us, 1_000));
    }

    /// Gets this time measurement as seconds (as a float)
    pub fn asSeconds(self: Time) f32 {
        return @intToFloat(f32, @divFloor(self.us, 1_000)) / 1_000;
    }

    // Misc

    /// Sleeps the amount of time specified
    pub fn sleep(time: Time) void {
        Sf.sfSleep(Sf.sfTime{ .microseconds = time.us });
    }

    us: i64
};

const tst = @import("std").testing;

test "time: conversion" {
    var t = Time.microseconds(5_120_000);

    tst.expectEqual(@as(i32, 5_120), t.asMilliseconds());
    tst.expectWithinMargin(@as(f32, 5.12), t.asSeconds(), 0.0001);

    t = Time.seconds(12);

    tst.expectWithinMargin(@as(f32, 12), t.asSeconds(), 0.0001);
}
