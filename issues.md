# Issues: Current Async FIFO

This page tracks the current async FIFO implementation in `qa/pdf_q31/q31_async_fifo_grayptr.v`.

## Scope

Current snapshot areas:

- output declarations: lines 12-14
- next-pointer logic: lines 46-64
- write/read clocked blocks: lines 66-90
- synchronizers: lines 93-113
- flag assignments: lines 115-120

## Main issue

Right now the main architectural problem is:

- `empty` is used to decide `rdptrbin_next`
- but `empty` is also computed from `rdptrgray_next`

So the read-side path feeds back into itself.

The same thing happens on the write side:

- `full` is used to decide `wrptrbin_next`
- but `full` is also computed from `wrptrgray_next`

That creates a combinational loop:

```text
empty -> rdptrbin_next -> rdptrgray_next -> empty
full  -> wrptrbin_next -> wrptrgray_next -> full
```

## Core fix

The clean mitigation is:

- make `empty` a read-domain registered flag
- make `full` a write-domain registered flag
- compute `empty_val` combinationally
- compute `full_val` combinationally
- register `empty` on `rdclk`
- register `full` on `wrclk`

That turns the loop into normal next-state logic.

## Exact corrections

### 1) Change output declarations

Current:

```verilog
output wire           empty,
output wire           full
```

Replace with:

```verilog
output reg            empty,
output reg            full
```

Reason:

- these flags belong to their own clock domains
- they should be stored state, not pure combinational outputs

### 2) Add internal next-flag wires

Add:

```verilog
wire empty_val;
wire full_val;
```

Reason:

- these hold the combinational next values of the flags
- `empty` and `full` themselves become the registered flags

### 3) Keep the next-pointer blocks

These blocks are fine once `empty` and `full` are registered:

```verilog
always @(*) begin
    rdptrbin_next = rdptrbin;
    if (rden && !empty)
        rdptrbin_next = rdptrbin + 1'b1;
end

always @(*) begin
    wrptrbin_next = wrptrbin;
    if (wren && !full)
        wrptrbin_next = wrptrbin + 1'b1;
end

always @(*) begin
    rdptrgray_next = binary2gray(rdptrbin_next);
    wrptrgray_next = binary2gray(wrptrbin_next);
end
```

Reason:

- now `empty` and `full` are no longer pure combinational feedback from the same next-state path
- the blocks become a normal "current state -> next state" structure

### 4) Replace direct flag assignments

Current:

```verilog
assign full = (wrptrgray_next == {~rdptrgray2[aw:aw-1], rdptrgray2[aw-2:0]});
assign empty = (rdptrgray_next == wrptrgray2);
```

Replace with:

```verilog
assign full_val  = (wrptrgray_next == {~rdptrgray2[aw:aw-1], rdptrgray2[aw-2:0]});
assign empty_val = (rdptrgray_next == wrptrgray2);
```

Reason:

- these expressions should compute the next value of the flags
- they should not directly drive the outputs

### 5) Register `full` in the write-domain block

Current write block:

```verilog
always @(posedge wrclk or posedge wrrst) begin
    if (wrrst) begin
        wrptrbin  <= {(aw+1){1'b0}};
        wrptrgray <= {(aw+1){1'b0}};
    end else begin
        wrptrbin  <= wrptrbin_next;
        wrptrgray <= wrptrgray_next;
        if (wren && !full)
            mem[wrptrbin[aw-1:0]] <= din;
    end
end
```

Replace with:

```verilog
always @(posedge wrclk or posedge wrrst) begin
    if (wrrst) begin
        wrptrbin  <= {(aw+1){1'b0}};
        wrptrgray <= {(aw+1){1'b0}};
        full      <= 1'b0;
    end else begin
        wrptrbin  <= wrptrbin_next;
        wrptrgray <= wrptrgray_next;
        full      <= full_val;
        if (wren && !full)
            mem[wrptrbin[aw-1:0]] <= din;
    end
end
```

Reason:

- `full` belongs to the write domain
- it should be updated on `wrclk`

### 6) Register `empty` in the read-domain block

Current read block:

```verilog
always @(posedge rdclk or posedge rdrst) begin
    if (rdrst) begin
        rdptrbin  <= {(aw+1){1'b0}};
        rdptrgray <= {(aw+1){1'b0}};
        dout      <= {dw{1'b0}};
    end else begin
        rdptrbin  <= rdptrbin_next;
        rdptrgray <= rdptrgray_next;
        if (rden && !empty)
            dout <= mem[rdptrbin[aw-1:0]];
    end
end
```

Replace with:

```verilog
always @(posedge rdclk or posedge rdrst) begin
    if (rdrst) begin
        rdptrbin  <= {(aw+1){1'b0}};
        rdptrgray <= {(aw+1){1'b0}};
        dout      <= {dw{1'b0}};
        empty     <= 1'b1;
    end else begin
        rdptrbin  <= rdptrbin_next;
        rdptrgray <= rdptrgray_next;
        empty     <= empty_val;
        if (rden && !empty)
            dout <= mem[rdptrbin[aw-1:0]];
    end
end
```

Reason:

- `empty` belongs to the read domain
- it should be updated on `rdclk`
- after reset the FIFO should start empty

## Minimal patch summary

Conceptually, the changes are:

Change:

```verilog
output wire empty, full;
```

to:

```verilog
output reg empty, full;
wire empty_val, full_val;
```

Change:

```verilog
assign full = ...
assign empty = ...
```

to:

```verilog
assign full_val  = ...
assign empty_val = ...
```

Add in write reset/clock block:

```verilog
full <= 1'b0;
full <= full_val;
```

Add in read reset/clock block:

```verilog
empty <= 1'b1;
empty <= empty_val;
```

## Why this fixes the issue

Before:

```text
full -> wrptrbin_next -> wrptrgray_next -> full
empty -> rdptrbin_next -> rdptrgray_next -> empty
```

After:

```text
full(reg) -> wrptrbin_next -> wrptrgray_next -> full_val -> full(reg next cycle)
empty(reg) -> rdptrbin_next -> rdptrgray_next -> empty_val -> empty(reg next cycle)
```

That is no longer a combinational loop. It is a normal next-state and registered-state structure.

## Recommendations

- Add `(* ASYNC_REG = "TRUE" *)` to the synchronizer flops if your synthesis flow supports it.
- Keep crossing the current registered Gray pointers between domains, not `*_next`.
- Keep `rdptrgray_next` and `wrptrgray_next` as unconditional Gray conversions of the chosen binary next pointers.
- If you later revise the FIFO, add a small self-checking testbench for:
  - reset state
  - one write then one read
  - empty transition after the last read
  - full transition at depth
  - simultaneous read/write when neither side is blocked
- If you want the file to read more clearly, rename the section comments from "next-state logic" and "present state logic" to:
  - `read-domain next-pointer logic`
  - `write-domain next-pointer logic`
  - `read-domain registers`
  - `write-domain registers`
  - `CDC synchronizers`
  - `flag generation`

## Best one-line summary

The clean fix for the current async FIFO is to register `empty` and `full` in their own clock domains and compute `empty_val` / `full_val` combinationally, instead of driving `empty` and `full` directly from `*_gray_next`.
