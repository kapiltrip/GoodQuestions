`timescale 1ns/1ps
`include "qa/q09_gray/gray_blocks.v"

module q09_gray_tb;
localparam N = 4;

reg clk;
reg rst_n;
reg [N-1:0] bin_in;
reg [N-1:0] gray_in;

wire [N-1:0] gray_out_conv;
wire [N-1:0] bin_out_conv;
wire [N-1:0] gray_count;
wire [N-1:0] gray_store;
wire [N-1:0] bin_store;

bin_to_gray #(N) u_bin_to_gray (
    .bin(bin_in),
    .gray(gray_out_conv)
);

gray_to_bin #(N) u_gray_to_bin (
    .gray(gray_in),
    .bin(bin_out_conv)
);

bin_counter_gray_out #(N) u_bin_counter_gray_out (
    .clk(clk),
    .rst_n(rst_n),
    .gray(gray_count)
);

gray_counter_store_gray #(N) u_gray_counter_store_gray (
    .clk(clk),
    .rst_n(rst_n),
    .gray_q(gray_store),
    .bin_q(bin_store)
);

initial clk = 0;
always #5 clk = ~clk;

function [N-1:0] f_bin_to_gray;
    input [N-1:0] b;
    begin
        f_bin_to_gray = b ^ (b >> 1);
    end
endfunction

function [N-1:0] f_gray_to_bin;
    input [N-1:0] g;
    integer k;
    begin
        f_gray_to_bin[N-1] = g[N-1];
        for (k = N-2; k >= 0; k = k - 1)
            f_gray_to_bin[k] = f_gray_to_bin[k+1] ^ g[k];
    end
endfunction

integer i;
reg [N-1:0] exp_bin_ctr;
reg [N-1:0] exp_gray_ctr;

initial begin
    rst_n = 0;
    bin_in = 0;
    gray_in = 0;

    repeat (2) @(posedge clk);
    #1;

    if (gray_count !== 0 || gray_store !== 0 || bin_store !== 0) begin
        $display("FAIL Q09 reset values");
        $finish;
    end

    for (i = 0; i < (1<<N); i = i + 1) begin
        bin_in = i[N-1:0];
        gray_in = f_bin_to_gray(i[N-1:0]);
        #1;
        if (gray_out_conv !== f_bin_to_gray(bin_in)) begin
            $display("FAIL Q09 bin_to_gray i=%0d exp=%b got=%b", i, f_bin_to_gray(bin_in), gray_out_conv);
            $finish;
        end
        if (bin_out_conv !== i[N-1:0]) begin
            $display("FAIL Q09 gray_to_bin i=%0d exp=%b got=%b", i[N-1:0], i[N-1:0], bin_out_conv);
            $finish;
        end
    end

    rst_n = 1;
    exp_bin_ctr = 1;

    for (i = 0; i < 20; i = i + 1) begin
        @(posedge clk);
        #1;
        exp_gray_ctr = f_bin_to_gray(exp_bin_ctr);

        if (gray_count !== exp_gray_ctr) begin
            $display("FAIL Q09 bin_counter_gray_out cyc=%0d exp=%b got=%b", i, exp_gray_ctr, gray_count);
            $finish;
        end

        if (gray_store !== exp_gray_ctr) begin
            $display("FAIL Q09 gray_counter_store_gray gray cyc=%0d exp=%b got=%b", i, exp_gray_ctr, gray_store);
            $finish;
        end

        if (bin_store !== exp_bin_ctr) begin
            $display("FAIL Q09 gray_counter_store_gray bin cyc=%0d exp=%b got=%b", i, exp_bin_ctr, bin_store);
            $finish;
        end

        exp_bin_ctr = exp_bin_ctr + 1'b1;
    end

    $display("PASS Q09 gray modules");
    $finish;
end

endmodule
