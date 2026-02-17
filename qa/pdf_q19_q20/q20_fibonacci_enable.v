module q20_fibonacci_enable
#(
    parameter WIDTH = 32
)
(
    input  wire              clk,
    input  wire              rst_n,
    input  wire              enable,
    output wire [WIDTH-1:0]  sum,
    output reg  [WIDTH-1:0]  cur_num,
    output reg  [WIDTH-1:0]  next_num
);

    assign sum = cur_num + next_num;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cur_num  <= {WIDTH{1'b0}};
            next_num <= {{(WIDTH-1){1'b0}}, 1'b1};
        end else if (enable) begin
            cur_num  <= next_num;
            next_num <= sum;
        end
    end
endmodule
