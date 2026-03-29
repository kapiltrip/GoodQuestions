# Revision

## Index

- [1) Procedural vs sequential vs sequential logic](#1-procedural-vs-sequential-vs-sequential-logic)
- [2) Shift operators and why `a << 2` is bit-level, not arithmetic `*`](#2-shift-operators-and-why-a--2-is-bit-level-not-arithmetic-)
- [3) Four synthesizable styles for a 4:1, 1-bit mux](#3-four-synthesizable-styles-for-a-41-1-bit-mux)
- [4) FSM Q&A: why `y` is `reg` but uses blocking assignment](#4-fsm-qa-why-y-is-reg-but-uses-blocking-assignment)
- [5) Why `q <= ~q;` means `Qn+1 = ~Qn` in a clocked block](#5-why-q--q-means-qn1--qn-in-a-clocked-block)

## 1) Procedural vs sequential vs sequential logic

Yes — the easiest way to understand this is to separate **three different ideas** that often get mixed together in HDL:

1. **procedural**
2. **sequential execution**
3. **sequential logic**

They are related, but they are **not the same thing**. The Verilog standard explicitly distinguishes procedural assignments/flows from sequential and parallel blocks, and says each `initial`/`always` creates its own concurrent activity flow. ([Bucknell University][1])

## 1) What “procedural” means

**Procedural** means: the code is written as a **process** that executes statements step by step during simulation. In the standard’s wording, **procedural assignments** are the basic **behavioral** construct, as opposed to continuous assignments, which are the basic **structural** construct. Also, each `initial` and each `always` starts its own **activity flow**. ([Bucknell University][1])

So this is **procedural code**:

```verilog
always @(*) begin
    x = a & b;
    y = x | c;
end
```

because it is written inside an `always` process.

A simple way to remember it:

- **procedural** = “written like instructions inside a process”
- **not procedural** = things like continuous assignment, for example:

```verilog
assign y = a & b;
```

So **procedural** answers the question:
**“What kind of coding style/construct is this?”** ([Bucknell University][1])

---

## 2) What “sequential” means in code execution

In Verilog, a **sequential block** is specifically a `begin ... end` block. The standard says the statements inside a sequential block are executed **in the given order**, **one after another**. ([Bucknell University][1])

Example:

```verilog
begin
    a = b;
    c = a;
end
```

This means:

- first execute `a = b;`
- then execute `c = a;`

That is **sequential execution**.

So **sequential** here answers a different question:
**“How do statements run inside this block?”** ([Bucknell University][1])

---

## 3) What “parallel” or “concurrent” means

Now comes the important HDL part.

The standard says each `initial` and each `always` creates its **own activity flow**, and all those activity flows are **concurrent**. Also, `fork ... join` is a parallel block whose statements execute concurrently. ([Bucknell University][1])

So this:

```verilog
always @(*) x = a;

always @(*) y = x;
```

is **not** one top-to-bottom program like C.

It is:

- one process computing `x`
- another process computing `y`

Both are separate concurrent processes.

So in HDL:

- **inside one `begin...end`** → sequential order
- **between different `always` blocks** → concurrent behavior ([Bucknell University][1])

---

## 4) Now the real difference: procedural vs sequential

This is the cleanest statement:

- **Procedural** is a **broad category**
- **Sequential** is one **execution style inside procedural code**

So:

- every sequential block is procedural
- but not everything procedural means “sequential logic”

That is the source of most confusion.

### Example A: procedural, but combinational logic

```verilog
always @(*) begin
    tmp = a ^ b;
    y   = tmp & c;
end
```

This is **procedural** because it is in an `always` block.
It is **sequential execution** because the statements in `begin...end` run in order.
But it represents **combinational logic**, not sequential logic. The ordered execution comes from the sequential block semantics. ([Bucknell University][1])

### Example B: procedural, and sequential logic

```verilog
always @(posedge clk) begin
    q1 <= d;
    q2 <= q1;
end
```

This is also **procedural**.
It also has **sequential execution** as code text inside the `begin...end`.
But now it models **sequential logic** because the process is triggered by a clock edge and uses nonblocking assignments, whose RHS is evaluated now and whose LHS update is scheduled later in the time step. ([Bucknell University][1])

So the key idea is:

> **procedural** tells you the code form  
> **sequential block** tells you statement ordering  
> **sequential logic** tells you the hardware being modeled

---

## 5) Very important: “sequential block” is not the same as “sequential logic”

These two sound similar, but they are different.

### Sequential block

This is a **language construct**:

```verilog
begin
   ...
end
```

Statements run one after another. ([Bucknell University][1])

### Sequential logic

This is a **hardware concept**:

- flip-flops
- registers
- state elements
- output depends on present input **and past state**

A sequential block can describe either:

- combinational logic
- or sequential logic

So you must not equate:

- `begin...end`  **with**
- clocked/register behavior

They are different layers of meaning. The first is syntax/execution order; the second is hardware meaning. The standard’s separate treatment of sequential blocks and nonblocking assignment scheduling is exactly why this distinction exists. ([Bucknell University][1])

---

## 6) Where blocking and non-blocking fit into this

The standard says a **blocking** procedural assignment is executed before later statements in the same sequential block, while a **nonblocking** procedural assignment allows scheduling without blocking the procedural flow and is evaluated in two steps. ([Bucknell University][1])

### Blocking `=`

```verilog
always @(*) begin
    x = a & b;
    y = x | c;
end
```

Because this is one sequential block, `y` sees the updated `x`. ([Bucknell University][1])

### Non-blocking `<=`

```verilog
always @(posedge clk) begin
    q1 <= d;
    q2 <= q1;
end
```

The simulator evaluates RHS values first, then updates the LHS later at the end of the time step, so `q2` gets the **old** `q1`. That is why `<=` matches clocked register behavior much better. ([Bucknell University][1])

---

## 7) Best mental model

Think like this:

- `always` / `initial` = **independent workers**
- `begin ... end` = **the ordered to-do list of one worker**
- multiple workers = **concurrent**
- statements inside one worker’s to-do list = **sequential**
- blocking `=` = **finish this step now**
- nonblocking `<=` = **record the new value now, apply it later** ([Bucknell University][1])

---

## Final takeaway

Do not memorize “procedural = sequential.” That is wrong.

Use this instead:

- **Procedural**: code inside a process such as `always`/`initial`. ([Bucknell University][1])
- **Sequential block**: a `begin...end` block whose statements execute in source order. ([Bucknell University][1])
- **Concurrent processes**: different `always`/`initial` blocks run concurrently. ([Bucknell University][1])
- **Sequential logic**: clocked/stateful hardware, often modeled with `always @(posedge clk)` and nonblocking assignments. ([Bucknell University][1])

The most important exam/interview sentence is:

> **Procedural is a coding/process concept; sequential can mean statement order inside a block, or stateful clocked hardware, depending on context.**

I can next explain this with a **single diagram** showing `procedural vs continuous vs sequential vs concurrent vs sequential logic` in one picture.

## 2) Shift operators and why `a << 2` is bit-level, not arithmetic `*`

Yes, this is operating at the **bit/vector level**.

In Verilog/SystemVerilog:

- `<<` and `>>` are **shift operators**
- they are not the normal arithmetic `*` or `/` operators
- `<<` and `>>` are **logical shifts**
- `<<<` and `>>>` are **arithmetic shifts**

Logical shifts move bits left or right and fill the emptied positions with `0`.

How to classify operators quickly:

```verilog
&  |  ^  ~      // bitwise operators
<< >> <<< >>>   // shift operators
*  /  +  -      // arithmetic operators
```

So `<<` and `>>` are not arithmetic multiply/divide operators. They are **shift operators** acting on bit positions of the vector.

Example:

```verilog
assign mul_by_4 = a << 2;
```

This means:

- take every bit of `a`
- move it 2 places to the left
- fill the 2 empty LSB positions with `0`

So for a fixed shift amount like `2`, this is basically **bit rewiring**, not a general multiplier.

For a 16-bit signal, this is equivalent to:

```verilog
mul_by_4 = {a[13:0], 2'b00};
```

That means:

- the lower 2 bits become `0`
- bits shifted past bit 15 are lost
- it behaves like multiply-by-4 only if the result still fits in 16 bits

Example with an 8-bit value:

```verilog
a        = 8'b0000_0101
a << 2   = 8'b0001_0100
```

So `5 << 2 = 20`, which matches multiplication by 4 for this unsigned example.

Bit view:

```text
a        = 0000 0000 0000 0101
a << 2   = 0000 0000 0001 0100
```

Why people say this is bit-level:

- the hardware is mainly shifting wire positions
- no full multiply array is required for a fixed left shift
- the zeros inserted at the right are part of shift semantics

Important note:

- `a << 2` often behaves like multiply-by-4 for unsigned values
- but conceptually it is still a **shift operation**
- with limited width, high bits can be shifted out and lost

Example of truncation:

```verilog
4'b1111 << 2 = 4'b1100
```

The upper bits are dropped because the result stays within 4 bits.

Similarly:

```verilog
assign div_by_8 = a >> 3;
```

This means:

- move every bit of `a` 3 places right
- fill the left side with `0`

Equivalent 16-bit view:

```verilog
div_by_8 = {3'b000, a[15:3]};
```

For an unsigned signal, this acts like divide-by-8 with the remainder discarded.

One more important point:

- `assign` is a **continuous assignment**
- so this is **combinational logic**
- there is no clock here
- there is no shift-over-time behavior like a shift register
- whenever `a` changes, the shifted output updates immediately

Quick memory line:

> `a << 2` means "move bits left by 2"; it may act like multiply-by-4, but the operator itself is a shift, not a general arithmetic multiply.

Two practical cautions:

1. **Overflow on left shift**
   If high bits are shifted out of the output width, they are lost. So `a << 2` is not always mathematically equal to `a * 4`.

2. **Signed vs unsigned right shift**
   If the value is unsigned, `>>` is fine for divide-by-2^n intuition.
   If the value is signed and negative, `>>>` is usually the correct arithmetic right shift because it preserves the sign bit.

Keywords:

- shift operator
- bit/vector level
- logical shift
- arithmetic shift
- zero fill
- bit rewiring
- fixed shift
- multiply-by-4 intuition
- divide-by-8 intuition
- width truncation
- bits shifted out are lost
- continuous assignment
- combinational logic
- no clock

## 3) Four synthesizable styles for a 4:1, 1-bit mux

Yes, these are four valid **synthesizable** ways to describe the same **4:1, 1-bit mux** in Verilog, once written correctly.

Verilog defines the ternary operator as `expr1 ? expr2 : expr3`. Continuous assignments drive **nets** whenever the right-hand side changes, while procedural `if`/`case` assignments assign to **variables**. That is why the `assign` styles use `wire`, and the `always @(*)` styles use `reg` in plain Verilog. Also, indexed bit-selects can use an expression, which is what makes `data[sel]` legal. ([Bucknell University][1])

### RTL: 4 versions of the same 4:1 mux

```verilog
module mux4to1_ternary (
    input  wire a, b, c, d,
    input  wire [1:0] sel,
    output wire y
);
    assign y = sel[1] ? (sel[0] ? d : c)
                      : (sel[0] ? b : a);
endmodule


module mux4to1_case (
    input  wire a, b, c, d,
    input  wire [1:0] sel,
    output reg  y
);
    always @(*) begin
        case (sel)
            2'b00: y = a;
            2'b01: y = b;
            2'b10: y = c;
            2'b11: y = d;
            default: y = 1'bx;
        endcase
    end
endmodule


module mux4to1_index (
    input  wire a, b, c, d,
    input  wire [1:0] sel,
    output wire y
);
    wire [3:0] data;
    assign data = {d, c, b, a};
    assign y    = data[sel];
endmodule


module mux4to1_ifelse (
    input  wire a, b, c, d,
    input  wire [1:0] sel,
    output reg  y
);
    always @(*) begin
        if      (sel == 2'b00) y = a;
        else if (sel == 2'b01) y = b;
        else if (sel == 2'b10) y = c;
        else if (sel == 2'b11) y = d;
        else                   y = 1'bx;
    end
endmodule
```

### Testbench

```verilog
`timescale 1ns/1ps

module tb_mux4to1;

    reg a, b, c, d;
    reg [1:0] sel;

    wire y_ternary;
    wire y_case;
    wire y_index;
    wire y_ifelse;

    reg expected;

    integer i;

    mux4to1_ternary u1 (
        .a(a), .b(b), .c(c), .d(d),
        .sel(sel),
        .y(y_ternary)
    );

    mux4to1_case u2 (
        .a(a), .b(b), .c(c), .d(d),
        .sel(sel),
        .y(y_case)
    );

    mux4to1_index u3 (
        .a(a), .b(b), .c(c), .d(d),
        .sel(sel),
        .y(y_index)
    );

    mux4to1_ifelse u4 (
        .a(a), .b(b), .c(c), .d(d),
        .sel(sel),
        .y(y_ifelse)
    );

    task check_outputs;
    begin
        case (sel)
            2'b00: expected = a;
            2'b01: expected = b;
            2'b10: expected = c;
            2'b11: expected = d;
            default: expected = 1'bx;
        endcase

        #1;

        if ((y_ternary !== expected) ||
            (y_case    !== expected) ||
            (y_index   !== expected) ||
            (y_ifelse  !== expected)) begin

            $display("FAIL");
            $display("a=%b b=%b c=%b d=%b sel=%b", a, b, c, d, sel);
            $display("expected=%b ternary=%b case=%b index=%b ifelse=%b",
                     expected, y_ternary, y_case, y_index, y_ifelse);
            $stop;
        end
    end
    endtask

    initial begin
        for (i = 0; i < 64; i = i + 1) begin
            {a, b, c, d, sel} = i[5:0];
            check_outputs;
        end

        $display("All tests passed.");
        $finish;
    end

endmodule
```

### How each version synthesizes

For valid `sel` values, all four describe the same function:

```text
m0 = sel[0] ? b : a
m1 = sel[0] ? d : c
y  = sel[1] ? m1 : m0
```

So the logical result is a **4:1 mux**, often realized internally as a tree of **three 2:1 muxes**.

### 1) Ternary version

This is the most direct dataflow description of a mux. Yosys explicitly states that Verilog `?:` expressions generate multiplexer cells, and its `$mux` cell is defined as `Y = S ? B : A`. So this version naturally becomes a mux tree. ([YosysHQ Docs][2])

### 2) `case` version

`case` is a procedural decision structure, so synthesis first builds a decision tree from the `always @(*)` block, then lowers that decision tree into mux logic. Yosys documents this directly: the `proc_mux` pass converts decision trees from `case` and `if-else` statements into trees of multiplexer cells. ([YosysHQ Docs][3])

Because every `sel` value is covered here, this is pure combinational logic. If you leave branches unassigned in a procedural combinational block, a synthesizer can infer a latch instead; Yosys has a dedicated `proc_dlatch` pass for identifying such latches. ([YosysHQ Docs][4])

### 3) Indexed-vector version

`assign y = data[sel];` is a **binary-encoded select**. Yosys has an internal `$bmux` cell for exactly this idea: a binary-encoded multiplexer where each value of `S` selects a different slice of `A`. With `WIDTH=1` and `S_WIDTH=2`, this is a 4:1 mux. ([YosysHQ Docs][2])

This style is compact, but it is easiest to read when the mux inputs are already naturally grouped into a vector.

### 4) `if-else` version

Verilog defines `if-else-if` as an **ordered** decision chain: expressions are evaluated in order, and once one condition is true, the chain terminates. That means the language semantics are **priority semantics**. Synthesis therefore starts from a priority decision tree and lowers it to mux logic. ([Bucknell University][1])

In this specific mux, the conditions `sel == 2'b00`, `01`, `10`, `11` are mutually exclusive, so an optimizer will usually reduce the priority structure to the same ordinary 4:1 mux as the `case` version.

### What the final hardware looks like

Before technology mapping, the tool usually represents these as abstract mux cells or mux trees. After that, technology mapping turns the RTL-equivalent network into cells available in the target architecture. Yosys documents this as a two-step idea: first RTL/netlist lowering, then mapping to the target library. The same mux can map to **LUTs on an FPGA** or to **standard cells on an ASIC**; the `abc` flow supports both FPGA LUT mapping and ASIC standard-cell mapping. ([YosysHQ Docs][5])

So:

- **Behaviorally**: all four are the same mux
- **Internally before mapping**: usually mux trees / encoded mux cells
- **After mapping**:
  - FPGA -> LUT implementation
  - ASIC -> mux cells, or equivalent AOI/OAI/inverter combinations, depending on the library and optimization

### Practical recommendation

For learning and interviews:

- **ternary**: best to show you understand mux dataflow
- **case**: most common RTL style for readable combinational selection
- **if-else**: fine, but remember it has priority semantics
- **indexed vector**: elegant for 1-bit output selected from a packed vector

For clean RTL coding, `case` and ternary are usually the easiest to read for a mux, while the indexed style is the shortest when the inputs are already packed.

## 4) FSM Q&A: why `y` is `reg` but uses blocking assignment

### Q

Why am I declaring `y` as `reg` in the FSM, and then writing:

```verilog
y = (state == SMATCH);
```

with a **blocking assignment**? I thought `reg` usually means non-blocking assignment.

### A

This is a very common confusion.

- In plain Verilog, `reg` does **not** mean the hardware must be a flip-flop.
- `reg` only means the signal is assigned inside a **procedural block** such as `always`.
- So a signal can be declared `reg` and still represent **combinational logic**.

The real rule is not:

- `reg` -> use non-blocking

The real rule is:

- **combinational `always @*`** -> usually use blocking `=`
- **clocked `always @(posedge clk)`** -> usually use non-blocking `<=`

So in the Moore FSM:

```verilog
always @* begin
    next_state = state;
    y = (state == SMATCH);
    ...
end
```

- this block is **combinational**
- `y` is being computed from the current state
- so blocking assignment is the correct style

Why must `y` be `reg` here?

- because in plain Verilog, anything assigned inside an `always` block must be declared `reg`
- if you wanted `y` to be a `wire`, you would move it outside:

```verilog
assign y = (state == SMATCH);
```

That would also be valid.

So the key interview sentence is:

> In Verilog, `reg` means procedurally assigned variable, not necessarily a hardware register. Whether to use `=` or `<=` depends on the type of `always` block, not on the word `reg`.

Short memory rule:

- `reg` answers: "where is it assigned?"
- blocking/non-blocking answers: "how should this procedural logic behave?"
- flip-flop vs combinational is determined by the `always` block style

Extra note:

- In SystemVerilog, people often use `logic` instead of `reg`, which avoids some of this naming confusion.

## 5) Why `q <= ~q;` means `Qn+1 = ~Qn` in a clocked block

Consider:

```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        q <= 1'b0;
    else
        q <= ~q;
end
```

This is interpreted as a flip-flop because:

- the block is triggered by `posedge clk`
- `q` is assigned inside that clocked process
- the assignment style `<=` matches register update behavior

The important mapping is:

- RHS `q` means the **current** stored value, `Qn`
- LHS `q` means the **next** stored value after the active clock edge, `Qn+1`

So:

```verilog
q <= ~q;
```

means:

```text
Qn+1 = ~Qn
```

That is toggle behavior.

Truth table:

```text
Qn   Qn+1
0    1
1    0
```

So the circuit is:

- a **D flip-flop**
- with implicit `D = ~Q`
- which therefore behaves like a T flip-flop with `T = 1`

### Important correction

It is **not** correct to say that LHS becomes `Qn+1` only because of non-blocking assignment.

The full reason is the combination of:

- a **clocked** `always @(posedge clk ...)` block, which implies storage
- a **non-blocking** assignment, which models register update timing correctly

So:

- `posedge clk` tells you this is sequential storage
- `<=` tells you the RHS is evaluated now and the register updates later in the time step

Short memory line:

> In a clocked `always` block, `q <= expr;` means the flip-flop will load `expr` on the clock edge, so `expr` is the D input and `q` on the left is the next state.

[1]: https://www.eg.bucknell.edu/~csci320/2016-fall/wp-content/uploads/2015/08/verilog-std-1364-2005.pdf "Title"
[2]: https://yosyshq.readthedocs.io/projects/yosys/en/v0.48/cell/word_mux.html "Multiplexers - YosysHQ Yosys 0.48 documentation"
[3]: https://yosyshq.readthedocs.io/projects/yosys/en/0.40/cmd/proc_mux.html "proc_mux - convert decision trees to multiplexers - YosysHQ Yosys documentation"
[4]: https://yosyshq.readthedocs.io/projects/yosys/en/0.44/cmd/proc_dlatch.html "proc_dlatch - extract latches from processes - YosysHQ Yosys documentation"
[5]: https://yosyshq.readthedocs.io/projects/yosys/en/0.40/using_yosys/synthesis/techmap_synth.html "Technology mapping - YosysHQ Yosys documentation"

## 5) `parameter` vs `localparam`, and `parameter integer` vs plain `parameter`

### `parameter`

`parameter` is a module constant that can be overridden when the module is instantiated.

Example:

```verilog
module fifo #(
    parameter DATA_W = 8,
    parameter ADDR_W = 4
) (
    ...
);
```

Then someone can instantiate it as:

```verilog
fifo #(
    .DATA_W(16),
    .ADDR_W(5)
) u_fifo (...);
```

Use `parameter` when you want the module user to be able to configure:

- width
- depth
- delay/count size
- feature enable values

Short rule:

> `parameter` = configurable by the parent module/user

---

### `localparam`

`localparam` is a constant inside the module that cannot be overridden from outside.

Example:

```verilog
localparam DEPTH = (1 << ADDR_W);
```

This is derived from parameters and is meant only for internal use.

Use `localparam` for:

- derived constants
- internal state encodings
- values that must not be changed externally

Examples:

```verilog
localparam IDLE  = 2'b00;
localparam START = 2'b01;
localparam STOP  = 2'b10;
```

or

```verilog
localparam DEPTH = (1 << ADDR_W);
```

Short rule:

> `localparam` = internal constant, not user-configurable

---

### Difference in one line

- `parameter` -> can be overridden
- `localparam` -> cannot be overridden

So a common pattern is:

```verilog
parameter  ADDR_W = 4;
localparam DEPTH  = (1 << ADDR_W);
```

Here:

- `ADDR_W` is chosen by the user
- `DEPTH` is computed from it and protected from override

---

### When to use `parameter integer`

Use `parameter integer` when the parameter is intended to represent an integer quantity such as:

- width
- depth
- count
- number of states
- loop/count limits

Example:

```verilog
parameter integer DATA_W = 8;
parameter integer ADDR_W = 4;
localparam integer DEPTH = (1 << ADDR_W);
```

This makes the intent clearer:

- these are numeric integer-valued parameters
- not bit-vector patterns like `4'b1010`

It is especially common for:

- bus widths
- array sizes
- loop bounds
- arithmetic constants used as sizes

---

### When plain `parameter` is enough

Use plain `parameter` when the value is more naturally treated like a bit-vector or generic constant.

Examples:

```verilog
parameter RESET_VALUE = 8'h00;
parameter IDLE_STATE  = 2'b00;
parameter MASK        = 16'hFF00;
```

Here the parameter is not mainly a numeric size; it is more like a value/pattern.

---

### Practical guideline

Use:

- `parameter integer` for widths, depths, counts, and sizes
- plain `parameter` for bit patterns, encodings, reset values, and masks
- `localparam` for internally derived values and state encodings you do not want overridden

---

### Easy memory trick

- `parameter` = user can change it
- `localparam` = local only
- `parameter integer` = numeric sizing/counting parameter
- plain `parameter` = generic value/pattern parameter

### FSM state names: why `localparam`, not `reg`

When writing FSM encodings such as:

```verilog
localparam [1:0] MOD0 = 2'd0;
localparam [1:0] MOD1 = 2'd1;
localparam [1:0] MOD2 = 2'd2;
```

these should be `localparam` because they are fixed constant labels for state values.
They do not change during simulation.

Use `reg` for the actual changing state variable:

```verilog
reg [1:0] state;
```

So:

- `state` is a changing stored value
- `MOD0/MOD1/MOD2` are fixed constants that name the legal state encodings

Short rule:

> state variable = `reg`, state names/encodings = `localparam`

### Q22 time-tick reminder: why both `one_ms_pulse` and `ms_counter==999` are needed

In Q22:

```verilog
assign second = one_ms_pulse && (ms_counter == 10'd999);
```

The two parts do different jobs:

- `ms_counter == 999` means the millisecond counter is at its terminal count
- `one_ms_pulse` means a real 1 ms timing event is happening now

Important counting point:

- because the counter starts at `0`, the range `0..999` is already 1000 counts
- so `999` is the 1000th count, not the 999th

Why `one_ms_pulse` is still needed:

- `ms_counter` is only the stored state
- `one_ms_pulse` is the event that advances time
- without `one_ms_pulse`, the counter would advance on every `clk`, not every millisecond

So:

- `ms_counter == 999` tells you **where** you are
- `one_ms_pulse` tells you **when** the valid ms event occurs

Short rule:

> state says where you are, pulse says when to move

### Q22 extra clarification: counter value vs pulses already completed

This is the subtle point:

- after reset, `ms_counter = 0` means **0 pulses completed**
- it does **not** mean “the first pulse has already been counted”

So the mapping is:

- after 0 `one_ms_pulse` events: `ms_counter = 0`
- after 1 pulse: `ms_counter = 1`
- after 2 pulses: `ms_counter = 2`
- ...
- after 999 pulses: `ms_counter = 999`
- on the 1000th pulse: rollover happens and `second` pulses

So:

```verilog
assign second = one_ms_pulse && (ms_counter == 10'd999);
```

means:

> if the stored count was already `999`, and one more valid 1 ms pulse arrives now,
> then this pulse is the 1000th pulse, so generate the `second` tick.

Important distinction:

- `0..999` are 1000 possible counter states
- but state `0` is the starting/reset state before any pulse happens

So `999` is:

- the last stored count before rollover
- not “1000 pulses already finished”

Short rule:

> counter value = pulses completed so far, except that the starting reset state is `0` before any pulse
