`timescale 1ns/1ps
`include "qa/pdf_q03_q06/q06_sign_extension.v"

module pdf_q06_tb;
    reg  [4:0] a;
    wire [9:0] c;

    q06 dut (
        .a(a),
        .c(c)
    );

    task check;
        input [4:0] v;
        reg   [9:0] exp;
        begin
            a = v;
            exp = {{5{v[4]}}, v};
            #1;
            if (c !== exp) begin
                $display("FAIL Q06 a=%b exp=%b got=%b", v, exp, c);
                $finish;
            end
        end
    endtask

    initial begin
        check(5'b00000);
        check(5'b00101);
        check(5'b01111);
        check(5'b10000);
        check(5'b10101);
        $display("PASS Q06");
        $finish;
    end
endmodule
