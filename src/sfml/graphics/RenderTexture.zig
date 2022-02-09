//! Target for off-screen 2D rendering into a texture. 

const sf = struct {
    pub usingnamespace @import("../sfml.zig");
    pub usingnamespace sf.system;
    pub usingnamespace sf.graphics;
};

const RenderTexture = @This();

// Constructor/destructor

/// Inits a render texture with a size (use createWithDepthBuffer if you want a depth buffer)
pub fn create(size: sf.Vector2u) !RenderTexture {
    var rtex = sf.c.sfRenderTexture_create(size.x, size.y, 0); //0 means no depth buffer

    if (rtex) |t| {
        return RenderTexture{ ._ptr = t };
    } else return sf.Error.nullptrUnknownReason;
}
/// Inits a render texture with a size, it will have a depth buffer
pub fn createWithDepthBuffer(size: sf.Vector2u) !RenderTexture {
    var rtex = sf.c.sfRenderTexture_create(size.x, size.y, 1);

    if (rtex) |t| {
        return .{ ._ptr = t };
    } else return sf.Error.nullptrUnknownReason;
}

/// Destroys this render texture
pub fn destroy(self: *RenderTexture) void {
    sf.c.sfRenderTexture_destroy(self._ptr);
    self._ptr = undefined;
}

// Drawing functions

/// Clears the drawing target with a color
pub fn clear(self: *RenderTexture, color: sf.Color) void {
    sf.c.sfRenderTexture_clear(self._ptr, color._toCSFML());
}

/// Updates the texture with what has been drawn on the render area
pub fn display(self: *RenderTexture) void {
    sf.c.sfRenderTexture_display(self._ptr);
}

/// Draw something on the texture (won't be visible until display is called)
/// Object must have a sfDraw function (look at CircleShape for reference)
/// You can pass a render state or null for default
pub fn draw(self: *RenderTexture, to_draw: anytype, states: ?sf.RenderStates) void {
    const T = @TypeOf(to_draw);
    if (comptime @import("std").meta.trait.hasFn("sfDraw")(T)) {
        // Inline call of object's draw function
        if (states) |s| {
            var cstates = s._toCSFML();
            @call(.{ .modifier = .always_inline }, T.sfDraw, .{ to_draw, self.*, &cstates });
        } else @call(.{ .modifier = .always_inline }, T.sfDraw, .{ to_draw, self.*, null });
        // to_draw.sfDraw(self, states);
    } else @compileError("You must provide a drawable object (struct with \"sfDraw\" method).");
}

/// Gets a const reference to the target texture (the reference doesn't change)
pub fn getTexture(self: RenderTexture) sf.Texture {
    const tex = sf.c.sfRenderTexture_getTexture(self._ptr);
    return sf.Texture{ ._const_ptr = tex.? };
}

// Texture related stuff

/// Generates a mipmap for the current texture data, returns true if the operation succeeded
pub fn generateMipmap(self: *RenderTexture) bool {
    return sf.c.sfRenderTexture_generateMipmap(self._ptr) != 0;
}

/// Tells whether or not the texture is to be smoothed
pub fn isSmooth(self: RenderTexture) bool {
    return sf.c.sfRenderTexture_isSmooth(self._ptr) != 0;
}
/// Enables or disables texture smoothing
pub fn setSmooth(self: *RenderTexture, smooth: bool) void {
    sf.c.sfRenderTexture_setSmooth(self._ptr, @boolToInt(smooth));
}

/// Tells whether or not the texture should repeat when rendering outside its bounds
pub fn isRepeated(self: RenderTexture) bool {
    return sf.c.sfRenderTexture_isRepeated(self._ptr) != 0;
}
/// Enables or disables texture repeating
pub fn setRepeated(self: *RenderTexture, repeated: bool) void {
    sf.c.sfRenderTexture_setRepeated(self._ptr, @boolToInt(repeated));
}

