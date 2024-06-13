//! This the same example as presented on the sfml website
//! https://www.sfml-dev.org/documentation/2.6.1/

const sf = struct {
    const sfml = @import("sfml");
    usingnamespace sfml;
    usingnamespace sfml.audio;
    usingnamespace sfml.graphics;
    usingnamespace sfml.window;
    usingnamespace sfml.system;
};

pub fn main() !void {
    // Create the main window
    var window = try sf.RenderWindow.create(.{ .x = 800, .y = 600 }, 32, "SFML window", sf.Style.defaultStyle, null);
    defer window.destroy();

    // Load a sprite to display
    var texture = try sf.Texture.createFromFile("cute_image.png");
    defer texture.destroy();
    var sprite = try sf.Sprite.createFromTexture(texture);
    defer sprite.destroy();

    // Create a graphical text to display
    var font = try sf.Font.createFromFile("arial.ttf");
    defer font.destroy();
    var text = try sf.Text.createWithText("Hello SFML", font, 50);
    defer text.destroy();

    // Loads a music to play
    var music = try sf.Music.createFromFile("funnysong.mp3");
    defer music.destroy();
    music.play();

    // Start the game loop
    while (window.isOpen()) {
        // Process events
        while (window.pollEvent()) |event| {
            // Close window: exit
            if (event == .closed)
                window.close();
        }

        // Clear screen
        window.clear(sf.Color.Black);

        // Draw the sprite
        window.draw(sprite, null);

        // Draw the string
        window.draw(text, null);

        //Update the window
        window.display();
    }
}
