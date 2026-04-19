# PDF Theory Answers (Q8-Q11)

## 8) What circuit would synthesis create for previous mux coding styles?

The previous question coded a 4:1 mux in three styles:

- nested conditional operator: `?:`
- combinational `if / else if / else`
- combinational `case`

For normal binary values of `sel`, all three styles describe this same function:

```verilog
sel = 2'b00 -> y = a
sel = 2'b01 -> y = b
sel = 2'b10 -> y = c
sel = 2'b11 -> y = d
```

So the expected synthesis result is a **4:1 multiplexer**, or an equivalent optimized gate/LUT network.

Equivalent Boolean expression:

```verilog
y = (~sel[1] & ~sel[0] & a) |
    (~sel[1] &  sel[0] & b) |
    ( sel[1] & ~sel[0] & c) |
    ( sel[1] &  sel[0] & d);
```

Equivalent 2:1 mux tree:

```verilog
m0 = sel[0] ? b : a;
m1 = sel[0] ? d : c;
y  = sel[1] ? m1 : m0;
```

### Style 1: conditional operator `?:`

```verilog
assign y = (sel == 2'b00) ? a :
           (sel == 2'b01) ? b :
           (sel == 2'b10) ? c : d;
```

This is a nested selection expression. Synthesis tools commonly lower this into mux logic. Yosys documentation explicitly says muxes are generated for Verilog `?:` expressions.

### Style 2: `if / else if / else`

```verilog
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
```

This source code has **priority-like semantics**: the first true condition wins.

However, in this exact mux, the conditions are mutually exclusive:

```verilog
sel == 2'b00
sel == 2'b01
sel == 2'b10
```

`sel` cannot be `00` and `01` at the same time. Because of that, synthesis can optimize the priority-looking source code into the same 4:1 mux function.

If the conditions overlap, then priority is real hardware:

```verilog
if (req[3])
    y = a;
else if (req[2])
    y = b;
else if (req[1])
    y = c;
else
    y = d;
```

If `req = 4'b1100`, both `req[3]` and `req[2]` are true, but `req[3]` wins. That is a priority encoder / priority mux style.

### Style 3: `case`

```verilog
always @(*) begin
    case (sel)
        2'b00: y = a;
        2'b01: y = b;
        2'b10: y = c;
        default: y = d;
    endcase
end
```

This is usually the clearest way to code an encoded mux. It reads like a truth table: each value of `sel` selects one input.

The `default` is important because it makes the case complete. Without a `default`, an unhandled select value can leave `y` unassigned.

### Full case and latch risk

A combinational block must assign every output on every path.

Bad incomplete example:

```verilog
always @(*) begin
    if (sel == 2'b00)
        y = a;
    else if (sel == 2'b01)
        y = b;
    else if (sel == 2'b10)
        y = c;
end
```

Here, when `sel == 2'b11`, `y` is not assigned. To preserve the previous value of `y`, synthesis may infer a latch. That is usually accidental and unwanted.

Good complete example:

```verilog
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
```

Same idea with `case`:

```verilog
always @(*) begin
    case (sel)
        2'b00: y = a;
        2'b01: y = b;
        2'b10: y = c;
        default: y = d;
    endcase
end
```

### Parallel case

A case is "parallel" when only one case item can match at a time.

This is parallel for normal 0/1 values:

```verilog
case (sel)
    2'b00: y = a;
    2'b01: y = b;
    2'b10: y = c;
    default: y = d;
endcase
```

These case values do not overlap.

Overlapping cases, especially with `casez` or `casex`, can create priority behavior:

```verilog
casez (req)
    4'b1???: y = a;
    4'b?1??: y = b;
    4'b??1?: y = c;
    default: y = d;
endcase
```

If `req = 4'b1100`, both the first and second items match. The first one wins in simulation, so this describes priority behavior.

### Interview answer

Do not stop at:

```text
if/else makes priority hardware and case makes mux hardware
```

That is too shallow.

Better answer:

```text
All three Q7 styles can synthesize to equivalent 4:1 mux hardware because the select choices are mutually exclusive and fully covered. The if/else and nested ?: styles have priority-like source-code semantics, but the priority does not change the hardware for this exact 2-bit encoded mux. A case statement is usually the clearest way to describe this truth-table-like mux. If the conditions overlap, priority hardware is required. If assignments are incomplete, latch inference can happen.
```

### Simulation note

For normal `0` and `1` values, all three versions behave the same.

With `X` or `Z` values in simulation, `?:`, `if/else`, and `case` can behave differently. That is simulator unknown-value behavior. The synthesized hardware is still real 0/1 hardware, so the RTL should be written to clearly express the intended hardware, not to depend on accidental `X` behavior.

### Practical rule

- Use `?:` for small simple selections, especially 2:1 muxes.
- Use `case` for encoded muxes like 4:1, 8:1, etc.
- Use `if / else if` when you intentionally want priority.
- In combinational `always @(*)` blocks, assign outputs in every branch.
- Use a final `else`, a `default`, or a default assignment at the top of the block to avoid accidental latches.

Sources checked:

- AMD Vivado UG901 Synthesis Guide: documents Verilog mux case coding and priority-processing considerations.  
  https://docs.amd.com/r/en-US/ug901-vivado-synthesis
- Yosys documentation: muxes are generated for `?:` expressions and process decision trees are mapped to mux logic.  
  https://yosyshq.readthedocs.io/projects/yosys/en/v0.50/cell/word_mux.html
- Intel/Altera Quartus HDL Coding Styles: missing final `else` or `default` can infer latches; `full_case` can create simulation/synthesis mismatch because it gives synthesis information not used by simulation.  
  https://community.altera.com/t5/s/jgyke29768/attachments/jgyke29768/quartus-prime/73810/2/HDL_Coding_styles_intel.pdf
- Clifford Cummings, `"full_case parallel_case", the Evil Twins of Verilog`: explains full case, parallel case, latch inference, priority encoders, and why blindly using `full_case` / `parallel_case` directives is risky.  
  https://csg.csail.mit.edu/6.375/6_375_2009_www/papers/cummings-case-snug99.pdf

## 9) Asynchronous vs synchronous reset flip-flops (pros/cons)

Asynchronous reset:
- Reset takes effect immediately (clock not required).
- Useful for power-on reset behavior.
- Needs careful reset deassertion handling to avoid timing/metastability issues across domains.

Synchronous reset:
- Reset only applied on active clock edge.
- Easier timing closure in many synchronous flows.
- Requires clock to be running for reset to take effect.

## 10) Latch vs flip-flop output behavior

- Latch (level-sensitive): output follows input while `clk=1`; holds value while `clk=0`.
- Flip-flop (edge-triggered): output updates only on the active clock edge (here, rising edge).

## 11) Edge detection timing explanation (including remaining part)

Using:
- delayed sample register `q_prev`
- `rising = d & ~q_prev`
- `falling = ~d & q_prev`
- `toggle = d ^ q_prev`

Waveform behavior:
- When `d` transitions `0 -> 1`, `rising` pulses high for one clock interval.
- When `d` transitions `1 -> 0`, `falling` pulses high for one clock interval.
- `toggle` pulses on both transitions, so it is high whenever either `rising` or `falling` is high.
- In the shown continuation timing diagram, you get one `rising` pulse near the first upward transition and one `falling` pulse near the later downward transition; `toggle` pulses at both events.
