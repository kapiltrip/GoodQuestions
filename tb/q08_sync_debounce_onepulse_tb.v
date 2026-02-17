`timescale 1ns/1ps
`include "qa/q08_sync_debounce_onepulse/sync_debounce_onepulse.v"

module q08_sync_debounce_onepulse_tb;
reg clk;
reg rst_n;
reg async_in;
wire pulse;

sync_debounce_onepulse dut(
    .clk(clk),
    .rst_n(rst_n),
    .async_in(async_in),
    .pulse(pulse)
);

initial clk = 0;
always #5 clk = ~clk;

task step;
    begin
        @(posedge clk);
        #1;
    end
endtask

integer i;
integer phase_pulses;
integer total_pulses;

initial begin
    rst_n = 0;
    async_in = 0;
    total_pulses = 0;

    repeat (2) step();
    if (pulse !== 1'b0) begin
        $display("FAIL Q08 pulse during reset");
        $finish;
    end

    rst_n = 1;

    phase_pulses = 0;
    repeat (4) begin
        step();
        if (pulse) phase_pulses = phase_pulses + 1;
    end
    if (phase_pulses != 0) begin
        $display("FAIL Q08 idle low produced pulse");
        $finish;
    end

    @(negedge clk);
    async_in = 1'b1;
    step();
    @(negedge clk);
    async_in = 1'b0;

    phase_pulses = 0;
    repeat (8) begin
        step();
        if (pulse) phase_pulses = phase_pulses + 1;
    end
    if (phase_pulses != 0) begin
        $display("FAIL Q08 short glitch should be rejected");
        $finish;
    end

    @(negedge clk);
    async_in = 1'b1;

    phase_pulses = 0;
    repeat (10) begin
        step();
        if (pulse) begin
            phase_pulses = phase_pulses + 1;
            total_pulses = total_pulses + 1;
        end
    end
    if (phase_pulses != 1) begin
        $display("FAIL Q08 first valid high should create exactly one pulse, got=%0d", phase_pulses);
        $finish;
    end

    @(negedge clk);
    async_in = 1'b0;
    repeat (5) step();

    @(negedge clk);
    async_in = 1'b1;

    phase_pulses = 0;
    repeat (10) begin
        step();
        if (pulse) begin
            phase_pulses = phase_pulses + 1;
            total_pulses = total_pulses + 1;
        end
    end
    if (phase_pulses != 1) begin
        $display("FAIL Q08 second valid high should create exactly one pulse, got=%0d", phase_pulses);
        $finish;
    end

    if (total_pulses != 2) begin
        $display("FAIL Q08 total pulses expected 2 got=%0d", total_pulses);
        $finish;
    end

    $display("PASS Q08 sync_debounce_onepulse");
    $finish;
end

endmodule
