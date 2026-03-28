module q14_last5_detect_10110 (
    input  wire clk,
    input  wire rst,
    input  wire din,
    output wire match
);
    reg [4:0] window;

    always @(posedge clk or posedge rst) begin
        if (rst)
            window <= 5'b00000;
        else
            window <= {window[3:0], din};
    end

    // High whenever the most recent 5 sampled bits are 10110.
    assign match = (window == 5'b10110);
endmodule


`timescale 1ns/1ps

module tb_q14_last5_detect_10110;
    reg clk;
    reg rst;
    reg din;

    wire match;

    reg [4:0] expected_window;
    reg       expected_match;

    q14_last5_detect_10110 dut (
        .clk(clk),
        .rst(rst),
        .din(din),
        .match(match)
    );

    always #5 clk = ~clk;

    task send_bit;
        input bit_in;
        begin
            @(negedge clk);
            din = bit_in;

            @(posedge clk);
            #1;

            expected_window = {expected_window[3:0], bit_in};
            expected_match  = (expected_window == 5'b10110);

            if (match !== expected_match) begin
                $display("FAIL: din=%b expected_window=%b expected_match=%b match=%b",
                         bit_in, expected_window, expected_match, match);
                $stop;
            end

            $display("din=%b window=%b match=%b",
                     bit_in, expected_window, match);
        end
    endtask

    initial begin
        clk = 1'b0;
        rst = 1'b1;
        din = 1'b0;
        expected_window = 5'b00000;
        expected_match  = 1'b0;

        repeat (2) @(posedge clk);
        rst = 1'b0;

        // Sequence contains 10110 once.
        send_bit(1'b1);
        send_bit(1'b0);
        send_bit(1'b1);
        send_bit(1'b1);
        send_bit(1'b0);

        // Extra bits to show match clears and can detect again.
        send_bit(1'b0);
        send_bit(1'b1);
        send_bit(1'b0);
        send_bit(1'b1);
        send_bit(1'b1);
        send_bit(1'b0);

        $display("All Q14 tests passed.");
        $finish;
    end
endmodule
