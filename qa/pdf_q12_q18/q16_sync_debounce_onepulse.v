module q16_sync_debounce_onepulse (
    input  wire clk,
    input  wire rst,
    input  wire async_in,
    output wire pulse
);
    reg q1;
    reg q2;
    reg d1;
    reg d2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q1 <= 1'b0;
            q2 <= 1'b0;
            d1 <= 1'b0;
            d2 <= 1'b0;
        end else begin
            q1 <= async_in; // Synchronizer stage 1
            q2 <= q1;       // Synchronizer stage 2
            d1 <= q2;       // Delay 1
            d2 <= d1;       // Delay 2
        end
    end

    // Valid only if synchronized input stays high for 2 clocks.
    // Then emit one pulse on low->high transition of that validated signal.
    assign pulse = (q2 & d1) & (~d2);
endmodule
