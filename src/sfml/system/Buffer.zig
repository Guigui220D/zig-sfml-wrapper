//! Buffer classed used for saveToMemory functions

const sf = struct {
    const sfml = @import("../sfml.zig");
    pub usingnamespace sfml;
};

const Buffer = @This();

// Constructor/destructor

/// Inits an empty buffer.
/// Std.time timer also is a good alternative
pub fn create() !Buffer {
    const buffer = sf.c.sfBuffer_create();
    if (buffer == null)
        return sf.Error.nullptrUnknownReason;

    return Buffer{ ._ptr = buffer.? };
}

/// Destroys this clock
pub fn destroy(self: *Buffer) void {
    sf.c.sfBuffer_destroy(self._ptr);
    self._ptr = undefined;
}

// Getters
/// Get the size of the data stored in the buffer
pub fn getSize(self: Buffer) usize {
    return @intCast(sf.c.sfBuffer_getSize(self._ptr));
}
/// Get the data stored in the buffer as a slice (you don't own the slice)
/// This doesn't seem to work if the buffer wasn't filled by a function
pub fn getData(self: Buffer) []const u8 {
    const size = self.getSize();
    const ptr: [*]const u8 = @ptrCast(sf.c.sfBuffer_getData(self._ptr));
    return ptr[0..size];
}

/// Pointer to the csfml structure
_ptr: *sf.c.sfBuffer,

// Tests

test "buffer: functions compile" {
    const tst = @import("std").testing;

    var buf = try Buffer.create();
    defer buf.destroy();

    try tst.expectEqual(0, buf.getSize());

    // This doesn't seem to work if the buffer wasn't filled by a function
    //const slice = buf.getData();
    //try tst.expectEqual(0, slice.len);
}
