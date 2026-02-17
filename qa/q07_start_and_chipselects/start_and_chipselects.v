module start_and_chipselects (
    input  wire clk,
    input  wire rst_n,
    output wire start,
    output wire CS1,
    output wire CS2,
    output wire CS3
);
reg [1:0] counter;
reg start_d;
reg [1:0] sel;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        counter <= 2'd0;
    else if (counter == 2'd2)
        counter <= 2'd0;
    else
        counter <= counter + 2'd1;
end

assign start = (counter == 2'd1);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
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

assign CS1 = start_d & (sel == 2'd0);
assign CS2 = start_d & (sel == 2'd1);
assign CS3 = start_d & (sel == 2'd2);

endmodule
