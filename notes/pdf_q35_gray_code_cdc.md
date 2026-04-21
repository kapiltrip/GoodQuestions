# PDF Q35) Why are Gray coding techniques used for clock domain crossings?

## Direct answer

Gray code is used in CDC because only **one bit changes between two adjacent values**.

That matters because a normal multi-bit bus cannot safely be synchronized bit by bit. If several bits change at the same time, the destination may capture some old bits and some new bits, creating a wrong mixed value.

With Gray code, for a counter or pointer that moves one step at a time:

```text
only one bit is changing
```

So after bit-by-bit synchronization, the destination can usually see either:

```text
old Gray value
```

or:

```text
new Gray value
```

but not a completely unrelated mixed value caused by many changing bits.

## Why binary is dangerous for CDC pointers

Take a normal binary counter transition:

```text
binary 7  = 4'b0111
binary 8  = 4'b1000
```

All four bits change:

```text
0111 -> 1000
```

If this binary pointer crosses into another clock domain through separate two-flop synchronizers, different bits may update on different destination clock edges.

The destination might briefly see:

```text
0000
1111
0100
1011
```

or another value that is neither `7` nor `8`.

For a FIFO pointer, that is dangerous because the full/empty logic may think the FIFO has a completely different number of entries.

## Why Gray code helps

The same count transition in Gray code changes only one bit.

One common binary-to-Gray conversion is:

```verilog
assign gray = binary ^ (binary >> 1);
```

Example table:

```text
binary    gray
000       000
001       001
010       011
011       010
100       110
101       111
110       101
111       100
```

Notice each Gray value differs from the previous one by only one bit.

Example:

```text
binary 3 -> 4:
    binary: 011 -> 100   three bits change
    gray:   010 -> 110   one bit changes
```

Now if the Gray pointer crosses to another clock domain, only one synchronizer bit is exposed to the current transition. The other bits are unchanged.

If the changing bit is captured late, the destination sees the old Gray pointer for one more cycle. If it is captured early, the destination sees the new Gray pointer. That is usually acceptable for FIFO status logic.

## Important: Gray code does not make any bus safe

Gray coding is useful only when the value is moving through a known sequence where adjacent states differ by one bit.

Good CDC use cases:

- FIFO read pointer
- FIFO write pointer
- counters that increment or decrement by one step
- pointer-like values where only adjacent movement is allowed

Bad use cases:

- arbitrary data bus
- address bus that can jump randomly
- packet data
- control fields where many bits can change independently

For arbitrary multi-bit data, use the bus handshake from Q34 or use an asynchronous FIFO.

## Async FIFO example

In an asynchronous FIFO, the write pointer lives in the write clock domain, and the read pointer lives in the read clock domain.

```text
write clock domain                         read clock domain

write pointer ---------------------------> used for empty/full logic
read pointer  <--------------------------- used for empty/full logic
```

But the raw binary pointers are not synchronized across domains. Instead:

```text
binary pointer -> convert to Gray -> synchronize Gray pointer -> compare
```

Typical structure:

```text
write domain:
    wbin  = binary write pointer used to address FIFO memory
    wgray = Gray-coded write pointer sent to read domain

read domain:
    rbin  = binary read pointer used to address FIFO memory
    rgray = Gray-coded read pointer sent to write domain
```

Then:

```text
wgray crosses into read domain
rgray crosses into write domain
```

Each crossed Gray pointer is passed through a normal two-flop synchronizer per bit.

## Why this is okay for FIFO flags

The synchronized pointer may be delayed by one or more destination clock cycles. That is normal.

For example, the read domain may see an older write pointer for a short time:

```text
actual write pointer     = newer value
synchronized write ptr   = older value
```

This can make the read side think fewer entries are available than actually exist. That is conservative. It may delay a read, but it does not create fake data.

Similarly, the write side may see an older read pointer:

```text
actual read pointer      = newer value
synchronized read ptr    = older value
```

This can make the write side think the FIFO is fuller than it really is. That is also conservative. It may delay a write, but it helps prevent overwrite.

So async FIFO status logic is designed to tolerate synchronized pointers being slightly old.

## Code snippets

Binary to Gray:

```verilog
assign gray = binary ^ (binary >> 1);
```

Gray to binary:

```verilog
integer i;

always @(*) begin
    binary[WIDTH-1] = gray[WIDTH-1];
    for (i = WIDTH-2; i >= 0; i = i - 1)
        binary[i] = binary[i+1] ^ gray[i];
end
```

Synchronizing a Gray pointer into another clock domain:

```verilog
reg [PTR_WIDTH-1:0] gray_sync_1;
reg [PTR_WIDTH-1:0] gray_sync_2;

always @(posedge dst_clk or negedge dst_rst_n) begin
    if (!dst_rst_n) begin
        gray_sync_1 <= {PTR_WIDTH{1'b0}};
        gray_sync_2 <= {PTR_WIDTH{1'b0}};
    end else begin
        gray_sync_1 <= gray_src;
        gray_sync_2 <= gray_sync_1;
    end
end
```

This looks like bit-by-bit bus synchronization, but the reason it is acceptable is the Gray-code rule:

```text
only one pointer bit changes per pointer increment
```

So only one synchronizer bit is uncertain for a given pointer transition.

## Important timing caveat

Gray code reduces the logical CDC problem, but physical timing still matters.

The Gray bus bits should be constrained so that routing skew does not make the destination observe multiple pointer-bit transitions from different source increments at the same time.

In real FPGA or ASIC flows, designers often add a max-delay or bus-skew constraint on the Gray pointer crossing.

So the safe assumption is:

```text
Gray pointer changes one bit per source increment
and implementation constraints keep the Gray bus crossing well controlled
```

Without that timing discipline, even Gray-coded CDC can be implemented poorly.

## Interview answer

Gray coding is used in clock domain crossing because only one bit changes between adjacent values. That makes it suitable for synchronizing counters or FIFO pointers across clock domains with normal two-flop synchronizers. If the changing bit is captured one cycle late, the destination usually sees either the old pointer or the new pointer, not an unrelated mixed value. This is why asynchronous FIFOs use Gray-coded read and write pointers for full and empty detection. Gray code is not for arbitrary data buses; arbitrary multi-bit data should use a handshake or asynchronous FIFO.
