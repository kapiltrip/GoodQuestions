module q24_fir_5tap #(
    parameter integer DATA_W  = 16,
    parameter integer COEFF_W = 16,
    parameter signed [COEFF_W-1:0] C1 = 1,
    parameter signed [COEFF_W-1:0] C2 = 2,
    parameter signed [COEFF_W-1:0] C3 = 3,
    parameter signed [COEFF_W-1:0] C4 = 2,
    parameter signed [COEFF_W-1:0] C5 = 1,
    parameter integer OUT_W = DATA_W + COEFF_W + 3
) (
    input  wire                          clk,
    input  wire                          rst_n,
    input  wire signed [DATA_W-1:0]      sample_in,
    output reg  signed [OUT_W-1:0]       sample_out
);
    localparam integer PROD_W = DATA_W + COEFF_W;

    reg signed [DATA_W-1:0] d1;
    reg signed [DATA_W-1:0] d2;
    reg signed [DATA_W-1:0] d3;
    reg signed [DATA_W-1:0] d4;

    wire signed [PROD_W-1:0] m1 = sample_in * C1;
    wire signed [PROD_W-1:0] m2 = d1 * C2;
    wire signed [PROD_W-1:0] m3 = d2 * C3;
    wire signed [PROD_W-1:0] m4 = d3 * C4;
    wire signed [PROD_W-1:0] m5 = d4 * C5;

    function signed [OUT_W-1:0] sx;
        input signed [PROD_W-1:0] v;
        begin
            sx = {{(OUT_W-PROD_W){v[PROD_W-1]}}, v};
        end
    endfunction

    wire signed [OUT_W-1:0] y_next;
    assign y_next = sx(m1) + sx(m2) + sx(m3) + sx(m4) + sx(m5);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            d1 <= {DATA_W{1'b0}};
            d2 <= {DATA_W{1'b0}};
            d3 <= {DATA_W{1'b0}};
            d4 <= {DATA_W{1'b0}};
            sample_out <= {OUT_W{1'b0}};
        end else begin
            sample_out <= y_next;
            d4 <= d3;
            d3 <= d2;
            d2 <= d1;
            d1 <= sample_in;
        end
    end
endmodule
