# PDF Theory Notes (Q14-Q18)

## 14) Detect `10110` in the last 5 inputs

- This is a sliding-window detector, not necessarily an FSM.
- Use a 5-bit shift register and compare against `5'b10110`.
- Output is high whenever the current 5-sample window matches.

## 17) Two common ways to generate Gray code

- Table/`case` decode from binary count to Gray code (good for fixed small width).
- Generic XOR method: `gray = bin ^ (bin >> 1)` (scales to any width).

## 18) FIFO full/empty logic (single-clock case)

- Keep write pointer, read pointer, and a count register.
- `fifo_empty` when count is zero.
- `fifo_full` when count reaches depth (256 here).
- For asynchronous write/read clocks, pointers should be synchronized across domains,
  often using Gray-code pointers.
