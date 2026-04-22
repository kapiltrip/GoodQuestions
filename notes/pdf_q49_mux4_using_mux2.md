# PDF Q49) Create a 4:1 Mux Using 2:1 Muxes

## Index

1. [49) Create a 4:1 mux using 2:1 muxes](#49-create-a-41-mux-using-21-muxes)
2. [Direct answer](#direct-answer)
3. [2:1 mux reminder](#21-mux-reminder)
4. [4:1 mux truth table](#41-mux-truth-table)
5. [Mux-tree construction](#mux-tree-construction)
6. [Why some diagrams show both S and S-bar at the same level](#why-some-diagrams-show-both-s-and-s-bar-at-the-same-level)
7. [Boolean equation](#boolean-equation)
8. [Gate-level interpretation](#gate-level-interpretation)
9. [Delay and area](#delay-and-area)
10. [Synthesizable Verilog](#synthesizable-verilog)
11. [Common mistakes](#common-mistakes)
12. [49) Interview answer](#49-interview-answer)

## 49) Create a 4:1 mux using 2:1 muxes

A 4:1 mux chooses one of four inputs using two select bits.

Inputs:

```text
A, B, C, D
```

Selects:

```text
S1 S0
```

Output:

```text
Y
```

## Direct answer

Use three 2:1 muxes:

```text
first level:
    mux0 selects A or B using S0
    mux1 selects C or D using S0

second level:
    mux2 selects between mux0 output and mux1 output using S1
```

Selection:

```text
S1 S0 | Y
------+---
0  0  | A
0  1  | B
1  0  | C
1  1  | D
```

## 2:1 mux reminder

A 2:1 mux has:

```text
D0, D1, S, Y
```

Convention:

```text
S=0 -> Y=D0
S=1 -> Y=D1
```

Equation:

```text
Y = S'D0 + S D1
```

## 4:1 mux truth table

```text
S1 S0 | selected input | Y
------+----------------+---
0  0  |       A        | A
0  1  |       B        | B
1  0  |       C        | C
1  1  |       D        | D
```

Think of `S1` as choosing the group:

```text
S1=0 -> choose from A/B group
S1=1 -> choose from C/D group
```

Think of `S0` as choosing within each group:

```text
S0=0 -> first item in group
S0=1 -> second item in group
```

## Mux-tree construction

Build two first-level muxes:

```text
low_pair  = S0 ? B : A
high_pair = S0 ? D : C
```

Then build the final mux:

```text
Y = S1 ? high_pair : low_pair
```

ASCII:

```text
A ----\
       MUX ---- low_pair ----\
B ----/ S0                   |
                             MUX ---- Y
C ----\                      | S1
       MUX ---- high_pair ---/
D ----/ S0
```

This uses:

```text
3 total 2:1 muxes
```

General rule:

```text
an N:1 mux built only from 2:1 muxes needs N-1 muxes
```

For `N=4`:

```text
4-1 = 3 muxes
```

## Why some diagrams show both S and S-bar at the same level

There are two different things people draw:

1. a **logical mux block**
2. the **gate/transistor-level implementation inside the mux**

At the logical block level, both first-level muxes use the same select:

```text
low_pair  = S0 ? B : A
high_pair = S0 ? D : C
```

So the first level is controlled by `S0`, and the second level is controlled by `S1`.

That is what this diagram means:

```text
A ----\
       MUX ---- low_pair ----\
B ----/ S0                   |
                             MUX ---- Y
C ----\                      | S1
       MUX ---- high_pair ---/
D ----/ S0
```

But inside a 2:1 mux, the select is normally used in both true and complemented form:

```text
Y = S'D0 + S D1
```

That means:

```text
D0 path is enabled by S'
D1 path is enabled by S
```

So a gate-level mux can be drawn as:

```text
D0 ---- AND with S' ----\
                         OR ---- Y
D1 ---- AND with S  ----/
```

or as transmission gates:

```text
D0 path controlled by S'
D1 path controlled by S
```

This is why a book may show `S0` and `S0_bar` at the same level. It is not saying the two first-level muxes use different select bits. It is showing that each mux needs both phases of the same select to choose between its upper and lower input.

For a 4:1 mux, the full Boolean equation makes this clear:

```text
Y = S1'S0'A + S1'S0B + S1S0'C + S1S0D
```

Here:

- `A` and `C` are selected when `S0=0`, so they use `S0'`.
- `B` and `D` are selected when `S0=1`, so they use `S0`.
- `A/B` group is selected when `S1=0`, so it uses `S1'`.
- `C/D` group is selected when `S1=1`, so it uses `S1`.

So both statements are correct, but they are describing different abstraction levels:

```text
block level:
    first-level muxes use S0
    final mux uses S1

gate/transistor level:
    each mux internally uses S and S'
```

## Boolean equation

The 4:1 mux equation is:

```text
Y = S1'S0'A + S1'S0B + S1S0'C + S1S0D
```

Written with Verilog operators:

```text
Y = (~S1 & ~S0 & A) |
    (~S1 &  S0 & B) |
    ( S1 & ~S0 & C) |
    ( S1 &  S0 & D)
```

Each product term corresponds to one select condition.

Example:

```text
S1=1, S0=0
```

Only this term survives:

```text
S1 S0' C
```

So:

```text
Y = C
```

## Gate-level interpretation

The sum-of-products implementation uses:

- two inverters for `S1'` and `S0'`
- four AND terms
- one OR tree to combine the terms

Conceptually:

```text
A enabled by S1'S0'
B enabled by S1'S0
C enabled by S1S0'
D enabled by S1S0
```

Then:

```text
Y = enabled_A OR enabled_B OR enabled_C OR enabled_D
```

The mux-tree and sum-of-products form implement the same truth table. Synthesis may choose either style internally depending on target cells or FPGA LUT mapping.

## Delay and area

### Mux tree delay

The selected data input passes through two 2:1 mux levels:

```text
input -> first-level mux -> second-level mux -> Y
```

So the data path delay is roughly:

```text
2 mux delays
```

The select `S0` affects the first level, and `S1` affects the second level.

### Gate-level delay

In sum-of-products form, a data input passes through:

```text
AND gate -> OR gate
```

Select inputs may also pass through an inverter first.

Actual delay depends on:

- cell library
- fanout
- input slew
- output load
- FPGA LUT structure
- synthesis optimization

For RTL, the best style is usually the clear behavioral expression:

```verilog
assign y = s1 ? (s0 ? d : c) : (s0 ? b : a);
```

or a `case` statement for larger muxes.

## Synthesizable Verilog

Full file:

```text
qa/pdf_q49/q49_mux4_from_mux2.v
```

2:1 mux:

```verilog
module q49_mux2 (
    input  wire d0,
    input  wire d1,
    input  wire s,
    output wire y
);
    assign y = s ? d1 : d0;
endmodule
```

4:1 mux using three 2:1 muxes:

```verilog
module q49_mux4_from_mux2 (
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire s0,
    input  wire s1,
    output wire y
);
    wire low_pair;
    wire high_pair;

    q49_mux2 u_mux_ab (
        .d0 (a),
        .d1 (b),
        .s  (s0),
        .y  (low_pair)
    );

    q49_mux2 u_mux_cd (
        .d0 (c),
        .d1 (d),
        .s  (s0),
        .y  (high_pair)
    );

    q49_mux2 u_mux_final (
        .d0 (low_pair),
        .d1 (high_pair),
        .s  (s1),
        .y  (y)
    );
endmodule
```

Boolean version:

```verilog
assign y = (~s1 & ~s0 & a) |
           (~s1 &  s0 & b) |
           ( s1 & ~s0 & c) |
           ( s1 &  s0 & d);
```

Bus-width version:

```verilog
assign low_pair  = s0 ? b : a;
assign high_pair = s0 ? d : c;
assign y         = s1 ? high_pair : low_pair;
```

## Common mistakes

### Mistake 1: swapping select-bit order

Always define the select mapping.

This note uses:

```text
S1 S0 = 00 -> A
S1 S0 = 01 -> B
S1 S0 = 10 -> C
S1 S0 = 11 -> D
```

If you use a different convention, the wiring changes.

### Mistake 2: using only two 2:1 muxes

Two 2:1 muxes can select between four inputs only partially. You still need a final mux to select between the two pair outputs.

Correct count:

```text
3 muxes
```

### Mistake 3: misunderstanding S and S-bar in mux diagrams

With the mux-tree structure above, both first-level muxes logically use `S0`, and the final mux logically uses `S1`.

If a diagram shows `S0` and `S0_bar`, it is usually showing the internal enable signals of the mux:

```text
S0' enables the D0 path
S0  enables the D1 path
```

That does not mean one first-level mux is selected by `S0` and the other by `S0_bar`. Both muxes still respond to the same logical select bit.

### Mistake 4: writing incomplete combinational RTL

If using `always @(*)` and `case`, assign every branch or provide a default. For a 4:1 mux, all four select values should be covered.

## 49) Interview answer

A 4:1 mux can be built from three 2:1 muxes. First, use two 2:1 muxes controlled by `S0`: one chooses between `A` and `B`, and the other chooses between `C` and `D`. Then use a third 2:1 mux controlled by `S1` to choose between those two intermediate outputs. The resulting mapping is `00 -> A`, `01 -> B`, `10 -> C`, and `11 -> D`. The equivalent Boolean equation is `Y = S1'S0'A + S1'S0B + S1S0'C + S1S0D`.
