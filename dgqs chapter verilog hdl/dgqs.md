# DGQS - Deep Questions and Answers (Verilog HDL)

## Q1) Declare the following variables in Verilog

- (a) 16-bit wire called `sum`
- (b) An array of integers of size 16 called `int_arr`
- (c) A memory `mem` of size 128x8

```verilog
// (a) 16-bit wire called "sum"
wire [15:0] sum;

// (b) Array of integers of size 16 called "int_arr"
integer int_arr [0:15];

// (c) Memory "mem" of size 128x8 (128 locations, each 8 bits)
reg [7:0] mem [0:127];
```

## Q2) What is the bit width of data type `integer` in Verilog?

`integer` in Verilog is **32-bit signed**.

### Deep understanding (why this matters)

- `integer` is a procedural variable type with a **fixed** width (32), unlike `reg`/`wire` which you usually size yourself.
- Because it is **signed**, arithmetic and comparisons can behave differently than unsigned vectors.
- In synthesis-oriented RTL, blindly using `integer` can create wider logic than needed; for datapaths, prefer explicitly sized vectors.
- `integer` is still very useful for loop counters and temporary control math in `always`/`initial` blocks.

### Verilog size cheat-sheet (must know)

- `wire`, `reg`, `tri`, and most net/variable vectors: **1 bit by default** if no range is given.
- `wire [N-1:0]` / `reg [N-1:0]`: **N bits** (explicitly sized).
- `integer`: **32-bit signed**.
- `time`: **64-bit unsigned**.
- `real`, `realtime`: **64-bit floating-point** (simulation/math type, not bit-accurate RTL storage).
- `event`: not a bit container (no meaningful width in datapath terms).
- Memory declaration `reg [W-1:0] mem [0:D-1]`: each word is `W` bits, depth is `D`, total storage is `W*D` bits.

### Practical rules to avoid bugs

- Always size hardware signals explicitly (`wire [15:0]`, `reg [7:0]`, etc.).
- Use sized constants (`8'd10`, `16'h00FF`) instead of unsized literals when width matters.
- Use `integer` mainly for `for` loop indices and temporary algorithmic variables.
- For real RTL storage, prefer sized `reg` (or `logic` in SystemVerilog) over unsized/default-width declarations.

### Signed/unsigned and complement ranges (must know)

