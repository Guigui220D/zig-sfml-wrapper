///! This is an example use of the sfml
const std = @import("std");
const sf = @import("sfml");

const allocator = std.heap.page_allocator;

// I only use things I've wrapped here, but the other csfml functions seem to work, just need to wrap them
pub fn main() anyerror!void {
    // Create a window
    var window = try sf.graphics.RenderWindow.create(.{ .x = 800, .y = 600 }, 32, "This is zig!", sf.window.Style.defaultStyle);
    defer window.destroy();
    //window.setVerticalSyncEnabled(false);
    window.setFramerateLimit(60);

    var vertices: [4]sf.graphics.Vertex = undefined;
    vertices[0] = .{ .position = .{ .x = 0, .y = 0 }, .color = sf.graphics.Color.Red, .tex_coords = .{ .x = 0, .y = 0 } };
    vertices[1] = .{ .position = .{ .x = 0, .y = 50 }, .color = sf.graphics.Color.Yellow, .tex_coords = .{ .x = 0, .y = 0 } };
    vertices[2] = .{ .position = .{ .x = 50, .y = 50 }, .color = sf.graphics.Color.Green, .tex_coords = .{ .x = 0, .y = 0 } };
    vertices[3] = .{ .position = .{ .x = 50, .y = 0 }, .color = sf.graphics.Color.Blue, .tex_coords = .{ .x = 0, .y = 0 } };
    var vertex_array = try sf.graphics.VertexArray.createFromSlice(vertices[0..], sf.graphics.PrimitiveType.Quads);
    defer vertex_array.destroy();

    // Shapes creation
    var circle = try sf.graphics.CircleShape.create(100);
    defer circle.destroy();
    circle.setFillColor(sf.graphics.Color.Green);
    circle.setPosition(.{ .x = 0, .y = 0 });
    circle.setOrigin(.{ .x = 100, .y = 100 });
    circle.setTexture(null);

    var bob = try sf.graphics.CircleShape.create(10);
    defer bob.destroy();
    bob.setFillColor(sf.graphics.Color.Red);
    bob.setOrigin(.{ .x = 10, .y = 10 });

    var tex = try sf.graphics.Texture.create(.{ .x = 12, .y = 10 });
    defer tex.destroy();
    std.debug.print("{} * {} = ", .{ tex.getSize().x, tex.getSize().y });
    std.debug.print("{}\n", .{tex.getPixelCount()});
    var pixel_data = try allocator.alloc(sf.graphics.Color, 120);
    defer allocator.free(pixel_data);
    for (pixel_data) |*c, i| {
        c.* = sf.graphics.Color.fromHSVA(@intToFloat(f32, i) / 144 * 360, 100, 100, 1);
    }
    try tex.updateFromPixels(pixel_data, null);

    var rect = try sf.graphics.RectangleShape.create(.{ .x = 50, .y = 70 });
    defer rect.destroy();
    rect.setPosition(.{ .x = 100, .y = 100 });
    rect.setTexture(tex);

    // Clock
    var clock = try sf.system.Clock.create();
    defer clock.destroy();

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

                    var global_pos = sf.window.mouse.getPosition(null);
                    std.debug.print("Mouse Global Position: {d}, {d}\n", .{ global_pos.x, global_pos.y });
                    var local_pos = sf.window.mouse.getPosition(window);
                    std.debug.print("Mouse Local Position: {d}, {d}\n", .{ local_pos.x, local_pos.y });
                },
                .resized => |resized| {
                    std.debug.print("Window Size from event: {d}, {d}\n", .{ resized.size.x, resized.size.y });
                    const size = window.getSize();
                    std.debug.print("Window Size from window.getSize(): {d}, {d}\n", .{ size.x, size.y });
                },
                .mouseWheelScrolled => |e| {
                    std.debug.print("Wheel: {}, Delta: {}\n", .{ e.wheel, e.delta });
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
        window.draw(vertex_array, null);
        window.display();
    }
}
