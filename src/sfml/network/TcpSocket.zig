//! Socket using the TCP protocol

const std = @import("std");
const sf = struct {
    pub usingnamespace @import("../sfml.zig");
    pub usingnamespace sf.network;
};

const TcpSocket = @This();

// Constructor/destructor

/// Creates a new udp socket
pub fn create() !TcpSocket {
    var sock = sf.c.sfTcpSocket_create();
    if (sock) |s| {
        return TcpSocket{ ._ptr = s };
    } else return sf.Error.nullptrUnknownReason;
}
/// Destroys this socket
pub fn destroy(self: *TcpSocket) void {
    sf.c.sfTcpSocket_destroy(self._ptr);
}

// Methods

/// Enables or disables blocking mode (true for blocking)
/// In blocking mode, receive waits for data
pub fn setBlocking(self: *TcpSocket, blocking: bool) void {
    sf.c.sfTcpSocket_setBlocking(self._ptr, @intFromBool(blocking));
}
/// Tells whether or not the socket is in blocking mode
pub fn isBlocking(self: TcpSocket) bool {
    return sf.c.sfTcpSocket_isBlocking(self._ptr) != 0;
}

/// Gets the port this socket is bound to (null for no port)
pub fn getLocalPort(self: TcpSocket) ?u16 {
    const port = sf.c.sfTcpSocket_getLocalPort(self._ptr);
    return if (port == 0) null else port;
}
/// Gets the address of the other tcp socket that is currently connected
pub fn getRemote(self: TcpSocket) error{notConnected}!sf.IpAndPort {
    const port = sf.c.sfTcpSocket_getRemotePort(self._ptr);
    if (port == 0)
        return error.notConnected;
    const ip = sf.c.sfTcpSocket_getRemoteAddress(self._ptr);
    const ip_and_port = sf.IpAndPort{ .ip = .{ ._ip = ip }, .port = port };
    std.debug.assert(!ip_and_port.ip.equals(sf.IpAddress.none()));
    return ip_and_port;
}

/// Connects to a server (the server typically has a Tcp Listener)
/// To connect to clients, use a tcp listener instead and wait for connections
pub fn connect(self: *TcpSocket, remote: sf.IpAndPort, timeout: sf.system.Time) sf.Socket.Error!void {
    const code = sf.c.sfTcpSocket_connect(self._ptr, remote.ip._ip, remote.port, timeout._toCSFML());
    try sf.Socket._codeToErr(code);
}
/// Disconnects from the remote
pub fn disconnect(self: *TcpSocket) void {
    sf.c.sfTcpSocket_disconnect(self._ptr);
}

/// Sends raw data to the remote
pub fn send(self: *TcpSocket, data: []const u8) sf.Socket.Error!void {
    const code = sf.c.sfTcpSocket_send(self._ptr, data.ptr, data.len);
    try sf.Socket._codeToErr(code);
}
/// Sends part of the buffer to the remote
/// Returns the slice of the rest of the data that hasn't been sent, what is left to send
pub fn sendPartial(self: *TcpSocket, data: []const u8) sf.Socket.Error![]const u8 {
    var sent: usize = undefined;
    var ret = data;
    const code = sf.c.sfTcpSocket_sendPartial(self._ptr, data.ptr, data.len, &sent);
    try sf.Socket._codeToErr(code);
    ret.ptr += sent;
    ret.len -= sent;
    return ret;
}
/// Sends a packet to the remote
pub fn sendPacket(self: *TcpSocket, packet: sf.Packet) sf.Socket.Error!void {
    const code = sf.c.sfTcpSocket_sendPacket(self._ptr, packet._ptr);
    try sf.Socket._codeToErr(code);
}

/// Receives raw data from the remote
/// Pass in a buffer large enough
/// Returns the slice of the received data
pub fn receive(self: *TcpSocket, buf: []u8) sf.Socket.Error![]const u8 {
    var size: usize = undefined;
    const code = sf.c.sfUdpSocket_receive(self._ptr, buf.ptr, buf.len, &size);
    try sf.Socket._codeToErr(code);
    return buf[0..size];
}
// TODO: consider receiveAlloc
// TODO: should this return its own new packet
/// Receives a packet from the remote
/// Pass the packet to fill with the data
pub fn receivePacket(self: *TcpSocket, packet: *sf.Packet) sf.Socket.Error!void {
    const code = sf.c.sfUdpSocket_receivePacket(self._ptr, packet._ptr);
    try sf.Socket._codeToErr(code);
}

/// Pointer to the csfml structure
_ptr: *sf.c.sfTcpSocket,

// TODO: write tests
