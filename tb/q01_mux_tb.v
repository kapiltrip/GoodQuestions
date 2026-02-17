`timescale 1ns/1ps
`include "qa/q01_mux/mux2_dataflow.v"
`include "qa/q01_mux/mux2_behavioral.v"
`include "qa/q01_mux/mux2_gatelevel.v"

module q01_mux_tb;
    reg a, b, sel;
    wire y_df, y_bh, y_gl;

    mux2_dataflow   u_df(.a(a), .b(b), .sel(sel), .y(y_df));
    mux2_behavioral u_bh(.a(a), .b(b), .sel(sel), .y(y_bh));
    mux2_gatelevel  u_gl(.a(a), .b(b), .sel(sel), .y(y_gl));

    integer i;
    initial begin
        for (i = 0; i < 8; i = i + 1) begin
            {a, b, sel} = i[2:0];
            #1;
            if ((y_df !== y_bh) || (y_df !== y_gl)) begin
                $display("FAIL Q01: a=%0b b=%0b sel=%0b -> df=%0b bh=%0b gl=%0b", a, b, sel, y_df, y_bh, y_gl);
                $finish;
            end
        end
        $display("PASS Q01 mux coding styles");
        $finish;
    end
endmodule
