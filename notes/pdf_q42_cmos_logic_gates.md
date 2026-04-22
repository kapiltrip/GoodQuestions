# PDF Q42) Transistor-Level Equivalent of Digital Logic Gates

## Index

1. [42) Transistor-level equivalent of digital logic gates](#42-transistor-level-equivalent-of-digital-logic-gates)
2. [Direct answer](#direct-answer)
3. [CMOS switch rules](#cmos-switch-rules)
4. [Static CMOS structure](#static-cmos-structure)
5. [Inverter gate](#inverter-gate)
6. [NAND gate](#nand-gate)
7. [NOR gate](#nor-gate)
8. [AND gate](#and-gate)
9. [OR gate](#or-gate)
10. [How to derive a CMOS gate from Boolean logic](#how-to-derive-a-cmos-gate-from-boolean-logic)
11. [Why NAND and NOR are more natural than AND and OR](#why-nand-and-nor-are-more-natural-than-and-and-or)
12. [Truth table and transistor count summary](#truth-table-and-transistor-count-summary)
13. [Switch-level Verilog examples](#switch-level-verilog-examples)
14. [Common mistakes](#common-mistakes)
15. [42) Interview answer](#42-interview-answer)

## 42) Transistor-level equivalent of digital logic gates

The page shows CMOS implementations of:

- inverter
- NAND
- NOR
- AND, made from NAND plus inverter
- OR, made from NOR plus inverter

The important interview idea is not only memorizing the drawings. The important idea is understanding how the pull-up and pull-down transistor networks are built.

## Direct answer

In static CMOS, every logic gate is built from two complementary transistor networks:

```text
VDD
 |
 pull-up network   PMOS devices
 |
 Y
 |
 pull-down network NMOS devices
 |
GND
```

The pull-up network connects `Y` to `VDD` when the output should be `1`.

The pull-down network connects `Y` to `GND` when the output should be `0`.

The two networks are complementary:

```text
NMOS series    <-> PMOS parallel
NMOS parallel  <-> PMOS series
```

This duality comes from De Morgan's laws.

## CMOS switch rules

For interview-level CMOS logic, treat transistors as controlled switches.

### NMOS

An NMOS transistor turns on when its gate is high.

```text
gate = 1 -> NMOS ON
gate = 0 -> NMOS OFF
```

In logic gates, NMOS devices are normally used in the pull-down network because they pass a strong `0`.

### PMOS

A PMOS transistor turns on when its gate is low.

```text
gate = 0 -> PMOS ON
gate = 1 -> PMOS OFF
```

In logic gates, PMOS devices are normally used in the pull-up network because they pass a strong `1`.

### Series and parallel meaning

Series devices implement an AND condition for conduction:

```text
device A in series with device B conducts only when A and B are ON
```

Parallel devices implement an OR condition for conduction:

```text
device A in parallel with device B conducts when A or B is ON
```

This is why:

```text
NMOS series   -> input condition A.B
NMOS parallel -> input condition A+B
```

For PMOS, remember each PMOS turns on for an input `0`, so its conduction condition is based on complemented inputs.

## Static CMOS structure

A static CMOS gate is designed so that for a stable input combination:

- output `1`: PMOS pull-up path is ON and NMOS pull-down path is OFF
- output `0`: NMOS pull-down path is ON and PMOS pull-up path is OFF

Ideally, there is no direct DC path from `VDD` to `GND` in steady state.

There is still small leakage current, and during switching there can be a short moment when both networks conduct partially. But the main static-CMOS idea is:

```text
one network pulls the output high
the complementary network pulls the output low
```

## Inverter gate

Boolean function:

```text
Y = A'
```

Truth table:

```text
A | Y
--+--
0 | 1
1 | 0
```

CMOS structure:

```text
        VDD
         |
       PMOS
 gate=A  |
         +---- Y
         |
       NMOS
 gate=A  |
        GND
```

Operation:

- If `A = 0`, PMOS is ON and NMOS is OFF, so `Y = 1`.
- If `A = 1`, PMOS is OFF and NMOS is ON, so `Y = 0`.

Transistor count:

```text
1 PMOS + 1 NMOS = 2 transistors
```

Important physical connection:

- PMOS body/bulk is tied to `VDD`.
- NMOS body/bulk is tied to `GND`.

That keeps body diodes reverse-biased in normal operation.

## NAND gate

Boolean function:

```text
Y = (A.B)'
```

Truth table:

```text
A B | Y
----+--
0 0 | 1
0 1 | 1
1 0 | 1
1 1 | 0
```

Output should be `0` only when:

```text
A = 1 and B = 1
```

So the NMOS pull-down network must conduct only for `A.B`.

That means:

```text
NMOS A and NMOS B in series
```

The complementary PMOS pull-up network must conduct when:

```text
A = 0 or B = 0
```

That means:

```text
PMOS A and PMOS B in parallel
```

CMOS structure:

```text
        VDD          VDD
         |            |
       PMOS A      PMOS B
         |            |
         +-----+------+
               |
               Y
               |
             NMOS A
               |
             NMOS B
               |
              GND
```

Operation:

- `A=0, B=0`: both PMOS ON, both NMOS OFF, so `Y=1`.
- `A=0, B=1`: PMOS A ON, series NMOS path broken, so `Y=1`.
- `A=1, B=0`: PMOS B ON, series NMOS path broken, so `Y=1`.
- `A=1, B=1`: both PMOS OFF, both NMOS ON in series, so `Y=0`.

Transistor count:

```text
2 PMOS + 2 NMOS = 4 transistors
```

## NOR gate

Boolean function:

```text
Y = (A+B)'
```

Truth table:

```text
A B | Y
----+--
0 0 | 1
0 1 | 0
1 0 | 0
1 1 | 0
```

Output should be `0` when:

```text
A = 1 or B = 1
```

So the NMOS pull-down network must conduct for `A+B`.

That means:

```text
NMOS A and NMOS B in parallel
```

The complementary PMOS pull-up network must conduct only when:

```text
A = 0 and B = 0
```

That means:

```text
PMOS A and PMOS B in series
```

CMOS structure:

```text
        VDD
         |
       PMOS A
         |
       PMOS B
         |
         +---- Y
         |
     +---+---+
     |       |
   NMOS A  NMOS B
     |       |
    GND     GND
```

Operation:

- `A=0, B=0`: both PMOS ON in series, both NMOS OFF, so `Y=1`.
- `A=0, B=1`: NMOS B ON, PMOS B OFF, so `Y=0`.
- `A=1, B=0`: NMOS A ON, PMOS A OFF, so `Y=0`.
- `A=1, B=1`: both NMOS ON, both PMOS OFF, so `Y=0`.

Transistor count:

```text
2 PMOS + 2 NMOS = 4 transistors
```

## AND gate

Boolean function:

```text
Y = A.B
```

In static CMOS, a direct AND is normally built as:

```text
NAND followed by inverter
```

First stage:

```text
N1 = (A.B)'
```

Second stage:

```text
Y = N1' = A.B
```

Truth table:

```text
A B | Y
----+--
0 0 | 0
0 1 | 0
1 0 | 0
1 1 | 1
```

Transistor count:

```text
NAND = 4 transistors
INV  = 2 transistors
AND  = 6 transistors
```

The reason is important:

```text
static CMOS naturally creates inverting gates
```

NAND and NOR are inverting gates. AND and OR are non-inverting, so they usually need an extra inversion stage unless a more complex compound gate absorbs the inversion somewhere else.

## OR gate

Boolean function:

```text
Y = A+B
```

In static CMOS, a direct OR is normally built as:

```text
NOR followed by inverter
```

First stage:

```text
N1 = (A+B)'
```

Second stage:

```text
Y = N1' = A+B
```

Truth table:

```text
A B | Y
----+--
0 0 | 0
0 1 | 1
1 0 | 1
1 1 | 1
```

Transistor count:

```text
NOR = 4 transistors
INV = 2 transistors
OR  = 6 transistors
```

## How to derive a CMOS gate from Boolean logic

A reliable method:

1. Decide when the output should be `0`.
2. Build the NMOS pull-down network for that condition.
3. Build the PMOS pull-up network as the dual network.
4. Check that for every input combination, exactly one network has a valid path.

Example for NAND:

```text
Y = (A.B)'

Y = 0 when A.B = 1

PDN = A series B NMOS
PUN = A parallel B PMOS
```

Example for NOR:

```text
Y = (A+B)'

Y = 0 when A+B = 1

PDN = A parallel B NMOS
PUN = A series B PMOS
```

Another way:

```text
series in the NMOS network becomes parallel in the PMOS network
parallel in the NMOS network becomes series in the PMOS network
```

This is the physical version of De Morgan's law:

```text
(A.B)' = A' + B'
(A+B)' = A'.B'
```

## Why NAND and NOR are more natural than AND and OR

Static CMOS gates are naturally inverting because:

- the NMOS network directly defines when the output is pulled low
- the PMOS network directly defines when the output is pulled high
- a single-stage static CMOS gate naturally gives a complemented form

So:

```text
single-stage static CMOS:
    inverter
    NAND
    NOR
    AOI/OAI compound gates

usually two-stage static CMOS:
    AND = NAND + inverter
    OR  = NOR  + inverter
```

This is also why standard-cell libraries often use NAND/NOR/AOI/OAI gates heavily.

### NAND versus NOR practical note

In silicon, PMOS devices are usually weaker than NMOS devices for the same size because hole mobility is lower than electron mobility.

A two-input NOR has two PMOS devices in series in the pull-up network. That stacked PMOS path is relatively slow unless the PMOS devices are made larger.

A two-input NAND has PMOS devices in parallel in the pull-up network and NMOS devices in series in the pull-down network. Since NMOS devices are stronger, NAND often gives better area/speed tradeoffs than NOR for many standard-cell designs.

Interview shorthand:

```text
NAND is often preferred over NOR in CMOS because stacked PMOS in NOR is expensive and slow.
```

That is a practical implementation trend, not a Boolean rule.

## Truth table and transistor count summary

```text
Gate      Boolean      Output is 0 when       CMOS structure          Count
--------  -----------  ---------------------  ----------------------  -----
INV       A'           A=1                    1 PMOS + 1 NMOS          2
NAND2     (A.B)'       A=1 and B=1            PMOS parallel, NMOS series 4
NOR2      (A+B)'       A=1 or B=1             PMOS series, NMOS parallel 4
AND2      A.B          not a natural inverter NAND2 + INV               6
OR2       A+B          not a natural inverter NOR2 + INV                6
```

Truth tables:

```text
A B | NAND NOR AND OR
----+----------------
0 0 |  1    1   0   0
0 1 |  1    0   0   1
1 0 |  1    0   0   1
1 1 |  0    0   1   1
```

## Switch-level Verilog examples

Normal synthesizable RTL should use Boolean operators such as:

```verilog
assign y = ~(a & b);
```

But for learning transistor-level behavior, Verilog has switch primitives such as `pmos` and `nmos`.

These are mainly for simulation/education, not normal RTL synthesis.

### CMOS inverter

```verilog
module cmos_inv_switch (
    input  wire a,
    output wire y
);
    supply1 vdd;
    supply0 gnd;

    pmos p0 (y, vdd, a);
    nmos n0 (y, gnd, a);
endmodule
```

### CMOS NAND

```verilog
module cmos_nand2_switch (
    input  wire a,
    input  wire b,
    output wire y
);
    supply1 vdd;
    supply0 gnd;
    wire n_mid;

    pmos p0 (y, vdd, a);
    pmos p1 (y, vdd, b);

    nmos n0 (y,     n_mid, a);
    nmos n1 (n_mid, gnd,   b);
endmodule
```

### CMOS NOR

```verilog
module cmos_nor2_switch (
    input  wire a,
    input  wire b,
    output wire y
);
    supply1 vdd;
    supply0 gnd;
    wire p_mid;

    pmos p0 (p_mid, vdd,   a);
    pmos p1 (y,     p_mid, b);

    nmos n0 (y, gnd, a);
    nmos n1 (y, gnd, b);
endmodule
```

### Synthesizable RTL equivalents

```verilog
assign inv_y  = ~a;
assign nand_y = ~(a & b);
assign nor_y  = ~(a | b);
assign and_y  = a & b;
assign or_y   = a | b;
```

The synthesis tool maps these Boolean functions to standard cells. The final implementation may use NAND, NOR, AOI, OAI, or other optimized cells depending on timing, area, and power.

## Common mistakes

### Mistake 1: swapping NAND and NOR transistor networks

Remember:

```text
NAND:
    NMOS series
    PMOS parallel

NOR:
    NMOS parallel
    PMOS series
```

### Mistake 2: saying AND is only two transistors

An AND gate is not made from one PMOS and one NMOS. That is an inverter.

In normal static CMOS:

```text
AND = NAND + inverter = 6 transistors
```

### Mistake 3: forgetting PMOS turns on with input 0

PMOS devices are controlled by the complemented input condition.

Example:

```text
input A = 0 -> PMOS A ON
input A = 1 -> PMOS A OFF
```

### Mistake 4: thinking transistor-level drawings are the same as RTL style

RTL describes behavior:

```verilog
assign y = ~(a & b);
```

The standard-cell library and synthesis tool choose the physical implementation. For most RTL design, you do not draw transistors manually. But knowing the transistor networks helps explain area, delay, power, and why NAND/NOR gates are common.

## 42) Interview answer

In static CMOS, each logic gate has a PMOS pull-up network to `VDD` and an NMOS pull-down network to `GND`. NMOS turns on for input `1` and is used to pull the output low; PMOS turns on for input `0` and is used to pull the output high. For an inverter, one PMOS and one NMOS share the same gate input, giving `Y=A'`. For a NAND, the NMOS devices are in series because the output should go low only when `A` and `B` are both `1`; the PMOS devices are in parallel. For a NOR, the NMOS devices are in parallel because the output should go low when `A` or `B` is `1`; the PMOS devices are in series. AND is normally NAND followed by an inverter, and OR is normally NOR followed by an inverter. The key rule is that the pull-up and pull-down networks are duals of each other.
