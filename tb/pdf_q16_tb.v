`timescale 1ns/1ps
`include "qa/pdf_q12_q18/q16_sync_debounce_onepulse.v"

module pdf_q16_tb;
    reg clk;
    reg rst;
    reg async_in;
    wire pulse;

    integer i;
    reg [11:0] seq_bits;
    reg ref_q1;
    reg ref_q2;
    reg ref_d1;
    reg ref_d2;
    reg ref_pulse;
    reg next_q1;
    reg next_q2;
    reg next_d1;
    reg next_d2;

    q16_sync_debounce_onepulse dut (
        .clk(clk),
        .rst(rst),
        .async_in(async_in),
        .pulse(pulse)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        rst = 1'b1;
        async_in = 1'b0;
        ref_q1 = 1'b0;
        ref_q2 = 1'b0;
        ref_d1 = 1'b0;
        ref_d2 = 1'b0;
        seq_bits = 12'b001111001110; // includes bounce-like changes

        repeat (2) @(posedge clk);
        rst = 1'b0;

        for (i = 11; i >= 0; i = i - 1) begin
            @(negedge clk) async_in = seq_bits[i];
            @(posedge clk);

            next_q1 = async_in;
            next_q2 = ref_q1;
            next_d1 = ref_q2;
            next_d2 = ref_d1;

            ref_q1 = next_q1;
            ref_q2 = next_q2;
            ref_d1 = next_d1;
            ref_d2 = next_d2;

            ref_pulse = (ref_q2 & ref_d1) & (~ref_d2);
            #1;
            if (pulse !== ref_pulse) begin
                $display("FAIL Q16 at step %0d: expected %0b got %0b", i, ref_pulse, pulse);
                $finish;
            end
        end

        $display("PASS Q16");
        $finish;
    end
endmodule
