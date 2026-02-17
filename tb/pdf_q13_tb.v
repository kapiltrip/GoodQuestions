`timescale 1ns/1ps
`include "qa/pdf_q12_q18/q13_seq_10110_fsms_abcd.v"

module pdf_q13_tb;
    reg clk;
    reg rst;
    reg x;
    wire y_a;
    wire y_b;
    wire y_c;
    wire y_d;

    integer i;
    integer cnt_a;
    integer cnt_b;
    integer cnt_c;
    integer cnt_d;
    reg [7:0] seq_bits;

    q13_a dut_a (.clk(clk), .rst(rst), .x(x), .y(y_a));
    q13_b dut_b (.clk(clk), .rst(rst), .x(x), .y(y_b));
    q13_c dut_c (.clk(clk), .rst(rst), .x(x), .y(y_c));
    q13_d dut_d (.clk(clk), .rst(rst), .x(x), .y(y_d));

    always #5 clk = ~clk;
    always @(posedge y_a) if (!rst) cnt_a = cnt_a + 1;
    always @(posedge y_b) if (!rst) cnt_b = cnt_b + 1;
    always @(posedge y_c) if (!rst) cnt_c = cnt_c + 1;
    always @(posedge y_d) if (!rst) cnt_d = cnt_d + 1;

    initial begin
        clk = 1'b0;
        rst = 1'b1;
        x = 1'b0;
        cnt_a = 0;
        cnt_b = 0;
        cnt_c = 0;
        cnt_d = 0;
        seq_bits = 8'b10110110; // overlapping pattern case

        repeat (2) @(posedge clk);
        rst = 1'b0;

        for (i = 7; i >= 0; i = i - 1) begin
            @(negedge clk) x = seq_bits[i];
            @(posedge clk);
        end

        // Flush Moore outputs by running two extra cycles.
        repeat (2) begin
            @(negedge clk) x = 1'b0;
            @(posedge clk);
        end

        if (cnt_a !== 2) begin
            $display("FAIL Q13 A: expected 2 detects, got %0d", cnt_a);
            $finish;
        end
        if (cnt_b !== 1) begin
            $display("FAIL Q13 B: expected 1 detect, got %0d", cnt_b);
            $finish;
        end
        if (cnt_c !== 2) begin
            $display("FAIL Q13 C: expected 2 detects, got %0d", cnt_c);
            $finish;
        end
        if (cnt_d !== 1) begin
            $display("FAIL Q13 D: expected 1 detect, got %0d", cnt_d);
            $finish;
        end

        $display("PASS Q13");
        $finish;
    end
endmodule
