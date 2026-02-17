# PDF Theory Notes (Q27)

## 27) Clock divide by N

- In this implementation, `divider_value` programs `N-1`.
  So actual divide value is:
  `N = divider_value + 1`.
- A counter runs from `0` to `divider_value`, then wraps.
- Output frequency is:
  `f_out = f_in / N`.

- For even `N`, posedge logic alone gives 50% duty.
- For odd `N`, the design uses dual-edge logic:
  generate `rise_pulse_reg` on posedge and copy it to `neg_pulse_reg` on negedge,
  then OR them:
  `clk_out = rise_pulse_reg | neg_pulse_reg`.
- This extends high time by half-cycle and gives near-50% duty for odd dividers.

- Safety behavior in code:
  if `divider_value=0`, it is clamped to `1` (minimum divide-by-2).
