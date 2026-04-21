module clk_div_n_duty #(
    parameter integer DIV_BY = 10,
    // DUTY_OPTION:
    // 0 -> use CUSTOM_DUTY_PERCENT
    // 1 -> 20%
    // 2 -> 30%
    // 3 -> 40%
    // 4 -> 50%
    // 5 -> 60%
    // 6 -> 70%
    // 7 -> 80%
    // 8 -> 90%
    parameter integer DUTY_OPTION = 4,
    parameter integer CUSTOM_DUTY_PERCENT = 50
) (
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
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

    localparam integer WIDTH = clog2(DIV_BY);
    localparam integer DUTY_PERCENT = (DUTY_OPTION == 1) ? 20 :
                                      (DUTY_OPTION == 2) ? 30 :
                                      (DUTY_OPTION == 3) ? 40 :
                                      (DUTY_OPTION == 4) ? 50 :
                                      (DUTY_OPTION == 5) ? 60 :
                                      (DUTY_OPTION == 6) ? 70 :
                                      (DUTY_OPTION == 7) ? 80 :
                                      (DUTY_OPTION == 8) ? 90 :
                                                           CUSTOM_DUTY_PERCENT;
    localparam integer HIGH_COUNT = (DIV_BY * DUTY_PERCENT) / 100;

    // Counts input clock cycles in sequence: 0, 1, ... DIV_BY-1, then repeats.
    reg [WIDTH-1:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= {WIDTH{1'b0}};
            clk_div <= 1'b0;
        end else begin
            if (counter == DIV_BY-1)
                counter <= {WIDTH{1'b0}};
            else
                counter <= counter + 1'b1;

            clk_div <= (counter < HIGH_COUNT);
        end
    end
endmodule
