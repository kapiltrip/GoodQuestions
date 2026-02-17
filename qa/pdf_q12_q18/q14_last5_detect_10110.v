module q14_last5_detect_10110 (
    input  wire clk,
    input  wire rst,
    input  wire din,
    output wire match
);
    reg [4:0] window;

    always @(posedge clk or posedge rst) begin
        if (rst)
            window <= 5'b00000;
        else
            window <= {window[3:0], din};
    end

    // High whenever the most recent 5 sampled bits are 10110.
    assign match = (window == 5'b10110);
endmodule
