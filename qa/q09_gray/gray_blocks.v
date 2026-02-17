module bin_counter_gray_out #(parameter N = 4)(
    input              clk,
    input              rst_n,
    output     [N-1:0] gray
);
reg [N-1:0] bin;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        bin <= {N{1'b0}};
    else
        bin <= bin + 1'b1;
end

assign gray = bin ^ (bin >> 1);

endmodule

module bin_to_gray #(parameter N = 4)(
    input      [N-1:0] bin,
    output     [N-1:0] gray
);
assign gray = bin ^ (bin >> 1);
endmodule

module gray_to_bin #(parameter N = 4)(
    input      [N-1:0] gray,
    output reg [N-1:0] bin
);
integer i;

always @* begin
    bin[N-1] = gray[N-1];
    for (i = N-2; i >= 0; i = i - 1)
        bin[i] = bin[i+1] ^ gray[i];
end
endmodule

module gray_counter_store_gray #(parameter N = 4)(
    input              clk,
    input              rst_n,
    output reg [N-1:0] gray_q,
    output     [N-1:0] bin_q
);
reg  [N-1:0] bin_now;
wire [N-1:0] bin_next;
wire [N-1:0] gray_next;

integer i;

always @* begin
    bin_now[N-1] = gray_q[N-1];
    for (i = N-2; i >= 0; i = i - 1)
        bin_now[i] = bin_now[i+1] ^ gray_q[i];
end

assign bin_next  = bin_now + 1'b1;
assign gray_next = bin_next ^ (bin_next >> 1);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        gray_q <= {N{1'b0}};
    else
        gray_q <= gray_next;
end

assign bin_q = bin_now;

endmodule
