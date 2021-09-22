const std = @import("std");
const Builder = std.build.Builder;

pub fn build(b: *Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    var test_runner = b.addTest("src/sfml/sfml_tests.zig");
    test_runner.linkLibC();
    test_runner.addLibPath("csfml/lib/msvc/");
    test_runner.linkSystemLibrary("csfml-graphics");
    test_runner.linkSystemLibrary("csfml-system");
    test_runner.linkSystemLibrary("csfml-window");
    test_runner.linkSystemLibrary("csfml-audio");
    test_runner.addIncludeDir("csfml/include/");
    test_runner.setTarget(target);
    test_runner.setBuildMode(mode);

    const test_step = b.step("test", "Runs the test suite.");
    test_step.dependOn(&test_runner.step);

    example(b, target, "sfml_example");
    example(b, target, "green_circle");
}

fn example(b: *Builder, targ: anytype, comptime name: []const u8) void {
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("sfml", "src/examples/" ++ name ++ ".zig");
    exe.linkLibC();
    exe.addPackagePath("sfml", "src/sfml/sfml.zig");
    exe.addLibPath("csfml/lib/msvc/");
    exe.linkSystemLibrary("csfml-graphics");
    exe.linkSystemLibrary("csfml-system");
    exe.linkSystemLibrary("csfml-window");
    exe.linkSystemLibrary("csfml-audio");
    exe.addIncludeDir("csfml/include/");
    exe.setTarget(targ);
    exe.setBuildMode(mode);
    exe.install();

    const run_step = b.step("run-" ++ name, "Run the " ++ name ++ " test");
    run_step.dependOn(&exe.run().step);
}
