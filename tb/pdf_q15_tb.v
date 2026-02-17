`timescale 1ns/1ps
`include "qa/pdf_q12_q18/q15_start_and_chipselects.v"

module pdf_q15_tb;
    reg clk;
    reg rst;
    wire start;
    wire cs1;
    wire cs2;
    wire cs3;

    integer i;
    integer start_count;
    integer cs_count;
    integer phase;

    q15_start_and_chipselects dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .cs1(cs1),
        .cs2(cs2),
        .cs3(cs3)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        rst = 1'b1;
        start_count = 0;
        cs_count = 0;
        phase = 0;

        repeat (2) @(posedge clk);
        rst = 1'b0;

        for (i = 0; i < 18; i = i + 1) begin
            @(posedge clk);
            #1;

            if (start)
                start_count = start_count + 1;

            if ((cs1 + cs2 + cs3) > 1) begin
                $display("FAIL Q15: multiple chip-selects high");
                $finish;
            end

            if (cs1 || cs2 || cs3) begin
                cs_count = cs_count + 1;
                if (phase == 0 && !cs1) begin
                    $display("FAIL Q15: expected cs1");
                    $finish;
                end
                if (phase == 1 && !cs2) begin
                    $display("FAIL Q15: expected cs2");
                    $finish;
                end
                if (phase == 2 && !cs3) begin
                    $display("FAIL Q15: expected cs3");
                    $finish;
                end
                phase = (phase == 2) ? 0 : phase + 1;
            end
        end

        if (start_count !== 6) begin
            $display("FAIL Q15: expected 6 start pulses, got %0d", start_count);
            $finish;
        end

        if (cs_count !== 6) begin
            $display("FAIL Q15: expected 6 CS pulses, got %0d", cs_count);
            $finish;
        end

        $display("PASS Q15");
        $finish;
    end
endmodule
