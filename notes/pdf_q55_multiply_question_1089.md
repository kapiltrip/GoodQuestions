# PDF Q55) Multiply Question

## Question

Find digits `A`, `B`, `C`, and `D` such that:

```text
  ABCD
x    9
------
  DCBA
```

Each variable is a different decimal digit from `0` to `9`.

## Direct Answer

```text
A = 1
B = 0
C = 8
D = 9
```

So:

```text
ABCD = 1089
DCBA = 9801
```

Check:

```text
1089 * 9 = 9801
```

## Column-by-Column Setup

Let the carries be:

```text
k1, k2, k3
```

Multiply from right to left:

```text
          A B C D
        x       9
        ---------
          D C B A
```

Column equations:

```text
9D        = A + 10k1
9C + k1   = B + 10k2
9B + k2   = C + 10k3
9A + k3   = D
```

There is no final carry beyond `D`, because the result is still a 4-digit number.

## Finding A and D

Since `ABCD` is a 4-digit number:

```text
A != 0
```

Also:

```text
9 * ABCD = DCBA
```

The result is also 4 digits, so:

```text
ABCD < 10000 / 9
ABCD < 1111.11...
```

Therefore:

```text
A = 1
```

Now use the last column equation:

```text
9A + k3 = D
```

Since `A = 1`:

```text
9 + k3 = D
```

`D` is a decimal digit, so `D <= 9`.

That forces:

```text
k3 = 0
D = 9
```

Now use the first column:

```text
9D = A + 10k1
```

Substitute:

```text
9 * 9 = 1 + 10k1
81 = 1 + 10k1
k1 = 8
```

So far:

```text
A = 1
D = 9
k1 = 8
k3 = 0
```

## Finding B and C

Use the middle equations:

```text
9C + k1 = B + 10k2
9B + k2 = C + 10k3
```

Substitute known values:

```text
9C + 8 = B + 10k2
9B + k2 = C
```

because:

```text
k3 = 0
```

The second equation says:

```text
C = 9B + k2
```

Since `C` is a digit, `B` cannot be large.

If `B >= 2`:

```text
9B >= 18
```

which is too large for digit `C`.

So:

```text
B = 0 or B = 1
```

But `A = 1`, and all digits are different, so:

```text
B != 1
```

Therefore:

```text
B = 0
```

Then:

```text
C = 9B + k2 = k2
```

Now use:

```text
9C + 8 = B + 10k2
```

Substitute `B=0` and `C=k2`:

```text
9k2 + 8 = 10k2
k2 = 8
```

So:

```text
C = 8
```

Final digits:

```text
A = 1
B = 0
C = 8
D = 9
```

## Verification

```text
  1089
x    9
------
  9801
```

Column check:

```text
9*9 = 81 -> write 1, carry 8
9*8 + 8 = 80 -> write 0, carry 8
9*0 + 8 = 8  -> write 8, carry 0
9*1 + 0 = 9  -> write 9
```

Result:

```text
9801
```

## Interview Answer

The answer is `1089 * 9 = 9801`, so `A=1`, `B=0`, `C=8`, and `D=9`. The reason starts with the size of the number: since `9 * ABCD` is still four digits, `ABCD` must be less than 1112, so `A=1`. The most significant result digit then comes from `9A + carry`, forcing `D=9` and that carry to be zero. The least significant multiplication `9D` gives `9*9=81`, so the first output digit is `1` and the carry is `8`. Solving the middle columns gives `B=0` and `C=8`.
