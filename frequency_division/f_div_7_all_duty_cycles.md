# Divide-by-7 Duty Cycles

This note covers synchronous divide-by-7 generation for the common duty-cycle cases:

- 14.29%
- 28.57%
- 42.86%
- exact 50%
- 57.14%
- 71.43%
- 85.71%

It also answers the design-choice question directly:

- for `/7`, `MSB` or `LSB` outputs from a mod-7 counter can realize some non-50% duty cycles
- but **exact 50% must not be justified by “LSB is close”**
- exact 50% for `/7` needs opposite-edge or half-cycle-assisted timing

## What Is Verified vs Derived

- **Verified from sources**
  - divide-by-7 naturally has non-50% single-edge duty-cycle options around `43%/57%`, `29%/71%`, and `14%/86%`
  - higher odd divide ratios such as `7` stay within the `40%-60%` window only approximately, not exactly at `50%`
  - odd dividers need special odd-divider handling for exact 50% duty
- **Derived in this note**
  - the specific mod-7 state sequence
  - the sample state-decode examples below
  - the interpretation of which counter bits happen to produce `42.86%`
  - the exact fractional values `1/7`, `2/7`, `3/7`, `4/7`, `5/7`, `6/7`

Verified references used in this note:

- Intel MAX 10 Clocking and PLL User Guide:
  https://www.intel.com/content/www/us/en/docs/programmable/683047/21-1/post-scale-counters-c0-to-c4.html
- Intel AN 507:
  https://cdrdv2-public.intel.com/653755/an507.pdf
- Analog Devices AD9512 data sheet:
  https://www.analog.com/media/en/technical-documentation/data-sheets/AD9512.pdf
- Analog Devices AD9510 FAQ:
  https://www.analog.com/en/resources/faqs/faq_on_the_ad9510_how_make_sure_that_duty_cycle_of.html
- Microchip PolarFire FPGA / SoC FPGA Clocking Resources User Guide:
  https://ww1.microchip.com/downloads/aemDocuments/documents/FPGA/ProductDocuments/UserGuides/Microchip_PolarFire_FPGA_and_PolarFire_SoC_FPGA_Clocking_Resources_User_Guide_VA.pdf

## 1) Start with a synchronous mod-7 counter

Use a fixed 7-state sequence. One clear choice is:

```text
Q2Q1Q0: 000 -> 001 -> 010 -> 011 -> 100 -> 101 -> 110 -> 000 -> ...
```

This is a mod-7 sequence because only 7 valid states are used before repeating.

The key divide-by-7 fact comes from the repeat length:

```text
Tout = 7 * Tin
fout = fin / 7
```

Once the sequence is fixed, output duty cycle is decided by **which valid states you decode as high**.

## 2) Single-edge decode duty cycles for `/7`

With plain positive-edge-only state decoding, output changes can only happen on integer multiples of `Tin`.

Because the total period is `7T`, the possible simple state-count duty cycles are:

- 1 state high out of 7 -> `14.29%`
- 2 states high out of 7 -> `28.57%`
- 3 states high out of 7 -> `42.86%`
- 4 states high out of 7 -> `57.14%`
- 5 states high out of 7 -> `71.43%`
- 6 states high out of 7 -> `85.71%`

This matches the general divider behavior documented by Analog Devices for divide ratio `7`, where the available duty-cycle settings are listed as `57%`, `43%`, `71%`, `29%`, `86%`, and `14%`. Those are rounded versions of the exact fractions above.

Sources:

- AD9512 Table 12 lists divide ratio `7` duty cycles as `57%`, `43%`, `71%`, `29%`, `86%`, and `14%`:
  https://www.analog.com/media/en/technical-documentation/data-sheets/AD9512.pdf
- AD9510 FAQ says higher odd divide ratios such as `7`, `9`, and `11` stay within the `40%-60%` window:
  https://www.analog.com/en/resources/faqs/faq_on_the_ad9510_how_make_sure_that_duty_cycle_of.html

## 3) Practical decode examples

Using the chosen state sequence:

```text
000, 001, 010, 011, 100, 101, 110
```

### 14.29%

Choose one valid state high.

Example:

```text
Y14 = Q2 & ~Q1 & ~Q0
```

Why this works:

- it is high only in state `100`
- so the output is high in 1 state out of 7

