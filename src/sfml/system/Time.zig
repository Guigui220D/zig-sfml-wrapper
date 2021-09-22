//! Represents a time value.

const sf = @import("../sfml.zig");

const Time = @This();

// Constructors

/// Converts a time from a csfml object
/// For inner workings
pub fn _fromCSFML(time: sf.c.sfTime) Time {
    return Time{ .us = time.microseconds };
}

/// Converts a time to a csfml object
/// For inner workings
pub fn _toCSFML(self: Time) sf.c.sfTime {
    return sf.c.sfTime{ .microseconds = self.us };
}

/// Creates a time object from a seconds count
pub fn seconds(s: f32) Time {
    return Time{ .us = @floatToInt(i64, s * 1_000) * 1_000 };
}

/// Creates a time object from milliseconds
pub fn milliseconds(ms: i32) Time {
    return Time{ .us = @intCast(i64, ms) * 1_000 };
}

/// Creates a time object from microseconds
pub fn microseconds(us: i64) Time {
    return Time{ .us = us };
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
    return @intToFloat(f32, self.us) / 1_000_000;
}

// Misc

/// Sleeps the amount of time specified
pub fn sleep(time: Time) void {
    sf.c.sfSleep(time._toCSFML());
}

/// A time of zero
pub const Zero = microseconds(0);

us: i64,

pub const TimeSpan = struct {
    // Constructors

    /// Construcs a time span
    pub fn init(begin: Time, length: Time) TimeSpan {
        return TimeSpan{
            .offset = begin,
            .length = length,
        };
    }

    /// Converts a timespan from a csfml object
    /// For inner workings
    pub fn _fromCSFML(span: sf.c.sfTimeSpan) TimeSpan {
        return TimeSpan{
            .offset = Time._fromCSFML(span.offset),
            .length = Time._fromCSFML(span.length),
        };
    }

    /// Converts a timespan to a csfml object
    /// For inner workings
    pub fn _toCSFML(self: TimeSpan) sf.c.sfTimeSpan {
        return sf.c.sfTimeSpan{
            .offset = self.offset._toCSFML(),
            .length = self.length._toCSFML(),
        };
    }

    /// The beginning of this span
    offset: Time,
    /// The length of this time span
    length: Time,
};

test "time: conversion" {
    const tst = @import("std").testing;

    var t = Time.microseconds(5_120_000);

    try tst.expectEqual(@as(i32, 5_120), t.asMilliseconds());
    try tst.expectApproxEqAbs(@as(f32, 5.12), t.asSeconds(), 0.0001);

    t = Time.seconds(12);

    try tst.expectApproxEqAbs(@as(f32, 12), t.asSeconds(), 0.0001);

    t = Time.microseconds(800);
    try tst.expectApproxEqAbs(@as(f32, 0.0008), t.asSeconds(), 0.0001);
}
