# PDF Q46) Creating Digital Logic Gates Using a 2:1 Mux

## Index

1. [46) Creating digital logic gates using a 2:1 mux](#46-creating-digital-logic-gates-using-a-21-mux)
2. [Direct answer](#direct-answer)
3. [2:1 mux equation](#21-mux-equation)
4. [Why a mux can build any Boolean function](#why-a-mux-can-build-any-boolean-function)
5. [Inverter using a 2:1 mux](#inverter-using-a-21-mux)
6. [AND using a 2:1 mux](#and-using-a-21-mux)
7. [OR using a 2:1 mux](#or-using-a-21-mux)
8. [NAND using a 2:1 mux](#nand-using-a-21-mux)
9. [NOR using a 2:1 mux](#nor-using-a-21-mux)
10. [XOR using a 2:1 mux](#xor-using-a-21-mux)
11. [XNOR using a 2:1 mux](#xnor-using-a-21-mux)
12. [Summary table](#summary-table)
13. [Synthesizable Verilog](#synthesizable-verilog)
14. [Practical notes](#practical-notes)
15. [46) Interview answer](#46-interview-answer)

## 46) Creating digital logic gates using a 2:1 mux

The question asks how to create basic digital gates using a 2:1 mux.

This is mostly a Boolean reasoning question. The goal is to understand that a mux can select one expression when a variable is `0` and another expression when the variable is `1`.

## Direct answer

For a 2:1 mux:

```text
S = 0 -> Y = D0
S = 1 -> Y = D1
```

Equation:

```text
Y = S'D0 + S D1
```

Using constants `0`, `1`, and sometimes an inverted input, we can implement gates:

```text
Gate  Select  D0   D1   Output
----  ------  ---  ---  ----------------
NOT   A       1    0    A'
AND   A       0    B    AB
OR    A       B    1    A+B
NAND  B       1    A'   (AB)'
NOR   A       B'   0    (A+B)'
XOR   A       B    B'   A xor B
XNOR  A       B'   B    A xnor B
```

## 2:1 mux equation

A 2:1 mux chooses between `D0` and `D1`.

```text
      D0 ----\
              MUX ---- Y
      D1 ----/
              ^
              |
              S
```

Equation:

```text
Y = S'D0 + S D1
```

This means:

- when `S=0`, `S'=1`, so `Y=D0`
- when `S=1`, `S=1`, so `Y=D1`

The select input can be one of the logic variables, and the data inputs can be:

- `0`
- `1`
- another variable
- an inverted variable
- another smaller logic expression

## Why a mux can build any Boolean function

This comes from Shannon expansion.

For any Boolean function `F(A, B, C, ...)`, choose one variable, for example `A`.

Then:

```text
F = A'F(A=0) + A F(A=1)
```

This is exactly a mux:

```text
S  = A
D0 = F when A=0
D1 = F when A=1
```

So:

```text
F = mux(A, F0, F1)
```

This is the deep reason a mux can implement arbitrary combinational logic.

For two-input gates, if we choose `A` as the select line, we just ask:

```text
what should Y be when A=0?
what should Y be when A=1?
```

Those two answers become `D0` and `D1`.

## Inverter using a 2:1 mux

Target:

```text
Y = A'
```

Use:

```text
S  = A
D0 = 1
D1 = 0
```

Check:

```text
A=0 -> Y=D0=1
A=1 -> Y=D1=0
```

So:

```text
Y = A'
```

Equation:

```text
Y = A'.1 + A.0 = A'
```

## AND using a 2:1 mux

Target:

```text
Y = AB
```

Use:

```text
S  = A
D0 = 0
D1 = B
```

Check:

```text
A=0 -> Y=0
A=1 -> Y=B
```

So:

```text
Y = A ? B : 0 = AB
```

Equation:

```text
Y = A'.0 + A.B = AB
```

## OR using a 2:1 mux

Target:

```text
Y = A+B
```

Use:

```text
S  = A
D0 = B
D1 = 1
```

Check:

```text
A=0 -> Y=B
A=1 -> Y=1
```

So:

```text
Y = A ? 1 : B = A+B
```

Equation:

```text
Y = A'B + A.1 = A'B + A = A+B
```

## NAND using a 2:1 mux

Target:

```text
Y = (AB)'
```

Use:

```text
S  = B
D0 = 1
D1 = A'
```

Check:

```text
B=0 -> Y=1
B=1 -> Y=A'
```

So:

```text
Y = B ? A' : 1
```

Equation:

```text
Y = B'.1 + B.A'
  = B' + A'B
  = A' + B'
  = (AB)'
```

Equivalent valid choice:

```text
S=A, D0=1, D1=B'
```

## NOR using a 2:1 mux

Target:

```text
Y = (A+B)' = A'B'
```

Use:

```text
S  = A
D0 = B'
D1 = 0
```

Check:

```text
A=0 -> Y=B'
A=1 -> Y=0
```

So:

```text
Y = A ? 0 : B' = A'B'
```

Equation:

```text
Y = A'B' + A.0 = A'B' = (A+B)'
```

## XOR using a 2:1 mux

Target:

```text
Y = A xor B
```

XOR means:

```text
if A=0, output B
if A=1, output B'
```

Use:

```text
S  = A
D0 = B
D1 = B'
```

Check:

```text
A=0 -> Y=B
A=1 -> Y=B'
```

Equation:

```text
Y = A'B + AB'
```

which is XOR.

## XNOR using a 2:1 mux

Target:

```text
Y = A xnor B
```

XNOR means:

```text
if A=0, output B'
if A=1, output B
```

Use:

```text
S  = A
D0 = B'
D1 = B
```

Check:

```text
A=0 -> Y=B'
A=1 -> Y=B
```

Equation:

```text
Y = A'B' + AB
```

which is XNOR.

## Summary table

Assuming mux convention:

```text
S=0 -> D0
S=1 -> D1
```

Use these connections:

```text
Gate    S    D0   D1   Equation
------  ---  ---  ---  -----------------------
INV     A    1    0    A'
AND     A    0    B    AB
OR      A    B    1    A+B
NAND    B    1    A'   A'+B' = (AB)'
NOR     A    B'   0    A'B' = (A+B)'
XOR     A    B    B'   A'B + AB'
XNOR    A    B'   B    A'B' + AB
```

There are usually multiple correct mux implementations for the same gate. For example, AND can also be:

```text
S=B, D0=0, D1=A
```

because:

```text
B ? A : 0 = AB
```

## Synthesizable Verilog

Full file:

```text
qa/pdf_q46/q46_gates_using_mux2.v
```

2:1 mux:

```verilog
module q46_mux2 (
    input  wire d0,
    input  wire d1,
    input  wire s,
    output wire y
);
    assign y = s ? d1 : d0;
endmodule
```

AND using mux:

```verilog
q46_mux2 u_mux (.d0(1'b0), .d1(b), .s(a), .y(y));
```

OR using mux:

```verilog
q46_mux2 u_mux (.d0(b), .d1(1'b1), .s(a), .y(y));
```

XOR using mux:

```verilog
q46_mux2 u_mux (.d0(b), .d1(~b), .s(a), .y(y));
```

In normal RTL, write the logic directly:

```verilog
assign y = a ^ b;
```

The mux implementation is mainly useful for learning, interviews, and understanding LUT/mux-style logic structures.

## Practical notes

### This is not usually the best physical implementation

Do not assume a gate made from muxes is smaller or faster than a real standard-cell gate.

For ASIC:

- the library has optimized NAND, NOR, XOR, AOI, OAI cells
- synthesis picks cells based on timing, area, and power

For FPGA:

- logic is implemented inside LUTs and routing
- writing the natural Boolean expression is usually best

### Constants matter

The diagrams use `VDD` and `GND`.

In RTL, those are:

```verilog
1'b1
1'b0
```

### Know the mux convention

Some diagrams label the upper input as `0` and lower input as `1`; others use `I0/I1`.

Always state your convention:

```text
S=0 selects D0
S=1 selects D1
```

Then derive the connections from the truth table.

## 46) Interview answer

A 2:1 mux implements `Y = S'D0 + S D1`. To build a gate, choose one input as the select and set `D0` to the required output when that input is `0`, and `D1` to the required output when that input is `1`. For example, for AND choose `S=A`, `D0=0`, and `D1=B`, giving `Y=AB`. For OR choose `S=A`, `D0=B`, and `D1=1`, giving `Y=A+B`. For inverter choose `S=A`, `D0=1`, and `D1=0`, giving `Y=A'`. For XOR choose `S=A`, `D0=B`, and `D1=B'`, giving `Y=A'B+AB'`.