Therefore:

```text
duty = 1/7 = 14.29%
```

### 28.57%

Choose two valid states high.

Example:

```text
Y29 = Q2 & ~Q0
```

Check the chosen states:

- `100` -> high
- `110` -> high
- all others -> low

So the output is high in 2 states out of 7.

Therefore:

```text
duty = 2/7 = 28.57%
```

### 42.86%

Choose three valid states high.

Example using a raw counter bit:

```text
Y43 = Q0
```

Check the chosen states:

- `000` -> `Q0=0`
- `001` -> `Q0=1`
- `010` -> `Q0=0`
- `011` -> `Q0=1`
- `100` -> `Q0=0`
- `101` -> `Q0=1`
- `110` -> `Q0=0`

So `Q0` is high in 3 valid states out of 7.

Therefore:

```text
duty = 3/7 = 42.86%
```

In this chosen sequence, `Q1` and `Q2` also happen to be high in exactly 3 of the 7 valid states, so they are also valid `42.86%` examples.

### 57.14%

Choose four valid states high.

A simple way is to invert a `42.86%` waveform:

```text
Y57 = ~Q0
```

Since `Q0` is high in 3 of 7 states, `~Q0` is high in the remaining 4 of 7 states:

```text
duty = 4/7 = 57.14%
```

### 71.43%

Choose five valid states high.

A simple way is to invert the 2-state decode:

```text
Y71 = ~(Q2 & ~Q0)
```

Since `Q2 & ~Q0` is high in 2 states out of 7, its inversion is high in the other 5 states:

```text
duty = 5/7 = 71.43%
```

### 85.71%

Choose six valid states high.

A simple way is to invert the 1-state decode:

```text
Y86 = ~(Q2 & ~Q1 & ~Q0)
```

Since the 1-state decode is high in 1 state out of 7, its inversion is high in 6 states out of 7:

```text
duty = 6/7 = 85.71%
```

## 4) Why “MSB vs LSB” is not the right rule

This is the important design-answer point.

For a pure binary divide-by-2 stage:

- the LSB naturally toggles every clock
- so it is naturally 50%

But a mod-7 counter is **not** a free-running full binary count.
It is a truncated sequence with only 7 valid states.

So bit waveforms must be checked from the actual valid-state sequence, not guessed from binary-counter intuition.

For the chosen mod-7 sequence:

```text
states: 000 001 010 011 100 101 110
Q0:      0   1   0   1   0   1   0
Q1:      0   0   1   1   0   0   1
Q2:      0   0   0   0   1   1   1
```

Each raw bit is high in exactly 3 valid states out of 7:

```text
duty(Q0) = duty(Q1) = duty(Q2) = 3/7 = 42.86%
```

and each inverted bit is high in exactly 4 valid states out of 7:

```text
duty(~Q0) = duty(~Q1) = duty(~Q2) = 4/7 = 57.14%
```

That is the exact reason the usual “LSB is naturally 50%” shortcut fails. In a truncated mod-7 machine, the LSB no longer sees all 8 states of a full 3-bit binary counter, so its waveform must be checked from the actual 7-state sequence.

So:

- choosing `MSB` or `LSB` is only a **decode convenience**
- it is **not** a general rule for “closest to 50%”
- if the question asks for exact 50%, do not answer by saying “LSB is close”

The safe interview/exam rule is:

> for odd dividers, use single-edge state decoding for non-50% duty cycles; use both edges or half-cycle extension for exact 50%

## 5) Why exact 50% is different for `/7`

For divide-by-7:

```text
Tout = 7 * Tin
```

Exact 50% duty requires:

```text
TH = TL = 3.5 * Tin
```

But a plain positive-edge-only synchronous decode can only change output on:

```text
0, T, 2T, 3T, 4T, 5T, 6T, 7T, ...
```

So it can make high widths such as:

- `1T`
- `2T`
- `3T`
- `4T`
- `5T`
- `6T`

but not `3.5T`.

That is why exact `50%` cannot come from plain single-edge state decoding for `/7`.

Intel documents this as a general odd-divider issue:

- odd divide factors require special odd-divider handling for exact 50%
- with odd-divider handling enabled, the effective high and low times are shifted by half cycles

Sources:

