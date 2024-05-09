const std = @import("std");
const zbench = @import("zbench");
const matrix = @import("zig_matrix");

const MatrixMul = struct {
    a: matrix.Mat4x4,
    b: matrix.Mat4x4,

    pub fn init() MatrixMul {
        const a = matrix.mat4x4(
            matrix.vec4(0, 1, 2, 3),
            matrix.vec4(4, 5, 6, 7),
            matrix.vec4(8, 9, 10, 11),
            matrix.vec4(12, 13, 14, 15),
        );
        const b = a.transpose();

        return .{
            .a = a,
            .b = b,
        };
    }

    pub fn run(self: MatrixMul, _: std.mem.Allocator) void {
        std.mem.doNotOptimizeAway(self.a.mul(self.b));
    }
};

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    var bench = zbench.Benchmark.init(allocator, .{});

    const matrixMul: MatrixMul = MatrixMul.init();
    try bench.addParam("matrixMul", &matrixMul, .{});

    defer bench.deinit();
    try bench.run(std.io.getStdOut().writer());
}
