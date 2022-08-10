//
// Now that we've learned about arrays, we can talk about strings.
//
// We've already seen Zig string literals: "Hello world.\n"
//
// Zig stores strings as arrays of bytes.
//
//     const foo = "Hello";
//
// Is almost* the same as:
//
//     const foo = [_]u8{ 'H', 'e', 'l', 'l', 'o' };
//
// (* We'll see what Zig strings REALLY are in Exercise 77.)
//
// Notice how individual characters use single quotes ('H') and
// strings use double quotes ("H"). These are not interchangeable!
//
const std = @import("std");

// not support unicode(UTF-8) I guess
fn concat(comptime T: type,comptime args: []const []const T, comptime separator: []const T) [] T {
    comptime {
        var buf_size: comptime_int = 0;
        for(args) |arg| {
            buf_size += arg.len;
        }
        buf_size = buf_size + separator.len * (args.len - 1);
        var buf = std.mem.zeroes([buf_size]T);
        var cur = 0;
        for (args) |arg, i| {
            if (i == args.len - 1){
                for (arg) |char| {
                    buf[cur] = char;
                    defer cur += 1;
                }
            } else {
                for (arg) |char| {
                    buf[cur] = char;
                    defer cur += 1;
                }
                for (separator) |char| {
                    buf[cur] = char;
                    defer cur += 1;
                }
            }
        }
        return buf[0..cur];
    }
}

// doing this shit with allocator
fn concatAlloc(comptime T:type, args: []const []const T, separator: []const T, allocator: std.mem.Allocator) std.ArrayList(T) {
    var buf = std.ArrayList(T).init(allocator);
    // Well, it's dumb
    for (args) |arg, i| {
        if (i == args.len - 1){
            for (arg) |char| {
                buf.append(char) catch unreachable;
            }
        } else {
            for (arg) |char| {
                buf.append(char) catch unreachable;
            }
            for (separator) |char| {
                buf.append(char) catch unreachable;
            }
        }
    }
    return buf;
}

pub fn main() void {
    const ziggy = "stardust";

    // (Problem 1)
    // Use array square bracket syntax to get the letter 'd' from
    // the string "stardust" above.
    const d: u8 = ziggy[4];

    // (Problem 2)
    // Use the array repeat '**' operator to make "ha ha ha ".
    const laugh = "ha " ** 3;

    // (Problem 3)
    // Use the array concatenation '++' operator to make "Major Tom".
    // (You'll need to add a space as well!)
    const major = "Major";
    const tom = "Tom";
    // const major_tom = major ++ " " ++ tom;
    // const major_tom = std.fmt.comptimePrint("{} {}", major, tom);
    // const major_tom_array_list = concatAlloc(u8, &[_][] const u8{major, tom}, " ", alloc);
    // defer major_tom_array_list.deinit();
    // const major_tom = major_tom_array_list.items;
    const major_tom = concat(u8, &.{major, tom}, " ");

    // That's all the problems. Let's see our results:
    std.debug.print("d={u} {s}{s}\n", .{ d, laugh, major_tom });
    // Keen eyes will notice that we've put 'u' and 's' inside the '{}'
    // placeholders in the format string above. This tells the
    // print() function to format the values as a UTF-8 character and
    // UTF-8 strings respectively. If we didn't do this, we'd see '100',
    // which is the decimal number corresponding with the 'd' character
    // in UTF-8. (And an error in the case of the strings.)
    //
    // While we're on this subject, 'c' (ASCII encoded character)
    // would work in place for 'u' because the first 128 characters
    // of UTF-8 are the same as ASCII!
    //
}

test "concat" {
    const major = "Major";
    const tom = "Tom";

    // https://ziglang.org/documentation/0.6.0/#Anonymous-List-Literals
    const major_tom: []u8 = concat(u8, &[_][] const u8{major, tom}, " ");
    const eq: bool = std.mem.eql(u8, major_tom, "Major Tom");
    try std.testing.expect(eq == true);
}

test "concatAlloc" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const alloc = gpa.allocator();

    const major = "Major";
    const tom = "Tom";
    const major_tom: []u8 = concatAlloc(u8, &[_][] const u8{major, tom}, " ", alloc).items;
    try std.testing.expect(std.mem.eql(u8, major_tom, "Major Tom"));
}
