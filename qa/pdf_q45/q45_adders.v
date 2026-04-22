// Q45: Half/full adders, half/full subtractors, and 4-bit ripple chains.

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

    // Equivalent carry forms:
    // cout = (a & b) | (cin & (a ^ b));
    // cout = (a & b) | (a & cin) | (b & cin);
    assign cout = (a & b) | (cin & (a ^ b));
endmodule

module q45_full_adder_majority_carry (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
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

module q45_half_subtractor (
    input  wire a,
    input  wire b,
    output wire diff,
    output wire borrow
);
    assign diff   = a ^ b;
    assign borrow = ~a & b;
endmodule

module q45_full_subtractor_two_half_subtractors (
    input  wire a,
    input  wire b,
    input  wire bin,
    output wire diff,
    output wire bout
);
    wire diff_ab;
    wire borrow_ab;
    wire borrow_bin;

    q45_half_subtractor u_hs0 (
        .a      (a),
        .b      (b),
        .diff   (diff_ab),
        .borrow (borrow_ab)
    );

    q45_half_subtractor u_hs1 (
        .a      (diff_ab),
        .b      (bin),
        .diff   (diff),
        .borrow (borrow_bin)
    );

    assign bout = borrow_ab | borrow_bin;
endmodule

module q45_full_subtractor_boolean (
    input  wire a,
    input  wire b,
    input  wire bin,
    output wire diff,
    output wire bout
);
    assign diff = a ^ b ^ bin;

    // Equivalent forms:
    // bout = (~a & b) | (bin & ~(a ^ b));
    // bout = (~a & b) | (~a & bin) | (b & bin);
    assign bout = (~a & b) | (bin & ~(a ^ b));
endmodule

module q45_ripple_subtractor4 (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       bin,
    output wire [3:0] diff,
    output wire       bout
);
    wire [3:0] borrow;

    q45_full_subtractor_two_half_subtractors u_fs0 (
        .a    (a[0]),
        .b    (b[0]),
        .bin  (bin),
        .diff (diff[0]),
        .bout (borrow[0])
    );

    q45_full_subtractor_two_half_subtractors u_fs1 (
        .a    (a[1]),
        .b    (b[1]),
        .bin  (borrow[0]),
        .diff (diff[1]),
        .bout (borrow[1])
    );

    q45_full_subtractor_two_half_subtractors u_fs2 (
        .a    (a[2]),
        .b    (b[2]),
        .bin  (borrow[1]),
        .diff (diff[2]),
        .bout (borrow[2])
    );

    q45_full_subtractor_two_half_subtractors u_fs3 (
        .a    (a[3]),
        .b    (b[3]),
        .bin  (borrow[2]),
        .diff (diff[3]),
        .bout (borrow[3])
    );

    assign bout = borrow[3];
endmodule

module q45_subtractor4_behavioral (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       bin,
    output wire [3:0] diff,
    output wire       bout
);
    wire [4:0] full_result;

    assign full_result = {1'b0, a} - {1'b0, b} - bin;
    assign diff        = full_result[3:0];
    assign bout        = full_result[4];
endmodule
