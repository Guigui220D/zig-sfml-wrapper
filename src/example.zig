///! This is an example use of the sfml

const std = @import("std");

usingnamespace @import("sfml/sfml_import.zig");
const sf = @import("sfml/sfml.zig");

// I only use things I've wrapped here, but the other csfml functions seem to work, just need to wrap them
pub fn main() anyerror!void {
    // Create a window
    var window = try sf.RenderWindow.init(.{.x = 800, .y = 600}, 32, "This is zig!");
    defer window.deinit();

    // Shapes creation
    var circle = try sf.CircleShape.init(100);
    defer circle.deinit();
    circle.setFillColor(Sf.sfGreen);
    circle.setPosition(.{.x = 0, .y = 0});
    circle.setOrigin(.{.x = 100, .y = 100});

    var bob = try sf.CircleShape.init(10);
    defer bob.deinit();
    bob.setFillColor(Sf.sfRed);
    bob.setOrigin(.{.x = 10, .y = 10});

    var rect = try sf.RectangleShape.init(.{.x = 50, .y = 70});
    defer rect.deinit();
    rect.setFillColor(Sf.sfYellow);
    rect.setPosition(.{.x = 100, .y = 100});

    // Clock
    var clock = try sf.Clock.init();
    defer clock.deinit();

    var view = window.getDefaultView();

    // Game loop
    while (window.isOpen()) {
        //Event polling
        while (window.pollEvent()) |event| {
            switch (event.type) {
                Sf.sfEventType.sfEvtClosed => window.close(),
                else => {}
            }
        }

        //Updating
        var total = clock.getElapsedSeconds();
        bob.setPosition(.{.x = 150.0 * std.math.cos(total), .y = 120.0 * std.math.sin(total)});

        rect.setRotation(total * 12);

        view.center = bob.getPosition();
        window.setView(view);

        //Drawing
        window.clear(Sf.sfBlack);
        window.draw(circle, null);
        window.draw(bob, null);
        window.draw(rect, null);
        window.display();
    }
}
