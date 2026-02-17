`timescale 1ns/1ps
`include "qa/q06_detect/detect.v"

module q06_detect_tb;
// 1) Testbench signals: drive DUT inputs and observe DUT output.
reg clk;
reg rst_n;
reg din;
wire match;

// 2) DUT instantiation: connects TB signals to detect module ports.
detect dut(
    .clk(clk),
    .rst_n(rst_n),
    .din(din),
    .match(match)
);

// 3) Clock generation: 10ns period.
initial clk = 0;
always #5 clk = ~clk;

// 4) Task = reusable stimulus block for one serial bit.
//    Sets din, waits one clock, then prints current result.
task sendbit;
    input b;
    begin
        // Put input before the sampling edge so DUT sees a stable value at posedge.
        din = b;
        // Wait for DUT sampling edge.
        @(posedge clk);
        // Small post-edge wait to avoid race while observing updated outputs.
        #1;
        $display("t=%0t din=%0b match=%0b", $time, din, match);
    end
endtask

// 5) Main stimulus sequence:
//    - hold reset
//    - release reset
//    - send two copies of 10110 and observe match pulse
// Note: No function is used in this TB; task is enough for simple driving.
initial begin
    rst_n = 0;
    din = 0;

    repeat (2) @(posedge clk);
    rst_n = 1;

    sendbit(1); sendbit(0); sendbit(1); sendbit(1); sendbit(0); // 10110
    sendbit(1); sendbit(0); sendbit(1); sendbit(1); sendbit(0); // 10110 again

    $finish;
end

endmodule
