// Q45: Half adder, full adder, and 4-bit ripple-carry adder.

module q45_half_adder (
    input  wire a,
    input  wire b,
    output wire sum,
    output wire carry
);
    assign sum   = a ^ b;
    assign carry = a & b;
endmodule

module q45_full_adder_two_half_adders (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    wire sum_ab;
    wire carry_ab;
    wire carry_cin;

    q45_half_adder u_ha0 (
        .a     (a),
        .b     (b),
        .sum   (sum_ab),
        .carry (carry_ab)
    );

    q45_half_adder u_ha1 (
        .a     (sum_ab),
        .b     (cin),
        .sum   (sum),
        .carry (carry_cin)
    );

    assign cout = carry_ab | carry_cin;
endmodule

module q45_full_adder_boolean (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (cin & (a ^ b));
endmodule

module q45_ripple_adder4 (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       cin,
    output wire [3:0] sum,
    output wire       cout
);
    wire [3:0] carry;

    q45_full_adder_two_half_adders u_fa0 (
        .a    (a[0]),
        .b    (b[0]),
        .cin  (cin),
        .sum  (sum[0]),
        .cout (carry[0])
    );

    q45_full_adder_two_half_adders u_fa1 (
        .a    (a[1]),
        .b    (b[1]),
        .cin  (carry[0]),
        .sum  (sum[1]),
        .cout (carry[1])
    );

    q45_full_adder_two_half_adders u_fa2 (
        .a    (a[2]),
        .b    (b[2]),
        .cin  (carry[1]),
        .sum  (sum[2]),
        .cout (carry[2])
    );

    q45_full_adder_two_half_adders u_fa3 (
        .a    (a[3]),
        .b    (b[3]),
        .cin  (carry[2]),
        .sum  (sum[3]),
        .cout (carry[3])
    );

    assign cout = carry[3];
endmodule

module q45_adder4_behavioral (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       cin,
    output wire [3:0] sum,
    output wire       cout
);
    assign {cout, sum} = a + b + cin;
endmodule
