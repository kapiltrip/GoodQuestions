# PDF Theory Notes (Q28-Q30)

## 28) Glitch-free clock gating with enable

- A level-sensitive latch samples `enable` only while `clk_in=0`.
- During `clk_in=1`, latch output is held constant, so `enable` transitions cannot create glitches.
- Gated clock equation:
  `gated_clk = clk_in & en_latched`.
- Timing note: enable-to-latch path is effectively a half-cycle path.

## 29) Detect rising edge when clocks are off

- If local clocks are unavailable, the input edge itself can clock a flop.
- A common pattern is:
  `always @(posedge d_async or negedge clr_n)`.
- On a rising edge of `d_async`, set request `q=1`.
- Clear it asynchronously with `clr_n` after clocks resume.
- `q` is asynchronous to local clock domains and must be synchronized before wider use.

## 30) Reset synchronizer (async assert, sync deassert)

- Use two flops with async reset to guarantee immediate assertion.
- On reset release, shift in `1` through two stages:
  first stage may absorb metastability, second stage gives stable release.
- Output remains asserted during reset and deasserts only on clock edges.
