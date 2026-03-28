# PDF Theory Notes (Q14-Q18)

## 14) Detect `10110` in the last 5 inputs

- This is a sliding-window detector, not necessarily an FSM.
- Use a 5-bit shift register and compare against `5'b10110`.
- Output is high whenever the current 5-sample window matches.

## 15) Generate `start` and rotating chip-select pulses from timing

- The waveform repeats every 3 clocks: `start`, then one chip-select pulse, then one idle cycle.
- A 3-phase FSM is a clean fit:
  `phase=0` gives `start`, `phase=1` gives one of `cs1/cs2/cs3`, and `phase=2` is idle.
- A second 2-bit selector rotates the active chip-select in the order
  `cs1 -> cs2 -> cs3 -> cs1`.
- Update the selector only after the chip-select pulse phase completes. That keeps each
  chip-select high for exactly one clock and preserves the required ordering.

## 17) Two common ways to generate Gray code

- The question is asking for a Gray-code counter sequence, where only one output bit
  changes between consecutive counts.
- A practical RTL approach is to keep an internal binary counter and generate Gray code
  from that count.
- Table/`case` decode from binary count to Gray code (good for fixed small width).
- Generic XOR method: `gray = bin ^ (bin >> 1)` (scales to any width).
- Reverse conversion from Gray back to binary is:
  `bin[MSB] = gray[MSB]`, then `bin[i] = bin[i+1] ^ gray[i]`.

## 18) FIFO full/empty logic (single-clock case)

- Keep write pointer, read pointer, and a count register.
- `fifo_empty` when count is zero.
- `fifo_full` when count reaches depth (256 here).
- For asynchronous write/read clocks, pointers should be synchronized across domains,
  often using Gray-code pointers.
