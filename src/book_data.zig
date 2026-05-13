pub const Chapter = struct {
    slug: []const u8,
    title: []const u8,
    subtitle: ?[]const u8 = null,
    hidden: bool = false,
    body_path: []const u8,
};

pub const Part = struct {
    title: []const u8,
    chapters: []const Chapter,
};

const part_0_chapters = [_]Chapter{
    .{
        .slug = "cover",
        .title = "Cover",
        .hidden = true,
        .body_path = "content/chapters/001-cover.html",
    },
};

const part_1_chapters = [_]Chapter{
    .{
        .slug = "welcome",
        .title = "Welcome to Zig",
        .subtitle = "What Zig is, what it isn't, and why it exists.",
        .body_path = "content/chapters/002-welcome.html",
    },
    .{
        .slug = "version-policy",
        .title = "Version Target",
        .subtitle = "Use the stable Zig release this book targets.",
        .body_path = "content/chapters/003-version-policy.html",
    },
    .{
        .slug = "install",
        .title = "Installing Zig 0.16",
        .subtitle = "Getting the compiler and verifying it works.",
        .body_path = "content/chapters/004-install.html",
    },
    .{
        .slug = "first-program",
        .title = "Your First Program",
        .subtitle = "Hello world, line by line, and the project that contains it.",
        .body_path = "content/chapters/005-first-program.html",
    },
    .{
        .slug = "learning-path",
        .title = "Learning Path and Practice",
        .subtitle = "How to use this book, the official docs, and drills together.",
        .body_path = "content/chapters/006-learning-path.html",
    },
    .{
        .slug = "philosophy",
        .title = "The Zig Philosophy",
        .subtitle = "Why the language insists on the things it insists on.",
        .body_path = "content/chapters/006-philosophy.html",
    },
    .{
        .slug = "project-structure",
        .title = "Project Structure and zig build",
        .subtitle = "A practical tour of the build system enough to be dangerous; Part X covers it properly.",
        .body_path = "content/chapters/007-project-structure.html",
    },
};

const part_2_chapters = [_]Chapter{
    .{
        .slug = "variables",
        .title = "Variables and Constants",
        .subtitle = "const, var, and what mutability actually means.",
        .body_path = "content/chapters/008-variables.html",
    },
    .{
        .slug = "reference-essentials",
        .title = "Language Reference Essentials",
        .subtitle = "Small official-reference topics that unlock real code reading.",
        .body_path = "content/chapters/008-reference-essentials.html",
    },
    .{
        .slug = "integers-floats",
        .title = "Integers and Floats",
        .subtitle = "A complete tour of Zig's numeric types.",
        .body_path = "content/chapters/009-integers-floats.html",
    },
    .{
        .slug = "bool-void-noreturn",
        .title = "Booleans, void, and noreturn",
        .subtitle = "Three small types with specific jobs.",
        .body_path = "content/chapters/010-bool-void-noreturn.html",
    },
    .{
        .slug = "strings",
        .title = "Strings and Character Literals",
        .subtitle = "Bytes, slices, sentinels, and UTF-8.",
        .body_path = "content/chapters/011-strings.html",
    },
    .{
        .slug = "arrays",
        .title = "Arrays",
        .subtitle = "Fixed-size, type-safe, stack-friendly.",
        .body_path = "content/chapters/012-arrays.html",
    },
    .{
        .slug = "slices",
        .title = "Slices and Sentinels",
        .subtitle = "A pointer plus a length; the workhorse of Zig.",
        .body_path = "content/chapters/013-slices.html",
    },
};

const part_3_chapters = [_]Chapter{
    .{
        .slug = "if-switch",
        .title = "Conditionals: if and switch",
        .subtitle = "Expressions, not statements; exhaustive matching.",
        .body_path = "content/chapters/014-if-switch.html",
    },
    .{
        .slug = "loops",
        .title = "Loops: while and for",
        .subtitle = "Two loops, neither one a do-while.",
        .body_path = "content/chapters/015-loops.html",
    },
    .{
        .slug = "labeled-blocks",
        .title = "Labeled Blocks and Loops",
        .subtitle = "Blocks as expressions; structured non-local control.",
        .body_path = "content/chapters/016-labeled-blocks.html",
    },
    .{
        .slug = "defer",
        .title = "Defer and errdefer",
        .subtitle = "Cleanup that happens on exit; cleanup that happens only on failure.",
        .body_path = "content/chapters/017-defer.html",
    },
};

const part_4_chapters = [_]Chapter{
    .{
        .slug = "functions",
        .title = "Functions",
        .subtitle = "Parameters, return types, first-class values.",
        .body_path = "content/chapters/018-functions.html",
    },
    .{
        .slug = "structs",
        .title = "Structs",
        .subtitle = "Aggregates, namespaces, and the thing files actually are.",
        .body_path = "content/chapters/019-structs.html",
    },
    .{
        .slug = "enums",
        .title = "Enums",
        .subtitle = "Named values with optional integer tags.",
        .body_path = "content/chapters/020-enums.html",
    },
    .{
        .slug = "unions",
        .title = "Unions and Tagged Unions",
        .subtitle = "Either-this-or-that with optional discrimination.",
        .body_path = "content/chapters/021-unions.html",
    },
    .{
        .slug = "optionals",
        .title = "Optionals",
        .subtitle = "Null without the nightmares.",
        .body_path = "content/chapters/022-optionals.html",
    },
};

