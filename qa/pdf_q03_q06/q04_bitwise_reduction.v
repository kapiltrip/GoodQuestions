module q04 (
    input  wire [15:0] databus,
    output wire        all_ones_detected,
    output wire        is_databus_odd,
    output wire        signal_not_zero
);
    assign all_ones_detected = &databus;  // AND reduction

    // This is not an "=^" operator. The "=" is assignment, and the "^" before
    // databus is a reduction XOR operator.
    //
    // Read this as:
    //     is_databus_odd = (^databus);
    //
    // Because "^" has one operand here, it XORs all bits of databus together
    // and produces one output bit:
    //     ^databus = databus[15] ^ databus[14] ^ ... ^ databus[0]
    //
    // Compare:
    //     a ^ b   -> bitwise XOR between two operands
    //     ^a      -> reduction XOR of all bits in one operand
    assign is_databus_odd    = ^databus;  // XOR reduction (odd number of 1s)

    assign signal_not_zero   = |databus;  // OR reduction
endmodule
