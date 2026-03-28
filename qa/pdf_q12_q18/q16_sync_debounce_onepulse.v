module q16_sync_debounce_onepulse (
    input  wire clk,
    input  wire rst,
    input  wire async_in,
    output wire pulse
);
    // Assumptions from the question:
    // 1) async_in is driven from an asynchronous source, so it must be synchronized.
    // 2) We need a pulse only for a low-to-high transition.
    // 3) Noise/glitches must be filtered out, so the synchronized input must stay
    //    high for at least 2 clk cycles before it is accepted as valid.
    //
    // This implementation is therefore:
    // - a 2-flop synchronizer on the input
    // - followed by a 2-sample validity check
    // - followed by one-clock pulse generation on the first valid high cycle

    // q1/q2 form the classic 2-flop synchronizer for an asynchronous input.
    reg q1;
    reg q2;

    // d1/d2 are delayed copies of the synchronized signal.
    // They let us check that the synchronized input stayed high for 2 clocks
    // and also create a one-clock pulse on the qualified rising event.
    reg d1;
    reg d2;

    // Sample async_in into the clk domain, then keep two more cycles of history.
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q1 <= 1'b0;
            q2 <= 1'b0;
            d1 <= 1'b0;
            d2 <= 1'b0;
        end else begin
            q1 <= async_in; // First synchronizer stage
            q2 <= q1;       // Second synchronizer stage: stable clk-domain version
            d1 <= q2;       // Previous synchronized sample
            d2 <= d1;       // Two-clocks-old synchronized sample
        end
    end

    // Pulse condition:
    // - q2 = 1 and d1 = 1  -> synchronized input has been high for at least 2 clocks
    // - d2 = 0             -> this is the first qualified high cycle only
    //
    // So:
    // - short glitches that do not survive long enough after synchronization are rejected
    // - a valid low-to-high transition produces exactly one clk-wide pulse
    assign pulse = (q2 & d1) & (~d2);
endmodule
