module mux2_gatelevel (
    input  wire a,
    input  wire b,
    input  wire sel,
    output wire y
);
    wire nsel;
    wire w0;
    wire w1;

    not u0(nsel, sel);
    and u1(w0, a, nsel);
    and u2(w1, b, sel);
    or  u3(y, w0, w1);
endmodule
