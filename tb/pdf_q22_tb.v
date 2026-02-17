`timescale 1ns/1ps
`include "qa/pdf_q22_q23/q22_time_ticks.v"

module pdf_q22_tb;
    reg clk;
    reg rst_n;
    reg one_ms_pulse;
    wire second;
    wire minute;
    wire hour;

    q22_time_ticks dut (
        .clk(clk),
        .rst_n(rst_n),
        .one_ms_pulse(one_ms_pulse),
        .second(second),
        .minute(minute),
        .hour(hour)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        one_ms_pulse = 1'b1;

        repeat (2) @(posedge clk);
        rst_n = 1'b1;

        // Check second tick condition.
        @(negedge clk);
        dut.ms_counter = 10'd998;
        dut.sec_counter = 6'd0;
        dut.min_counter = 6'd0;
        #1;
        if (second !== 1'b0 || minute !== 1'b0 || hour !== 1'b0) begin
            $display("FAIL Q22: unexpected tick before terminal count");
            $finish;
        end

        @(posedge clk);
        #1;
        if (second !== 1'b1 || minute !== 1'b0 || hour !== 1'b0) begin
            $display("FAIL Q22: second tick missing");
            $finish;
        end

        // Check minute tick condition.
        @(negedge clk);
        dut.ms_counter = 10'd999;
        dut.sec_counter = 6'd59;
        dut.min_counter = 6'd10;
        #1;
        if (second !== 1'b1 || minute !== 1'b1 || hour !== 1'b0) begin
            $display("FAIL Q22: minute tick condition failed");
            $finish;
        end

        // Check hour tick condition.
        @(negedge clk);
        dut.ms_counter = 10'd999;
        dut.sec_counter = 6'd59;
        dut.min_counter = 6'd59;
        #1;
        if (second !== 1'b1 || minute !== 1'b1 || hour !== 1'b1) begin
            $display("FAIL Q22: hour tick condition failed");
            $finish;
        end

        $display("PASS Q22");
        $finish;
    end
endmodule
