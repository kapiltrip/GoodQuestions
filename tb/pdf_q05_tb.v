`timescale 1ns/1ps
`include "qa/pdf_q03_q06/q05_shift_operations.v"

module pdf_q05_tb;
    reg  [15:0] a;
    wire [15:0] mul_by_4, div_by_8;

    q05 dut (
        .a(a),
        .mul_by_4(mul_by_4),
        .div_by_8(div_by_8)
    );

    task check;
        input [15:0] v;
        begin
            a = v;
            #1;
            if (mul_by_4 !== (v << 2)) begin $display("FAIL Q05 mul v=%h", v); $finish; end
            if (div_by_8 !== (v >> 3)) begin $display("FAIL Q05 div v=%h", v); $finish; end
        end
    endtask

    initial begin
        check(16'h0000);
        check(16'h0001);
        check(16'h0008);
        check(16'h00F0);
        check(16'h8001);
        $display("PASS Q05");
        $finish;
    end
endmodule
