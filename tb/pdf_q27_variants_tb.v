`timescale 1ns/1ps
`include "qa/pdf_q27/q27_clock_divider_variants.v"

module pdf_q27_variants_tb;
    reg clk;
    reg rst_n;
    reg enable;
    wire clk_div2;
    wire clk_div4;
    wire clk_div8;
    wire clk_div3;
    wire tick;

    integer cycle_count;

    integer rise2;
    integer rise4;
    integer rise8;
    integer rise3;
    integer tick_count;

    integer last2;
    integer last4;
    integer last8;
    integer last3;
    integer last_tick;

    q27_div2_toggle dut2 (.clk(clk), .rst_n(rst_n), .clk_div2(clk_div2));
    q27_div4_counter dut4 (.clk(clk), .rst_n(rst_n), .clk_div4(clk_div4));
    q27_div8_counter dut8 (.clk(clk), .rst_n(rst_n), .clk_div8(clk_div8));
    q27_div3_duty50 dut3 (.clk(clk), .rst_n(rst_n), .clk_div3(clk_div3));
    q27_divn_tick #(.DIV_N(5)) dut_tick (.clk(clk), .rst_n(rst_n), .enable(enable), .tick(tick));

    always #5 clk = ~clk;

    always @(posedge clk) begin
        if (!rst_n)
            cycle_count <= 0;
        else
            cycle_count <= cycle_count + 1;
    end

    always @(posedge clk_div2) begin
        if (rst_n) begin
            if (rise2 > 0 && (cycle_count - last2) !== 2) begin
                $display("FAIL Q27 variants: div2 spacing %0d", cycle_count - last2);
                $finish;
            end
            last2 <= cycle_count;
            rise2 <= rise2 + 1;
        end
    end

    always @(posedge clk_div4) begin
        if (rst_n) begin
            if (rise4 > 0 && (cycle_count - last4) !== 4) begin
                $display("FAIL Q27 variants: div4 spacing %0d", cycle_count - last4);
                $finish;
            end
            last4 <= cycle_count;
            rise4 <= rise4 + 1;
        end
    end

    always @(posedge clk_div8) begin
        if (rst_n) begin
            if (rise8 > 0 && (cycle_count - last8) !== 8) begin
                $display("FAIL Q27 variants: div8 spacing %0d", cycle_count - last8);
                $finish;
            end
            last8 <= cycle_count;
            rise8 <= rise8 + 1;
        end
    end

    always @(posedge clk_div3) begin
        if (rst_n) begin
            if (rise3 > 0 && (cycle_count - last3) !== 3) begin
                $display("FAIL Q27 variants: div3 spacing %0d", cycle_count - last3);
                $finish;
            end
            last3 <= cycle_count;
            rise3 <= rise3 + 1;
        end
    end

    always @(posedge clk) begin
        if (rst_n && tick) begin
            if (tick_count > 0 && (cycle_count - last_tick) !== 5) begin
                $display("FAIL Q27 variants: tick spacing %0d", cycle_count - last_tick);
                $finish;
            end
            last_tick <= cycle_count;
            tick_count <= tick_count + 1;
        end
    end

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        enable = 1'b1;

        cycle_count = 0;
        rise2 = 0;
        rise4 = 0;
        rise8 = 0;
        rise3 = 0;
        tick_count = 0;
        last2 = 0;
        last4 = 0;
        last8 = 0;
        last3 = 0;
        last_tick = 0;

        repeat (2) @(posedge clk);
        rst_n = 1'b1;

        repeat (160) begin
            @(posedge clk);
            if (rise2 >= 5 && rise4 >= 4 && rise8 >= 3 && rise3 >= 5 && tick_count >= 5) begin
                $display("PASS Q27 variants");
                $finish;
            end
        end

        $display("FAIL Q27 variants: timeout");
        $finish;
    end
endmodule
