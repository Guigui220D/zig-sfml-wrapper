//! Utility class that measures the elapsed time. 

usingnamespace @import("../sfml_import.zig");
const sf = @import("../sfml_errors.zig");

pub const Clock = struct {
    const Self = @This();
    
    // Constructor/destructor

    /// Inits a clock. The clock will have its time set at 0 at this point, and automatically starts
    /// Std.time timer also is a good alternative
    pub fn init() !Self {
        var clock = Sf.sfClock_create();
        if (clock == null)
            return sf.Error.nullptrUnknownReason;

        return Self{ .ptr = clock.? };
    }

    /// Destroys this clock
    pub fn deinit(self: Self) void {
        Sf.sfClock_destroy(self.ptr);
    }

    // Clock control
    // TODO : use sfTime instead
    // the std's timer can be used too

    /// Gets the elapsed seconds
    pub fn getElapsedSeconds(self: Self) f32 {
        var time = Sf.sfClock_getElapsedTime(self.ptr);
        return Sf.sfTime_asSeconds(time);
    }

    /// Gets the elapsed seconds and restarts the timer
    pub fn restart(self: Self) f32 {
        var time = Sf.sfClock_restart(self.ptr);
        return Sf.sfTime_asSeconds(time);
    }

    /// Pointer to the csfml structure
    ptr: *Sf.sfClock
};

const std = @import("std");
const tst = std.testing;

test "clock: sleep test" { 
    // This tests just sleeps and check what the timer measured (not very accurate but eh)
    var clk = try Clock.init();
    defer clk.deinit();

    std.time.sleep(500_000_000);  //500 ms

    tst.expectWithinMargin(@as(f32, 0.5), clk.getElapsedSeconds(), 0.1);

    std.time.sleep(200_000_000);  //200 ms

    tst.expectWithinMargin(@as(f32, 0.7), clk.restart(), 0.1);
    tst.expectWithinMargin(@as(f32, 0), clk.getElapsedSeconds(), 0.01);
}