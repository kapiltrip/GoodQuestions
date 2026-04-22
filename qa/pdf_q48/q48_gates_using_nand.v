// Q48: Build gates using only NAND gates.

module q48_inv_using_nand (
    input  wire a,
    output wire y
);
    assign y = ~(a & a);
endmodule

module q48_and_using_nand (
    input  wire a,
    input  wire b,
    output wire y
);
    wire nand_ab;

    assign nand_ab = ~(a & b);
    assign y       = ~(nand_ab & nand_ab);
endmodule

module q48_or_using_nand (
    input  wire a,
    input  wire b,
    output wire y
);
    wire not_a;
    wire not_b;

    assign not_a = ~(a & a);
    assign not_b = ~(b & b);
    assign y     = ~(not_a & not_b);
endmodule

module q48_xor_using_nand (
    input  wire a,
    input  wire b,
    output wire y
);
    wire nand_ab;
    wire a_term;
    wire b_term;

    assign nand_ab = ~(a & b);
    assign a_term  = ~(a & nand_ab);
    assign b_term  = ~(b & nand_ab);
    assign y       = ~(a_term & b_term);
endmodule

module q48_nor_using_nand (
    input  wire a,
    input  wire b,
    output wire y
);
    wire or_ab;

    q48_or_using_nand u_or (
        .a (a),
        .b (b),
        .y (or_ab)
    );

    assign y = ~(or_ab & or_ab);
endmodule
