// Q13 : Pattern detector for 10110
//
// A = Mealy overlap
// B = Mealy non-overlap
// C = Moore overlap
// D = Moore non-overlap
//
// State meaning is written in the state names themselves:
// S0    = no useful bits matched yet
// S1    = matched "1"
// S10   = matched "10"
// S101  = matched "101"
// S1011 = matched "1011"
//
// For Moore only, we add one extra state:
// SMATCH = full pattern "10110" detected

//==============================================================
// A) Mealy overlap
//==============================================================
module q13_a (
    input  wire clk,
    input  wire rst,
    input  wire x,
    output reg  y
);
    reg [2:0] state, next_state;

    localparam S0    = 3'd0;
    localparam S1    = 3'd1;
    localparam S10   = 3'd2;
    localparam S101  = 3'd3;
    localparam S1011 = 3'd4;

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= S0;
        else
            state <= next_state;
    end

    always @* begin
        next_state = state;
        y = 1'b0;

        // Mealy difference:
        // output depends on (present state + input),
        // so we do NOT need an extra match state.
        case (state)
            S0   : next_state = (x ? S1    : S0);
            S1   : next_state = (x ? S1    : S10);
            S10  : next_state = (x ? S101  : S0);
            S101 : next_state = (x ? S1011 : S10);

            S1011: begin
                if (x) begin
                    next_state = S1;
                end else begin
                    y = 1'b1;        // detect 10110 immediately
                    next_state = S10; // overlap:
                                      // 10110 ends with suffix "10",
                                      // so keep that for next possible match
                end
            end

            default: next_state = S0;
        endcase
    end
endmodule


//==============================================================
// B) Mealy non-overlap
//==============================================================
module q13_b (
    input  wire clk,
    input  wire rst,
    input  wire x,
    output reg  y
);
    reg [2:0] state, next_state;

    localparam S0    = 3'd0;
    localparam S1    = 3'd1;
    localparam S10   = 3'd2;
    localparam S101  = 3'd3;
    localparam S1011 = 3'd4;

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= S0;
        else
            state <= next_state;
    end

    always @* begin
        next_state = state;
        y = 1'b0;

        case (state)
            S0   : next_state = (x ? S1    : S0);
            S1   : next_state = (x ? S1    : S10);
            S10  : next_state = (x ? S101  : S0);
            S101 : next_state = (x ? S1011 : S10);

            S1011: begin
                if (x) begin
                    next_state = S1;
                end else begin
                    y = 1'b1;      // detect 10110 immediately
                    next_state = S0; // non-overlap:
                                     // after match, restart from scratch
                end
            end

            default: next_state = S0;
        endcase
    end
endmodule


//==============================================================
// C) Moore overlap
//==============================================================
module q13_c (
    input  wire clk,
    input  wire rst,
    input  wire x,
    output reg  y
);
    reg [2:0] state, next_state;

    localparam S0     = 3'd0;
    localparam S1     = 3'd1;
    localparam S10    = 3'd2;
    localparam S101   = 3'd3;
    localparam S1011  = 3'd4;
    localparam SMATCH = 3'd5;

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= S0;
        else
            state <= next_state;
    end

    always @* begin
        next_state = state;

        // Moore difference:
        // output depends ONLY on state,
        // so we need an extra match state.
        y = (state == SMATCH);

        case (state)
            S0    : next_state = (x ? S1    : S0);
            S1    : next_state = (x ? S1    : S10);
            S10   : next_state = (x ? S101  : S0);
            S101  : next_state = (x ? S1011 : S10);

            // In Moore, pattern completion moves to SMATCH first.
            S1011 : next_state = (x ? S1 : SMATCH);

            // overlap:
            // after detecting 10110, the useful suffix is "10"
            // so SMATCH behaves like state S10 for the next input
            // from S10: x=1 -> S101, x=0 -> S0
            SMATCH: next_state = (x ? S101 : S0);

            default: next_state = S0;
        endcase
    end
endmodule


//==============================================================
// D) Moore non-overlap
//==============================================================
module q13_d (
    input  wire clk,
    input  wire rst,
    input  wire x,
    output reg  y
);
    reg [2:0] state, next_state;

    localparam S0     = 3'd0;
    localparam S1     = 3'd1;
    localparam S10    = 3'd2;
    localparam S101   = 3'd3;
    localparam S1011  = 3'd4;
    localparam SMATCH = 3'd5;

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= S0;
        else
            state <= next_state;
    end

    always @* begin
        next_state = state;
        y = (state == SMATCH);

        case (state)
            S0    : next_state = (x ? S1    : S0);
            S1    : next_state = (x ? S1    : S10);
            S10   : next_state = (x ? S101  : S0);
            S101  : next_state = (x ? S1011 : S10);
            S1011 : next_state = (x ? S1 : SMATCH);

            // non-overlap:
            // after reporting a match, restart searching fresh
            SMATCH: next_state = (x ? S1 : S0);

            default: next_state = S0;
        endcase
    end
endmodule
