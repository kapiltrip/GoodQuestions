# PDF Theory Notes (Q22-Q23)

## 22) Generate second, minute, hour ticks from 1 ms pulse

- The question is not asking for a full clock/time display.
  It is asking for three rollover tick pulses:
  `second`, `minute`, and `hour`.
- The input `one_ms_pulse` is already synchronous and occurs once every 1 ms.
  So this pulse is the time base for the whole design.

### What the question is asking

Starting from a 1 ms tick:

- generate a `second` pulse once every 1000 ms
- generate a `minute` pulse once every 60 seconds
- generate an `hour` pulse once every 60 minutes

Each output is meant to be a 1-clock pulse, not a level that stays high.

### Why cascaded counters solve it

You can break the problem into three smaller counters:

1. `ms_counter` counts 1 ms pulses from `0` to `999`
2. `sec_counter` counts second ticks from `0` to `59`
3. `min_counter` counts minute ticks from `0` to `59`

This is a classic divide-and-rollover structure.

### How the pulses are generated

In the repo code:

```verilog
assign second = one_ms_pulse && (ms_counter == 10'd999);
assign minute = second && (sec_counter == 6'd59);
assign hour   = minute && (min_counter == 6'd59);
```

This means:

- `second` pulses when the millisecond counter reaches its terminal count
- `minute` pulses only when a second pulse happens and the seconds counter is at 59
- `hour` pulses only when a minute pulse happens and the minutes counter is at 59

So each larger time unit is generated from the rollover of the smaller one.

### Why the counters reset at those values

- `1000 ms = 1 second`, so `ms_counter` must count `0..999`
- `60 seconds = 1 minute`, so `sec_counter` must count `0..59`
- `60 minutes = 1 hour`, so `min_counter` must count `0..59`

That is why the widths and terminal counts are:

- 10-bit millisecond counter for `0..999`
- 6-bit second counter for `0..59`
- 6-bit minute counter for `0..59`

### Important implementation idea

The outputs are combinationally decoded from the current counter values, while the counters themselves are updated in clocked `always` blocks.

That gives 1-cycle pulses exactly at rollover.

Example:

- if `ms_counter == 999` and `one_ms_pulse == 1`, then `second = 1`
- on that same clock edge, `ms_counter` resets to 0
- so on the next cycle, `second` goes back to 0

That is why `second`, `minute`, and `hour` behave like tick pulses.

### Final takeaway

- Use the 1 ms pulse as the base timing event.
- Count 1000 of them to make a second tick.
- Count 60 second ticks to make a minute tick.
- Count 60 minute ticks to make an hour tick.
- Generate each output as a 1-cycle rollover pulse, not as a stored level.

- Do not use `#` delays in synthesizable RTL.

## 23) Build B from clock and A waveform

- Desired behavior:
  B rises immediately with A, and falls one clock after A falls.
- Implement one-cycle delayed version of A (`A_delay`) in a flip-flop.
- Output equation:
  `B = A | A_delay`.
