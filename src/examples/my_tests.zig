///! This is an example use of the sfml
const std = @import("std");

const sf = @import("sfml");

// I only use things I've wrapped here, but the other csfml functions seem to work, just need to wrap them
pub fn main() anyerror!void {
    // Create a window
    var window = try sf.RenderWindow.init(.{ .x = 800, .y = 600 }, 32, "This is zig!");
    defer window.deinit();
    //window.setVerticalSyncEnabled(false);
    window.setFramerateLimit(60);

    // Shapes creation
    var circle = try sf.CircleShape.init(100);
    defer circle.deinit();
    circle.setFillColor(sf.Color.Green);
    circle.setPosition(.{ .x = 0, .y = 0 });
    circle.setOrigin(.{ .x = 100, .y = 100 });

    var bob = try sf.CircleShape.init(10);
    defer bob.deinit();
    bob.setFillColor(sf.Color.Red);
    bob.setOrigin(.{ .x = 10, .y = 10 });

    var tex = try sf.Texture.initFromFile("test.png");
    defer tex.deinit();

    var rect = try sf.RectangleShape.init(.{ .x = 50, .y = 70 });
    defer rect.deinit();
    rect.setFillColor(sf.Color.Yellow);
    rect.setPosition(.{ .x = 100, .y = 100 });
    rect.setTexture(tex);

    // Clock
    var clock = try sf.Clock.init();
    defer clock.deinit();

    var view = window.getDefaultView();

    // Game loop
    while (window.isOpen()) {
        //Event polling
        while (window.pollEvent()) |event| {
            switch (event.type) {
                sf.c.sfEventType.sfEvtClosed => window.close(),
                sf.c.sfEventType.sfEvtMouseButtonPressed => {
                    //std.debug.print("click\n", .{});
                    var vec = sf.Vector2i{
                        .x = event.mouseButton.x,
                        .y = event.mouseButton.y,
                    };
                    var coords = window.mapPixelToCoords(vec, null);
                    rect.setPosition(coords);
                },
                else => {},
            }
        }

        //Updating
        var total = clock.getElapsedTime().asSeconds();
        bob.setPosition(.{ .x = 150.0 * std.math.cos(total), .y = 120.0 * std.math.sin(total) });

        rect.setRotation(total * 12);

        view.center = bob.getPosition();
        if (sf.Keyboard.isKeyPressed(.A))
            window.setView(view);

        //Drawing
        window.clear(sf.Color.Black);
        window.draw(circle, null);
        window.draw(bob, null);
        window.draw(rect, null);
        window.display();
    }
}
