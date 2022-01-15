const std = @import("std");

pub fn utf8toUnicode(comptime utf8: []const u8) []const u32 {
    const uni = std.unicode;

    var ret = comptime t: {
        var view = uni.Utf8View.initComptime(utf8);
        var iter = view.iterator();

        var result: []const u32 = &[0]u32{};
        while (iter.nextCodepoint()) |c| {
            result = result ++ [1]u32{c};
        }

        break :t result;
    };

    return ret;
}
