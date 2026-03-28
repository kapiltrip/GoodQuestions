`timescale 1ns/1ps
`include "qa/pdf_q12_q18/q17_gray_counter_methods.v"

module pdf_q17_tb;
    reg clk;
    reg rst;
    reg [3:0] bin_in;
    reg [3:0] gray_in;
    wire [2:0] gray_case;
    wire [3:0] gray_xor;
    wire [3:0] gray_from_bin;
    wire [3:0] bin_from_gray;

    integer i;
    reg [2:0] expected_case;
    reg [2:0] prev_case;
    reg [3:0] prev_gray_xor;
    reg [3:0] diff_xor;

    function [2:0] next_gray3;
        input [2:0] g;
        begin
            case (g)
                3'b000: next_gray3 = 3'b001;
                3'b001: next_gray3 = 3'b011;
                3'b011: next_gray3 = 3'b010;
                3'b010: next_gray3 = 3'b110;
                3'b110: next_gray3 = 3'b111;
                3'b111: next_gray3 = 3'b101;
                3'b101: next_gray3 = 3'b100;
                default: next_gray3 = 3'b000;
            endcase
        end
    endfunction

    q17_gray_counter_case_3bit dut_case (
        .clk(clk),
        .rst(rst),
        .gray(gray_case)
    );

    q17_gray_counter_xor #(.N(4)) dut_xor (
        .clk(clk),
        .rst(rst),
        .gray(gray_xor)
    );

    q17_bin_to_gray #(.N(4)) dut_bin_to_gray (
        .bin(bin_in),
        .gray(gray_from_bin)
    );

    q17_gray_to_bin #(.N(4)) dut_gray_to_bin (
        .gray(gray_in),
        .bin(bin_from_gray)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        rst = 1'b1;
        bin_in = 4'b0000;
        gray_in = 4'b0000;

        for (i = 0; i < 16; i = i + 1) begin
            bin_in = i[3:0];
            gray_in = i[3:0] ^ (i[3:0] >> 1);
            #1;

            if (gray_from_bin !== (i[3:0] ^ (i[3:0] >> 1))) begin
                $display("FAIL Q17 bin->gray for bin=%0b got=%0b", i[3:0], gray_from_bin);
                $finish;
            end

            if (bin_from_gray !== i[3:0]) begin
                $display("FAIL Q17 gray->bin for gray=%0b got=%0b expected=%0b",
                         gray_in, bin_from_gray, i[3:0]);
                $finish;
            end
        end

        repeat (2) @(posedge clk);
        rst = 1'b0;
        @(posedge clk);
        #1;
        prev_gray_xor = gray_xor;
        prev_case = gray_case;

        for (i = 0; i < 16; i = i + 1) begin
            @(posedge clk);
            #1;

            expected_case = next_gray3(prev_case);
            if (gray_case !== expected_case) begin
                $display("FAIL Q17 case at step %0d: expected next %0b got %0b", i, expected_case, gray_case);
                $finish;
            end
            prev_case = gray_case;

            diff_xor = gray_xor ^ prev_gray_xor;
            if ((diff_xor == 4'b0000) || ((diff_xor & (diff_xor - 1'b1)) != 4'b0000)) begin
                $display("FAIL Q17 xor at step %0d: gray transition not one-bit", i);
                $finish;
            end
            prev_gray_xor = gray_xor;
        end

        $display("PASS Q17");
        $finish;
    end
endmodule
