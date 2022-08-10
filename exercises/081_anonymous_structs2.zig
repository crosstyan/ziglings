//
// An anonymous struct value LITERAL (not to be confused with a
// struct TYPE) uses '.{}' syntax:
//
//     .{
//          .center_x = 15,
//          .center_y = 12,
//          .radius = 6,
//     }
//
// These literals are always evaluated entirely at compile-time.
// The example above could be coerced into the i32 variant of the
// "circle struct" from the last exercise.
//
// Or you can let them remain entirely anonymous as in this
// example:
//
//     fn bar(foo: anytype) void {
//         print("a:{} b:{}\n", .{foo.a, foo.b});
//     }
//
//     bar(.{
//         .a = true,
//         .b = false,
//     });
//
// The example above prints "a:true b:false".
//
const print = @import("std").debug.print;

pub fn main() void {
    printCircle(.{
        .center_x = @as(u32, 205),
        .center_y = @as(u32, 187),
        .radius = @as(u32, 12),
    });
}

// Please complete this function which prints an anonymous struct
// representing a circle.

// When you say anytype. Usually you don't really mean ANY type.
// You want some type that can do something
// like this circle should be a struct that has field center_x, center_y, and radius.
// You can somehow fix it by adding guard inside the function
// but it doesn't make a difference if you just see the signature/type of this function.
// You will say "any? really?" like (void *) in C, but this compiler is much better,
// since it can infer the return type by @TypeOf
// I mean you still have to document the type.
fn printCircle(circle: anytype) void {
    print("x:{} y:{} radius:{}\n", .{
        circle.center_x,
        circle.center_y,
        circle.radius,
    });
}

// These is no type in C and everything is void *.
// But you still have to annotate every type or the compiler will complain.
// That's why C is called Static but weak type.
// 
//  "Dynamically typed languages (where type checking happens at run time) can
//  also be strongly typed. Note that in dynamically typed languages, values
//  have types, not variables."
// https://en.wikipedia.org/wiki/Strong_and_weak_typing
