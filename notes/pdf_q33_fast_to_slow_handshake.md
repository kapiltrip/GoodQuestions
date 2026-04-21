# PDF Q33) How would the previous circuit change from fast domain to slow domain?

## Direct answer

When crossing from a **fast clock domain** to a **slow clock domain**, a simple two-flip-flop synchronizer may miss a short fast-domain pulse.

So the circuit must change like this:

```text
fast source event
        -> hold request high in fast domain
        -> synchronize request into slow domain
        -> slow domain captures/detects it
        -> synchronize acknowledge back to fast domain
        -> fast domain clears request only after acknowledge returns
```

This is called a **closed-loop synchronizer**, **feedback synchronizer**, or **request/acknowledge handshake synchronizer**.

VerilogPro explains the core problem: a fast-domain pulse can disappear before a slow clock edge samples it, so if every event must be received, a feedback acknowledge path is needed. ([VerilogPro CDC article](https://www.verilogpro.com/clock-domain-crossing-part-1/))

## Why slow-to-fast was easier

In Q32, the signal moved from:

```text
slow clock domain -> fast clock domain
```

That is easier because the slow signal usually remains stable for many fast clock cycles.

Example:

```text
slow_clk = 25 MHz   -> period = 40 ns
fast_clk = 100 MHz  -> period = 10 ns
```

If the slow-domain signal is high for one slow cycle, the fast domain sees it for about four fast cycles. So a two-flop synchronizer in the fast domain has multiple chances to sample it.

## Why fast-to-slow is harder

In Q33, the direction is reversed:

```text
fast clock domain -> slow clock domain
```

Now a fast-domain pulse may be very narrow compared to the slow clock period.

Example:

```text
fast_clk = 100 MHz  -> period = 10 ns
slow_clk = 25 MHz   -> period = 40 ns
```

If the fast domain creates a one-cycle pulse:

```text
fast pulse width = 10 ns
slow clock period = 40 ns
```

The pulse can start and finish between two slow clock edges.

```text
slow_clk edge        slow_clk edge
     |                    |
     |   fast pulse       |
     |    ___             |
_____|___|   |____________|_____
```

The slow domain never samples `1`, so the event is lost.

EDN states the same issue: when synchronizing from fast clock domain to slow clock domain using only a 2-flop synchronizer, a pulse can be skipped, causing loss of pulse detection. ([EDN CDC synchronizer article](https://www.edn.com/synchronizer-techniques-for-multi-clock-domain-socs-fpgas/))

## Correct idea: hold the request until acknowledged

Instead of sending a short pulse directly, convert the fast event into a **level request**.

The fast domain does this:

```text
event happens -> set request = 1
```

Then it keeps `request = 1` until the slow domain has definitely seen it.

The slow domain does this:

```text
synchronize request through two slow-clock flops
use synchronized request
send acknowledge back
```

The fast domain receives the acknowledge through another two-flop synchronizer:

```text
slow acknowledge -> two fast-clock flops -> ack seen in fast domain
```

Only after that does the fast domain clear the request.

So the full loop is:

```text
fast request -> slow synchronizer -> slow received level
      ^                                  |
      |                                  v
fast ack synchronizer <- slow acknowledge
```

This is why the notebook diagram has synchronizers in **both directions**.

## Block diagram

```text
                  request path
fast domain                          slow domain

fast_event
    |
    v
[ request FF ] ---> [ slow FF1 ] ---> [ slow FF2 ] ---> slow_level
     Q0                Q1               Q2
     ^                                  |
     |                                  |
     |          acknowledge path        v
 [ fast FF2 ] <--- [ fast FF1 ] <--- slow_ack = Q2
     Q4                Q3
     |
     v
 fast_ack
```

Usually one extra delayed copy of `fast_ack` is kept in the fast domain:

```text
Q5 = delayed fast_ack
```

Then the fast control logic can detect:

```text
rising edge of ack  -> slow domain has seen the request
falling edge of ack -> slow domain has seen request return low
```

That is why the image mentions edges between `Q4` and `Q5`.

## Step-by-step operation

Assume everything starts at `0`.

```text
Q0 = 0
Q1 = 0
Q2 = 0
Q3 = 0
Q4 = 0
```

### 1. Fast event happens

The fast control logic sets `Q0 = 1`.

```text
fast_event -> Q0 = 1
```

`Q0` is not a one-cycle pulse anymore. It is a held request.

### 2. Slow domain synchronizes the request

The slow domain samples `Q0` through two flops:

```text
Q0 -> Q1 -> Q2
```

After two slow clock edges, `Q2` becomes `1`.

Now the slow domain knows:

```text
request received
```

If a one-cycle pulse is needed in the slow domain, generate it from `Q2` after synchronization.

### 3. Slow domain sends acknowledge back

The simplest acknowledge is:

```text
slow_ack = Q2
```

That means:

```text
if Q2 = 1, the slow domain has captured the request
```

### 4. Fast domain synchronizes the acknowledge

The fast domain samples `slow_ack` through two fast-clock flops:

```text
slow_ack -> Q3 -> Q4
```

When `Q4` becomes `1`, the fast domain knows the slow domain has seen the request.

### 5. Fast domain clears the request

Now the fast control logic clears `Q0`.

```text
if fast_ack_rise:
    Q0 = 0
```

### 6. Slow domain sees request go low

The slow synchronizer eventually updates:

```text
Q1 -> 0
Q2 -> 0
```

So `slow_ack` becomes `0`.

### 7. Fast domain sees acknowledge go low

The fast synchronizer eventually updates:

```text
Q3 -> 0
Q4 -> 0
```

Now the fast domain knows the handshake returned to idle and it is safe to send the next event.

This is why the control logic should not set `Q0` again immediately after clearing it. It should wait until the returned acknowledge is low again.

## Verilog code

This module safely transfers a one-cycle or short pulse from a fast clock domain into a slow clock domain.

It outputs:

- `slow_level`: synchronized level in the slow domain
- `slow_pulse`: one-cycle pulse in the slow domain
- `fast_busy`: fast domain is waiting for the handshake to complete

```verilog
module fast_to_slow_handshake_sync (
    input  wire fast_clk,
    input  wire fast_rst,
    input  wire fast_event,

    input  wire slow_clk,
    input  wire slow_rst,
    output wire slow_level,
    output wire slow_pulse,

    output wire fast_busy
);

    reg req_fast;

    reg req_slow_1;
    reg req_slow_2;
    reg req_slow_2_d;

    reg ack_fast_1;
    reg ack_fast_2;
    reg ack_fast_2_d;

    wire ack_fast_rise;

    assign ack_fast_rise =  ack_fast_2 & ~ack_fast_2_d;

    assign fast_busy  = req_fast | ack_fast_2;
    assign slow_level = req_slow_2;
    assign slow_pulse = req_slow_2 & ~req_slow_2_d;

    always @(posedge fast_clk or posedge fast_rst) begin
        if (fast_rst) begin
            req_fast     <= 1'b0;
            ack_fast_1   <= 1'b0;
            ack_fast_2   <= 1'b0;
            ack_fast_2_d <= 1'b0;
        end else begin
            ack_fast_1   <= req_slow_2;
            ack_fast_2   <= ack_fast_1;
            ack_fast_2_d <= ack_fast_2;

            if (fast_event && !fast_busy)
                req_fast <= 1'b1;
            else if (ack_fast_rise)
                req_fast <= 1'b0;
        end
    end

    always @(posedge slow_clk or posedge slow_rst) begin
        if (slow_rst) begin
            req_slow_1   <= 1'b0;
            req_slow_2   <= 1'b0;
            req_slow_2_d <= 1'b0;
        end else begin
            req_slow_1   <= req_fast;
            req_slow_2   <= req_slow_1;
            req_slow_2_d <= req_slow_2;
        end
    end

endmodule
```

Important: `fast_event` is accepted only when `fast_busy = 0`. If another event comes while `fast_busy = 1`, this simple circuit drops it. If events must never be dropped, the fast source must hold `fast_event` until `fast_busy` is low, or use a small FIFO/event counter.

## How this code matches the diagram

The notebook diagram uses names like `Q0`, `Q1`, `Q2`, `Q3`, `Q4`, and `Q5`.

Mapping:

```text
Q0 -> req_fast
Q1 -> req_slow_1
Q2 -> req_slow_2
Q3 -> ack_fast_1
Q4 -> ack_fast_2
Q5 -> ack_fast_2_d
```

So:

```text
Q0 is set by fast control logic.
Q1/Q2 synchronize Q0 into the slow domain.
Q2 returns as acknowledge.
Q3/Q4 synchronize acknowledge back into the fast domain.
Q5 is a delayed copy used for edge detection.
```

The control logic uses:

```text
Q4 rising edge  -> slow side captured the request
Q4 falling edge -> slow side has returned to idle
```

## Why the fast domain must wait for falling acknowledge

Suppose the fast domain sends an event and then clears `Q0` after seeing `ack = 1`.

At that moment, the slow domain still has:

```text
Q2 = 1
```

If the fast domain immediately sends a new event before `Q2` returns to `0`, the slow domain may not see a new rising edge. It may just see:

```text
Q2 stayed high
```

So a new event can be lost.

That is why the fast control logic should wait for:

```text
ack high  -> clear request
ack low   -> handshake finished
```

Only after the acknowledge returns low is the circuit ready for the next event.

## Open-loop alternative

There is a simpler alternative: stretch the fast pulse so it remains high long enough for the slow domain to sample it.

Rule of thumb:

```text
fast signal width >= 1.5x destination slow clock period
```

This is called an **open-loop synchronizer**, because there is no acknowledge back to the source domain.

But it depends on assumptions about clock frequencies and pulse width. If clock ratios can change, or if every event must be guaranteed, use the closed-loop handshake.

## When to use which method

Use simple 2-flop synchronization if:

- the signal is a single-bit level
- the level is guaranteed to stay stable long enough
- losing a transition is acceptable or impossible by design

Use pulse stretching if:

- the destination clock period is known
- the stretched pulse width is guaranteed
- no feedback latency is allowed

Use full handshaking if:

- every fast event must be captured
- clock ratio may vary
- the source must know when the destination has received the event
- it is acceptable to wait several cycles before sending the next event

Use an asynchronous FIFO if:

- events can arrive back-to-back
- throughput matters
- data is multi-bit
- the destination may consume slower than the source produces

## Exam or interview answer

For fast-to-slow clock domain crossing, a simple two-flop synchronizer may miss a short pulse because the pulse can occur entirely between two slow clock edges. The fast-domain pulse should first be converted into a held request level. That request is synchronized into the slow domain using two slow-clock flip-flops. The slow-domain synchronized request is then sent back to the fast domain as an acknowledge through another two-flop synchronizer. The fast domain clears the request only after the acknowledge is received, and waits for the acknowledge to return low before sending the next request. This closed-loop handshake guarantees that the slow domain gets enough time to capture the event.

## One-line memory trick

> Fast-to-slow CDC needs stretch or handshake; if every event matters, hold request until acknowledge returns.
