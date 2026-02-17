`timescale 1ns/1ps
`include "qa/q07_start_and_chipselects/start_and_chipselects.v"

module q07_start_and_chipselects_tb;
reg clk;
reg rst_n;
wire start;
wire CS1;
wire CS2;
wire CS3;

start_and_chipselects dut(
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .CS1(CS1),
    .CS2(CS2),
    .CS3(CS3)
);

initial clk = 0;
always #5 clk = ~clk;

integer cyc;
integer start_count;
integer cs_count;
integer phase;

initial begin
    rst_n = 0;
    start_count = 0;
    cs_count = 0;
    phase = 0;

    repeat (2) @(posedge clk);
    rst_n = 1;

    for (cyc = 0; cyc < 18; cyc = cyc + 1) begin
        @(posedge clk);
        #1;

        if (start) start_count = start_count + 1;

        if ((CS1 + CS2 + CS3) > 1) begin
            $display("FAIL Q07 multiple CS high t=%0t", $time);
            $finish;
        end

        if (CS1 || CS2 || CS3) begin
            cs_count = cs_count + 1;

            if (phase == 0 && !CS1) begin
                $display("FAIL Q07 expected CS1 t=%0t", $time);
                $finish;
            end
            if (phase == 1 && !CS2) begin
                $display("FAIL Q07 expected CS2 t=%0t", $time);
                $finish;
            end
            if (phase == 2 && !CS3) begin
                $display("FAIL Q07 expected CS3 t=%0t", $time);
                $finish;
            end

            phase = (phase == 2) ? 0 : phase + 1;
        end

        $display("t=%0t start=%0b CS1=%0b CS2=%0b CS3=%0b", $time, start, CS1, CS2, CS3);
    end

    if (start_count != 6) begin
        $display("FAIL Q07 start_count exp=6 got=%0d", start_count);
        $finish;
    end

    if (cs_count != 6) begin
        $display("FAIL Q07 cs_count exp=6 got=%0d", cs_count);
        $finish;
    end

    $display("PASS Q07 start_and_chipselects");
    $finish;
end

endmodule
