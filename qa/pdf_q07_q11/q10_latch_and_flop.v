module q10 (
    input  wire clk,
    input  wire input_sig,
    output reg  q_latch,
    output reg  q_flop
);
    always @(clk or input_sig) begin
        if (clk)
            q_latch <= input_sig;
    end

    always @(posedge clk) begin
        q_flop <= input_sig;
    end
endmodule
