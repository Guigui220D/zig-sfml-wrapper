const std = @import("std");

// Call that from your own build.zig as a helper!
pub fn link(exe: *std.Build.Step.Compile) void {
    exe.linkLibC();
    exe.linkSystemLibrary("csfml-graphics");
    exe.linkSystemLibrary("csfml-system");
    exe.linkSystemLibrary("csfml-window");
    exe.linkSystemLibrary("csfml-audio");
    exe.linkSystemLibrary("csfml-network");
}

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardOptimizeOption(.{});

    // Register modules
    const module = b.addModule("sfml", .{
        .root_source_file = b.path("src/sfml/sfml.zig"),
    });
    module.addLibraryPath(b.path("CSFML/lib/msvc/"));
    module.addIncludePath(b.path("CSFML/include/"));

    // Register test runner
    var test_runner = b.addTest(.{
        .root_source_file = b.path("src/sfml/sfml_tests.zig"),
        .target = target,
        .optimize = mode,
    });
    link(test_runner);
    test_runner.addIncludePath(b.path("csfml/include/"));
    test_runner.root_module.addImport("sfml", module);

    // Register the examples
    example(b, module, target, mode, "sfml_example");
    example(b, module, target, mode, "green_circle");
    example(b, module, target, mode, "heat_haze");

    // Register the test step
    const test_step = b.step("test", "Runs the test suite.");
    var run = b.addRunArtifact(test_runner);

    test_step.dependOn(&run.step);
}

fn example(b: *std.Build, module: *std.Build.Module, target: anytype, mode: anytype, comptime name: []const u8) void {
    const exe = b.addExecutable(.{
        .name = name,
        .root_source_file = b.path("src/examples/" ++ name ++ ".zig"),
        .target = target,
        .optimize = mode,
    });
    link(exe);
    exe.root_module.addImport("sfml", module);

    const run = b.addRunArtifact(exe);
    const run_step = b.step("run-" ++ name, "Run the " ++ name ++ " test");
    run_step.dependOn(&run.step);
}
