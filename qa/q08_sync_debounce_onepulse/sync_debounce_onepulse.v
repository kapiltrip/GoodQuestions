module sync_debounce_onepulse (
    input  wire clk,
    input  wire rst_n,
    input  wire async_in,
    output wire pulse
);
reg q1, q2;
reg d1, d2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        q1 <= 1'b0;
        q2 <= 1'b0;
        d1 <= 1'b0;
        d2 <= 1'b0;
    end else begin
        q1 <= async_in;
        q2 <= q1;
        d1 <= q2;
        d2 <= d1;
    end
end

assign pulse = (q2 & d1) & ~d2;

endmodule
