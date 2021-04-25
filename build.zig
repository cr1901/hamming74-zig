const Builder = @import("std").build.Builder;

pub fn build(b: *Builder) void {
    const mode = b.standardReleaseOptions();
    const lib = b.addStaticLibrary("hamming74", "src/main.zig");
    lib.setBuildMode(mode);
    lib.addPackage(.{
            .name = "zig-matrix",
            .path = "zig-matrix/src/main.zig",
    });

    lib.install();

    const test_step = b.step("test", "Run all tests");
    test_step.dependOn(&b.addTest("src/main.zig").step);

    b.default_step.dependOn(test_step);
}
