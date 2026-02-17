module q05 (
    input  wire [15:0] a,
    output wire [15:0] mul_by_4,
    output wire [15:0] div_by_8
);
    assign mul_by_4 = a << 2;  // multiply by 4
    assign div_by_8 = a >> 3;  // divide by 8
endmodule
