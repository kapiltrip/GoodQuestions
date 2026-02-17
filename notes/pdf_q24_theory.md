# PDF Theory Notes (Q24)

## 24) 5-tap FIR filter

- FIR has no feedback. Output is a weighted sum of present and delayed samples.
- For 5 taps:
  `y[n] = C1*x[n] + C2*x[n-1] + C3*x[n-2] + C4*x[n-3] + C5*x[n-4]`.
- Hardware blocks:
  delay line (flip-flops), 5 multipliers, and an adder tree/MAC sum.

## Example application

- Audio or sensor smoothing (low-pass filtering) to reduce high-frequency noise.
- A symmetric coefficient set (example `1,2,3,2,1`) gives a simple smoothing response.
- Scale/normalize coefficients as needed for your fixed-point format.
