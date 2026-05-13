const std = @import("std");

const max_file_bytes: usize = 16 * 1024 * 1024;

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const allocator = init.gpa;
    const args = try init.minimal.args.toSlice(init.arena.allocator());

    const root_path = if (args.len > 1) args[1] else "dist";
    const port = if (args.len > 2) try std.fmt.parseInt(u16, args[2], 10) else 8080;

    var root = try std.Io.Dir.cwd().openDir(io, root_path, .{});
    defer root.close(io);

    const address = try std.Io.net.IpAddress.parseIp4("127.0.0.1", port);
    var server = try address.listen(io, .{ .reuse_address = true });
    defer server.deinit(io);

    std.debug.print("Serving {s} at http://127.0.0.1:{d}/\n", .{ root_path, port });
    std.debug.print("Press Ctrl-C to stop.\n", .{});

    while (true) {
        var stream = try server.accept(io);
        handleConnection(io, allocator, root, stream) catch |err| {
            std.debug.print("connection error: {s}\n", .{@errorName(err)});
        };
        stream.close(io);
    }
}

fn handleConnection(
    io: std.Io,
    allocator: std.mem.Allocator,
    root: std.Io.Dir,
    stream: std.Io.net.Stream,
) !void {
    var send_buffer: [16 * 1024]u8 = undefined;
    var recv_buffer: [16 * 1024]u8 = undefined;
    var connection_reader = stream.reader(io, &recv_buffer);
    var connection_writer = stream.writer(io, &send_buffer);
    const reader = &connection_reader.interface;
    const writer = &connection_writer.interface;

    const request_line = reader.takeDelimiterExclusive('\n') catch return;
    const target = parseTarget(request_line) orelse return try respondText(writer, .bad_request, "bad request\n");

    while (true) {
        const line = reader.takeDelimiterExclusive('\n') catch return;
        const trimmed = std.mem.trimEnd(u8, line, "\r");
        if (trimmed.len == 0) break;
    }

    try serveRequest(io, allocator, root, writer, target);
}

fn serveRequest(
    io: std.Io,
    allocator: std.mem.Allocator,
    root: std.Io.Dir,
    writer: *std.Io.Writer,
    raw_target: []const u8,
) !void {
    const target = stripQuery(raw_target);
    const file_path = resolvePath(target) orelse {
        return respondText(writer, .not_found, "not found\n");
    };

    const bytes = root.readFileAlloc(io, file_path, allocator, .limited(max_file_bytes)) catch |err| switch (err) {
        error.FileNotFound => {
            return respondText(writer, .not_found, "not found\n");
        },
        else => return err,
    };
    defer allocator.free(bytes);

    try respond(writer, .ok, contentType(file_path), bytes);
}

fn parseTarget(request_line: []const u8) ?[]const u8 {
    const line = std.mem.trimEnd(u8, request_line, "\r");
    var parts = std.mem.splitScalar(u8, line, ' ');
    const method = parts.next() orelse return null;
    const target = parts.next() orelse return null;
    if (!std.mem.eql(u8, method, "GET") and !std.mem.eql(u8, method, "HEAD")) return null;
    if (!std.mem.startsWith(u8, target, "/")) return null;
    return target;
}

const Status = enum {
    ok,
    bad_request,
    not_found,
};

fn respondText(writer: *std.Io.Writer, status: Status, body: []const u8) !void {
    try respond(writer, status, "text/plain; charset=utf-8", body);
}

fn respond(writer: *std.Io.Writer, status: Status, content_type: []const u8, body: []const u8) !void {
    const code: u16, const reason: []const u8 = switch (status) {
        .ok => .{ 200, "OK" },
        .bad_request => .{ 400, "Bad Request" },
        .not_found => .{ 404, "Not Found" },
    };

    try writer.print(
        "HTTP/1.1 {d} {s}\r\n" ++
            "Content-Length: {d}\r\n" ++
            "Content-Type: {s}\r\n" ++
            "Cache-Control: no-store\r\n" ++
            "Connection: close\r\n" ++
            "\r\n",
        .{ code, reason, body.len, content_type },
    );
    try writer.writeAll(body);
    try writer.flush();
}

fn stripQuery(target: []const u8) []const u8 {
    const query = std.mem.findScalar(u8, target, '?') orelse target.len;
    return target[0..query];
}

fn resolvePath(target: []const u8) ?[]const u8 {
    if (std.mem.eql(u8, target, "/")) return "index.html";
    if (std.mem.eql(u8, target, "/index.html")) return "index.html";
    if (std.mem.eql(u8, target, "/book.js")) return "book.js";
    return null;
}

fn contentType(path: []const u8) []const u8 {
    if (std.mem.endsWith(u8, path, ".html")) return "text/html; charset=utf-8";
    if (std.mem.endsWith(u8, path, ".js")) return "application/javascript; charset=utf-8";
    return "application/octet-stream";
}
