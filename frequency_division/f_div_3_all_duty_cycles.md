# Divide-by-3 Duty Cycles

This note covers synchronous divide-by-3 generation for the common duty-cycle cases:

- 33.33%
- 66.67%
- exact 50%

It also answers the design-choice question directly:

- for `/3`, `MSB` or `LSB` outputs from a mod-3 counter can realize non-50% duty cycles
- but **exact 50% must not be justified by “one bit looks close”**
- exact 50% for `/3` needs opposite-edge or half-cycle-assisted timing

## What Is Verified vs Derived

- **Verified from sources**
  - divide-by-3 naturally gives `33%/67%` or `67%/33%` style duty cycles with single-edge division
  - exact 50% for odd divide needs opposite-edge or equivalent odd-divider handling
  - vendor clocking hardware treats odd divide as a special case when 50% duty is required
- **Derived in this note**
  - the specific mod-3 state sequence
  - the T-FF excitation table and Boolean equations
  - the sample state-decode examples below
  - the interpretation of which chosen counter bits produce `33.33%` or `66.67%`

Verified references used in this note:

- Intel MAX 10 Clocking and PLL User Guide:
  https://www.intel.com/content/www/us/en/docs/programmable/683047/21-1/post-scale-counters-c0-to-c4.html
- Intel AN 507:
  https://cdrdv2-public.intel.com/653755/an507.pdf
- Analog Devices AD9512 data sheet:
  https://www.analog.com/media/en/technical-documentation/data-sheets/AD9512.pdf
- Analog Devices AD9510 FAQ:
  https://www.analog.com/en/resources/faqs/faq_on_the_ad9510_how_make_sure_that_duty_cycle_of.html
- Microchip Divide-by-Three CLB note:
  https://developerhelp.microchip.com/xwiki/bin/view/products/mcu-mpu/8-bit-mcu-tips-tricks/configurable-logic-block/divide-by-three/
- onsemi AND8001/D:
  https://www.onsemi.com/download/application-notes/pdf/and8001-d.pdf

## 1) Start with a synchronous mod-3 counter

Use a fixed 3-state sequence. One clear choice is implemented with two positive-edge-triggered T flip-flops:

- `Q1` = LSB
- `Q2` = MSB

Desired count sequence:

```text
Q2Q1: 00 -> 01 -> 10 -> 00 -> ...
```

For a T flip-flop:

- `T = 1` means toggle
- `T = 0` means hold

From the sequence:

- `00 -> 01`: `Q1` toggles, `Q2` holds
- `01 -> 10`: `Q1` toggles, `Q2` toggles
- `10 -> 00`: `Q1` holds,   `Q2` toggles

So the excitation table is:

```text
Present Q2Q1   T2   T1
00             0    1
01             1    1
10             1    0
```

One valid simplification is:

```text
T2 = Q2 + Q1
T1 = ~Q2 + Q1
```

These equations generate the required `00 -> 01 -> 10 -> 00` synchronous mod-3 sequence.

The divide-by-3 fact comes from the repeat length:

```text
Tout = 3 * Tin
fout = fin / 3
```

Once the sequence is fixed, output duty cycle is decided by **which valid states are decoded as high**.

## 2) Divide-by-3 with 33.33% duty cycle

Choose the output high in only one of the three valid states.

Example:

```text
Y33 = ~Q2 & ~Q1
```

That is high only in state `00`.

So the output sequence is:

```text
1 -> 0 -> 0 -> 1 -> 0 -> 0 -> ...
```

Meaning:

- high for 1 clock
- low for 2 clocks
- total period = 3 input clocks

Therefore:

```text
fout = fin / 3
duty = 1/3 = 33.33%
```

This matches the general divider behavior documented by Analog Devices, which lists divide ratio `3` duty cycles of `67%` and `33%`.

Sources:

- AD9512 Table 12 lists divide ratio `3` duty cycles of `67%` and `33%`:
  https://www.analog.com/media/en/technical-documentation/data-sheets/AD9512.pdf
