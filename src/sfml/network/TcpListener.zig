//! A TCP listener socket

const sf = struct {
    pub usingnamespace @import("../sfml.zig");
    pub usingnamespace sf.network;
};

const TcpListener = @This();

// Constructor/destructor

/// Creates a new tcp listener socket
pub fn create() !TcpListener {
    var sock = sf.c.sfTcpListener_create();
    if (sock) |s| {
        return TcpListener{ ._ptr = s };
    } else
        return sf.Error.nullptrUnknownReason;
}
/// Destroys this socket
pub fn destroy(self: *TcpListener) void {
    sf.c.sfTcpListener_destroy(self._ptr);
}

// Methods

/// Enables or disables blocking mode (true for blocking)
/// In blocking mode, receive waits for data
pub fn setBlocking(self: *TcpListener, blocking: bool) void {
    sf.c.sfTcpListener_setBlocking(self._ptr, @boolToInt(blocking));
}
/// Tells whether or not the socket is in blocking mode
pub fn isBlocking(self: TcpListener) bool {
    return sf.c.sfTcpListener_isBlocking(self._ptr) != 0;
}

/// Gets the port this socket is listening on
/// Error if the socket is not listening
pub fn getLocalPort(self: TcpListener) error{notListening}!u16 {
    const port = sf.c.sfTcpListener_getLocalPort(self._ptr);
    if (port == 0)
        return error.notListening;
    return port;
}

/// Starts listening for incoming connections on a given port (and address)
/// If address is null, it listens on any address of this machine
pub fn listen(self: *TcpListener, port: u16, address: ?sf.IpAddress) sf.Socket.Error!void {
    const ip = if (address) |i| i._ip else sf.c.sfIpAddress_Any;
    const code = sf.c.sfTcpListener_listen(self._ptr, port, ip);
    try sf.Socket._codeToErr(code);
}
/// Accepts a new connection, returns a tcp socket if it works
/// If the tcp is in blocking mode, it will wait
pub fn accept(self: *TcpListener) sf.Socket.Error!?sf.TcpSocket {
    var ret: sf.TcpSocket = undefined;
    const retptr = @ptrCast([*c]?*sf.c.sfTcpSocket, &(ret._ptr));
    const code = sf.c.sfTcpListener_accept(self._ptr, retptr);
    if (!self.isBlocking() and code == sf.c.sfSocketNotReady)
        return null;
    try sf.Socket._codeToErr(code);
    return ret;
}

/// Pointer to the csfml structure
_ptr: *sf.c.sfTcpListener,

// TODO: write tests