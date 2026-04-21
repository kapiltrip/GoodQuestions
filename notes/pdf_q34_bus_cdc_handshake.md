# PDF Q34) How would you synchronize a data bus instead?

## Direct answer

Do **not** synchronize every bit of a multi-bit bus using separate two-flop synchronizers.

That method is unsafe because each bit is synchronized independently. Some bits may update at the destination synchronizer output on one destination clock edge, while other bits may update on the next destination clock edge. This is often described as some bits taking one destination-cycle path and other bits taking a two destination-cycle path. The destination can then see a mixed value that never existed in the source domain.

## Deep reason behind this statement

A two-flop synchronizer solves a **single-bit metastability problem**. It does not solve a **multi-bit consistency problem**.

For one bit, this circuit is fine:

```text
async_bit -> FF1 -> FF2 -> synced_bit
              both flops use destination clock
```

If `async_bit` changes near a destination clock edge, `FF1` may:

- capture the old value
- capture the new value
- become metastable for a short time and then settle

`FF2` gives `FF1` one more destination clock cycle to settle before the signal is used by normal destination-domain logic.

That is good for one bit because the only question is:

```text
Did this one control signal become 0 or 1 safely?
```

But a bus is different. A bus has many bits, and the destination needs all bits to belong to the **same source value**.

For a bus, the question is:

```text
Did every bit come from the same source clock cycle?
```

A separate two-flop synchronizer on each bit cannot guarantee that.

## Why different bits can arrive in different cycles

Assume the source bus changes here:

```text
old bus value -> new bus value
```

From the source domain point of view, all bits may change together on one source clock edge. But from the destination clock domain point of view, those bit changes are asynchronous.

That means each bit can reach its first destination flip-flop at a slightly different time because of:

- source clock and destination clock phase relationship
- different routing delay for each bit
- different clock-to-Q delay from the source registers
- setup/hold timing around the destination clock edge
- possible metastability in the first synchronizer flop

So even if the source launches all bus bits together, the destination does not see one clean atomic bus update.

Example with two bus bits:

```text
source changes bus from 2'b00 to 2'b11
```

Each bit has its own synchronizer:

```text
bit[0] -> FF1_0 -> FF2_0 -> dst_bit[0]
bit[1] -> FF1_1 -> FF2_1 -> dst_bit[1]
```

Now suppose the source transition happens close to a destination clock edge.

```text
destination edge N:
    bit[0] arrives just before the edge, so FF1_0 captures new value 1
    bit[1] arrives just after the edge, so FF1_1 still captures old value 0

destination edge N+1:
    FF2_0 captures 1 from FF1_0
    FF1_1 captures new value 1
    FF2_1 still captures old value 0

destination output after edge N+1:
    dst_bit[0] = 1
    dst_bit[1] = 0
    dst_bus    = 2'b01
```

But `2'b01` was never sent by the source. The source only had:

```text
old value = 2'b00
new value = 2'b11
```

The destination created a fake intermediate value because the bus bits crossed independently.

At the next destination edge:

```text
destination edge N+2:
    FF2_1 finally captures 1

destination output:
    dst_bus = 2'b11
```

So `bit[0]` reached the destination output one destination cycle earlier than `bit[1]`.

This is what the sentence means:

```text
some bits update at the destination output on edge N+1
some bits update at the destination output on edge N+2
```

The two-flop synchronizer reduced metastability risk for each bit, but it did not keep the bus bits together as one word.

## Important distinction

For a single-bit control signal, late arrival by one cycle is usually acceptable.

Example:

```text
enable becomes visible this destination cycle or next destination cycle
```

That only delays the event.

For a multi-bit bus, one bit arriving late changes the meaning of the entire value.

Example:

```text
source intended address = 8'b1111_0000
destination briefly sees = 8'b1011_0100
```

That is not just a delay. That is a wrong data value.

The better method is:

```text
source domain holds the bus stable
        -> source sends a 1-bit request/ready control signal
        -> destination synchronizes only that control signal
        -> destination captures the whole bus
        -> destination sends an acknowledge back
        -> source releases or updates the bus only after acknowledge returns
```

So the key rule is:

```text
Synchronize the control signal, not every data bit.
```

## Why bit-by-bit synchronization is wrong

Suppose the source bus changes from:

```text
old value = 8'b0000_1111
new value = 8'b1111_0000
```

If every bit has its own two-flop synchronizer, the destination may see:

```text
8'b0000_0000
8'b1111_1111
8'b1010_0101
```

or some other mixed value for one cycle.

That happens because the bus bits are not guaranteed to resolve through the synchronizers in the same destination-clock cycle. A two-flop synchronizer is good for a **single-bit control level**, not for preserving the relationship between multiple changing bits.

## Correct circuit idea

Use a handshake.

```text
source clock domain                         destination clock domain

src_data ----> [ source hold register ] ------------------> [ destination data register ]
                         |                                           ^
                         |                                           |
                         v                                           |
                    req / ready ----> [ 2-FF sync ] ----> capture enable
                         ^                                           |
                         |                                           v
                    [ 2-FF sync ] <------------------------------ ack
```

