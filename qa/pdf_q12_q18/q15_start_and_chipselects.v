module q15_start_and_chipselects (
    input  wire clk,
    input  wire rst,
    output wire start,
    output wire cs1,
    output wire cs2,
    output wire cs3
);
    reg [1:0] counter;
    reg       start_d;
    reg [1:0] sel;

    // Generate a start pulse every 3 clocks: count 0,1,2 then wrap.
    always @(posedge clk or posedge rst) begin
        if (rst)
            counter <= 2'd0;
        else if (counter == 2'd2)
            counter <= 2'd0;
        else
            counter <= counter + 2'd1;
    end

    assign start = (counter == 2'd1);

    // One cycle after start, pulse one chip-select and rotate CS1->CS2->CS3.
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            start_d <= 1'b0;
            sel <= 2'd0;
        end else begin
            start_d <= start;
            if (start_d) begin
                if (sel == 2'd2)
                    sel <= 2'd0;
                else
                    sel <= sel + 2'd1;
            end
        end
    end

    assign cs1 = start_d & (sel == 2'd0);
    assign cs2 = start_d & (sel == 2'd1);
    assign cs3 = start_d & (sel == 2'd2);
endmodule
