const std = @import("std");
const HashList = @import("hashlist.zig").HashList;
const isUpper = std.ascii.isUpper;
const print = std.debug.print;
const split = std.mem.split;
const parseInt = std.fmt.parseInt;

const init_input = @embedFile("day-05-init.txt");
const moves_input = @embedFile("day-05.txt");

// const init_input =
//     \\    [D]
//     \\[N] [C]
//     \\[Z] [M] [P]
//     \\ 1   2   3
// ;
// const moves_input =
//     \\move 1 from 2 to 1
//     \\move 3 from 1 to 3
//     \\move 2 from 2 to 1
//     \\move 1 from 1 to 2
// ;

pub fn main() !void {
    try run();
}

pub fn run() !void {

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

    // MOVES
    lines = split(u8, moves_input, "\n");
    while (lines.next()) |line| {
        if (line.len == 0) continue;
        print("\n", .{});
        var items = try splitMove(line);
        var cnt = items[0];
        var orig = try hl.get(items[1]);
        var dest = try hl.get(items[2]);
        var i: u32 = 0;
        var insert_pos = dest.items.len;
        while (i < cnt) : (i += 1) {
            var el = orig.pop();
            // try dest.append(el); // part 1
            try dest.insert(insert_pos, el); // Part2
        }
        hl.printme();
    }

    // TEARDOWN
    hl.deinit();
}

fn splitMove(line: []const u8) ![3]u32 {
    var parts = split(u8, line, " ");
    var res: [3]u32 = undefined;
    var pos: usize = 0;
    while (parts.next()) |part| {
        // ex: move 5 from 6 to 9
        if (pos == 1 or pos == 3 or pos == 5) {
            var v = try parseInt(u32, part, 10);
            var new_pos = @divTrunc(pos, 2);
            res[new_pos] = v;
        }
        pos += 1;
    }
    print("PARSE {d}\n", .{res});
    return res;
}

test "run" {
    try run();
}

// test "hm" {
//     var allocator = std.testing.allocator;
//     var hl = HashList(u32, u32).init(allocator);
//     var i: u32 = 0;

//     while (i < 2) : (i += 1) {
//         var l = try hl.get(i);
//         try l.append(i);
//         try l.insert(0, i + 10);
//     }
//     hl.deinit();
// }
