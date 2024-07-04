const std = @import("std");

pub inline fn toUnicodeComptime(utf8: []const u8) [:0]const u32 {
    comptime {
        var view = std.unicode.Utf8View.initComptime(utf8);
        var iter = view.iterator();

        var result: [:0]const u32 = &.{};
        while (iter.nextCodepoint()) |c| {
            result = result ++ [1]u32{c};
        }

        return result;
    }
}

pub fn toUnicodeAlloc(alloc: std.mem.Allocator, utf8: []const u8) ![:0]const u32 {
    var arr = try std.ArrayList(u32).initCapacity(alloc, utf8.len + 1);
    errdefer arr.deinit();

    var view = try std.unicode.Utf8View.init(utf8);
    var iter = view.iterator();

    while (iter.nextCodepoint()) |c| {
        arr.append(c) catch unreachable; // We already allocated enough space
    }

    arr.append(0) catch unreachable;

    var ret: [:0]const u32 = @ptrCast(try arr.toOwnedSlice());
    ret.len -= 1; // I have to exclude manually the 0?
    return ret;
}

test "Utf8 to Utf32 comptime" {
    const tst = std.testing;

    const str1 = toUnicodeComptime("Hi! 😁 你好");
    try tst.expectEqualSlices(u32, &[_]u32{ 'H', 'i', '!', ' ', 0x1f601, ' ', 0x4f60, 0x597d }, str1);
    try tst.expectEqual(0, str1[str1.len]);
}

test "Utf8 to Utf32" {
    const tst = std.testing;
    const alloc = tst.allocator;

    const str1 = try toUnicodeAlloc(alloc, "é👓ب");
    defer alloc.free(str1);

    try tst.expectEqualSlices(u32, &[_]u32{ 0xe9, 0x1f453, 0x628 }, str1);
    try tst.expectEqual(0, str1[str1.len]);
}
