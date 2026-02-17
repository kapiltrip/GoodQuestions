# PDF Theory Answers (Q1-Q2)

## 1) Difference between blocking and non-blocking statements, and when to use them

- `=` is a **blocking** assignment.
- In an `always` block, blocking assignments execute in order and each line updates immediately.
- Typical use: **combinational logic** in `always @(*)`.

- `<=` is a **non-blocking** assignment.
- Right-hand sides are sampled first, then left-hand sides update together at the end of the time step.
- Typical use: **sequential/clocked logic** in `always @(posedge clk)` or `always @(negedge clk)`.

Practical rule:
- Use blocking (`=`) for combinational `always` blocks.
- Use non-blocking (`<=`) for flip-flop/register logic.

## 2) Difference between logical and bitwise operators

Bitwise operators work on each bit of a vector:
- `&` (AND), `|` (OR), `^` (XOR), `~` (NOT)
- Example: `assign y = a & b;`

Logical operators treat the whole operand as true/false:
- `&&` (logical AND), `||` (logical OR), `!` (logical NOT)
- Example: `if (cond1 && cond2) ...`

Notes:
- Bitwise ops are used to build logic on vectors/signals.
- Logical ops are mainly used in conditions (`if`, `while`, `case` guards, etc.).
