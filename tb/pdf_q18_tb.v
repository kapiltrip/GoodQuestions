`timescale 1ns/1ps
`include "qa/pdf_q12_q18/q18_fifo_sync_dualport.v"

module pdf_q18_tb;
    reg clk;
    reg rst_n;
    reg push;
    reg pop;
    reg [7:0] data_in;
    wire [7:0] data_out;
    wire fifo_full;
    wire fifo_empty;

    fifo_sync_dualport #(
        .DATA_W(8),
        .ADDR_W(2)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .push(push),
        .pop(pop),
        .data_in(data_in),
        .data_out(data_out),
        .fifo_full(fifo_full),
        .fifo_empty(fifo_empty)
    );

    always #5 clk = ~clk;

    task do_cycle;
        input p_push;
        input p_pop;
        input [7:0] p_data;
        begin
            @(negedge clk);
            push = p_push;
            pop = p_pop;
            data_in = p_data;
            @(posedge clk);
            #1;
        end
    endtask

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        push = 1'b0;
        pop = 1'b0;
        data_in = 8'h00;

        repeat (2) @(posedge clk);
        rst_n = 1'b1;
        @(posedge clk);
        #1;

        if (fifo_empty !== 1'b1 || fifo_full !== 1'b0) begin
            $display("FAIL Q18: bad reset flags");
            $finish;
        end

        do_cycle(1'b1, 1'b0, 8'h11);
        do_cycle(1'b1, 1'b0, 8'h22);
        do_cycle(1'b1, 1'b0, 8'h33);
        do_cycle(1'b1, 1'b0, 8'h44);

        if (fifo_full !== 1'b1) begin
            $display("FAIL Q18: fifo_full not asserted after 4 pushes");
            $finish;
        end

        do_cycle(1'b0, 1'b1, 8'h00);
        if (data_out !== 8'h11) begin
            $display("FAIL Q18: first pop expected 0x11 got 0x%0h", data_out);
            $finish;
        end

        do_cycle(1'b0, 1'b1, 8'h00);
        if (data_out !== 8'h22) begin
            $display("FAIL Q18: second pop expected 0x22 got 0x%0h", data_out);
            $finish;
        end

        do_cycle(1'b0, 1'b1, 8'h00);
        if (data_out !== 8'h33) begin
            $display("FAIL Q18: third pop expected 0x33 got 0x%0h", data_out);
            $finish;
        end

        do_cycle(1'b0, 1'b1, 8'h00);
        if (data_out !== 8'h44) begin
            $display("FAIL Q18: fourth pop expected 0x44 got 0x%0h", data_out);
            $finish;
        end

        if (fifo_empty !== 1'b1) begin
            $display("FAIL Q18: fifo_empty not asserted after pops");
            $finish;
        end

        $display("PASS Q18");
        $finish;
    end
endmodule
