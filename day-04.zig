const std = @import("std");
const print = std.debug.print;
const parseInt = std.fmt.parseInt;
const split = std.mem.split;
const assert = std.debug.assert;
const input = @embedFile("day-04.txt");

pub fn main() !void {
    var lines = split(u8, input, "\n");
    var left: []const u8 = undefined;
    var right: []const u8 = undefined;
    var cnt_f: u32 = 0;
    var cnt_p: u32 = 0;

    while (lines.next()) |line| {
        if (line.len == 0) continue;
        var items = split(u8, line, ",");
        left = items.next() orelse unreachable;
        right = items.next() orelse unreachable;
        if (full_overlap(left, right)) {
            cnt_f += 1;
        }
        if (partial_overlap(left, right)) {
            cnt_p += 1;
        }
    }
    print("TOTAL full overlap{}\n", .{cnt_f});
    print("TOTAL partial overlap{}\n", .{cnt_p});
}

pub fn full_overlap(left: []const u8, right: []const u8) bool {
    var left_range = range_to_ints(left);
    var right_range = range_to_ints(right);
    return (left_range[0] <= right_range[0] and left_range[1] >= right_range[1]) or (left_range[0] >= right_range[0] and left_range[1] <= right_range[1]);
}

pub fn partial_overlap(left: []const u8, right: []const u8) bool {
    var left_range = range_to_ints(left);
    var right_range = range_to_ints(right);
    return (left_range[1] >= right_range[0] and left_range[0] <= right_range[1]) or (left_range[0] <= right_range[1] and left_range[1] >= right_range[0]);
}

pub fn range_to_ints(range: []const u8) [2]i32 {
    const zeros = [2]i32{ 0, 0 };
    var items = split(u8, range, "-");
    var start_str = items.next() orelse unreachable;
    var stop_str = items.next() orelse unreachable;
    var start = parseInt(i32, start_str, 10) catch |err| {
        print("ERR {}", .{err});
        return zeros;
    };
    var stop = parseInt(i32, stop_str, 10) catch |err| {
        print("ERR {}", .{err});
        return zeros;
    };
    var res = [2]i32{ start, stop };
    return res;
}

test "test full_overlap" {
    assert(full_overlap("6-7", "6-9"));
    assert(full_overlap("1-5", "2-4"));
    assert(!full_overlap("1-3", "2-4"));
    assert(!full_overlap("1-3", "5-7"));
}
