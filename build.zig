const std = @import("std");

fn addTestSuite(b: *std.Build, exe: *std.Build.Step.Compile, suite_name: []const u8) !void {
    // Create the suite path (e.g., "Tests/AK")
    const suite_path = b.fmt("Tests/{s}", .{suite_name});
    
    // Open the directory
    var dir = try std.fs.cwd().openDir(suite_path, .{ .iterate = true });
    defer dir.close();

    // Create an ArrayList to store the test files
    var test_files = std.ArrayList([]const u8).init(b.allocator);
    defer test_files.deinit();

    // Iterate through the directory
    var iter = dir.iterate();
    while (try iter.next()) |entry| {
        // Check if the file is a .cpp file
        if (std.mem.endsWith(u8, entry.name, ".cpp")) {
            // Add the full path to our list
            const full_path = b.fmt("{s}/{s}", .{ suite_path, entry.name });
            try test_files.append(full_path);
        }
    }

    // Add all test files to the executable
    exe.addCSourceFiles(.{
        .files = test_files.items,
        .flags = &.{"-std=c++23"},
    });
}

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardOptimizeOption(.{});

// simdutf
// Unicode routines (UTF8, UTF16, UTF32) and Base64: billions of characters per second using SSE2, AVX2, NEON, AVX-512,
// RISC-V Vector Extension, LoongArch64. Part of Node.js, WebKit/Safari, Ladybird, Chromium, Cloudflare Workers and Bun.
    const simdutf = b.addStaticLibrary(.{
        .name = "simdutf",
        .target = target,
        .optimize = mode,
    });
    simdutf.linkLibCpp();
    simdutf.addIncludePath(b.path("Libraries/simdutf"));
    simdutf.addCSourceFiles(.{
        .files = &.{
            "Libraries/simdutf/simdutf.cpp"
        },
        .flags = &.{ 
            "-DSIMDUTF_IMPLEMENTATION_ICELAKE=0",
         },
    });


// LibAK: A custom C++ standard library replacement
// - Provides core data structures and utilities
// - Includes string manipulation, containers, streams
// - Memory management utilities (kmalloc)
// - JSON parsing and serialization
// - Time and date handling
// - UTF-8/16/32 string support
// - Base64, Hex encoding/decoding
// - Path manipulation
// - Error handling primitives
// - Format and string building
// - Random number generation
// - Assertions and debugging utilities
// Originally developed for SerenityOS, can be used standalone
// Designed to be lightweight and efficient alternative to STL
    const lib_AK = b.addStaticLibrary(.{
        .name = "AK",
        .target = target,
        .optimize = mode
    });
    lib_AK.addIncludePath( b.path(".") );

    const debug_flags = [_][]const u8{
        // "-DAFLACLOADER_DEBUG",
        // "-DAUDIO_DEBUG",
        // "-DAWAVLOADER_DEBUG",
        // "-DBMP_DEBUG",
        // "-DBINDINGS_GENERATOR_DEBUG",
        // "-DCACHE_DEBUG",
        // "-DCALLBACK_MACHINE_DEBUG",
        // "-DCANVAS_RENDERING_CONTEXT_2D_DEBUG",
        // "-DCRYPTO_DEBUG",
        // "-DCSS_LOADER_DEBUG",
        // "-DCSS_PARSER_DEBUG",
        // "-DCSS_TOKENIZER_DEBUG",
        // "-DCSS_TRANSITIONS_DEBUG",
        // "-DDNS_DEBUG",
        // "-DEDITOR_DEBUG",
        // "-DEMOJI_DEBUG",
        // "-DFILE_WATCHER_DEBUG",
        // "-DFLAC_ENCODER_DEBUG",
        // "-DGENERATE_DEBUG",
        // "-DGHASH_PROCESS_DEBUG",
        // "-DGIF_DEBUG",
        // "-DHEAP_DEBUG",
        // "-DHIGHLIGHT_FOCUSED_FRAME_DEBUG",
        // "-DHTML_SCRIPT_DEBUG",
        // "-DHTTPJOB_DEBUG",
        // "-DHUNKS_DEBUG",
        // "-DICO_DEBUG",
        // "-DIDL_DEBUG",
        // "-DIMAGE_DECODER_DEBUG",
        // "-DIMAGE_LOADER_DEBUG",
        // "-DJOB_DEBUG",
        // "-DJS_BYTECODE_DEBUG",
        // "-DJS_MODULE_DEBUG",
        // "-DLEXER_DEBUG",
        // "-DLIBWEB_CSS_ANIMATION_DEBUG",
        // "-DLIBWEB_CSS_DEBUG",
        // "-DLIBWEB_WASM_DEBUG",
        // "-DLINE_EDITOR_DEBUG",
        // "-DLZW_DEBUG",
        // "-DMACH_PORT_DEBUG",
        // "-DMATROSKA_DEBUG",
        // "-DMATROSKA_TRACE_DEBUG",
        // "-DNETWORKJOB_DEBUG",
        // "-DNT_DEBUG",
        // "-DOPENTYPE_GPOS_DEBUG",
        // "-DHTML_PARSER_DEBUG",
        // "-DPATH_DEBUG",
        // "-DPLAYBACK_MANAGER_DEBUG",
        // "-DPNG_DEBUG",
        // "-DPROMISE_DEBUG",
        // "-DREGEX_DEBUG",
        // "-DREQUESTSERVER_DEBUG",
        // "-DRESOURCE_DEBUG",
        // "-DRSA_PARSE_DEBUG",
        // "-DSHARED_QUEUE_DEBUG",
        // "-DSPAM_DEBUG",
        // "-DSYNTAX_HIGHLIGHTING_DEBUG",
        // "-DSTYLE_INVALIDATION_DEBUG",
        // "-DTEXTEDITOR_DEBUG",
        // "-DTIFF_DEBUG",
        // "-DTIME_ZONE_DEBUG",
        // "-DTLS_DEBUG",
        // "-DTOKENIZER_TRACE_DEBUG",
        // "-DURL_PARSER_DEBUG",
        // "-DUTF8_DEBUG",
        // "-DVPX_DEBUG",
        // "-DWASI_DEBUG",
        // "-DWASI_FINE_GRAINED_DEBUG",
        // "-DWASM_BINPARSER_DEBUG",
        // "-DWASM_TRACE_DEBUG",
        // "-DWASM_VALIDATOR_DEBUG",
        // "-DWEBDRIVER_DEBUG",
        // "-DWEBDRIVER_ROUTE_DEBUG",
        // "-DWEBGL_CONTEXT_DEBUG",
        // "-DWEBVIEW_PROCESS_DEBUG",
        // "-DWEB_FETCH_DEBUG",
        // "-DWEB_WORKER_DEBUG",
        // "-DWEBP_DEBUG",
        // "-DWORKER_THREAD_DEBUG",
        // "-DXML_PARSER_DEBUG",
    };
    const all_flags = [_][]const u8{"-std=c++23"} ++ debug_flags;

    lib_AK.addCSourceFiles(.{
        .files = &.{
            "AK/Assertions.cpp",
            "AK/Base64.cpp",
            "AK/ByteString.cpp",
            "AK/CircularBuffer.cpp",
            "AK/ConstrainedStream.cpp",
            "AK/CountingStream.cpp",
            "AK/DOSPackedTime.cpp",
            "AK/DeprecatedFlyString.cpp",
            "AK/Error.cpp",
            "AK/FloatingPointStringConversions.cpp",
            "AK/FlyString.cpp",
            "AK/Format.cpp",
            "AK/GenericLexer.cpp",
            "AK/Hex.cpp",
            "AK/JsonObject.cpp",
            "AK/JsonParser.cpp",
            "AK/JsonValue.cpp",
            "AK/LexicalPath.cpp",
            "AK/LexicalPathWindows.cpp",
            "AK/MemoryStream.cpp",
            "AK/NumberFormat.cpp",
            "AK/OptionParser.cpp",
            "AK/Random.cpp",
            "AK/SipHash.cpp",
            "AK/StackInfo.cpp",
            "AK/Stream.cpp",
            "AK/String.cpp",
            "AK/StringBase.cpp",
            "AK/StringBuilder.cpp",
            "AK/StringFloatingPointConversions.cpp",
            "AK/StringImpl.cpp",
            "AK/StringUtils.cpp",
            "AK/StringView.cpp",
            "AK/Time.cpp",
            "AK/Utf16View.cpp",
            "AK/Utf32View.cpp",
            "AK/Utf8View.cpp",
            "AK/kmalloc.cpp",
        },
        .flags = &all_flags,
    });
    lib_AK.linkLibCpp();
    lib_AK.addIncludePath(b.path("Libraries/simdutf"));
    lib_AK.linkLibrary(simdutf);

