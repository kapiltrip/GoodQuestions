# Discussion: Synchronous or Asynchronous Counters in These Divider Schemes?

This note answers a specific design question for the `/3`, `/5`, and `/7` frequency-division material in this folder:

> Are these divider schemes using synchronous counters or asynchronous (ripple) counters?

## Short answer

For the cited `/3`, `/5`, and `/7` discussion in this folder, the answer is:

- they are fundamentally **synchronous divider/counter schemes**
- for exact `50%` odd division, they often become **dual-edge synchronous** or **half-cycle-assisted synchronous**
- they are **not** ripple/asynchronous counters in the usual sense

That distinction matters.

Using both clock edges does **not** make a design asynchronous.
If all state elements are still controlled by the same master clock family, such as:

- `clk`
- `clk_bar`
- or a documented falling-edge transition of the same source clock

then the design is still synchronous in architecture.

## What “asynchronous counter” would mean here

In the usual digital-design sense, an asynchronous or ripple counter is one where:

- the first flip-flop is clocked by the external clock
- later flip-flops are clocked by earlier flip-flop outputs

So the state change ripples stage by stage instead of all stages updating from the same master clock event.

That is **not** what the cited odd-divider sources are describing.

The cited sources instead use:

- one common input clock
- sometimes its inverted version or falling edge
- explicit divider state or high/low count control

That is a synchronous style.

## Bottom-line conclusion by source

### 1) Microchip divide-by-3 note

Microchip states:

- a common divide-by-3 50% implementation uses **three D-type flip-flops**
- **the first two are clocked using a positive edge clock**
- **the last DFF is clocked with a negative edge clock**
- the goal of that extra negative-edge stage is specifically to obtain the **50% duty-cycle** divide-by-3 output

What the source is giving you directly:

- a concrete divide-by-3 circuit structure
- explicit edge choice for each flip-flop
- a timing intent tied to the same base clock, not to ripple propagation

Source:

- https://developerhelp.microchip.com/xwiki/bin/view/products/mcu-mpu/8-bit-mcu-tips-tricks/configurable-logic-block/divide-by-three/

Why this means synchronous, not ripple:

- the description is based on edge choice of the same clock, not on one flop output becoming the next flop clock
- the architecture is “same clock, different edge usage,” which is a synchronous timing method

So the clean conclusion is:

- **Microchip’s divide-by-3 50% method is dual-edge synchronous**
- it is **not** an asynchronous ripple counter
- the negative-edge stage is a timing-extension trick, not a ripple-clock stage

## 2) onsemi AND8001/D

onsemi says two very important things directly:

- `Synchronous clocking`
- later, the divide-by-3 50% circuit `clocks synchronously with 50% output duty cycle`

It also describes the implementation as:

- creating differential `Clock` and `Clock bar`
- using a flip-flop that triggers on the `Clock Bar` rising edge
- keeping the divider behavior tied to the same original clock family

What the source is giving you directly:

- an explicit statement that the method is synchronous
- a circuit explanation based on `Clock` and `Clock bar`
- an odd-divider 50% approach that uses opposite edges of the same clock rather than stage-to-stage ripple clocking

Source:

- https://www.onsemi.com/download/application-notes/pdf/and8001-d.pdf

Why this means synchronous, not ripple:

- onsemi explicitly labels the design synchronous
- the opposite-edge stage is driven from inverted clock polarity, not from a previous flop output
- that is still a common-clock design with half-cycle alignment

So the clean conclusion is:

- **onsemi’s odd-divider method is synchronous**
- for exact 50% odd division, it is better described as **dual-edge synchronous**
- it is **not** a ripple counter
- the schematic style may look unusual, but the clocking concept is still common-clock synchronous design

## 3) Intel PLL post-scale counters

Intel documents the post-scale divider as a counter with:

- an 8-bit high-time setting
- an 8-bit low-time setting
- an odd-divider control bit `rselodd`
- a duty-cycle mechanism defined in terms of output transitions placed on clock edges
- a specific odd-divider behavior where the falling edge is used for exact 50% duty on odd divide values

What the source is giving you directly:

