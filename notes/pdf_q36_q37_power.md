# PDF Q36-Q37) Power Components and Static Power Reduction in RTL

## Index

1. [36) Describe the two components that make up power](#36-describe-the-two-components-that-make-up-power)
2. [Dynamic power](#dynamic-power)
3. [Static power](#static-power)
4. [Power report view](#power-report-view)
5. [36) Interview answer](#36-interview-answer)
6. [37) Describe static power and how to reduce it in RTL](#37-describe-static-power-and-how-to-reduce-it-in-rtl)
7. [What RTL can and cannot control](#what-rtl-can-and-cannot-control)
8. [Technique 1: reduce gate count and memory/register count](#technique-1-reduce-gate-count-and-memoryregister-count)
9. [Technique 2: power-gate idle blocks](#technique-2-power-gate-idle-blocks)
10. [Technique 3: isolation cells](#technique-3-isolation-cells)
11. [Technique 4: retention registers](#technique-4-retention-registers)
12. [Technique 5: use low-leakage implementation choices](#technique-5-use-low-leakage-implementation-choices)
13. [Technique 6: memories, FIFOs, and large arrays](#technique-6-memories-fifos-and-large-arrays)
14. [Important correction: clock gating is mainly dynamic power reduction](#important-correction-clock-gating-is-mainly-dynamic-power-reduction)
15. [ASIC versus FPGA view](#asic-versus-fpga-view)
16. [37) Interview answer](#37-interview-answer)
17. [References checked](#references-checked)

## 36) Describe the two components that make up power

## Direct answer

Digital power is usually divided into:

```text
total power = dynamic power + static power
```

Dynamic power is consumed when signals switch.

Static power is consumed even when the circuit is powered but not switching.

The simple CMOS model is:

```text
P_total = P_dynamic + P_static

P_dynamic ~= alpha * C * VDD^2 * f
P_static  ~= I_leak * VDD
```

Where:

- `alpha` is the switching activity factor.
- `C` is the effective capacitance being charged and discharged.
- `VDD` is the supply voltage.
- `f` is the clock or switching frequency.
- `I_leak` is the leakage current.

## Dynamic power

Dynamic power happens because CMOS nodes have capacitance. When a signal changes from `0` to `1`, the output capacitance is charged from the supply. When it changes from `1` to `0`, that stored energy is discharged.

So dynamic power increases when:

- more nodes toggle
- the clock frequency is higher
- the switched capacitance is larger
- the voltage is higher
- there are many glitches or unnecessary transitions

The main RTL-level knobs for dynamic power are:

- reduce switching activity
- use clock enables or clock gating for idle registers
- avoid unnecessary combinational toggling
- reduce data-path width where possible
- avoid useless memory reads and writes
- reduce glitchy logic and long unnecessary combinational paths

Example:

```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 8'd0;
    end else if (count_en) begin
        count <= count + 8'd1;
    end
end
```

Here, `count_en` allows the register to update only when needed. In ASIC flow, synthesis may convert this kind of enable into clock gating. In FPGA flow, the enable usually maps to the flip-flop clock-enable resource.

This mainly reduces dynamic power because fewer registers and downstream logic toggle.

## Static power

Static power is leakage power. It exists even when:

```text
                                                        clock is stopped
                                                        signals are not changing
                                                        logic is idle
```

The circuit still leaks because real transistors are not perfect switches.

Main causes include:

- subthreshold leakage through an off transistor
- gate oxide leakage
- junction leakage
- leakage inside memories and standard cells

Static power increases with:

- more transistors and larger area
- lower-threshold voltage cells
- higher temperature
- higher supply voltage
- advanced process nodes with higher leakage
- always-on blocks that cannot be shut down

Important idea:

```text
Clock gating does not remove static leakage.
Power gating can remove most leakage from an idle block.
```

Clock gating stops switching. Power gating removes or cuts off the supply to a block.

## Power report view

In real tools, the names may be more detailed than only static and dynamic.

You may see:

```text
switching power
internal power
leakage power
```

Typical mapping:

```text
switching power = dynamic power due to net capacitance
internal power  = dynamic power inside standard cells
leakage power   = static power
```

So if an interviewer asks for the two big categories:

```text
dynamic power and static power
```

If a tool report asks for detailed categories:

```text
switching, internal, and leakage
```

## 36) Interview answer

Power in digital CMOS has two main components: dynamic and static. Dynamic power is consumed when nodes switch, and it is roughly proportional to switching activity, capacitance, supply voltage squared, and frequency: `alpha * C * VDD^2 * f`. Static power is leakage power, consumed even when the circuit is not switching, and is roughly `I_leak * VDD`. In tool reports, dynamic power may be split into switching power and internal cell power, while static power is usually reported as leakage.

## 37) Describe static power and how to reduce it in RTL

## Direct answer

Static power is leakage power consumed by powered transistors even when the circuit is idle.

At RTL, you do not directly choose transistor leakage current. RTL controls architecture, resource count, idle behavior, and power-management intent. So RTL reduces static power mainly by:

- using fewer gates, registers, memories, and always-on blocks
- sharing hardware when operations are mutually exclusive
- avoiding over-wide datapaths
- removing unused logic
- identifying blocks that can be power-gated
- adding the control signals needed for power gating, isolation, retention, and wake-up
- preserving only the state that must survive power-down

The strongest static-power reduction technique is usually:

```text
turn off the supply to an idle power domain
```

That is power gating.

## What RTL can and cannot control

RTL can control:

- how much logic is inferred
- how many registers are used
- whether a block has a clear idle state
- whether a block can be safely stopped
- which state must be saved before shutdown
- which outputs must be clamped during shutdown
- which clocks, resets, and enables are needed for a power controller

RTL usually cannot directly control:

- transistor threshold voltage
- leakage current of a specific standard cell
- power switch size
- physical placement
- exact sleep transistor implementation
- exact isolation or retention cell implementation

Those are handled by synthesis, implementation, standard-cell libraries, and power intent files such as UPF.

But RTL must make those optimizations possible.

## Technique 1: reduce gate count and memory/register count

Static power is roughly related to how much powered silicon exists.

More gates usually means:

```text
more transistors -> more leakage
```

So reducing area can reduce static power.

RTL methods:

- avoid duplicated arithmetic when one shared unit is enough
- avoid unnecessarily wide counters and datapaths
- remove unused features and debug logic in production builds
- avoid large flop arrays when a memory macro is better
- avoid keeping unused registers alive
- let synthesis remove unreachable logic
- use parameters carefully so unused blocks are not instantiated

Example: duplicated hardware

```verilog
always @(*) begin
    if (sel) begin
        y = a + b;
    end else begin
        y = c + d;
    end
end
```

Depending on synthesis and timing constraints, this may infer two adders and a mux.

If only one addition is needed per cycle, you can write the sharing explicitly:

```verilog
wire [7:0] add_lhs = sel ? a : c;
wire [7:0] add_rhs = sel ? b : d;

assign y = add_lhs + add_rhs;
```

Now the design structure clearly uses:

```text
two muxes + one adder
```

instead of:

```text
two adders + one mux
```

This can reduce area and leakage, but there is a tradeoff:

- shared hardware may reduce area and static power
- shared hardware may increase mux delay
- shared hardware may reduce throughput if operations were meant to be parallel

So resource sharing is useful only when the operations are mutually exclusive and timing still closes.

## Technique 2: power-gate idle blocks

Power gating means turning off the supply to a block when it is not needed.

This reduces static power much more directly than clock gating, because leakage needs powered transistors. If the block is disconnected from power, most of its leakage disappears.

At RTL, you usually do not instantiate the actual sleep transistor. Instead, you design the control behavior.

A typical power-down sequence is:

```text
1. finish current transaction
2. stop accepting new work
3. wait until the block is idle
4. save required state
5. clamp outputs using isolation
6. stop the clock
7. turn off the power domain
```

A typical wake-up sequence is:

```text
1. turn power back on
2. wait for supply to be stable
3. restore retained state or reset the block
4. release isolation
5. enable clock
6. allow new transactions
```

Example power controller style:

```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        iso_en      <= 1'b1;
        save_state  <= 1'b0;
        restore     <= 1'b0;
        clk_en      <= 1'b0;
        pwr_enable  <= 1'b0;
        pwr_state   <= PWR_OFF;
    end else begin
        case (pwr_state)
            PWR_ON: begin
                if (sleep_req && block_idle) begin
                    save_state <= 1'b1;
                    iso_en     <= 1'b1;
                    clk_en     <= 1'b0;
                    pwr_enable <= 1'b0;
                    pwr_state  <= PWR_OFF;
                end
            end

            PWR_OFF: begin
                if (wake_req) begin
                    pwr_enable <= 1'b1;
                    pwr_state  <= PWR_WAKE;
                end
            end

            PWR_WAKE: begin
                if (power_good) begin
                    restore   <= 1'b1;
                    iso_en    <= 1'b0;
                    clk_en    <= 1'b1;
                    pwr_state <= PWR_ON;
                end
            end
        endcase
    end
end
```

Role of the signals:

- `sleep_req`: system wants to shut down the block.
- `block_idle`: block has no unfinished transaction.
- `save_state`: tells retention logic to save important registers.
- `iso_en`: enables output isolation/clamping.
- `clk_en`: stops or restarts the clock/clock enable.
- `pwr_enable`: controls the power switch for the domain.
- `power_good`: says the power domain is back to a valid voltage.
- `restore`: tells retention logic to restore saved state.

This is the RTL part. The power intent file tells tools where the power domain is, which cells need isolation, which registers need retention, and how the power switch is controlled.

## Technique 3: isolation cells

When a block is power-gated, its outputs are no longer valid.

Without isolation, an active block may see:

```text
X
unknown
floating value
random interrupt
invalid control signal
```

Isolation cells clamp powered-off domain outputs to a known safe value.

Example:

```text
powered-off block output -> isolation cell -> active block input
```

The clamp value may be:

```text
0
1
hold previous value
```

The correct value depends on the protocol.

Examples:

- clamp `valid` to `0`
- clamp `interrupt` to `0`
- clamp `write_enable` to `0`
- clamp an inactive-low reset carefully, depending on design intent

RTL responsibility:

- know which outputs can affect active logic
- define safe inactive values
- provide or coordinate the `iso_en` control
- verify that no active block consumes invalid powered-off outputs

## Technique 4: retention registers

When a power domain is turned off, normal flops lose their state.

That is fine for registers that can be reset or recomputed.

It is not fine for state that must survive sleep, such as:

- configuration registers
- security state
- protocol state
- wake-up context
- partial computation state

Retention registers are special flops or retention structures that preserve selected state while the main block is powered off.

Important rule:

```text
Do not retain every register by default.
```

Retention costs area and power because retention logic must stay supplied. A good low-power design retains only the state required for correct wake-up.

RTL responsibility:

- identify which state must survive power-down
- separate retained state from resettable/recomputable state
- define save and restore timing
- verify wake-up behavior

Example classification:

```text
must retain:
    configuration registers
    mode bits needed immediately after wake

can reset:
    temporary pipeline registers
    counters that restart from zero
    valid bits for flushed transactions

can recompute:
    cached combinational results
    temporary datapath values
```

## Technique 5: use low-leakage implementation choices

Some static-power reduction is not written as normal RTL logic, but RTL can enable it.

Implementation options include:

- high-`Vt` standard cells for non-critical paths
- multi-`Vt` optimization
- longer-channel devices
- lower leakage memories
- body biasing, if supported by the process
- voltage islands or lower-voltage domains

RTL helps by:

- keeping timing realistic
- avoiding unnecessary high-speed requirements
- separating fast critical logic from slow always-on logic
- giving synthesis clean enables and hierarchy
- not over-constraining slow blocks

If every path is declared timing-critical, the tool may choose faster, leakier cells. If the design clearly separates critical and non-critical logic, the implementation tool has more freedom to use low-leakage cells.

## Technique 6: memories, FIFOs, and large arrays

Large arrays can leak a lot because they contain many storage cells.

RTL choices that matter:

- infer memory macros instead of thousands of flops when appropriate
- use memory enable signals
- avoid unnecessary reads and writes
- use memory sleep, retention, or shutdown modes if the technology supports them
- split a large memory if only part of it must stay alive
- preserve only required memory contents across sleep

Example:

```verilog
always @(posedge clk) begin
    if (mem_wr_en) begin
        mem[mem_addr] <= mem_wdata;
    end

    if (mem_rd_en) begin
        mem_rdata <= mem[mem_addr];
    end
end
```

`mem_wr_en` and `mem_rd_en` help avoid unnecessary memory activity. That mainly reduces dynamic power, but these enables also make power analysis and memory low-power modes easier to reason about.

## Important correction: clock gating is mainly dynamic power reduction

Clock gating is very important, but it mainly reduces dynamic power.

Clock gating stops:

```text
clock tree switching
register toggling
downstream data switching
```

But the cells are still powered, so they still leak.

So:

```text
clock gating = mostly dynamic power reduction
power gating = static leakage reduction
```

Clock gating may be part of the power-down sequence, because you normally stop clocks before or during shutdown. But clock gating alone is not enough to remove static power.

## ASIC versus FPGA view

### ASIC

In ASIC design, RTL plus UPF can define real power domains.

ASIC low-power flow can insert:

- power switches
- isolation cells
- retention registers
- level shifters
- clock-gating cells
- high-`Vt` cells on non-critical paths

This gives strong control over both dynamic and static power.

### FPGA

In FPGA design, the fabric already exists on the chip.

RTL can reduce:

- dynamic power by reducing switching
- design-dependent power by using fewer active resources
- memory and DSP activity through enables

But FPGA static power is heavily affected by:

- chosen FPGA device
- process and temperature
- voltage rails
- transceivers and hard IP blocks
- whether vendor-supported low-power modes exist

So in FPGA, you usually reduce static power by:

- selecting a smaller or lower-power device
- disabling unused hard IP
- turning off unused transceivers or PLLs if supported
- using vendor-supported clock/power controls
- lowering temperature and voltage within allowed limits

Do not assume ASIC-style RTL power gating is available in a normal FPGA fabric.

## 37) Interview answer

Static power is leakage power consumed while the circuit is powered, even if no signals are switching. At RTL, I can reduce it indirectly by reducing area, avoiding unnecessary registers and memories, sharing resources when operations are mutually exclusive, and designing blocks so they can be shut down when idle. For real leakage reduction, the strongest method is power gating: partition the design into power domains, stop the block safely, save any required state using retention registers, isolate outputs to safe values, and then turn off the domain. Clock gating is still useful, but it mainly reduces dynamic power; it does not eliminate leakage because the logic remains powered.

## References checked

- [WPI Advanced Digital Systems Design: Power Analysis and Optimization](https://schaumont.dyn.wpi.edu/ece574f24/09power.html): dynamic power formula, static/leakage power, and power-report categories.
- [BDTI Inside DSP on Low Power](https://www.bdti.com/InsideDSP/2004/06/01/InsideDSP-on-Low-Power-2): simplified CMOS power model using switching and leakage terms.
- [AMD Vivado `power_opt_design`](https://docs.amd.com/r/2021.2-English/ug835-vivado-tcl-commands/power_opt_design): dynamic power optimization using clock gating and clock enables.
- [AMD Vivado Using Clock Enables](https://docs.amd.com/r/2024.2-English/ug904-vivado-implementation/Using-Clock-Enables-CEs): clock-enable based gating and clock-power reduction.
- [Cadence low-power verification with IEEE 1801 UPF](https://www.cadence.com/content/dam/cadence-www/global/en_US/documents/tools/system-design-verification/low-power-wp.pdf): power gating, isolation cells, retention registers, and power switches.
- [EDN low-power design specification from RTL through GDSII](https://www.edn.com/low-power-design-specification-from-rtl-through-gdsii/): UPF power domains, power switches, retention, and isolation strategies.
