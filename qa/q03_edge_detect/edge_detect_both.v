module edge_detect_both (
    input  wire clk,
    input  wire rst,
    input  wire d,
    output reg  q
);
    // Stores previous sampled value of d.
    reg d_prev;

    // On each clock, compare current d with previous d.
    // If different, q=1 for one cycle (edge detected).
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            d_prev <= 1'b0;
            q <= 1'b0;
        end else begin
            // XOR is 1 when d changed (0->1 or 1->0).
            q <= d ^ d_prev;
            // Update history for next cycle comparison.
            d_prev <= d;
        end
    end
endmodule

module edge_detect_both_async_d (
    input  wire clk,
    input  wire rst,
    input  wire d,
    output reg  q
);
    // Two-stage synchronizer for asynchronous input d.
    reg d_sync1;
    reg d_sync2;
    // Previous synchronized sample for edge comparison.
    reg d_sync2_prev;

    // Synchronize async input to clk domain, then detect both edges.
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            d_sync1 <= 1'b0;
            d_sync2 <= 1'b0;
            d_sync2_prev <= 1'b0;
            q <= 1'b0;
        end else begin
            // Stage 1 and stage 2 synchronization.
            d_sync1 <= d;
            d_sync2 <= d_sync1;
            // Edge pulse in clk domain after synchronization.
            q <= d_sync2 ^ d_sync2_prev;
            // Save current synchronized value for next comparison.
            d_sync2_prev <= d_sync2;
        end
    end
endmodule