- the divider is treated as a programmable counter structure, not a ripple chain
- high time and low time are controlled numerically
- exact odd-divider 50% is handled by edge placement inside the divider logic

Intel also says:

- the PLL implements duty cycle by transitioning the output on the **rising edge** of the VCO clock
- for odd divide with exact 50%, it uses a **falling-edge** transition

Source:

- https://www.intel.com/content/www/us/en/docs/programmable/683047/21-1/post-scale-counters-c0-to-c4.html

Why this means synchronous, not ripple:

- Intel is not describing a chain of flops clocked from each other
- it is describing a controlled post-scale counter driven from the VCO clock
- the odd-divider feature changes which edge of that same clock is used for one transition

That is a synchronous divider architecture inside the PLL.

So the clean conclusion is:

- **Intel’s odd-divider mechanism is synchronous**
- exact 50% for odd divide is achieved by **same-clock half-cycle edge placement**
- it is **not** an asynchronous ripple implementation
- this is stronger than a generic inference because the source describes the actual edge-selection behavior of the divider

## 4) Intel AN 507

Intel AN 507 gives the programmable rule for odd divide 50% duty:

- `high_count = (CounterValue + 1) / 2`
- `low_count = CounterValue - high_count`
- `Odd/even division bit = 1`
- example settings such as divide-by-5 and the matching `high_count`/`low_count` split

What the source is giving you directly:

- the divider is configured through count values, not hand-built ripple stages
- odd-divider 50% comes from a count split plus an odd/even control bit
- the model is a controlled synchronous divider with programmable timing

Source:

- https://cdrdv2-public.intel.com/653755/an507.pdf

Why this matters:

- AN 507 treats the divider as a configured counter with high/low count control
- that is a synchronous counter-style model
- there is no ripple-chain description

So again, the conclusion is:

- **configured synchronous counter/divider**
- not asynchronous ripple logic
- the source is especially useful because it shows the divider as a programmable timing machine rather than as a chain of toggling FF outputs

## 5) Analog Devices AD9512

The AD9512 documentation says:

- each output has its own divider
- each divider can be configured for **divide ratio, phase, and duty cycle**
- synchronization can hold dividers in a known state and then start them from a clock edge
- divider duty cycle is selectable from documented tables for specific divide ratios
- synchronized divider start-up is part of the published operating model

What the source is giving you directly:

- per-output divider blocks
- explicit synchronization behavior
- explicit duty-cycle programmability
- phase relationship control across outputs

Source:

- https://www.analog.com/media/en/technical-documentation/data-sheets/AD9512.pdf

Why this points to synchronous architecture:

- the device has programmable divider blocks per output
- those dividers are explicitly synchronized and phase-controlled
- that behavior matches synchronous divider blocks, not a loose ripple-counter interpretation

This is an inference from the divider-control and synchronization behavior in the datasheet.

So the clean conclusion is:

- **ADI’s programmable divider blocks are best understood as synchronous dividers**
- not asynchronous ripple counters

## 6) Analog Devices AD9510 FAQ

The AD9510 FAQ is useful because it explains the duty-cycle behavior of odd divides in plain words.

It states that:

- divide-by-3 produces `33.3%-66.6%`
- divide-by-5 produces `40%-60%`
- higher odd divide ratios such as `7`, `9`, and `11` stay within the `40%-60%` range

Source:

- https://www.analog.com/en/resources/faqs/faq_on_the_ad9510_how_make_sure_that_duty_cycle_of.html

Why this matters for the synchronous-vs-asynchronous question:

- the FAQ is not a clock-architecture tutorial
- but it reinforces that the published behavior is framed in terms of divider ratio and duty-cycle outcome, not ripple propagation
- combined with the AD9512 divider/synchronization documentation, it supports the same synchronous-divider reading

So the clean conclusion is:

- **ADI documents odd-divider behavior as a property of programmable divider blocks**
- not as a ripple-counter artifact

## 7) Why exact 50% odd division often uses both edges

For odd divide factors such as:

- `/3`
- `/5`
- `/7`

the output period is:

```text
Tout = N * Tin
```

Exact 50% duty requires:

```text
TH = TL = (N/2) * Tin
```

When `N` is odd, that means:

