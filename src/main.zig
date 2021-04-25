const zig_matrix = @import("zig-matrix");

const Generator = zig_matrix.Matrix(u8, 7, 4);

test "ref-generator" {
    Generator;
}
