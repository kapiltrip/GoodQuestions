`timescale 1ns/1ps
`include "qa/pdf_q25_q26/q26_clock_div3_duty50.v"

module pdf_q26_tb;
    reg clk;
    reg rst_n;
    wire clk_div3_33;
    wire clk_div3_50;
    wire clk_div3_66;
    wire clk_div3_100;

    integer counter;
    integer rise_count;
    integer last_rise_cycle;
    integer high33;
    integer high50;
    integer high66;
    integer high100;
    integer i;

    q26_clock_div3_duty50 #(.DUTY_CYCLE(33)) dut_33 (
        .clk(clk),
        .rst_n(rst_n),
        .clk_div3(clk_div3_33)
    );

    q26_clock_div3_duty50 #(.DUTY_CYCLE(50)) dut_50 (
        .clk(clk),
        .rst_n(rst_n),
        .clk_div3(clk_div3_50)
    );

    q26_clock_div3_duty50 #(.DUTY_CYCLE(66)) dut_66 (
        .clk(clk),
        .rst_n(rst_n),
        .clk_div3(clk_div3_66)
    );

    q26_clock_div3_duty50 #(.DUTY_CYCLE(100)) dut_100 (
        .clk(clk),
        .rst_n(rst_n),
        .clk_div3(clk_div3_100)
    );

    always #5 clk = ~clk;

    always @(posedge clk) begin
        if (!rst_n)
            counter <= 0;
        else
            counter <= counter + 1;
    end

    always @(posedge clk_div3_50) begin
        if (rst_n) begin
            if (rise_count > 0) begin
                if ((counter - last_rise_cycle) !== 3) begin
                    $display("FAIL Q26: rising-edge spacing expected 3 cycles, got %0d",
                             (counter - last_rise_cycle));
                    $finish;
                end
            end
            last_rise_cycle <= counter;
            rise_count <= rise_count + 1;
        end
    end

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        counter = 0;
        rise_count = 0;
        last_rise_cycle = 0;
        high33 = 0;
        high50 = 0;
        high66 = 0;
        high100 = 0;

        repeat (2) @(posedge clk);
        rst_n = 1'b1;

        repeat (6) @(posedge clk);

        for (i = 0; i < 3; i = i + 1) begin
            @(posedge clk);
            #1;
            high33 = high33 + clk_div3_33;
            high50 = high50 + clk_div3_50;
            high66 = high66 + clk_div3_66;
            high100 = high100 + clk_div3_100;

            @(negedge clk);
            #1;
            high33 = high33 + clk_div3_33;
            high50 = high50 + clk_div3_50;
            high66 = high66 + clk_div3_66;
            high100 = high100 + clk_div3_100;
        end

        if (high33 !== 2 || high50 !== 3 || high66 !== 4 || high100 !== 6) begin
            $display("FAIL Q26: duty counts 33=%0d 50=%0d 66=%0d 100=%0d",
                     high33, high50, high66, high100);
            $finish;
        end

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
