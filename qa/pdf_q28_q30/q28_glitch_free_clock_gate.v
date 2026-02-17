module q28_glitch_free_clock_gate (
    input  wire clk_in,
    input  wire enable,
    output wire gated_clk
);
    reg en_latched;

    // Latch enable only while clock is low.
    // This prevents enable changes from glitching gated_clk when clk_in is high.
    always @(clk_in or enable) begin
        if (!clk_in)
            en_latched <= enable;
    end

    assign gated_clk = clk_in & en_latched;
endmodule
