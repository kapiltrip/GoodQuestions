`timescale 1ns/1ps
`include "qa/pdf_q07_q11/q10_latch_and_flop.v"

module pdf_q10_tb;
    reg clk, input_sig;
    wire q_latch, q_flop;

    q10 dut (
        .clk(clk),
        .input_sig(input_sig),
        .q_latch(q_latch),
        .q_flop(q_flop)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        input_sig = 1'b0;

        @(posedge clk); #1;
        if (q_latch !== 1'b0 || q_flop !== 1'b0) begin $display("FAIL Q10 init"); $finish; end

        input_sig = 1'b1; #1;
        if (q_latch !== 1'b1) begin $display("FAIL Q10 latch follow high"); $finish; end
        if (q_flop !== 1'b0)  begin $display("FAIL Q10 flop changed without edge"); $finish; end

        input_sig = 1'b0; #1;
        if (q_latch !== 1'b0) begin $display("FAIL Q10 latch follow low"); $finish; end

        @(negedge clk);
        input_sig = 1'b1; #1;
        if (q_latch !== 1'b0) begin $display("FAIL Q10 latch hold while clk low"); $finish; end

        @(posedge clk); #1;
        if (q_flop !== 1'b1) begin $display("FAIL Q10 flop capture at posedge"); $finish; end
        if (q_latch !== 1'b1) begin $display("FAIL Q10 latch open on high"); $finish; end

        $display("PASS Q10");
        $finish;
    end
endmodule
