//! Import this to get all the sfml wrapper classes

pub const system = @import("system/system_module.zig");
pub const window = @import("window/window_module.zig");
pub const graphics = @import("graphics/graphics_module.zig");
pub const audio = @import("audio/audio_module.zig");
pub const network = @import("network/network_module.zig");

pub const c = @cImport({
    @cInclude("SFML/Graphics.h");
    @cInclude("SFML/Window.h");
    @cInclude("SFML/System.h");
    @cInclude("SFML/Audio.h");
    @cInclude("SFML/Network.h");
});

pub const Error = error{
    nullptrUnknownReason,
    windowCreationFailed,
    resourceLoadingError,
    notEnoughData,
    areaDoesNotFit,
    outOfBounds,
    savingInFileFailed,
    cannotWriteToPacket,
    noMoreData,
    couldntRead,
    timeout,
    wrongDataSize,
    unimplemented,
};

test "all sfml tests" {
    const tst = @import("std").testing;
    tst.refAllDeclsRecursive(system);
    tst.refAllDeclsRecursive(window);
    tst.refAllDeclsRecursive(graphics);
    tst.refAllDeclsRecursive(audio);
    //tst.refAllDeclsRecursive(network);
}
