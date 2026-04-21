# PDF Q31) What is metastability?

## Direct answer

**Metastability** is a condition where a flip-flop or register output is temporarily not a clean logic `0` and not a clean logic `1`.

It usually happens when the input changes too close to the active clock edge. That means the input violates the flip-flop's **setup time** or **hold time** requirement. Intel's FPGA metastability white paper explains that when a register's setup or hold timing is violated, the output can enter a metastable state and take longer than the normal clock-to-output delay to settle to a valid high or low value. ([Intel FPGA metastability white paper](https://cdrdv2-public.intel.com/650346/wp-01082-quartus-ii-metastability.pdf))

Short definition:

> Metastability is an unstable intermediate state of a flip-flop where the output takes an unpredictable amount of time to settle to `0` or `1`.

## Why metastability happens

A flip-flop needs the input data to be stable around the clock edge:

```text
before clock edge -> setup time
after clock edge  -> hold time
```

So for a positive-edge triggered flip-flop:

```text
              active clock edge
                     |
data must be stable  |  data must still be stable
       before here   |       after here
```

If the data changes inside this small timing window, the flip-flop may not clearly know whether it should capture:

- the old value
- the new value

So instead of immediately becoming a clean `0` or `1`, the internal transistor feedback can balance for a short time. That temporary uncertain condition is called **metastability**.

## Deep hardware intuition

Digital design looks like it has only two values:

```text
0 and 1
```

But real hardware is analog underneath. A flip-flop is built from transistors and feedback nodes. Internally, those nodes have voltages, delays, gain, noise, and switching thresholds.

A good mental model is a ball on a hill:

```text
left side  -> stable logic 0
right side -> stable logic 1
top        -> metastable point
```

If the ball is clearly on the left, it rolls to `0`.
If the ball is clearly on the right, it rolls to `1`.
If the ball is almost exactly on top, it may balance for some time before falling to either side.

That is what happens inside the flip-flop. It eventually settles to `0` or `1`, but the exact settling time is not predictable for a bad timing event.

## Where metastability occurs

Metastability usually appears when a signal is not synchronous to the clock that samples it.

Common cases:

- clock domain crossing, also called **CDC**
- asynchronous input pins
- push buttons and switches
- external sensor or peripheral signals
- asynchronous reset release
- signals moving between unrelated clocks

Example:

```text
signal produced by clk_A
signal captured by clk_B
clk_A and clk_B are unrelated
```

Because the two clocks are unrelated, the signal can change at any time relative to `clk_B`. That means the destination flip-flop may sometimes see a setup or hold violation.

## Why metastability is dangerous

The dangerous part is not only that the first flip-flop becomes uncertain. The dangerous part is what happens if the next logic reads that signal before it settles.

Possible failures:

- one logic path may read the value as `0`
- another logic path may read the same value as `1`
- an FSM may jump to a wrong state
- a counter or pointer may update incorrectly
- a FIFO full/empty flag may become wrong
- simulation may not show the real failure, because metastability is analog behavior

Important point:

> Metastability is a timing reliability problem, not a Verilog syntax problem.

Your Verilog may be syntactically correct and still describe hardware that can fail if asynchronous signals are sampled without synchronization.

## Can metastability be completely removed?

For asynchronous inputs and clock domain crossings, metastability cannot be completely removed in a strict mathematical sense. It can only be made very unlikely.

The practical design goal is to make the failure probability extremely small. This is measured using:

```text
MTBF = Mean Time Between Failures
```

Higher MTBF means a more reliable design.

Intel's Quartus guide says that adding settling time in a synchronizer chain improves the chance that a metastable signal resolves to a known value and can exponentially increase MTBF. ([Intel Quartus MTBF guide](https://www.intel.com/content/www/us/en/docs/programmable/683082/23-1/mtbf-optimization-64725.html))

Research literature also notes that synchronizers reduce the probability of unresolved metastability over time, but do not guarantee success for every possible asynchronous event. ([Metastability-Containing Circuits, arXiv](https://arxiv.org/abs/1606.06570))

## How to reduce metastability for a single-bit signal

For a single asynchronous control signal, the standard solution is a **two-flip-flop synchronizer**.

```verilog
module two_ff_synchronizer (
    input  wire clk,
    input  wire rst,
    input  wire async_in,
    output wire sync_out
);

    reg sync_1;
    reg sync_2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sync_1 <= 1'b0;
            sync_2 <= 1'b0;
        end else begin
            sync_1 <= async_in;
            sync_2 <= sync_1;
        end
    end

    assign sync_out = sync_2;

endmodule
```

Here:

- `sync_1` samples the asynchronous input
- `sync_1` may become metastable
- `sync_2` samples `sync_1` one clock later
- that extra clock cycle gives `sync_1` time to settle

So the second flip-flop greatly reduces the chance that metastability reaches the main design.

Memory line:

> first flop may suffer, second flop protects the circuit.

## Important warning for multi-bit signals

Do **not** synchronize every bit of a multi-bit bus independently using separate two-flop synchronizers.

Bad idea:

```text
// Not safe for a changing multi-bit bus
sync bit 0 separately
sync bit 1 separately
sync bit 2 separately
sync bit 3 separately
```

The reason is that different bits may settle or transfer on different clock cycles. The destination domain may see a mixed value that never existed in the source domain.

For multi-bit clock domain crossing, use proper CDC methods:

- asynchronous FIFO
- handshake protocol
- valid/ready style transfer
- Gray-code counter or pointer crossing
- vendor-provided CDC primitives when appropriate

## Relation to setup and hold time

Setup time means:

```text
data must be stable before the clock edge
```

Hold time means:

```text
data must remain stable after the clock edge
```

If either requirement is violated:

```text
setup violation or hold violation -> possible metastability
```

So the chain is:

```text
asynchronous timing
        -> setup/hold violation
        -> metastability risk
        -> possible system failure
```

## Exam or interview answer

Metastability is an unstable condition in a flip-flop where the output is temporarily neither a valid logic `0` nor a valid logic `1`. It happens when the input changes too close to the active clock edge, causing a setup or hold time violation. The flip-flop eventually settles to `0` or `1`, but the settling time is unpredictable. Metastability commonly occurs in asynchronous inputs and clock domain crossings. It cannot be completely eliminated, but its probability can be reduced using synchronizers, such as a two-flip-flop synchronizer for single-bit signals.

## One-line memory trick

> Metastability = flip-flop confusion caused by bad timing near the clock edge.
