# PDF Q38-Q39) Dynamic Power and RTL Low-Power Techniques

## Index

1. [38) Describe dynamic power](#38-describe-dynamic-power)
2. [Dynamic power formula](#dynamic-power-formula)
3. [Where dynamic power comes from physically](#where-dynamic-power-comes-from-physically)
4. [What increases dynamic power](#what-increases-dynamic-power)
5. [Dynamic power in RTL terms](#dynamic-power-in-rtl-terms)
6. [38) Interview answer](#38-interview-answer)
7. [39) Describe low-power techniques with RTL code](#39-describe-low-power-techniques-with-rtl-code)
8. [Technique 1: do not let registers toggle unnecessarily](#technique-1-do-not-let-registers-toggle-unnecessarily)
9. [Technique 2: stop counters when they are done](#technique-2-stop-counters-when-they-are-done)
10. [Technique 3: use clock enables instead of manual clock AND gates](#technique-3-use-clock-enables-instead-of-manual-clock-and-gates)
11. [Technique 4: clock gating](#technique-4-clock-gating)
12. [Technique 5: operand isolation](#technique-5-operand-isolation)
13. [Technique 6: valid-based pipeline gating](#technique-6-valid-based-pipeline-gating)
14. [Technique 7: memory and RAM enables](#technique-7-memory-and-ram-enables)
15. [Technique 8: avoid glitch power](#technique-8-avoid-glitch-power)
16. [Technique 9: avoid useless wide logic and unused activity](#technique-9-avoid-useless-wide-logic-and-unused-activity)
17. [Technique 10: choose architecture carefully](#technique-10-choose-architecture-carefully)
18. [Technique 11: Gray-code state and address transitions](#technique-11-gray-code-state-and-address-transitions)
19. [Technique 12: bus inversion and bus encoding](#technique-12-bus-inversion-and-bus-encoding)
20. [Important RTL coding notes](#important-rtl-coding-notes)
21. [39) Interview answer](#39-interview-answer)
22. [References checked](#references-checked)

## 38) Describe dynamic power

## Direct answer

Dynamic power is the power consumed when signals switch.

In CMOS logic, power is consumed mainly when internal and output capacitances are charged and discharged during transitions:

```text
0 -> 1
1 -> 0
```

So if a signal does not toggle, it does not consume switching power on that node.

The usual first-order formula is:

```text
P_dynamic ~= alpha * C * VDD^2 * f
```

Meaning:

- `alpha`: activity factor, or how often the node toggles.
- `C`: capacitance being charged/discharged.
- `VDD`: supply voltage.
- `f`: clock frequency or switching frequency.

## Dynamic power formula

The important part of the formula is:

```text
P_dynamic proportional to alpha
P_dynamic proportional to C
P_dynamic proportional to VDD^2
P_dynamic proportional to f
```

So:

- If switching activity doubles, dynamic power roughly doubles.
- If frequency doubles, dynamic power roughly doubles.
- If capacitance doubles, dynamic power roughly doubles.
- If voltage doubles, dynamic power roughly becomes four times larger.

That voltage-square term is why voltage reduction is powerful, but voltage is usually not controlled only by RTL. RTL mainly controls activity and sometimes the amount of logic/capacitance inferred.

## Where dynamic power comes from physically

A CMOS gate has PMOS and NMOS transistor networks.

When the output changes:

```text
0 -> 1:
    output capacitance charges from VDD

1 -> 0:
    output capacitance discharges to GND
```

That charge and discharge costs energy.

There is also short-circuit power during switching. For a short time, both PMOS and NMOS paths may conduct partially, creating a temporary path:

```text
VDD -> PMOS network -> NMOS network -> GND
```

This short-circuit component also depends on transitions, so it is usually counted as part of dynamic power.

Important distinction:

```text
switching power:
    charging and discharging capacitance

short-circuit power:
    temporary current path during input/output transition

both happen because signals are switching
```

## What increases dynamic power

Dynamic power increases when:

- many registers toggle every cycle
- clocks run at high frequency
- wide buses switch frequently
- high-fanout signals toggle frequently
- counters run even when nobody needs their value
- combinational logic toggles even when its output is ignored
- memory ports are clocked every cycle
- DSPs/multipliers receive changing operands even when their result is unused
- glitchy combinational paths create extra temporary transitions
- the design is over-wide or over-parallel for the required throughput

Dynamic power is not only about the final output value. Internal nodes can switch even when the final output does not change.

Example:

```verilog
assign y = en ? (a * b) : 32'd0;
```

If `a` and `b` keep changing while `en = 0`, the multiplier may still toggle internally even though `y` is forced to zero. That wastes dynamic power.

## Dynamic power in RTL terms

At RTL, think like this:

```text
Every unnecessary toggle is unnecessary dynamic power.
```

Good RTL asks:

- Does this register need to update this cycle?
- Does this counter need to count now?
- Does this memory need to read now?
- Does this multiplier need changing operands now?
- Does this pipeline stage contain valid data?
- Can this block be idle without switching?
- Can this high-fanout enable or clock be used safely?

Dynamic power is reduced by making idle logic stay quiet.

## 38) Interview answer

Dynamic power is the power consumed when CMOS signals transition between `0` and `1`. It is mainly due to charging and discharging capacitance, plus short-circuit current during switching when PMOS and NMOS devices may conduct briefly together. The common model is `P_dynamic ~= alpha * C * VDD^2 * f`, so dynamic power depends on switching activity, capacitance, supply voltage squared, and frequency. At RTL, the practical way to reduce it is to reduce unnecessary toggling.

## 39) Describe low-power techniques with RTL code

## Direct answer

The main RTL low-power idea is:

```text
do not toggle logic unless its new value is useful
```

Common RTL techniques are:

- clock enables
- clock gating through proper cells or FPGA clock-enable resources
- stop conditions for counters
- valid-based pipeline updates
- operand isolation for large combinational blocks
- memory read/write enables
- disabling unused blocks
- avoiding unnecessary wide logic
- reducing glitches with better registered boundaries
- choosing a lower-power architecture

## Technique 1: do not let registers toggle unnecessarily

Bad style:

```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_q <= 32'd0;
    end else begin
        data_q <= data_d;
    end
end
```

This register updates every clock cycle. If `data_d` changes every cycle but the block is idle, `data_q` also toggles unnecessarily.

Better style:

```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_q <= 32'd0;
    end else if (data_en) begin
        data_q <= data_d;
    end
end
```

Signal roles:

- `data_en`: says this register has a useful new value to capture.
- `data_d`: next value.
- `data_q`: stored value.

When `data_en = 0`, `data_q` keeps its old value and does not toggle. In FPGA, this often maps to a flip-flop clock-enable pin. In ASIC, synthesis may use this enable to infer integrated clock gating if the enable controls enough registers.

## Technique 2: stop counters when they are done

A free-running counter is a classic source of useless toggling.

Bad style:

```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 8'd0;
    end else begin
        counter <= counter + 8'd1;
    end
end
```

This counter toggles forever.

Better style with start and stop conditions:

```verilog
module low_power_counter #(
    parameter [7:0] STOP_VALUE = 8'd31
)(
    input  wire       clk,
    input  wire       rst_n,
    input  wire       start,
    output reg        busy,
    output reg        done,
    output reg  [7:0] counter
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 8'd0;
            busy    <= 1'b0;
            done    <= 1'b0;
        end else begin
            done <= 1'b0;

            if (start && !busy) begin
                counter <= 8'd0;
                busy    <= 1'b1;
            end else if (busy) begin
                if (counter == STOP_VALUE) begin
                    busy <= 1'b0;
                    done <= 1'b1;
                end else begin
                    counter <= counter + 8'd1;
                end
            end
        end
    end

endmodule
```

Signal roles:

- `start`: begins one count operation.
- `busy`: tells the design the counter is currently active.
- `STOP_VALUE`: final count value.
- `done`: one-cycle pulse when the count completes.
- `counter`: only increments while `busy = 1`.

Power idea:

```text
counter toggles only during the useful counting window
```

Once the counter reaches `STOP_VALUE`, it stops. That prevents the lower bits from toggling every cycle forever.

Important note:

```text
Do not use #1 delays in synthesizable RTL.
```

Some printed examples use:

```verilog
counter <= #1 counter + 1;
```

That `#1` is a simulation delay style. For synthesizable RTL, write:

```verilog
counter <= counter + 1;
```

## Technique 3: use clock enables instead of manual clock AND gates

This is good RTL:

```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        q <= 1'b0;
    end else if (en) begin
        q <= d;
    end
end
```

This says:

```text
update q only when en is high
```

Do not write this in normal RTL:

```verilog
assign gated_clk = clk & en;

always @(posedge gated_clk or negedge rst_n) begin
    if (!rst_n) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end
```

Why this is risky:

- `en` can glitch.
- the gated clock can create a runt pulse.
- clock skew can become uncontrolled.
- timing tools need special clock-gating checks.
- FPGA fabrics usually have dedicated clock-enable or clock-buffer resources.

Correct idea:

```text
Write clean clock-enable RTL.
Let ASIC synthesis infer an integrated clock-gating cell when appropriate.
Use FPGA clock-enable pins or vendor clock-buffer primitives when needed.
```

## Technique 4: clock gating

Clock gating turns off the clock to idle registers.

Why it saves dynamic power:

- the clock tree stops toggling in that region
- flip-flop internal clock pins stop toggling
- registers stop updating
- downstream combinational logic often stops toggling

ASIC clock gating usually uses an integrated clock-gating cell, not a raw AND gate.

Conceptually:

```text
clk + enable -> integrated clock gate -> gated_clk
```

Then a group of registers uses `gated_clk`.

RTL usually describes this as an enable:

```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pipe_q <= 16'd0;
    end else if (pipe_en) begin
        pipe_q <= pipe_d;
    end
end
```

The synthesis tool may convert this into clock gating if:

- enough registers share the same enable
- timing is safe
- clock-gating insertion is enabled
- the target library has proper clock-gating cells

Granularity:

```text
coarse-grain gating:
    stop a whole module or large block

fine-grain gating:
    stop smaller register groups
```

Coarse-grain gating usually gives larger power savings, but wake-up/control may be more complex.

Do not add a clock gate for just one or two flops without checking the power result.

Reason:

```text
clock-gating cell area/leakage + enable logic + verification cost
```

may be larger than the dynamic power saved by gating a tiny register group.

A better rule is:

```text
Use clock gating when a meaningful group of registers shares the same idle condition.
```

In ASIC RTL, some flows explicitly instantiate a clock-gating wrapper or library cell. The real cell name is library-specific, but the concept is:

```verilog
module gated_reg_bank (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        bank_en,
    input  wire [31:0] bank_d,
    output reg  [31:0] bank_q
);

    wire bank_clk;

    integrated_clock_gate u_bank_cg (
        .clk_in  (clk),
        .enable  (bank_en),
        .clk_out (bank_clk)
    );

    always @(posedge bank_clk or negedge rst_n) begin
        if (!rst_n) begin
            bank_q <= 32'd0;
        end else begin
            bank_q <= bank_d;
        end
    end

endmodule
```

Signal roles:

- `bank_en`: says the whole register bank has useful work.
- `integrated_clock_gate`: stands for a real glitch-safe clock-gating cell from the ASIC library.
- `bank_clk`: gated clock that should only be generated by a proper clock-gating cell.

This example shows the structure, but in many RTL flows you still write the enable style and let synthesis insert the real clock-gating cell.

## Technique 5: operand isolation

Operand isolation prevents unnecessary input changes from entering expensive combinational logic.

Bad style:

```verilog
assign mult_result = a * b;
assign y           = use_mult ? mult_result : 32'd0;
```

Even when `use_mult = 0`, if `a` and `b` keep changing, the multiplier can still toggle internally.

Better style:

```verilog
wire [15:0] a_iso = use_mult ? a : 16'd0;
wire [15:0] b_iso = use_mult ? b : 16'd0;

assign mult_result = a_iso * b_iso;
assign y           = use_mult ? mult_result : 32'd0;
```

Signal roles:

- `use_mult`: says the multiplier result is actually needed.
- `a_iso`, `b_iso`: stable operands when the multiplier is not used.
- `mult_result`: output of the expensive combinational block.

Power idea:

```text
if the result is not needed, keep the multiplier inputs stable
```

Tradeoff:

Operand isolation adds muxes. It is useful when the isolated block is large enough, active enough, or high-capacitance enough that the saved switching is larger than the mux overhead.

Good candidates:

- multipliers
- dividers
- wide adders
- comparators
- CRC blocks
- encryption datapaths
- wide mux trees

## Technique 6: valid-based pipeline gating

Pipeline registers should not always update if the stage does not contain valid data.

Bad style:

```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage_data <= 32'd0;
        stage_valid <= 1'b0;
    end else begin
        stage_data  <= next_data;
        stage_valid <= next_valid;
    end
end
```

`stage_data` changes whenever `next_data` changes, even if `next_valid = 0`.

Better style:

```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage_data  <= 32'd0;
        stage_valid <= 1'b0;
    end else begin
        stage_valid <= next_valid;

        if (next_valid) begin
            stage_data <= next_data;
        end
    end
end
```

Now `stage_data` updates only when it carries a real valid item.

Power idea:

```text
valid = 0 means data is meaningless
so do not toggle the data register
```

This is very useful for buses, pipelines, packet paths, and streaming designs.

If downstream logic depends on `stage_data` even when `stage_valid = 0`, fix the protocol first. Data should be meaningful only when valid is high.

## Technique 7: memory and RAM enables

Memory blocks can consume significant dynamic power if clocked or accessed unnecessarily.

Bad style:

```verilog
always @(posedge clk) begin
    rdata <= mem[addr];

    if (wr_en) begin
        mem[addr] <= wdata;
    end
end
```

This reads every cycle, even when no read is needed.

Better style:

```verilog
always @(posedge clk) begin
    if (wr_en) begin
        mem[waddr] <= wdata;
    end

    if (rd_en) begin
        rdata <= mem[raddr];
    end
end
```

Signal roles:

- `wr_en`: write only when needed.
- `rd_en`: read only when needed.
- `waddr`, `raddr`: address buses that should be meaningful only during real access.
- `rdata`: updates only on real reads.

Power idea:

```text
do not clock/access memory ports unless there is a real read or write
```

In FPGA designs, using memory enable signals helps the tool map to block RAM enable pins or memory clock-enable behavior.

## Technique 8: avoid glitch power

Glitches are temporary unwanted transitions inside combinational logic.

Example:

```text
input changes
different paths have different delays
internal node briefly toggles to the wrong value
then settles
```

Even if the final output is correct, the temporary toggles still consume dynamic power.

Ways to reduce glitch power:

- register high-activity inputs before large combinational blocks
- pipeline long arithmetic paths
- avoid very unbalanced reconvergent paths
- avoid constantly changing unused operands
- use one clean mux point instead of many scattered muxes
- avoid feeding wide logic with changing data when `valid = 0`

Example:

```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_q <= 16'd0;
        b_q <= 16'd0;
    end else if (calc_en) begin
        a_q <= a;
        b_q <= b;
    end
end

assign sum = a_q + b_q;
```

Here, `a_q` and `b_q` change only when `calc_en` is high, so the adder does not see random input changes during idle cycles.

## Technique 9: avoid useless wide logic and unused activity

Wide datapaths cost power because many bits can toggle.

RTL checks:

- Is a 64-bit counter needed, or is 12 bits enough?
- Is a full multiplier needed, or is a shift/add enough?
- Is a wide compare needed every cycle?
- Does debug logic toggle in production?
- Are unused features still instantiated?
- Are unused bus fields changing even when ignored?

Example: width control

```verilog
localparam COUNT_W = 5;

reg [COUNT_W-1:0] count;
```

If the design only counts to `31`, a 5-bit counter is enough. An 8-bit or 32-bit counter would toggle extra flops and logic.

## Technique 10: choose architecture carefully

Low-power RTL is not only about adding enables. Architecture matters.

Examples:

- Use a smaller datapath if throughput allows.
- Use resource sharing if operations are mutually exclusive.
- Use parallel hardware only when required by throughput.
- Keep high-frequency logic small.
- Move rarely used work into a slower or gated block.
- Split always-on logic from idle-able logic.
- Avoid waking a large block for a tiny task.

Resource sharing example:

```verilog
wire [15:0] add_lhs = sel ? a : c;
wire [15:0] add_rhs = sel ? b : d;

assign y = add_lhs + add_rhs;
```

This uses one adder when only one addition is needed at a time.

But there is a tradeoff:

```text
sharing can reduce area and capacitance
sharing can add mux delay
sharing can reduce throughput
```

So use it when the operations are naturally mutually exclusive.

## Technique 11: Gray-code state and address transitions

Gray coding can reduce switching because only one bit changes between adjacent encoded values.

For a state machine, binary encoding may change several state bits on one transition.

Example:

```text
binary state transition:
    3'b011 -> 3'b100
    three bits toggle

Gray-style transition:
    3'b010 -> 3'b110
    one bit toggles
```

If the FSM transitions frequently, fewer state-bit toggles can reduce dynamic power in:

- the state register
- next-state decode
- output decode
- downstream control logic

Example:

```verilog
localparam [1:0] IDLE = 2'b00;
localparam [1:0] LOAD = 2'b01;
localparam [1:0] RUN  = 2'b11;
localparam [1:0] DONE = 2'b10;

reg [1:0] state;
reg [1:0] next_state;

always @(*) begin
    next_state = state;

    case (state)
        IDLE: if (start)      next_state = LOAD;
        LOAD:                 next_state = RUN;
        RUN:  if (run_done)   next_state = DONE;
        DONE:                 next_state = IDLE;
        default:              next_state = IDLE;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end
```

This state order has one-bit transitions:

```text
00 -> 01 -> 11 -> 10 -> 00
```

Important tradeoff:

Gray-coded FSMs are not always lower power overall. If the Gray encoding makes decode logic much larger or glitchier, the saved state-register toggles may be lost in the combinational logic. Use it when state transitions are frequent and decode remains simple.

Gray coding can also reduce toggles on internal address buses used for sequential access, such as read/write pointers or address decoding paths.

Example:

```verilog
assign gray_addr = bin_addr ^ (bin_addr >> 1);
```

This is especially common in FIFO pointers. For CDC, Gray code is used mainly for safe pointer crossing. For low power, the useful property is still the same:

```text
only one bit changes between adjacent values
```

## Technique 12: bus inversion and bus encoding

Wide data buses can burn dynamic power because many bits may toggle at once.

Bus inversion reduces bit toggles by comparing the next bus value with the previous transmitted bus value.

If more than half the bits would toggle, transmit the inverted version and assert an extra sideband bit called `invert`.

The receiver reconstructs the original value:

```text
if invert = 0:
    received data = bus

if invert = 1:
    received data = ~bus
```

Example for an 8-bit bus:

```text
previous bus = 8'b0000_0000
next data    = 8'b1111_0001
```

Seven bits would toggle. Since `7 > 8/2`, transmit:

```text
bus    = ~next_data = 8'b0000_1110
invert = 1
```

Now only four physical signals toggle:

```text
bus[3:1] plus invert
```

instead of seven data bits.

Simple RTL example:

```verilog
module bus_invert_encoder #(
    parameter WIDTH = 8
)(
    input  wire [WIDTH-1:0] prev_bus,
    input  wire [WIDTH-1:0] next_data,
    output wire [WIDTH-1:0] enc_bus,
    output wire             invert
);

    wire [WIDTH-1:0] diff;
    wire [$clog2(WIDTH+1)-1:0] toggle_count;

    assign diff = prev_bus ^ next_data;
    assign toggle_count = count_ones(diff);
    assign invert = (toggle_count > (WIDTH/2));
    assign enc_bus = invert ? ~next_data : next_data;

    function automatic [$clog2(WIDTH+1)-1:0] count_ones;
        input [WIDTH-1:0] value;
        integer i;
        begin
            count_ones = '0;
            for (i = 0; i < WIDTH; i = i + 1) begin
                count_ones = count_ones + value[i];
            end
        end
    endfunction

endmodule
```

Decoder:

```verilog
assign data_out = invert ? ~enc_bus : enc_bus;
```

Signal roles:

- `prev_bus`: previous encoded physical bus value.
- `next_data`: real new data that should be communicated.
- `diff`: marks which bits would toggle.
- `toggle_count`: number of changing bits.
- `invert`: sideband signal telling receiver that `enc_bus` was inverted.
- `enc_bus`: physical bus driven across the wide connection.

Tradeoff:

```text
bus inversion saves power only if saved bus toggles exceed encoder/decoder overhead
```

It is most useful for wide, high-capacitance, high-activity buses. It is less useful for narrow buses or buses where data already changes only a little.

## Important RTL coding notes

### Do not manually gate clocks with random logic

Avoid:

```verilog
assign clk_gated = clk & en;
```

Use:

- register enables in generic RTL
- integrated clock-gating cells in ASIC flows
- BUFGCE/clock-control primitives or flip-flop CE pins in FPGA flows

### Do not use delays in synthesizable RTL

Avoid:

```verilog
q <= #1 d;
```

Use:

```verilog
q <= d;
```

### Make enable conditions meaningful

A bad enable that is high almost all the time saves little power.

Good enable:

```text
high only when the register/block has useful work
```

Poor enable:

```text
high every cycle because it was easy to connect
```

### Verify power with realistic activity

Power depends strongly on activity. A design may look low-power under one testbench and high-power under a real workload.

Use realistic:

- simulation waveforms
- SAIF/VCD activity files
- clock frequencies
- enable duty cycles
- memory access rates
- traffic patterns

## 39) Interview answer

At RTL, low-power design mainly means reducing unnecessary switching activity. I would use clock enables so registers update only when their new value is useful, stop counters when they reach their terminal count, gate pipelines based on valid signals, use memory read/write enables, and isolate operands going into large blocks like multipliers when their result is not needed. For ASIC, synthesis can convert common enables into integrated clock gating cells; for FPGA, I would prefer flip-flop clock enables or vendor clock-buffer enables instead of manually ANDing clocks. I would also consider Gray-coded FSM/address transitions and bus-invert encoding for high-activity buses when the encoding overhead is justified. I would avoid `#` delays in synthesizable RTL and verify power using realistic switching activity.

## References checked

- [WPI Advanced Digital Systems Design: Power Analysis and Optimization](https://schaumont.dyn.wpi.edu/ece574f24/09power.html): dynamic power formula, activity factor, short-circuit power, glitch power, and static/leakage context.
- [AMD Vivado Implementation UG904: Power Optimization](https://docs.amd.com/r/en-US/ug904-vivado-implementation/Power-Optimization): dynamic power optimization and intelligent clock gating.
- [AMD Vivado Implementation UG904: Using Clock Enables](https://docs.amd.com/r/2024.2-English/ug904-vivado-implementation/Using-Clock-Enables-CEs): clock-enable based implementation context.
- [Intel MAX 10 FPGA Design Guidelines: Optimize clock power management](https://www.intel.com/content/www/us/en/docs/programmable/683196/current/optimize-the-clock-power-management.html): clock power, clock-enable guidance, memory clocking, glitches, and architectural power topics.
- [Intel Quartus Prime Pro Power Analysis and Optimization: Clock Enable in Memory Blocks](https://www.intel.com/content/www/us/en/docs/programmable/683174/21-4/clock-enable-in-memory-blocks.html): memory power reduction through memory clock-enable behavior.
- [Intel Stratix 10 Embedded Memory User Guide: Reduce Power Consumption](https://www.intel.com/content/www/us/en/docs/programmable/683423/21-4/reduce-power-consumption.html): memory read enable and embedded memory low-power guidance.
- [Synopsys Low Power Design overview](https://www.synopsys.com/glossary/what-is-low-power-design.html): clock gating, power gating, RTL power analysis, and activity-based dynamic power discussion.
- [Original Bus-Invert Coding paper](https://www.eng.auburn.edu/~agrawvd/COURSE/E6270_Fall07/PROJECT/JIANG/StanTVLSI95-BusInvertCoding.pdf): bus-invert decision based on Hamming distance greater than half the bus width.
- [All About Circuits: FSM State Encoding](https://www.allaboutcircuits.com/technical-articles/encoding-the-states-of-a-finite-state-machine-vhdl/): Gray-coded state assignment and switching reduction idea.
