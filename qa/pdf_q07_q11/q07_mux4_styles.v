module q07_a (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire [1:0] sel,
    output wire y
);
    assign y = (sel == 2'b00) ? a :
               (sel == 2'b01) ? b :
               (sel == 2'b10) ? c : d;
endmodule

module q07_b (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire [1:0] sel,
    output reg  y
);
    always @(*) begin
        if (sel == 2'b00)
            y = a;
        else if (sel == 2'b01)
            y = b;
        else if (sel == 2'b10)
            y = c;
        else
            y = d;
    end
endmodule

/*
Q8 STUDY NOTE: What circuit does synthesis create from these mux styles?

Short answer:
    q07_a, q07_b, and q07_c all describe the same 4:1 multiplexer.
    A synthesis tool should create a 4-input selection circuit for y:

        sel = 2'b00 -> y = a
        sel = 2'b01 -> y = b
        sel = 2'b10 -> y = c
        sel = 2'b11 -> y = d

    The final gates/LUTs/cells may look different depending on the synthesis
    tool and target technology, but the RTL intent is a 4:1 mux.

Equivalent Boolean form:
    y = (~sel[1] & ~sel[0] & a) |
        (~sel[1] &  sel[0] & b) |
        ( sel[1] & ~sel[0] & c) |
        ( sel[1] &  sel[0] & d);

Equivalent 2:1 mux tree form:
    m0 = sel[0] ? b : a;
    m1 = sel[0] ? d : c;
    y  = sel[1] ? m1 : m0;

Style q07_a: nested conditional operator
    assign y = (sel == 2'b00) ? a :
               (sel == 2'b01) ? b :
               (sel == 2'b10) ? c : d;

    The ?: operator is a selection operator. Yosys documentation says the
    Verilog frontend generates muxes for ?: expressions. For this 4:1 mux,
    the nested ?: chain is commonly implemented as a tree of 2:1 muxes or
    optimized into an equivalent LUT/gate structure.

Style q07_b: if / else-if / else
    always @(*) begin
        if (sel == 2'b00)
            y = a;
        else if (sel == 2'b01)
            y = b;
        else if (sel == 2'b10)
            y = c;
        else
            y = d;
    end

    Source-code semantics are priority-like: test the first condition, then
    the second, then the third, then the final else. That matters if conditions
    can overlap.

    In this exact mux, the conditions are mutually exclusive:
        sel cannot be 2'b00 and 2'b01 at the same time.

    So even though if/else is written as a priority chain, a good synthesis
    tool can optimize the logic into the same 4:1 mux function.

    If the conditions were overlapping, the hardware would need priority.
    Example:
        if (req[3])      y = a;
        else if (req[2]) y = b;
        else if (req[1]) y = c;
        else             y = d;

    If req = 4'b1100, both req[3] and req[2] are true, but req[3] wins.
    That is a priority encoder / priority mux style, not a plain parallel mux.

Style q07_c: case statement
    always @(*) begin
        case (sel)
            2'b00: y = a;
            2'b01: y = b;
            2'b10: y = c;
            default: y = d;
        endcase
    end

    This is usually the clearest coding style for a mux selected by an encoded
    select signal. It looks like a truth table: each sel value chooses one data
    input.

Full case:
    A case or if/else mux must assign y for every possible select value.
    Here, q07_c is full because default covers anything not listed. q07_b is
    full because the final else covers anything not matched earlier. q07_a is
    full because the last ": d" covers the remaining case.

    If a combinational always block does not assign y on some path, synthesis
    may infer a latch so y can remember its old value.

Bad incomplete mux example:
    always @(*) begin
        if (sel == 2'b00)
            y = a;
        else if (sel == 2'b01)
            y = b;
        else if (sel == 2'b10)
            y = c;
        // Missing assignment for sel == 2'b11.
        // Hardware now needs memory to hold old y -> latch risk.
    end

Parallel case:
    A case is "parallel" when only one case item can match at a time. This
    q07_c case is parallel for normal 0/1 select values because 2'b00, 2'b01,
    and 2'b10 are distinct. The default covers the rest.

    A non-parallel or overlapping case can describe priority behavior. This is
    common with casez/casex or wildcard patterns.

Important interview answer:
    Do not simply say "if/else makes priority hardware and case makes mux
    hardware." That is too shallow.

    Better:
        if/else has priority semantics in the source code.
        case is commonly used to write truth-table-like mux logic.
        When all choices are mutually exclusive and fully covered, synthesis
        can optimize all three Q7 styles to equivalent 4:1 mux hardware.
        If choices overlap, priority matters.
        If choices are incomplete, latch inference can happen.

Simulation note:
    For normal 0/1 values of sel, all three modules behave the same.
    With X/Z values in simulation, ?:, if/else, and case can propagate or hide
    unknowns differently. Synthesis mostly targets real 0/1 hardware, so do not
    rely only on X behavior to define intended hardware.

Practical RTL rule:
    - For simple 2:1 choices, ?: is compact.
    - For encoded muxes like this 4:1 mux, case is usually the most readable.
    - For intentional priority encoders, if/else-if is usually clearest.
    - In combinational always blocks, assign every output in every path.
    - Prefer default assignments or final else/default branches to avoid
      accidental latches.

Sources checked:
    - AMD Vivado UG901 Synthesis Guide:
      documents mux case examples and priority-processing considerations.
      https://docs.amd.com/r/en-US/ug901-vivado-synthesis

    - Yosys documentation:
      ?: expressions and process decision trees are converted to mux cells.
      https://yosyshq.readthedocs.io/projects/yosys/en/v0.50/cell/word_mux.html

    - Intel/Altera Quartus HDL Coding Styles:
      missing final else/default clauses can infer latches; full_case can cause
      simulation/synthesis mismatch because it is synthesis-only information.

    - Clifford Cummings, "full_case parallel_case", the Evil Twins of Verilog:
      explains full case, parallel case, latch inference, priority encoders,
      and why blindly using full_case/parallel_case directives is risky.
*/

module q07_c (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire [1:0] sel,
    output reg  y
);
    always @(*) begin
        case (sel)
            2'b00: y = a;
            2'b01: y = b;
            2'b10: y = c;
            default: y = d;
        endcase
    end
endmodule
