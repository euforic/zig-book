const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const bookgen = b.addExecutable(.{
        .name = "zig-bookgen",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/bookgen.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    const generate_cmd = b.addRunArtifact(bookgen);
    generate_cmd.addArg(b.pathFromRoot("."));
    generate_cmd.addArg("book.js");

    const generate_step = b.step("generate", "Regenerate book.js from Zig metadata and chapter sources");
    generate_step.dependOn(&generate_cmd.step);

    const site_cmd = b.addRunArtifact(bookgen);
    site_cmd.addArg(b.pathFromRoot("."));
    site_cmd.addArg("--site");
    site_cmd.addArg("dist");
    site_cmd.step.dependOn(generate_step);

    const site_step = b.step("site", "Build the static GitHub Pages site into dist/");
    site_step.dependOn(&site_cmd.step);

    const serve = b.addExecutable(.{
        .name = "zig-book-serve",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/serve.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    const serve_port = b.option(u16, "port", "Port for the local dev server") orelse 8080;
    const serve_cmd = b.addRunArtifact(serve);
    serve_cmd.addArg(b.pathFromRoot("dist"));
    serve_cmd.addArg(b.fmt("{d}", .{serve_port}));
    serve_cmd.step.dependOn(site_step);

    const serve_step = b.step("serve", "Build dist/ and serve it locally via Zig");
    serve_step.dependOn(&serve_cmd.step);

    const node_check = b.addSystemCommand(&.{ "node", "--check", b.pathFromRoot("book.js") });
    node_check.step.dependOn(generate_step);

    const dist_node_check = b.addSystemCommand(&.{ "node", "--check", b.pathFromRoot("dist/book.js") });
    dist_node_check.step.dependOn(site_step);

    const fmt_check = b.addSystemCommand(&.{
        "zig",
        "fmt",
        "--check",
        b.pathFromRoot("build.zig"),
        b.pathFromRoot("src/bookgen.zig"),
        b.pathFromRoot("src/book_data.zig"),
        b.pathFromRoot("src/serve.zig"),
    });

    const check_step = b.step("check", "Regenerate and validate the generated book site");
    check_step.dependOn(&node_check.step);
    check_step.dependOn(&dist_node_check.step);
    check_step.dependOn(&fmt_check.step);

    b.default_step.dependOn(site_step);
}
