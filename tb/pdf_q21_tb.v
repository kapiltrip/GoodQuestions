`timescale 1ns/1ps
`include "qa/pdf_q21/q21_max_and_second_max_onecmp.v"

module pdf_q21_tb;
    reg clk;
    reg rst;
    reg clear;
    reg in_valid;
    reg [7:0] in_data;
    wire in_ready;
    wire [7:0] max1;
    wire [7:0] max2;
    wire max1_valid;
    wire max2_valid;

    reg [7:0] exp_max1;
    reg [7:0] exp_max2;
    reg exp_max1_valid;
    reg exp_max2_valid;

    q21_max_and_second_max_onecmp #(.WIDTH(8)) dut (
        .clk(clk),
        .rst(rst),
        .clear(clear),
        .in_valid(in_valid),
        .in_data(in_data),
        .in_ready(in_ready),
        .max1(max1),
        .max2(max2),
        .max1_valid(max1_valid),
        .max2_valid(max2_valid)
    );

    always #5 clk = ~clk;

    task update_expected;
        input [7:0] s;
        begin
            if (!exp_max1_valid) begin
                exp_max1 = s;
                exp_max1_valid = 1'b1;
            end else if (s >= exp_max1) begin
                exp_max2 = exp_max1;
                exp_max2_valid = exp_max1_valid;
                exp_max1 = s;
                exp_max1_valid = 1'b1;
            end else if (!exp_max2_valid || s >= exp_max2) begin
                exp_max2 = s;
                exp_max2_valid = 1'b1;
            end
        end
    endtask

    task send_sample;
        input [7:0] s;
        begin
            while (in_ready !== 1'b1) @(posedge clk);

            @(negedge clk);
            in_data = s;
            in_valid = 1'b1;
            update_expected(s);

            @(posedge clk);
            #1;
            in_valid = 1'b0;

            while (in_ready !== 1'b1) @(posedge clk);
            #1;

            if (max1_valid !== exp_max1_valid || max2_valid !== exp_max2_valid ||
                max1 !== exp_max1 || max2 !== exp_max2) begin
                $display("FAIL Q21: sample=%0d exp(max1,max2,v1,v2)=(%0d,%0d,%0b,%0b) got=(%0d,%0d,%0b,%0b)",
                         s, exp_max1, exp_max2, exp_max1_valid, exp_max2_valid,
                         max1, max2, max1_valid, max2_valid);
                $finish;
            end
        end
    endtask

    initial begin
        clk = 1'b0;
        rst = 1'b1;
        clear = 1'b0;
        in_valid = 1'b0;
        in_data = 8'd0;
        exp_max1 = 8'd0;
        exp_max2 = 8'd0;
        exp_max1_valid = 1'b0;
        exp_max2_valid = 1'b0;

        repeat (2) @(posedge clk);
        rst = 1'b0;
        #1;

        send_sample(8'd8);
        send_sample(8'd3);
        send_sample(8'd15);
        send_sample(8'd15);
        send_sample(8'd2);
        send_sample(8'd9);

        @(negedge clk) clear = 1'b1;
        @(posedge clk);
        #1;
        clear = 1'b0;
        exp_max1 = 8'd0;
        exp_max2 = 8'd0;
        exp_max1_valid = 1'b0;
        exp_max2_valid = 1'b0;

        if (max1_valid !== 1'b0 || max2_valid !== 1'b0 || in_ready !== 1'b1) begin
            $display("FAIL Q21: clear did not reset outputs");
            $finish;
        end

        $display("PASS Q21");
        $finish;
    end
endmodule
