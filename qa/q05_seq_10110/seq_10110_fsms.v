module seq_10110_mealy_overlap (
    input  wire clk,
    input  wire rst_n,
    input  wire x,
    output reg  y
);
    // Mealy + overlap:
    // - y pulses in the same cycle the last '0' of 10110 arrives.
    // - After a match, keep the longest useful suffix ("10") for overlap.
    reg [2:0] state, next_state;

    // State meaning = longest matched prefix of "10110".
    localparam S0 = 3'd0; // ""
    localparam S1 = 3'd1; // "1"
    localparam S2 = 3'd2; // "10"
    localparam S3 = 3'd3; // "101"
    localparam S4 = 3'd4; // "1011"

    always @(posedge clk) begin
        if (!rst_n) state <= S0;
        else        state <= next_state;
    end

    always @* begin
        y = 1'b0;
        next_state = state;

        case (state)
            S0: next_state = (x ? S1 : S0);
            S1: next_state = (x ? S1 : S2);
            S2: next_state = (x ? S3 : S0);
            S3: next_state = (x ? S4 : S2);
            S4: begin
                if (x) begin
                    next_state = S1;
                end else begin
                    y = 1'b1;       // Detected 10110 (Mealy pulse now).
                    next_state = S2; // Overlap: keep trailing "10".
                end
            end
            default: next_state = S0;
        endcase
    end
endmodule

module seq_10110_mealy_nonoverlap (
    input  wire clk,
    input  wire rst_n,
    input  wire x,
    output reg  y
);
    // Mealy + non-overlap:
    // - y pulses in the same cycle the last '0' of 10110 arrives.
    // - After a match, restart from S0 (no shared bits across matches).
    reg [2:0] state, next_state;

    localparam S0 = 3'd0; // ""
    localparam S1 = 3'd1; // "1"
    localparam S2 = 3'd2; // "10"
    localparam S3 = 3'd3; // "101"
    localparam S4 = 3'd4; // "1011"

    always @(posedge clk) begin
        if (!rst_n) state <= S0;
        else        state <= next_state;
    end

    always @* begin
        y = 1'b0;
        next_state = state;

        case (state)
            S0: next_state = (x ? S1 : S0);
            S1: next_state = (x ? S1 : S2);
            S2: next_state = (x ? S3 : S0);
            S3: next_state = (x ? S4 : S2);
            S4: begin
                if (x) begin
                    next_state = S1;
                end else begin
                    y = 1'b1;       // Detected 10110 (Mealy pulse now).
                    next_state = S0; // Non-overlap: full restart.
                end
            end
            default: next_state = S0;
        endcase
    end
endmodule

module seq_10110_moore_overlap (
    input  wire clk,
    input  wire rst_n,
    input  wire x,
    output reg  y
);
    // Moore + overlap:
    // - y is high only in S5, so detection is one clock after last bit.
    // - After S5, transition as if "10" was already matched.
    reg [2:0] state, next_state;

    localparam S0 = 3'd0; // ""
    localparam S1 = 3'd1; // "1"
    localparam S2 = 3'd2; // "10"
    localparam S3 = 3'd3; // "101"
    localparam S4 = 3'd4; // "1011"
    localparam S5 = 3'd5; // Match state (y=1).

    always @(posedge clk) begin
        if (!rst_n) state <= S0;
        else        state <= next_state;
    end

    always @* begin
        y = (state == S5); // Moore output depends only on state.

        case (state)
            S0: next_state = (x ? S1 : S0);
            S1: next_state = (x ? S1 : S2);
            S2: next_state = (x ? S3 : S0);
            S3: next_state = (x ? S4 : S2);
            S4: next_state = (x ? S1 : S5); // On x=0, complete 10110.
            S5: begin
                next_state = (x ? S3 : S0); // Overlap continuation from suffix "10".
            end
            default: next_state = S0;
        endcase
    end
endmodule

module seq_10110_moore_nonoverlap (
    input  wire clk,
    input  wire rst_n,
    input  wire x,
    output reg  y
);
    // Moore + non-overlap:
    // - y is high only in S5, so detection is one clock after last bit.
    // - After S5, restart matching from scratch.
    reg [2:0] state, next_state;

    localparam S0 = 3'd0; // ""
    localparam S1 = 3'd1; // "1"
    localparam S2 = 3'd2; // "10"
    localparam S3 = 3'd3; // "101"
    localparam S4 = 3'd4; // "1011"
    localparam S5 = 3'd5; // Match state (y=1).

    always @(posedge clk) begin
        if (!rst_n) state <= S0;
        else        state <= next_state;
    end

    always @* begin
        y = (state == S5); // Moore output depends only on state.

        case (state)
            S0: next_state = (x ? S1 : S0);
            S1: next_state = (x ? S1 : S2);
            S2: next_state = (x ? S3 : S0);
            S3: next_state = (x ? S4 : S2);
            S4: next_state = (x ? S1 : S5); // On x=0, complete 10110.
            S5: begin
                next_state = (x ? S1 : S0); // Non-overlap restart behavior.
            end
            default: next_state = S0;
        endcase
    end
endmodule
