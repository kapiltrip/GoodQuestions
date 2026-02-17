`timescale 1ns/1ps
`include "qa/pdf_q07_q11/q09_ff_reset_styles.v"

module pdf_q09_tb;
    reg clk, rst, d;
    wire q_async, q_sync;

    q09_a dut_async (.clk(clk), .rst(rst), .d(d), .q(q_async));
    q09_b dut_sync  (.clk(clk), .rst(rst), .d(d), .q(q_sync));

    initial clk = 1'b0;
    always #5 clk = ~clk;

    initial begin
        rst = 1'b1;
        d = 1'b1;

        #1;
        if (q_async !== 1'b0) begin $display("FAIL Q09 async reset immediate"); $finish; end

        @(posedge clk); #1;
        if (q_sync !== 1'b0) begin $display("FAIL Q09 sync reset on clk"); $finish; end

        rst = 1'b0;
        @(posedge clk); #1;
        if (q_async !== 1'b1 || q_sync !== 1'b1) begin
            $display("FAIL Q09 load d");
            $finish;
        end

        @(negedge clk);
        rst = 1'b1;
        #1;
        if (q_async !== 1'b0) begin $display("FAIL Q09 async did not reset immediately"); $finish; end
        if (q_sync !== 1'b1)  begin $display("FAIL Q09 sync changed before clk"); $finish; end

        @(posedge clk); #1;
        if (q_sync !== 1'b0) begin $display("FAIL Q09 sync reset missing on clk"); $finish; end

        $display("PASS Q09");
        $finish;
    end
endmodule
