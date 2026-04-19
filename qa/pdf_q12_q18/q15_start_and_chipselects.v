module q15_start_and_chipselects (
    input  wire clk,
    input  wire rst,
    output wire start,
    output wire cs1,
    output wire cs2,
    output wire cs3
);
    reg [1:0] phase;
    reg [1:0] sel;

    // phase:
    // 0 -> start pulse
    // 1 -> one chip-select pulse
    // 2 -> idle
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            phase <= 2'd2;
            sel <= 2'd0;
        end else begin
            case (phase)
                2'd0: begin
                    phase <= 2'd1;
                end

                2'd1: begin
                    phase <= 2'd2;
                    if (sel == 2'd2)
                        sel <= 2'd0;
                    else
                        sel <= sel + 2'd1;
                end

                default: begin
                    phase <= 2'd0;
                end
            endcase
        end
    end

    assign start = (phase == 2'd0);
assign cs1 = (phase == 2'd1) && (sel == 2'd0);
assign cs2 = (phase == 2'd1) && (sel == 2'd1);
assign cs3 = (phase == 2'd1) && (sel == 2'd2);
endmodule

// Discussion:
// phase is acting like a small FSM state register.
// phase = 2'd0 is the start-pulse state.
// phase = 2'd1 is the chip-select-pulse state.
// phase = 2'd2 is the idle state, where all outputs are low.
//
// The code could explicitly write:
//     2'd2: phase <= 2'd0;
//
// Instead, q15 uses the default branch:
//     default: phase <= 2'd0;
//
// For normal operation, this is the same because phase = 2'd2 falls into
// default and returns to phase = 2'd0 on the next clock edge. The default
// branch also recovers safely if phase ever becomes the unused value 2'd3.
