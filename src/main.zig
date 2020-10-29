const std = @import("std");

usingnamespace @import("sfml/sfml_import.zig");
const sf = @import("sfml/sfml.zig");

pub fn main() anyerror!void {
    var window = try sf.RenderWindow.init(800, 600, 32, "This is zig!");
    defer window.deinit();

    var circle = try sf.CircleShape.init(100);
    defer circle.deinit();
    circle.setFillColor(Sf.sfGreen);
    circle.setPosition(.{.x = 0, .y = 0});
    circle.setOrigin(.{.x = 100, .y = 100});

    var bob = try sf.CircleShape.init(10);
    defer bob.deinit();
    bob.setFillColor(Sf.sfRed);
    bob.setOrigin(.{.x = 10, .y = 10});

    var clock = try sf.Clock.init();
    defer clock.deinit();

    var view = window.getDefaultView();
    defer view.deinit();

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

        view.setCenter(bob.getPosition());
        window.setView(view);

        //Drawing
        window.clear(Sf.sfBlack);
        window.draw(circle, null);
        window.draw(bob, null);
        window.display();
    }
}
