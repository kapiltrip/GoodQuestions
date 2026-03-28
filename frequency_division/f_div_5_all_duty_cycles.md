# Divide-by-5 Duty Cycles

This note covers synchronous divide-by-5 generation for the common duty-cycle cases:

- 20%
- 40%
- exact 50%
- 60%
- 80%

It also answers the design-choice question directly:

- for `/5`, `MSB` or `LSB` outputs from a mod-5 counter can realize some non-50% duty cycles
- but **exact 50% must not be justified by “LSB is close”**
- exact 50% for `/5` needs opposite-edge or half-cycle-assisted timing

## What Is Verified vs Derived

- **Verified from sources**
  - odd dividers need special odd-divider handling for exact 50% duty
  - divide-by-5 has natural single-edge duty-cycle options such as `40%`, `60%`, `20%`, and `80%`
  - exact 50% for divide factor `5` is implemented in vendor clocking hardware with odd-divider support
- **Derived in this note**
  - the specific mod-5 state sequence
  - the sample state-decode examples below
  - the interpretation of which counter bits happen to produce `20%` or `40%` in the chosen sequence

Verified references used in this note:

- Intel MAX 10 Clocking and PLL User Guide:
  https://www.intel.com/content/www/us/en/docs/programmable/683047/21-1/post-scale-counters-c0-to-c4.html
- Intel AN 507:
  https://cdrdv2-public.intel.com/653755/an507.pdf
- Analog Devices AD9512 data sheet, divider duty-cycle table:
  https://www.analog.com/media/en/technical-documentation/data-sheets/AD9512.pdf
- Analog Devices AD9510 FAQ:
  https://www.analog.com/en/resources/faqs/faq_on_the_ad9510_how_make_sure_that_duty_cycle_of.html
- Microchip PolarFire FPGA / SoC FPGA Clocking Resources User Guide:
  https://ww1.microchip.com/downloads/aemDocuments/documents/FPGA/ProductDocuments/UserGuides/Microchip_PolarFire_FPGA_and_PolarFire_SoC_FPGA_Clocking_Resources_User_Guide_VA.pdf

## 1) Start with a synchronous mod-5 counter

Use a fixed 5-state sequence. One clear choice is:

```text
Q2Q1Q0: 000 -> 001 -> 010 -> 011 -> 100 -> 000 -> ...
```

This is a mod-5 sequence because only 5 valid states are used before repeating.

The key divide-by-5 fact comes from the repeat length:

```text
Tout = 5 * Tin
fout = fin / 5
```

Once the sequence is fixed, output duty cycle is decided by **which states you decode as high**.

## 2) Single-edge decode duty cycles for `/5`

With plain positive-edge-only state decoding, output changes can only happen on integer multiples of `Tin`.

Because the total period is `5T`, the possible simple state-count duty cycles are:

- 1 state high out of 5 -> `20%`
- 2 states high out of 5 -> `40%`
- 3 states high out of 5 -> `60%`
- 4 states high out of 5 -> `80%`

This matches the general divider behavior documented by Analog Devices for divide ratio `5`, where the available duty-cycle settings include `60`, `40`, `80`, and `20` percent.

Source:

- AD9512 Table 12 lists divide ratio `5` duty-cycle options of `60%`, `40%`, `80%`, and `20%`:
  https://www.analog.com/media/en/technical-documentation/data-sheets/AD9512.pdf
- AD9510 FAQ states directly that divide-by-5 produces exactly `40%-60%`:
  https://www.analog.com/en/resources/faqs/faq_on_the_ad9510_how_make_sure_that_duty_cycle_of.html

## 3) Practical decode examples

Using the chosen state sequence:

```text
000, 001, 010, 011, 100
```

### 20%

Choose one valid state high.

Example:

```text
Y20 = Q2
```

Why this works in the chosen sequence:

- `Q2 = 1` only in state `100`
- so the output pattern is high in 1 state out of 5

Therefore:

```text
duty = 1/5 = 20%
```

### 40%

Choose two valid states high.

Example using a raw counter bit:

```text
Y40 = Q0
```

Check the chosen states:

- `000` -> `Q0=0`
- `001` -> `Q0=1`
- `010` -> `Q0=0`
- `011` -> `Q0=1`
- `100` -> `Q0=0`

So `Q0` is high in 2 valid states out of 5.

Therefore:

```text
duty = 2/5 = 40%
```

Another equally valid 40% example in this sequence is:

```text
Y40_alt = Q1
```

because `Q1` is also high in exactly 2 valid states: `010` and `011`.

### 60%

Choose three valid states high.

A simple way is to invert a 40% waveform:

```text
Y60 = ~Q0
```

Since `Q0` is high in 2 of 5 states, `~Q0` is high in the remaining 3 of 5 states:

```text
duty = 3/5 = 60%
```

### 80%

Choose four valid states high.

A simple way is to invert the 20% waveform:

