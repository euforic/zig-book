const std = @import("std");
const book = @import("book_data.zig");

const max_source_bytes: usize = 64 * 1024 * 1024;

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const allocator = init.gpa;
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    const root_path = if (args.len > 1) args[1] else ".";

    var root = try std.Io.Dir.cwd().openDir(io, root_path, .{});
    defer root.close(io);

    if (args.len > 2 and std.mem.eql(u8, args[2], "--site")) {
        const site_path = if (args.len > 3) args[3] else "dist";
        try emitSite(root, io, allocator, site_path);
        return;
    }

    const output_path = if (args.len > 2) args[2] else "book.js";
    try emitBookFile(root, io, allocator, output_path);
}

fn emitBookFile(root: std.Io.Dir, io: std.Io, allocator: std.mem.Allocator, output_path: []const u8) !void {
    var output = try root.createFile(io, output_path, .{});
    defer output.close(io);

    var write_buffer: [64 * 1024]u8 = undefined;
    var file_writer = output.writerStreaming(io, &write_buffer);
    const writer = &file_writer.interface;

    try emitBook(root, io, allocator, writer);
    try writer.flush();
}

fn emitSite(root: std.Io.Dir, io: std.Io, allocator: std.mem.Allocator, site_path: []const u8) !void {
    try root.deleteTree(io, site_path);
    try root.createDirPath(io, site_path);

    const index_out = try std.Io.Dir.path.join(allocator, &.{ site_path, "index.html" });
    defer allocator.free(index_out);
    const book_out = try std.Io.Dir.path.join(allocator, &.{ site_path, "book.js" });
    defer allocator.free(book_out);

    const index_html = try root.readFileAlloc(io, "index.html", allocator, .limited(max_source_bytes));
    defer allocator.free(index_html);
    try root.writeFile(io, .{ .sub_path = index_out, .data = index_html });

    try emitBookFile(root, io, allocator, book_out);
}

fn emitBook(root: std.Io.Dir, io: std.Io, allocator: std.mem.Allocator, writer: *std.Io.Writer) !void {
    const prefix = try root.readFileAlloc(io, "src/runtime-prefix.js", allocator, .limited(max_source_bytes));
    defer allocator.free(prefix);

    const suffix = try root.readFileAlloc(io, "src/runtime-suffix.js", allocator, .limited(max_source_bytes));
    defer allocator.free(suffix);

    try writer.writeAll(prefix);
    try writer.writeAll("\n");
    try writer.writeAll("// ================================================================\n");
    try writer.writeAll("//  GENERATED BOOK CONTENT\n");
    try writer.writeAll("//  Edit src/book_data.zig and content/chapters/*.html, then run:\n");
    try writer.writeAll("//      zig build generate\n");
    try writer.writeAll("// ================================================================\n\n");
    try writer.writeAll("const PARTS = [];\n\n");

    for (book.parts) |part| {
        try writer.writeAll("PARTS.push({\n  title: ");
        try writeJsString(writer, part.title);
        try writer.writeAll(",\n  chapters: [\n");

        for (part.chapters, 0..) |chapter, i| {
            if (i != 0) try writer.writeAll(",\n");
            try writer.writeAll("    {\n");

            try writer.writeAll("      slug: ");
            try writeJsString(writer, chapter.slug);
            try writer.writeAll(",\n");

            try writer.writeAll("      title: ");
            try writeJsString(writer, chapter.title);
            try writer.writeAll(",\n");

            if (chapter.subtitle) |subtitle| {
                try writer.writeAll("      subtitle: ");
                try writeJsString(writer, subtitle);
                try writer.writeAll(",\n");
            }

            if (chapter.hidden) {
                try writer.writeAll("      hidden: true,\n");
            }

            try writer.writeAll("      body: `\n");
            const body = try root.readFileAlloc(io, chapter.body_path, allocator, .limited(max_source_bytes));
            defer allocator.free(body);
            try writer.writeAll(body);
            if (body.len == 0 or body[body.len - 1] != '\n') try writer.writeAll("\n");
            try writer.writeAll("`\n");
            try writer.writeAll("    }");
        }

        try writer.writeAll("\n  ]\n});\n\n");
    }

    try writer.writeAll(suffix);
}

fn writeJsString(writer: *std.Io.Writer, value: []const u8) !void {
    const hex = "0123456789abcdef";

    try writer.writeByte('"');
    for (value) |byte| {
        switch (byte) {
            '\\' => try writer.writeAll("\\\\"),
            '"' => try writer.writeAll("\\\""),
            '\n' => try writer.writeAll("\\n"),
            '\r' => try writer.writeAll("\\r"),
            '\t' => try writer.writeAll("\\t"),
            0...8, 11...12, 14...31 => {
                try writer.writeAll("\\x");
                try writer.writeByte(hex[byte >> 4]);
                try writer.writeByte(hex[byte & 0x0f]);
            },
            else => try writer.writeByte(byte),
        }
    }
    try writer.writeByte('"');
}
