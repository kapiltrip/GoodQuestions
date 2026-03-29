# TODO

This file now holds the actionable items that were previously mixed into `revision.md`.
`revision.md` keeps the explanatory notes; `TODO.md` keeps review and follow-up work.

## Review Items

- Review Verilog port declaration styles:
  - ANSI style: ports declared with direction/type in module header
  - Non-ANSI style: ports listed in header, declared below
- Review clock divider duty-mode outputs once:
  - `clk_out_narrow`: high for 1 count
  - `clk_out_mid`: near 50% using posedge + negedge path
  - `clk_out_wide`: low for 1 count
  - `clk_out_full`: always high
- Review Q30 reset synchronizer assumptions:
  - works for one clock domain (`clk`) only
  - `rst_n` is external async reset and can change at any time
  - reset is active-low (`0` asserted, `1` deasserted)
  - `clk` must be running during reset release for deassertion to propagate
  - two-FF synchronizer depth is assumed sufficient for metastability risk reduction
  - `rst_n` low pulse width must satisfy async reset timing/min pulse constraints
  - each additional clock domain should use its own reset synchronizer
- Review FSM output coding:
  - why `reg` in plain Verilog does not automatically mean flip-flop/register hardware
  - why combinational `always @*` usually uses blocking `=`
- Make more self-checking testbenches:
  - expected-value checking instead of only waveform/manual inspection
  - fail fast with `$display` and `$stop`
  - keep simple reusable TB structure with clock/reset/stimulus/check
- Learn more about tasks and functions:
  - when to use `task`
  - when to use `function`
  - input/output/inout arguments
  - synthesizable vs testbench-style usage
- Review shift-register history conventions:
  - left-shift-style and right-shift-style history storage are both valid
  - newest bit at LSB vs newest bit at MSB
  - compare pattern must match the chosen storage order
- Review Q15 start/chip-select waveform derivation:
  - 3-phase sequence is `start -> chip-select -> idle`
  - selector rotates `cs1 -> cs2 -> cs3 -> cs1`
  - update selector after the chip-select pulse, not during start generation
- Review debounce vs synchronization:
  - synchronization reduces metastability propagation risk; it does not automatically remove real glitches
  - debounce means accept an input change only after it remains stable for a required time/window
  - glitch filtering is the practical effect of debounce: short pulses/bounce are rejected as invalid
  - in Q16, `q1/q2` synchronize the async input, while `q2/d1/d2` qualify it and create a one-cycle pulse
- Review async FIFO pointer roles:
  - use binary pointers for pointer incrementing and RAM indexing
  - use Gray pointers only for clock-domain crossing and full/empty comparison
  - Gray code is not a natural linear RAM address order; its sequence jumps like `0,1,3,2,...`
  - Gray code is chosen for CDC because only one bit changes between consecutive pointer values
  - `*_next` pointers represent the post-operation pointer value, not the current one
  - `empty` is often checked with `rdptrgray_next` so the read domain can tell whether the FIFO becomes empty after the current allowed read
  - `full` is often checked with `wrptrgray_next` so the write domain can tell whether the FIFO becomes full after the current allowed write
  - if only current Gray pointers are compared, `full`/`empty` can lag by one cycle

## Pending

- Q27: divide-by-N circuit, programmable `divider_value = N-1`, odd/even duty behavior, and when decode-style outputs are not ideal as real clock nets
- Q21: max and second max with least comparators
- Q24: 5-tap FIR filter, coefficients, signed arithmetic, and output width sizing
