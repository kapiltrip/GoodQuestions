# PDF Theory Notes (Q27)

## 27) Clock Divide By N

- `N` is a parameter, so the divide value is fixed when the module is instantiated.
- The counter runs from `0` to `N-1`, then returns to `0`.
- Output frequency is:
  `f_out = f_in / N`.

The output is high while:

```verilog
count < (N/2)
```

So for even `N`, the duty cycle is 50%.

For odd `N`, this simple version is not exactly 50% duty. Example for `N=5`:

- high for 2 input clock cycles
- low for 3 input clock cycles

This keeps the code simple and still divides the frequency by `N`.
