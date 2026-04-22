# PDF Q48) Design Inverter, AND, OR, and XOR Using Only NAND Gates

## Index

1. [48) Design inverter, AND, OR, and XOR using only NAND gates](#48-design-inverter-and-or-and-xor-using-only-nand-gates)
2. [Direct answer](#direct-answer)
3. [Why NAND is universal](#why-nand-is-universal)
4. [Inverter using NAND](#inverter-using-nand)
5. [AND using NAND](#and-using-nand)
6. [OR using NAND](#or-using-nand)
7. [XOR using NAND](#xor-using-nand)
8. [Optional NOR using NAND](#optional-nor-using-nand)
9. [Gate count summary](#gate-count-summary)
10. [Synthesizable Verilog](#synthesizable-verilog)
11. [Common mistakes](#common-mistakes)
12. [48) Interview answer](#48-interview-answer)

## 48) Design inverter, AND, OR, and XOR using only NAND gates

The question asks for basic gates implemented only with NAND gates.

NAND is called a universal gate because any Boolean function can be built using only NAND gates.

## Direct answer

Use these constructions:

```text
NOT:
    A' = NAND(A, A)

AND:
    AB = NAND(NAND(A,B), NAND(A,B))

OR:
    A+B = NAND(NAND(A,A), NAND(B,B))

XOR:
    N1 = NAND(A,B)
    N2 = NAND(A,N1)
    N3 = NAND(B,N1)
    Y  = NAND(N2,N3)
```

## Why NAND is universal

A NAND gate gives:

```text
NAND(A,B) = (AB)'
```

If we can build:

- NOT
- AND
- OR

then we can build any combinational Boolean function.

NAND can build all three, so NAND is functionally complete.

The most important identity is De Morgan's law:

```text
A + B = (A'B')'
```

NAND naturally gives the outside inversion:

```text
NAND(A', B') = (A'B')' = A+B
```

So if we can create `A'` and `B'` with NAND gates, we can create OR.

## Inverter using NAND

Tie the two NAND inputs together:

```text
Y = NAND(A, A)
```

Equation:

```text
Y = (A.A)' = A'
```

ASCII:

```text
A ----\
      NAND ---- Y = A'
A ----/
```

Truth table:

```text
A | Y
--+--
0 | 1
1 | 0
```

Gate count:

```text
1 NAND
```

## AND using NAND

NAND gives the inverted AND:

```text
N1 = (AB)'
```

Invert it with another NAND:

```text
Y = NAND(N1, N1)
  = N1'
  = ((AB)')'
  = AB
```

ASCII:

```text
A ----\
      NAND ---- N1 ----\
B ----/                NAND ---- Y = AB
               N1 ----/
```

Gate count:

```text
2 NAND gates
```

## OR using NAND

Use De Morgan:

```text
A+B = (A'B')'
```

Create `A'` and `B'` using NAND-as-inverter:

```text
NA = NAND(A,A) = A'
NB = NAND(B,B) = B'
```

Then:

```text
Y = NAND(NA, NB)
  = (A'B')'
  = A+B
```

ASCII:

```text
A ----\
      NAND ---- A' ----\
A ----/                |
                       NAND ---- Y = A+B
B ----\                |
      NAND ---- B' ----/
B ----/
```

Gate count:

```text
3 NAND gates
```

## XOR using NAND

XOR equation:

```text
Y = A'B + AB'
```

A compact NAND-only construction uses four NAND gates:

```text
N1 = NAND(A, B)
N2 = NAND(A, N1)
N3 = NAND(B, N1)
Y  = NAND(N2, N3)
```

ASCII:

```text
          +------+
A --------|      |
          | NAND |---- N1
B --------|      |
          +------+

A -------- NAND with N1 ---- N2
B -------- NAND with N1 ---- N3

N2 -------\
          NAND ---- Y
N3 -------/
```

### Why the 4-NAND XOR works

Let:

```text
N1 = (AB)'
```

Then:

```text
N2 = (A.N1)'
   = (A.(AB)')'
```

Since:

```text
(AB)' = A' + B'
```

then:

```text
A.(AB)' = A(A' + B') = AA' + AB' = AB'
```

So:

```text
N2 = (AB')'
```

Similarly:

```text
N3 = (A'B)'
```

Final output:

```text
Y = NAND(N2, N3)
  = (N2.N3)'
  = ((AB')'.(A'B)')'
```

Using De Morgan:

```text
Y = AB' + A'B
```

That is XOR.

Gate count:

```text
4 NAND gates
```

## Optional NOR using NAND

NOR is the inverse of OR:

```text
NOR = (A+B)'
```

Build OR using NAND, then invert it with another NAND:

```text
OR_AB = NAND(NAND(A,A), NAND(B,B))
Y     = NAND(OR_AB, OR_AB)
```

Gate count:

```text
4 NAND gates
```

## Gate count summary

```text
Gate   NAND-only construction                         NAND count
-----  ---------------------------------------------  ----------
NOT    NAND(A,A)                                      1
AND    NAND output followed by NAND inverter          2
OR     invert both inputs, then NAND                  3
NOR    OR construction followed by NAND inverter      4
XOR    standard shared-middle NAND structure          4
```

There are alternative NAND-only implementations, but these are the common interview answers.

## Synthesizable Verilog

Full file:

```text
qa/pdf_q48/q48_gates_using_nand.v
```

Inverter:

```verilog
assign y = ~(a & a);
```

AND:

```verilog
wire nand_ab;

assign nand_ab = ~(a & b);
assign y       = ~(nand_ab & nand_ab);
```

OR:

```verilog
wire not_a;
wire not_b;

assign not_a = ~(a & a);
assign not_b = ~(b & b);
assign y     = ~(not_a & not_b);
```

XOR:

```verilog
wire nand_ab;
wire a_term;
wire b_term;

assign nand_ab = ~(a & b);
assign a_term  = ~(a & nand_ab);
assign b_term  = ~(b & nand_ab);
assign y       = ~(a_term & b_term);
```

For production RTL, normally write:

```verilog
assign y = a ^ b;
```

The NAND-only implementation is for gate-level reasoning and interview practice. Synthesis may map the direct XOR to a real XOR cell or other optimized structure.

## Common mistakes

### Mistake 1: using NAND(A,B) as AND

```text
NAND(A,B) = (AB)'
```

That is not AND. You need one more NAND as an inverter.

### Mistake 2: building OR as NAND(A,B)

NAND is:

```text
A' + B'
```

not:

```text
A + B
```

For OR, invert the inputs first:

```text
A+B = (A'B')'
```

### Mistake 3: forgetting shared node in XOR

The compact XOR uses the first NAND output twice:

```text
N1 = NAND(A,B)
N2 = NAND(A,N1)
N3 = NAND(B,N1)
Y  = NAND(N2,N3)
```

If `N1` is not reused correctly, the circuit will not be XOR.

### Mistake 4: assuming NAND-only is always optimal

NAND-only construction is important because NAND is universal. But a real synthesis flow may choose an XOR cell, AOI/OAI gate, or LUT implementation depending on target technology.

## 48) Interview answer

NAND is a universal gate. To make an inverter, tie both NAND inputs together: `A' = NAND(A,A)`. To make AND, first make `N1=NAND(A,B)=(AB)'`, then invert it with `NAND(N1,N1)` to get `AB`. To make OR, use De Morgan: `A+B=(A'B')'`, so create `A'=NAND(A,A)` and `B'=NAND(B,B)`, then NAND those two signals. XOR can be built with four NAND gates: `N1=NAND(A,B)`, `N2=NAND(A,N1)`, `N3=NAND(B,N1)`, and `Y=NAND(N2,N3)`.
