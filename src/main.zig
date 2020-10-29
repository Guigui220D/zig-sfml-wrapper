const std = @import("std");

usingnamespace @import("sfml/sfml_import.zig");
const sf = @import("sfml/sfml.zig");

pub fn main() anyerror!void {
    var window = try sf.RenderWindow.init(200, 200, 32, "This is zig!");
    defer window.deinit();

    var circle = try sf.CircleShape.init(100);
    defer circle.deinit();
    circle.setFillColor(Sf.sfGreen);
    circle.setPosition(.{.x = 0, .y = 50});

    while (window.isOpen()) {
        //Event polling
        while (window.pollEvent()) |event| {
            switch (event.type) {
                Sf.sfEventType.sfEvtClosed => window.close(),
                else => {}
            }
        }

        //Drawing
        window.clear(Sf.sfBlack);
        window.draw(circle, null);
        window.display();
    }
}