- AD9510 FAQ states directly that divide-by-3 produces `33.3%-66.6%`:
  https://www.analog.com/en/resources/faqs/faq_on_the_ad9510_how_make_sure_that_duty_cycle_of.html

## 3) Divide-by-3 with 66.67% duty cycle

Choose the output high in two of the three valid states.

Example:

```text
Y66 = ~Q2
```

Why:

- at `00`, `Q2 = 0` -> output high
- at `01`, `Q2 = 0` -> output high
- at `10`, `Q2 = 1` -> output low

So the output sequence is:

```text
1 -> 1 -> 0 -> 1 -> 1 -> 0 -> ...
```

Meaning:

- high for 2 clocks
- low for 1 clock

Therefore:

```text
fout = fin / 3
duty = 2/3 = 66.67%
```

Again, this is the `2 of 3 states high` case, which is why it matches the vendor-documented `67%/33%` behavior for divide-by-3.

## 4) Why “MSB vs LSB” is not the right rule

This is the important design-answer point.

For a pure binary divide-by-2 stage:

- the LSB naturally toggles every clock
- so it is naturally 50%

But a mod-3 counter is **not** a free-running full binary count.
It is a truncated sequence with only 3 valid states.

So bit waveforms must be checked from the actual valid-state sequence, not guessed from binary-counter intuition.

For the chosen mod-3 sequence:

- `Q1` pattern is `0, 1, 0`
- `Q2` pattern is `0, 0, 1`

So each raw bit is high in only 1 valid state out of 3:

```text
duty(Q1) = duty(Q2) = 1/3 = 33.33%
```

and each inverted bit is high in 2 valid states out of 3:

```text
duty(~Q1) = duty(~Q2) = 2/3 = 66.67%
```

That is the exact reason the usual “LSB is naturally 50%” shortcut fails here. In a truncated mod-3 machine, the bit waveforms are sequence-dependent.

So:

- choosing `MSB` or `LSB` is only a **decode convenience**
- it is **not** a rule for “closest to 50%”
- if the question asks for exact 50%, do not answer by saying “pick the right bit”

The safe interview/exam rule is:

> for odd dividers, use single-edge state decoding for non-50% duty cycles; use both edges or half-cycle extension for exact 50%

## 5) Why exact 50% duty is different for `/3`

For divide-by-3:

```text
Tout = 3 * Tin
```

Exact 50% duty would require:

```text
TH = TL = 1.5 * Tin
```

But a plain positive-edge-only synchronous decode can change state only on full-clock boundaries:

```text
0, T, 2T, 3T, ...
```

So it can produce widths like:

- `1T`
- `2T`

but not `1.5T`.

This is exactly the official odd-divider issue described by Intel:
for divide factor `3`, high and low counts `2` and `1` imply a `67%–33%` duty cycle, and 50% duty for odd divide needs special odd-divider handling that effectively creates `1.5` and `1.5` cycle high/low times.

Sources:

- Intel states that for divide factor `3`, high and low counts `2` and `1` imply `67%–33%`, and that 50% duty for odd divide requires the `rselodd` odd-divider mechanism which effectively changes this to `1.5` and `1.5` cycles:
  https://www.intel.com/content/www/us/en/docs/programmable/683047/21-1/post-scale-counters-c0-to-c4.html
- Intel AN 507 gives the general odd-counter rule `high_count = (CounterValue + 1)/2`, `low_count = CounterValue - high_count`, and `Odd/even division bit = 1` for 50% duty on odd division, which specializes to `/3` as `high_count=2`, `low_count=1`:
  https://cdrdv2-public.intel.com/653755/an507.pdf
- Microchip explicitly notes that a common divide-by-3 50% implementation uses two DFFs on the positive edge and one DFF on the negative edge:
  https://developerhelp.microchip.com/xwiki/bin/view/products/mcu-mpu/8-bit-mcu-tips-tricks/configurable-logic-block/divide-by-three/
