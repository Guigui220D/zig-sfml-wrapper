//! Test suite. Most tests are fairly basic, as they're not testing the SFML itself

const std = @import("std");

test "all sfml tests" {
    const sf = @import("sfml.zig");
    std.testing.refAllDecls(sf.system);
    std.testing.refAllDecls(sf.window);
    std.testing.refAllDecls(sf.graphics);
    std.testing.refAllDecls(sf.audio);
}
