const std = @import("std");
const print = std.debug.print;
const indexOf = std.mem.indexOf;
const split = std.mem.split;
const assert = std.debug.assert;

// const input =
//     \\vJrwpWtwJgWrhcsFMMfFFhFp
//     \\jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
//     \\PmmdzqPrVvPwwTWBwg
//     \\wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
//     \\ttgJtRGJQctTZtZT
//     \\CrZsJsPPZsGzwwsLwLmpwMDw
// ;
const input = @embedFile("day-03.txt");

pub fn main() !void {
    var lines = split(u8, input, "\n");
    var sum_part_one: usize = 0;
    var sum_part_two: usize = 0;
    var window: [3][]const u8 = undefined;
    var pos: u32 = 0;

    while (lines.next()) |line| {
        // Handle part 1
        const left = line[0 .. line.len / 2];
        const right = line[line.len / 2 ..];
        if (left.len != right.len) {
            unreachable;
        }
        var inter_it = intersect(u8, left, right);
        while (inter_it.next()) |item| {
            sum_part_one += priority(item);
            break;
        }
        // Handle part 2
        print("{d} {d}\n", .{ pos, pos % 3 });
        window[pos % 3] = line;
        if (pos % 3 == 2) {
            // print("ITER {s}\n", .{window});
            var inter_first = intersect(u8, window[0], window[1]);
            while (inter_first.next()) |item| {
                var item_arr = [_]u8{item};
                var inter_second = intersect(u8, &item_arr, window[2]);
                var common_char = inter_second.next() orelse continue;
                sum_part_two += priority(common_char);
                print("FOUND {c} -> {}\n", .{ common_char, sum_part_two });
                break;
            }
        }
        pos += 1;
    }
    print("SUM PART ONE {d}\n", .{sum_part_one});
    print("SUM PART TWO {d}\n", .{sum_part_two});

    // Second part

}

pub fn priority(c: usize) usize {
    // Lowercase item types a through z have priorities 1 through 26.
    // Uppercase item types A through Z have priorities 27 through 52.

    if (c >= 97) { // "a" is 97 -> 1
        return c - 96;
    }
    // "A" is 65 -> 27
    return c - 38;
}

pub fn intersect(comptime T: type, left: []const T, right: []const T) IntersectIterator(T) {
    return .{
        .left = left,
        .right = right,
    };
}

pub fn IntersectIterator(comptime T: type) type {
    return struct {
        left: []const T,
        right: []const T,
        index: usize = 0,

        const Self = @This();

        pub fn next(self: *Self) ?T {
            while (self.index < self.left.len) {
                var larr = self.left[self.index .. self.index + 1];
                var pos = indexOf(T, self.right, larr) orelse {
                    self.index += 1;
                    continue;
                };
                self.index += 1;
                return self.right[pos];
            }
            self.index += 1;
            return null;
        }
    };
}

test "test char" {
    const a = 'a';
    const A = 'A';
    print("{} {}\n", .{ a, A });
    print("{} {}\n", .{ priority(a), priority(A) });

    const p = 'p';
    const P = 'P';
    print("{} {}\n", .{ p, P });
    print("{} {}\n", .{ priority(p), priority(P) });

    const z = 'z';
    const Z = 'Z';
    print("{} {}\n", .{ z, Z });
    print("{} {}\n", .{ priority(z), priority(Z) });
}

test "test intersect" {
    var inter_it = intersect(u8, "ham", "spam");
    var item = inter_it.next() orelse '?';
    assert('a' == item);
    item = inter_it.next() orelse '?';
    assert('m' == item);
    item = inter_it.next() orelse '?';
    assert('?' == item);
}
