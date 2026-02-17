`timescale 1ns/1ps
`include "qa/pdf_q28_q30/q28_glitch_free_clock_gate.v"

module pdf_q28_tb;
    reg clk_in;
    reg enable;
    wire gated_clk;

    q28_glitch_free_clock_gate dut (
        .clk_in(clk_in),
        .enable(enable),
        .gated_clk(gated_clk)
    );

    always #5 clk_in = ~clk_in;

    initial begin
        clk_in = 1'b0;
        enable = 1'b0;

        // Enable during high phase must not create mid-cycle glitch.
        @(posedge clk_in);
        #1 enable = 1'b1;
        #1;
        if (gated_clk !== 1'b0) begin
            $display("FAIL Q28: gated clock changed while input clock high");
            $finish;
        end

        @(negedge clk_in);
        #1;
        if (gated_clk !== 1'b0) begin
            $display("FAIL Q28: gated clock should stay low on low phase");
            $finish;
        end

        @(posedge clk_in);
        #1;
        if (gated_clk !== 1'b1) begin
            $display("FAIL Q28: gated clock did not pass clock after enable latch");
            $finish;
        end

        // Disable during high phase must not cut pulse early.
        #1 enable = 1'b0;
        #1;
        if (gated_clk !== 1'b1) begin
            $display("FAIL Q28: gated clock dropped early during high phase");
            $finish;
        end

        @(negedge clk_in);
        #1;
        if (gated_clk !== 1'b0) begin
            $display("FAIL Q28: gated clock should be low after disable latched");
            $finish;
        end

        @(posedge clk_in);
        #1;
        if (gated_clk !== 1'b0) begin
            $display("FAIL Q28: gated clock should remain blocked");
            $finish;
        end

        $display("PASS Q28");
        $finish;
    end
endmodule
