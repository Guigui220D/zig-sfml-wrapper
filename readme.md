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
//! This is a translation of the c++ code the sfml website gives you to test if SFML works

const sf = @import("sfml");

pub fn main() !void {
    var window = try sf.RenderWindow.init(.{.x = 200, .y = 200}, 32, "SFML works!");
    defer window.deinit();

    var shape = try sf.CircleShape.init(100.0);
    defer shape.deinit();
    shape.setFillColor(sf.Color.Green);

    while (window.isOpen()) {
        while (window.pollEvent()) |event| {
            if (event.type == sf.c.sfEventType.sfEvtClosed) //TODO : events
                window.close();
        }

        window.clear(sf.Color.Black);
        window.draw(shape, null);
        window.display();
    }
}
```