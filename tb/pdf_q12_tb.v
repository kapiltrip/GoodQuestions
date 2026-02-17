`timescale 1ns/1ps
`include "qa/pdf_q12_q18/q12_one_cycle_pulse_detect.v"

module pdf_q12_tb;
    reg clk;
    reg rst;
    reg d;
    wire pulse_high;

    q12 dut (
        .clk(clk),
        .rst(rst),
        .d(d),
        .pulse_high(pulse_high)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        rst = 1'b1;
        d = 1'b0;

        repeat (2) @(posedge clk);
        rst = 1'b0;

        // 1-cycle high pulse on d should be detected.
        @(negedge clk) d = 1'b1;
        @(negedge clk) d = 1'b0;
        #1;
        if (pulse_high !== 1'b1) begin
            $display("FAIL Q12: expected pulse for 1-cycle input high");
            $finish;
        end
        @(posedge clk);
        #1;
        if (pulse_high !== 1'b0) begin
            $display("FAIL Q12: pulse should clear after one cycle");
            $finish;
        end

        // 2-cycle high on d should not trigger one-cycle detector.
        @(negedge clk) d = 1'b1;
        @(posedge clk);
        @(negedge clk) d = 1'b1;
        @(posedge clk);
        @(negedge clk) d = 1'b0;
        #1;
        if (pulse_high !== 1'b0) begin
            $display("FAIL Q12: false pulse on 2-cycle input high");
            $finish;
        end

        $display("PASS Q12");
        $finish;
    end
endmodule
