//! Target for generalizing draw functions

const sf = @import("../sfml.zig").graphics;

pub const RenderTarget = union(enum) {
    window: *sf.RenderWindow,
    texture: *sf.RenderTexture,

    pub fn draw(self: *const RenderTarget, to_draw: anytype, states: ?sf.RenderStates) void {
        switch (self.*) {
            .window => |w| w.draw(to_draw, states),
            .texture => |t| t.draw(to_draw, states),
        }
    }
};

test "rendertarget tests" {
    // var window = try sf.RenderWindow.createDefault(.{ .x = 10, .y = 10 }, "yo");
    // defer window.destroy();
    var texture = try sf.RenderTexture.create(.{ .x = 10, .y = 10 });
    defer texture.destroy();
    var rect = try sf.RectangleShape.create(.{ .x = 10, .y = 10 });
    defer rect.destroy();

    var target: RenderTarget = undefined;

    // target = .{ .window = &window };
    // target.draw(rect, null);

    target = .{ .texture = &texture };
    target.draw(rect, null);
}
