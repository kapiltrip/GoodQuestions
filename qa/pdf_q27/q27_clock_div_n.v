module q27_clock_div_n #(
    // Maximum supported divide ratio N.
    // divider_value is programmed as N-1.
    parameter MAX_N = 256,
    // Duty selector:
    // 0 -> narrow pulse  (~1/N high)
    // 1 -> near 50%      (exact for even N)
    // 2 -> wide pulse    (~(N-1)/N high)
    // 3 -> 100% high
    parameter integer DUTY_MODE = 0
) (
    clk,
    rst_n,
    divider_value,
    clk_out
);
    function integer clog2;
        input integer value;
        integer i;
        begin
            value = value - 1;
            for (i = 0; value > 0; i = i + 1)
                value = value >> 1;
            clog2 = i;
        end
    endfunction

    localparam WIDTH = clog2(MAX_N);

    input  wire             clk;
    input  wire             rst_n;
    input  wire [WIDTH-1:0] divider_value; // program N-1
    output wire             clk_out;
    reg [WIDTH-1:0] posedge_cnt;
    reg rise_pulse_reg;
    reg neg_pulse_reg;

    // N = divider_value + 1
    // odd N => divider_value is even
    wire odd_n = ~divider_value[0];
    wire [WIDTH-1:0] half_point = divider_value >> 1;

    // Assumption: divider_value >= 1 (i.e., N >= 2)
    // Counter runs: 0 .. divider_value
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            posedge_cnt <= {WIDTH{1'b0}};
        else if (posedge_cnt == divider_value)
            posedge_cnt <= {WIDTH{1'b0}};
        else
            posedge_cnt <= posedge_cnt + 1'b1;
    end

    // Build base high window in posedge domain
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            rise_pulse_reg <= 1'b0;
        else if (posedge_cnt == half_point)
            rise_pulse_reg <= 1'b1;
        else if (posedge_cnt == divider_value)
            rise_pulse_reg <= 1'b0;
    end

    // For odd N, extend by half cycle using negedge sample
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            neg_pulse_reg <= 1'b0;
        else if (odd_n)
            neg_pulse_reg <= rise_pulse_reg;
        else
            neg_pulse_reg <= 1'b0;
    end

    // Different duty-cycle outputs on the same /N period.
    wire duty1       = (posedge_cnt == divider_value); // high for 1 count
    wire duty50      = rise_pulse_reg | neg_pulse_reg; // near 50%
    wire dutyNminus1 = (posedge_cnt != {WIDTH{1'b0}}); // low for 1 count
    wire duty100     = 1'b1;                           // always high

    // Select output style.
    assign clk_out = (DUTY_MODE == 0) ? duty1       :
                     (DUTY_MODE == 1) ? duty50      :
                     (DUTY_MODE == 2) ? dutyNminus1 :
                     (DUTY_MODE == 3) ? duty100     :
                                        duty50;
endmodule
