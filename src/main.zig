const std = @import("std");
const gf2mat = @import("gf2mat.zig");
const testing = std.testing;
const Gf2Mat = gf2mat.Gf2Mat;

const Generator = Gf2Mat(7, 4).fromBitArray([_]u1 {
    1, 1, 0, 1,
    1, 0, 1, 1,
    1, 0, 0, 0,
    0, 1, 1, 1,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1
});

const ParityCheck = Gf2Mat(3, 7).fromBitArray([_]u1 {
    1, 0, 1, 0, 1, 0, 1,
    0, 1, 1, 0, 0, 1, 1,
    0, 0, 0, 1, 1, 1, 1
});

const Decode = Gf2Mat(4, 7).fromBitArray([_]u1 {
    0, 0, 1, 0, 0, 0, 0,
    0, 0, 0, 0, 1, 0, 0,
    0, 0, 0, 0, 0, 1, 0,
    0, 0, 0, 0, 0, 0, 1
});

test "basic Hamming(7, 4) matrix repr" {
    testing.expectEqual(Generator.data, [4]u8{0b1101_1011, 0b1000_0111, 0b0100_0010, 0b0001_0000});
    testing.expectEqual(ParityCheck.data, [3]u8{0b1010_1010, 0b1100_1100, 0b00111_1000});
    testing.expectEqual(Decode.data, [4]u8{0b0010_0000, 0b0001_0000, 0b0001_0000, 0b0001_0000});
}
