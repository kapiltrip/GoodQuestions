# PDF Q34) How would you synchronize a data bus instead?

## Direct answer

Do **not** synchronize every bit of a multi-bit bus using separate two-flop synchronizers.

That method is unsafe because each bit is synchronized independently. Some bits may update at the destination synchronizer output on one destination clock edge, while other bits may update on the next destination clock edge. This is often described as some bits taking one destination-cycle path and other bits taking a two destination-cycle path. The destination can then see a mixed value that never existed in the source domain.

## Short discussion takeaway

In this bus CDC method, we are **not** synchronizing the bus bits one by one.

What actually happens is:

```text
1. source captures the bus into src_hold
2. source keeps src_hold stable
3. source sends a 1-bit req control signal
4. destination synchronizes req
5. destination uses synchronized req as permission to capture src_hold
6. destination sends ack back
7. source synchronizes ack and then may update src_hold again
```

So the accurate wording is:

```text
The handshake bits are synchronized.
The bus register is held stable and sampled.
```

The bus does not become safe because each data bit was synchronized. The bus becomes safe because the source promises:

```text
I already captured a clean word in src_hold.
I will not change src_hold until the destination acknowledges it.
```

The request bit does not inspect the bus. It does not prove that every bus bit is stable. It only tells the destination that, according to the protocol, the source has finished preparing the word and is holding it.

So if `src_hold` captured a wrong word, the handshake will still transfer that wrong word safely. Capturing the correct word into `src_hold` is the sender/source-side responsibility.

The clean separation is:

```text
src_data -> src_hold
    sender/source-side timing or earlier CDC problem

src_hold -> dst_data
    bus CDC handshake problem
```

If the individual bits inside `src_data` are changing too fast before `src_hold` captures them, ask where those bits come from:

```text
same src_clk domain:
    normal setup/hold timing problem into src_hold

another unrelated clock domain:
    another CDC problem before this bus handshake
```

In both cases, this bus CDC method starts only after `src_hold` contains a clean word.

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

The assumption in this example is important:

```text
bit[1] was not permanently wrong.
It was delayed by one destination clock cycle.
```

At edge `N`, `FF1_1` captured the old value because `bit[1]` reached it too late, or because the first flop became metastable and did not settle to the new value in time. If the source bus is still holding the new value, then on the next destination clock edge `FF1_1` can capture the correct new value. One more destination edge later, `FF2_1` outputs that correct value.

So the delayed bit can catch up, assuming:

- the source bus remains stable long enough
- the first synchronizer flop resolves from metastability before the next stage samples an unsafe value
- the destination does not use the temporary mixed bus value

But the third assumption is exactly the problem. Normal destination logic usually cannot know that the bus is temporarily mixed. That is why using independent synchronizers on every bus bit is unsafe.

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

## How can one control signal tell that the bus is stable?

The control signal does **not** inspect the bus.

It does not check every bit. It does not measure whether the bus is electrically stable. It only has meaning because the source and destination follow a protocol.

The protocol promise is:

```text
source is allowed to toggle req only after src_hold has captured a valid word
source is not allowed to change src_hold until ack comes back
```

So when the destination sees the synchronized request, it trusts this promise:

```text
if req arrived, then src_hold has already been loaded and is being held stable
```

That is why the request bit can act like a label for the bus word.

Think of it like this:

```text
src_hold = the package
req      = the "package is ready" flag
ack      = the "package received" flag
```

The `req` bit does not make the package correct. It only tells the receiver that the sender has finished preparing the package and will not change it until the receiver acknowledges it.

In hardware terms:

```text
1. source loads src_hold with a clean word
2. source toggles req
3. destination synchronizes req
4. destination captures src_hold
5. destination toggles/sends ack
6. source sees ack and may change src_hold for the next word
```

If the source violates the rule and changes `src_hold` before `ack`, then the control signal is lying. The CDC design is no longer correct.

So the accurate statement is:

```text
The synchronized control signal does not prove the bus is stable.
The protocol makes the bus stable, and the control signal tells the destination when to capture it.
```

## What if the original bus is changing fast?

