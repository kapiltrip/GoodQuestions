`timescale 1ns/1ps
`include "qa/pdf_q03_q06/q04_bitwise_reduction.v"

module pdf_q04_tb;
    reg  [15:0] databus;
    wire all_ones_detected, is_databus_odd, signal_not_zero;

    q04 dut (
        .databus(databus),
        .all_ones_detected(all_ones_detected),
        .is_databus_odd(is_databus_odd),
        .signal_not_zero(signal_not_zero)
    );

    task check;
        input [15:0] v;
        begin
            databus = v;
            #1;
            if (all_ones_detected !== (&v)) begin $display("FAIL Q04 all_ones v=%h", v); $finish; end
            if (is_databus_odd    !== (^v)) begin $display("FAIL Q04 odd v=%h", v);      $finish; end
            if (signal_not_zero   !== (|v)) begin $display("FAIL Q04 nonzero v=%h", v);  $finish; end
        end
    endtask

    initial begin
        check(16'h0000);
        check(16'hFFFF);
        check(16'h0001);
        check(16'h0003);
        check(16'hA55A);
        $display("PASS Q04");
        $finish;
    end
endmodule
