`timescale 1ns/1ps
`include "qa/pdf_q22_q23/q23_timing_b_from_a.v"

module pdf_q23_tb;
    reg clk;
    reg rst_n;
    reg A;
    wire B;

    integer i;
    reg [9:0] seq_bits;
    reg a_delay_ref;
    reg expected_b;

    q23_timing_b_from_a dut (
        .clk(clk),
        .rst_n(rst_n),
        .A(A),
        .B(B)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        A = 1'b0;
        a_delay_ref = 1'b0;
        seq_bits = 10'b1010011101;

        repeat (2) @(posedge clk);
        rst_n = 1'b1;

        for (i = 9; i >= 0; i = i - 1) begin
            @(negedge clk) A = seq_bits[i];
            #1;
            expected_b = A | a_delay_ref;
            if (B !== expected_b) begin
                $display("FAIL Q23 at step %0d (negedge): expected %0b got %0b", i, expected_b, B);
                $finish;
            end

            @(posedge clk);
            a_delay_ref = A;
            #1;
            expected_b = A | a_delay_ref;
            if (B !== expected_b) begin
                $display("FAIL Q23 at step %0d (posedge): expected %0b got %0b", i, expected_b, B);
                $finish;
            end
        end

        $display("PASS Q23");
        $finish;
    end
endmodule
