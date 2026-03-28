# PDF Theory Answers (Q1-Q2)

## 1) Difference between blocking and non-blocking statements, and when to use them

### Short interview answer

- `=` is a **blocking** assignment.
- It executes **immediately** in procedural order, so the next line in the same `always` block sees the updated value.
- Use it mainly for **combinational logic** in `always @(*)` or `always_comb`.

- `<=` is a **non-blocking** assignment.
- The **RHS is evaluated now**, but the **LHS is updated later**, at the end of the current time step.
- Use it mainly for **sequential/clocked logic** in `always @(posedge clk)`, `always @(negedge clk)`, or `always_ff`.

### Why the difference matters

- This is not just a syntax rule; it is about **simulation scheduling**.
- Blocking assignments behave like step-by-step execution inside one procedural block.
- Non-blocking assignments model how flip-flops behave in hardware: all registers triggered by the same clock edge update **together**.
- If you use the wrong style, synthesis may still produce hardware, but **simulation can be misleading** or differ from the intended circuit.

### Scheduling intuition

- Blocking `=`:
  The assignment completes before the next statement in the same sequential block runs.

- Non-blocking `<=`:
  1. Evaluate the right-hand side at the clock/event.
  2. Schedule the left-hand side update for the end of the time step.

This is why people say:
- blocking = "update now"
- non-blocking = "sample now, update later"

### When to use which

- **Combinational logic**: use blocking `=`
- **Flip-flops / registers / clocked logic**: use non-blocking `<=`
- **FSM coding pattern**:
  - `next_state` combinational block: use `=`
  - `state` register block: use `<=`

### Good examples

```verilog
// Combinational logic
always @(*) begin
    y = a & b;
    z = y | c;   // z sees the updated y immediately
end
```

```verilog
// Sequential logic
always @(posedge clk) begin
    q1 <= d;
    q2 <= q1;    // q2 gets the previous-cycle value of q1
end
```

### Very common interview pitfall

```verilog
always @(posedge clk) begin
    q1 = d;
    q2 = q1;
end
```

- This uses **blocking** assignments in a clocked block.
- In simulation, `q1` changes immediately, so `q2` can see the new `q1` in the same block.
- That can destroy the intended **pipeline/register behavior** and is a classic reason interviewers prefer `<=` for sequential logic.

### Another important pitfall

- Do **not** assign the same variable from multiple `always` blocks.
- Do **not** mix blocking and non-blocking assignments on the same signal.
- Even if Verilog allows some of these cases, they often create **race conditions**, confusing behavior, or lint/tool errors.

### Best-practice summary

- Use blocking `=` for `always @(*)` combinational logic.
- Use non-blocking `<=` for `always @(posedge/negedge clk)` sequential logic.
- In SystemVerilog, prefer `always_comb` for combinational logic and `always_ff` for sequential logic because they express intent more clearly.

### One-line answer for interview

Blocking assignments (`=`) update immediately and are used for combinational logic; non-blocking assignments (`<=`) evaluate first and update at the end of the time step, so they are used for clocked/register logic to model parallel flip-flop updates correctly.

### References

