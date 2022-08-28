//! Multiplexer that allows to read from multiple sockets.

const sf = struct {
    pub usingnamespace @import("../sfml.zig");
    pub usingnamespace sf.network;
};

const SocketSelector = @This();

// Constructor/destructor

/// Creates a new socket selector
pub fn create() SocketSelector {
    var sock = sf.c.sfSocketSelector_create();
    if (sock) |s| {
        return SocketSelector{ ._ptr = s };
    } else
        return sf.Error.nullptrUnknownReason;
}
/// Destroys this socket selector
pub fn destroy(self: *SocketSelector) void {
    sf.c.sfSocketSelector_destroy(self._ptr);
}
/// Copies this socket selector
pub fn copy(self: SocketSelector) SocketSelector {
    var sock = sf.c.sfSocketSelector_copy(self._ptr);
    if (sock) |s| {
        return SocketSelector{ ._ptr = s };
    } else
        return sf.Error.nullptrUnknownReason;
}

// Methods

/// Adds a socket to the selector
pub fn addSocket(self: *SocketSelector, socket: anytype) void {
    switch (@TypeOf(socket)) {
        sf.UdpSocket => sf.c.sfSocketSelector_addUdpSocket(self._ptr, socket._ptr),
        sf.TcpSocket => sf.c.sfSocketSelector_addTcpSocket(self._ptr, socket._ptr),
        sf.TcpListener => sf.c.sfSocketSelector_addTcpListener(self._ptr, socket._ptr),
        else => @compileError("Socket has to be a tcp socket, tcp listener or udp socket")
    }
}
/// Removes a socket from the selector
pub fn removeSocket(self: *SocketSelector, socket: anytype) void {
    switch (@TypeOf(socket)) {
        sf.UdpSocket => sf.c.sfSocketSelector_removeUdpSocket(self._ptr, socket._ptr),
        sf.TcpSocket => sf.c.sfSocketSelector_removeTcpSocket(self._ptr, socket._ptr),
        sf.TcpListener => sf.c.sfSocketSelector_removeTcpListener(self._ptr, socket._ptr),
        else => @compileError("Socket has to be a tcp socket, tcp listener or udp socket")
    }
}
/// Removes all sockets from the selector
pub fn clear(self: *SocketSelector) void {
    sf.c.sfSocketSelector_clear(self._ptr);
}

/// Wait until one of the sockets is ready to receive something (or timeout)
/// Returns true if one of the sockets is ready and false if timeout
pub fn wait(self: SocketSelector, timeout: sf.system.Time) bool {
    const time = timeout orelse sf.system.Time{ .us = 0 };
    const ret = sf.c.sfSocketSelector_wait(self._ptr, time._toCSFML());
    return ret != 0;
}

/// Checks one socket to know if it's ready to read data
pub fn isSocketReady(self: SocketSelector, socket: anytype) bool {
    switch (@TypeOf(socket)) {
        sf.UdpSocket => sf.c.sfSocketSelector_isUdpSocketReady(self._ptr, socket._ptr),
        sf.TcpSocket => sf.c.sfSocketSelector_isTcpSocketReady(self._ptr, socket._ptr),
        sf.TcpListener => sf.c.sfSocketSelector_isTcpListenerReady(self._ptr, socket._ptr),
        else => @compileError("Socket has to be a tcp socket, tcp listener or udp socket")
    }
}

/// Pointer to the csfml structure
_ptr: *sf.c.sfSocketSelector,