//! Cursor defines the appearance of a system cursor.

const std = @import("std");
const sf = struct {
    const sfml = @import("../root.zig");
    pub usingnamespace sfml;
    pub usingnamespace sfml.system;
};

const Cursor = @This();

/// Enumeration of the native system cursor types
pub const Type = enum(c_uint) {
    /// Arrow cursor (default)
    arrow,
    /// Busy arrow cursor
    arrow_wait,
    /// Busy cursor
    wait,
    /// I-beam, cursor when hovering over a field allowing text entry
    text,
    /// Pointing hand cursor
    hand,
    /// Horizontal double arrow cursor
    size_horizontal,
    /// Vertical double arrow cursor
    size_vertical,
    /// Double arrow cursor going from top-left to bottom-right
    size_top_left_bottom_right,
    /// Double arrow cursor going from bottom-left to top-right
    size_bottom_left_top_right,
    /// Left arrow cursor on Linux, same as sizeHorizontal on other platforms
    size_left,
    /// Right arrow cursor on Linux, same as sizeHorizontal on other platforms
    size_right,
    /// Up arrow cursor on Linux, same as sizeVertical on other platforms
    size_top,
    /// Down arrow cursor on Linux, same as sizeVertical on other platforms
    size_bottom,
    /// Top-left arrow cursor on Linux, same as sizeTopLeftBottomRight on other platforms
    size_top_left,
    /// Bottom-right arrow cursor on Linux, same as sizeTopLeftBottomRight on other platforms
    size_bottom_right,
    /// Bottom-left arrow cursor on Linux, same as sizeBottomLeftTopRight on other platforms
    size_bottom_left,
    /// Top-right arrow cursor on Linux, same as sizeBottomLeftTopRight on other platforms
    size_top_right,
    /// Combination of sizeHorizontal and sizeVertical
    size_all,
    /// Crosshair cursor
    cross,
    /// Help cursor
    help,
    /// Action not allowed cursor
    not_allowed,
};

// Constructors and destructors

/// Create a cursor with the provided image
pub fn createFromPixels(pixels: []const u8, size: sf.Vector2u, hotspot: sf.Vector2u) !Cursor {
    // Check slice length
    if (pixels.len != size.x * size.y * @sizeOf(u32))
        return sf.Error.wrongDataSize;
    // Create the cursor
    const cursor = sf.c.sfCursor_createFromPixels(@ptrCast(pixels.ptr), size._toCSFML(), hotspot._toCSFML());
    if (cursor == null)
        return sf.Error.nullptrUnknownReason;
    return Cursor{ ._ptr = cursor.? };
}
/// Create a native system cursor
pub fn createFromSystem(cursor_type: Type) !Cursor {
    const cursor = sf.c.sfCursor_createFromSystem(@intFromEnum(cursor_type));
    if (cursor == null)
        return sf.Error.nullptrUnknownReason;
    return Cursor{ ._ptr = cursor.? };
}

/// Destroy a cursor
pub fn destroy(self: *Cursor) void {
    sf.c.sfCursor_destroy(self._ptr);
    self._ptr = undefined;
}

/// Pointer to the csfml structure
_ptr: *sf.c.sfCursor,

test "cursor: createFromSystem" {
    var cursor = try Cursor.createFromSystem(.arrow);
    defer cursor.destroy();
}