- `1.5T` for `/3`
- `2.5T` for `/5`
- `3.5T` for `/7`

Those are half-cycle values.

A plain positive-edge-only decode can only move on:

```text
0, T, 2T, 3T, ...
```

So it cannot create those exact half-cycle widths.

That is why the sources keep introducing one of these ideas:

- falling-edge transition support
- inverted clock
- opposite-edge-triggered flip-flop
- half-cycle-shifted helper stage

This is still synchronous because the extra timing point comes from the **same clock**, just on the opposite edge.

## 8) “Opposite edge” does not mean asynchronous

This is the most important conceptual clarification.

A design can be:

- synchronous on rising edge only
- synchronous on falling edge only
- synchronous using both edges

All three are still synchronous if they are referenced to the same master clock.

The divider becomes asynchronous only if stages are being clocked by previous stage outputs in ripple fashion.

So:

- `clk` plus `clk_bar` -> still synchronous family
- rising-edge FF plus falling-edge FF -> still synchronous family
- FF2 clocked by FF1 output -> ripple/asynchronous style

That is the clean separation.

## 9) Evidence summary by source type

It helps to separate what is directly stated from what is inferred:

- **Microchip**
  - direct evidence: positive-edge and negative-edge DFF usage in one divide-by-3 circuit
  - strong conclusion: dual-edge synchronous
- **onsemi**
  - direct evidence: explicit use of the phrase `Synchronous clocking`
  - strong conclusion: synchronous by the source’s own wording
- **Intel**
  - direct evidence: programmable high/low counts plus odd-divider edge handling
  - strong conclusion: synchronous divider/counter with half-cycle edge control
- **ADI**
  - direct evidence: programmable synchronized divider blocks with phase/duty-cycle control
  - conclusion: best interpreted as synchronous divider architecture

So the strongest “pure citation” support comes from:

- onsemi for the word **synchronous**
- Microchip for the **positive-edge / negative-edge** split
- Intel for the **count-controlled odd-divider** mechanism

ADI adds strong architectural support, even though its wording is more “divider block / synchronization” than “this is a synchronous counter” in textbook language.

## 10) What this means for your `/3`, `/5`, and `/7` notes

For the notes in this folder, the safest engineering phrasing is:

- the basic mod-`N` state-decode solutions are **synchronous counters**
- the exact `50%` odd-divider solutions are **dual-edge synchronous** or **half-cycle-assisted synchronous**
- they should **not** be described as asynchronous counters

If you want one compact sentence for revision:

> Odd-divider 50% circuits usually stay synchronous; they just use both clock edges or equivalent half-cycle timing, rather than becoming ripple counters.

## Best supported conclusion

Across the cited material:

- **Microchip**: clearly synchronous, using positive-edge and negative-edge DFFs
- **onsemi**: explicitly says synchronous
- **Intel**: programmable post-scale counter with rising/falling-edge duty control, which is synchronous
- **ADI**: programmable synchronized divider blocks, best interpreted as synchronous divider architecture

So the top-quality conclusion is:

> The divider schemes discussed in this folder are synchronous divider/counter designs. For exact 50% duty cycle on odd divide ratios, they use dual-edge or half-cycle-assisted synchronous timing, not asynchronous ripple counting.

## Cited references

- Microchip divide-by-3 CLB note:
  https://developerhelp.microchip.com/xwiki/bin/view/products/mcu-mpu/8-bit-mcu-tips-tricks/configurable-logic-block/divide-by-three/
- onsemi AND8001/D:
  https://www.onsemi.com/download/application-notes/pdf/and8001-d.pdf
- Intel MAX 10 Clocking and PLL User Guide:
  https://www.intel.com/content/www/us/en/docs/programmable/683047/21-1/post-scale-counters-c0-to-c4.html
- Intel AN 507:
  https://cdrdv2-public.intel.com/653755/an507.pdf
- Analog Devices AD9512 datasheet:
  https://www.analog.com/media/en/technical-documentation/data-sheets/AD9512.pdf
- Analog Devices AD9510 FAQ:
  https://www.analog.com/en/resources/faqs/faq_on_the_ad9510_how_make_sure_that_duty_cycle_of.html
