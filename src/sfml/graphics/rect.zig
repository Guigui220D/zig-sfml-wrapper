//! Utility class for manipulating 2D axis aligned rectangles.

const sf = struct {
    const sfml = @import("../sfml.zig");
    pub usingnamespace sfml;
    pub usingnamespace sfml.system;
};

pub fn Rect(comptime T: type) type {
    return packed struct {
        const Self = @This();

        /// The CSFML vector type equivalent
        const CsfmlEquivalent = switch (T) {
            c_int => sf.c.sfIntRect,
            f32 => sf.c.sfFloatRect,
            else => void,
        };

        /// Creates a rect (just for convinience)
        pub fn init(left: T, top: T, width: T, height: T) Self {
            return Self{
                .left = left,
                .top = top,
                .width = width,
                .height = height,
            };
        }

        /// Makes a CSFML rect with this rect (only if the corresponding type exists)
        /// This is mainly for the inner workings of this wrapper
        pub fn _toCSFML(self: Self) CsfmlEquivalent {
            if (CsfmlEquivalent == void) @compileError("This rectangle type doesn't have a CSFML equivalent.");
            return @as(CsfmlEquivalent, @bitCast(self));
        }

        /// Creates a rect from a CSFML one (only if the corresponding type exists)
        /// This is mainly for the inner workings of this wrapper
        pub fn _fromCSFML(rect: CsfmlEquivalent) Self {
            if (CsfmlEquivalent == void) @compileError("This rectangle type doesn't have a CSFML equivalent.");
            return @as(Self, @bitCast(rect));
        }

        /// Checks if a point is inside this recangle
        pub fn contains(self: Self, vec: sf.Vector2(T)) bool {
            // Shamelessly stolen
            const min_x: T = @min(self.left, self.left + self.width);
            const max_x: T = @max(self.left, self.left + self.width);
            const min_y: T = @min(self.top, self.top + self.height);
            const max_y: T = @max(self.top, self.top + self.height);

            return (vec.x >= min_x and
                vec.x < max_x and
                vec.y >= min_y and
                vec.y < max_y);
        }

        /// Checks if two rectangles have a common intersection, if yes returns that zone, if not returns null
        pub fn intersects(self: Self, other: Self) ?Self {
            // Shamelessly stolen too
            const r1_min_x: T = @min(self.left, self.left + self.width);
            const r1_max_x: T = @max(self.left, self.left + self.width);
            const r1_min_y: T = @min(self.top, self.top + self.height);
            const r1_max_y: T = @max(self.top, self.top + self.height);

            const r2_min_x: T = @min(other.left, other.left + other.width);
            const r2_max_x: T = @max(other.left, other.left + other.width);
            const r2_min_y: T = @min(other.top, other.top + other.height);
            const r2_max_y: T = @max(other.top, other.top + other.height);

            const inter_left: T = @max(r1_min_x, r2_min_x);
            const inter_top: T = @max(r1_min_y, r2_min_y);
            const inter_right: T = @min(r1_max_x, r2_max_x);
            const inter_bottom: T = @min(r1_max_y, r2_max_y);

            if (inter_left < inter_right and inter_top < inter_bottom) {
                return Self.init(inter_left, inter_top, inter_right - inter_left, inter_bottom - inter_top);
            } else {
                return null;
            }
        }

        /// Checks if two rectangles are the same
        pub fn equals(self: Self, other: Self) bool {
            return (self.left == other.left and
                self.top == other.top and
                self.width == other.width and
                self.height == other.height);
        }

        /// Gets a vector with left and top components inside
        pub fn getCorner(self: Self) sf.Vector2(T) {
            return sf.Vector2(T){ .x = self.left, .y = self.top };
        }
        pub const getPosition = getCorner;
        /// Gets a vector with the bottom right corner coordinates
        pub fn getOtherCorner(self: Self) sf.Vector2(T) {
            return self.getCorner().add(self.getSize());
        }
        /// Gets a vector with width and height components inside
        pub fn getSize(self: Self) sf.Vector2(T) {
            return sf.Vector2(T){ .x = self.width, .y = self.height };
        }

        /// x component of the top left corner
        left: T,
        /// x component of the top left corner
        top: T,
        /// width of the rectangle
        width: T,
        /// height of the rectangle
        height: T,
    };
}

test "rect: intersect" {
    const tst = @import("std").testing;

    var r1 = Rect(c_int).init(0, 0, 10, 10);
    var r2 = Rect(c_int).init(6, 6, 20, 20);
    var r3 = Rect(c_int).init(-5, -5, 10, 10);

    try tst.expectEqual(@as(?Rect(c_int), null), r2.intersects(r3));

    var inter1: sf.c.sfIntRect = undefined;
    var inter2: sf.c.sfIntRect = undefined;

    try tst.expectEqual(sf.c.sfIntRect_intersects(&r1._toCSFML(), &r2._toCSFML(), &inter1), 1);
    try tst.expectEqual(sf.c.sfIntRect_intersects(&r1._toCSFML(), &r3._toCSFML(), &inter2), 1);

    try tst.expectEqual(Rect(c_int)._fromCSFML(inter1), r1.intersects(r2).?);
    try tst.expectEqual(Rect(c_int)._fromCSFML(inter2), r1.intersects(r3).?);
}

test "rect: contains" {
    const tst = @import("std").testing;

    const r1 = Rect(f32).init(0, 0, 10, 10);

    try tst.expect(r1.contains(.{ .x = 0, .y = 0 }));
    try tst.expect(r1.contains(.{ .x = 9, .y = 9 }));
    try tst.expect(!r1.contains(.{ .x = 5, .y = -1 }));
    try tst.expect(!r1.contains(.{ .x = 10, .y = 5 }));
}

test "rect: getPosition" {
    const tst = @import("std").testing;

    const r1 = Rect(f32).init(1, 3, 10, 10);
    const pos = r1.getPosition();

    try tst.expectApproxEqAbs(1.0, pos.x, 0.0001);
    try tst.expectApproxEqAbs(3.0, pos.y, 0.0001);
}

test "rect: getSize" {
    const tst = @import("std").testing;

    const r1 = Rect(f32).init(1, 3, 10, 12);
    const size = r1.getSize();

    try tst.expectApproxEqAbs(10, size.x, 0.0001);
    try tst.expectApproxEqAbs(12, size.y, 0.0001);
}

test "rect: sane from/to CSFML rect" {
    const tst = @import("std").testing;

    inline for ([_]type{ c_int, f32 }) |T| {
        const rect = Rect(T).init(1, 3, 5, 10);
        const crect = rect._toCSFML();

        try tst.expectEqual(rect.left, crect.left);
        try tst.expectEqual(rect.top, crect.top);
        try tst.expectEqual(rect.width, crect.width);
        try tst.expectEqual(rect.height, crect.height);

        const rect2 = Rect(T)._fromCSFML(crect);

        try tst.expectEqual(rect, rect2);
    }
}
