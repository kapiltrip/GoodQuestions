`timescale 1ns/1ps
`include "qa/pdf_q03_q06/q03_logic_gates.v"

module pdf_q03_tb;
    reg a, b;
    wire and_y, or_y, xor_y, nand_y, nor_y, xnor_y;
    integer i;

    q03 dut (
        .a(a), .b(b),
        .and_y(and_y), .or_y(or_y), .xor_y(xor_y),
        .nand_y(nand_y), .nor_y(nor_y), .xnor_y(xnor_y)
    );

    initial begin
        for (i = 0; i < 4; i = i + 1) begin
            {a, b} = i[1:0];
            #1;
            if (and_y  !== (a & b))  begin $display("FAIL Q03 and");  $finish; end
            if (or_y   !== (a | b))  begin $display("FAIL Q03 or");   $finish; end
            if (xor_y  !== (a ^ b))  begin $display("FAIL Q03 xor");  $finish; end
            if (nand_y !== ~(a & b)) begin $display("FAIL Q03 nand"); $finish; end
            if (nor_y  !== ~(a | b)) begin $display("FAIL Q03 nor");  $finish; end
            if (xnor_y !== ~(a ^ b)) begin $display("FAIL Q03 xnor"); $finish; end
        end
        $display("PASS Q03");
        $finish;
    end
endmodule
