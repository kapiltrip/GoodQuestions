module div3(
    input wire clk ,  rst , 
    input wire x,
    output wire isdiv
);
reg [1:0] state,next_state;
localparam [1:0] mod0=2'd0; //remainder ==0
localparam [1:0] mod1=2'd1;
localparam [1:0] mod2 =2'd2; //remainder ==2
always @(posedge clk or posedge rst)begin
    if(rst)
        state<=mod0;
    else 
        state<=next_state;
end
always @(*)begin
    case (state)
        mod0:next_state=(x)?mod1:mod0;
        mod1:next_state=(x)?mod0:mod2;
        mod2:next_state=(x)?mod2:mod1;
        default : next_state=mod0;


    endcase 
end
assign isdiv=(state ==mod0);

endmodule