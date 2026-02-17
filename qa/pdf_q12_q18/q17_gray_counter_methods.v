module q17_gray_counter_case_3bit (
    input  wire       clk,
    input  wire       rst,
    output reg [2:0]  gray
);
    reg [2:0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst)
            counter <= 3'b000;
        else
            counter <= counter + 3'b001;
    end

    // Method 1: explicit decode table from binary count to Gray code.
    always @* begin
        case (counter)
            3'b000: gray = 3'b000;
            3'b001: gray = 3'b001;
            3'b010: gray = 3'b011;
            3'b011: gray = 3'b010;
            3'b100: gray = 3'b110;
            3'b101: gray = 3'b111;
            3'b110: gray = 3'b101;
            default: gray = 3'b100;
        endcase
    end
endmodule

module q17_gray_counter_xor #(parameter N = 4) (
    input  wire         clk,
    input  wire         rst,
    output wire [N-1:0] gray
);
    reg [N-1:0] bcd_counter;

    always @(posedge clk or posedge rst) begin
        if (rst)
            bcd_counter <= {N{1'b0}};
        else
            bcd_counter <= bcd_counter + {{(N-1){1'b0}}, 1'b1};
    end

    // Method 2: generic binary-to-Gray conversion by XORing adjacent bits.
    assign gray = bcd_counter ^ (bcd_counter >> 1);
endmodule
