# PDF Theory Notes (Q19-Q20)

## 19) Divisible-by-3 detector from serial input bitstream

- The question is not asking you to store the whole received number.
  It is asking whether the number formed so far is divisible by 3.
- For divisibility by 3, only the remainder matters.
  Any number must be in exactly one of these 3 cases:
  remainder `0`, remainder `1`, or remainder `2`.
- So the FSM needs only 3 states:
  `mod0`, `mod1`, `mod2`.

### Why the update rule is `new_rem = (2 * old_rem + bit) mod 3`

- Each new serial bit is shifted into the LSB position.
- That means the old number shifts left by one bit, which is the same as multiplying by 2.
- Then the new input bit is added at the LSB.

So if the old number is `N` and the new bit is `b`, then:

```text
new_number = 2*N + b
```

We only care about the remainder modulo 3, so:

```text
new_rem = (2*old_rem + b) mod 3
```

That is the whole trick behind the FSM.

### State meaning

- `mod0` means the received number so far is divisible by 3
- `mod1` means remainder is 1 when divided by 3
- `mod2` means remainder is 2 when divided by 3

Since output should be `1` only when divisible by 3:

```text
div_by_3 = 1 only in state mod0
```

### Transition understanding

Using:

```text
new_rem = (2*old_rem + bit) mod 3
```

the transitions become:

- From `mod0`:
  - input `0` -> `(2*0 + 0) mod 3 = 0` -> stay in `mod0`
  - input `1` -> `(2*0 + 1) mod 3 = 1` -> go to `mod1`
- From `mod1`:
  - input `0` -> `(2*1 + 0) mod 3 = 2` -> go to `mod2`
  - input `1` -> `(2*1 + 1) mod 3 = 0` -> go to `mod0`
- From `mod2`:
  - input `0` -> `(2*2 + 0) mod 3 = 1` -> go to `mod1`
  - input `1` -> `(2*2 + 1) mod 3 = 2` -> stay in `mod2`

This exactly matches the Verilog FSM in Q19.

### Coding note: why `next_state = state;` is often used in an FSM

Many FSM branches mean "stay in the same state."

So a common Verilog style is:

```verilog
always @* begin
    next_state = state;
    case (state)
        ...
    endcase
end
```

Meaning:

- by default, hold the present state
- only override `next_state` when an actual transition is needed

For this divisible-by-3 FSM, that matches the self-loops:

- `mod0` with input `0` stays in `mod0`
- `mod2` with input `1` stays in `mod2`

So the line can look redundant at first, but it is often there to express "no transition" cleanly and safely.

### Small example

Suppose bits arrive as:

```text
0, 1, 1
```

Then the formed binary numbers are:

- `0`  -> decimal 0  -> divisible by 3 -> `mod0`
- `01` -> decimal 1  -> not divisible  -> `mod1`
- `011` -> decimal 3 -> divisible by 3 -> `mod0`

So the FSM moves:

```text
mod0 --1--> mod1 --1--> mod0
```

### Final takeaway

- Do not track the whole number.
- Track only remainder modulo 3.
- Because there are only 3 possible remainders, only 3 FSM states are needed.
- Output high only in `mod0`.

## 20) Fibonacci generator with enable

- The Fibonacci sequence is:
  `0, 1, 1, 2, 3, 5, 8, 13, ...`
- Each new term is the sum of the previous two terms.
- So the hardware must remember two consecutive values at all times.

### Why two registers are enough

If the current pair is:

```text
cur_num  = F(n)
next_num = F(n+1)
```

then the next Fibonacci value is:

```text
sum = F(n) + F(n+1) = F(n+2)
```

After one enabled clock, the pair should become:

```text
cur_num  <- F(n+1)
next_num <- F(n+2)
```

That is exactly why the update rule is:

```text
cur_num  <= next_num
next_num <= cur_num + next_num
```

### Reset values

The usual starting pair is:

```text
cur_num  = 0
next_num = 1
```

Then:

```text
sum = 1
```

and future enabled clocks generate:

```text
0, 1, 1, 2, 3, 5, 8, ...
```

### Why nonblocking assignments matter

Both registers update on the same clock edge, so nonblocking assignments are required:

```verilog
cur_num  <= next_num;
next_num <= sum;
```

This means:

- `cur_num` gets the old `next_num`
- `next_num` gets the old `cur_num + next_num`

So the pair shifts forward correctly.

If blocking assignments were used in a clocked block, the second assignment could see an already-updated value and break the intended sequence.

### Why `enable` is needed

The question says the circuit must not advance when `enable=0`.

So:

- when `enable=1`, advance to the next Fibonacci pair
- when `enable=0`, hold both registers

That means the sequence pauses cleanly without losing its current position.

### Small example

Starting after reset:

```text
cur_num=0, next_num=1, sum=1
```

After 1 enabled clock:

```text
cur_num=1, next_num=1
```

After 2 enabled clocks:

```text
cur_num=1, next_num=2
```

After 3 enabled clocks:

```text
cur_num=2, next_num=3
```

So the generated sequence progresses correctly.

### Final takeaway

- Store the previous two Fibonacci values in two registers.
- Add them to form the next value.
- On each enabled clock, shift the pair forward.
- On disabled clocks, hold the current pair.
