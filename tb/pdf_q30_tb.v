`timescale 1ns/1ps
`include "qa/pdf_q28_q30/q30_reset_synchronizer.v"

module pdf_q30_tb;
    reg clk;
    reg rst_n;
    wire local_reset_n;

    q30_reset_synchronizer dut (
        .clk(clk),
        .rst_n(rst_n),
        .local_reset_n(local_reset_n)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;

        #1;
        if (local_reset_n !== 1'b0) begin
            $display("FAIL Q30: local reset should assert immediately");
            $finish;
        end

        @(negedge clk) rst_n = 1'b1;

        @(posedge clk);
        #1;
        if (local_reset_n !== 1'b0) begin
            $display("FAIL Q30: deasserted too early at first clock");
            $finish;
        end

        @(posedge clk);
        #1;
        if (local_reset_n !== 1'b1) begin
            $display("FAIL Q30: did not deassert after two clocks");
            $finish;
        end

        // Async assert check mid-cycle.
        #2 rst_n = 1'b0;
        #1;
        if (local_reset_n !== 1'b0) begin
            $display("FAIL Q30: async assert failed");
            $finish;
        end

        @(negedge clk) rst_n = 1'b1;
        @(posedge clk);
        #1;
        if (local_reset_n !== 1'b0) begin
            $display("FAIL Q30: re-deasserted too early");
            $finish;
        end
        @(posedge clk);
        #1;
        if (local_reset_n !== 1'b1) begin
            $display("FAIL Q30: re-deassert failed");
            $finish;
        end

        $display("PASS Q30");
        $finish;
    end
endmodule
