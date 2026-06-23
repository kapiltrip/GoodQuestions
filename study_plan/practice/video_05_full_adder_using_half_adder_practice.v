// Video 05 / Q5
// Question: Verilog Code for Full Adder using Half Adder | Gate Level Modeling | All about VLSI ||
// Link: https://www.youtube.com/watch?v=VbtIJPZhXLo&list=PLqPfWwayuBvPYYQS2h5p622vGR6aZIfux&index=5
// Topic: Full Adder using Half Adder
// Write your practice code here.
// Try building half adder first, then use it inside full adder.
// Lecture 05 - Full Adder using Half Adder Practice
// Write your gate-level design here.
//  
// Practice idea:
// 1. Build a half adder module first.
// 2. Instantiate two half adders inside the full adder.
// 3. OR the two carry outputs to make cout.
// 4. Keep this file for design modules only.
module fullAdderUsingHalfAdder(
  input wire a,b,cin,
  output wire sum,cout
);
  wire w1,w2,w3;
  ha ha1 (
    .a(a),
    .b(b),
    .sum(w1),
    .cout(w2)
  );
  ha ha2 (
    .a(w1),
    .b(cin),
    .sum(sum),
    .cout(w3)
  );
  or g3 (cout , w3,w2);
  
endmodule
module ha (
  input wire a,b,
  output wire sum,cout
);
  xor g1 (sum, a,b);
  and g2 (cout , a,b);
endmodule

module halfSub(
    input wire a,b,
    output wire diff,borrow
);
wire w1;
xor g1 (diff,a,b); //difference 
not g2 (w1,a); //a bar 
and g3 (borrow , w1,b); //abar . b 

endmodule
module fullSub(
    input wire a,b,bin,
    output wire diff, bout
);
wire w1,w2,w3,w4;
//abar xor b+ b.bin

xor g1(diff,a,b,bin);
not g2(w1,a);
xor g3(w2,w1,b);  
and g4(w3,w2,bin);
and g6(w4,w1,b);
or g5(bout,w4,w3);

endmodule

/*
Equation notes:

Full Adder:
  Sum  = A ^ B ^ Cin
  Cout = A B + (A ^ B) Cin
  Cout = A B + A Cin + B Cin

Full Subtractor:
  Diff = A ^ B ^ Bin
  Bout = (~A) B + ~(A ^ B) Bin
  Bout = (~A) B + (~A) Bin + B Bin
  Bout = (~A) B + ((~A) ^ B) Bin

Remember:
  FA: Cout = A B + (A ^ B) Cin
  FS: Bout = (~A) B + ~(A ^ B) Bin
*/
module fsUsingHs(
    input wire a,b,bin,
    output wire diff, borrow
);    
wire w1,w2,w3;
halfSub hs1(
    .a(a),
    .b(b),
    .diff(w1),
    .borrow(w2)
);
halfSub hs2(
    .a(w1),
    .b(bin),
    .diff(diff),
    .borrow(w3)
);
//will it be or ? 
or g1(borrow,w2,w3);

endmodule
