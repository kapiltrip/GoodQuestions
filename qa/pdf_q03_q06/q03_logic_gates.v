module q03 (
    input  wire a,
    input  wire b,
    output wire and_y,
    output wire or_y,
    output wire xor_y,
    output wire nand_y,
    output wire nor_y,
    output wire xnor_y
);
    assign and_y  = a & b;
    assign or_y   = a | b;
    assign xor_y  = a ^ b;
    assign nand_y = ~(a & b);
    assign nor_y  = ~(a | b);
    assign xnor_y = ~(a ^ b);
endmodule

module q03_bitwise_vector #(
    parameter WIDTH = 4
) (
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    output wire [WIDTH-1:0] and_y,
    output wire [WIDTH-1:0] or_y,
    output wire [WIDTH-1:0] xor_y,
    output wire [WIDTH-1:0] nand_y,
    output wire [WIDTH-1:0] nor_y,
    output wire [WIDTH-1:0] xnor_y
);
    assign and_y  = a & b;
    assign or_y   = a | b;
    assign xor_y  = a ^ b;
    assign nand_y = ~(a & b);
    assign nor_y  = ~(a | b);
    assign xnor_y = ~(a ^ b);
endmodule

module q03_logical (
    input  wire a,
    input  wire b,
    output wire and_y,
    output wire or_y,
    output wire xor_y,
    output wire nand_y,
    output wire nor_y,
    output wire xnor_y
);
    assign and_y  = a && b;
    assign or_y   = a || b;
    assign xor_y  = a != b;
    assign nand_y = !(a && b);
    assign nor_y  = !(a || b);
    assign xnor_y = a == b;
endmodule
