`timescale 1ns/1ps
`include "qa/pdf_q25_q26/q25_clock_div2.v"

module pdf_q25_tb;
    reg clk;
    reg rst_n;
    wire q;

    integer i;
    reg prev_q;

    q25_clock_div2 dut (
        .clk(clk),
        .rst_n(rst_n),
        .q(q)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        prev_q = 1'b0;

        repeat (2) @(posedge clk);
        rst_n = 1'b1;
        @(posedge clk);
        #1;
        prev_q = q;

        for (i = 0; i < 10; i = i + 1) begin
            @(posedge clk);
            #1;
            if (q === prev_q) begin
                $display("FAIL Q25 at step %0d: q did not toggle", i);
                $finish;
            end
            prev_q = q;
        end

        $display("PASS Q25");
        $finish;
    end
endmodule
