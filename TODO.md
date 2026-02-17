# TODO

- Review Verilog port declaration styles:
  - ANSI style (ports declared with direction/type in module header)
  - Non-ANSI style (ports listed in header, declared below)
- Review clock divider duty-mode outputs once:
  - `clk_out_narrow` (high for 1 count)
  - `clk_out_mid` (near 50% using posedge + negedge path)
  - `clk_out_wide` (low for 1 count)
  - `clk_out_full` (always high)
- Review Q30 reset synchronizer assumptions:
  - Works for one clock domain (`clk`) only.
  - `rst_n` is external async reset and can change at any time.
  - Reset is active-low (`0` asserted, `1` deasserted).
  - `clk` must be running during reset release for deassertion to propagate.
  - Two-FF synchronizer depth is assumed sufficient for metastability risk reduction.
  - `rst_n` low pulse width must satisfy async reset timing/min pulse constraints.
  - Each additional clock domain should use its own reset synchronizer.
