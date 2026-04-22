# PDF Q44) FSMs, Karnaugh Maps, and Gray Code

## Index

1. [44) FSMs, Karnaugh maps, and Gray code](#44-fsms-karnaugh-maps-and-gray-code)
2. [Direct answer](#direct-answer)
3. [Original divide-by-3 FSM idea](#original-divide-by-3-fsm-idea)
4. [Why the 3-state binary assignment is not Gray coded](#why-the-3-state-binary-assignment-is-not-gray-coded)
5. [Why a closed 3-state Gray-code loop is impossible](#why-a-closed-3-state-gray-code-loop-is-impossible)
6. [Karnaugh map view](#karnaugh-map-view)
7. [Correct 6-state Gray-coded solution](#correct-6-state-gray-coded-solution)
8. [State names versus state codes](#state-names-versus-state-codes)
9. [FIFO-style formula for choosing the Gray states](#fifo-style-formula-for-choosing-the-gray-states)
10. [Valid 6-state Gray loops in 3 bits](#valid-6-state-gray-loops-in-3-bits)
11. [What divide values are possible with 2-bit and 3-bit Gray FSM state registers?](#what-divide-values-are-possible-with-2-bit-and-3-bit-gray-fsm-state-registers)
12. [3-bit K-map placement](#3-bit-k-map-placement)
13. [Next-state table](#next-state-table)
14. [Next-state equations](#next-state-equations)
15. [Synthesizable Verilog](#synthesizable-verilog)
16. [Duty cycle and clocking notes](#duty-cycle-and-clocking-notes)
17. [Why Gray coding can help](#why-gray-coding-can-help)
18. [Common mistakes](#common-mistakes)
19. [44) Interview answer](#44-interview-answer)

## 44) FSMs, Karnaugh maps, and Gray code

The question in the shared pages is essentially:

```text
Design a divide-by-3 clock circuit using an FSM.
Then assign the FSM states using Gray coding.
Use Karnaugh-map thinking to make the state transitions legal.
```

The interviewer also states that a 50% duty cycle is not required.

That detail matters. A simple divide-by-3 FSM can produce:

```text
High for 1 cycle, low for 2 cycles
```

So the output pattern is:

```text
1 0 0 1 0 0 ...
```

That has output frequency `clk/3` and duty cycle `1/3`.

## Direct answer

A 3-state divide-by-3 FSM is easy, but a closed 3-state Gray-coded loop is impossible because every Gray transition changes exactly one bit, and a one-bit transition flips parity. Returning to the starting code requires an even number of one-bit transitions.

So for a Gray-coded divide-by-3 FSM, use a 6-state Gray-coded loop:

```text
000 -> 001 -> 011 -> 111 -> 101 -> 100 -> 000
```

Assign the output high on two states:

```text
000 = high
001 = low
011 = low
111 = high
101 = low
100 = low
```

Output pattern:

```text
1 0 0 1 0 0 ...
```

Every state transition changes exactly one bit, and the output still divides the clock by 3.

## Original divide-by-3 FSM idea

Without Gray-code restrictions, the natural FSM is:

```text
S0: output high
S1: output low
S2: output low
```

State transition:

```text
S0 -> S1 -> S2 -> S0
```

One possible binary assignment:

```text
S0 = 00
S1 = 01
S2 = 10
```

Output:

```text
state | output
------+-------
00    |   1
01    |   0
10    |   0
```

This generates:

```text
1 0 0 1 0 0 ...
```

So as a divide-by-3 FSM, it works.

But as a Gray-coded FSM, it fails.

## Why the 3-state binary assignment is not Gray coded

For Gray coding, each transition must change only one bit.

Check the binary assignment:

```text
00 -> 01 changes 1 bit
01 -> 10 changes 2 bits
10 -> 00 changes 1 bit
```

The bad transition is:

```text
01 -> 10
```

because both bits change.

If you try:

```text
00 -> 01 -> 11 -> 00
```

then:

```text
00 -> 01 changes 1 bit
01 -> 11 changes 1 bit
11 -> 00 changes 2 bits
```

Now the bad transition is:

```text
11 -> 00
```

This is not a bad choice of labels. It is a fundamental problem.

## Why a closed 3-state Gray-code loop is impossible

Think of each binary code as a node in a graph.

A valid Gray-code transition is an edge between two nodes whose Hamming distance is 1.

For 2-bit codes:

```text
00 ---- 01
|       |
|       |
10 ---- 11
```

This graph is a square. It has no triangle.

A 3-state closed FSM needs a triangle:

```text
A -> B -> C -> A
```

But a Gray-code graph cannot make an odd-length cycle.

Reason:

- Every one-bit transition flips the parity of the number of `1`s.
- Starting at even parity, one transition goes to odd parity.
- Next transition goes back to even parity.
- After an odd number of one-bit transitions, parity is opposite.
- Therefore, after 3 one-bit transitions, you cannot be back at the starting state.

So:

```text
a closed 3-state Gray-coded loop is impossible
```

This is the key insight in the question.

## Karnaugh map view

Karnaugh-map squares are arranged in Gray-code order.

That means adjacent squares differ by exactly one bit:

```text
left/right adjacency  -> one-bit change
up/down adjacency     -> one-bit change
wraparound adjacency  -> one-bit change
```

For a 2-bit K-map:

```text
        Q0
        0     1
Q1=0   00 -- 01
        |     |
Q1=1   10 -- 11
```

You can move only to an adjacent square if you want a legal Gray transition.

Trying to place three states in a loop forces one transition to jump diagonally or skip to a non-adjacent square.

That is why the 2-bit attempt gets stuck.

## Correct 6-state Gray-coded solution

Use three state bits and choose a 6-state Gray path that closes back to the beginning:

```text
000 -> 001 -> 011 -> 111 -> 101 -> 100 -> 000
```

Check every transition:

```text
000 -> 001 : bit0 changes
001 -> 011 : bit1 changes
011 -> 111 : bit2 changes
111 -> 101 : bit1 changes
101 -> 100 : bit0 changes
100 -> 000 : bit2 changes
```

Each transition changes exactly one bit.

Assign output high every third input clock:

```text
state | output
------+-------
000   |   1
001   |   0
011   |   0
111   |   1
101   |   0
100   |   0
```

Output pattern:

```text
1 0 0 1 0 0 ...
```

The FSM state sequence has six states, but the output waveform repeats every three input clocks.

## State names versus state codes

Do not confuse the state name with the state code.

These are state names:

```text
S0, S1, S2, S3, S4, S5
```

These are state codes:

```text
000, 001, 011, 111, 101, 100
```

The names are only labels used by the RTL designer. They do not have to match the binary value.

For example, this is valid:

```verilog
localparam S0_HIGH = 3'b000;
localparam S1_LOW  = 3'b001;
localparam S2_LOW  = 3'b011;
localparam S3_HIGH = 3'b111;
localparam S4_LOW  = 3'b101;
localparam S5_LOW  = 3'b100;
```

This is also valid:

```verilog
localparam S0_HIGH = 3'b001;
localparam S1_LOW  = 3'b011;
localparam S2_LOW  = 3'b010;
localparam S3_HIGH = 3'b110;
localparam S4_LOW  = 3'b111;
localparam S5_LOW  = 3'b101;
```

Both are valid if:

1. the next-state transitions change only one bit, and
2. the output sequence is still `HIGH, LOW, LOW, HIGH, LOW, LOW`.

So the important thing is not the state name. The important thing is the order of the state codes.

## FIFO-style formula for choosing the Gray states

The useful formula from non-power-of-two Gray FIFO counters is:

```text
start = (2^N - DEPTH) / 2
end   = (2^N + DEPTH) / 2 - 1
```

Then count binary from `start` to `end`, and convert each binary value to Gray:

```text
gray = binary ^ (binary >> 1)
```

This works cleanly when:

```text
DEPTH is even
DEPTH <= 2^N
```

For this question:

```text
DEPTH = 6 states
N     = 3 state bits
2^N   = 8
```

So:

```text
start = (8 - 6) / 2 = 1
end   = (8 + 6) / 2 - 1 = 6
```

Use binary values:

```text
1, 2, 3, 4, 5, 6
```

Convert to 3-bit binary and Gray:

```text
binary value | binary | gray = binary ^ (binary >> 1)
-------------+--------+--------------------------------
1            | 001    | 001
2            | 010    | 011
3            | 011    | 010
4            | 100    | 110
5            | 101    | 111
6            | 110    | 101
```

That gives this valid 6-state Gray loop:

```text
001 -> 011 -> 010 -> 110 -> 111 -> 101 -> 001
```

Check the wraparound:

```text
101 -> 001
```

Only bit2 changes, so the loop is legal.

Then assign output:

```text
state | output
------+-------
001   |   1
011   |   0
010   |   0
110   |   1
111   |   0
101   |   0
```

Output pattern:

```text
1 0 0 1 0 0 ...
```

So this sequence is just as valid as:

```text
000 -> 001 -> 011 -> 111 -> 101 -> 100 -> 000
```

The formula-backed sequence is often easier to explain because it comes from a repeatable method.

## Valid 6-state Gray loops in 3 bits

You do not need to memorize every valid loop. For an interview, one correct loop with a clear reason is enough.

But if you want to see the range of possibilities, these are unique 6-state loops in a 3-bit Gray cube, normalized so rotations and reversals are not repeated:

```text
000 -> 001 -> 011 -> 010 -> 110 -> 100 -> 000
000 -> 001 -> 011 -> 111 -> 101 -> 100 -> 000
000 -> 001 -> 011 -> 111 -> 110 -> 010 -> 000
000 -> 001 -> 011 -> 111 -> 110 -> 100 -> 000
000 -> 001 -> 101 -> 100 -> 110 -> 010 -> 000
000 -> 001 -> 101 -> 111 -> 011 -> 010 -> 000
000 -> 001 -> 101 -> 111 -> 110 -> 010 -> 000
000 -> 001 -> 101 -> 111 -> 110 -> 100 -> 000
000 -> 010 -> 011 -> 001 -> 101 -> 100 -> 000
000 -> 010 -> 011 -> 111 -> 101 -> 100 -> 000
000 -> 010 -> 011 -> 111 -> 110 -> 100 -> 000
000 -> 010 -> 110 -> 111 -> 101 -> 100 -> 000
001 -> 011 -> 010 -> 110 -> 100 -> 101 -> 001
001 -> 011 -> 010 -> 110 -> 111 -> 101 -> 001
001 -> 011 -> 111 -> 110 -> 100 -> 101 -> 001
010 -> 011 -> 111 -> 101 -> 100 -> 110 -> 010
```

Your formula-based sequence is in that list:

```text
001 -> 011 -> 010 -> 110 -> 111 -> 101 -> 001
```

The design rule is:

```text
any loop is valid if every step, including the final step back to the first state, changes exactly one bit.
```

After choosing the loop, place the high output every third state:

```text
HIGH, LOW, LOW, HIGH, LOW, LOW
```

## What divide values are possible with 2-bit and 3-bit Gray FSM state registers?

For a Gray-coded closed loop:

```text
each transition changes one bit
```

Because one-bit transitions alternate parity, a closed Gray loop must use an even number of unique states.

For a divide-by-`M` output, the state-loop length must be a multiple of `M`, because the output pattern must repeat every `M` clocks.

So the useful rule is:

```text
choose an even loop length L such that:
    L is a multiple of M
    L <= 2^N
```

where:

```text
N = number of state bits
M = desired divide value
L = number of states used in the Gray loop
```

For odd divide values, the smallest legal Gray loop is usually:

```text
L = 2M
```

That is why divide-by-3 uses:

```text
L = 2 * 3 = 6 states
```

### With 2 state bits

Available codes:

```text
2^2 = 4
```

Useful closed Gray loop lengths:

```text
2 states
4 states
```

Possible useful divide values:

```text
divide by 2:
    use 2 states or 4 states

divide by 4:
    use 4 states
```

Divide-by-3 is not possible with a 2-bit Gray-coded closed FSM because it would need:

```text
2 * 3 = 6 states
```

but 2 bits only provide:

```text
4 states
```

### With 3 state bits

Available codes:

```text
2^3 = 8
```

Useful closed Gray loop lengths:

```text
2 states
4 states
6 states
8 states
```

Possible useful divide values:

```text
divide by 2:
    use 2, 4, 6, or 8 states

divide by 3:
    use 6 states

divide by 4:
    use 4 or 8 states

divide by 6:
    use 6 states

divide by 8:
    use 8 states
```

Divide-by-5 is not possible with only 3 Gray state bits if you require a closed one-bit-change loop, because the smallest even loop for divide-by-5 is:

```text
2 * 5 = 10 states
```

but:

```text
2^3 = 8 states only
```

General bit estimate:

```text
if M is even:
    N >= ceil(log2(M))

if M is odd:
    N >= ceil(log2(2M))
```

Examples:

```text
divide by 3:
    M is odd
    need states = 2M = 6
    N = ceil(log2(6)) = 3

divide by 5:
    M is odd
    need states = 2M = 10
    N = ceil(log2(10)) = 4

divide by 8:
    M is even
    need states = 8
    N = ceil(log2(8)) = 3
```

## 3-bit K-map placement

Let the state bits be:

```text
Q2 Q1 Q0
```

Use Gray order on the columns:

```text
Q1Q0 = 00, 01, 11, 10
```

K-map placement:

```text
             Q1Q0
             00     01     11     10
Q2 = 0      000    001    011    010
            High   Low    Low    unused

Q2 = 1      100    101    111    110
            Low    Low    High   unused
```

Legal Gray path:

```text
000 -> 001 -> 011 -> 111 -> 101 -> 100 -> 000
```

Map movement:

- `000 -> 001`: move right
- `001 -> 011`: move right
- `011 -> 111`: move down
- `111 -> 101`: move left
- `101 -> 100`: move left
- `100 -> 000`: move up

The unused cells are:

```text
010
110
```

In a robust FSM, unused states should recover to a known legal state.

## Next-state table

Present state:

```text
Q2 Q1 Q0
```

Next state:

```text
D2 D1 D0
```

State transition table:

```text
Present | Next | Output
--------+------+-------
000     | 001  |   1
001     | 011  |   0
011     | 111  |   0
111     | 101  |   1
101     | 100  |   0
100     | 000  |   0
010     | 000  |   0   recovery state
110     | 000  |   0   recovery state
```

This table intentionally maps illegal states `010` and `110` back to `000`.

If you use K-map don't-cares for unused states, you may get smaller equations, but the FSM may not self-recover from an illegal state. For interview and practical RTL, explicit recovery is usually safer.

## Next-state equations

From the table above:

```text
D2 = Q0 . (Q2 + Q1)
D1 = Q2' . Q0
D0 = (Q2' . Q1') + (Q1 . Q0)
```

Output is high in states `000` and `111`:

```text
Y = Q2'Q1'Q0' + Q2Q1Q0
```

Equivalent expression:

```text
Y = (Q2 == Q1) and (Q1 == Q0)
```

because `Y=1` only when all three state bits are equal.

### Equation check

For `000`:

```text
D2 = 0.(0+0) = 0
D1 = 1.0     = 0
D0 = 1.1 + 0 = 1
next = 001
```

For `111`:

```text
D2 = 1.(1+1) = 1
D1 = 0.1     = 0
D0 = 0.0 + 1 = 1
next = 101
```

For `100`:

```text
D2 = 0.(1+0) = 0
D1 = 0.0     = 0
D0 = 0.1 + 0 = 0
next = 000
```

So the equations match the intended path.

## Synthesizable Verilog

See the full Verilog file:

```text
qa/pdf_q44/q44_div3_gray_fsm.v
```

It contains:

- `q44_div3_fsm_binary`: simple 3-state divide-by-3 FSM
- `q44_div3_fsm_gray6`: 6-state Gray-coded FSM using a case statement
- `q44_div3_fsm_gray6_equations`: 6-state Gray-coded FSM using minimized equations

Main Gray-coded version:

```verilog
module q44_div3_fsm_gray6 (
    input  wire       clk,
    input  wire       rst_n,
    output reg        div3_out,
    output reg  [2:0] state
);
    localparam S0_HIGH = 3'b000;
    localparam S1_LOW  = 3'b001;
    localparam S2_LOW  = 3'b011;
    localparam S3_HIGH = 3'b111;
    localparam S4_LOW  = 3'b101;
    localparam S5_LOW  = 3'b100;

    reg [2:0] next_state;

    always @(*) begin
        case (state)
            S0_HIGH: next_state = S1_LOW;
            S1_LOW:  next_state = S2_LOW;
            S2_LOW:  next_state = S3_HIGH;
            S3_HIGH: next_state = S4_LOW;
            S4_LOW:  next_state = S5_LOW;
            S5_LOW:  next_state = S0_HIGH;
            default: next_state = S0_HIGH;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= S0_HIGH;
            div3_out <= 1'b1;
        end else begin
            state    <= next_state;
            div3_out <= (next_state == S0_HIGH) || (next_state == S3_HIGH);
        end
    end
endmodule
```

Equation version:

```verilog
assign next_state[2] = state[0] & (state[2] | state[1]);
assign next_state[1] = ~state[2] & state[0];
assign next_state[0] = (~state[2] & ~state[1]) | (state[1] & state[0]);
```

## Duty cycle and clocking notes

The output pattern is:

```text
1 0 0 1 0 0 ...
```

So:

```text
frequency division = divide by 3
duty cycle         = 1/3 high, 2/3 low
```

This question explicitly says 50% duty cycle is not required.

If someone asks for an exact 50% duty-cycle divide-by-3, the usual solution is different. It often uses both clock edges or combines two phase-shifted waveforms. That was covered earlier in the divide-by-3 duty-cycle question.

### Important generated-clock warning

In real RTL, avoid using a logic-generated signal as a clock unless the target flow explicitly supports and constrains it.

Better practice in many FPGA/ASIC designs is:

```text
keep one main clock
generate a clock-enable pulse every 3 cycles
use that enable inside always @(posedge clk)
```

For interview clock-divider questions, the divided output is often drawn as a clock waveform. For production timing closure, treat this carefully.

## Why Gray coding can help

Gray coding means only one state bit changes per transition.

Benefits:

- fewer state-register bit toggles
- fewer simultaneous switching events
- less chance of decode glitches from multiple state bits changing at slightly different times
- useful for clock-domain-crossing pointers
- sometimes useful for low-power FSM state assignments

But Gray coding is not always best.

Tradeoffs:

- more state bits may be needed
- decode logic can become larger
- unused-state recovery must be handled
- binary or one-hot encoding may be better for timing or simplicity

For this exact question, Gray coding is valuable because the interviewer is testing whether you know:

```text
K-map adjacency = Gray-code adjacency
```

and whether you notice that a 3-state closed Gray loop cannot exist.

## Common mistakes

### Mistake 1: forcing three Gray states into a loop

This fails because one transition must change two bits.

Bad attempt:

```text
00 -> 01 -> 11 -> 00
```

Bad transition:

```text
11 -> 00 changes two bits
```

### Mistake 2: forgetting the return transition

It is not enough to check:

```text
S0 -> S1
S1 -> S2
```

You must also check:

```text
S2 -> S0
```

The wraparound transition is where many wrong answers fail.

### Mistake 3: using K-map cells in normal binary order

K-map rows and columns must be Gray ordered.

For two variables, the order is:

```text
00, 01, 11, 10
```

not:

```text
00, 01, 10, 11
```

### Mistake 4: using don't-cares without thinking about recovery

Unused states can be treated as don't-cares for minimization, but that may create an FSM that does not recover predictably after reset issues, X-propagation, or a soft error.

Safer interview answer:

```text
unused states recover to a known legal state
```

### Mistake 5: claiming the 6-state FSM divides by 6

The state sequence has six states, but the output pattern is:

```text
1 0 0 1 0 0
```

The output repeats every three clocks:

```text
1 0 0
```

So the output divides the input frequency by 3.

## 44) Interview answer

I would first make a simple divide-by-3 FSM with three states: high, low, low. But if the interviewer asks for Gray-coded state transitions, a closed 3-state loop is impossible because each Gray transition flips exactly one bit, and returning to the original code after an odd number of one-bit transitions cannot happen. A 2-bit K-map also shows this because adjacent cells form a square, not a triangle. So I would use a 3-bit, 6-state Gray-coded loop: `000 -> 001 -> 011 -> 111 -> 101 -> 100 -> 000`. I would drive the output high in states `000` and `111`, and low in the other four states. That gives the waveform `1 0 0 1 0 0`, which is a divide-by-3 output with 33.33% duty cycle, while every FSM transition changes only one state bit.
