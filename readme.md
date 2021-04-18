# Zig SFML Wrapper

## This is a work in progress! Things work but I want to make pretty classes for everything

### Disclaimer

CSFML (and this wrapper in consequence) suffers from issue [#1481](https://github.com/ziglang/zig/issues/1481) of Ziglang, breaking some getter functions.

### What this is

This is a wrapper for CSFML. Theres no problem importing CSFML in Zig, but the resulting code can be a little bit messy.
My goal is to make things close enought to SFML, with nice methods.

### Compiling

You need to add csfml first at the top of the tree, like that

sfml-wrapper
+ csfml
+ + include
+ + lib
+ src
+ build.zig

Use `zig build run-sfml_example` (or an other example name) to run the example program

Use `zig build test` to run the tests (which arent that useful)

### Small example

This is how you get started :

```zig
//! This is a translation of the c++ code the sfml website gives you to test if SFML works
//! for instance, in this page: https://www.sfml-dev.org/tutorials/2.5/start-vc.php

const sf = struct {
    pub usingnamespace @import("sfml");
    pub usingnamespace graphics;
    pub usingnamespace window;
};

pub fn main() !void {
    var window = try sf.RenderWindow.createDefault(.{ .x = 200, .y = 200 }, "SFML works!");
    defer window.destroy();

    var shape = try sf.CircleShape.create(100.0);
    defer shape.destroy();
    shape.setFillColor(sf.Color.Green);

    while (window.isOpen()) {
        while (window.pollEvent()) |event| {
            if (event == .closed)
                window.close();
        }

        window.clear(sf.Color.Black);
        window.draw(shape, null);
        window.display();
    }
}
```
