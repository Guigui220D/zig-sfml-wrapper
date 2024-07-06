//! Represents a time span.

const sf = struct {
    const sfml = @import("../root.zig");
    pub usingnamespace sfml;
    pub usingnamespace sfml.system;
};

const TimeSpan = @This();

// Constructors

/// Construcs a time span
pub fn init(begin: sf.Time, length: sf.Time) TimeSpan {
    return sf.TimeSpan{
        .offset = begin,
        .length = length,
    };
}

/// Converts a timespan from a csfml object
/// For inner workings
pub fn _fromCSFML(span: sf.c.sfTimeSpan) TimeSpan {
    return sf.TimeSpan{
        .offset = sf.Time._fromCSFML(span.offset),
        .length = sf.Time._fromCSFML(span.length),
    };
}

/// Converts a timespan to a csfml object
/// For inner workings
pub fn _toCSFML(self: sf.TimeSpan) sf.c.sfTimeSpan {
    return sf.c.sfTimeSpan{
        .offset = self.offset._toCSFML(),
        .length = self.length._toCSFML(),
    };
}

/// The beginning of this span
offset: sf.Time,
/// The length of this time span
length: sf.Time,
