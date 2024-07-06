/// Represents the status of a sound playing
pub const SoundStatus = enum(c_int) {
    stopped,
    paused,
    playing,
};
