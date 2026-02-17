module q12 (
    input  wire clk,
    input  wire rst,
    input  wire d,
    output wire pulse_high
);
    reg q1;
    reg q2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q1 <= 1'b0;
            q2 <= 1'b0;
        end else begin
            q1 <= d;   // delay by 1 cycle
            q2 <= q1;  // delay by 2 cycles
        end
    end

    // Detect an exact one-cycle pulse pattern: 0 -> 1 -> 0.
    assign pulse_high = (~d) & q1 & (~q2);
endmodule
