module q06 (
    input  wire [4:0] a,
    output wire [9:0] c
);
    assign c = {{5{a[4]}}, a};
endmodule
