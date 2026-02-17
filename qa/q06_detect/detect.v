module detect(
    input wire clk,
    input wire rst_n,
    input wire din,
    output wire match
);
reg [4:0] shreg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        shreg <= 5'b0;
    else
        shreg <= {shreg[3:0], din};
end

assign match = (shreg == 5'b10110);

endmodule
