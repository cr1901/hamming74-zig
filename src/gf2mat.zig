/// Helper module for multiplying vectors/matrices of GF(2).
/// A lot of this was taken from the zig-matrix library and reduced/modified for my own needs.

/// Row major-only
/// Most Significant Bit to Least Significant Bit order per byte, going in order of rows.
/// Least Significant Byte of data store used first.
fn Gf2Mat(
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

        fn init() Self {
            return Self {
                .data = [_]u8{0} ** num_bytes,
            };
        }

        fn fromBitArray(data: [bit_size]u1) Self {
            @panic("unimplemented");
        }

        fn multiply(self: Self, b: anytype) Gf2Mat(Self.rows, @TypeOf(b).cols) {
            if(Self.cols != @TypeOf(b).rows) {
                @compileError("Self.cols does not match b.rows");
            }

            @panic("unimplemented");
        }
    };
}


// const Matrix = @import("zig-matrix").Matrix;
// const StorageOrder = @import("zig-matrix").StorageOrder;
//
// const Generator = Matrix(u1, 7, 4).fromValues([_]u1 {
//     1, 1, 0, 1,
//     1, 0, 1, 1,
//     1, 0, 0, 0,
//     0, 1, 1, 1,
//     0, 1, 0, 0,
//     0, 0, 1, 0,
//     0, 0, 0, 1
// }, .RowMajor);
//
// const ParityCheck = Matrix(u1, 3, 7).fromValues([_]u1 {
//     1, 0, 1, 0, 1, 0, 1,
//     0, 1, 1, 0, 0, 1, 1,
//     0, 0, 0, 1, 1, 1, 1
// }, .RowMajor);
//
// const Decode = Matrix(u1, 4, 7).fromValues([_]u1 {
//     0, 0, 1, 0, 0, 0, 0,
//     0, 0, 0, 0, 1, 0, 0,
//     0, 0, 0, 0, 0, 1, 0,
//     0, 0, 0, 0, 0, 0, 1
// }, .RowMajor);

test "mul" {
    const foo = Gf2Mat(3, 2).init();
    const bar = Gf2Mat(2, 1).init();

    // const mul_res = foo.multiply(bar);
}
