const std = @import("std");
const print = std.debug.print;
const HashList = @import("hashlist.zig").HashList;
const split = std.mem.split;
const isUpper = std.ascii.isUpper;

const init_input = @embedFile("day-05-init.txt");

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
    hl.printme();
    hl.deinit();
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
