# PDF Theory Notes (Q25-Q26)

## 25) Clock divide by 2

- Use one flip-flop and toggle it on every positive clock edge.
- Output frequency is half of input (`f_out = f_in / 2`).
- Duty cycle is naturally 50% (ideal flip-flop behavior).

## 26) Clock divide by 3 with 50-50 duty cycle

- For odd dividers, 50% duty cannot be obtained from one edge only.
- Use a mod-3 counter on `posedge` and generate `rise_pulse_reg`.
- Sample that pulse on `negedge` into `neg_pulse_reg`.
- OR the two registered signals:
  `clk_div3 = rise_pulse_reg | neg_pulse_reg`.
- This creates a divide-by-3 output with approximately 50% duty and glitch-free logic.

- Do not use `#` delays in synthesizable RTL.
