`timescale 1ns/1ps
`include "qa/pdf_q27/q27_clock_div_n.v"

module pdf_q27_tb;
    reg clk;
    reg rst_n;
    wire clk_div;

    integer clk_cycles;
    integer rise_count;
    integer last_rise_cycle;

    clk_div_n #(
        .N(5)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .clk_div(clk_div)
    );

    always #5 clk = ~clk;

    always @(posedge clk) begin
        if (!rst_n)
            clk_cycles <= 0;
        else
            clk_cycles <= clk_cycles + 1;
    end

    always @(posedge clk_div) begin
        if (rst_n) begin
            if (rise_count > 0) begin
                if ((clk_cycles - last_rise_cycle) !== 5) begin
                    $display("FAIL Q27: expected /5 rising-edge spacing, got %0d",
                             (clk_cycles - last_rise_cycle));
                    $finish;
                end
            end
            last_rise_cycle <= clk_cycles;
            rise_count <= rise_count + 1;
        end
    end

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        clk_cycles = 0;
        rise_count = 0;
        last_rise_cycle = 0;

        repeat (2) @(posedge clk);
        rst_n = 1'b1;

        repeat (120) begin
            @(posedge clk);
            if (rise_count >= 4) begin
                $display("PASS Q27");
                $finish;
            end
        end

        $display("FAIL Q27: timeout waiting for enough clk_div edges");
        $finish;
    end
endmodule
