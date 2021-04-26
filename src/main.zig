const Matrix = @import("zig-matrix").Matrix;
const StorageOrder = @import("zig-matrix").StorageOrder;

const Generator = Matrix(u1, 7, 4).fromValues([_]u1 {
    1, 1, 0, 1,
    1, 0, 1, 1,
    1, 0, 0, 0,
    0, 1, 1, 1,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1
}, .RowMajor);

const ParityCheck = Matrix(u1, 3, 7).fromValues([_]u1 {
    1, 0, 1, 0, 1, 0, 1,
    0, 1, 1, 0, 0, 1, 1,
    0, 0, 0, 1, 1, 1, 1
}, .RowMajor);

const Decode = Matrix(u1, 4, 7).fromValues([_]u1 {
    0, 0, 1, 0, 0, 0, 0,
    0, 0, 0, 0, 1, 0, 0,
    0, 0, 0, 0, 0, 1, 0,
    0, 0, 0, 0, 0, 0, 1
}, .RowMajor);

test "ref-generator" {
    const foo = Generator;
}
