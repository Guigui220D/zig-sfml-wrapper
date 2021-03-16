//! Test suite. Most tests are fairly basic, as they're not testing the SFML itself

test "all sfml tests" {
    const sf = @import("sfml.zig");
    _ = sf.system;
    _ = sf.window;
    _ = sf.graphics;
    _ = sf.audio;
}
