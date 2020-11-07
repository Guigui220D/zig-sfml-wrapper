//! This the same example as presented on the sfml website
//! https://www.sfml-dev.org/documentation/2.5.1/

const sf = @import("sfml");

pub fn main() !void {
    // Create the main window
    var window = try sf.RenderWindow.init(.{ .x = 800, .y = 600 }, 32, "SFML window");
    defer window.deinit();

    // Load a sprite to display
    var texture = try sf.Texture.initFromFile("cute_image.png");
    defer texture.deinit();
    var sprite = try sf.Sprite.initFromTexture(texture);
    defer sprite.deinit();

    // Create a graphical text to display
    var font = try sf.Font.initFromFile("arial.ttf");
    defer font.deinit();
    var text = try sf.Text.initWithText("Hello SFML", font, 50);
    defer text.deinit();

    // Loads a music to play
    var music = try sf.Music.initFromFile("nice_music.ogg");
    defer music.deinit();
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