const part_5_chapters = [_]Chapter{
    .{
        .slug = "error-sets",
        .title = "Error Sets",
        .subtitle = "errors are values; values have types",
        .body_path = "content/chapters/023-error-sets.html",
    },
    .{
        .slug = "error-unions",
        .title = "Error Unions",
        .subtitle = "the !T type and what it really is",
        .body_path = "content/chapters/024-error-unions.html",
    },
    .{
        .slug = "try-catch-patterns",
        .title = "Patterns: try, catch, errdefer",
        .subtitle = "the everyday shape of error code",
        .body_path = "content/chapters/025-try-catch-patterns.html",
    },
};

const part_6_chapters = [_]Chapter{
    .{
        .slug = "memory-model",
        .title = "The Memory Model",
        .subtitle = "no hidden allocations, ever",
        .body_path = "content/chapters/026-memory-model.html",
    },
    .{
        .slug = "pointers",
        .title = "Pointers",
        .subtitle = "single, many, sentinel, anyopaque",
        .body_path = "content/chapters/027-pointers.html",
    },
    .{
        .slug = "allocators",
        .title = "The Allocator Interface",
        .subtitle = "one type, many strategies",
        .body_path = "content/chapters/028-allocators.html",
    },
    .{
        .slug = "allocator-zoo",
        .title = "The Allocator Zoo",
        .subtitle = "picking the right one for the job",
        .body_path = "content/chapters/029-allocator-zoo.html",
    },
    .{
        .slug = "memory-safety",
        .title = "Memory Safety",
        .subtitle = "what the compiler and runtime catch, and what they don't",
        .body_path = "content/chapters/030-memory-safety.html",
    },
};

const part_7_chapters = [_]Chapter{
    .{
        .slug = "comptime-eval",
        .title = "Compile-Time Evaluation",
        .subtitle = "the same language, run twice",
        .body_path = "content/chapters/031-comptime-eval.html",
    },
    .{
        .slug = "generics",
        .title = "Generics via Comptime",
        .subtitle = "fn(comptime T: type) T — that's the whole trick",
        .body_path = "content/chapters/032-generics.html",
    },
    .{
        .slug = "type-introspection",
        .title = "Type Introspection",
        .subtitle = "@typeInfo and the metadata of your code",
        .body_path = "content/chapters/033-type-introspection.html",
    },
    .{
        .slug = "comptime-patterns",
        .title = "Comptime Patterns",
        .subtitle = "everyday uses, not just toy examples",
        .body_path = "content/chapters/034-comptime-patterns.html",
    },
};

const part_8_chapters = [_]Chapter{
    .{
        .slug = "packed-structs",
        .title = "Packed Structs and Bit Layout",
        .subtitle = "talking to hardware and wire formats",
        .body_path = "content/chapters/035-packed-structs.html",
    },
    .{
        .slug = "vectors-simd",
        .title = "Vectors and SIMD",
        .subtitle = "@Vector(N, T) and the operators that work on it",
        .body_path = "content/chapters/036-vectors-simd.html",
    },
    .{
        .slug = "inline-asm-builtins",
        .title = "Inline Assembly and Builtins",
        .subtitle = "the escape hatches",
        .body_path = "content/chapters/037-inline-asm-builtins.html",
    },
    .{
        .slug = "threads-atomics",
        .title = "Threads, Atomics, and Concurrency",
        .subtitle = "the runtime concurrency story (and what changed in 0.16)",
        .body_path = "content/chapters/038-threads-atomics.html",
    },
    .{
        .slug = "labeled-switch",
        .title = "Labeled Switch and Tail-Call Dispatch",
        .subtitle = "writing interpreters that go fast",
        .body_path = "content/chapters/039-labeled-switch.html",
    },
};

const part_9_chapters = [_]Chapter{
    .{
        .slug = "stdlib-map",
        .title = "Standard Library Map",
        .subtitle = "what std gives you and where to look first",
        .body_path = "content/chapters/040-stdlib-map.html",
    },
    .{
        .slug = "std-fmt",
        .title = "std.fmt — Formatting and Printing",
        .subtitle = "format strings, but checked",
        .body_path = "content/chapters/040-std-fmt.html",
    },
    .{
        .slug = "std-mem",
        .title = "std.mem — Slices, Bytes, Search",
        .subtitle = "everything you do to []T",
        .body_path = "content/chapters/041-std-mem.html",
    },
    .{
        .slug = "containers",
        .title = "ArrayList, HashMap, and Friends",
        .subtitle = "the everyday containers",
        .body_path = "content/chapters/042-containers.html",
    },
    .{
        .slug = "std-io",
        .title = "std.Io — Reader, Writer, and the New I/O Model",
        .subtitle = "the flagship 0.16 feature",
        .body_path = "content/chapters/043-std-io.html",
    },
    .{
        .slug = "std-fs",
        .title = "std.Io.Dir — Filesystem",
        .subtitle = "directories, files, paths",
        .body_path = "content/chapters/044-std-fs.html",
    },
    .{
        .slug = "std-process",
        .title = "std.process — Args, Env, Subprocesses",
        .subtitle = "the world outside your program",
        .body_path = "content/chapters/045-std-process.html",
    },
    .{
        .slug = "std-crypto",
        .title = "std.crypto — Hashes, Ciphers, KDFs",
        .subtitle = "what the standard library gives you, batteries included",
        .body_path = "content/chapters/046-std-crypto.html",
    },
    .{
        .slug = "std-json",
        .title = "std.json — Parsing, Serializing, Streaming",
        .subtitle = "the JSON support is good, actually",
        .body_path = "content/chapters/047-std-json.html",
    },
};

