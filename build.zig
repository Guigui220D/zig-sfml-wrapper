const std = @import("std");
const Builder = std.build.Builder;

pub fn link(exe: *std.build.LibExeObjStep) void {
    exe.linkLibC();
    exe.linkSystemLibrary("csfml-graphics");
    exe.linkSystemLibrary("csfml-system");
    exe.linkSystemLibrary("csfml-window");
    exe.linkSystemLibrary("csfml-audio");
    exe.linkSystemLibrary("csfml-network");
    // exe.addIncludePath("csfml/include/");
    // exe.addLibraryPath("csfml/lib/msvc/");
}

pub fn pkg(name: []const u8) std.build.Pkg {
    return .{
        .name = name,
        .source = .{
            .path = @src().file ++ "/../src/sfml/sfml.zig"
        }
    };
}

pub fn build(b: *Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    var test_runner = b.addTest("src/sfml/sfml_tests.zig");
    link(test_runner);
    test_runner.setTarget(target);
    test_runner.setBuildMode(mode);

    const test_step = b.step("test", "Runs the test suite.");
    test_step.dependOn(&test_runner.step);

    example(b, target, "sfml_example");
    example(b, target, "green_circle");
    example(b, target, "heat_haze");
}

fn example(b: *Builder, targ: anytype, comptime name: []const u8) void {
    const mode = b.standardReleaseOptions();

    const exe = b.addExecutable("sfml", "src/examples/" ++ name ++ ".zig");
    exe.addPackagePath("sfml", "src/sfml/sfml.zig");
    link(exe);
    exe.setTarget(targ);
    exe.setBuildMode(mode);
    exe.install();

    const run_step = b.step("run-" ++ name, "Run the " ++ name ++ " test");
    run_step.dependOn(&exe.run().step);
}
