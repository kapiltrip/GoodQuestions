# PDF Theory Answers (Q8-Q11)

## 8) What circuit would synthesis create for previous mux coding styles?

- Style 1 (`?:`) and Style 2 (`if/else if`) generally synthesize to equivalent priority-style selection logic.
- Style 3 (`case` with full coverage) typically synthesizes as a parallel mux network.
- If all select values are fully covered, all three styles are functionally equivalent for a 4:1 mux.

## 9) Asynchronous vs synchronous reset flip-flops (pros/cons)

Asynchronous reset:
- Reset takes effect immediately (clock not required).
- Useful for power-on reset behavior.
- Needs careful reset deassertion handling to avoid timing/metastability issues across domains.

Synchronous reset:
- Reset only applied on active clock edge.
- Easier timing closure in many synchronous flows.
- Requires clock to be running for reset to take effect.

## 10) Latch vs flip-flop output behavior

- Latch (level-sensitive): output follows input while `clk=1`; holds value while `clk=0`.
- Flip-flop (edge-triggered): output updates only on the active clock edge (here, rising edge).

## 11) Edge detection timing explanation (including remaining part)

Using:
- delayed sample register `q_prev`
- `rising = d & ~q_prev`
- `falling = ~d & q_prev`
- `toggle = d ^ q_prev`

Waveform behavior:
- When `d` transitions `0 -> 1`, `rising` pulses high for one clock interval.
- When `d` transitions `1 -> 0`, `falling` pulses high for one clock interval.
- `toggle` pulses on both transitions, so it is high whenever either `rising` or `falling` is high.
- In the shown continuation timing diagram, you get one `rising` pulse near the first upward transition and one `falling` pulse near the later downward transition; `toggle` pulses at both events.
