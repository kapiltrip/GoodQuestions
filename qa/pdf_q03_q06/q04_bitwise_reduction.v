module q04 (
    input  wire [15:0] databus,
    output wire        all_ones_detected,
    output wire        is_databus_odd,
    output wire        signal_not_zero
);
    assign all_ones_detected = &databus;  // AND reduction
    assign is_databus_odd    = ^databus;  // XOR reduction (odd number of 1s)
    assign signal_not_zero   = |databus;  // OR reduction
endmodule
