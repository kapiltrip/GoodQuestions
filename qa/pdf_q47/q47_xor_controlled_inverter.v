// Q47: XOR used as a controlled inverter.

module q47_xor_controlled_inverter (
    input  wire a,
    input  wire control,
    output wire y
);
    assign y = a ^ control;
endmodule

module q47_xnor_controlled_buffer (
    input  wire a,
    input  wire control,
    output wire y
);
    assign y = ~(a ^ control);
endmodule

module q47_add_sub_4bit (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       subtract,
    output wire [3:0] result,
    output wire       cout
);
    wire [3:0] b_to_adder;

    assign b_to_adder = b ^ {4{subtract}};
    assign {cout, result} = a + b_to_adder + subtract;
endmodule
