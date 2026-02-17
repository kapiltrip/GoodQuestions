module q22_time_ticks (
    input  wire clk,
    input  wire rst_n,
    input  wire one_ms_pulse,
    output wire second,
    output wire minute,
    output wire hour
);
    reg [9:0] ms_counter;
    reg [5:0] sec_counter;
    reg [5:0] min_counter;

    assign second = one_ms_pulse && (ms_counter == 10'd999);
    assign minute = second && (sec_counter == 6'd59);
    assign hour   = minute && (min_counter == 6'd59);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ms_counter <= 10'd0;
        end else if (one_ms_pulse) begin
            if (ms_counter == 10'd999)
                ms_counter <= 10'd0;
            else
                ms_counter <= ms_counter + 10'd1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sec_counter <= 6'd0;
        end else if (second) begin
            if (sec_counter == 6'd59)
                sec_counter <= 6'd0;
            else
                sec_counter <= sec_counter + 6'd1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            min_counter <= 6'd0;
        end else if (minute) begin
            if (min_counter == 6'd59)
                min_counter <= 6'd0;
            else
                min_counter <= min_counter + 6'd1;
        end
    end
endmodule