- **Unsigned N-bit range**: `0` to `(2^N)-1`.
- **Signed N-bit (2's complement) range**: `-(2^(N-1))` to `+(2^(N-1))-1`.
- **Signed N-bit (1's complement) range**: `-((2^(N-1))-1)` to `+((2^(N-1))-1)`.

### 1's vs 2's complement (core difference)

- **1's complement negative** = bitwise invert of positive number.
- **2's complement negative** = (bitwise invert) + `1`.
- **2's complement has one zero** (`000...0`), while **1's complement has two zeros** (`000...0` and `111...1`).
- Modern digital design and Verilog signed arithmetic effectively use **2's complement** interpretation.

### Quick 8-bit examples

- **Unsigned (8-bit)**: `0` to `255`.
- **2's complement signed (8-bit)**: `-128` to `+127`.
- **1's complement signed (8-bit)**: `-127` to `+127`.

### Why these ranges are exactly like this

- With `N` bits, total distinct bit patterns are always `2^N`.
- A range is decided by how those `2^N` patterns are interpreted.

### Unsigned interpretation (all patterns are non-negative)

- **Unsigned (definition)**: all `N` bits are used only for magnitude, so values are never negative.
- **Signed (definition)**: bit pattern is interpreted with sign information (in modern systems, usually 2's complement), allowing both negative and positive values.

- Every bit is magnitude-only, with weights `2^0, 2^1, ... , 2^(N-1)`.
- Smallest pattern is all zeros: `000...0` => `0`.
- Largest pattern is all ones: `111...1` => `(2^N)-1`.
- So unsigned range is exactly `0` to `(2^N)-1`.

### Signed 2's complement interpretation (modern digital systems)

- MSB is sign-weighted as `-2^(N-1)`; remaining bits keep positive weights.
- Minimum value is `100...0` => `-2^(N-1)`.
- Maximum value is `011...1` => `+(2^(N-1))-1`.
- So range becomes `-(2^(N-1))` to `+(2^(N-1))-1`.
- Extra negative number happens because zero uses only one code (`000...0`), so negative side gets one extra value.

### Signed 1's complement interpretation (historical concept)

- Negative is formed by bitwise inversion of positive.
- Both `000...0` and `111...1` represent zero (positive and negative zero).
- Because one code is "wasted" on second zero, magnitude max is `2^(N-1)-1`.
- So range is `-((2^(N-1))-1)` to `+((2^(N-1))-1)`.

### Quick check across common widths (2's complement signed)

- `4-bit`: `-8` to `+7`; unsigned `0` to `15`.
- `8-bit`: `-128` to `+127`; unsigned `0` to `255`.
- `16-bit`: `-32768` to `+32767`; unsigned `0` to `65535`.
- `32-bit` (`integer`): `-2147483648` to `+2147483647`; unsigned `0` to `4294967295`.

## Q3) What is the difference between `wire` and `reg` data type?

### Interview answer (best length)

- There is no fixed "correct number", but in interviews **5-6 core differences** is ideal.
- Say the core points first (object kind, assignment style, storage behavior, driver model, usage pattern), then add one modern note (`logic` in SystemVerilog).

### Core differences (must know)

- **Type category**: `wire` is a **net**; `reg` is a **variable**.
- **Meaning**: `wire` models a connection between drivers; `reg` models a procedurally assigned value.
- **How assigned**: `wire` is driven by `assign`, module outputs, or primitive outputs; `reg` is assigned inside `always`/`initial`.
- **Storage behavior**: `wire` does not store on its own; `reg` holds last assigned value until next assignment.
- **Multiple drivers**: `wire` can have multiple drivers (net resolution rules apply); `reg` is typically single procedural driver in good RTL style.
- **Typical RTL use**: `wire` for combinational interconnects; `reg` for outputs/temps/cycle-to-cycle state from procedural blocks.

### Very important clarification

- `reg` does **not** automatically mean flip-flop hardware.
- A `reg` in `always @(*)` describes combinational logic (if fully assigned).
- A `reg` in `always @(posedge clk)` describes sequential logic (flip-flop behavior).
- So hardware depends on the `always` block style, not the word `reg` alone.

### Short interview-ready script

- "`wire` is a net/connection type driven continuously by `assign`, module output ports, or gate/primitive outputs; `reg` is a procedural variable assigned in `always/initial`."
- "`wire` reflects its drivers, while `reg` keeps last assigned value."
- "`reg` is not always a register; inference depends on combinational vs clocked procedural logic."

### Modern SystemVerilog note

- In SystemVerilog, `logic` is commonly used instead of old `reg` for variables/signals with single driver intent.

## Q4) Which of the following are not legal identifiers?

Given:
- (a) `$key`
- (b) `key$`
- (c) `123scan`
- (d) `Scan123`

### Rule first (for normal/simple identifiers)

- Must start with a letter (`a-z`, `A-Z`) or underscore (`_`).
- After first character, letters, digits, `_`, and `$` are allowed.
- Verilog is case-sensitive (`scan123` and `Scan123` are different).

### Answer

- **Not legal**: (a) `$key`, (c) `123scan`
- **Legal**: (b) `key$`, (d) `Scan123`

### Why

- `$key` starts with `$`; names beginning with `$` are reserved style for system tasks/functions.
- `123scan` starts with a digit, which is not allowed for simple identifiers.
- `key$` is valid because `$` is allowed after the first character.
- `Scan123` starts with a letter and then uses allowed characters.

### Deep interview note

- If needed, Verilog also supports **escaped identifiers** (start with `\` and end at whitespace), which can represent otherwise illegal text forms. But for standard interview questions, apply simple-identifier rules above.

## Q5) How many operands are there for each operator?

- (a) Reduction NAND `~&` -> **1 operand (unary reduction)**
- (b) Logical OR `||` -> **2 operands (binary logical)**
- (c) Right shift `>>` -> **2 operands (value, shift amount)**
- (d) Conditional `?:` -> **3 operands (condition, true-expression, false-expression)**

### Deep pattern to remember

- **Reduction operators** (`&`, `~&`, `|`, `~|`, `^`, `~^`) are unary: they reduce one vector to one bit.
- **Logical/arithmetic/shift operators** are mostly binary.
- `?:` is the classic ternary operator in Verilog.

## Q6)

```verilog
wire [5:0] in;
wire [5:0] out  = {in[3:0], 2'b0};
wire [5:0] out1 = {2'b0, in[5:3]};
```

### (a) Name of operator used

- Main operator is **concatenation** operator: `{ ... }`
- Also used inside: **part-select/indexing** (`in[3:0]`, `in[5:3]`).

### (b) Relation between signals

- (i) Relation between `in` and `out`:
  - `out = {in[3:0], 2'b0}`
  - This is equivalent to **left shift by 2** of `in` with truncation of upper bits:
  - `out` behaves like `in << 2` (for 6-bit result), so:
    - `out[5:2] = in[3:0]`
    - `out[1:0] = 2'b00`
    - original `in[5:4]` are dropped.

- (ii) Relation between `in` and `out1`:
  - `out1 = {2'b0, in[5:3]}`
  - Concatenation here is 5 bits (`2 + 3`), assigned into 6-bit `out1`, so one extra MSB `0` is padded.
  - Effective value is `out1 = {3'b000, in[5:3]}`.
  - This matches **right shift by 3** on a 6-bit vector:
  - `out1` behaves like `in >> 3`, so:
    - `out1[5:3] = 3'b000`
    - `out1[2:0] = in[5:3]`

### Important subtlety (interview gold)

- In `out1`, many candidates miss the width mismatch (`5-bit RHS` to `6-bit LHS`).
- Verilog pads the extra left bit with `0` (for this unsigned-style context), which is why it cleanly matches `in >> 3`.

## Q7) What does `out` give?

```verilog
wire [7:0] in;
wire out = ^in;
```

- `^in` is a **reduction XOR**.
- So `out` is the **parity bit** of `in`.
- `out = 1` when `in` has an **odd number of 1s**.
- `out = 0` when `in` has an **even number of 1s**.

### Quick examples

- `in = 8'b0000_0000` -> `out = 0` (zero 1s, even)
- `in = 8'b0000_0001` -> `out = 1` (one 1, odd)
- `in = 8'b1011_0001` -> `out = 0` (four 1s, even)

### How it "opens up" (bit-level expansion)

- For 8-bit `in`, reduction XOR expands as:

```verilog
wire out = in[7] ^ in[6] ^ in[5] ^ in[4] ^ in[3] ^ in[2] ^ in[1] ^ in[0];
```

- So you can solve it by counting number of `1`s:
  - odd count -> `out = 1`
  - even count -> `out = 0`

### Interview depth note

- Reduction XOR checks parity in one operator, so it is widely used in error-detection/parity logic.
- If `in` contains unknown/high-impedance bits (`x`/`z`), result can become unknown in simulation.

## Q8) Single-line statements for output `out = 1` when

Assume:

```verilog
wire [7:0] in;
wire out;
```

### (a) All bits of 8-bit register are `0`

```verilog
assign out = ~|in;
```

- `~|in` is **reduction NOR**, true only when every bit is `0`.

### (b) At least one bit of 8-bit register is `0`

```verilog
assign out = ~&in;
```

- `~&in` is **reduction NAND**, true unless all bits are `1`.
- Equivalent comparison form: `assign out = (in != 8'hFF);`

## Q9) Use of non-blocking assignment in behavioral modeling; difference from blocking

### Why non-blocking (`<=`) is used

- Non-blocking models **clocked/sequential register updates** correctly.
- All RHS values are sampled first at the triggering edge; LHS updates occur later in the NBA update phase.
- This mimics flip-flop behavior where registers update "together" at a clock edge.
- It reduces simulation race conditions across multiple clocked `always` blocks.

### Interview core 6 differences (`=` vs `<=`)

- **Update timing**: blocking `=` updates immediately; non-blocking `<=` schedules update for end of current time-step.
- **Execution effect**: blocking statements act step-by-step (next line sees new value); non-blocking next line still sees old value until update phase.
- **Best use**: blocking for combinational `always @(*)`; non-blocking for sequential `always @(posedge clk)`.
- **Order sensitivity**: blocking is order-dependent inside a block; non-blocking better represents concurrent register transfers.
- **Race behavior**: blocking across multiple clocked blocks can create races; non-blocking significantly reduces these race issues.
- **Hardware intent clarity**: non-blocking in clocked logic clearly communicates "flip-flop update on edge."

### Tiny example (why this matters)

```verilog
// Correct register swap in one clock
always @(posedge clk) begin
  a <= b;
  b <= a;
end
```

- With `<=`, swap works (both sample old values first).
- With `=`, second assignment sees already-updated value, so behavior changes.

### Interview one-liner

- "Use `<=` for sequential/clocked logic because registers update concurrently after sampling; use `=` for combinational step-by-step calculations."

### Deep dive: what is race behavior?

- A **race** happens when final simulation result depends on execution order of parallel processes (`always` blocks) in the same time-slot.
- If order is not guaranteed by language semantics, simulator may pick either order, so behavior can become nondeterministic.

### Common race types (interview core)

- **Read-after-write race**: one block writes a variable while another reads it in same edge/time-slot.
- **Write-after-write race**: two blocks write same variable in same edge/time-slot.
- **Testbench vs DUT race**: TB drives and DUT samples at same edge without proper clocking discipline.

### Why blocking `=` causes races more easily

- In clocked blocks, `=` updates immediately in active region.
- Another parallel block may read either old or new value depending on execution order.
- That makes behavior order-dependent and fragile.

### Concrete race example (interview-friendly)

```verilog
reg q, d, y;

always @(posedge clk) q = d;   // blocking write
always @(posedge clk) y = q;   // blocking read
```

- At the same `posedge clk`, both blocks are active.
- If first block executes first, `y` may see **new** `q`.
- If second block executes first, `y` sees **old** `q`.
- So `y` becomes simulator-order dependent: this is a race.

```verilog
// Race-safe style
always @(posedge clk) q <= d;
always @(posedge clk) y <= q;
```

- With `<=`, both RHS are sampled first, then both LHS update in NBA region.
- Now `y` deterministically gets previous-cycle `q` (like real flops).

### Verilog time-slot phases (classic event queue)

- **Active region**: edge-triggered blocks run; blocking assignments update immediately; RHS of `<=` is evaluated here.
- **Inactive region**: `#0` events (if used) are processed.
- **NBA region**: queued non-blocking LHS updates are committed.
- **Monitor/Postponed region**: `$monitor`, `$strobe`, final observation style actions.

### NBA region (deeper intuition)

- In active region, `<=` does not write LHS immediately; it only captures RHS value and schedules an update.
- NBA region is where all those scheduled LHS writes are finally applied.
- This two-step model gives flip-flop-like behavior: sample first, update together.
- That is why statements like `a <= b; b <= a;` swap correctly in one clock edge.

### Block-wise clarity (very important)

- NBA commit is **not** "after `end`" of one block.
- NBA commit is **not** "after `endmodule`".
- `end` only means that one process finished execution in active region.
- Non-blocking updates are committed after **all currently triggered processes** finish active/inactive regions for that same time-slot.
- So parallel update point is global to the time-slot, not local to one block text boundary.

### At one clock edge (`posedge clk`) with non-blocking

- Time `t`: clock edge occurs, triggered `always @(posedge clk)` blocks enter active region.
- Inside each block: RHS of every `<=` is sampled using current (old) values.
- LHS updates are queued into NBA (not written immediately).
- After active/inactive work completes: all NBA updates commit in same time-step.
- Result: all flops appear to update simultaneously at that edge.

### Block-level behavior of `<=` (important)

- In same block, multiple `<=` to **different** regs all sample old values first.
- In same block, multiple `<=` to **same** reg in one edge: last scheduled assignment in that block wins.
- Across different blocks, driving same reg with `<=` is still a bad practice and can be nondeterministic/conflicting.

### Practical anti-race rules

- Use `<=` in clocked/sequential blocks.
- Use `=` in combinational `always @(*)`.
- Avoid multiple procedural drivers for one register.
- Keep testbench driving/sampling separated using stable clocking methodology.

## Q10) Given code below, what value of `a` is displayed?

```verilog
always @(clk) begin
  a = 0;
  a <= 1;
  $display(a);
end
```

- Displayed value is **`0`** (on each trigger).
- Why: `a = 0` updates immediately (blocking).
- `a <= 1` is scheduled to NBA, so it is not visible yet in same active region.
- `$display(a)` executes before NBA commit, so it prints current value (`0`).
- After block finishes, NBA updates `a` to `1`.

## Q11) Difference between inertial and transport delays; applications

- **Inertial delay**: pulses narrower than delay are filtered (glitch rejection).
- **Transport delay**: every input change is propagated after delay (no filtering).

### Applications

- Inertial: gate/device modeling (real gates do not pass very narrow glitches).
- Transport: interconnect/wire/channel delay modeling where pulses should be preserved.

### Interview note

- In Verilog practice, gate/continuous-delay style is typically treated as inertial behavior; transport-like behavior is modeled explicitly when needed.

## Q12) Difference between these two lines

```verilog
#5 a = b + c;
a = #5 b + c;
```

- `#5 a = b + c;` (**inter-assignment delay**): wait 5 units, then evaluate `b+c`, then assign.
- `a = #5 b + c;` (**intra-assignment delay**): evaluate `b+c` now, wait 5 units, then assign saved result.

### Why it matters

- If `b` or `c` changes during the 5-unit window, first statement sees new values; second statement keeps old sampled value.

## Q13) Final value of `b` in each code

### (a)

```verilog
initial begin
  a = 0;
  #5 b = a;
  a = #3 1;
end
```

- At `t=5`, `b=a` uses `a=0` -> `b=0`.
- `a = #3 1` updates `a` at `t=8`.
- **Final `b = 0`**.

### (b)

```verilog
initial begin
  a = 0;
  a = #3 1;
  #5 b = a;
end
```

- `a = #3 1` updates `a` at `t=3`.
- Then `#5 b=a` occurs at `t=8`, reads `a=1`.
- **Final `b = 1`**.

## Q14) What do `x` and `y` mean in `` `timescale x / y ``?

- `x` = **time unit** for delays (`#1`, `#5`, etc.) in that module/file.
- `y` = **time precision** (smallest resolution/rounding step).

Example:
- `` `timescale 10ns/1ps `` means `#1` = `10ns`; simulator rounds to `1ps` precision.

## Q15) Difference between `always` and `initial`

- `initial`: runs **once** from time 0, then finishes.
- `always`: repeats forever; re-enters based on event control/delays.
- `initial` is common in testbenches (stimulus/setup); limited synthesizable use depending on tool/target.
- `always` is standard for synthesizable combinational/sequential RTL behavior.

## Q16) Period of `clk`

```verilog
`timescale 10ns/1ps
reg clk;
initial clk = 0;
always #5 clk = ~clk;
```

- `#5` = `5 * 10ns = 50ns` (half cycle, because clock toggles each delay).
- Full period = `2 * 50ns = 100ns`.
- **Clock period = `100ns`** (frequency = `10MHz`).

## Q17) `case`, `casex`, `casez`

- `case`: exact match; `x`/`z` are treated as literal bits.
- `casex`: treats `x` and `z` as don't-cares in comparison (very permissive, risky).
- `casez`: treats `z` (and `?`) as don't-care; `x` still significant.

### Interview guidance

- Prefer `case`/`casez` with clear intent.
- Avoid `casex` in RTL because it can mask unknowns and hide real bugs.

## Q18) 4:1 MUX coded with `if-else` vs `case`

### (a) Advantages / disadvantages

- `if-else`:
  - Good for priority logic and range/complex conditions.
  - Can become verbose for decoded selects; priority interpretation may be unintended.
- `case`:
  - Cleaner for exact decoded select patterns (`2'b00`, `2'b01`, ...).
  - Easier to read/maintain for mux/decoder style logic.
  - Needs full coverage (or `default`) to avoid incomplete assignment behavior.

### (b) Synthesis result for given code

- With full, mutually exclusive select coverage, both styles synthesize to equivalent combinational mux logic.
- Tools may internally optimize either style to the same hardware.

### (c) If `default` is removed in `case`

- If all valid binary combinations (`00,01,10,11`) are still covered, synthesis typically still infers combinational mux.
- But for simulation robustness (especially unknowns), missing `default` can cause output-hold behavior when no item matches.

### (d) If combination `11` and `default` are removed

- Now one legal input combination is uncovered.
- In combinational coding style, output is not assigned for that path, so previous value is held.
- This leads to **latch inference** (exactly the trap interviewers test).
