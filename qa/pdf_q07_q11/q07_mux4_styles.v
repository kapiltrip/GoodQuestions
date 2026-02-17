module q07_a (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire [1:0] sel,
    output wire y
);
    assign y = (sel == 2'b00) ? a :
               (sel == 2'b01) ? b :
               (sel == 2'b10) ? c : d;
endmodule

module q07_b (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire [1:0] sel,
    output reg  y
);
    always @(*) begin
        if (sel == 2'b00)
            y = a;
        else if (sel == 2'b01)
            y = b;
        else if (sel == 2'b10)
            y = c;
        else
            y = d;
    end
endmodule

module q07_c (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire [1:0] sel,
    output reg  y
);
    always @(*) begin
        case (sel)
            2'b00: y = a;
            2'b01: y = b;
            2'b10: y = c;
            default: y = d;
        endcase
    end
endmodule
