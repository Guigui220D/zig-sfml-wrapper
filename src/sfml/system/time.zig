//! Represents a time value.

pub const Time = struct {
    const Self = @This();

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

    us: i64
};

const tst = @import("std").testing;

test "time: conversion" { 
    var t = Time{.us = 5_120_000};

    tst.expectEqual(@as(i32, 5_120), t.asMilliseconds());
    tst.expectWithinMargin(@as(f32, 5.12), t.asSeconds(), 0.0001);
}