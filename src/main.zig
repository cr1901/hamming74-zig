const std = @import("std");
const testing = std.testing;
const Matrix = @import("zig-matrix").Matrix;
const StorageOrder = @import("zig-matrix").StorageOrder;

const Generator = Matrix(u8, 7, 4).fromValues([_]u8 {
    1, 1, 0, 1,
    1, 0, 1, 1,
    1, 0, 0, 0,
    0, 1, 1, 1,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1
}, .RowMajor);

const ParityCheck = Matrix(u8, 3, 7).fromValues([_]u8 {
    1, 0, 1, 0, 1, 0, 1,
    0, 1, 1, 0, 0, 1, 1,
    0, 0, 0, 1, 1, 1, 1
}, .RowMajor);

const DecodeMatrix = Matrix(u8, 4, 7).fromValues([_]u8 {
    0, 0, 1, 0, 0, 0, 0,
    0, 0, 0, 0, 1, 0, 0,
    0, 0, 0, 0, 0, 1, 0,
    0, 0, 0, 0, 0, 0, 1
}, .RowMajor);

const Encoder = struct {
    const Self = @This();

    in_buf: []const u8,
    out_buf: []u8,
    in_cursor: u16,
    out_cursor: u16,

    pub fn init(in_buf: []const u8, out_buf: []u8) Self {
        return .{
            .in_buf = in_buf,
            .out_buf = out_buf,
            .in_cursor = 0,
            .out_cursor = 0,
        };
    }

    // LSB encoded first for now.
    fn encodeOneValue(self: *Encoder, inp: u4) u8 {
        var i: u8 = 4;
        var inp_bits: [4]u8 = [4]u8{ 0, 0, 0, 0 };
        var inp_copy = inp;

        // Convert to bit array. Do we really need a copy of inp?
        while(i > 0) : (i -= 1) {
            inp_bits[4 - i] = inp_copy & 1;
            inp_copy = inp_copy >> 1;
        }

        var inp_mat = Matrix(u8, 4, 1).fromValues(inp_bits, .RowMajor);
        var encoded_mat = Generator.multiply(inp_mat);
        // TODO: Make u7
        var outp_bits : u8 = 0;

        for (encoded_mat.data) |v, j| {
            const stdout = std.io.getStdOut().writer();

            outp_bits |= ((v & 1) << j);

            stdout.print("{b:.8}\n", .{outp_bits}) catch unreachable;
        }

        return outp_bits;
    }
};

test "encodeOneValue" {
    var inp = [1]u8{ 2 };
    var outp = [1]u8{ 0 };
    var e = Encoder.init(&inp, &outp);

    testing.expectEqual(e.encodeOneValue(13), 0);
}
