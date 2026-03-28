module q12 (
    input  wire clk,
    input  wire rst,
    input  wire d,
    output wire pulse_high,
    output wire pulse_low
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

    // Theory:
    // q1 stores d from 1 clock earlier.
    // q2 stores d from 2 clocks earlier.
    // So the logic checks a 3-sample window: {q2, q1, d}.
    //
    // Exact one-cycle high pulse means: 0 -> 1 -> 0
    // Therefore: q2=0, q1=1, d=0
    //
    // Exact one-cycle low pulse means: 1 -> 0 -> 1
    // Therefore: q2=1, q1=0, d=1
    //
    // Note on ~ :
    // ~d, (~d), and ~(d) are the same for a single 1-bit signal.
    // Parentheses here are only for readability.

    // Detect an exact one-cycle high pulse pattern: 0 -> 1 -> 0.
    assign pulse_high = (~d) & q1 & (~q2);

    // Detect an exact one-cycle low pulse pattern: 1 -> 0 -> 1.
    assign pulse_low  = d & (~q1) & q2;
endmodule
