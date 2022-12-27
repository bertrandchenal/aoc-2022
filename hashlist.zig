const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const HashMap = std.hash_map.HashMap;
const AutoHashMap = std.hash_map.AutoHashMap;
const print = std.debug.print;

pub fn HashList(comptime K: type, comptime V: type) type {
    return struct {
        hm: AutoHashMap(K, *ArrayList(V)),
        allocator: Allocator,
        // arena: std.heap.ArenaAllocator,
        const Self = @This();

        pub fn init(allocator: Allocator) Self {
            // var arena = std.heap.ArenaAllocator.init(allocator);
            // allocator = arena.allocator();
            return Self{
                .hm = std.AutoHashMap(K, *ArrayList(V)).init(allocator),
                .allocator = allocator,

                // .allocator = allocator,
                // .arena = arena.allocator(),
            };
        }

        pub fn deinit(self: *Self) void {
            var h_iterator = self.hm.iterator();
            while (h_iterator.next()) |item| {
                item.value_ptr.*.deinit();
                self.allocator.destroy(item.value_ptr.*);
            }
            self.hm.deinit();
        }

        pub fn printme(self: *Self) void {
            var h_iterator = self.hm.iterator();
            while (h_iterator.next()) |item| {
                print("{} ->", .{item.key_ptr.*});
                for (item.value_ptr.*.items) |val| {
                    print("  {c}", .{val});
                }
                print("\n", .{});
            }
            print("\n", .{});
        }

        pub fn get(self: *Self, k: K) !*ArrayList(V) {
            if (self.hm.contains(k)) {
                var list = self.hm.get(k).?;
                return list;
            } else {
                var list = try self.allocator.create(ArrayList(V));
                list.* = ArrayList(V).init(self.allocator);
                try self.hm.put(k, list);
                return list;
            }
        }
    };
}

test "create" {
    var allocator = std.testing.allocator;

    var hl = HashList(u32, u32).init(allocator);

    var i: u32 = 0;
    var l: *ArrayList(u32) = undefined;
    while (i < 2) : (i += 1) {
        l = try hl.get(i);
        var j: u32 = 0;
        while (j < 20) : (j += 1) {
            try l.append(i);
            try l.insert(0, i + 10);
        }
    }
    print("PRINTME\n", .{});
    hl.printme();

    i = 0;
    while (i < 2) : (i += 1) {
        l = try hl.get(i);
        _ = l.pop();
    }

    print("PRINTME\n", .{});
    hl.printme();

    print("END TEST\n", .{});
    hl.deinit();
}
