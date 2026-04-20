module q26_clock_div3_duty50 (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div3
);
    // Counts input clock cycles in sequence: 0, 1, 2, then repeats.
    reg [1:0] counter;
    // Goes high for one full input clock cycle once every 3 cycles.
    reg clk_pos;
    // Delayed copy of clk_pos taken on the falling edge, used for 50% duty.
    reg clk_neg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 2'b00;
            clk_pos <= 1'b0;
        end else begin
            if (counter == 2'b10)
                counter <= 2'b00;
            else
                counter <= counter + 2'b01;

            clk_pos <= (counter == 2'b10);
        end
    end

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_neg <= 1'b0;
        else
            clk_neg <= clk_pos;
    end

    assign clk_div3 = clk_pos | clk_neg;
endmodule
