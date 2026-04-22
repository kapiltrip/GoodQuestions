// Q46: Implement basic gates using only 2:1 mux structure.
//
// q46_mux2 convention:
//   s = 0 -> y = d0
//   s = 1 -> y = d1

module q46_mux2 (
    input  wire d0,
    input  wire d1,
    input  wire s,
    output wire y
);
    assign y = s ? d1 : d0;
endmodule

module q46_inv_using_mux2 (
    input  wire a,
    output wire y
);
    q46_mux2 u_mux (.d0(1'b1), .d1(1'b0), .s(a), .y(y));
endmodule

module q46_and_using_mux2 (
    input  wire a,
    input  wire b,
    output wire y
);
    q46_mux2 u_mux (.d0(1'b0), .d1(b), .s(a), .y(y));
endmodule

module q46_or_using_mux2 (
    input  wire a,
    input  wire b,
    output wire y
);
    q46_mux2 u_mux (.d0(b), .d1(1'b1), .s(a), .y(y));
endmodule

module q46_nand_using_mux2 (
    input  wire a,
    input  wire b,
    output wire y
);
    q46_mux2 u_mux (.d0(1'b1), .d1(~a), .s(b), .y(y));
endmodule

module q46_nor_using_mux2 (
    input  wire a,
    input  wire b,
    output wire y
);
    q46_mux2 u_mux (.d0(~b), .d1(1'b0), .s(a), .y(y));
endmodule

module q46_xor_using_mux2 (
    input  wire a,
    input  wire b,
    output wire y
);
    q46_mux2 u_mux (.d0(b), .d1(~b), .s(a), .y(y));
endmodule

module q46_xnor_using_mux2 (
    input  wire a,
    input  wire b,
    output wire y
);
    q46_mux2 u_mux (.d0(~b), .d1(b), .s(a), .y(y));
endmodule
