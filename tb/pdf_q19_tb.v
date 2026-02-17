`timescale 1ns/1ps
`include "qa/pdf_q19_q20/q19_divisible_by3_fsm.v"

module pdf_q19_tb;
    reg clk;
    reg rst;
    reg bit_in;
    wire div_by_3;

    integer i;
    integer remainder_ref;
    reg [11:0] seq_bits;
    reg expected_div;

    q19_divisible_by3_fsm dut (
        .clk(clk),
        .rst(rst),
        .bit_in(bit_in),
        .div_by_3(div_by_3)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        rst = 1'b1;
        bit_in = 1'b0;
        remainder_ref = 0;
        seq_bits = 12'b110010101011;

        repeat (2) @(posedge clk);
        rst = 1'b0;
        #1;
        if (div_by_3 !== 1'b1) begin
            $display("FAIL Q19: reset state should be divisible");
            $finish;
        end

        for (i = 11; i >= 0; i = i - 1) begin
            @(negedge clk) bit_in = seq_bits[i];
            @(posedge clk);
            remainder_ref = (remainder_ref * 2 + bit_in) % 3;
            expected_div = (remainder_ref == 0);
            #1;
            if (div_by_3 !== expected_div) begin
                $display("FAIL Q19 at step %0d: expected %0b got %0b", i, expected_div, div_by_3);
                $finish;
            end
        end

        $display("PASS Q19");
        $finish;
    end
endmodule
