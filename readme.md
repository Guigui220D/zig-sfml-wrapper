# Zig SFML Wrapper

## A pretty interface to use csfml in a way that looks Object-Oriented in zig!

### What this is

This is a wrapper for CSFML. Theres no problem importing CSFML in Zig, but the resulting code can be a little bit messy.
My goal is to make things close enought to SFML, with nice methods.

### How much is done

Most of the classes are wrapped and you should be able to write games with this wrapper. However, some things aren't ready and help is welcome, here are some examples:

- Transforms
- Convex Shapes

I do not plan to implement the network module, since there is already some pretty nice [networking libraries](https://github.com/MasterQ32/zig-network) vailable for zig for udp and tcp stuff.

### Compiling

Check the [wiki](../../wiki) for a small guide on how to compile your project or the examples.

### Small example

This is a small example of how you use this sfml wrapper:

```zig
//! This is a translation of the c++ code the sfml website gives you to test if SFML works
//! for instance, in this page: https://www.sfml-dev.org/tutorials/2.5/start-vc.php

const sf = struct {
    usingnamespace @import("sfml");
    usingnamespace sf.graphics;
    usingnamespace sf.window;
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

### Projects made with this wrapper

[Pong clone I made](https://github.com/Guigui220D/sfml-pong-zig)
