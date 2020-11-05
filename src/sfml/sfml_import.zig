//! Imports the csfml c headers

pub const c = @cImport({
    @cInclude("SFML/Graphics.h");
    @cInclude("SFML/Window.h");
    @cInclude("SFML/System.h");
    @cInclude("SFML/Audio.h");
});
