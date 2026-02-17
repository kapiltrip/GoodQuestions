module q30_reset_synchronizer (
    input  wire clk,
    input  wire rst_n,
    output wire local_reset_n
);
    reg ff1;
    reg ff2;

    // Asynchronous assert (rst_n low), synchronous deassert (rst_n high).
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ff1 <= 1'b0;
            ff2 <= 1'b0;
        end else begin
            ff1 <= 1'b1;
            ff2 <= ff1;
        end
    end

    assign local_reset_n = rst_n & ff2;
endmodule
