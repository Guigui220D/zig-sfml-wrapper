//! Utility class that measures the elapsed time. 

usingnamespace @import("sfml_import.zig");
const sf = @import("sfml_errors.zig");

pub const Clock = struct {
    const Self = @This();
    
    // Constructor/destructor

    pub fn init() !Self {
        var clock = Sf.sfClock_create();
        if (clock == null)
            return sf.Error.nullptrUnknownReason;

        return Self{ .ptr = clock.? };
    }

    pub fn deinit(self: Self) void {
        Sf.sfClock_destroy(self.ptr);
    }

    // Clock control
    // TODO : use sfTime instead
    // the std's timer can be used too

    pub fn getElapsedSeconds(self: Self) f32 {
        var time = Sf.sfClock_getElapsedTime(self.ptr);
        return Sf.sfTime_asSeconds(time);
    }

    pub fn restart(self: Self) f32 {
        var time = Sf.sfClock_restart(self.ptr);
        return Sf.sfTime_asSeconds(time);
    }

    // Pointer to the csfml structure
    ptr: *Sf.sfClock
};

const std = @import("std");
const tst = std.testing;

test "clock: sleep test" { 
    var clk = try Clock.init();
    defer clk.deinit();

    std.time.sleep(5_000_000);  //5 ms

    tst.expectWithinMargin(@as(f32, 0.005), clk.getElapsedSeconds(), 0.001);

    std.time.sleep(20_000_000);  //20 ms

    tst.expectWithinMargin(@as(f32, 0.025), clk.restart(), 0.002);
}