Then the raw changing bus must **not** be treated as the CDC bus.

The correct CDC path is not:

```text
fast-changing src_data directly crosses into destination domain
```

The correct CDC path is:

```text
fast-changing src_data
        -> source-domain holding register
        -> held bus crosses to destination capture register
```

The source-domain holding register is the important part. It takes one snapshot of the bus when a transfer is accepted.

```verilog
if (src_valid && src_ready) begin
    src_hold <= src_data;
    req_src  <= ~req_src;
end
```

After that, `src_hold` must remain unchanged until the acknowledge returns. The original `src_data` may continue changing internally, but those later changes are **not** part of the current CDC transfer.

So when we say:

```text
keep the bus stable
```

we mean:

```text
keep the source holding register stable
```

not necessarily:

```text
force every internal source-domain signal to stop changing
```

## What if individual bits inside `src_data` change too fast?

Then the problem happens **before** the CDC transfer.

The holding register only guarantees this:

```text
after src_hold captures a word, src_hold stays stable
```

It does **not** guarantee this:

```text
src_hold always captures the word you intended
```

For `src_hold` to capture the intended word, all bits of `src_data` must already be valid around the `src_clk` edge that loads `src_hold`.

```text
src_data bits stable before src_clk edge -> src_hold captures correct word
src_data bits change near src_clk edge   -> src_hold may capture mixed word
```

Example:

```text
intended old value = 4'b0000
intended new value = 4'b1111
```

If the individual bits of `src_data` do not arrive at `src_hold` at the same time, the source holding register itself might capture:

```text
src_hold = 4'b0101
```

That value is already wrong in the source domain. The CDC handshake will then safely transfer `4'b0101`, but it cannot know that `4'b0101` was not the intended value.

So the handshake solves this problem:

```text
do not let the destination see a changing bus
```

It does not solve this earlier problem:

```text
make a fast-changing or asynchronous source bus become a correct word
```

The source side must provide a clean word first.

Correct source-side assumptions:

- `src_data` is generated by logic synchronous to `src_clk`
- all `src_data` bits meet setup and hold timing to the `src_hold` register
- `src_valid` is asserted only when the whole bus word is valid
- `src_hold` loads only when `src_valid && src_ready`

If the individual bits are not synchronous to `src_clk`, first fix that at the source side. Depending on the design, that may mean:

- register the bits in the source clock domain before using them as a bus
- use a valid signal that says when the whole bus is stable
- use a request/acknowledge handshake from the producer into the source domain
- use an asynchronous FIFO if full-rate multi-word transfer is needed
- use Gray code only for special cases like pointers or counters where one-bit-at-a-time change is part of the design

Important sentence:

```text
The CDC handshake preserves the word captured in src_hold.
It does not repair a word that src_hold captured incorrectly.
```

## Is that still a CDC problem?

It depends where those changing bits come from.

### Case 1: bits are generated inside the same `src_clk` domain

If `src_data` is produced by logic already synchronous to `src_clk`, then individual bits changing too close to the `src_hold` capture edge is mainly a **normal source-domain timing problem**, not the bus CDC problem.

In that case, the issue is:

```text
source logic -> src_hold register
```

The source logic must meet normal setup and hold timing to `src_hold`.

```text
same clock domain timing problem:
    src_data bits must be stable before/after the src_clk edge
```

If this timing fails, `src_hold` may capture a wrong or mixed word. The later CDC handshake can transfer that word safely, but it cannot know the word was already wrong.

So for this case:

```text
wrong capture into src_hold = not solved by CDC handshake
```

It must be fixed by normal synchronous design methods:

- register the source data earlier
- reduce combinational delay
- fix setup/hold timing
- assert `src_valid` only when the word is ready

### Case 2: bits come from another asynchronous clock domain

If the individual bits of `src_data` are themselves coming from some other unrelated clock domain, then yes, that is a **CDC problem**.

But it is a different CDC problem that happens **before** this bus handshake.

```text
other clock domain -> src_data/src_hold area -> destination clock domain
```

The bus handshake in this note only handles:

```text
src_hold in source domain -> dst_data in destination domain
```

