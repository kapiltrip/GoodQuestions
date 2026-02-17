`timescale 1ns/1ps
`include "qa/pdf_q28_q30/q29_async_rise_detect_when_clocks_off.v"

module pdf_q29_tb;
    reg d_async;
    reg clr_n;
    wire q;

    q29_async_rise_detect_when_clocks_off dut (
        .d_async(d_async),
        .clr_n(clr_n),
        .q(q)
    );

    initial begin
        d_async = 1'b0;
        clr_n = 1'b0;
        #1;
        if (q !== 1'b0) begin
            $display("FAIL Q29: q should reset low");
            $finish;
        end

        clr_n = 1'b1;
        #2;
        if (q !== 1'b0) begin
            $display("FAIL Q29: q should stay low before rising edge");
            $finish;
        end

        d_async = 1'b1;
        #1;
        if (q !== 1'b1) begin
            $display("FAIL Q29: q did not set on async rising edge");
            $finish;
        end

        d_async = 1'b0;
        #1;
        if (q !== 1'b1) begin
            $display("FAIL Q29: q should hold high");
            $finish;
        end

        clr_n = 1'b0;
        #1;
        if (q !== 1'b0) begin
            $display("FAIL Q29: q did not clear");
            $finish;
        end

        $display("PASS Q29");
        $finish;
    end
endmodule
