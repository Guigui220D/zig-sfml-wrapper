///! This is an example use of the sfml

const std = @import("std");
const sf = @import("sfml");

const allocator = std.heap.page_allocator;

// I only use things I've wrapped here, but the other csfml functions seem to work, just need to wrap them
pub fn main() anyerror!void {
    // Create a window
    var window = try sf.graphics.RenderWindow.init(.{ .x = 800, .y = 600 }, 32, "This is zig!");
    defer window.deinit();
    //window.setVerticalSyncEnabled(false);
    window.setFramerateLimit(60);

    // Shapes creation
    var circle = try sf.graphics.CircleShape.init(100);
    defer circle.deinit();
    circle.setFillColor(sf.graphics.Color.Green);
    circle.setPosition(.{ .x = 0, .y = 0 });
    circle.setOrigin(.{ .x = 100, .y = 100 });
    circle.setTexture(null);

    var bob = try sf.graphics.CircleShape.init(10);
    defer bob.deinit();
    bob.setFillColor(sf.graphics.Color.Red);
    bob.setOrigin(.{ .x = 10, .y = 10 });

    var tex = try sf.graphics.Texture.init(.{ .x = 12, .y = 10 });
    defer tex.deinit();
    std.debug.print("{} * {} = ", .{ tex.getSize().x, tex.getSize().y });
    std.debug.print("{}\n", .{tex.getPixelCount()});
    var pixel_data = try allocator.alloc(sf.graphics.Color, 120);
    defer allocator.free(pixel_data);
    for (pixel_data) |c, i| {
        pixel_data[i] = sf.graphics.Color.fromHSVA(@intToFloat(f32, i) / 144 * 360, 100, 100, 1);
    }
    try tex.updateFromPixels(pixel_data, null);

    var rect = try sf.graphics.RectangleShape.init(.{ .x = 50, .y = 70 });
    defer rect.deinit();
    rect.setPosition(.{ .x = 100, .y = 100 });
    rect.setTexture(tex);

    // Clock
    var clock = try sf.system.Clock.init();
    defer clock.deinit();

    var view = window.getDefaultView();

    // Game loop
    while (window.isOpen()) {
        //Event polling
        while (window.pollEvent()) |event| {
            switch (event) {
                .closed => window.close(),
                .mouseButtonPressed => |e| {
                    var coords = window.mapPixelToCoords(e.pos, null);
                    rect.setPosition(coords);
                },
                else => {},
            }
        }

        //Updating
        var total = clock.getElapsedTime().asSeconds();

        rect.setRotation(total * 12);

        view.center = bob.getPosition();
        if (sf.window.keyboard.isKeyPressed(.A))
            window.setView(view);

        bob.setPosition(window.mapPixelToCoords(sf.window.mouse.getPosition(window), null));

        //std.debug.print("{}\n", .{sf.Mouse.getPosition(window)});

        //Drawing
        window.clear(sf.graphics.Color.Black);
        window.draw(circle, null);
        window.draw(bob, null);
        window.draw(rect, null);
        window.display();
    }
}
