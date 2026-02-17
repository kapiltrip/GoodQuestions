`timescale 1ns/1ps
`include "qa/pdf_q25_q26/q26_clock_div3_duty50.v"

module pdf_q26_tb;
    reg clk;
    reg rst_n;
    wire clk_div3;

    integer clk_cycles;
    integer rise_count;
    integer last_rise_cycle;

    q26_clock_div3_duty50 #(.DUTY_MODE(1)) dut (
        .clk(clk),
        .rst_n(rst_n),
        .clk_div3(clk_div3)
    );

    always #5 clk = ~clk;

    always @(posedge clk) begin
        if (!rst_n)
            clk_cycles <= 0;
        else
            clk_cycles <= clk_cycles + 1;
    end

    always @(posedge clk_div3) begin
        if (rst_n) begin
            if (rise_count > 0) begin
                if ((clk_cycles - last_rise_cycle) !== 3) begin
                    $display("FAIL Q26: rising-edge spacing expected 3 cycles, got %0d",
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

        repeat (80) begin
            @(posedge clk);
            if (rise_count >= 4) begin
                $display("PASS Q26");
                $finish;
            end
        end

        $display("FAIL Q26: timeout waiting for enough clk_div3 edges");
        $finish;
    end
endmodule
