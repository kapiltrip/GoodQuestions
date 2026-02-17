module q27_div2_toggle (
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div2
);
    // Method: T-FF style toggle every input clock edge.
    // Equation: f_out = f_in / 2
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div2 <= 1'b0;
        else
            clk_div2 <= ~clk_div2;
    end
endmodule

module q27_div4_counter (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div4
);
    reg [1:0] cnt;

    // Method: free-running binary counter.
    // Equation: counter bit k has frequency f_in / 2^(k+1).
    // Here k=1, so cnt[1] = f_in/4.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 2'b00;
        else
            cnt <= cnt + 2'b01;
    end

    assign clk_div4 = cnt[1];
endmodule

module q27_div8_counter (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div8
);
    reg [2:0] cnt;

    // Same counter-bit method.
    // cnt[2] toggles at f_in/8.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 3'b000;
        else
            cnt <= cnt + 3'b001;
    end

    assign clk_div8 = cnt[2];
endmodule

module q27_div3_duty50 (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div3
);
    reg [1:0] cnt_p;
    reg risepulse;
    reg negpulse;

    // Method for odd divider with ~50% duty:
    // 1) mod-3 counter on posedge: 0->1->2->0
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt_p <= 2'b00;
        else if (cnt_p == 2'b10)
            cnt_p <= 2'b00;
        else
            cnt_p <= cnt_p + 2'b01;
    end

    // 2) Generate pulse on one phase (here phase 2).
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            risepulse <= 1'b0;
        else if (cnt_p == 2'b10)
            risepulse <= 1'b1;
        else
            risepulse <= 1'b0;
    end

    // 3) Copy on negedge to extend by half-cycle.
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            negpulse <= 1'b0;
        else
            negpulse <= risepulse;
    end

    // 4) OR of both registered paths gives divide-by-3 output.
    assign clk_div3 = risepulse | negpulse;
endmodule

module q27_divn_tick #(
    parameter integer DIV_N = 10
) (
    input  wire clk,
    input  wire rst_n,
    input  wire enable,
    output reg  tick
);
    function integer clog2;
        input integer value;
        integer v;
        begin
            v = value - 1;
            clog2 = 0;
            while (v > 0) begin
                v = v >> 1;
                clog2 = clog2 + 1;
            end
        end
    endfunction

    localparam integer DIV_SAFE = (DIV_N < 2) ? 2 : DIV_N;
    localparam integer CNT_W = clog2(DIV_SAFE);
    reg [CNT_W-1:0] cnt;

    // Method: modulo-N counter + terminal-count pulse.
    // Equation: tick asserted once every N input clocks.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= {CNT_W{1'b0}};
            tick <= 1'b0;
        end else if (enable) begin
            if (cnt == DIV_SAFE-1) begin
                cnt <= {CNT_W{1'b0}};
                tick <= 1'b1;
            end else begin
                cnt <= cnt + 1'b1;
                tick <= 1'b0;
            end
        end else begin
            tick <= 1'b0;
        end
    end
endmodule
