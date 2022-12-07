const std = @import("std");
const print = std.debug.print;
const indexOf = std.mem.indexOf;
const split = std.mem.split;

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
    var sum: usize = 0;
    while (lines.next()) |line| {
        const left = line[0 .. line.len / 2];
        const right = line[line.len / 2 ..];
        if (left.len != right.len) {
            unreachable;
        }
        var inter_it = intersection(u8, left, right);
        while (inter_it.next()) |item| {
            print("FOUND {c}\n", .{item});
            sum += priority(item);
            break;
        }
    }
    print("SUM {d}\n", .{sum});
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

pub fn intersection(comptime T: type, left: []const T, right: []const T) IntersectionIterator(T) {
    print("left {s} right {s}\n", .{ left, right });
    return .{
        .index = 0,
        .left = left,
        .right = right,
    };
}

pub fn IntersectionIterator(comptime T: type) type {
    return struct {
        left: []const T,
        right: []const T,
        index: usize,

        const Self = @This();

        pub fn next(self: *Self) ?T {
            defer self.index += 1;
            var larr = self.left[self.index .. self.index + 1]; INCORECT MUST RETURN NULL IF INDEX >= ARRAY LEN
            var pos = indexOf(T, self.right, larr) orelse return null; INCORECT MUST FORWARD TO NEXT INDEX
            return self.right[pos];
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
