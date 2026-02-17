`timescale 1ns/1ps
`include "qa/pdf_q07_q11/q07_mux4_styles.v"

module pdf_q07_tb;
    reg a, b, c, d;
    reg [1:0] sel;
    wire y_a, y_b, y_c;
    reg exp;
    integer i;

    q07_a dut_a (.a(a), .b(b), .c(c), .d(d), .sel(sel), .y(y_a));
    q07_b dut_b (.a(a), .b(b), .c(c), .d(d), .sel(sel), .y(y_b));
    q07_c dut_c (.a(a), .b(b), .c(c), .d(d), .sel(sel), .y(y_c));

    initial begin
        for (i = 0; i < 64; i = i + 1) begin
            {a, b, c, d, sel} = i[5:0];
            #1;
            case (sel)
                2'b00: exp = a;
                2'b01: exp = b;
                2'b10: exp = c;
                default: exp = d;
            endcase

            if (y_a !== exp) begin $display("FAIL Q07 A i=%0d", i); $finish; end
            if (y_b !== exp) begin $display("FAIL Q07 B i=%0d", i); $finish; end
            if (y_c !== exp) begin $display("FAIL Q07 C i=%0d", i); $finish; end
        end
        $display("PASS Q07");
        $finish;
    end
endmodule
