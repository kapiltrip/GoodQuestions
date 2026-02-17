# PDF Theory Notes (Q19-Q20)

## 19) Divisible-by-3 detector from serial input bitstream

- Track remainder states only: `mod0`, `mod1`, `mod2`.
- On each new bit, update using:
  `new_rem = (2 * old_rem + bit) mod 3`.
- Output high when state is `mod0`.

## 20) Fibonacci generator with enable

- Keep two registers for consecutive terms (start `0` and `1`).
- When `enable=1`, update:
  `cur <= next`, `next <= cur + next`.
- When `enable=0`, hold both values.
