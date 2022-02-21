const std = @import("std");
const sf = struct {
    pub usingnamespace @import("sfml");
    pub usingnamespace sf.network;
};

pub fn main() !void {
    const ip = sf.IpAddress.initFromString("google.com");
    std.debug.print("ip: {}\n", .{ ip._ip });
}