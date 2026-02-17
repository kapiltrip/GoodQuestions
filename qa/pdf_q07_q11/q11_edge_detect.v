module q11 (
    input  wire clk,
    input  wire rst,
    input  wire d,
    output wire rising,
    output wire falling,
    output wire toggle
);
    reg q_prev;

    always @(posedge clk or posedge rst) begin
        if (rst)
            q_prev <= 1'b0;
        else
            q_prev <= d;
    end

    assign toggle  = d ^ q_prev;
    assign falling = (~d) & q_prev;
    assign rising  = d & (~q_prev);
endmodule
