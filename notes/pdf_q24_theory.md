# PDF Theory Notes (Q24)

## 24) 5-tap FIR filter

- The question is asking for a circuit that processes the current sample together
  with a finite number of past samples.
- In a 5-tap FIR filter, you use:
  the current sample plus the previous 4 samples.
- FIR means **Finite Impulse Response**:
  there is no feedback path from output back into the filter input/state.

### Mathematical form

For 5 taps:

```text
y[n] = C1*x[n] + C2*x[n-1] + C3*x[n-2] + C4*x[n-3] + C5*x[n-4]
```

Meaning:

- `x[n]` = current input sample
- `x[n-1]` = 1-clock old sample
- `x[n-2]` = 2-clocks old sample
- `x[n-3]` = 3-clocks old sample
- `x[n-4]` = 4-clocks old sample

and `C1..C5` are the coefficients (weights).

So the output is not just the current input.
It is a weighted sum of the current input and recent history.

### Why it is called a 5-tap filter

Each weighted sample term is one "tap".

So:

- 1 current sample term
- 4 delayed sample terms

gives a total of 5 taps.

### Hardware view

The FIR can be built from three parts:

1. **Delay line**
   - flip-flops/registers store previous samples
2. **Multipliers**
   - each sample is multiplied by its coefficient
3. **Adder tree / sum**
   - all products are added to generate the output

Block-level idea:

```text
input -> z^-1 -> z^-1 -> z^-1 -> z^-1
   |       |       |       |       |
  *C1     *C2     *C3     *C4     *C5
   \       \       \       \       \
                add them all -> y[n]
```

Here `z^-1` means a 1-clock delay.

### How the repo code maps to this

In the RTL:

- `sample_in` is `x[n]`
- `d1` is `x[n-1]`
- `d2` is `x[n-2]`
- `d3` is `x[n-3]`
- `d4` is `x[n-4]`

The products are:

- `m1 = sample_in * C1`
- `m2 = d1 * C2`
- `m3 = d2 * C3`
- `m4 = d3 * C4`
- `m5 = d4 * C5`

Then:

```text
y_next = m1 + m2 + m3 + m4 + m5
```

On each clock:

- the delayed samples shift down the line
- the new filtered output is registered into `sample_out`

So the delay chain is effectively:

```text
d1 <= sample_in
d2 <= d1
d3 <= d2
d4 <= d3
```

### Why the output depends on old samples

That is the whole purpose of filtering.

If you used only the current sample, there would be no averaging or shaping over time.
By using delayed samples too, the filter can:

- smooth noise
- emphasize or suppress certain frequency components
- behave like a low-pass, high-pass, or other response depending on coefficients

### Why symmetric coefficients are common

An example coefficient set like:

```text
1, 2, 3, 2, 1
```

is symmetric.

That often gives a simple smoothing / low-pass behavior.
The center sample has the highest weight, and nearby samples also contribute.

### Signed arithmetic note

Because samples and coefficients may be signed, the product widths are larger than
the input widths.
Those products must be sign-extended before the final addition so the summed result
is numerically correct.

### Final takeaway

- A 5-tap FIR filter uses the current sample and 4 previous samples.
- Each sample is multiplied by a coefficient.
- All 5 products are added.
- No feedback is used, so it is FIR.
- The delay line gives time history; the coefficients control the filtering behavior.

## Example application

- Audio or sensor smoothing (low-pass filtering) to reduce high-frequency noise.
- A symmetric coefficient set (example `1,2,3,2,1`) gives a simple smoothing response.
- Scale/normalize coefficients as needed for your fixed-point format.
