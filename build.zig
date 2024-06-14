const std = @import("std");
const builtin = @import("builtin");

/// Windows only: use the LIBRARY_PATH environment variable to add library paths
/// TODO: is there an actual environment variable that works?
fn addLibraryPathEnvVar(exe: *std.Build.Step.Compile, alloc: std.mem.Allocator) !void {
    // This is ugly because of utf16...
    const env_name = try std.unicode.utf8ToUtf16LeAllocZ(alloc, "LIBRARY_PATH");
    defer alloc.free(env_name);
    if (std.process.getenvW(env_name)) |env| {
        var it = std.mem.tokenize(u16, env, &[_]u16{';'});
        while (it.next()) |path| {
            const path_u8 = try std.unicode.utf16LeToUtf8Alloc(alloc, path);
            defer alloc.free(path_u8);

            exe.addLibraryPath(std.Build.LazyPath.relative(path_u8));
        }
    }
}

// Call that from your own build.zig as a helper!
pub fn link(exe: *std.Build.Step.Compile) void {
    exe.linkLibC();

    if (builtin.os.tag == .windows) {
        const alloc = std.heap.page_allocator;
        // So that the library paths are available
        addLibraryPathEnvVar(exe, alloc) catch @panic("Failed to use allocator in addLibraryPathEnvVar");
    }

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
        .root_source_file = b.path("src/root.zig"),
    });

    // Register test runner
    const test_runner = b.addTest(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = mode,
    });
    link(test_runner);

    //Build step to generate docs:
    const docs = b.addTest(.{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = mode,
    });
    link(docs);
    docs.root_module.addImport("sfml", module);

    const emitted_docs = docs.getEmittedDocs();
    const docs_step = b.step("docs", "Generate docs");
    docs_step.dependOn(&b.addInstallDirectory(.{
        .source_dir = emitted_docs,
        .install_dir = .prefix,
        .install_subdir = "docs",
    }).step);

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

    const install = b.addInstallArtifact(exe, .{});
    const install_step = b.step(name, "Get the compiled " ++ name ++ " example in the bin folder");
    install_step.dependOn(&install.step);

    const run = b.addRunArtifact(exe);
    const run_step = b.step("run-" ++ name, "Run the " ++ name ++ " test");
    run_step.dependOn(&run.step);
}
