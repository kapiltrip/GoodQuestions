`timescale 1ns/1ps
`include "qa/q04_rise_pulse/edge_to_1cycle_pulse.v"

module q04_rise_pulse_tb;
    reg clk, rst_n, d;
    wire q;

    edge_to_1cycle_pulse dut(
        .clk(clk),
        .rst_n(rst_n),
        .d(d),
        .q(q)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst_n = 0; d = 0;
        @(posedge clk); #1;
        if (q !== 0) begin $display("FAIL Q04 reset q"); $finish; end

        rst_n = 1;

        d = 0;
        @(posedge clk); #1;
        if (q !== 0) begin $display("FAIL Q04 stable low"); $finish; end

        d = 1;
        @(posedge clk); #1;
        if (q !== 1) begin $display("FAIL Q04 rising edge pulse expected"); $finish; end

        d = 1;
        @(posedge clk); #1;
        if (q !== 0) begin $display("FAIL Q04 pulse must be one cycle"); $finish; end

        d = 0;
        @(posedge clk); #1;
        if (q !== 0) begin $display("FAIL Q04 falling edge no pulse"); $finish; end

        d = 1;
        @(posedge clk); #1;
        if (q !== 1) begin $display("FAIL Q04 second rising edge pulse expected"); $finish; end

        @(posedge clk); #1;
        if (q !== 0) begin $display("FAIL Q04 pulse must clear"); $finish; end

        $display("PASS Q04 edge_to_1cycle_pulse");
        $finish;
    end
endmodule
