module q17_gray_counter_case_3bit (
    input  wire       clk,
    input  wire       rst,
    output reg [2:0]  gray
);
    // Q17 asks for Verilog to generate a Gray-code counter.
    // This first method follows the book's direct 3-bit example:
    // keep an ordinary binary counter, then decode each binary state
    // to its corresponding 3-bit Gray-code value.
    reg [2:0] counter;

    // Internal binary count: 000,001,010,...,111,000,...
    always @(posedge clk or posedge rst) begin
        if (rst)
            counter <= 3'b000;
        else
            counter <= counter + 3'b001;
    end

    // Method 1: explicit binary-to-Gray decode table.
    // Output Gray sequence:
    // 000,001,011,010,110,111,101,100
    always @* begin
        case (counter)
            3'b000: gray = 3'b000;
            3'b001: gray = 3'b001;
            3'b010: gray = 3'b011;
            3'b011: gray = 3'b010;
            3'b100: gray = 3'b110;
            3'b101: gray = 3'b111;
            3'b110: gray = 3'b101;
            default: gray = 3'b100;
        endcase
    end
endmodule

module q17_bin_to_gray #(parameter N = 4) (
    input  wire [N-1:0] bin,
    output wire [N-1:0] gray
);
    // Direct binary-to-Gray conversion:
    // gray = binary ^ (binary >> 1)
    assign gray = bin ^ (bin >> 1);
endmodule

module q17_gray_to_bin #(parameter N = 4) (
    input  wire [N-1:0] gray,
    output reg  [N-1:0] bin
);
    integer i;

    // Direct Gray-to-binary conversion:
    // bin[MSB] = gray[MSB]
    // bin[i]   = bin[i+1] ^ gray[i]
    always @* begin
        bin[N-1] = gray[N-1];
        for (i = N-2; i >= 0; i = i - 1)
            bin[i] = bin[i+1] ^ gray[i];
    end
endmodule

module q17_gray_counter_xor #(parameter N = 4) (
    input  wire         clk,
    input  wire         rst,
    output wire [N-1:0] gray
);
    // This second method is the scalable version of the same idea.
    // We still count in binary internally, but convert that binary count
    // to Gray code at the output using the standard XOR relation:
    // gray = binary ^ (binary >> 1)
    //
    // Note: the register name comes from the source example, but here it is
    // simply an N-bit binary counter, not a decimal-only BCD counter.
    reg [N-1:0] bin_counter;

    // Internal binary count increments once per clock.
    always @(posedge clk or posedge rst) begin
        if (rst)
            bin_counter <= {N{1'b0}};
        else
            bin_counter <= bin_counter + {{(N-1){1'b0}}, 1'b1};
    end

    // Method 2: generic binary-to-Gray conversion.
    // For example, for 4 bits:
    // gray[3] = bin[3]
    // gray[2] = bin[3] ^ bin[2]
    // gray[1] = bin[2] ^ bin[1]
    // gray[0] = bin[1] ^ bin[0]
    assign gray = bin_counter ^ (bin_counter >> 1);
endmodule
