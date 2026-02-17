`timescale 1ns/1ps
`include "qa/q05_seq_10110/seq_10110_fsms.v"

module q05_seq_10110_tb;
    reg clk, rst_n, x;

    wire y_mealy_ov;
    wire y_mealy_non;
    wire y_moore_ov;
    wire y_moore_non;

    seq_10110_mealy_overlap dut_mealy_ov (
        .clk(clk),
        .rst_n(rst_n),
        .x(x),
        .y(y_mealy_ov)
    );

    seq_10110_mealy_nonoverlap dut_mealy_non (
        .clk(clk),
        .rst_n(rst_n),
        .x(x),
        .y(y_mealy_non)
    );

    seq_10110_moore_overlap dut_moore_ov (
        .clk(clk),
        .rst_n(rst_n),
        .x(x),
        .y(y_moore_ov)
    );

    seq_10110_moore_nonoverlap dut_moore_non (
        .clk(clk),
        .rst_n(rst_n),
        .x(x),
        .y(y_moore_non)
    );

    localparam S0 = 3'd0;
    localparam S1 = 3'd1;
    localparam S2 = 3'd2;
    localparam S3 = 3'd3;
    localparam S4 = 3'd4;
    localparam S5 = 3'd5;

    reg [2:0] ref_mealy_ov;
    reg [2:0] ref_mealy_non;
    reg [2:0] ref_moore_ov;
    reg [2:0] ref_moore_non;

    integer i;
    reg [23:0] bits;

    initial clk = 1'b0;
    always #5 clk = ~clk;

    function [2:0] next_mealy_ov;
        input [2:0] st;
        input bit_in;
        begin
            case (st)
                S0: next_mealy_ov = (bit_in ? S1 : S0);
                S1: next_mealy_ov = (bit_in ? S1 : S2);
                S2: next_mealy_ov = (bit_in ? S3 : S0);
                S3: next_mealy_ov = (bit_in ? S4 : S2);
                S4: next_mealy_ov = (bit_in ? S1 : S2);
                default: next_mealy_ov = S0;
            endcase
        end
    endfunction

    function [2:0] next_mealy_non;
        input [2:0] st;
        input bit_in;
        begin
            case (st)
                S0: next_mealy_non = (bit_in ? S1 : S0);
                S1: next_mealy_non = (bit_in ? S1 : S2);
                S2: next_mealy_non = (bit_in ? S3 : S0);
                S3: next_mealy_non = (bit_in ? S4 : S2);
                S4: next_mealy_non = (bit_in ? S1 : S0);
                default: next_mealy_non = S0;
            endcase
        end
    endfunction

    function [2:0] next_moore_ov;
        input [2:0] st;
        input bit_in;
        begin
            case (st)
                S0: next_moore_ov = (bit_in ? S1 : S0);
                S1: next_moore_ov = (bit_in ? S1 : S2);
                S2: next_moore_ov = (bit_in ? S3 : S0);
                S3: next_moore_ov = (bit_in ? S4 : S2);
                S4: next_moore_ov = (bit_in ? S1 : S5);
                S5: next_moore_ov = (bit_in ? S3 : S0);
                default: next_moore_ov = S0;
            endcase
        end
    endfunction

    function [2:0] next_moore_non;
        input [2:0] st;
        input bit_in;
        begin
            case (st)
                S0: next_moore_non = (bit_in ? S1 : S0);
                S1: next_moore_non = (bit_in ? S1 : S2);
                S2: next_moore_non = (bit_in ? S3 : S0);
                S3: next_moore_non = (bit_in ? S4 : S2);
                S4: next_moore_non = (bit_in ? S1 : S5);
                S5: next_moore_non = (bit_in ? S1 : S0);
                default: next_moore_non = S0;
            endcase
        end
    endfunction

    task drive_bit;
        input bit_in;
        reg exp_mealy_ov;
        reg exp_mealy_non;
        begin
            @(negedge clk);
            x = bit_in;
            #1;

            exp_mealy_ov = (ref_mealy_ov == S4) && (bit_in == 1'b0);
            exp_mealy_non = (ref_mealy_non == S4) && (bit_in == 1'b0);

            if (y_mealy_ov !== exp_mealy_ov) begin
                $display("FAIL Q05 mealy overlap bit=%0b exp=%0b got=%0b", bit_in, exp_mealy_ov, y_mealy_ov);
                $finish;
            end
            if (y_mealy_non !== exp_mealy_non) begin
                $display("FAIL Q05 mealy nonoverlap bit=%0b exp=%0b got=%0b", bit_in, exp_mealy_non, y_mealy_non);
                $finish;
            end

            ref_mealy_ov = next_mealy_ov(ref_mealy_ov, bit_in);
            ref_mealy_non = next_mealy_non(ref_mealy_non, bit_in);
            ref_moore_ov = next_moore_ov(ref_moore_ov, bit_in);
            ref_moore_non = next_moore_non(ref_moore_non, bit_in);

            @(posedge clk);
            #1;

            if (y_moore_ov !== (ref_moore_ov == S5)) begin
                $display("FAIL Q05 moore overlap bit=%0b exp=%0b got=%0b", bit_in, (ref_moore_ov == S5), y_moore_ov);
                $finish;
            end
            if (y_moore_non !== (ref_moore_non == S5)) begin
                $display("FAIL Q05 moore nonoverlap bit=%0b exp=%0b got=%0b", bit_in, (ref_moore_non == S5), y_moore_non);
                $finish;
            end
        end
    endtask

    initial begin
        rst_n = 1'b0;
        x = 1'b0;

        ref_mealy_ov = S0;
        ref_mealy_non = S0;
        ref_moore_ov = S0;
        ref_moore_non = S0;

        repeat (2) @(posedge clk);
        #1;
        if (y_mealy_ov !== 1'b0 || y_mealy_non !== 1'b0 || y_moore_ov !== 1'b0 || y_moore_non !== 1'b0) begin
            $display("FAIL Q05 outputs must be low during reset");
            $finish;
        end

        rst_n = 1'b1;

        // Explicit overlap-sensitive sequence: 10110110
        bits = 24'b000000000000000010110110;
        for (i = 7; i >= 0; i = i - 1) begin
            drive_bit(bits[i]);
        end

        // Additional mixed sequence to exercise self-loops and repeated matches.
        bits = 24'b101101011001011011010110;
        for (i = 23; i >= 0; i = i - 1) begin
            drive_bit(bits[i]);
        end

        $display("PASS Q05 seq_10110 all FSM variants");
        $finish;
    end
endmodule
