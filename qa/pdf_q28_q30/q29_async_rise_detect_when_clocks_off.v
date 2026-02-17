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
