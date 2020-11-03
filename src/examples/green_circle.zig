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