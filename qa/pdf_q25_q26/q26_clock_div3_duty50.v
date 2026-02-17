module q26_clock_div3_duty50 #(
    // Duty mode selector for learning/conversion:
    // 0 -> 33.3% (basic /3 decode, no half-cycle extension)
    // 1 -> 50.0% (uses negedge extension; recommended)
    // 2 -> 66.7% (high for 2 cycles, low for 1 cycle)
    // 3 -> 100% (always high; NOT a usable divided clock)
    parameter integer DUTY_MODE = 1
) (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div3
);
    // ------------------------------------------------------------
    // Conceptual framework (important for interviews/viva):
    //   Tout = TH + TL,  fout = 1/Tout
    //   For divide-by-3: Tout = 3*Tin, so fout = fin/3
    //
    // Two separate design questions:
    // 1) Repeat rate (frequency division):
    //    - Decided by counter sequence length (mod-3 here: 0,1,2).
    // 2) High/low split inside the same Tout (duty cycle):
    //    - D = TH/Tout
    //
    // Example for /3:
    //   Basic decode  : TH=Tin,   TL=2Tin   -> D=33.3%
    //   Duty fix (~50%): TH=1.5Tin, TL=1.5Tin -> D=50%
    //
    // Key point:
    //   Adjusting duty-cycle decode does NOT change mod-3 counting.
    //   Counter sets period (3*Tin); decode sets TH vs TL.
    // ------------------------------------------------------------

    // 2-bit counter is enough for mod-3 states: 0,1,2.
    reg [1:0] posedge_cnt;
    // High window generated on positive edge domain.
    // This by itself is the "original/basic" /3 output: 33.3% duty.
    reg risepulse;
    // Copy of risepulse captured on negative edge domain.
    // Used only to extend high time by half a clock.
    reg negpulse;

    // Mod-3 phase counter:
    // 00 -> 01 -> 10 -> 00 ...
    // This advances once per input posedge.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            posedge_cnt <= 2'b00;
        else if (posedge_cnt == 2'b10)
            posedge_cnt <= 2'b00;
        else
            posedge_cnt <= posedge_cnt + 2'b01;
    end

    // Generate a pulse in the posedge domain once every 3 cycles.
    // risepulse is high only during phase "2".
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            risepulse <= 1'b0;
        else if (posedge_cnt == 2'b10)
            risepulse <= 1'b1;
        else
            risepulse <= 1'b0;
    end

    // Half-cycle extension for odd divide ratio (/3):
    // capture risepulse on negedge so total high time becomes 1.5 cycles.
    // That gives near-50% duty: high 1.5 cycles, low 1.5 cycles in a 3-cycle period.
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            negpulse <= 1'b0;
        else
            negpulse <= risepulse;
    end

    // Final divide-by-3 output:
    // OR both registered terms; output only changes on clock edges (no combinational glitches).
    // Viva line:
    // "Frequency division is decided by pattern repeat period (Tout);
    // duty cycle is decided by TH/TL split within that same Tout."
    //
    // NOTE on "can I make any duty I want?":
    // For /3 with posedge+negedge shaping, practical steps are in half-cycle units.
    // So you get discrete choices (e.g. 33.3%, 50.0%, 66.7%), not arbitrary real values.
    wire clk_div3_33 = risepulse;             // TH=1.0Tin, TL=2.0Tin
    wire clk_div3_50 = risepulse | negpulse;  // TH=1.5Tin, TL=1.5Tin
    wire clk_div3_66 = (posedge_cnt != 2'b00);// TH=2.0Tin, TL=1.0Tin
    wire clk_div3_100 = 1'b1;                 // DC high (no toggling at output)

    assign clk_div3 = (DUTY_MODE == 0) ? clk_div3_33  :
                      (DUTY_MODE == 1) ? clk_div3_50  :
                      (DUTY_MODE == 2) ? clk_div3_66  :
                      (DUTY_MODE == 3) ? clk_div3_100 :
                                         clk_div3_50;
endmodule
