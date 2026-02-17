`timescale 1ns/1ps
`include "qa/pdf_q12_q18/q14_last5_detect_10110.v"

module pdf_q14_tb;
    reg clk;
    reg rst;
    reg din;
    wire match;

    integer i;
    reg [11:0] seq_bits;
    reg [4:0] ref_window;
    reg ref_match;

    q14_last5_detect_10110 dut (
        .clk(clk),
        .rst(rst),
        .din(din),
        .match(match)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        rst = 1'b1;
        din = 1'b0;
        ref_window = 5'b00000;
        seq_bits = 12'b001011011010;

        repeat (2) @(posedge clk);
        rst = 1'b0;

        for (i = 11; i >= 0; i = i - 1) begin
            @(negedge clk) din = seq_bits[i];
            @(posedge clk);
            ref_window = {ref_window[3:0], din};
            ref_match = (ref_window == 5'b10110);
            #1;
            if (match !== ref_match) begin
                $display("FAIL Q14 at step %0d: expected %0b got %0b", i, ref_match, match);
                $finish;
            end
        end

        $display("PASS Q14");
        $finish;
    end
endmodule
