// Q13 pattern detector for 10110
// A: Mealy overlap
// B: Mealy non-overlap
// C: Moore overlap
// D: Moore non-overlap

module q13_a (
    input  wire clk,
    input  wire rst,
    input  wire x,
    output reg  y
);
    reg [2:0] state, next_state;

    localparam A = 3'd0; // ""
    localparam B = 3'd1; // "1"
    localparam C = 3'd2; // "10"
    localparam D = 3'd3; // "101"
    localparam E = 3'd4; // "1011"

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= A;
        else
            state <= next_state;
    end

    always @* begin
        y = 1'b0;
        next_state = state;

        case (state)
            A: next_state = (x ? B : A);
            B: next_state = (x ? B : C);
            C: next_state = (x ? D : A);
            D: next_state = (x ? E : C);
            E: begin
                if (x) begin
                    next_state = B;
                end else begin
                    y = 1'b1;
                    next_state = C; // overlap keeps suffix "10"
                end
            end
            default: next_state = A;
        endcase
    end
endmodule

module q13_b (
    input  wire clk,
    input  wire rst,
    input  wire x,
    output reg  y
);
    reg [2:0] state, next_state;

    localparam A = 3'd0;
    localparam B = 3'd1;
    localparam C = 3'd2;
    localparam D = 3'd3;
    localparam E = 3'd4;

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= A;
        else
            state <= next_state;
    end

    always @* begin
        y = 1'b0;
        next_state = state;

        case (state)
            A: next_state = (x ? B : A);
            B: next_state = (x ? B : C);
            C: next_state = (x ? D : A);
            D: next_state = (x ? E : C);
            E: begin
                if (x) begin
                    next_state = B;
                end else begin
                    y = 1'b1;
                    next_state = A; // non-overlap restart
                end
            end
            default: next_state = A;
        endcase
    end
endmodule

module q13_c (
    input  wire clk,
    input  wire rst,
    input  wire x,
    output reg  y
);
    reg [2:0] state, next_state;

    localparam A = 3'd0;
    localparam B = 3'd1;
    localparam C = 3'd2;
    localparam D = 3'd3;
    localparam E = 3'd4;
    localparam F = 3'd5; // match state

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= A;
        else
            state <= next_state;
    end

    always @* begin
        y = (state == F);

        case (state)
            A: next_state = (x ? B : A);
            B: next_state = (x ? B : C);
            C: next_state = (x ? D : A);
            D: next_state = (x ? E : C);
            E: next_state = (x ? B : F);
            F: next_state = (x ? D : A); // overlap continuation
            default: next_state = A;
        endcase
    end
endmodule

module q13_d (
    input  wire clk,
    input  wire rst,
    input  wire x,
    output reg  y
);
    reg [2:0] state, next_state;

    localparam A = 3'd0;
    localparam B = 3'd1;
    localparam C = 3'd2;
    localparam D = 3'd3;
    localparam E = 3'd4;
    localparam F = 3'd5; // match state

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= A;
        else
            state <= next_state;
    end

    always @* begin
        y = (state == F);

        case (state)
            A: next_state = (x ? B : A);
            B: next_state = (x ? B : C);
            C: next_state = (x ? D : A);
            D: next_state = (x ? E : C);
            E: next_state = (x ? B : F);
            F: next_state = (x ? B : A); // non-overlap restart
            default: next_state = A;
        endcase
    end
endmodule
