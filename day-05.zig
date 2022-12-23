const std = @import("std");
const HashList = @import("hashlist.zig").HashList;
const isUpper = std.ascii.isUpper;
const print = std.debug.print;
const split = std.mem.split;
const parseInt = std.fmt.parseInt;

const init_input = @embedFile("day-05-init.txt");
const moves_input = @embedFile("day-05.txt");

pub fn main() !void {
    // INIT
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();
    var hl = HashList(usize, u8).init(allocator);
    var lines = split(u8, init_input, "\n");

    while (lines.next()) |line| {
        for (line) |c, pos| {
            if (isUpper(c)) {
                var idx = @divTrunc(pos, 4) + (pos % 4);
                var l = try hl.get(idx);
                try l.insert(0, c);
            }
        }
    }

    // MOVES
    lines = split(u8, moves_input, "\n");
    while (lines.next()) |line| {
        if (line.len == 0) continue;
        const items = try splitMove(line);
        print("ITEMS {d}\n", .{items});
    }

    // TEARDOWN
    // hl.printme();
    hl.deinit();
}

fn splitMove(line: []const u8) ![]u32 {
    var parts = split(u8, line, " ");
    var res: [3]u32 = undefined;
    var pos: usize = 0;
    while (parts.next()) |part| {
        // ex: move 5 from 6 to 9
        if (pos == 1 or pos == 3 or pos == 5) {
            var v = try parseInt(u32, part, 10);
            var new_pos = @divTrunc(pos, 2);
            res[new_pos] = v;
            print("PARSE {s}, {d}\n", .{ part, new_pos });
        }
        pos += 1;
    }
    return &res;
}

test "hm" {
    var allocator = std.testing.allocator;

    var hl = HashList(u32, u32).init(allocator);

    var i: u32 = 0;
    // var l: *ArrayList(u32) = undefined;
    while (i < 2) : (i += 1) {
        var l = try hl.get(i);
        try l.append(i);
        try l.insert(0, i + 10);
    }
    hl.deinit();
}
