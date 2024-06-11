//! Socket using the UDP protocol

const sf = struct {
    pub usingnamespace @import("../sfml.zig");
    pub usingnamespace sf.network;
};

const UdpSocket = @This();

// Constructor/destructor

/// Creates a new udp socket
pub fn create() !UdpSocket {
    const sock = sf.c.sfUdpSocket_create();
    if (sock) |s| {
        return UdpSocket{ ._ptr = s };
    } else return sf.Error.nullptrUnknownReason;
}
/// Destroys this socket
pub fn destroy(self: *UdpSocket) void {
    sf.c.sfUdpSocket_destroy(self._ptr);
}

// Methods

/// Enables or disables blocking mode (true for blocking)
/// In blocking mode, receive waits for data
pub fn setBlocking(self: *UdpSocket, blocking: bool) void {
    sf.c.sfUdpSocket_setBlocking(self._ptr, @intFromBool(blocking));
}
/// Tells whether or not the socket is in blocking mode
pub fn isBlocking(self: UdpSocket) bool {
    return sf.c.sfUdpSocket_isBlocking(self._ptr) != 0;
}
/// Gets the port this socket is bound to (null for no port)
pub fn getLocalPort(self: UdpSocket) ?u16 {
    const port = sf.c.sfUdpSocket_getLocalPort(self._ptr);
    return if (port == 0) null else port;
}
/// Binds the socket to a specified port and ip
/// port: the port to bind to (null to let the os choose)
/// ip: the interface to bind to (null for any interface)
pub fn bind(self: *UdpSocket, port: ?u16, ip: ?sf.IpAddress) sf.Socket.Error!void {
    const p = port orelse 0;
    const i = ip orelse sf.IpAddress.any();
    const code = sf.c.sfUdpSocket_bind(self._ptr, p, i._ip);
    try sf.Socket._codeToErr(code);
}
/// Unbinds the socket from the port it's bound to
pub fn unbind(self: *UdpSocket) void {
    sf.c.sfUdpSocket_unbind(self._ptr);
}
/// Sends raw data to a recipient
pub fn send(self: *UdpSocket, data: []const u8, remote: sf.IpAndPort) sf.Socket.Error!void {
    const code = sf.c.sfUdpSocket_send(self._ptr, data.ptr, data.len, remote.ip._ip, remote.port);
    try sf.Socket._codeToErr(code);
}
/// Sends a packet to a recipient
pub fn sendPacket(self: *UdpSocket, packet: sf.Packet, remote: sf.IpAndPort) sf.Socket.Error!void {
    const code = sf.c.sfUdpSocket_sendPacket(self._ptr, packet._ptr, remote.ip._ip, remote.port);
    try sf.Socket._codeToErr(code);
}

/// Represents received data and a remote ip and port
pub const ReceivedRaw = struct { data: []const u8, sender: sf.IpAndPort };
/// Receives raw data from a recipient
/// Pass in a buffer large enough
/// Returns the slice of the received data and the sender ip and port
pub fn receive(self: *UdpSocket, buf: []u8) sf.Socket.Error!ReceivedRaw {
    var size: usize = undefined;
    var remote: sf.IpAndPort = undefined;
    const code = sf.c.sfUdpSocket_receive(self._ptr, buf.ptr, buf.len, &size, &remote.ip._ip, &remote.port);
    try sf.Socket._codeToErr(code);
    return ReceivedRaw{ .data = buf[0..size], .sender = remote };
}
// TODO: consider receiveAlloc ?
// TODO: should this return its own new packet?
/// Receives a packet from a recipient
/// Pass the packet to fill with the data
/// Returns the sender ip and port
pub fn receivePacket(self: *UdpSocket, packet: *sf.Packet) sf.Socket.Error!sf.IpAndPort {
    var remote: sf.IpAndPort = undefined;
    const code = sf.c.sfUdpSocket_receivePacket(self._ptr, packet._ptr, &remote.ip._ip, &remote.port);
    try sf.Socket._codeToErr(code);
    return remote;
}
/// Gets the max datagram size you can send
pub fn getMaxDatagramSize() c_uint {
    return sf.c.sfUdpSocket_maxDatagramSize();
}

/// Pointer to the csfml structure
_ptr: *sf.c.sfUdpSocket,

test "udp socket: dumb test" {
    const tst = @import("std").testing;

    var buf: [1024]u8 = undefined;
    var pack = try sf.Packet.create();
    defer pack.destroy();

    var sock = try UdpSocket.create();
    defer sock.destroy();

    sock.setBlocking(false);
    try tst.expect(!sock.isBlocking());

    try sock.bind(null, null);
    const port = sock.getLocalPort().?;
    try tst.expect(port >= 49152);

    try tst.expectError(error.notReady, sock.receive(&buf));

    sock.unbind();
    try tst.expect(sock.getLocalPort() == null);
    try tst.expectError(error.otherError, sock.receivePacket(&pack));

    const target = sf.IpAndPort{ .port = 1, .ip = sf.IpAddress.none() };
    try tst.expectError(error.otherError, sock.sendPacket(pack, target));
    try tst.expectError(error.otherError, sock.send(buf[0..10], target));
}