- [IEEE Std 1364-2001, blocking and non-blocking procedural assignment semantics](https://0x04.net/~mwk/vstd/ieee-1364-2001.pdf)
- [Clifford E. Cummings, "Nonblocking Assignments in Verilog Synthesis, Coding Styles That Kill!"](https://web02.gonzaga.edu/faculty/talarico/CP230/documents/Cummings-verilog_guidelines.pdf)
- [Verilator warning docs on mixed blocking/non-blocking assignment (`BLKANDNBLK`)](https://verilator.org/guide/latest/warnings.html)

### Keywords to remember

- blocking `=`
- non-blocking `<=`
- immediate update
- procedural order
- sample now, update later
- end of time step
- RHS evaluated first
- parallel register update
- combinational -> `=`
- sequential/clocked -> `<=`
- pipeline behavior
- race condition
- do not mix `=` and `<=` on same signal
- `always_comb`
- `always_ff`

### What is a race condition?

- A **race condition** happens when the final result depends on the **order in which concurrent procedural blocks execute** in simulation.
- In Verilog, two `always` blocks triggered at the same time may run in an unspecified order.
- If one block reads a signal while another block writes that same signal in the same simulation time step, the result can become order-dependent.
- That means the design may behave differently in simulation than you expected, even though the code compiles.

Example idea:

```verilog
always @(posedge clk)
    a = b;

always @(posedge clk)
    b = a;
```

- Both blocks run on the same clock edge.
- If the first block runs first, the result can differ from the case where the second block runs first.
- This is a classic race-condition pattern.

Interview-safe definition:

Race condition means the output depends on simulator execution order instead of clear hardware intent.

## 2) Difference between logical and bitwise operators

### Short interview answer

- **Bitwise operators** work on each bit position independently.
- Main operators: `&`, `|`, `^`, `~`
- They are used when you want to manipulate **vectors/buses/masks**.

- **Logical operators** treat the whole operand as a Boolean condition.
- Main operators: `&&`, `||`, `!`
- They are used mainly in **conditions** such as `if`, `while`, and control expressions.

### Core difference

- Bitwise operators act on **every bit** of the operand.
- Logical operators first interpret each operand as **true/false**, then produce a **1-bit result**.

So the key idea is:
- bitwise = hardware operation on bits
- logical = condition check on whole expression

### Simple example

```verilog
reg [3:0] a = 4'b1010;
reg [3:0] b = 4'b1100;
```

```verilog
a & b   = 4'b1000   // bit-by-bit AND
a | b   = 4'b1110   // bit-by-bit OR
a ^ b   = 4'b0110   // bit-by-bit XOR
~a      = 4'b0101   // bit-by-bit NOT
```

```verilog
a && b  = 1'b1      // both operands are nonzero, so true
a || b  = 1'b1      // at least one operand is nonzero
!a      = 1'b0      // a is nonzero, so logical NOT is false
```

### Why this confuses people in interviews

For **1-bit signals**, `&` and `&&` can appear similar.

Example:
- if `a = 1'b1` and `b = 1'b0`
- `a & b = 1'b0`
- `a && b = 1'b0`

But for **multi-bit vectors**, they are very different.

Example:

```verilog
a = 4'b0010;
b = 4'b0100;
```

- `a & b = 4'b0000`
- `a && b = 1'b1`

Why?
- `a & b` compares corresponding bits, and no bit position has `1` in both operands.
- `a && b` only checks whether `a` is nonzero and `b` is nonzero. Both are nonzero, so the result is true.

This is one of the most common Verilog interview traps.

### Result width difference

- Bitwise operations usually produce a **vector result**.
- Logical operations produce a **single-bit result**: `1`, `0`, or sometimes `x`.

So this matters:

```verilog
wire [3:0] x;
assign x = a && b;
```

- `a && b` itself is only **1 bit**
- when assigned to `x`, it becomes `4'b0001` or `4'b0000` after normal assignment sizing

### Where each is used

- Use **bitwise** operators in datapath logic:
  - masking bits
  - setting/clearing bits
  - XOR/parity-style logic
  - combining buses

- Use **logical** operators in control logic:
  - `if (valid && ready)`
  - `while (!done)`
  - `if (req || timeout)`

### Important `if` statement connection

In Verilog, an `if` condition is true only when the expression has a **nonzero known value**.

- nonzero known value -> true
- zero -> false
- `x` or `z` -> treated as false in `if`

That means:

```verilog
if (a && b)
```

is asking:
- "Are both operands logically true?"

But:

```verilog
if (a & b)
```

is asking:
- "After bitwise AND, is the resulting vector nonzero?"

Those are not equivalent for buses.

### Common bug example

```verilog
if (data & mask)
    hit = 1'b1;
else
    hit = 1'b0;
```

This means:
- compute `data & mask`
- if the result is nonzero, take the `if` branch

That is valid code, but it is **not** the same as:

```verilog
if (data && mask)
```

because `data && mask` only asks whether both vectors are nonzero, not whether they overlap in any bit position.

### `X` and `Z` behavior

This is another place interviewers may probe.

- Logical operators can return `x` when the truth value is ambiguous.
- Bitwise operators propagate `x`/`z` bit-by-bit according to the truth tables.

Example intuition:
- `4'b000x && 4'b0001` can become `x` because the first operand may be zero or nonzero.
- `4'b000x & 4'b0001` works bit by bit, so only the overlapping bit positions matter.

More clearly:

- For `4'b000x && 4'b0001`, Verilog first asks:
  - is `4'b000x` logically true or false?
  - is `4'b0001` logically true or false?
- `4'b0001` is definitely nonzero, so it is logically true.
- But `4'b000x` is ambiguous:
  - if `x = 0`, then the value is `4'b0000`, which is false
  - if `x = 1`, then the value is `4'b0001`, which is true
- Since the simulator cannot know whether the first operand is false or true, the logical result can become `x`.

- For `4'b000x & 4'b0001`, the operation is done bit by bit:
  - MSB side bits: `0 & 0 = 0`
  - next bits: `0 & 0 = 0`
  - next bits: `0 & 0 = 0`
  - LSB: `x & 1 = x`
- So the result is:

```verilog
4'b000x & 4'b0001 = 4'b000x
```

- The important idea is that bitwise operators keep the uncertainty **local to the affected bit positions**, while logical operators ask for the truth value of the **entire operand**.
- That is why one unknown bit can make a logical expression ambiguous, but in bitwise logic the unknown may stay confined to only one bit of the result.
- Also note: if the second operand were `4'b0000`, then `x & 0 = 0`, so the unknown could disappear in the bitwise result.

Also remember:
- if a logical expression becomes `x`, then using it in `if (...)` can still go to the `else` path, because `if` treats `x` and `z` as false.

### Width mismatch behavior

For bitwise operators:
- if the operands have different widths, Verilog extends the shorter operand before doing the bit-by-bit operation
- for unsigned operands, the shorter one is zero-filled on the MSB side

Example:

```verilog
3'b101 & 1'b1   -> 3'b001
```

because `1'b1` is effectively extended to `3'b001`.

### Easy way to remember

- `&` looks at **bits**
- `&&` looks at **truth**
- `|` combines bits
- `||` combines Boolean conditions
- `~` flips every bit
- `!` flips true/false

### Interview-ready comparison

| Feature | Bitwise operators | Logical operators |
|---|---|---|
| Operators | `&`, `|`, `^`, `~` | `&&`, `||`, `!` |
| Works on | Each bit | Whole operand as Boolean |
| Result width | Usually vector width | 1 bit |
| Common use | RTL/data manipulation | Conditions/control |
| Multi-bit operands | Operates bit-by-bit | Checks zero/nonzero |
| `X/Z` handling | Per-bit propagation | Can produce ambiguous `x` |

### Related interview point: reduction operators

Do not confuse **bitwise** and **reduction** operators.

- `a & b` = bitwise AND between two operands
- `&a` = reduction AND of all bits of `a`

Example:

```verilog
a = 4'b1110;
a & 4'b1011 = 4'b1010
&a          = 1'b0
```

Interviewers often check whether you can distinguish:
- bitwise AND: `a & b`
- logical AND: `a && b`
- reduction AND: `&a`

### One-line answer for interview

Bitwise operators (`&`, `|`, `^`, `~`) work on each bit of a signal and are used for vector/datapath logic, while logical operators (`&&`, `||`, `!`) treat the whole operand as true/false and return a 1-bit Boolean result, so they are mainly used in conditions.

### References

- [IEEE Std 1364-2001, logical operators, bit-wise operators, reduction operators, and `if` statement semantics](https://0x04.net/~mwk/vstd/ieee-1364-2001.pdf)

### Keywords to remember

- bitwise = per-bit operation
- logical = true/false check
- `&` vs `&&`
- `|` vs `||`
- `~` vs `!`
- vector result vs 1-bit result
- nonzero = true
- zero = false
- `x/z` in conditions
- `if (a & b)` != `if (a && b)`
- masking
- control logic
- bus operations
- reduction operator `&a`
- width extension
