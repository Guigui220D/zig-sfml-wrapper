//! Contains socket utils for all socket types (not a subtype for polymorphism)

const sf = struct {
    pub usingnamespace @import("../sfml.zig");
    pub usingnamespace sf.network;
};

pub const Error = error {
    notReady,
    partial,
    disconnected,
    otherError
};

pub fn codeToErr(code: sf.c.sfSocketStatus) Error!void {
    switch (code) {
        sf.c.sfSocketDone => return,
        sf.c.sfSocketNotReady => return error.notReady,
        sf.c.sfSocketPartial => return error.partial,
        sf.c.sfSocketDisconnected => return error.disconnected,
        sf.c.sfSocketError => return error.otherError,
        else => unreachable
    }
}

pub const ReceivedRaw = struct {
    data: []const u8,
    sender: sf.IpAndPort
};