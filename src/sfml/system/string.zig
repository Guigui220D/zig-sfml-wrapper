//! String utils. This modules is not the same as the one is the C++ SFML.

const std = @import("std");

pub const String = union(String.Type) {
    /// Constructs a unicode string at comptime from a string litteral
    pub fn fromUtf8(comptime utf8: []const u8) String {
        const uni = std.unicode;
    
        var ret = comptime t: {
            var view = uni.Utf8View.initComptime(utf8);
            var iter = view.iterator();

            var result: []const u32 = &[0]u32{};
            while (iter.nextCodepoint()) |c| {
                result = result ++ [1]u32{ c };
            }

            break :t result;
        };

        return String { .unicode = ret };
    }

    /// Tells whether or not to use the unicode setString or setTitle for an sfml function
    pub fn needsUnicode(self: String) bool {
        return self != .ascii;
    }

    /// Gets this string as unicode
    pub fn getUnicode(self: String, allocator: *std.mem.Allocator) ![]const u32 {
        switch (self) {
            .unicode => |s| return s.unicode,
            .utf8 => |s| return try utf8ToUnicode(s, allocator),
            .ascii => |s| return try utf8ToUnicode(s, allocator)
        }
    }
    /// Gets this string as ascii, only works if the string is in ascii
    pub fn getAscii(self: String) []const u8 {
        if (needsUnicode(self))
            @panic("Cannot convert a unicode string to ascii string");
        return ascii;
    } 

    /// Frees a pointer given by getUnicode
    pub fn getUnicodeFree(self: String, allocator: *std.mem.Allocator, ptr: []const u32) void {
        switch (self) {
            .unicode => |_| {},
            .utf8 => |_| allocator.free(ptr),
            .ascii => |_| allocator.free(ptr)
        }
    }

    fn utf8ToUnicode(str: []const u8, allocator: *std.mem.Allocator) ![]const u32 {
        const uni = std.unicode;

        var buf = try allocator.alloc(u32, std.unicode.utf8CountCodepoints(str));
        errdefer allocator.free(buf);

        var view = try uni.Utf8View.init(utf8);
        var iter = view.iterator();

        for (buf) |*i| {
            i.* = iter.nextCodepoint().?;
        }

        return buf;
    }

    const Type = {
        unicode,
        utf8,
        ascii
    };

    unicode: []const u32,
    utf8: []const u8,
    ascii: []const u8,
}