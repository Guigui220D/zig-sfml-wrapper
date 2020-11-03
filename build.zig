const std = @import("std");
const Builder = std.build.Builder;

pub fn build(b: *Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("sfml", "src/examples/my_tests.zig");
    exe.linkLibC();
    exe.addPackagePath("sfml", "src/sfml/sfml.zig");
    exe.addLibPath("csfml/lib/msvc/");
    exe.linkSystemLibrary("csfml-graphics");
    exe.linkSystemLibrary("csfml-system");
    exe.linkSystemLibrary("csfml-window");
    exe.addIncludeDir("csfml/include/");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    var test_runner = b.addTest("src/sfml/sfml_tests.zig");
    test_runner.linkLibC();
    test_runner.addLibPath("csfml/lib/msvc/");
    test_runner.linkSystemLibrary("csfml-graphics");
    test_runner.linkSystemLibrary("csfml-system");
    test_runner.linkSystemLibrary("csfml-window");
    test_runner.addIncludeDir("csfml/include/");
    test_runner.setTarget(target);
    test_runner.setBuildMode(mode);

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const test_step = b.step("test", "Runs the test suite.");
    test_step.dependOn(&test_runner.step);
}
