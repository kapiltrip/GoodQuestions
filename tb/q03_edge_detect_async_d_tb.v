`timescale 1ns/1ps
`include "qa/q03_edge_detect/edge_detect_both.v"

module q03_edge_detect_async_d_tb;
    reg clk, rst, d;
    wire q;

    edge_detect_both_async_d dut(.clk(clk), .rst(rst), .d(d), .q(q));

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst = 1;
        d = 0;
        repeat (2) @(posedge clk);
        rst = 0;

        // Async rise between clock edges.
        #3 d = 1;
        repeat (3) @(posedge clk);
        #1;
        if (q !== 1) begin $display("FAIL Q03A expected pulse for async rise"); $finish; end

        @(posedge clk); #1;
        if (q !== 0) begin $display("FAIL Q03A pulse should be one cycle"); $finish; end

        // Async fall between clock edges.
        #2 d = 0;
        repeat (3) @(posedge clk);
        #1;
        if (q !== 1) begin $display("FAIL Q03A expected pulse for async fall"); $finish; end

        @(posedge clk); #1;
        if (q !== 0) begin $display("FAIL Q03A pulse should be one cycle"); $finish; end

        $display("PASS Q03A both-edge detector with async d");
        $finish;
    end
endmodule
