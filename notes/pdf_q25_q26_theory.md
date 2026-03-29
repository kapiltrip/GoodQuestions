# PDF Theory Notes (Q25-Q26)

## 25) Clock divide by 2

- The simplest divide-by-2 circuit is a single flip-flop with feedback.
- On every positive edge of `clk`, invert the previous output:
  `q <= ~q;`
- After reset, suppose `q = 0`.
  Then the sequence at each rising edge is:
  `0 -> 1 -> 0 -> 1 -> 0 ...`
- Notice that `q` needs **two** input clock edges to complete one full output period:
  `0 -> 1` is half-cycle, and `1 -> 0` completes the cycle.
- Therefore:
  `f_out = f_in / 2`
- If the input clock has a 50% duty cycle and the flip-flop is ideal, the divided clock also has about 50% duty cycle.

### Intuition

- Input clock changes every cycle.
- Output `q` changes only once per clock edge and must toggle twice to return to its starting value.
- So output is slower by a factor of 2.

### Why reset is used

- Reset gives a known starting value to the divider.
- Here, when `rst_n = 0`, output is forced to `0`.
- After reset is released, toggling starts from a known state.

### Verification idea

- Keep applying input clock pulses.
- Check that `q` changes state on every rising edge after reset.
- If `q` toggles on every clock edge, its frequency is automatically half of the input.

## 26) Clock divide by 3 with 50-50 duty cycle

- For odd dividers, 50% duty cannot be obtained from one edge only.
- Use a mod-3 counter on `posedge` and generate `rise_pulse_reg`.
- Sample that pulse on `negedge` into `neg_pulse_reg`.
- OR the two registered signals:
  `clk_div3 = rise_pulse_reg | neg_pulse_reg`.
- This creates a divide-by-3 output with approximately 50% duty and glitch-free logic.

- Do not use `#` delays in synthesizable RTL.
