/// Helper module for multiplying vectors/matrices of GF(2).
/// A lot of this was taken from the zig-matrix library and reduced/modified for my own needs.

const std = @import("std");
const testing = std.testing;


/// Row major-only
/// The first bit in a row is stored at the Most Significant Bit available in the current byte.
/// Least Significant Byte of data store array is used first.
pub fn Gf2Mat(
    comptime r: comptime_int,
    comptime c: comptime_int,
) type {
    // either const or comptime here works
    const bit_size: comptime_int = c * r;
    const num_bytes: comptime_int = bit_size/8 + if ((bit_size % 8) != 0) 1 else 0;

    return struct {
        data: [num_bytes]u8,

        const rows: comptime_int = r;
        const cols: comptime_int = c;
        const Self = @This();

        pub fn init() Self {
            return Self {
                .data = [_]u8{0} ** num_bytes,
            };
        }

        pub fn fromBitArray(data: [bit_size]u1) Self {
            var out = Self.init();
            var curr_byte: usize = 0;
            var curr_offs: u3 = 7;

            for (data) |d| {
                var mask = (@as(u8, d) << curr_offs);
                out.data[curr_byte] |= mask;

                if(curr_offs == 0) {
                    curr_byte += 1;
                }

                curr_offs -%= 1;
            }

            return out;
        }

        pub fn elementAt(self: Self, curr_row: usize, curr_col: usize) u1 {
            var bit_idx: usize = curr_row * cols + curr_col;
            var byte_idx: usize = bit_idx/8;

            var bit_idx_in_byte: u3 = 7 - @intCast(u3, bit_idx % 8);
            var bit_mask: u8 = @as(u8, 1) << bit_idx_in_byte;

            var curr_byte: u8 = self.data[byte_idx];
            var curr_bit: u1 = @intCast(u1, (curr_byte & bit_mask) >> bit_idx_in_byte);

            return curr_bit;
        }

        pub fn multiply(self: Self, b: anytype) Gf2Mat(Self.rows, @TypeOf(b).cols) {
            if(Self.cols != @TypeOf(b).rows) {
                @compileError("Self.cols does not match b.rows");
            }

            const mult_bit_size: comptime_int = c * r;
            var mul_data: [mult_bit_size]u1 = [_]u1{0} ** mult_bit_size;

            @panic("unimplemented");
        }
    };
}

test "elementAt" {
    const test_mat = Gf2Mat(4, 5).fromBitArray([_]u1 {
        1, 1, 0, 1, 1,
        1, 0, 1, 1, 0,
        1, 0, 0, 0, 1,
        0, 1, 1, 1, 0
    });

    testing.expectEqual(test_mat.elementAt(0, 0), 1);
    testing.expectEqual(test_mat.elementAt(0, 1), 1);
    testing.expectEqual(test_mat.elementAt(0, 2), 0);
    testing.expectEqual(test_mat.elementAt(0, 3), 1);
    testing.expectEqual(test_mat.elementAt(0, 4), 1);

    testing.expectEqual(test_mat.elementAt(1, 0), 1);
    testing.expectEqual(test_mat.elementAt(1, 1), 0);
    testing.expectEqual(test_mat.elementAt(1, 2), 1);
    testing.expectEqual(test_mat.elementAt(1, 3), 1);
    testing.expectEqual(test_mat.elementAt(1, 4), 0);

    testing.expectEqual(test_mat.elementAt(2, 0), 1);
    testing.expectEqual(test_mat.elementAt(2, 1), 0);
    testing.expectEqual(test_mat.elementAt(2, 2), 0);
    testing.expectEqual(test_mat.elementAt(2, 3), 0);
    testing.expectEqual(test_mat.elementAt(2, 4), 1);

    testing.expectEqual(test_mat.elementAt(3, 0), 0);
    testing.expectEqual(test_mat.elementAt(3, 1), 1);
    testing.expectEqual(test_mat.elementAt(3, 2), 1);
    testing.expectEqual(test_mat.elementAt(3, 3), 1);
    testing.expectEqual(test_mat.elementAt(3, 4), 0);
}

test "mul" {
    const foo = Gf2Mat(3, 2).init();
    const bar = Gf2Mat(2, 1).init();

    // const mul_res = foo.multiply(bar);
}
