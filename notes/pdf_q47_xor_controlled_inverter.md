# PDF Q47) Use an XOR Gate as a Controlled Inverter

## Index

1. [47) Use an XOR gate as a controlled inverter](#47-use-an-xor-gate-as-a-controlled-inverter)
2. [Direct answer](#direct-answer)
3. [Truth table](#truth-table)
4. [Why XOR works](#why-xor-works)
5. [Controlled inverter versus normal inverter](#controlled-inverter-versus-normal-inverter)
6. [XNOR version](#xnor-version)
7. [Common application: add/subtract circuit](#common-application-addsubtract-circuit)
8. [Synthesizable Verilog](#synthesizable-verilog)
9. [Timing and power notes](#timing-and-power-notes)
10. [Common mistakes](#common-mistakes)
11. [47) Interview answer](#47-interview-answer)

## 47) Use an XOR gate as a controlled inverter

An XOR gate can act as either:

- a buffer
- an inverter

depending on the value of a control input.

This is why XOR is often called a controlled inverter.

## Direct answer

Connect the signal to one XOR input and the control signal to the other XOR input:

```text
Y = A XOR control
```

Behavior:

```text
control = 0 -> Y = A
control = 1 -> Y = A'
```

So the XOR conditionally inverts `A`.

## Truth table

```text
control A | Y = A ^ control
----------+----------------
   0    0 |        0
   0    1 |        1
   1    0 |        1
   1    1 |        0
```

Grouped by control:

```text
control = 0:
    Y = A ^ 0 = A

control = 1:
    Y = A ^ 1 = A'
```

## Why XOR works

XOR is `1` when the inputs are different:

```text
A ^ B = A'B + AB'
```

Let `B = control`.

```text
Y = A ^ control
```

Case 1:

```text
control = 0

Y = A ^ 0
  = A'0 + A1
  = A
```

Case 2:

```text
control = 1

Y = A ^ 1
  = A'1 + A0
  = A'
```

That is the full controlled-inverter proof.

## Controlled inverter versus normal inverter

A normal inverter always gives:

```text
Y = A'
```

A controlled inverter gives:

```text
Y = A       when control=0
Y = A'      when control=1
```

This makes the XOR useful when the same datapath must sometimes use a true value and sometimes use its complement.

ASCII view:

```text
A --------\
           XOR ---- Y
control --/
```

## XNOR version

XNOR gives the opposite control polarity:

```text
Y = ~(A ^ control)
```

Truth table:

```text
control = 0 -> Y = A'
control = 1 -> Y = A
```

So:

- XOR with control `0` passes and control `1` inverts.
- XNOR with control `0` inverts and control `1` passes.

## Common application: add/subtract circuit

The most common hardware use is an adder/subtractor.

To compute:

```text
A + B
```

use:

```text
subtract = 0
B_to_adder = B ^ 0 = B
Cin = 0
```

To compute:

```text
A - B
```

use two's complement:

```text
A - B = A + (~B) + 1
```

Set:

```text
subtract = 1
B_to_adder = B ^ 1 = ~B
Cin = 1
```

So one adder can do both:

```text
result = A + (B ^ subtract) + subtract
```

For a bus:

```verilog
assign b_to_adder = b ^ {WIDTH{subtract}};
assign result     = a + b_to_adder + subtract;
```

The replication:

```verilog
{WIDTH{subtract}}
```

creates a mask of all zeros or all ones.

Example for 4 bits:

```text
subtract = 0 -> mask = 0000 -> B unchanged
subtract = 1 -> mask = 1111 -> B inverted
```

## Synthesizable Verilog

Full file:

```text
qa/pdf_q47/q47_xor_controlled_inverter.v
```

Controlled inverter:

```verilog
module q47_xor_controlled_inverter (
    input  wire a,
    input  wire control,
    output wire y
);
    assign y = a ^ control;
endmodule
```

4-bit add/subtract example:

```verilog
module q47_add_sub_4bit (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       subtract,
    output wire [3:0] result,
    output wire       cout
);
    wire [3:0] b_to_adder;

    assign b_to_adder = b ^ {4{subtract}};
    assign {cout, result} = a + b_to_adder + subtract;
endmodule
```

## Timing and power notes

### Timing

An XOR gate is usually more complex than a simple inverter or NAND gate.

If you put XOR gates on every bit of a wide bus before an adder, they become part of the adder input timing path.

For add/subtract units this is normally acceptable, but for high-speed datapaths the XOR delay must be included in timing analysis.

### Power

When `control` toggles, every XOR output in the bus may toggle.

For example:

```text
B = 1010
control changes 0 -> 1
B_to_adder changes 1010 -> 0101
```

That can create a lot of switching activity. In low-power designs, avoid toggling control unnecessarily.

## Common mistakes

### Mistake 1: saying XOR always inverts

XOR only inverts when the control input is `1`.

```text
A ^ 0 = A
A ^ 1 = A'
```

### Mistake 2: using OR instead of XOR

OR cannot be used as a controlled inverter:

```text
A | 0 = A
A | 1 = 1
```

When control is `1`, OR forces output high instead of inverting.

### Mistake 3: forgetting the add/subtract carry-in

For subtraction:

```text
A - B = A + ~B + 1
```

The XOR mask creates `~B`, but you still need the `+1`.

That is why:

```text
Cin = subtract
```

### Mistake 4: confusing XOR and XNOR control polarity

XOR:

```text
control 0 -> pass
control 1 -> invert
```

XNOR:

```text
control 0 -> invert
control 1 -> pass
```

## 47) Interview answer

An XOR gate can be used as a controlled inverter by connecting the data input to one XOR input and the control input to the other. The output is `Y = A ^ control`. If `control=0`, then `Y=A^0=A`, so the input passes through unchanged. If `control=1`, then `Y=A^1=A'`, so the input is inverted. This is commonly used in add/subtract hardware: XOR each bit of `B` with the subtract control and use the same subtract control as the adder carry-in, so the circuit computes either `A+B` or `A+~B+1`.
