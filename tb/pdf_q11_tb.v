`timescale 1ns/1ps
`include "qa/pdf_q07_q11/q11_edge_detect.v"

module pdf_q11_tb;
    reg clk, rst, d;
    wire rising, falling, toggle;

    q11 dut (
        .clk(clk),
        .rst(rst),
        .d(d),
        .rising(rising),
        .falling(falling),
        .toggle(toggle)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        rst = 1'b1;
        d = 1'b0;

        @(posedge clk); #1;
        rst = 1'b0;
        if (rising !== 1'b0 || falling !== 1'b0 || toggle !== 1'b0) begin
            $display("FAIL Q11 reset outputs");
            $finish;
        end

        @(negedge clk);
        d = 1'b1; #1;
        if (rising !== 1'b1 || falling !== 1'b0 || toggle !== 1'b1) begin
            $display("FAIL Q11 rising detect");
            $finish;
        end

        @(posedge clk); #1;
        if (rising !== 1'b0 || falling !== 1'b0 || toggle !== 1'b0) begin
            $display("FAIL Q11 clear after sample high");
            $finish;
        end

        @(negedge clk);
        d = 1'b0; #1;
        if (rising !== 1'b0 || falling !== 1'b1 || toggle !== 1'b1) begin
            $display("FAIL Q11 falling detect");
            $finish;
        end

        @(posedge clk); #1;
        if (rising !== 1'b0 || falling !== 1'b0 || toggle !== 1'b0) begin
            $display("FAIL Q11 clear after sample low");
            $finish;
        end

        $display("PASS Q11");
        $finish;
    end
endmodule
