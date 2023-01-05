//! Contains socket utils for all socket types (not a subtype for polymorphism)

const sf = struct {
    pub usingnamespace @import("../sfml.zig");
    pub usingnamespace sf.network;
};

/// Miscellaneous errors that can occur when handling sockets (connecting, sending, receiving, etc...)
pub const Error = error{ notReady, partial, disconnected, otherError };

/// Turns a csfml error code into a proper zig error
/// For this wrapper's internal workings
pub fn _codeToErr(code: sf.c.sfSocketStatus) Error!void {
    switch (code) {
        sf.c.sfSocketDone => return,
        sf.c.sfSocketNotReady => return error.notReady,
        sf.c.sfSocketPartial => return error.partial,
        sf.c.sfSocketDisconnected => return error.disconnected,
        sf.c.sfSocketError => return error.otherError,
        else => unreachable,
    }
}