- Intel MAX 10 guide explains that odd divide factors need the `rselodd` mechanism to achieve exact 50% duty by using a falling-edge transition:
  https://www.intel.com/content/www/us/en/docs/programmable/683047/21-1/post-scale-counters-c0-to-c4.html
- Intel AN 507 gives the general odd-counter rule:
  `high_count = (CounterValue + 1) / 2`, `low_count = CounterValue - high_count`, `Odd/even division bit = 1`
  for 50% duty on odd division. Substituting `CounterValue = 7` gives the divide-by-7 case `high_count = 4`, `low_count = 3`, which is the half-cycle-assisted `50%` solution:
  https://cdrdv2-public.intel.com/653755/an507.pdf
- Microchip states directly that plain divide-by-5 mode does not generate 50% duty cycle. That is not a divide-by-7 statement, but it is another vendor confirmation that odd single-edge divider modes naturally produce non-50% outputs unless special handling is added:
  https://ww1.microchip.com/downloads/aemDocuments/documents/FPGA/ProductDocuments/UserGuides/Microchip_PolarFire_FPGA_and_PolarFire_SoC_FPGA_Clocking_Resources_User_Guide_VA.pdf

## 6) Practical exact-50% method you can remember

There are two equally valid mental models.

### Model A: start from a 3-state-high window and extend it

Use a contiguous 3-state-high decode in the positive-edge domain.

That gives:

```text
TH = 3T
```

Then create a half-cycle-shifted companion using opposite-edge sampling and combine it so the total high time becomes:

```text
3T + 0.5T = 3.5T
```

### Model B: start from a 4-state-high window and trim by symmetry

Use a contiguous 4-state-high decode:

```text
TH = 4T
```

Then use an opposite-edge-assisted scheme so the effective split becomes:

```text
3.5T / 3.5T
```

The exact gate-level topology can vary between implementations.
The universal principle is:

- plain single-edge decode gives only integer-`T` high/low widths
- exact 50% for odd divide needs half-cycle timing information

That is why vendor solutions rely on the equivalent of:

- opposite-edge-triggered storage
- falling-edge transition support
- or half-cycle-shifted logic

## 7) What to say in an interview or exam

If asked for `/7` duty cycles:

- `14.29%`, `28.57%`, `42.86%`, `57.14%`, `71.43%`, and `85.71%` can be obtained by decoding 1, 2, 3, 4, 5, or 6 valid states of a mod-7 counter
- direct `MSB`/`LSB` outputs may give some of those percentages, depending on the chosen valid-state sequence
- but **exact 50% is not a matter of choosing the “right bit”**
- exact `50%` for `/7` needs both edges or an equivalent half-cycle-assisted method

This is the point that matters most in practice.

## 8) Final summary formulas

For a 7-state divider:

```text
1 state high  -> 14.29%
2 states high -> 28.57%
3 states high -> 42.86%
4 states high -> 57.14%
5 states high -> 71.43%
6 states high -> 85.71%
```

For exact 50%:

```text
Not possible from plain posedge-only state decode
Need half-cycle / opposite-edge assistance
```

## One-line memory trick

- odd-divider state decode gives discrete fractions of `1/N`
- for `/7`: `14.29, 28.57, 42.86, 57.14, 71.43, 85.71`
- exact `50%` for odd divide -> use both edges, not “pick LSB”

## Verified references

- Intel MAX 10 Clocking and PLL User Guide:
  https://www.intel.com/content/www/us/en/docs/programmable/683047/21-1/post-scale-counters-c0-to-c4.html
- Intel AN 507:
  https://cdrdv2-public.intel.com/653755/an507.pdf
- Analog Devices AD9512 data sheet:
  https://www.analog.com/media/en/technical-documentation/data-sheets/AD9512.pdf
- Analog Devices AD9510 FAQ:
  https://www.analog.com/en/resources/faqs/faq_on_the_ad9510_how_make_sure_that_duty_cycle_of.html
- Microchip PolarFire FPGA / SoC FPGA Clocking Resources User Guide:
  https://ww1.microchip.com/downloads/aemDocuments/documents/FPGA/ProductDocuments/UserGuides/Microchip_PolarFire_FPGA_and_PolarFire_SoC_FPGA_Clocking_Resources_User_Guide_VA.pdf
