const std = @import("std");
const Builder = std.build.Builder;

pub fn link(exe: *std.build.Step.Compile) void {
    exe.linkLibC();
    exe.linkSystemLibrary("csfml-graphics");
    exe.linkSystemLibrary("csfml-system");
    exe.linkSystemLibrary("csfml-window");
    exe.linkSystemLibrary("csfml-audio");
    exe.linkSystemLibrary("csfml-network");
    //exe.addIncludePath("csfml/include/");
    //exe.addLibraryPath("csfml/lib/msvc/");
}

pub fn pkg(name: []const u8) std.build.Pkg {
    return .{ .name = name, .source = .{ .path = @src().file ++ "/../src/sfml/sfml.zig" } };
}

pub fn build(b: *Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardOptimizeOption(.{});

    const test_runner = b.addTest(.{
        .root_source_file = .{ .path = "src/sfml/sfml_tests.zig" },
        .target = target,
        .optimize = mode,
    });
    link(test_runner);

    const run = b.addRunArtifact(test_runner);
    const test_step = b.step("test", "run the unit tests");
    test_step.dependOn(&run.step);

    example(b, target, mode, "sfml_example");
    example(b, target, mode, "green_circle");
    example(b, target, mode, "heat_haze");
}

fn example(b: *Builder, target: anytype, mode: anytype, comptime name: []const u8) void {
    const exe = b.addExecutable(.{
        .name = name,
        .root_source_file = .{ .path = "src/examples/" ++ name ++ ".zig" },
        .target = target,
        .optimize = mode,
    });
    link(exe);
    exe.addAnonymousModule("sfml", .{ .source_file = .{ .path = "src/sfml/sfml.zig" } });

    const run = b.addRunArtifact(exe);
    const run_step = b.step("run-" ++ name, "Run the " ++ name ++ " test");
    run_step.dependOn(&run.step);
}
