//! Encapsulate an IPv4 network address.

const std = @import("std");
const sf = @import("../sfml.zig");

const IpAddress = @This();

// Const addresses
// TODO: make those comptime
/// Any address or no address
pub fn any() IpAddress {
    return IpAddress.initFromInt(0);
}
pub const none = any;
/// Broadcast address
pub fn broadcast() IpAddress {
    return IpAddress.initFromInt(0xFFFFFFFF);
}
/// Loopback
pub fn localhost() IpAddress {
    return IpAddress.init(127, 0, 0, 1);
}

// Constructor/destructor

/// Inits an ip address from bytes
pub fn init(a: u8, b: u8, c: u8, d: u8) IpAddress {
    return .{ ._ip = sf.c.sfIpAddress_fromBytes(a, b, c, d) };
}
/// Inits an ip address from an integer
pub fn initFromInt(int: u32) IpAddress {
    return .{ ._ip = sf.c.sfIpAddress_fromInteger(int) }; 
}
/// Inits an ip address from a string (network name or ip)
pub fn initFromString(str: [*:0]const u8) IpAddress {
    return .{ ._ip = sf.c.sfIpAddress_fromString(str) }; 
}

// Local/global addresses

/// Gets the local address of this pc (takes no time)
pub fn getLocalAddress() IpAddress {
    return .{ ._ip = sf.c.sfIpAddress_getLocalAddress() }; 
}
/// Gets the public address of this pc (from outside)
/// Takes time because it needs to contact an internet server
/// Specify a timeout in case it takes too much time
pub fn getPublicAddress(timeout: ?sf.system.Time) !IpAddress {
    const time = timeout orelse sf.system.Time{ .us = 0 };
    const ip = IpAddress{ ._ip = sf.c.sfIpAddress_getPublicAddress(time._toCSFML()) };
    if (ip.equals(IpAddress.none()))
        return sf.Error.timeout;
    return ip;
}

// Compare

/// Compares two ip addresses
pub fn equals(self: IpAddress, other: IpAddress) bool {
    return std.mem.eql(u8, self.bytes(), other.bytes());
}

fn bytes(self: IpAddress) []const u8 {
    return @ptrCast(*const [16]u8, &self._ip)[0..];
}

// Getter

/// Gets the ip as an int
pub fn toInt(self: IpAddress) u32 {
    // TODO: this doesn't compile because of c abi problems, find a workaround
    return sf.c.sfIpAddress_toInteger(self._ip);
}

/// Csfml structure
_ip: sf.c.sfIpAddress,

test "ipaddress" {
    const tst = std.testing;

    var ip = IpAddress.init(0x01, 0x23, 0x45, 0x67);
    try tst.expect(ip.equals(IpAddress.initFromInt(0x01234567)));
    ip = IpAddress.initFromInt(0xabababab);
    try tst.expect(ip.equals(IpAddress.init(0xab, 0xab, 0xab, 0xab)));
    ip = IpAddress.initFromString("localhost");
    try tst.expect(ip.equals(IpAddress.localhost()));

    //toInt();

    _ = getLocalAddress();
    _ = getPublicAddress(sf.system.Time.microseconds(1)) catch {};
}