- onsemi shows the same idea using an extra FF and opposite-edge timing to obtain divide-by-3 with 50% output duty cycle:
  https://www.onsemi.com/download/application-notes/pdf/and8001-d.pdf

## 6) Practical exact-50% method you can remember

Start from the 33.33% pulse:

```text
P = ~Q2 & ~Q1
```

This is high for one full input clock every three cycles.

Now create a half-cycle-shifted version using opposite-edge sampling, or equivalently any safe half-cycle-delay mechanism:

```text
Pd = P delayed by half a clock
```

Then combine them:

```text
Y50 = P | Pd
```

What this does:

- `P` contributes `1T` of high time
- `Pd` extends it by another `0.5T`

So the total high time becomes:

```text
1T + 0.5T = 1.5T
```

and low time is also `1.5T`.

Therefore:

```text
fout = fin / 3
duty = 50%
```

This is the practical principle behind the official odd-divider solutions: use both clock edges, or a half-cycle-shifted path, to make an odd divide symmetric.

## 7) Final formulas to remember

For the synchronous mod-3 counter:

```text
T2 = Q2 + Q1
T1 = ~Q2 + Q1
```

For the three output duty styles:

### 33.33%

```text
Y33 = ~Q2 & ~Q1
```

### 66.67%

```text
Y66 = ~Q2
```

### 50%

Not possible from plain positive-edge-only state decoding alone.
Use a half-cycle-shifted or opposite-edge-assisted method, e.g.:

```text
P   = ~Q2 & ~Q1
Y50 = P | Pd
```

where `Pd` is the half-cycle-shifted version of `P`.

## 8) Bubble notation in `/3` schematics

Reference figure in this folder:
`frequency_division/images/Screenshot 2026-03-28 230945.png`

Normally, for a negative-edge-triggered flip-flop, you expect the bubble to appear on the clock pin of the flip-flop symbol itself.

Standard convention:

- triangle only on clock pin -> positive-edge-triggered
- triangle plus bubble on clock pin -> negative-edge-triggered

That is the usual textbook notation.

However, some divide-by-3 schematics do not draw full textbook FF symbols.
Instead, they draw simplified FF blocks and show the inversion in the clock-distribution path.

So if a figure first creates:

```text
Clk
Clk_bar
```

and then feeds different flip-flops from those two paths, the bubble may appear on the clock-generation path rather than being redrawn on the FF clock symbol.

This does **not** mean the circuit principle is different.
It is still the same idea:

- one storage element uses the normal clock edge
- another storage element uses the inverted / opposite-edge version

So the clean interpretation is:

- **standard FF notation**: bubble on FF clock pin means negative-edge-triggered
- **some divide-by-3 drawings**: bubble is shown on the clock path to indicate inverted clock polarity, while the FF symbol is simplified

The underlying hardware meaning is the same:

- a bubble denotes inversion / active-low polarity
- in odd-divider 50% circuits, that inversion is used to create half-cycle timing information from the opposite clock edge

## One-line memory trick

- 1 valid state high -> 33.33%
- 2 valid states high -> 66.67%
- exact 50% for odd divide -> use both edges or half-cycle extension

## Verified references

- Intel MAX 10 Clocking and PLL User Guide:
  https://www.intel.com/content/www/us/en/docs/programmable/683047/21-1/post-scale-counters-c0-to-c4.html
- Intel AN 507:
  https://cdrdv2-public.intel.com/653755/an507.pdf
- Analog Devices AD9512 data sheet:
  https://www.analog.com/media/en/technical-documentation/data-sheets/AD9512.pdf
- Analog Devices AD9510 FAQ:
  https://www.analog.com/en/resources/faqs/faq_on_the_ad9510_how_make_sure_that_duty_cycle_of.html
- Microchip Divide-by-Three CLB note:
  https://developerhelp.microchip.com/xwiki/bin/view/products/mcu-mpu/8-bit-mcu-tips-tricks/configurable-logic-block/divide-by-three/
- onsemi AND8001/D:
  https://www.onsemi.com/download/application-notes/pdf/and8001-d.pdf
