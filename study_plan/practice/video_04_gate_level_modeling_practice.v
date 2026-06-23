// Video 04 / Q4
// Question: Introduction to Gate Level Modeling in Verilog | Getting Started with Vivado Tool Interface
// Link: https://www.youtube.com/watch?v=c-qxVcc-FbI&list=PLqPfWwayuBvPYYQS2h5p622vGR6aZIfux&index=4
// Topic: Introduction to Gate Level Modeling in Verilog
// Write your practice code here.
// Start with simple gate primitives: and, or, not, xor, nand, nor, xnor.
// Lecture 04 - Gate Level Modeling Practice
// Write your gate-level design here.
//
// Practice ideas:
// 1. Start with simple gates: and, or, not, xor.
// 2. Then try nand, nor, xnor.
// 3. Remember gate primitive syntax: gate_type (output, input1, input2);
// 4. Keep this file for the design only.
//buit in gates, are called primitives, and or not xor nand nor xor xnor buffif1 
//bufif0 notif1 notif0 
//not gate 
//bufif1 (active high input ), bufif0 (output ,input , control )
//half adder 
module ha (
  input wire a,b,
  output sum, carry
);
  xor g1 (sum,a,b);
  and g2 (carry,a,b); 
endmodule

module fullAdder (
    input wire a,b,cin,
    output wire sum, cout
);
  wire w1,w2,w3;
  
  xor g1 (sum, a,b,cin);
  and g2 (w1,a,b);      //ab
  and g3 (w2 , b,cin) ; //bc
  and g4 (w3 , a, cin); //ac
  or g5 (cout , w1,w2,w3);
  
  endmodule






