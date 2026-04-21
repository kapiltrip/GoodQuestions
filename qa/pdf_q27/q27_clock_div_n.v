module clk_div_n #(
    parameter integer N = 4
) (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
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

    localparam integer WIDTH = clog2(N);
    localparam integer HALF  = N / 2;

    // Counts input clock cycles in sequence: 0, 1, ... N-1, then repeats.
    reg [WIDTH-1:0] counter;
    // Posedge-generated divided clock. Exact 50% duty for even N.
    reg pos;
    // Delayed copy of pos taken on the falling edge.
    // Used to extend odd-N high time by half an input clock cycle.
    reg neg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= {WIDTH{1'b0}};
            pos <= 1'b0;
        end else begin
            if (counter == N-1)
                counter <= {WIDTH{1'b0}};
            else
                counter <= counter + 1'b1;

            pos <= (counter < HALF);
        end
    end

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            neg <= 1'b0;
        else
            neg <= pos;
    end

    wire duty_even = pos;
    wire duty_odd  = pos | neg;

    assign clk_div = ((N % 2) == 0) ? duty_even:
                                      duty_odd;
endmodule
