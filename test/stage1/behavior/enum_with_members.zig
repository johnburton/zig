const expect = @import("std").testing.expect;
const mem = @import("std").mem;
const fmtstream = @import("std").fmtstream;

const ET = union(enum) {
    SINT: i32,
    UINT: u32,

    pub fn print(a: *const ET, buf: []u8) anyerror!usize {
        return switch (a.*) {
            ET.SINT => |x| fmtstream.formatIntBuf(buf, x, 10, false, fmtstream.FormatOptions{}),
            ET.UINT => |x| fmtstream.formatIntBuf(buf, x, 10, false, fmtstream.FormatOptions{}),
        };
    }
};

test "enum with members" {
    const a = ET{ .SINT = -42 };
    const b = ET{ .UINT = 42 };
    var buf: [20]u8 = undefined;

    expect((a.print(buf[0..]) catch unreachable) == 3);
    expect(mem.eql(u8, buf[0..3], "-42"));

    expect((b.print(buf[0..]) catch unreachable) == 2);
    expect(mem.eql(u8, buf[0..2], "42"));
}