The source-side data register holds the bus constant while the request is crossing the clock-domain boundary. The destination side does not use the bus immediately. It waits until the synchronized request says the bus is valid and stable.

## Step-by-step operation

Assume the source wants to send one bus value to the destination.

### 1. Source captures and holds the bus

The source domain copies `src_data` into a holding register:

```text
src_hold <= src_data
```

After this, `src_hold` must not change until the destination acknowledges the transfer.

### 2. Source toggles or asserts request

The source changes a 1-bit request signal:

```text
req_src changes
```

Only this 1-bit request goes through a normal two-flop synchronizer into the destination clock domain.

### 3. Destination sees synchronized request

After two destination-clock edges, the destination sees that a new transfer is pending.

At this point, the data bus has already been stable for enough time because the source has been holding it since before the request crossed.

### 4. Destination captures the bus

The destination loads the whole bus into a destination register:

```text
dst_data <= src_hold
```

This capture happens once per request.

### 5. Destination sends acknowledge back

The destination changes a 1-bit acknowledge signal.

That acknowledge goes back through a two-flop synchronizer into the source clock domain.

### 6. Source releases the bus

When the source sees the synchronized acknowledge, it knows the destination has captured the data. Now the source may send the next bus value.

## Verilog example

This example uses a toggle handshake. Every new transfer toggles `req_src`. The destination compares the synchronized request against its last acknowledged request. If they differ, a new bus value is available.

```verilog
module bus_cdc_handshake #(
    parameter WIDTH = 8
)(
    input  wire             src_clk,
    input  wire             src_rst_n,
    input  wire             dst_clk,
    input  wire             dst_rst_n,

    input  wire [WIDTH-1:0] src_data,
    input  wire             src_valid,
    output wire             src_ready,

    output reg  [WIDTH-1:0] dst_data,
    output reg              dst_valid
);

    reg [WIDTH-1:0] src_hold;
    reg             req_src;

    reg             req_dst_ff1;
    reg             req_dst_ff2;

    reg             ack_dst;
    reg             ack_src_ff1;
    reg             ack_src_ff2;

    assign src_ready = (req_src == ack_src_ff2);

    always @(posedge src_clk or negedge src_rst_n) begin
        if (!src_rst_n) begin
            src_hold <= {WIDTH{1'b0}};
            req_src  <= 1'b0;
        end else if (src_valid && src_ready) begin
            src_hold <= src_data;
            req_src  <= ~req_src;
        end
    end

    always @(posedge dst_clk or negedge dst_rst_n) begin
        if (!dst_rst_n) begin
            req_dst_ff1 <= 1'b0;
            req_dst_ff2 <= 1'b0;
        end else begin
            req_dst_ff1 <= req_src;
            req_dst_ff2 <= req_dst_ff1;
        end
    end

    always @(posedge dst_clk or negedge dst_rst_n) begin
        if (!dst_rst_n) begin
            dst_data  <= {WIDTH{1'b0}};
            dst_valid <= 1'b0;
            ack_dst   <= 1'b0;
        end else begin
            dst_valid <= 1'b0;

            if (req_dst_ff2 != ack_dst) begin
                dst_data  <= src_hold;
                dst_valid <= 1'b1;
                ack_dst   <= req_dst_ff2;
            end
        end
    end

    always @(posedge src_clk or negedge src_rst_n) begin
        if (!src_rst_n) begin
            ack_src_ff1 <= 1'b0;
            ack_src_ff2 <= 1'b0;
        end else begin
            ack_src_ff1 <= ack_dst;
            ack_src_ff2 <= ack_src_ff1;
        end
    end

endmodule
```

## Why this is safe

The bus itself is not independently synchronized bit by bit. Instead, the source keeps the bus stable while the handshake travels across the clock domains.

The destination captures the bus only after the request has passed through the destination-domain synchronizer. That gives the data bus enough time to become stable before capture.

The acknowledge path prevents the source from changing the bus too early.

## Important timing note

In a real FPGA or ASIC flow, the CDC timing constraints still matter.

The bus path is intentionally crossing between unrelated clocks, so the static timing tool must be told that this is a CDC path. Depending on the flow, this may require false-path or max-delay constraints, and the synchronizer flops may need CDC attributes.

The design idea is still the same:

```text
bus is held stable by protocol
control is synchronized with two flops
destination captures only after synchronized control arrives
```

## When to use an asynchronous FIFO instead

Use this handshake method when the bus is transferred occasionally, one word at a time.

Use an **asynchronous FIFO** when:

- transfers are frequent
- source and destination clocks run independently for long periods
- throughput matters
- back-to-back words must be buffered

An asynchronous FIFO is basically the higher-throughput version of this CDC problem. It uses memory plus synchronized Gray-coded read/write pointers.

## Interview answer

For a multi-bit CDC bus, I would not synchronize each bit separately. That can create an invalid mixed bus value in the destination domain. I would hold the bus stable in the source domain, synchronize a 1-bit request or valid signal into the destination domain, capture the full bus in the destination only after that control signal is synchronized, and send an acknowledge back so the source knows when it can change the bus again. For continuous high-throughput data, I would use an asynchronous FIFO.
