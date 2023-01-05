//! This is a translation of the code present on this page: https://github.com/SFML/SFML/wiki/Source%3A-HeatHazeShader
//! This example is here to show shaders work
//! Original code by binary1248

const sf = struct {
    const sfml = @import("sfml");
    usingnamespace sfml;
    usingnamespace sfml.graphics;
    usingnamespace sfml.window;
    usingnamespace sfml.system;
};

pub fn main() !void {
    var window = try sf.RenderWindow.createDefault(.{ .x = 600, .y = 600 }, "Heat");
    defer window.destroy();
    window.setVerticalSyncEnabled(true);

    var object_texture = try sf.Texture.createFromFile("cute_image.png");
    defer object_texture.destroy();

    var object = try sf.Sprite.createFromTexture(object_texture);
    defer object.destroy();
    //object.setScale(.{ .x = 0.5, .y = 0.5 });

    var distortion_map = try sf.Texture.createFromFile("distortion_map.png");
    defer distortion_map.destroy();
    distortion_map.setRepeated(true);
    distortion_map.setSmooth(true);

    var render_texture = try sf.RenderTexture.create(.{ .x = 400, .y = 300 });
    defer render_texture.destroy();

    var sprite = try sf.Sprite.createFromTexture(render_texture.getTexture());
    sprite.setPosition(.{ .x = 100, .y = 150 });

    //var shader = try sf.Shader.createFromFile(null, null, "heat_shader.fs");
    var shader = try sf.Shader.createFromFile(null, null, "heat_shader.fs");
    defer shader.destroy();
    shader.setUniform("currentTexture", sf.Shader.CurrentTexture);
    shader.setUniform("distortionMapTexture", distortion_map);

    var distortion_factor: f32 = 0.05;
    var rise_factor: f32 = 2;

    var clock = try sf.Clock.create();
    defer clock.destroy();

    while (true) {
        while (window.pollEvent()) |event| {
            switch (event) {
                .closed => return,
                .keyPressed => |kp| {
                    switch (kp.code) {
                        .Escape => return,
                        .Up => distortion_factor *= 2,
                        .Down => distortion_factor /= 2,
                        .Right => rise_factor *= 2,
                        .Left => rise_factor /= 2,
                        else => {},
                    }
                },
                else => {},
            }
        }

        shader.setUniform("time", clock.getElapsedTime().asSeconds());
        shader.setUniform("distortionFactor", distortion_factor);
        shader.setUniform("riseFactor", rise_factor);

        render_texture.clear(sf.Color.Black);
        render_texture.draw(object, null);
        render_texture.display();

        window.clear(sf.Color.Black);
        window.draw(sprite, sf.RenderStates{ .shader = shader });
        window.display();
    }
}