```text
Y80 = ~Q2
```

Since `Q2` is high in only 1 valid state, `~Q2` is high in 4 valid states:

```text
duty = 4/5 = 80%
```

## 4) Why “MSB vs LSB” is not the right rule

This is the important design-answer point.

For a pure binary divide-by-2 stage:

- the LSB naturally toggles every clock
- so it is naturally 50%

But a mod-5 counter is **not** a free-running full binary count.
It is a truncated sequence with only 5 valid states.

So bit waveforms must be checked from the actual valid-state sequence, not guessed from binary-counter intuition.

For the chosen mod-5 sequence:

- `Q0` happens to give `40%`
- `Q1` also happens to give `40%`
- `Q2` happens to give `20%`

You can see immediately why the LSB is not a “natural 50%” output here by writing its pattern over the valid-state sequence:

```text
states: 000 001 010 011 100
Q0:      0   1   0   1   0
```

So `Q0` is high for only 2 valid states out of 5:

```text
duty(Q0) = 2/5 = 40%
```

That is the exact reason the usual binary-counter shortcut fails. In a truncated mod-5 machine, the LSB no longer sees all 8 states of a full 3-bit binary counter, so its waveform must be checked from the actual 5-state sequence.

Their inversions give:

- `~Q0` -> `60%`
- `~Q1` -> `60%`
- `~Q2` -> `80%`

So:

- choosing `MSB` or `LSB` is only a **decode convenience**
- it is **not** a general rule for “closest to 50%”
- if the question asks for exact 50%, do not answer by saying “LSB is close”

The safe interview/exam rule is:

> for odd dividers, use single-edge state decoding for non-50% duty cycles; use both edges or half-cycle extension for exact 50%

## 5) Why exact 50% is different for `/5`

For divide-by-5:

```text
Tout = 5 * Tin
```

Exact 50% duty requires:

```text
TH = TL = 2.5 * Tin
```

But a plain positive-edge-only synchronous decode can only change output on:

```text
0, T, 2T, 3T, 4T, 5T, ...
```

So it can make high widths such as:

- `1T`
- `2T`
- `3T`
- `4T`

but not `2.5T`.

That is why exact `50%` cannot come from plain single-edge state decoding for `/5`.

Intel documents this as a general odd-divider issue:

- odd divide factors require special odd-divider handling for exact 50%
- with odd-divider handling enabled, the effective high and low times are shifted by half cycles

Sources:

- Intel MAX 10 guide explains that odd divide factors need the `rselodd` mechanism to achieve exact 50% duty by using a falling-edge transition:
  https://www.intel.com/content/www/us/en/docs/programmable/683047/21-1/post-scale-counters-c0-to-c4.html
- Intel AN 507 gives the specific divide-by-5 case:
  for `C counter value = 5`, use `high_count = 3`, `low_count = 2`, and `Odd/even division bit = 1`
  to generate 50% duty:
  https://cdrdv2-public.intel.com/653755/an507.pdf
- Microchip also states that its divide-by-5 mode does not generate a 50% duty-cycle output, which reinforces the general odd-divider limitation for plain single-edge divide-by-5 generation:
  https://ww1.microchip.com/downloads/aemDocuments/documents/FPGA/ProductDocuments/UserGuides/Microchip_PolarFire_FPGA_and_PolarFire_SoC_FPGA_Clocking_Resources_User_Guide_VA.pdf

## 6) Practical exact-50% method you can remember

There are two equally valid mental models.

### Model A: start from a 40% high window and extend it

Use a contiguous 2-state-high decode in the positive-edge domain.

That gives:

```text
TH = 2T
```

Then create a half-cycle-shifted companion using opposite-edge sampling and combine it so the total high time becomes:

```text
2T + 0.5T = 2.5T
```

### Model B: start from a 60% high window and trim by symmetry

Use a contiguous 3-state-high decode:

```text
TH = 3T
```

Then use an opposite-edge-assisted scheme so the effective split becomes:

```text
2.5T / 2.5T
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

If asked for `/5` duty cycles:

- `20%`, `40%`, `60%`, and `80%` can be obtained by decoding 1, 2, 3, or 4 valid states of a mod-5 counter
- direct `MSB`/`LSB` outputs may give some of those percentages, depending on the chosen valid-state sequence
- but **exact 50% is not a matter of choosing the “right bit”**
- exact `50%` for `/5` needs both edges or an equivalent half-cycle-assisted method

This is the point that matters most in practice.

## 8) Final summary formulas

For a 5-state divider:

```text
1 state high  -> 20%
2 states high -> 40%
3 states high -> 60%
4 states high -> 80%
```

For exact 50%:

```text
Not possible from plain posedge-only state decode
Need half-cycle / opposite-edge assistance
```

## One-line memory trick

- odd-divider state decode gives discrete fractions of `1/N`
- for `/5`: `20, 40, 60, 80`
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
