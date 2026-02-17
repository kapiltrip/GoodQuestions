module edge_to_1cycle_pulse (
    input  wire clk,
    input  wire rst_n,   // active-low reset
    input  wire d,
    output reg  q
);

    reg prev;  // previous value of d (1-clock delayed)

    always @(posedge clk) begin
        if (!rst_n) begin
            prev <= 1'b0;
            q    <= 1'b0;
        end else begin
            q    <= d & ~prev;  // 1-cycle pulse on rising edge of d
            prev <= d;          // store current d for next cycle
        end
    end

endmodule
