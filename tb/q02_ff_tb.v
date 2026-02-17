`timescale 1ns/1ps
`include "qa/q02_ff/dff_async_reset.v"
`include "qa/q02_ff/dff_sync_reset.v"

module q02_ff_tb;
    reg clk, rst, d;
    wire q_async, q_sync;

    dff_async_reset u_async(.clk(clk), .rst(rst), .d(d), .q(q_async));
    dff_sync_reset  u_sync (.clk(clk), .rst(rst), .d(d), .q(q_sync));

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst = 1; d = 0;
        #3;
        if (q_async !== 0) begin
            $display("FAIL Q02 async reset behavior");
            $finish;
        end

        rst = 0;
        d = 1;
        @(posedge clk);
        #1;
        if (q_async !== 1 || q_sync !== 1) begin
            $display("FAIL Q02 set behavior");
            $finish;
        end

        d = 0;
        rst = 1;
        #1;
        if (q_async !== 0) begin
            $display("FAIL Q02 async should reset immediately");
            $finish;
        end
        if (q_sync !== 1) begin
            $display("FAIL Q02 sync should wait for clock edge");
            $finish;
        end

        @(posedge clk);
        #1;
        if (q_sync !== 0) begin
            $display("FAIL Q02 sync reset on clock edge");
            $finish;
        end

        $display("PASS Q02 async vs sync DFF");
        $finish;
    end
endmodule
