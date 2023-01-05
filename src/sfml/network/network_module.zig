const c = @import("../sfml_import.zig").c;

pub const Packet = @import("Packet.zig");
pub const IpAddress = @import("IpAddress.zig");
pub const IpAndPort = struct { ip: IpAddress, port: u16 };
pub const ip = IpAddress.init;

pub const Socket = @import("Socket.zig");
pub const UdpSocket = @import("UdpSocket.zig");
pub const TcpSocket = @import("TcpSocket.zig");
pub const TcpListener = @import("TcpListener.zig");
pub const SocketSelector = @import("SocketSelector.zig");
