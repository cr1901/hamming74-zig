/// Helper module for multiplying vectors/matrices of GF(2).
/// A lot of this was taken from the zig-matrix library and reduced/modified for my own needs.

const std = @import("std");
const testing = std.testing;


/// Row major-only
/// Most Significant Bit to Least Significant Bit order per byte, going in order of rows.
/// Least Significant Byte of data store used first.
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

        pub fn multiply(self: Self, b: anytype) Gf2Mat(Self.rows, @TypeOf(b).cols) {
            if(Self.cols != @TypeOf(b).rows) {
                @compileError("Self.cols does not match b.rows");
            }

            @panic("unimplemented");
        }
    };
}

test "mul" {
    const foo = Gf2Mat(3, 2).init();
    const bar = Gf2Mat(2, 1).init();

    // const mul_res = foo.multiply(bar);
}
