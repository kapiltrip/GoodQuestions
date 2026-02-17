module q23_timing_b_from_a (
    input  wire clk,
    input  wire rst_n,
    input  wire A,
    output wire B
);
    reg a_delay;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            a_delay <= 1'b0;
        else
            a_delay <= A;
    end

    assign B = A | a_delay;
endmodule