It assumes `src_hold` already contains a clean source-domain word.

If `src_data` is asynchronous to `src_clk`, you must first make it safe in the source domain. Do not simply sample every bit into `src_hold` and hope the bus becomes correct.

For that earlier CDC, use the correct structure for the data type:

- single-bit control: two-flop synchronizer
- occasional multi-bit word: valid/ready or request/acknowledge handshake
- continuous stream: asynchronous FIFO
- counter/pointer crossing: Gray code plus synchronizers

So the clean answer is:

```text
If src_data is synchronous to src_clk:
    bit timing into src_hold is a normal setup/hold timing problem.

If src_data is asynchronous to src_clk:
    that is another CDC problem before this CDC transfer.

In both cases:
    the src-to-dst bus handshake only works after src_hold has captured a clean word.
```

## What if data arrives faster than the handshake?

Then this simple handshake can accept only the transfers for which:

```text
src_valid && src_ready
```

is true.

If the source changes `src_data` again before `src_ready` returns, there are only three correct choices:

- the source waits and holds that next value until `src_ready` is high
- the source allows that next value to be dropped
- the design uses an asynchronous FIFO to buffer multiple values

If the design needs to transfer **every fast-changing bus value**, a one-word handshake is usually not enough. Use an asynchronous FIFO.

If the source ignores `src_ready` and keeps overwriting the value that is supposed to be transferred, then it is not a correct CDC design. The protocol has been broken.

## What if timing constraints do not match?

The handshake makes the bus logically safe only if the held bus has enough time to settle at the destination before the destination captures it.

In the normal handshake sequence:

```text
source loads src_hold
source toggles req_src
req_src passes through two destination flops
destination captures src_hold
```

Because `req_src` takes at least two destination clock edges to pass through the synchronizer, the held bus usually has multiple destination cycles to become stable before capture.

But this is still an assumption that the implementation must satisfy. The physical data path from `src_hold` to `dst_data` must not be so slow or skewed that some bits are still arriving when the destination capture happens.

So a correct CDC design needs both:

```text
protocol correctness:
    source holds src_hold until acknowledge returns

physical timing correctness:
    src_hold bits arrive at the destination capture flops within the allowed stable window
```

If the physical timing cannot meet that stable window, then the choices are:

- add more wait cycles before destination capture
- constrain the bus path with an appropriate max-delay or bus-skew constraint
- place/register the logic better so the bus delay is smaller
- use an asynchronous FIFO or another CDC structure designed for the required rate

Do not think of the handshake as magic. It is correct only when the source obeys the hold rule and the implementation gives the held data enough time to reach the destination capture register.

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

The code is kept as one complete module. The comments inside the code explain the role of the variables where they are declared and used.

