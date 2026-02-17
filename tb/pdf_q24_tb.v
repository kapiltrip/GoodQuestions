`timescale 1ns/1ps
`include "qa/pdf_q24/q24_fir_5tap.v"

module pdf_q24_tb;
    reg clk;
    reg rst_n;
    reg signed [15:0] sample_in;
    wire signed [34:0] sample_out;

    integer i;
    reg signed [15:0] x_seq [0:6];
    reg signed [15:0] r1;
    reg signed [15:0] r2;
    reg signed [15:0] r3;
    reg signed [15:0] r4;
    reg signed [34:0] expected_y;

    q24_fir_5tap dut (
        .clk(clk),
        .rst_n(rst_n),
        .sample_in(sample_in),
        .sample_out(sample_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        sample_in = 16'sd0;
        r1 = 16'sd0;
        r2 = 16'sd0;
        r3 = 16'sd0;
        r4 = 16'sd0;

        x_seq[0] = 16'sd1;
        x_seq[1] = 16'sd2;
        x_seq[2] = 16'sd3;
        x_seq[3] = 16'sd4;
        x_seq[4] = 16'sd5;
        x_seq[5] = 16'sd0;
        x_seq[6] = -16'sd1;

        repeat (2) @(posedge clk);
        rst_n = 1'b1;

        for (i = 0; i < 7; i = i + 1) begin
            @(negedge clk) sample_in = x_seq[i];
            @(posedge clk);
            expected_y = sample_in * 1 + r1 * 2 + r2 * 3 + r3 * 2 + r4 * 1;
            r4 = r3;
            r3 = r2;
            r2 = r1;
            r1 = sample_in;
            #1;
            if (sample_out !== expected_y) begin
                $display("FAIL Q24 at step %0d: expected %0d got %0d", i, expected_y, sample_out);
                $finish;
            end
        end

        $display("PASS Q24");
        $finish;
    end
endmodule
