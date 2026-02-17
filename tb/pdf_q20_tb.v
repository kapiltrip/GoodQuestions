`timescale 1ns/1ps
`include "qa/pdf_q19_q20/q20_fibonacci_enable.v"

module pdf_q20_tb;
    reg clk;
    reg rst_n;
    reg enable;
    wire [15:0] sum;
    wire [15:0] cur_num;
    wire [15:0] next_num;

    integer i;
    reg [15:0] exp_cur;
    reg [15:0] exp_next;
    reg [15:0] exp_sum;

    q20_fibonacci_enable #(.WIDTH(16)) dut (
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),
        .sum(sum),
        .cur_num(cur_num),
        .next_num(next_num)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        enable = 1'b0;
        exp_cur = 16'd0;
        exp_next = 16'd1;

        repeat (2) @(posedge clk);
        rst_n = 1'b1;
        #1;

        if (cur_num !== 16'd0 || next_num !== 16'd1 || sum !== 16'd1) begin
            $display("FAIL Q20: reset values mismatch");
            $finish;
        end

        for (i = 0; i < 6; i = i + 1) begin
            @(negedge clk) enable = 1'b1;
            @(posedge clk);
            exp_sum = exp_cur + exp_next;
            exp_cur = exp_next;
            exp_next = exp_sum;
            #1;
            if (cur_num !== exp_cur || next_num !== exp_next) begin
                $display("FAIL Q20 at step %0d: expected cur=%0d next=%0d, got cur=%0d next=%0d",
                         i, exp_cur, exp_next, cur_num, next_num);
                $finish;
            end
        end

        @(negedge clk) enable = 1'b0;
        repeat (2) begin
            @(posedge clk);
            #1;
            if (cur_num !== exp_cur || next_num !== exp_next) begin
                $display("FAIL Q20: values changed while enable=0");
                $finish;
            end
        end

        $display("PASS Q20");
        $finish;
    end
endmodule
