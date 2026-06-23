// Video 06 / Q6
// Question: BCD and Ripple Carry Adder (RCA) Using GLM in Verilog | Digital Design Explained
// Link: https://www.youtube.com/watch?v=_dqCK0T3d8E&list=PLqPfWwayuBvPYYQS2h5p622vGR6aZIfux&index=6
// Write your practice code here.
// Start with ripple-carry-adder structure, then add BCD correction logic when ready.
module fullAdder(
    input wire a,b,cin,
    output wire sum, cout
);
assign sum= a^b^cin;
assign cout = a &b | b&cin | cin &a ;

endmodule
module ripplyCarryAdder(
    input wire [3:0] a,b,
    input wire cin,
    output wire [3:0] sum,
    output wire cout
);
wire [4:0] carry ;  // to remember that, the carry will have 5 bits, 0 to 4 

assign carry[0]=cin;
assign cout=carry[4];
genvar i;
generate
    for(i=0;i<4;i=i+1) begin : FA_STATE
        fullAdder fa1(
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])

);
    end
endgenerate
endmodule