/// Gets the size of this window
pub fn getSize(self: RenderTexture) sf.Vector2u {
    return sf.Vector2u._fromCSFML(sf.c.sfRenderTexture_getSize(self._ptr));
}

// Target related stuff

/// Gets the current view of the target
/// Unlike in SFML, you don't get a const pointer but a copy
pub fn getView(self: RenderTexture) sf.View {
    return sf.View._fromCSFML(sf.c.sfRenderTexture_getView(self._ptr).?);
}
/// Gets the default view of this target
/// Unlike in SFML, you don't get a const pointer but a copy
pub fn getDefaultView(self: RenderTexture) sf.View {
    return sf.View._fromCSFML(sf.c.sfRenderTexture_getDefaultView(self._ptr).?);
}
/// Sets the view of this target
pub fn setView(self: *RenderTexture, view: sf.View) void {
    var cview = view._toCSFML();
    defer sf.c.sfView_destroy(cview);
    sf.c.sfRenderTexture_setView(self._ptr, cview);
}
/// Gets the viewport of this target
pub fn getViewport(self: RenderTexture, view: sf.View) sf.IntRect {
    return sf.IntRect._fromCSFML(sf.c.sfRenderTexture_getViewPort(self._ptr, view._ptr));
}

/// Convert a point from target coordinates to world coordinates, using the current view (or the specified view)
pub fn mapPixelToCoords(self: RenderTexture, pixel: sf.Vector2i, view: ?sf.View) sf.Vector2f {
    if (view) |v| {
        var cview = v._toCSFML();
        defer sf.c.sfView_destroy(cview);
        return sf.Vector2f._fromCSFML(sf.c.sfRenderTexture_mapPixelToCoords(self._ptr, pixel._toCSFML(), cview));
    } else return sf.Vector2f._fromCSFML(sf.c.sfRenderTexture_mapPixelToCoords(self._ptr, pixel._toCSFML(), null));
}
/// Convert a point from world coordinates to target coordinates, using the current view (or the specified view)
pub fn mapCoordsToPixel(self: RenderTexture, coords: sf.Vector2f, view: ?sf.View) sf.Vector2i {
    if (view) |v| {
        var cview = v._toCSFML();
        defer sf.c.sfView_destroy(cview);
        return sf.Vector2i._fromCSFML(sf.c.sfRenderTexture_mapCoordsToPixel(self._ptr, coords._toCSFML(), cview));
    } else return sf.Vector2i._fromCSFML(sf.c.sfRenderTexture_mapCoordsToPixel(self._ptr, coords._toCSFML(), null));
}

/// Pointer to the csfml structure
_ptr: *sf.c.sfRenderTexture,

test "rendertexture tests" {
    const tst = @import("std").testing;

    var rentex = try RenderTexture.create(.{ .x = 10, .y = 10 });
    defer rentex.destroy();

    rentex.setRepeated(true);
    rentex.setSmooth(true);

    rentex.clear(sf.Color.Red);
    {
        var rect = try sf.RectangleShape.create(.{ .x = 5, .y = 5 });
        defer rect.destroy();

        rect.setFillColor(sf.Color.Blue);

        rentex.draw(rect, null);
    }
    rentex.display();

    _ = rentex.generateMipmap();

    try tst.expect(rentex.isRepeated());
    try tst.expect(rentex.isSmooth());

    const tex = rentex.getTexture();

    try tst.expectEqual(sf.Vector2u{ .x = 10, .y = 10 }, tex.getSize());
    try tst.expectEqual(sf.Vector2u{ .x = 10, .y = 10 }, rentex.getSize());

    var img = tex.copyToImage();
    defer img.destroy();

    try tst.expectEqual(sf.Color.Blue, img.getPixel(.{ .x = 1, .y = 1 }));
    try tst.expectEqual(sf.Color.Red, img.getPixel(.{ .x = 6, .y = 3 }));
}
