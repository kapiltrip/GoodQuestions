module q19_divisible_by3_fsm (
    input  wire clk,
    input  wire rst,
    input  wire bit_in,
    output wire div_by_3
);
    reg [1:0] state;
    reg [1:0] next_state;

    localparam MOD0 = 2'd0;
    localparam MOD1 = 2'd1;
    localparam MOD2 = 2'd2;

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= MOD0;
        else
            state <= next_state;
    end

    // New remainder = (old_remainder * 2 + bit_in) mod 3.
    always @* begin
        case (state)
            MOD0: next_state = (bit_in ? MOD1 : MOD0);
            MOD1: next_state = (bit_in ? MOD0 : MOD2);
            MOD2: next_state = (bit_in ? MOD2 : MOD1);
            default: next_state = MOD0;
        endcase
    end

    assign div_by_3 = (state == MOD0);
endmodule
