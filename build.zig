const std = @import("std");

pub fn link(b: *std.Build, exe: *std.Build.Step.Compile) void {
    exe.linkLibC();
    exe.linkSystemLibrary("csfml-graphics");
    exe.linkSystemLibrary("csfml-system");
    exe.linkSystemLibrary("csfml-window");
    exe.linkSystemLibrary("csfml-audio");
    exe.linkSystemLibrary("csfml-network");
    //exe.addIncludePath(b.path("csfml/include/"));
    //exe.addLibraryPath(b.path("csfml/lib/msvc/"));
}

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardOptimizeOption(.{});

    // Register modules
    const module = b.addModule("sfml", .{
        .root_source_file = b.path("src/sfml/sfml.zig"),
    });

    // Register test runner
    var test_runner = b.addTest(.{
        .root_source_file = b.path("src/sfml/sfml_tests.zig"),
        .target = target,
        .optimize = mode,
    });
    link(b, test_runner);
    test_runner.root_module.addImport("sfml", module);

    // Register the examples
    const sfml_example = b.addExecutable(.{
        .name = "sfml_example",
        .root_source_file = b.path("src/examples/sfml_example.zig"),
        .target = target,
        .optimize = mode,
    });
    link(b, sfml_example);
    sfml_example.root_module.addImport("sfml", module);

    const green_circle = b.addExecutable(.{
        .name = "green_circle",
        .root_source_file = b.path("src/examples/green_circle.zig"),
        .target = target,
        .optimize = mode,
    });
    link(b, green_circle);
    green_circle.root_module.addImport("sfml", module);

    const heat_haze = b.addExecutable(.{
        .name = "heat_haze",
        .root_source_file = b.path("src/examples/heat_haze.zig"),
        .target = target,
        .optimize = mode,
    });
    link(b, heat_haze);
    heat_haze.root_module.addImport("sfml", module);

    // Register the test step
    const test_step = b.step("test", "Runs the test suite.");
    var run = b.addRunArtifact(test_runner);

    test_step.dependOn(&run.step);

    const sfml_example_step = b.step("sfml-example", "Builds the main SFML example");
    sfml_example_step.dependOn(&b.addInstallArtifact(sfml_example, .{}).step);

    const green_circle_step = b.step("green-circle-example", "Builds the green circle example");
    green_circle_step.dependOn(&b.addInstallArtifact(green_circle, .{}).step);

    const heat_haze_step = b.step("sync-examples", "Builds the heat haze shader example");
    heat_haze_step.dependOn(&b.addInstallArtifact(heat_haze, .{}).step);
}
