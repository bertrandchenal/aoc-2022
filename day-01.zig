const std = @import("std");
const print = std.debug.print;
const sort = std.sort;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

const Elf = struct {
    calories: u32,
};
//var elves = ArrayList(Elf);

fn reifyElves(stream: anytype) !ArrayList(Elf) {
    const allocator = std.heap.page_allocator;
    var elves = ArrayList(Elf).init(allocator);

    var buf: [1024]u8 = undefined;
    var total: u32 = 0;
    while (try stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        if (line.len == 0) {
            // Create new elf
            var elf = Elf{ .calories = total };
            total = 0;
            try elves.append(elf);
            continue;
        }
        const value: u32 = try std.fmt.parseInt(u32, line, 0);
        total += value;
    }
    return elves;
}

fn biggerThan(context: void, lhs: Elf, rhs: Elf) bool {
    _ = context;
    return lhs.calories > rhs.calories;
}

pub fn main() !void {
    // Find max value & position
    var file = try std.fs.cwd().openFile("day-01.txt", .{});
    defer file.close();
    var reader = std.io.bufferedReader(file.reader());
    var stream = reader.reader();

    const elves = try reifyElves(stream);
    var max_calories: u32 = 0;
    var max_pos: usize = 0;
    for (elves.items) |e, i| {
        if (e.calories > max_calories) {
            max_calories = e.calories;
            max_pos = i;
        }
    }
    print("Max value {d} at position {d}\n", .{ max_calories, max_pos });

    // Find top 3 elves
    var items = elves.items;
    sort.sort(Elf, items, {}, biggerThan);
    var top3_total: u32 = 0;
    var pos: usize = 0;
    while (pos <= 2) : (pos += 1) {
        top3_total += items[pos].calories;
    }

    print("Top 3: {d} {d} {d} (total {d}\n)", .{
        items[0].calories,
        items[1].calories,
        items[2].calories,
        top3_total,
    });
}
