# PDF Theory Notes (Q22-Q23)

## 22) Generate second, minute, hour ticks from 1 ms pulse

- Input `one_ms_pulse` is synchronous and occurs once per millisecond.
- Use cascaded counters:
  `ms: 0..999`, `sec: 0..59`, `min: 0..59`.
- Generate 1-cycle tick pulses on rollover:
  `second`, then `minute`, then `hour`.
- Do not use `#` delays in synthesizable RTL.

## 23) Build B from clock and A waveform

- Desired behavior:
  B rises immediately with A, and falls one clock after A falls.
- Implement one-cycle delayed version of A (`A_delay`) in a flip-flop.
- Output equation:
  `B = A | A_delay`.