// Lib Test
    const lib_test = b.addStaticLibrary(.{
        .name = "LibTest",
        .target = target,
        .optimize = mode,
    });
    lib_test.linkLibCpp();
    lib_test.addIncludePath(b.path("."));
    lib_test.linkLibrary(lib_AK);
    lib_test.addIncludePath( b.path("Libraries") );
    lib_test.addCSourceFiles(.{
        .files = &.{
            "Libraries/LibTest/TestSuite.cpp",
            "Libraries/LibTest/CrashTest.cpp",
            "Libraries/LibCore/ArgsParser.cpp",
            "Libraries/LibCore/Version.cpp",
            "Libraries/LibCore/Environment.cpp",
        },
        .flags = &.{ "-std=c++23" },
    });

// Test Executable
// - Links against LibAK for core functionality
// - Uses C++23 standard Libraries/LibTest/TestMain.cpp
    const test_exe = b.addExecutable(.{
        .name = "test",
        .root_module = b.addModule("main", .{
            .target = target,
            .optimize = mode,
            .link_libcpp = true,
        }),
    });

    test_exe.addCSourceFiles(.{
        .files = &.{
            "Libraries/LibTest/TestMain.cpp"
        },
        .flags = &.{
            "-std=c++23"
        }
    });

    test_exe.addIncludePath(b.path("."));
    test_exe.linkLibrary(lib_AK);
    test_exe.addIncludePath(b.path("Libraries"));
    test_exe.linkLibrary(lib_test);

    try addTestSuite(b, test_exe, "AK");

    // Create a run step for the test executable
    const run_test = b.addRunArtifact(test_exe);

    // Add it to the "test" step
    const test_step = b.step("test", "Run all tests");
    test_step.dependOn(&run_test.step);

// Main Executable
// - Links against LibAK for core functionality
// - Uses C++23 standard
    const exe = b.addExecutable(.{
        .name = "hello",
        .root_module = b.addModule("main", .{
            .target = target,
            .optimize = mode,
            .link_libcpp = true,
        }),
    });

    exe.addCSourceFile(.{
        .file = b.path("main.cpp"),
        .flags = &.{
            "-std=c++23"
        }
    });
    exe.addIncludePath( b.path(".") );
    exe.linkLibrary(lib_AK);

    b.installArtifact(exe);	
}