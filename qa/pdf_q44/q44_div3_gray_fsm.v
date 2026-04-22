// Q44: Divide-by-3 FSM examples.
//
// These modules are written as interview/practice examples. In a production
// FPGA/ASIC design, do not use a fabric-generated signal as a clock unless
// the clocking architecture and timing constraints explicitly support it.

module q44_div3_fsm_binary (
    input  wire       clk,
    input  wire       rst_n,
    output reg        div3_out,
    output reg  [1:0] state
);
    localparam S_HIGH = 2'b00;
    localparam S_LOW0 = 2'b01;
    localparam S_LOW1 = 2'b10;

    reg [1:0] next_state;

    always @(*) begin
        case (state)
            S_HIGH: next_state = S_LOW0;
            S_LOW0: next_state = S_LOW1;
            S_LOW1: next_state = S_HIGH;
            default: next_state = S_HIGH;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= S_HIGH;
            div3_out <= 1'b1;
        end else begin
            state    <= next_state;
            div3_out <= (next_state == S_HIGH);
        end
    end
endmodule

module q44_div3_fsm_gray6 (
    input  wire       clk,
    input  wire       rst_n,
    output reg        div3_out,
    output reg  [2:0] state
);
    localparam S0_HIGH = 3'b000;
    localparam S1_LOW  = 3'b001;
    localparam S2_LOW  = 3'b011;
    localparam S3_HIGH = 3'b111;
    localparam S4_LOW  = 3'b101;
    localparam S5_LOW  = 3'b100;

    reg [2:0] next_state;

    always @(*) begin
        case (state)
            S0_HIGH: next_state = S1_LOW;
            S1_LOW:  next_state = S2_LOW;
            S2_LOW:  next_state = S3_HIGH;
            S3_HIGH: next_state = S4_LOW;
            S4_LOW:  next_state = S5_LOW;
            S5_LOW:  next_state = S0_HIGH;
            default: next_state = S0_HIGH;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= S0_HIGH;
            div3_out <= 1'b1;
        end else begin
            state    <= next_state;
            div3_out <= (next_state == S0_HIGH) || (next_state == S3_HIGH);
        end
    end
endmodule

module q44_div3_fsm_gray6_equations (
    input  wire       clk,
    input  wire       rst_n,
    output reg        div3_out,
    output reg  [2:0] state
);
    wire [2:0] next_state;

    assign next_state[2] = state[0] & (state[2] | state[1]);
    assign next_state[1] = ~state[2] & state[0];
    assign next_state[0] = (~state[2] & ~state[1]) | (state[1] & state[0]);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= 3'b000;
            div3_out <= 1'b1;
        end else begin
            state    <= next_state;
            div3_out <= (next_state == 3'b000) || (next_state == 3'b111);
        end
    end
endmodule