```verilog
module bus_cdc_handshake #(
    parameter WIDTH = 8          // WIDTH is the number of bits in the bus.
)(
    // src_clk and src_rst_n control all source-domain registers.
    input  wire             src_clk,
    input  wire             src_rst_n,

    // dst_clk and dst_rst_n control all destination-domain registers.
    input  wire             dst_clk,
    input  wire             dst_rst_n,

    // src_data is the source word to transfer.
    // src_valid says src_data is a clean source-domain word right now.
    input  wire [WIDTH-1:0] src_data,
    input  wire             src_valid,

    // src_ready tells the source when this CDC block can accept a new word.
    output wire             src_ready,

    // dst_data is the received word in the destination clock domain.
    // dst_valid pulses for one dst_clk cycle when dst_data is newly captured.
    output reg  [WIDTH-1:0] dst_data,
    output reg              dst_valid
);

    // src_hold is the source-domain holding register for the bus.
    // It is loaded once at the start of a transfer and then held stable.
    reg [WIDTH-1:0] src_hold;

    // req_src is the source-domain request toggle.
    // Every change of req_src means src_hold has a new word.
    reg             req_src;

    // req_dst_ff1 and req_dst_ff2 synchronize req_src into dst_clk.
    // req_dst_ff2 is the synchronized request used by destination logic.
    reg             req_dst_ff1;
    reg             req_dst_ff2;

    // ack_dst remembers the latest request already accepted in dst_clk.
    // ack_src_ff1 and ack_src_ff2 synchronize ack_dst back into src_clk.
    // ack_src_ff2 is the acknowledge value used by source logic.
    reg             ack_dst;
    reg             ack_src_ff1;
    reg             ack_src_ff2;

    // Source ready logic:
    // req_src is the current request state.
    // ack_src_ff2 is the last acknowledged request state seen back in src_clk.
    // If they are equal, no transfer is pending and src_hold may be updated.
    assign src_ready = (req_src == ack_src_ff2);

    // Source block:
    // When src_valid and src_ready are both high, src_hold captures src_data.
    // Then req_src toggles to tell the destination that src_hold is ready.
    // While src_ready is low, src_hold is not changed.
    always @(posedge src_clk or negedge src_rst_n) begin
        if (!src_rst_n) begin
            src_hold <= {WIDTH{1'b0}};
            req_src  <= 1'b0;
        end else if (src_valid && src_ready) begin
            src_hold <= src_data;
            req_src  <= ~req_src;
        end
    end

    // Request sync block:
    // req_src is asynchronous to dst_clk, so it first goes to req_dst_ff1.
    // req_dst_ff2 is the safer destination-domain version of req_src.
    // Only the 1-bit request is synchronized this way, not every bus bit.
    always @(posedge dst_clk or negedge dst_rst_n) begin
        if (!dst_rst_n) begin
            req_dst_ff1 <= 1'b0;
            req_dst_ff2 <= 1'b0;
        end else begin
            req_dst_ff1 <= req_src;
            req_dst_ff2 <= req_dst_ff1;
        end
    end

    // Destination capture block:
    // ack_dst stores the last req_dst_ff2 value that was already consumed.
    // If req_dst_ff2 differs from ack_dst, a new held bus word is waiting.
    // dst_data captures the whole src_hold bus once.
    // dst_valid pulses for that capture cycle.
    // ack_dst is updated so the source can later see that this word was taken.
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

    // Acknowledge sync block:
    // ack_dst is asynchronous to src_clk, so it first goes to ack_src_ff1.
    // ack_src_ff2 is the safer source-domain acknowledge value.
    // When ack_src_ff2 catches up to req_src, src_ready becomes high again.
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

## Realization

A single control bit goes from the source domain to the destination domain:

```text
req_src -> req_dst_ff1 -> req_dst_ff2
```

This synchronized request bit tells the destination:

```text
the source has placed a new stable word in src_hold
```

Then the destination checks:

```verilog
if (req_dst_ff2 != ack_dst)
```

That condition means:

```text
this request value is new compared to the last request value already handled
```

For the first transfer, everything starts at `0` after reset:

```text
req_src = 0
ack_dst = 0
```

So there is no new transfer yet. When the source has a word ready, it toggles:

```text
req_src: 0 -> 1
```

After synchronization, the destination sees:

```text
req_dst_ff2 = 1
ack_dst     = 0
```

Now the comparison becomes true:

```text
req_dst_ff2 != ack_dst
```

That tells the destination that new data is available in `src_hold`.

For the next transfer, the toggle goes the other way:

```text
req_src: 1 -> 0
```

Then the destination eventually sees:

```text
req_dst_ff2 = 0
ack_dst     = 1
```

Again, the values are different, so this also means a new transfer.

So the destination is not looking only for `1`. It is looking for a change compared to `ack_dst`:

```text
0 -> 1 means new transfer
1 -> 0 means new transfer
```

So the destination captures the held bus:

```verilog
dst_data <= src_hold;
```

Then the destination updates:

```verilog
ack_dst <= req_dst_ff2;
```

That means:

```text
I have handled this request now
```

After that, `ack_dst` is synchronized back into the source domain:

```text
ack_dst -> ack_src_ff1 -> ack_src_ff2
```

When the source sees:

```verilog
req_src == ack_src_ff2
```

it knows:

```text
the destination has captured the previous word
```

So the source can send the next word.

The important correction is:

```text
req_src is not the data bit.
req_src is the 1-bit request toggle that says a new data word is available in src_hold.
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
