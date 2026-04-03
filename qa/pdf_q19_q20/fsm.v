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
    // Default: stay in the current state unless a transition overrides it.
    next_state=state;
    case (state)
        mod0:if (x) next_state=mod1;
        mod1:next_state=(x)?mod0:mod2;
        mod2:if (!x) next_state=mod1;
        default : next_state=mod0;


    endcase 
end
assign isdiv=(state ==mod0);

endmodule
