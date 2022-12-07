const std = @import("std");
const print = std.debug.print;
const sort = std.sort;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;

fn round_part_one(a: u8, b: u8) u32 {
    // A rock
    // B paper
    // C scissor
    // X rock
    // Y paper
    // Z scissor
    var score: u32 = switch (a) {
        'A' => switch (b) {
            'Y' => 6, // WIN
            'Z' => 0, // LOSE
            else => 3,
        },
        'B' => switch (b) {
            'Z' => 6,
            'X' => 0,
            else => 3,
        },
        'C' => switch (b) {
            'X' => 6,
            'Y' => 0,
            else => 3,
        },
        else => unreachable,
    };
    const extra: u32 = switch (b) {
        'X' => 1,
        'Y' => 2,
        'Z' => 3,
        else => unreachable,
    };
    return score + extra;
}

fn round_part_two(a: u8, b: u8) u32 {
    // A rock (1)
    // B paper (2)
    // C scissor (3)
    // X lose
    // Y draw
    // Z win

    var score: u32 = switch (b) {
        'X' => 0,
        'Y' => 3,
        'Z' => 6,

        else => unreachable,
    };
    const extra: u32 = switch (a) {
        'A' => switch (b) {
            'X' => 3, // LOSE with scissor
            'Y' => 1, // DRAW with rock
            else => 2, // WIN with paper
        },
        'B' => switch (b) {
            'X' => 1, // LOSE with rock
            'Y' => 2, // DRAW with paper
            else => 3, // WIN with scissor
        },
        'C' => switch (b) {
            'X' => 2, // LOSE with paper
            'Y' => 3, // DRAW with scissor
            else => 1,
        },
        else => unreachable,
    };
    print("score {} extra {}\n", .{ score, extra });
    return score + extra;
}

fn computeScore(stream: anytype) !u32 {
    var buf: [1024]u8 = undefined;
    var total: u32 = 0;
    while (try stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        if (line.len == 0) {
            break;
        }
        total += round_part_two(line[0], line[2]);
    }
    return total;
}

pub fn main() !void {
    // Find max value & position
    var file = try std.fs.cwd().openFile("day-02.txt", .{});
    defer file.close();
    var reader = std.io.bufferedReader(file.reader());
    var stream = reader.reader();
    const score = try computeScore(stream);
    print("Score: {}\n", .{score});
}

test "enum" {
    const Value2 = enum(u32) {
        hundred = 100,
        thousand = 1000,
        million = 1000000,
        next,
    };

    print("{}\n", .{@enumToInt(Value2.hundred) == 100});
}
