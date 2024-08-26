const std = @import("std");

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Run `zig build test` to run the tests.\n", .{});

    hello();
    std.debug.print("{d}\n", .{add(10, 20)});

    forLoop();
    forLoopWithIndex();
    whileLoop();
    Errors_();
    catchErrors();
    _ = try ThrowErrors();

    try bw.flush(); // don't forget to flush!
}

fn hello() void {
    std.debug.print("Hello, World!\n", .{});
}

fn add(a: i7, b: i7) i7 {
    std.debug.print("{s}", .{"Add two integers ==> "});
    var c: i7 = undefined;
    c = 23;
    return a + b + c;
}

fn forLoop() void {
    const elems = [_]u8{ 'H', 'e', 'l', 'l', 'o' };
    std.debug.print("{s}", .{"For Loop ==> "});
    for (elems) |elem| {
        std.debug.print("{c}", .{elem});
    }
    std.debug.print("\n", .{});
}

fn forLoopWithIndex() void {
    const elems = [_]u8{ 'H', 'e', 'l', 'l', 'o', ' ', 'M', '.' };
    std.debug.print("{s}", .{"For Loop with Index ==> "});
    for (elems, 0..) |_, idx| {
        std.debug.print("{c}", .{elems[idx]});
    }
    std.debug.print("\n", .{});
}

fn whileLoop() void {
    const elems = [_]u8{ 'H', 'e', 'l', 'l', 'o', ' ', 'M', '.', '!' };
    const len = elems.len;
    var i: usize = 0;
    std.debug.print("{s}", .{"While Loop ==> "});
    while (i < len) : (i += 1) {
        std.debug.print("{c}", .{elems[i]});
    }
    std.debug.print("\n", .{});
}

const AllocationError = error{OutOfMemory};

const FileOpenError = error{
    AccessDenied,
    OutOfMemory,
    FileNotFound,
};

fn Errors_() void {
    const err: FileOpenError = AllocationError.OutOfMemory;
    std.debug.print("{s}", .{"Errors...\n"});
    std.debug.assert(FileOpenError.OutOfMemory == err);
}

fn catchErrors() void {
    std.debug.print("{s}", .{"Catch Errors...\n"});
    const err_val: u16 = ThrowErrors() catch 29;
    _ = err_val;
}

fn ThrowErrors() !u16 {
    return FileOpenError.AccessDenied;
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
