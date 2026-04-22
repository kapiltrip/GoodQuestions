# PDF Q51) Convert Decimal 13 to Binary, Hex, and Octal

## Index

1. [51) Convert decimal value 13 to binary, hex, and octal](#51-convert-decimal-value-13-to-binary-hex-and-octal)
2. [Direct answer](#direct-answer)
3. [Decimal to binary](#decimal-to-binary)
4. [Decimal to hexadecimal](#decimal-to-hexadecimal)
5. [Decimal to octal](#decimal-to-octal)
6. [Binary grouping shortcut](#binary-grouping-shortcut)
7. [Place-value check](#place-value-check)
8. [Verilog literal notation](#verilog-literal-notation)
9. [Width and leading-zero notes](#width-and-leading-zero-notes)
10. [Common mistakes](#common-mistakes)
11. [51) Interview answer](#51-interview-answer)

## 51) Convert decimal value 13 to binary, hex, and octal

The question asks for conversion of:

```text
13 decimal
```

into:

- binary
- hexadecimal
- octal

## Direct answer

```text
Decimal:      13
Binary:       1101
Hexadecimal:  D
Octal:        15
```

With base prefixes:

```text
13 decimal = 0b1101 = 0xD = 0o15
```

In Verilog literal style:

```verilog
4'd13 == 4'b1101 == 4'hD == 4'o15
```

## Decimal to binary

### Method 1: powers of 2

Find powers of two that add to 13:

```text
8 + 4 + 1 = 13
```

Powers:

```text
2^3 = 8
2^2 = 4
2^1 = 2
2^0 = 1
```

Now mark which powers are used:

```text
8 4 2 1
1 1 0 1
```

So:

```text
13 decimal = 1101 binary
```

### Method 2: repeated division by 2

Divide by 2 and keep remainders:

```text
13 / 2 = 6 remainder 1
 6 / 2 = 3 remainder 0
 3 / 2 = 1 remainder 1
 1 / 2 = 0 remainder 1
```

Read remainders from bottom to top:

```text
1101
```

So:

```text
13 decimal = 1101 binary
```

## Decimal to hexadecimal

Hexadecimal is base 16.

Hex digits:

```text
0 1 2 3 4 5 6 7 8 9 A B C D E F
```

Meaning:

```text
A = 10
B = 11
C = 12
D = 13
E = 14
F = 15
```

Since decimal 13 is less than 16, it is one hex digit:

```text
13 decimal = D hex
```

Repeated division by 16:

```text
13 / 16 = 0 remainder 13
```

Remainder 13 is hex digit:

```text
D
```

So:

```text
13 decimal = 0xD
```

## Decimal to octal

Octal is base 8.

Digits:

```text
0 1 2 3 4 5 6 7
```

Repeated division by 8:

```text
13 / 8 = 1 remainder 5
 1 / 8 = 0 remainder 1
```

Read remainders from bottom to top:

```text
15
```

So:

```text
13 decimal = 15 octal
```

Check:

```text
15 octal = 1*8 + 5
         = 13 decimal
```

## Binary grouping shortcut

Once you know:

```text
13 decimal = 1101 binary
```

you can convert binary to hex and octal by grouping bits.

### Binary to hex

Hex groups bits in groups of 4:

```text
1101
```

`1101` binary is:

```text
8 + 4 + 0 + 1 = 13
```

Hex digit 13 is:

```text
D
```

So:

```text
1101b = Dh
```

### Binary to octal

Octal groups bits in groups of 3 from the right.

Start with:

```text
1101
```

Group from right:

```text
1 101
```

Pad the left group with zeros:

```text
001 101
```

Convert each 3-bit group:

```text
001 = 1
101 = 5
```

So:

```text
1101b = 15o
```

## Place-value check

### Binary check

```text
1101b = 1*2^3 + 1*2^2 + 0*2^1 + 1*2^0
      = 1*8   + 1*4   + 0*2   + 1*1
      = 8 + 4 + 0 + 1
      = 13
```

### Hex check

```text
Dh = 13 decimal
```

For multi-digit hex, each digit is a power of 16. Here there is only one digit.

### Octal check

```text
15o = 1*8^1 + 5*8^0
    = 8 + 5
    = 13
```

## Verilog literal notation

Verilog number format:

```text
<width>'<base><value>
```

Base letters:

```text
b = binary
o = octal
d = decimal
h = hexadecimal
```

Examples for decimal 13:

```verilog
4'b1101
4'o15
4'd13
4'hD
```

All represent the same 4-bit pattern:

```text
1101
```

The following are equal as unsigned values:

```verilog
4'b1101 == 4'd13
4'hD    == 4'd13
4'o15   == 4'd13
```

### Unsized constants

You may see:

```verilog
'hD
13
```

Be careful with unsized constants. In Verilog, unsized decimal constants are at least 32 bits and signed by default in many contexts. For clean RTL, specify width when the width matters.

Good style:

```verilog
localparam [3:0] VALUE = 4'd13;
```

## Width and leading-zero notes

Decimal 13 needs 4 bits unsigned:

```text
13 = 1101
```

Range check:

```text
3 bits unsigned range: 0 to 7
4 bits unsigned range: 0 to 15
```

So:

```text
13 does not fit in 3 unsigned bits
13 fits in 4 unsigned bits
```

Leading zeros do not change the value:

```text
1101      = 13
0000_1101 = 13
```

But leading zeros do change the width:

```verilog
4'b1101      // 4 bits
8'b0000_1101 // 8 bits
```

### Signed interpretation warning

The 4-bit pattern:

```text
1101
```

as unsigned is:

```text
13
```

as signed two's complement is:

```text
-3
```

So be clear about signedness. For this question, the value is positive decimal 13, so treat it as unsigned unless the interviewer says signed.

## Common mistakes

### Mistake 1: writing binary as 1011

`1011` binary is:

```text
8 + 0 + 2 + 1 = 11
```

Decimal 13 is:

```text
1101
```

### Mistake 2: confusing hex D and decimal D

`D` is a hex digit.

```text
D hex = 13 decimal
```

There is no decimal digit `D`.

### Mistake 3: converting octal using groups of 4

Groups:

```text
hex   -> groups of 4 bits
octal -> groups of 3 bits
```

For octal:

```text
1101 -> 001 101 -> 15 octal
```

### Mistake 4: forgetting Verilog width

This is clean:

```verilog
4'hD
```

This may be context-dependent:

```verilog
'hD
```

Use explicit widths when teaching or writing synthesizable RTL.

### Mistake 5: interpreting `4'b1101` as signed by accident

The bits are the same, but signed interpretation changes the value.

```text
unsigned 1101 = 13
signed   1101 = -3
```

## 51) Interview answer

Decimal 13 is `1101` in binary because `13 = 8 + 4 + 1`, so the bits for `8, 4, 2, 1` are `1, 1, 0, 1`. In hexadecimal, `1101` is one 4-bit group, equal to decimal 13, which is digit `D`, so the hex value is `0xD`. In octal, group the binary bits in threes from the right: `001 101`, which gives octal digits `1` and `5`, so the octal value is `015` or simply `15`. In Verilog, this can be written as `4'd13`, `4'b1101`, `4'hD`, or `4'o15`.
