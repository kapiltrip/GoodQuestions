module q29_async_rise_detect_when_clocks_off (
    input  wire d_async,
    input  wire clr_n,
    output reg  q
);
    // Set on async rising edge, hold until async clear.
    always @(posedge d_async or negedge clr_n) begin
        if (!clr_n)
            q <= 1'b0;
        else
            q <= 1'b1;
    end
endmodule

module q29_async_any_edge_detect_when_clocks_off (
    input  wire d_async,
    input  wire clr_n,
    output wire q
);
    reg rise_seen;
    reg fall_seen;

    // Set on async rising edge, hold until async clear.
    always @(posedge d_async or negedge clr_n) begin
        if (!clr_n)
            rise_seen <= 1'b0;
        else
            rise_seen <= 1'b1;
    end

    // Set on async falling edge, hold until async clear.
    always @(negedge d_async or negedge clr_n) begin
        if (!clr_n)
            fall_seen <= 1'b0;
        else
            fall_seen <= 1'b1;
    end

    assign q = rise_seen | fall_seen;
endmodule
