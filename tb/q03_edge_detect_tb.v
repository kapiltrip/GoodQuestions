`timescale 1ns/1ps
`include "qa/q03_edge_detect/edge_detect_both.v"

module q03_edge_detect_tb;
    reg clk, rst, d;
    wire q;

    edge_detect_both dut(.clk(clk), .rst(rst), .d(d), .q(q));

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst = 1; d = 0;
        @(posedge clk);
        #1;
        rst = 0;

        d = 0;
        @(posedge clk); #1;
        if (q !== 0) begin $display("FAIL Q03 no edge expected"); $finish; end

        d = 1;
        @(posedge clk); #1;
        if (q !== 1) begin $display("FAIL Q03 rising edge expected"); $finish; end

        d = 1;
        @(posedge clk); #1;
        if (q !== 0) begin $display("FAIL Q03 stable high expected no pulse"); $finish; end

        d = 0;
        @(posedge clk); #1;
        if (q !== 1) begin $display("FAIL Q03 falling edge expected"); $finish; end

        d = 0;
        @(posedge clk); #1;
        if (q !== 0) begin $display("FAIL Q03 stable low expected no pulse"); $finish; end

        $display("PASS Q03 both-edge detector");
        $finish;
    end
endmodule
