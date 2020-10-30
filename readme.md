# Zig SFML Wrapper

## This is a work in progress! Things work but I want to make pretty classes for everything

This is a wrapper for CSFML. Theres no problem importing CSFML in Zig, but the resulting code can be a little bit messy.
My goal is to make things close enought to SFML, with nice methods.

This is a side project that I just started, it's incomplete so I don't recommend really using it yet (exept if you want to contribute which really isn't hard).

### Compiling

You need to add csfml first at the top of the tree, like that

sfml-wrapper
+ csfml
+ + include
+ + lib
+ src
+ build.zig

Use `zig build run` to run the example program

Use `zig build test` to run the tests (which arent that useful)

### Small example

This is how you get started :

```zig
const std = @import("std");

usingnamespace @import("sfml/sfml_import.zig");
const sf = @import("sfml/sfml.zig");

pub fn main() !void {
    //Create a window
    var window = try sf.RenderWindow.init(.{.x = 800, .y = 600}, 32, "This is zig!");
    defer window.deinit();

    // Game loop
    while (window.isOpen()) {
        // Event polling
        while (window.pollEvent()) |event| {
            switch (event.type) {
                Sf.sfEventType.sfEvtClosed => window.close(),
                else => {}
            }
        }

        // Update your game here

        // Drawing
        window.clear(Sf.sfBlack);
            // Draw stuff here
        window.display();
    }
}
```