const part_10_chapters = [_]Chapter{
    .{
        .slug = "build-zig",
        .title = "build.zig fundamentals",
        .subtitle = "Zig's build system is just Zig code",
        .body_path = "content/chapters/048-build-zig.html",
    },
    .{
        .slug = "modules-deps",
        .title = "Modules and dependencies",
        .subtitle = "Packages, build.zig.zon, and the Zig package manager",
        .body_path = "content/chapters/049-modules-deps.html",
    },
    .{
        .slug = "cross-compile",
        .title = "Cross-compilation",
        .subtitle = "Building for every platform from one machine",
        .body_path = "content/chapters/050-cross-compile.html",
    },
    .{
        .slug = "custom-build-steps",
        .title = "Custom build steps",
        .subtitle = "Code generation, test runners, and build-time scripts",
        .body_path = "content/chapters/051-custom-build-steps.html",
    },
};

const part_11_chapters = [_]Chapter{
    .{
        .slug = "c-from-zig",
        .title = "Calling C from Zig",
        .subtitle = "translate-c, headers, and the new 0.16 workflow",
        .body_path = "content/chapters/052-c-from-zig.html",
    },
    .{
        .slug = "zig-from-c",
        .title = "Calling Zig from C",
        .subtitle = "Exporting symbols, callconv(.c), and building shared libraries",
        .body_path = "content/chapters/053-zig-from-c.html",
    },
    .{
        .slug = "zig-cc",
        .title = "zig cc and zig c++",
        .subtitle = "Zig as a hermetic C/C++ cross-compiler",
        .body_path = "content/chapters/054-zig-cc.html",
    },
    .{
        .slug = "wasm-embedded",
        .title = "WebAssembly and freestanding",
        .subtitle = "Zig where there is no operating system",
        .body_path = "content/chapters/055-wasm-embedded.html",
    },
};

const part_12_chapters = [_]Chapter{
    .{
        .slug = "unit-testing",
        .title = "Unit testing",
        .subtitle = "test blocks, std.testing, and the test runner",
        .body_path = "content/chapters/056-unit-testing.html",
    },
    .{
        .slug = "fuzzing-smith",
        .title = "Fuzzing with Smith",
        .subtitle = "Zig 0.16's built-in coverage-guided fuzzer",
        .body_path = "content/chapters/057-fuzzing-smith.html",
    },
    .{
        .slug = "debugging",
        .title = "Debugging",
        .subtitle = "Stack traces, gdb/lldb, logs, and 0.16 diagnostic improvements",
        .body_path = "content/chapters/058-debugging.html",
    },
    .{
        .slug = "practice-projects",
        .title = "Practice Projects",
        .subtitle = "Applied projects that turn syntax knowledge into working Zig judgment.",
        .body_path = "content/chapters/059-practice-projects.html",
    },
    .{
        .slug = "idioms",
        .title = "Idioms and going further",
        .subtitle = "Patterns to internalize, traps to avoid, where to go next",
        .body_path = "content/chapters/059-idioms.html",
    },
};

pub const parts = [_]Part{
    .{ .title = "", .chapters = &part_0_chapters },
    .{ .title = "Foundations", .chapters = &part_1_chapters },
    .{ .title = "Values & Types", .chapters = &part_2_chapters },
    .{ .title = "Control Flow", .chapters = &part_3_chapters },
    .{ .title = "Functions & Composition", .chapters = &part_4_chapters },
    .{ .title = "Part V — Errors as Values", .chapters = &part_5_chapters },
    .{ .title = "Part VI — Memory & Pointers", .chapters = &part_6_chapters },
    .{ .title = "Part VII — Comptime", .chapters = &part_7_chapters },
    .{ .title = "Part VIII — Advanced Language", .chapters = &part_8_chapters },
    .{ .title = "Part IX — Standard Library Tour", .chapters = &part_9_chapters },
    .{ .title = "Part X — The Build System", .chapters = &part_10_chapters },
    .{ .title = "Part XI — Interop", .chapters = &part_11_chapters },
    .{ .title = "Part XII — Testing & Practice", .chapters = &part_12_chapters },
};
