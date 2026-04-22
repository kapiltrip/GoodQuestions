# PDF Q50) Frequency, Period, and Propagation Delay

## Index

1. [50) Frequency, period, and propagation delay](#50-frequency-period-and-propagation-delay)
2. [Direct answer](#direct-answer)
3. [Frequency and period relationship](#frequency-and-period-relationship)
4. [Propagation delay](#propagation-delay)
5. [Critical path](#critical-path)
6. [Solving the shown circuit](#solving-the-shown-circuit)
7. [Why the worst path is 3 gate delays](#why-the-worst-path-is-3-gate-delays)
8. [Sequential timing version](#sequential-timing-version)
9. [Unit conversions](#unit-conversions)
10. [Important real-world timing notes](#important-real-world-timing-notes)
11. [Common mistakes](#common-mistakes)
12. [50) Interview answer](#50-interview-answer)

## 50) Frequency, period, and propagation delay

The page asks:

```text
Assuming propagation delay through each gate is 1 ns,
what is the maximum frequency this circuit can run?
```

The drawn circuit is basically a full-adder style structure:

```text
sum  = A ^ B ^ Cin
cout = (A & B) | (Cin & (A ^ B))
```

The key is to find the worst combinational path delay.

## Direct answer

The worst path goes through 3 gates:

```text
A or B -> XOR -> AND -> OR -> Carry Out
```

Each gate has:

```text
1 ns delay
```

So:

```text
critical path delay = 3 gates * 1 ns/gate = 3 ns
```

Maximum ideal frequency:

```text
fmax = 1 / T
     = 1 / 3 ns
     = 333.33 MHz
```

So the answer is:

```text
maximum frequency = 333.33 MHz
```

This is the simplified answer, ignoring flop clock-to-Q, setup time, skew, uncertainty, and wire delay.

## Frequency and period relationship

Frequency and period are reciprocals:

```text
f = 1 / T
T = 1 / f
```

Where:

- `f` is frequency in hertz
- `T` is period in seconds

Examples:

```text
T = 10 ns -> f = 100 MHz
T = 5 ns  -> f = 200 MHz
T = 2 ns  -> f = 500 MHz
T = 1 ns  -> f = 1 GHz
```

For this question:

```text
T = 3 ns
```

Therefore:

```text
f = 1 / (3 * 10^-9)
  = 333,333,333.33 Hz
  = 333.33 MHz
```

## Propagation delay

Propagation delay is the time it takes for a change at a gate input to affect the gate output.

For a gate:

```text
input changes at time t
output becomes valid at time t + tpd
```

The question assumes:

```text
tpd for every gate = 1 ns
```

So a path passing through:

- 1 gate = 1 ns
- 2 gates = 2 ns
- 3 gates = 3 ns

In real timing libraries, different gates have different delays. A 2-input NAND, 3-input AND, XOR, and OR do not all have the same delay. But for this interview-style problem, each gate is assumed to be 1 ns.

## Critical path

The critical path is the slowest path through the combinational logic.

The circuit can only run as fast as its slowest required path.

If one output settles in 2 ns and another output settles in 3 ns, the circuit result is not fully valid until:

```text
3 ns
```

So the clock period must be at least the worst-case delay, not the average delay.

Simplified rule:

```text
minimum clock period >= critical path delay
maximum clock frequency <= 1 / critical path delay
```

## Solving the shown circuit

The circuit has inputs:

```text
A
B
Carry In
```

Outputs:

```text
Sum
Carry Out
```

Logic:

```text
P    = A ^ B
Sum  = P ^ Cin
G    = A & B
PC   = P & Cin
Cout = G | PC
```

Where:

- `P` means propagate
- `G` means generate

Path delays:

```text
A/B -> P:
    XOR = 1 ns

P -> Sum:
    XOR = 1 ns

A/B -> Sum:
    XOR + XOR = 2 ns

Cin -> Sum:
    XOR = 1 ns

A/B -> G -> Cout:
    AND + OR = 2 ns

Cin -> PC -> Cout:
    AND + OR = 2 ns

A/B -> P -> PC -> Cout:
    XOR + AND + OR = 3 ns
```

Worst path:

```text
A/B -> XOR -> AND -> OR -> Cout
```

Critical delay:

```text
3 ns
```

## Why the worst path is 3 gate delays

The carry-out has two ways to become `1`:

```text
Cout = (A & B) | (Cin & (A ^ B))
```

The direct generate path is:

```text
A/B -> AND -> OR
```

That is 2 gates.

The propagate path is:

```text
A/B -> XOR -> AND with Cin -> OR
```

That is 3 gates.

Since `Cout` depends on both paths, the output cannot be trusted until the slower path is stable.

So:

```text
critical path = propagate carry path
```

## Sequential timing version

A purely combinational circuit does not "run at a frequency" by itself.

Frequency matters when the logic is placed between registers:

```text
launch flop -> combinational logic -> capture flop
```

The real setup timing equation is:

```text
Tclk >= Tcq + Tcomb_max + Tsetup + Tskew_or_uncertainty_margin
```

Where:

- `Tcq`: launch flop clock-to-Q delay
- `Tcomb_max`: maximum combinational delay
- `Tsetup`: setup time of capture flop
- clock skew/uncertainty: clocking margin

The page's simplified calculation assumes:

```text
Tcq = 0
Tsetup = 0
wire delay = 0
skew/uncertainty = 0
```

So:

```text
Tclk >= Tcomb_max = 3 ns
```

In a real chip, if:

```text
Tcq      = 0.20 ns
Tcomb    = 3.00 ns
Tsetup   = 0.15 ns
margin   = 0.10 ns
```

then:

```text
Tclk >= 0.20 + 3.00 + 0.15 + 0.10
     >= 3.45 ns
```

and:

```text
fmax = 1 / 3.45 ns = 289.86 MHz
```

So the interview answer `333.33 MHz` is correct only for the simplified assumptions.

## Unit conversions

Useful conversions:

```text
1 s  = 10^3 ms
1 ms = 10^3 us
1 us = 10^3 ns
1 ns = 10^3 ps
```

Frequency:

```text
1 Hz  = 1 cycle/second
1 kHz = 10^3 Hz
1 MHz = 10^6 Hz
1 GHz = 10^9 Hz
```

Shortcut:

```text
frequency in MHz = 1000 / period in ns
```

For this question:

```text
period = 3 ns

fMHz = 1000 / 3
     = 333.33 MHz
```

More examples:

```text
period 1 ns  -> 1000 MHz = 1 GHz
period 2 ns  -> 500 MHz
period 4 ns  -> 250 MHz
period 10 ns -> 100 MHz
```

## Important real-world timing notes

### Gate delay is not constant

Real gate delay depends on:

- input transition time
- output load capacitance
- cell drive strength
- process corner
- voltage
- temperature
- fanout
- placement and routing

An XOR gate is usually slower than a simple NAND gate, but the problem simplifies every gate to 1 ns.

### Wire delay matters

In modern designs, wire delay can be comparable to or larger than cell delay.

The real path is:

```text
cell delay + net delay + cell delay + net delay + ...
```

### Setup and hold are separate

Maximum frequency is usually a setup timing question:

```text
can data arrive before the next clock edge?
```

Hold timing is different:

```text
does data change too soon after the same clock edge?
```

Slowing the clock helps setup but usually does not fix hold.

### Input/output paths need external assumptions

For a module input-to-output path, timing also depends on:

- when the input arrives relative to clock
- what captures the output
- board delay or parent-module delay
- input/output constraints

That is why static timing constraints include input delays and output delays.

## Common mistakes

### Mistake 1: counting all gates in the circuit

Do not add every gate in the drawing.

Only add gates along one input-to-output path.

Then choose the longest path.

### Mistake 2: using the shortest path

The fastest output transition does not set maximum frequency.

The slowest required path sets maximum frequency.

### Mistake 3: forgetting the first XOR in the carry path

For carry-out:

```text
A/B -> XOR -> AND -> OR
```

That is 3 gates.

If you count only:

```text
AND -> OR
```

you miss the propagate path.

### Mistake 4: using frequency = period

Frequency and period are reciprocals:

```text
f = 1/T
```

For:

```text
T = 3 ns
```

frequency is not `3 MHz`; it is `333.33 MHz`.

### Mistake 5: ignoring real register overhead in production timing

The simplified answer is 333.33 MHz. Real `fmax` would be lower after adding:

- `Tcq`
- setup time
- clock uncertainty
- wire delay
- clock skew effects

## 50) Interview answer

First I would find the critical path, not count every gate in the circuit. The sum path from `A` or `B` goes through two XOR gates, so it is 2 ns. The carry-out has a direct generate path through AND then OR, which is 2 ns, but it also has a propagate path from `A` or `B` through XOR, then AND with `Cin`, then OR to `Cout`, which is 3 gate delays. Since each gate is 1 ns, the critical path is 3 ns. Using `f = 1/T`, the maximum simplified frequency is `1/3 ns = 333.33 MHz`. In a real sequential circuit I would also include clock-to-Q, setup time, clock uncertainty, skew, and routing delay.
