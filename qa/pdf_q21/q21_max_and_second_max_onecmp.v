module q21_max_and_second_max_onecmp #(
    parameter WIDTH = 8
) (
    input  wire             clk,
    input  wire             rst,
    input  wire             clear,
    input  wire             in_valid,
    input  wire [WIDTH-1:0] in_data,
    output wire             in_ready,
    output reg  [WIDTH-1:0] max1,
    output reg  [WIDTH-1:0] max2,
    output reg              max1_valid,
    output reg              max2_valid
);
    localparam S_IDLE = 2'd0;
    localparam S_CMP1 = 2'd1;
    localparam S_CMP2 = 2'd2;

    reg [1:0] state;
    reg [WIDTH-1:0] sample_r;

    // One shared comparator used in both compare stages.
    wire [WIDTH-1:0] cmp_b = (state == S_CMP1) ? max1 : max2;
    wire cmp_ge = (sample_r >= cmp_b);

    assign in_ready = (state == S_IDLE);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= S_IDLE;
            sample_r <= {WIDTH{1'b0}};
            max1 <= {WIDTH{1'b0}};
            max2 <= {WIDTH{1'b0}};
            max1_valid <= 1'b0;
            max2_valid <= 1'b0;
        end else if (clear) begin
            state <= S_IDLE;
            sample_r <= {WIDTH{1'b0}};
            max1 <= {WIDTH{1'b0}};
            max2 <= {WIDTH{1'b0}};
            max1_valid <= 1'b0;
            max2_valid <= 1'b0;
        end else begin
            case (state)
                S_IDLE: begin
                    if (in_valid) begin
                        sample_r <= in_data;
                        state <= S_CMP1;
                    end
                end

                S_CMP1: begin
                    if (!max1_valid || cmp_ge) begin
                        max2 <= max1;
                        max2_valid <= max1_valid;
                        max1 <= sample_r;
                        max1_valid <= 1'b1;
                        state <= S_IDLE;
                    end else begin
                        state <= S_CMP2;
                    end
                end

                S_CMP2: begin
                    if (!max2_valid || cmp_ge) begin
                        max2 <= sample_r;
                        max2_valid <= 1'b1;
                    end
                    state <= S_IDLE;
                end

                default: state <= S_IDLE;
            endcase
        end
    end
endmodule
