const calloc = @import("../utils/calloc.zig");

test "" {
    const AllocMaker = struct {
        pub fn getAllocator(_: *@This()) std.mem.Allocator {
            return std.testing.allocator;
        }
    };
    const cator = calloc.wrapAllocator(AllocMaker);

    var five = cator.malloc(5) orelse @panic("oom");
    five = cator.realloc(five, 10) orelse {
        cator.free(five);
        @panic("realloc failed");
    };
    cator.free(five);

    var six = cator.calloc(6, 1) orelse @panic("oom");
    for(six[0..6]) |*v, i| v.* = @intCast(u8, i);
    cator.free(six);

    const aligned = cator.malloc(@sizeOf(max_align_t)) orelse @panic("oom");

    // const aligned_v = @ptrCast(*max_align_t, aligned);
    // aligned_v.* = 10.0; // wow can't even float_init_bigfloat

    cator.free(aligned);
}