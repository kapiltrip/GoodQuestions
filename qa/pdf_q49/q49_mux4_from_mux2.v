// Q49: Create a 4:1 mux using 2:1 muxes.

module q49_mux2 (
    input  wire d0,
    input  wire d1,
    input  wire s,
    output wire y
);
    assign y = s ? d1 : d0;
endmodule

module q49_mux4_from_mux2 (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire s0,
    input  wire s1,
    output wire y
);
    wire low_pair;
    wire high_pair;

    q49_mux2 u_mux_ab (
        .d0 (a),
        .d1 (b),
        .s  (s0),
        .y  (low_pair)
    );

    q49_mux2 u_mux_cd (
        .d0 (c),
        .d1 (d),
        .s  (s0),
        .y  (high_pair)
    );

    q49_mux2 u_mux_final (
        .d0 (low_pair),
        .d1 (high_pair),
        .s  (s1),
        .y  (y)
    );
endmodule

module q49_mux4_boolean (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire s0,
    input  wire s1,
    output wire y
);
    assign y = (~s1 & ~s0 & a) |
               (~s1 &  s0 & b) |
               ( s1 & ~s0 & c) |
               ( s1 &  s0 & d);
endmodule

module q49_mux4_from_mux2_bus #(
    parameter WIDTH = 8
)(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire [WIDTH-1:0] c,
    input  wire [WIDTH-1:0] d,
    input  wire             s0,
    input  wire             s1,
    output wire [WIDTH-1:0] y
);
    wire [WIDTH-1:0] low_pair;
    wire [WIDTH-1:0] high_pair;

    assign low_pair  = s0 ? b : a;
    assign high_pair = s0 ? d : c;
    assign y         = s1 ? high_pair : low_pair;
endmodule
