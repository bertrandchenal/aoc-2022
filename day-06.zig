const std = @import("std");
const HashList = @import("hashlist.zig").HashList;
const isUpper = std.ascii.isUpper;
const print = std.debug.print;
const allEqual = std.mem.allEqual;

const input = @embedFile("day-06.txt");
//const input = "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"; // test part1
//const input = "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"; //test part2

pub fn main() !void {
    try run();
}

pub fn allDiff(arr: []u8) bool {
    var i: u8 = 0;
    while (i < arr.len) : (i += 1) {
        var j: u8 = i + 1;
        while (j < arr.len) : (j += 1) {
            if (arr[i] == arr[j]) {
                return false;
            }
        }
    }
    return true;
}

pub fn run() !void {
    var buf: [4]u8 = undefined;
    var pos: usize = 0;
    while (pos < input.len) : (pos += 1) {
        buf[pos % 4] = input[pos];
        print("{c}\n", .{input[pos]});
        if (pos >= 4 and allDiff(buf[0..])) {
            print("FOUND! {d}\n", .{pos + 1});
            break;
        }
    }
}
