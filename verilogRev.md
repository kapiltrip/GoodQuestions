# Verilog Revision - Course Videos 1 to 3

Video 1: [Introduction to Verilog: Modules, Number Representations & Comments](https://www.youtube.com/watch?v=IP_8QJ5k2I8)

Video 2: [Verilog Data Types Explained | reg, net, integer, real, time](https://www.youtube.com/watch?v=R57WWiEqkLQ)

Video 3: [Port Connection Rules in Verilog | Connect by Order vs Connect by Name Explained](https://www.youtube.com/watch?v=C219U48xX04)

Note on screenshots: I did not embed every slide screenshot from the videos because that would recreate the creator's slide deck. Instead, each video has timestamp links to the exact slide/topic positions, followed by original revision notes, examples, pitfalls, and quizzes.

Caption cleanup used in this note: "vlog" means Verilog, "FPJ" means FPGA, "Vado/Vivo" means Vivado, "quarters" means Quartus, "rich/ridge" means `reg`, "war" means `wor`, and "van/vand" means `wand`.

## Index

- [Course Video Index](#course-video-index)
- [Video 1 Timestamp Index](#video-1-timestamp-index)
- [V1-1) HDL And Verilog Mindset](#v1-1-hdl-and-verilog-mindset)
- [V1-2) EDA Tools And Synthesis Flow](#v1-2-eda-tools-and-synthesis-flow)
- [V1-3) Synthesizable vs Non-Synthesizable Code](#v1-3-synthesizable-vs-non-synthesizable-code)
- [V1-4) Module Structure](#v1-4-module-structure)
- [V1-5) Ports And Identifiers](#v1-5-ports-and-identifiers)
- [V1-6) Abstraction Levels](#v1-6-abstraction-levels)
- [V1-7) Number Representation](#v1-7-number-representation)
- [V1-8) Strings And Comments](#v1-8-strings-and-comments)
- [V1-9) Video 1 Quiz](#v1-9-video-1-quiz)
- [Video 2 Timestamp Index](#video-2-timestamp-index)
- [V2-1) What A Data Type Means In Verilog](#v2-1-what-a-data-type-means-in-verilog)
- [V2-2) Net Data Type: Connection, Not Storage](#v2-2-net-data-type-connection-not-storage)
- [V2-3) `wire`: Continuous Driving And Width Traps](#v2-3-wire-continuous-driving-and-width-traps)
- [V2-4) Four-State Logic: `0`, `1`, `x`, `z`](#v2-4-four-state-logic-0-1-x-z)
- [V2-5) Multiple Drivers: `wire`, `wor`, And `wand`](#v2-5-multiple-drivers-wire-wor-and-wand)
- [V2-6) `reg`: Storage Variable, Not Automatically A Flip-Flop](#v2-6-reg-storage-variable-not-automatically-a-flip-flop)
- [V2-7) `integer`, `real`, And `time`](#v2-7-integer-real-and-time)
- [V2-8) Vectors And Indexing](#v2-8-vectors-and-indexing)
- [V2-9) Bit Select, Part Select, And Vector Slicing](#v2-9-bit-select-part-select-and-vector-slicing)
- [V2-10) Width Mismatch Interview Traps](#v2-10-width-mismatch-interview-traps)
- [V2-11) Video 2 Points To Remember](#v2-11-video-2-points-to-remember)
- [V2-12) Video 2 Quiz](#v2-12-video-2-quiz)
- [Video 3 Timestamp Index](#video-3-timestamp-index)
- [V3-1) Why Port Connection Rules Matter](#v3-1-why-port-connection-rules-matter)
- [V3-2) Testbench, DUT, Stimulus, And Response](#v3-2-testbench-dut-stimulus-and-response)
- [V3-3) Data Type Rules For Ports](#v3-3-data-type-rules-for-ports)
- [V3-4) Outside Signals That Connect To Ports](#v3-4-outside-signals-that-connect-to-ports)
- [V3-5) Connect By Name](#v3-5-connect-by-name)
- [V3-6) Connect By Order](#v3-6-connect-by-order)
- [V3-7) Full Adder Using Two Half Adders](#v3-7-full-adder-using-two-half-adders)
- [V3-8) Width Mismatch During Port Connection](#v3-8-width-mismatch-during-port-connection)
- [V3-9) Empty And Unconnected Ports](#v3-9-empty-and-unconnected-ports)
- [V3-10) Video 3 Points To Remember](#v3-10-video-3-points-to-remember)
- [V3-11) Video 3 Quiz](#v3-11-video-3-quiz)
- [Deep Revision Addendum](#deep-revision-addendum)
- [D1) The Real Hardware Meaning Of Verilog Objects](#d1-the-real-hardware-meaning-of-verilog-objects)
- [D2) Continuous Assignment vs Procedural Assignment](#d2-continuous-assignment-vs-procedural-assignment)
- [D3) Expression Width, Extension, Truncation, And Signedness](#d3-expression-width-extension-truncation-and-signedness)
- [D4) How To Debug `x` And `z` In Simulation](#d4-how-to-debug-x-and-z-in-simulation)
- [D5) Synthesizable Templates You Should Memorize](#d5-synthesizable-templates-you-should-memorize)
- [D6) Interview-Style Mental Models](#d6-interview-style-mental-models)
- [Practice Snippets](#practice-snippets)
- [Source Notes](#source-notes)

## Course Video Index

| Video | Title | Duration | Main Revision Topics |
| --- | --- | --- | --- |
| 1 | [Modules, Number Representations & Comments](https://www.youtube.com/watch?v=IP_8QJ5k2I8) | 40:36 | HDL mindset, EDA tools, modules, ports, identifiers, abstraction levels, number literals, strings, comments. |
| 2 | [Verilog Data Types Explained](https://www.youtube.com/watch?v=R57WWiEqkLQ) | 49:05 | `net`, `wire`, `wor`, `wand`, `reg`, `integer`, `real`, `time`, vectors, slicing, width mismatch. |
| 3 | [Port Connection Rules in Verilog](https://www.youtube.com/watch?v=C219U48xX04) | 46:45 | Testbench/DUT connections, port data type rules, connect by name, connect by order, instantiation, width mismatch, empty ports. |

## Video 1 Timestamp Index

| No. | Topic | Timestamp Link | Revision Purpose |
| --- | --- | --- | --- |
| 1 | Course approach: beginner friendly, 40% theory and 60% coding | [00:00](https://www.youtube.com/watch?v=IP_8QJ5k2I8&t=0s) | Understand the course direction. |
| 2 | Tools: Vivado, Quartus, ModelSim/Questa, EDA Playground | [02:00](https://www.youtube.com/watch?v=IP_8QJ5k2I8&t=120s) | Know where Verilog code can be written and simulated. |
| 3 | HDL definition | [06:00](https://www.youtube.com/watch?v=IP_8QJ5k2I8&t=360s) | HDL describes hardware structure and behavior. |
| 4 | HLS idea: C/C++/Python to RTL through tools | [07:20](https://www.youtube.com/watch?v=IP_8QJ5k2I8&t=440s) | Separate direct HDL coding from high-level synthesis. |
| 5 | Verilog vs VHDL | [08:00](https://www.youtube.com/watch?v=IP_8QJ5k2I8&t=480s) | Know both are HDLs with different syntax strictness. |
| 6 | EDA tools and gate-level netlist | [09:20](https://www.youtube.com/watch?v=IP_8QJ5k2I8&t=560s) | Your HDL is processed by tools into lower-level hardware. |
| 7 | Synthesizable vs non-synthesizable constructs | [11:40](https://www.youtube.com/watch?v=IP_8QJ5k2I8&t=700s) | Know which code can become hardware. |
| 8 | `module` and `endmodule` keywords | [13:10](https://www.youtube.com/watch?v=IP_8QJ5k2I8&t=790s) | Every Verilog design block is written as a module. |
| 9 | Port list and module name | [14:00](https://www.youtube.com/watch?v=IP_8QJ5k2I8&t=840s) | Understand module interface. |
| 10 | Port directions: `input`, `output`, `inout` | [15:20](https://www.youtube.com/watch?v=IP_8QJ5k2I8&t=920s) | Compiler needs to know signal direction. |
| 11 | Port declaration styles and semicolon mistakes | [18:00](https://www.youtube.com/watch?v=IP_8QJ5k2I8&t=1080s) | Avoid common beginner syntax bugs. |
| 12 | Identifier rules | [19:40](https://www.youtube.com/watch?v=IP_8QJ5k2I8&t=1180s) | Legal module and signal names. |
| 13 | Abstraction levels: gate, dataflow, behavioral, switch | [22:00](https://www.youtube.com/watch?v=IP_8QJ5k2I8&t=1320s) | Know the major coding styles. |
| 14 | Number literal syntax: `size'basevalue` | [27:00](https://www.youtube.com/watch?v=IP_8QJ5k2I8&t=1620s) | Most important syntax in Video 1. |
| 15 | Oversized and undersized literals | [30:20](https://www.youtube.com/watch?v=IP_8QJ5k2I8&t=1820s) | Larger size zero-extends; smaller size truncates MSBs. |
| 16 | Default size/base when omitted | [35:00](https://www.youtube.com/watch?v=IP_8QJ5k2I8&t=2100s) | Do not rely blindly on unsized constants. |
| 17 | Strings | [37:20](https://www.youtube.com/watch?v=IP_8QJ5k2I8&t=2240s) | Each character takes 8 bits. |
| 18 | Next topics | [39:00](https://www.youtube.com/watch?v=IP_8QJ5k2I8&t=2340s) | Data types, port connections, gate-level designs. |

## V1-1) HDL And Verilog Mindset

HDL means Hardware Description Language. Verilog is not just a software language that runs one line after another on a CPU. It describes hardware that will exist as gates, muxes, flip-flops, memories, wires, and module connections.

The most important mental shift:

```text
Software mindset:
    statement 1 executes
    then statement 2 executes
    then statement 3 executes

Hardware mindset:
    logic block 1 exists
    logic block 2 exists
    logic block 3 exists
    all can respond at the same time
```

Example:

```verilog
assign y = a & b;
assign z = c | d;
```

These two assignments describe two pieces of combinational hardware. They are not a normal C-like ordered algorithm.

The lecture also mentions HLS, or High-Level Synthesis. In HLS, a tool can convert C/C++/Python-like descriptions into RTL. That is a separate flow. For this course, learn direct Verilog RTL first, because it teaches you the real hardware meaning behind the code.

## V1-2) EDA Tools And Synthesis Flow

EDA means Electronic Design Automation. EDA tools help you write, simulate, synthesize, implement, and verify digital hardware.

| Tool | Typical Use |
| --- | --- |
| Vivado | Xilinx/AMD FPGA simulation, synthesis, implementation, bitstream generation. |
| Quartus Prime | Intel/Altera FPGA flow. |
| ModelSim / Questa | HDL simulation. |
| EDA Playground | Browser-based HDL practice. |
| Cadence / Synopsys tools | Common ASIC design and verification flows. |

Useful flow:

```text
Verilog source
-> compile / elaborate
-> simulate behavior
-> synthesize RTL
-> gate-level netlist or FPGA resource mapping
-> implementation
-> bitstream for FPGA or downstream ASIC flow
```

A gate-level netlist is a lower-level circuit representation. If you write:

```verilog
assign y = (a & b) | c;
```

the synthesis idea is:

```text
a, b -> AND logic
AND result, c -> OR logic
OR output -> y
```

In an FPGA, the tool may map this into a LUT instead of literal separate gates. The concept is still the same: RTL becomes hardware.

## V1-3) Synthesizable vs Non-Synthesizable Code

Synthesizable code can become hardware.

Examples:

```verilog
assign y = a & b;
```

```verilog
always @(*) begin
    y = sel ? b : a;
end
```

```verilog
always @(posedge clk) begin
    q <= d;
end
```

These can map to combinational gates, muxes, and flip-flops.

Non-synthesizable code is useful in simulation/testbenches but normally cannot become hardware:

```verilog
#10 a = 1'b1;
$display("a=%b", a);
```

Practical rule:

```text
Design module: use synthesizable RTL.
Testbench: can use delays, displays, file I/O, randomization, and other simulation helpers.
```

Interview trap: a design file and a testbench file can both be written in Verilog, but only the design file is expected to synthesize into hardware.

## V1-4) Module Structure

Every Verilog design unit is a module.

General structure:

```verilog
module module_name (port_list);
    // declarations
    // logic
endmodule
```

Rules:

- `module` and `endmodule` are keywords.
- The module name is an identifier.
- The module header ends with a semicolon.
- `endmodule` has no semicolon.
- All design logic for that block goes between `module` and `endmodule`.

Old-style port declaration:

```verilog
module and_gate(a, b, y);
    input a;
    input b;
    output y;

    assign y = a & b;
endmodule
```

ANSI-style declaration:

```verilog
module and_gate(
    input wire a,
    input wire b,
    output wire y
);
    assign y = a & b;
endmodule
```

Modern RTL usually prefers ANSI-style because the direction and type are visible immediately in the port list.

Common mistake:

```verilog
module bad(input a; input b; output y);
```

Use commas inside the port list, not semicolons.

Correct:

```verilog
module good(
    input a,
    input b,
    output y
);
```

## V1-5) Ports And Identifiers

Ports are signals visible at the module boundary.

| Keyword | Meaning |
| --- | --- |
| `input` | Signal enters the module. |
| `output` | Signal leaves the module. |
| `inout` | Bidirectional signal. Use carefully. |

Example:

```verilog
module simple_logic(
    input wire a,
    input wire b,
    input wire c,
    output wire y
);
    wire n1;

    assign n1 = a & b;
    assign y = n1 | c;
endmodule
```

Here `a`, `b`, `c`, and `y` are ports. `n1` is internal. Another module can connect to the ports, but it cannot directly access `n1` unless you expose it.

Identifier rules:

| Name | Valid? | Reason |
| --- | --- | --- |
| `full_adder` | Yes | Good identifier. |
| `full_adder1` | Yes | Number is allowed after first character. |
| `_stage0` | Yes | Underscore is allowed. |
| `1full_adder` | No | Starts with number. |
| `full adder` | No | Contains space. |
| `full-adder` | No | `-` is an operator. |
| `module` | No | Keyword. |
| `wire` | No | Keyword. |

Verilog is case-sensitive:

```verilog
data
Data
DATA
```

These are three different identifiers.

## V1-6) Abstraction Levels

The lecture lists four modeling levels:

1. Gate-level modeling
2. Dataflow modeling
3. Behavioral modeling
4. Switch-level modeling

### Gate-Level Modeling

You instantiate gates directly:

```verilog
module and_gate_primitive(
    input wire a,
    input wire b,
    output wire y
);
    and g1(y, a, b);
endmodule
```

This is useful when learning gate structures, half adders, full adders, and ripple adders.

### Dataflow Modeling

You describe Boolean/data equations:

```verilog
module and_gate_dataflow(
    input wire a,
    input wire b,
    output wire y
);
    assign y = a & b;
endmodule
```

This is compact and common for combinational logic.

### Behavioral Modeling

You describe what the circuit should do:

```verilog
module mux2_behavioral(
    input wire a,
    input wire b,
    input wire sel,
    output reg y
);
    always @(*) begin
        if (sel)
            y = b;
        else
            y = a;
    end
endmodule
```

Behavioral code can still synthesize, as long as the constructs are synthesizable.

### Switch-Level Modeling

Switch-level modeling describes behavior closer to MOS switches/transistors. It is not normally used in beginner RTL.

## V1-7) Number Representation

Standard literal format:

```verilog
<size>'<base><value>
```

Read it as:

```text
size tick base value
```

Examples:

| Literal | Meaning |
| --- | --- |
| `4'b1010` | 4-bit binary value `1010`. |
| `6'o73` | 6-bit octal value `73`, equal to binary `111011`. |
| `8'd15` | 8-bit decimal value 15. |
| `8'hff` | 8-bit hex value `ff`, equal to binary `11111111`. |

Base letters:

| Base | Meaning |
| --- | --- |
| `b` | Binary |
| `o` | Octal |
| `d` | Decimal |
| `h` | Hexadecimal |

### Bigger Size Than Needed

```verilog
8'o73
```

Octal `73` is binary `111011`, which needs 6 bits. With size 8:

```text
8'o73 = 8'b00111011
```

Zeros are added on the MSB side.

### Smaller Size Than Needed

```verilog
2'o73
```

Full value:

```text
73 octal = 111011
```

Only 2 bits requested:

```text
2'o73 = 2'b11
```

This may compile with a warning, but it is a real design bug if you expected the full value.

### Unsized Numbers

```verilog
16
```

This is an unsized decimal constant. Beginner-safe rule: do not rely on the default width. Write the width explicitly when assigning to hardware signals:

```verilog
5'd16
8'd16
32'd16
```

Pick the width that matches the destination and the actual numeric range.

## V1-8) Strings And Comments

A string is a collection of characters inside double quotes:

```verilog
"HELLO"
```

Each character takes 8 bits:

```text
"A"     = 8 bits
"AB"    = 16 bits
"HELLO" = 40 bits
```

Spaces count as characters.

The video title mentions comments, but the accessible transcript did not contain a separate comments section. For revision, know both styles:

```verilog
// single-line comment
```

```verilog
/*
multi-line comment
*/
```

Good comments explain intent:

```verilog
assign carry = a & b; // carry is 1 only when both half-adder inputs are 1
```

Bad comments repeat syntax:

```verilog
assign carry = a & b; // assign carry
```

## V1-9) Video 1 Quiz

1. What does HDL stand for?
2. Why is Verilog not exactly like C?
3. What is an EDA tool?
4. What is the difference between design code and testbench code?
5. What keyword closes a module?
6. Why is `1mux` not a legal identifier?
7. What does `6'o73` equal in binary?
8. What happens to `2'o73`?
9. What is the default base of the literal `25`?
10. How many bits are needed for `"ABCD"`?

Answers:

1. Hardware Description Language.
2. Verilog describes hardware that can operate concurrently.
3. Electronic Design Automation tool.
4. Design code should synthesize into hardware; testbench code is for simulation stimulus/checking.
5. `endmodule`.
6. It starts with a number.
7. `6'b111011`.
8. It truncates to `2'b11`.
9. Decimal.
10. 32 bits.

## Video 2 Timestamp Index

| No. | Topic | Timestamp Link | Revision Purpose |
| --- | --- | --- | --- |
| 1 | Recap of Video 1 and start of data types | [00:00](https://www.youtube.com/watch?v=R57WWiEqkLQ&t=0s) | Connect modules/numbers to data type discussion. |
| 2 | What data type means | [00:55](https://www.youtube.com/watch?v=R57WWiEqkLQ&t=55s) | A data type says what kind of value a variable/signal can hold or drive. |
| 3 | Net data type intro | [02:30](https://www.youtube.com/watch?v=R57WWiEqkLQ&t=150s) | Nets connect modules and carry driven values. |
| 4 | Net as bridge between driver and receiver | [03:20](https://www.youtube.com/watch?v=R57WWiEqkLQ&t=200s) | Understand source, net, and receiver. |
| 5 | Net classifications: `wire`, `wand`, `wor` | [05:40](https://www.youtube.com/watch?v=R57WWiEqkLQ&t=340s) | Know common net types. |
| 6 | Declaring `wire` and using `assign` | [06:15](https://www.youtube.com/watch?v=R57WWiEqkLQ&t=375s) | `assign` continuously drives a net. |
| 7 | Default wire width | [08:00](https://www.youtube.com/watch?v=R57WWiEqkLQ&t=480s) | Plain `wire w;` is 1 bit. |
| 8 | Width mismatch: RHS wider than 1-bit wire | [09:15](https://www.youtube.com/watch?v=R57WWiEqkLQ&t=555s) | LSB survives, upper bits are discarded. |
| 9 | Default wire value and high impedance | [11:20](https://www.youtube.com/watch?v=R57WWiEqkLQ&t=680s) | Undriven wire is `z`. |
| 10 | Four Verilog values: `0`, `1`, `x`, `z` | [12:10](https://www.youtube.com/watch?v=R57WWiEqkLQ&t=730s) | Simulation values and debugging meaning. |
| 11 | `assign w = -1` on 1-bit wire | [14:00](https://www.youtube.com/watch?v=R57WWiEqkLQ&t=840s) | Unsized decimal, 32-bit result, then truncation. |
| 12 | Verilog concurrency and multiple continuous assigns | [19:30](https://www.youtube.com/watch?v=R57WWiEqkLQ&t=1170s) | Verilog statements describe parallel hardware. |
| 13 | Multiple drivers on `wire` produce `x` for conflict | [21:00](https://www.youtube.com/watch?v=R57WWiEqkLQ&t=1260s) | Driving 0 and 1 together creates unknown. |
| 14 | `wor`: wired-OR net | [22:50](https://www.youtube.com/watch?v=R57WWiEqkLQ&t=1370s) | Multiple drivers combine by OR. |
| 15 | `wand`: wired-AND net | [24:30](https://www.youtube.com/watch?v=R57WWiEqkLQ&t=1470s) | Multiple drivers combine by AND. |
| 16 | `reg` data type | [26:00](https://www.youtube.com/watch?v=R57WWiEqkLQ&t=1560s) | Procedural storage variable. |
| 17 | `reg` default width/value and signedness | [27:00](https://www.youtube.com/watch?v=R57WWiEqkLQ&t=1620s) | Plain `reg` is 1 bit, default `x`, unsigned unless signed. |
| 18 | `integer` data type | [29:25](https://www.youtube.com/watch?v=R57WWiEqkLQ&t=1765s) | 32-bit signed variable, useful for counters/loops. |
| 19 | Decimal truncation in integer vs real | [31:00](https://www.youtube.com/watch?v=R57WWiEqkLQ&t=1860s) | Integer cannot store fractional values. |
| 20 | `real` data type | [31:35](https://www.youtube.com/watch?v=R57WWiEqkLQ&t=1895s) | 64-bit real number, simulation-oriented, non-synthesizable. |
| 21 | Vectors syntax | [33:20](https://www.youtube.com/watch?v=R57WWiEqkLQ&t=2000s) | Packed multi-bit `wire` or `reg`. |
| 22 | `[2:0]` vs `[0:2]` indexing | [34:30](https://www.youtube.com/watch?v=R57WWiEqkLQ&t=2070s) | Index direction changes bit numbering, not the literal bit order. |
| 23 | Non-zero ranges such as `[5:3]` | [38:00](https://www.youtube.com/watch?v=R57WWiEqkLQ&t=2280s) | Legal but confusing, avoid unless needed. |
| 24 | Underscores in number literals | [39:00](https://www.youtube.com/watch?v=R57WWiEqkLQ&t=2340s) | Use for readability, ignored by compiler. |
| 25 | Bit select and part select | [40:00](https://www.youtube.com/watch?v=R57WWiEqkLQ&t=2400s) | Extract one bit or a range of bits. |
| 26 | Vectors only with `wire`/`reg` style packed objects | [42:00](https://www.youtube.com/watch?v=R57WWiEqkLQ&t=2520s) | Do not write ranged `integer`. |
| 27 | Width mismatch examples and addition trap | [43:30](https://www.youtube.com/watch?v=R57WWiEqkLQ&t=2610s) | Freshers often lose upper bits accidentally. |
| 28 | Final warning: be careful with widths | [48:00](https://www.youtube.com/watch?v=R57WWiEqkLQ&t=2880s) | Explicit widths prevent silent bugs. |

## V2-1) What A Data Type Means In Verilog

In normal programming, a data type tells the compiler what kind of value a variable can store: integer, float, character, string, and so on.

In Verilog, a data type also has a hardware meaning:

```text
Does this object represent a connection?
Does it hold a procedural value?
How many bits wide is it?
Can it represent unknown/high-impedance values?
Is it signed or unsigned?
Can synthesis turn it into hardware?
```

The main Video 2 data types:

| Type | Core Meaning |
| --- | --- |
| `wire` / net | A driven connection. It does not procedurally store a value. |
| `wor` | Wired-OR net. Multiple drivers combine with OR. |
| `wand` | Wired-AND net. Multiple drivers combine with AND. |
| `reg` | Procedural variable. It holds the last assigned procedural value in simulation. |
| `integer` | 32-bit signed procedural variable. |
| `real` | Real-number simulation variable, generally non-synthesizable. |
| `time` | Simulation time variable, generally non-synthesizable. |

Do not memorize this like C data types. In Verilog, the key question is:

```text
Am I describing a physical connection, a combinational result, a register/flip-flop, or a simulation-only helper?
```

## V2-2) Net Data Type: Connection, Not Storage

A net represents a connection between drivers and receivers.

Think of a net like a wire on a schematic:

```text
driver/source -> net -> receiver/load
```

If module A drives a signal into module B:

```text
Module A output -> wire/net -> Module B input
```

The net is the bridge. It does not "store" the value the way a software variable stores a value. It carries whatever value is being driven onto it.

Important language:

| Term | Meaning |
| --- | --- |
| Driver/source | The thing that forces a value onto the net. |
| Receiver/load | The thing that reads the net value. |
| Net | The connection carrying the driven value. |

Example:

```verilog
module top;
    wire w;

    assign w = 1'b1;
endmodule
```

`w` is not assigned once and then stored. The continuous assignment continuously drives `1` onto `w`.

That is why this is called a continuous assignment:

```verilog
assign w = expression;
```

If the expression changes, the net updates automatically.

## V2-3) `wire`: Continuous Driving And Width Traps

Basic declaration:

```verilog
wire w;
```

Default width:

```text
wire w; means a 1-bit wire
```

Continuous assignment:

```verilog
assign w = a;
```

The right-hand side drives the left-hand side continuously.

### Why `assign` Matters

For a net like `wire`, you normally drive it using:

```verilog
assign w = value;
```

In pure Verilog, a continuous assignment left-hand side is a net. A procedural assignment inside an `always`/`initial` block assigns to a variable such as `reg`.

Compare:

```verilog
wire y;
assign y = a & b;
```

versus:

```verilog
reg y;
always @(*) begin
    y = a & b;
end
```

Both can describe combinational logic, but the coding mechanism is different.

### Width Trap: RHS Wider Than LHS

Example from the lecture idea:

```verilog
wire w;
assign w = 3'b001;
```

`w` is only 1 bit wide. RHS is 3 bits wide.

Verilog keeps the least significant bit:

```text
3'b001 -> lower 1 bit is 1
w = 1'b1
```

No hard compile error is required. Many tools warn, but the language permits truncation.

Another example:

```verilog
wire w;
assign w = 3'b100;
```

Only the LSB survives:

```text
3'b100 -> lower 1 bit is 0
w = 1'b0
```

This is why explicit vector widths matter.

Better:

```verilog
wire [2:0] w;
assign w = 3'b001;
```

Now LHS and RHS are both 3 bits.

## V2-4) Four-State Logic: `0`, `1`, `x`, `z`

Verilog simulation uses four main logic values:

| Value | Name | Meaning |
| --- | --- | --- |
| `0` | Logic zero | False / low. |
| `1` | Logic one | True / high. |
| `x` | Unknown | Simulator cannot determine 0 or 1. |
| `z` | High impedance | Undriven, disconnected, tri-stated. |

### Default `wire` Value

If a wire is declared but not driven:

```verilog
wire w;
```

then `w` is high impedance:

```text
w = z
```

This makes sense because a net is a connection. If nothing drives the connection, it is floating/undriven.

When you see `z` in simulation, ask:

```text
Did I forget to connect this signal?
Did I leave a port open?
Did a tri-state driver disable itself?
```

### Default `reg` Value

If a `reg` is declared but never initialized:

```verilog
reg a;
```

then it starts as unknown:

```text
a = x
```

This is very useful in simulation. It warns you that the design has no known reset/initial assignment path yet.

### Difference Between `x` And `z`

| Value | Debug Meaning |
| --- | --- |
| `x` | Something is unknown, uninitialized, conflicting, or not determinable. |
| `z` | Something is not being driven. |

In real hardware, unknown does not physically exist as a stable logic level. It is a simulator value that says "this could be 0 or 1, and I cannot safely choose."

## V2-5) Multiple Drivers: `wire`, `wor`, And `wand`

Verilog is concurrent. These two continuous assignments happen in parallel:

```verilog
wire w;
assign w = 1'b0;
assign w = 1'b1;
```

You are trying to drive the same net with both 0 and 1. That is a conflict.

For a normal `wire`, simulation resolves this as unknown:

```text
w = x
```

Reason:

```text
one driver says 0
another driver says 1
simulator cannot choose a valid digital value
```

### Simple Wire Resolution Intuition

| Driver A | Driver B | Normal `wire` Result |
| --- | --- | --- |
| `z` | `z` | `z` |
| `0` | `z` | `0` |
| `1` | `z` | `1` |
| `0` | `0` | `0` |
| `1` | `1` | `1` |
| `0` | `1` | `x` |

### `wor`: Wired OR

`wor` means wired-OR net.

```verilog
wor w;
assign w = 1'b0;
assign w = 1'b1;
```

The drivers are ORed:

```text
0 OR 1 = 1
```

So:

```text
w = 1
```

### `wand`: Wired AND

`wand` means wired-AND net.

```verilog
wand w;
assign w = 1'b0;
assign w = 1'b1;
```

The drivers are ANDed:

```text
0 AND 1 = 0
```

So:

```text
w = 0
```

### Practical Advice

Most beginner RTL should avoid multiple drivers. Use a mux, priority logic, or a single `always @(*)`/`assign` expression instead.

Bad beginner pattern:

```verilog
assign y = source_a;
assign y = source_b;
```

Better:

```verilog
assign y = sel ? source_b : source_a;
```

or:

```verilog
always @(*) begin
    if (sel)
        y = source_b;
    else
        y = source_a;
end
```

`wor` and `wand` are real Verilog features, but they are not how most modern clean RTL is written.

## V2-6) `reg`: Storage Variable, Not Automatically A Flip-Flop

The lecture introduces `reg` as a data type used to store data.

Basic declaration:

```verilog
reg a;
```

Default width:

```text
1 bit
```

Default simulation value:

```text
x
```

Plain `reg` is unsigned unless declared signed:

```verilog
reg signed [7:0] s;
```

### Critical Clarification

`reg` does not automatically mean "hardware register" or "flip-flop."

It means a procedural variable assigned inside procedural code:

```verilog
always @(*) begin
    y = a & b;
end
```

If `y` is declared as `reg`, the synthesized hardware can still be only combinational logic.

Flip-flop style:

```verilog
always @(posedge clk) begin
    q <= d;
end
```

Here `q` becomes a flip-flop because it is assigned on a clock edge, not because the type name is `reg`.

### Combinational `reg`

```verilog
module mux2(
    input wire a,
    input wire b,
    input wire sel,
    output reg y
);
    always @(*) begin
        if (sel)
            y = b;
        else
            y = a;
    end
endmodule
```

`y` is a `reg` because procedural assignment requires it in Verilog. The hardware is a mux, not a flip-flop.

### Sequential `reg`

```verilog
module dff(
    input wire clk,
    input wire d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule
```

Here `q` is a flip-flop because assignment happens on `posedge clk`.

Interview line:

```text
reg is a Verilog procedural variable. It synthesizes to a flip-flop only when the procedural behavior requires memory, such as edge-triggered assignment.
```

## V2-7) `integer`, `real`, And `time`

### `integer`

Declaration:

```verilog
integer i;
```

Typical properties:

```text
size: 32 bits
signed: yes
default simulation value: x
```

Useful for:

- loop indices
- counters in testbenches
- simple signed integer calculations
- sometimes synthesizable loop variables when the synthesis tool can unroll/resolve the loop

Example:

```verilog
integer i;

initial begin
    for (i = 0; i < 8; i = i + 1)
        $display("i=%0d", i);
end
```

Important: integer is not for fractional values.

```verilog
integer m;
initial begin
    m = 3.14;
end
```

The fractional part is not preserved as a true real value. Use `real` for simulation-only decimal/fractional values.

### `real`

Declaration:

```verilog
real r;
```

Example:

```verilog
initial begin
    r = 3.14;
    $display("%f", r);
end
```

`real` is for simulation modeling. Treat it as non-synthesizable for normal RTL.

Do not write synthesizable datapath RTL expecting FPGA/ASIC hardware to implement arbitrary `real` arithmetic from a plain `real` variable. Hardware fixed-point/floating-point design must be done explicitly with proper bit widths or dedicated IP.

### `time`

The video title mentions `time`; the transcript does not deeply cover it in this session. For revision:

```verilog
time t;
```

`time` is used to store simulation time values.

Example:

```verilog
initial begin
    #10;
    t = $time;
    $display("time=%0t", t);
end
```

Use it in testbenches and simulation checks. Treat it as non-synthesizable for normal hardware design.

## V2-8) Vectors And Indexing

A vector is a multi-bit signal.

Syntax:

```verilog
data_type [range] identifier;
```

Common examples:

```verilog
wire [3:0] nibble;
reg  [7:0] byte_data;
reg  [31:0] word_data;
```

`[3:0]` means:

```text
4 bits total
MSB index = 3
LSB index = 0
```

Visual:

```text
bit index:  3 2 1 0
value:      b3 b2 b1 b0
```

### Standard Style

Use:

```verilog
reg [2:0] a;
```

This is conventional:

```text
a[2] = MSB
a[0] = LSB
```

### Reverse Range

Verilog also allows:

```verilog
reg [0:2] a;
```

Now:

```text
a[0] = leftmost/MSB side
a[2] = rightmost/LSB side
```

This is legal but often confusing. For beginner RTL and interview code, prefer `[MSB:LSB]`, such as `[2:0]`, `[7:0]`, `[31:0]`.

### Non-Zero Ranges

This is also legal:

```verilog
reg [5:3] a;
```

It has 3 bits:

```text
indices: 5, 4, 3
```

But it is rarely worth the confusion. Prefer zero-based packed vectors unless there is a strong reason.

### Underscores In Literals

Underscores improve readability and are ignored by the compiler:

```verilog
reg [5:0] a;
initial a = 6'b111_011;
```

Same as:

```verilog
initial a = 6'b111011;
```

Good for grouping:

```verilog
32'b1010_1100_0011_0101_1111_0000_0001_1001
```

## V2-9) Bit Select, Part Select, And Vector Slicing

Assume:

```verilog
reg [5:0] a;
reg b;
reg [2:0] c;

initial begin
    a = 6'b111_011;
end
```

Index map:

```text
a[5] a[4] a[3] a[2] a[1] a[0]
 1    1    1    0    1    1
```

### Bit Select

One bit:

```verilog
b = a[0];
```

Result:

```text
b = 1
```

Another:

```verilog
b = a[2];
```

Result:

```text
b = 0
```

### Part Select

Multiple bits:

```verilog
c = a[5:3];
```

Result:

```text
a[5:3] = 111
c = 3'b111
```

Another:

```verilog
c = a[2:0];
```

Result:

```text
a[2:0] = 011
c = 3'b011
```

This is called slicing or part-selecting a vector.

### Why Slicing Matters

Slicing is used constantly in real RTL:

```verilog
opcode = instruction[31:26];
rs     = instruction[25:21];
rt     = instruction[20:16];
imm    = instruction[15:0];
```

It lets you extract fields from a packed bus.

## V2-10) Width Mismatch Interview Traps

This video spends a lot of time warning about width mismatch. That warning is correct.

Verilog often does not stop you when widths differ. It truncates or extends according to expression sizing rules.

### Trap 1: 1-Bit `reg` Assigned Multi-Bit Value

```verilog
reg a;

initial begin
    a = 7;
end
```

`a` is 1 bit. `7` is unsized decimal, typically at least 32 bits:

```text
7 decimal = ...00000111
```

Only the LSB is stored:

```text
a = 1
```

### Trap 2: 2-Bit `reg` Assigned 7

```verilog
reg [1:0] a;

initial begin
    a = 7;
end
```

Binary 7:

```text
111
```

Only lower 2 bits fit:

```text
a = 2'b11
```

As decimal, that is 3, not 7.

### Trap 3: Addition With Accidentally 1-Bit Variables

This is the lecture's freshers' mistake:

```verilog
reg a;
reg b;
reg c;

initial begin
    a = 3;
    b = 4;
    c = a + b;
end
```

A beginner expects:

```text
3 + 4 = 7
```

But each variable is only 1 bit.

Assignment:

```text
a = 3 -> binary ...0011 -> lower 1 bit = 1
b = 4 -> binary ...0100 -> lower 1 bit = 0
```

Then:

```text
c = a + b = 1 + 0 = 1
```

So `c` becomes 1, not 7.

Correct:

```verilog
reg [2:0] a;
reg [2:0] b;
reg [3:0] c;

initial begin
    a = 3'd3;
    b = 3'd4;
    c = a + b;
end
```

Now:

```text
a = 3
b = 4
c = 7
```

Why `c` is 4 bits: adding two 3-bit values can require 4 bits for carry.

### Trap 4: `assign w = -1` With 1-Bit Wire

```verilog
wire w;
assign w = -1;
```

`-1` as an unsized integer-style value is represented using two's complement. In a typical 32-bit context:

```text
-1 = 32'hffff_ffff = all ones
```

`w` is 1 bit, so only the LSB remains:

```text
w = 1'b1
```

Do not say "`wire` stores -1." A plain 1-bit `wire` cannot represent signed -1 as a numeric signed value. It just receives one driven bit.

### Safer Width Habit

When writing RTL:

```verilog
reg [7:0] a;
reg [7:0] b;
reg [8:0] sum;

always @(*) begin
    sum = {1'b0, a} + {1'b0, b};
end
```

This makes the carry bit explicit.

Bad habit:

```verilog
reg a, b, sum;
sum = a + b;
```

That is only 1-bit arithmetic.

## V2-11) Video 2 Points To Remember

- `wire` is a net. It is for connection and continuous driving.
- Plain `wire w;` is 1 bit.
- An undriven `wire` reads as `z`.
- `assign` creates a continuous driver.
- Normal `wire` with conflicting 0 and 1 drivers becomes `x`.
- `wor` combines multiple drivers by OR.
- `wand` combines multiple drivers by AND.
- `reg` is a procedural variable, not automatically a flip-flop.
- Plain `reg a;` is 1 bit and starts as `x`.
- A `reg` becomes flop-like when assigned in clocked edge-triggered procedural logic.
- `integer` is typically 32-bit signed and useful for loops/counters.
- `real` is simulation-oriented and not normal synthesizable RTL.
- `time` stores simulation time and is testbench-oriented.
- Vectors are declared like `[MSB:LSB]`.
- Prefer `[7:0]`, `[31:0]`, etc. over confusing non-zero/reversed ranges.
- Bit select extracts one bit: `a[3]`.
- Part select extracts a range: `a[7:4]`.
- If RHS is wider than LHS, upper bits can be silently lost.
- Always size your signals and constants intentionally.

## V2-12) Video 2 Quiz

### Questions

1. What is the main difference between a net and a `reg`?
2. What is the default width of `wire w;`?
3. What is the default value of an undriven `wire`?
4. What is the default simulation value of an uninitialized `reg`?
5. What happens if two continuous assignments drive a normal `wire` with 0 and 1?
6. What does `wor` do with multiple drivers?
7. What does `wand` do with multiple drivers?
8. Does `reg` always synthesize to a flip-flop?
9. What is the usual size and signedness of `integer`?
10. Is `real` normally synthesizable?
11. In `reg [5:0] a`, what is the MSB index?
12. If `a = 6'b111_011`, what is `a[2:0]`?
13. If `reg [1:0] x; x = 7;`, what binary value is stored in `x`?
14. If `reg a; a = 4;`, what value is stored in `a`?
15. Why is `reg a; reg b; reg c; c = a + b;` dangerous for arithmetic?

### Answers

1. A net represents a driven connection; a `reg` is a procedural variable that holds the last assigned procedural value in simulation.
2. 1 bit.
3. `z`.
4. `x`.
5. The resolved value becomes `x` because the drivers conflict.
6. It ORs the driver values.
7. It ANDs the driver values.
8. No. It becomes a flip-flop only if the behavior requires edge-triggered storage.
9. 32-bit signed.
10. No, treat it as simulation-only for normal RTL.
11. 5.
12. `3'b011`.
13. `2'b11`.
14. `1'b0`, because decimal 4 is binary `100`, and only the LSB fits.
15. All variables are 1 bit, so multi-bit arithmetic is lost before or during the addition.

## Video 3 Timestamp Index

| No. | Topic | Timestamp Link | Revision Purpose |
| --- | --- | --- | --- |
| 1 | Recap of modules, data types, vectors, slicing | [00:00](https://www.youtube.com/watch?v=C219U48xX04&t=0s) | Connect previous lectures to port connection rules. |
| 2 | Start of port connection rules | [01:20](https://www.youtube.com/watch?v=C219U48xX04&t=80s) | Understand why module connections are a major beginner issue. |
| 3 | Testbench and DUT idea | [02:00](https://www.youtube.com/watch?v=C219U48xX04&t=120s) | Testbench drives inputs and checks outputs. |
| 4 | Example stimulus for full adder | [03:00](https://www.youtube.com/watch?v=C219U48xX04&t=180s) | Inputs produce expected sum/carry outputs. |
| 5 | Input port default data type | [04:20](https://www.youtube.com/watch?v=C219U48xX04&t=260s) | Input ports are net type by default in classic Verilog. |
| 6 | Why `input reg` is not accepted in Verilog | [06:00](https://www.youtube.com/watch?v=C219U48xX04&t=360s) | Inputs are driven from outside, so they behave as driven connections. |
| 7 | Output port default data type | [07:15](https://www.youtube.com/watch?v=C219U48xX04&t=435s) | Output defaults to net; can be declared `output reg` if assigned procedurally inside. |
| 8 | Testbench signals driving DUT inputs | [09:00](https://www.youtube.com/watch?v=C219U48xX04&t=540s) | Actual signals connected to input ports may be `reg` or net depending on source. |
| 9 | Testbench signals receiving DUT outputs | [12:30](https://www.youtube.com/watch?v=C219U48xX04&t=750s) | In classic Verilog, output actuals should be nets. |
| 10 | Inout port rule | [15:20](https://www.youtube.com/watch?v=C219U48xX04&t=920s) | `inout` is net on both sides. |
| 11 | Connection by name vs order | [16:00](https://www.youtube.com/watch?v=C219U48xX04&t=960s) | Two ways to instantiate modules. |
| 12 | Full adder using half adders diagram | [17:00](https://www.youtube.com/watch?v=C219U48xX04&t=1020s) | See module-to-module wiring. |
| 13 | How many internal wires are needed | [18:00](https://www.youtube.com/watch?v=C219U48xX04&t=1080s) | Three internal connections: intermediate sum and two carries. |
| 14 | Half adder instance by name | [21:00](https://www.youtube.com/watch?v=C219U48xX04&t=1260s) | `.formal(actual)` syntax. |
| 15 | No order restriction in named connection | [26:20](https://www.youtube.com/watch?v=C219U48xX04&t=1580s) | Named connection is safer for large modules. |
| 16 | Connection by order | [28:00](https://www.youtube.com/watch?v=C219U48xX04&t=1680s) | Actuals connect positionally to the module header order. |
| 17 | Ordered connection mistake example | [30:00](https://www.youtube.com/watch?v=C219U48xX04&t=1800s) | Wrong order silently connects wrong signals. |
| 18 | Multi-module data type exercise | [32:00](https://www.youtube.com/watch?v=C219U48xX04&t=1920s) | Decide which signals must be nets and which can be regs. |
| 19 | Port width mismatch | [37:00](https://www.youtube.com/watch?v=C219U48xX04&t=2220s) | Wider actual to narrower formal connects/truncates lower bits. |
| 20 | Unconnected input ports | [40:00](https://www.youtube.com/watch?v=C219U48xX04&t=2400s) | Inputs should not be left floating in an instance. |
| 21 | Unconnected output ports | [42:00](https://www.youtube.com/watch?v=C219U48xX04&t=2520s) | Outputs can be intentionally left unconnected with empty actuals. |
| 22 | Empty arguments vs missing arguments | [44:00](https://www.youtube.com/watch?v=C219U48xX04&t=2640s) | Empty commas count as arguments; omitted arguments cause errors. |

## V3-1) Why Port Connection Rules Matter

Modules are only useful when they can connect to other modules. A module's internal logic may be correct, but the complete design can still fail if the ports are connected incorrectly.

Port connection rules answer these questions:

```text
1. What data type should a module port have?
2. What data type should the outside signal connected to that port have?
3. How do I instantiate one module inside another?
4. What happens if the port widths do not match?
5. What happens if I leave a port unconnected?
```

This is important because Verilog often accepts legal-but-wrong code. A connection may compile but still connect the wrong signal or silently drop upper bits.

The safest habit:

```text
Use named port connection.
Use clear internal wire names.
Match signal widths intentionally.
Never leave inputs floating.
Leave outputs unconnected only intentionally.
```

## V3-2) Testbench, DUT, Stimulus, And Response

The lecture uses a design inside a testbench to explain connections.

Vocabulary:

| Term | Meaning |
| --- | --- |
| DUT | Design Under Test. This is the module you want to verify. |
| Testbench | A module that drives inputs into the DUT and checks outputs. |
| Stimulus | Input values applied to the DUT. |
| Response | Output values produced by the DUT. |
| Expected value | The result you believe the DUT should produce. |

For a full adder:

```text
inputs:  a, b, cin
outputs: sum, carry
```

If:

```text
a=0, b=1, cin=1
```

then:

```text
0 + 1 + 1 = 2 decimal = binary 10
sum   = 0
carry = 1
```

The testbench drives `a`, `b`, `cin`, then observes `sum` and `carry`. If the observed result matches the expected result, that test case passes.

Basic testbench shape:

```verilog
module full_adder_tb;
    reg a_tb;
    reg b_tb;
    reg cin_tb;
    wire sum_tb;
    wire carry_tb;

    full_adder dut (
        .a(a_tb),
        .b(b_tb),
        .cin(cin_tb),
        .sum(sum_tb),
        .carry(carry_tb)
    );

    initial begin
        a_tb = 1'b0;
        b_tb = 1'b1;
        cin_tb = 1'b1;
        #1;
        $display("sum=%b carry=%b", sum_tb, carry_tb);
    end
endmodule
```

Why inputs are `reg` in the testbench:

```text
The testbench assigns values procedurally inside an initial block.
Classic Verilog procedural assignment needs a reg variable.
```

Why outputs are `wire` in the testbench:

```text
The DUT output continuously drives the testbench observation signal.
So the receiver side should be a net in classic Verilog.
```

## V3-3) Data Type Rules For Ports

Classic Verilog port rules are easier if you separate the inside of the module from the outside connection.

### Input Ports

Example:

```verilog
module design_a(
    input a,
    input b
);
endmodule
```

Inside `design_a`, `a` and `b` are input ports. In classic Verilog, an input port is a net by default.

Beginner-safe rule:

```text
input ports are driven from outside the module, so treat them as nets inside the module.
```

Do not write this in classic Verilog:

```verilog
module bad(
    input reg a
);
endmodule
```

Reason:

```text
The input is not stored by the module. It is driven from the outside.
```

### Output Ports

Output ports can be net-like or variable-like depending on how you drive them inside the module.

Continuous assignment style:

```verilog
module and_gate(
    input wire a,
    input wire b,
    output wire y
);
    assign y = a & b;
endmodule
```

Here `y` is a net because `assign` continuously drives it.

Procedural assignment style:

```verilog
module mux2(
    input wire a,
    input wire b,
    input wire sel,
    output reg y
);
    always @(*) begin
        if (sel)
            y = b;
        else
            y = a;
    end
endmodule
```

Here `y` is `output reg` because it is assigned inside an `always` block.

Important:

```text
output reg does not automatically mean flip-flop.
It only means the output is assigned procedurally.
```

### Inout Ports

`inout` ports are bidirectional. They must behave as nets because either side may drive or release the connection.

Example:

```verilog
module tri_buf(
    input wire en,
    input wire data,
    inout wire bus
);
    assign bus = en ? data : 1'bz;
endmodule
```

Use `inout` carefully. Most beginner RTL designs avoid it except for top-level chip/FPGA pins or tri-state bus examples.

## V3-4) Outside Signals That Connect To Ports

Now look from the parent module or testbench side.

### Connecting To DUT Inputs

The outside signal connected to a DUT input can be:

- `reg`, if the testbench/procedural code drives it
- `wire`, if another module output or continuous assignment drives it

Testbench-driven input:

```verilog
reg a_tb;

initial begin
    a_tb = 1'b0;
    #10 a_tb = 1'b1;
end
```

Module-driven input:

```verilog
wire a_net;

producer u_producer (
    .out(a_net)
);

consumer u_consumer (
    .in(a_net)
);
```

Here `a_net` connects two modules, so it should be a net.

### Connecting To DUT Outputs

In classic Verilog, a child module output should connect to a parent net:

```verilog
wire y_tb;

and_gate dut (
    .a(a_tb),
    .b(b_tb),
    .y(y_tb)
);
```

Do not use a parent `reg` as the driven target of a module output in Verilog-2005 style:

```verilog
reg y_tb;          // not beginner-safe classic Verilog
and_gate dut (..., .y(y_tb));
```

Reason:

```text
The child module output continuously drives the outside signal.
The outside signal must be able to receive a continuous/module driver.
```

### Compact Rule Table

| Port On Child Module | Inside Child Module | Outside Signal In Parent/Testbench |
| --- | --- | --- |
| `input` | net | `reg` if testbench drives it, or net if another module drives it |
| `output` with `assign` | net | net |
| `output reg` with `always` | reg inside child | net outside child |
| `inout` | net | net |

For your current course, memorize this table.

## V3-5) Connect By Name

Connect by name uses this syntax:

```verilog
module_name instance_name (
    .formal_port(actual_signal),
    .formal_port(actual_signal)
);
```

Example:

```verilog
half_adder ha1 (
    .a(a_fa),
    .b(b_fa),
    .sum(w1),
    .carry(w2)
);
```

Meaning:

```text
half_adder port a     connects to a_fa
half_adder port b     connects to b_fa
half_adder port sum   connects to w1
half_adder port carry connects to w2
```

The names before the parentheses are the child module's formal port names. The signals inside the parentheses are the parent module's actual signals.

```text
.a(a_fa)
 ^  ^
 |  parent/full-adder signal
 child/half-adder port
```

### Why Named Connection Is Safer

With named connection, order does not matter:

```verilog
half_adder ha1 (
    .carry(w2),
    .sum(w1),
    .b(b_fa),
    .a(a_fa)
);
```

This still connects correctly because each actual signal is tied to a named formal port.

Best practice:

```text
Use named connection for nearly all real RTL.
```

It is easier to review, safer when modules have many ports, and less likely to break if the module header changes.

## V3-6) Connect By Order

Connect by order uses only actual signals:

```verilog
half_adder ha1 (a_fa, b_fa, w1, w2);
```

This depends entirely on the child module port declaration order.

If the child module is:

```verilog
module half_adder(
    input wire a,
    input wire b,
    output wire sum,
    output wire carry
);
```

then:

```verilog
half_adder ha1 (a_fa, b_fa, w1, w2);
```

means:

```text
a_fa -> a
b_fa -> b
w1   -> sum
w2   -> carry
```

### Ordered Connection Trap

Wrong:

```verilog
half_adder ha1 (b_fa, a_fa, w2, w1);
```

This compiles if widths and directions are compatible, but it connects:

```text
b_fa -> a
a_fa -> b
w2   -> sum
w1   -> carry
```

For a symmetric half adder, swapping `a` and `b` may not change the function, but swapping `sum` and `carry` is a real bug.

For large modules, connect-by-order is dangerous.

Use connect-by-order only when:

- the module has very few ports
- you are doing a quick throwaway test
- the order is obvious and stable

For revision and interviews, prefer connect-by-name.

## V3-7) Full Adder Using Two Half Adders

A full adder can be built from:

- two half adders
- one OR gate

Logic:

```text
First half adder:
    a_fa + b_fa -> intermediate sum w1 and carry w2

Second half adder:
    w1 + cin_fa -> final sum sum_fa and carry w3

OR gate:
    carry_fa = w2 | w3
```

Why three internal wires:

| Wire | Meaning |
| --- | --- |
| `w1` | Sum output of first half adder, input to second half adder. |
| `w2` | Carry output of first half adder, input to OR gate. |
| `w3` | Carry output of second half adder, input to OR gate. |

### Half Adder Module

```verilog
module half_adder(
    input wire a,
    input wire b,
    output wire sum,
    output wire carry
);
    assign sum = a ^ b;
    assign carry = a & b;
endmodule
```

### Full Adder With Named Connection

```verilog
module full_adder(
    input wire a_fa,
    input wire b_fa,
    input wire cin_fa,
    output wire sum_fa,
    output wire carry_fa
);
    wire w1;
    wire w2;
    wire w3;

    half_adder ha1 (
        .a(a_fa),
        .b(b_fa),
        .sum(w1),
        .carry(w2)
    );

    half_adder ha2 (
        .a(w1),
        .b(cin_fa),
        .sum(sum_fa),
        .carry(w3)
    );

    assign carry_fa = w2 | w3;
endmodule
```

Hardware meaning:

```text
ha1 is one physical/logic instance of half_adder.
ha2 is a second physical/logic instance of half_adder.
w1, w2, w3 are internal connections.
```

Do not think "calling a function." Module instantiation creates hardware structure.

### Same Full Adder With Ordered Connection

```verilog
module full_adder_ordered(
    input wire a_fa,
    input wire b_fa,
    input wire cin_fa,
    output wire sum_fa,
    output wire carry_fa
);
    wire w1;
    wire w2;
    wire w3;

    half_adder ha1 (a_fa, b_fa, w1, w2);
    half_adder ha2 (w1, cin_fa, sum_fa, w3);

    assign carry_fa = w2 | w3;
endmodule
```

This works only because the order matches:

```text
(a, b, sum, carry)
```

If the half adder module header changes, ordered instantiations can break silently.

## V3-8) Width Mismatch During Port Connection

Port width mismatch is the same core problem as assignment width mismatch.

Example:

```verilog
module child(
    input wire m
);
endmodule

module top;
    wire [3:0] m_b;

    child u_child (
        .m(m_b)
    );
endmodule
```

The child formal port `m` is 1 bit. The parent actual signal `m_b` is 4 bits.

Beginner mental picture:

```text
m_b[3] m_b[2] m_b[1] m_b[0]
                        |
                        m
```

Only the least significant bit connects to the 1-bit formal port.

The upper bits are not connected to that child input.

Better:

```verilog
child u_child (
    .m(m_b[0])
);
```

This makes the truncation intentional.

If the child really needs all four bits:

```verilog
module child(
    input wire [3:0] m
);
endmodule
```

### Narrow Actual To Wide Formal

Example:

```verilog
module child(
    input wire [3:0] bus
);
endmodule

module top;
    wire one_bit_signal;

    child u_child (
        .bus(one_bit_signal)
    );
endmodule
```

Now the child expects 4 bits but the parent gives 1 bit. Tools may extend the value, but this is not a good habit. Make the intent explicit:

```verilog
child u_child (
    .bus({3'b000, one_bit_signal})
);
```

Or fix the child port width.

### Practical Port Width Checklist

Before instantiating a module:

```text
1. Read the child module header.
2. Write down each formal port width.
3. Check each actual signal width in the parent.
4. If widths differ, use explicit slicing or concatenation.
5. Do not rely on silent truncation/extension.
```

## V3-9) Empty And Unconnected Ports

There are two different ideas:

```text
empty argument:   a comma placeholder exists, but no signal is connected
missing argument: the port position is not provided at all
```

### Empty Output Port

Suppose:

```verilog
module design(
    input wire a,
    input wire b,
    output wire x,
    output wire y
);
endmodule
```

With ordered connection:

```verilog
design d2 (m, n, , );
```

This provides four argument positions:

```text
m -> a
n -> b
empty -> x
empty -> y
```

Leaving outputs unconnected is allowed when you intentionally do not need those outputs.

Named version:

```verilog
design d2 (
    .a(m),
    .b(n),
    .x(),
    .y()
);
```

This is clearer.

### Empty Input Port

Do not leave required inputs unconnected:

```verilog
design d1 (, , x_top, y_top);
```

The input ports `a` and `b` are floating. In real design practice, this is wrong. Some tools error, some warn, some allow it but simulate as `z` or `x` behavior downstream.

Correct:

```verilog
design d1 (m, n, x_top, y_top);
```

or tie off unused inputs:

```verilog
design d1 (
    .a(1'b0),
    .b(n),
    .x(x_top),
    .y(y_top)
);
```

### Missing Arguments

Wrong:

```verilog
design d3 (m, n);
```

If the module has four ports and you provide only two ordered actuals, the instantiation does not provide all argument positions. This is not the same as giving empty placeholders for the remaining output ports.

For ordered connection, if you intentionally skip outputs:

```verilog
design d3 (m, n, , );
```

For named connection:

```verilog
design d3 (
    .a(m),
    .b(n),
    .x(),
    .y()
);
```

Named connection is much clearer.

## V3-10) Video 3 Points To Remember

- A testbench is also a Verilog module.
- The testbench drives DUT inputs and observes DUT outputs.
- DUT input ports are nets inside the DUT in classic Verilog.
- DUT outputs default to net, but can be `output reg` if assigned procedurally inside the DUT.
- Signals connected to DUT inputs can be testbench `reg` variables or nets from other modules.
- Signals connected to DUT outputs should be nets in classic Verilog.
- `inout` ports should be nets on both sides.
- Module instantiation creates hardware structure, not a software function call.
- Connect by name uses `.formal(actual)`.
- Connect by order depends on the exact module header order.
- Connect by name is safer and preferred for real RTL.
- Internal wires are needed when connecting one submodule output to another submodule input.
- Width mismatches may compile but silently drop or extend bits.
- Use explicit slicing like `bus[0]` or concatenation like `{3'b000, sig}` when widths differ.
- Do not leave inputs floating.
- Outputs can be left unconnected intentionally with empty actuals.
- Empty arguments and missing arguments are not the same thing.

## V3-11) Video 3 Quiz

### Questions

1. What is a DUT?
2. Why does a testbench usually declare DUT input drivers as `reg`?
3. Why should DUT output receiver signals be `wire` in classic Verilog?
4. Can an input port be declared `input reg` in classic Verilog?
5. When do you declare an output as `output reg`?
6. What is the syntax of connect by name?
7. Why is connect by name safer than connect by order?
8. How many internal wires are needed for a full adder made from two half adders and one OR gate?
9. In the full adder structure, what does `w1` usually carry?
10. If a 4-bit actual connects to a 1-bit formal input, which bit usually connects?
11. Is leaving an output unconnected allowed?
12. Should you leave inputs unconnected?
13. What is the difference between `design d3 (m, n);` and `design d3 (m, n, , );`?
14. What does `.sum(w1)` mean?
15. Is module instantiation the same as calling a function?

### Answers

1. Design Under Test.
2. Because the testbench drives them procedurally inside an `initial` or `always` block.
3. Because the DUT output drives that outside signal like a continuous/module driver.
4. No, not in classic Verilog style.
5. When the output is assigned inside a procedural block such as `always @(*)` or `always @(posedge clk)`.
6. `.formal_port(actual_signal)`.
7. It explicitly names each child port, so order changes or many ports are less likely to create wrong connections.
8. Three: intermediate sum, carry from first half adder, carry from second half adder.
9. The sum output of the first half adder.
10. The least significant bit.
11. Yes, if intentionally unused.
12. No. Tie them to a known value or connect them properly.
13. The first provides only two arguments; the second provides four positions with the last two intentionally empty.
14. The child module's `sum` port is connected to the parent signal `w1`.
15. No. Instantiation creates another hardware instance.

## Deep Revision Addendum

This section connects the first two videos into the mental model you need for writing correct RTL and answering interview questions. The videos introduce syntax, but syntax alone is not enough. Verilog bugs usually happen when the code looks legal but the hardware meaning is different from what you imagined.

The recurring questions to ask for every line are:

```text
1. Is this object a connection or a procedural variable?
2. How many bits wide is it?
3. Is it signed or unsigned?
4. Who drives it?
5. Is it driven continuously or assigned inside a procedural block?
6. Does this code describe combinational logic, sequential logic, or simulation-only behavior?
```

If you can answer those six questions, most beginner Verilog confusion disappears.

## D1) The Real Hardware Meaning Of Verilog Objects

The word "data type" in Verilog is slightly misleading if you come from C/C++/Python. In software, a variable is usually a storage location in memory. In Verilog, an object may describe a physical connection, a procedural simulation variable, a packed bus, or simulation-only data.

### Object Meaning Table

| Object | What It Means In RTL Thinking | Default Width | Default Simulation Value | Typical Use |
| --- | --- | --- | --- | --- |
| `wire` | A net/connection driven by something else | 1 bit | `z` if undriven | Module connections, continuous assignments |
| `wor` | Net whose multiple drivers OR together | 1 bit | depends on drivers | Rare wired-OR modeling |
| `wand` | Net whose multiple drivers AND together | 1 bit | depends on drivers | Rare wired-AND modeling |
| `reg` | Procedural variable | 1 bit | `x` | Assigned in `always`/`initial` blocks |
| `integer` | 32-bit signed procedural variable | 32 bits | `x` | Loop indexes, testbench counters |
| `real` | Real-valued simulation variable | implementation real type | usually unknown/0 depending use | Testbench math/modeling |
| `time` | Simulation time variable | usually 64 bits | implementation dependent until assigned | Testbench timing |

### The Most Important Distinction

```text
wire/net:
    "What value is being driven onto this connection?"

reg/procedural variable:
    "What value did the procedural block last assign here?"
```

That is why this is natural:

```verilog
wire y;
assign y = a & b;
```

The expression continuously drives the net.

And this is natural:

```verilog
reg y;
always @(*) begin
    y = a & b;
end
```

The procedural block assigns a value to `y` whenever its inputs change.

Both can synthesize to the same AND gate. The difference is the coding mechanism.

### `reg` Is Not The Same As Hardware Register

This is a major interview point.

```verilog
reg y;
always @(*) begin
    y = a & b;
end
```

Hardware:

```text
AND gate
```

Not a flip-flop.

But:

```verilog
reg q;
always @(posedge clk) begin
    q <= d;
end
```

Hardware:

```text
edge-triggered D flip-flop
```

The clocked behavior creates the flip-flop. The `reg` keyword only says the object can be assigned procedurally.

In SystemVerilog, you will often use `logic` instead of `reg`, but the hardware reasoning is the same: the procedural behavior decides the hardware.

## D2) Continuous Assignment vs Procedural Assignment

Verilog has multiple assignment styles. Do not mix them mentally.

### Continuous Assignment

```verilog
assign y = a & b;
```

Meaning:

```text
Whenever a or b changes, y is continuously driven with a & b.
```

Hardware image:

```text
a ----\
      AND ---- y
b ----/
```

Use continuous assignment for simple combinational equations.

Correct left-hand side in classic Verilog:

```verilog
wire y;
assign y = a & b;
```

### Procedural Blocking Assignment

```verilog
always @(*) begin
    y = a & b;
end
```

The `=` assignment is blocking. In a combinational `always @(*)` block, blocking assignment is the normal style.

Example:

```verilog
always @(*) begin
    t = a & b;
    y = t | c;
end
```

Simulation order inside this block:

```text
1. compute t
2. compute y using updated t
```

This is useful for combinational intermediate calculations.

### Procedural Nonblocking Assignment

```verilog
always @(posedge clk) begin
    q <= d;
end
```

The `<=` assignment is nonblocking. In a clocked block, nonblocking assignment is the normal style.

Why:

```verilog
always @(posedge clk) begin
    q1 <= d;
    q2 <= q1;
end
```

This describes two flip-flops in a pipeline:

```text
d -> q1 -> q2
```

At the clock edge:

```text
q1 gets old d
q2 gets old q1
```

That matches real flip-flop behavior: all flip-flops sample inputs at the same clock edge.

### Rule Of Thumb

| Logic Type | Block | Assignment Style |
| --- | --- | --- |
| Simple combinational equation | `assign` | continuous |
| Combinational procedural logic | `always @(*)` | blocking `=` |
| Sequential clocked logic | `always @(posedge clk)` | nonblocking `<=` |
| Testbench stimulus | `initial` | depends on need |

This rule prevents many simulation/synthesis mismatches.

### Bad Mixed-Driver Example

Do not do this:

```verilog
wire y;
assign y = a;
assign y = b;
```

If `a` and `b` differ, `y` can become `x`.

Also avoid this style:

```verilog
reg y;
always @(*) y = a;
always @(*) y = b;
```

Multiple procedural blocks assigning the same variable is normally bad RTL. Use one block with a mux decision:

```verilog
always @(*) begin
    if (sel)
        y = b;
    else
        y = a;
end
```

## D3) Expression Width, Extension, Truncation, And Signedness

This is the deepest practical part of Videos 1 and 2. Most Verilog beginners lose marks in interviews because they ignore bit width.

### Width First, Value Second

Always ask:

```text
How many bits are on the left?
How many bits are on the right?
If the right side is wider, which bits survive?
If the right side is narrower, how is it extended?
```

Example:

```verilog
reg [1:0] a;
initial a = 7;
```

`7` in binary:

```text
111
```

Destination is only 2 bits:

```text
a = 11
```

So decimal value stored is 3.

### Truncation Happens From The MSB Side

When RHS is too wide, low bits are kept.

```verilog
reg [3:0] y;
initial y = 8'b1011_0110;
```

Keep lower 4 bits:

```text
y = 4'b0110
```

Upper bits `1011` are discarded.

### Zero Extension

If an unsigned RHS is narrower than the LHS, it is usually zero-extended.

```verilog
reg [7:0] y;
initial y = 4'b1010;
```

Result:

```text
y = 8'b0000_1010
```

### Sign Extension

If the value is signed and narrower than the destination, sign extension repeats the sign bit.

Example:

```verilog
reg signed [3:0] a;
reg signed [7:0] y;

initial begin
    a = -2;   // 4'b1110
    y = a;    // sign-extended
end
```

Result:

```text
a = 4'b1110
y = 8'b1111_1110
```

If you accidentally use unsigned:

```verilog
reg [3:0] a;
reg [7:0] y;
```

then assigning `4'b1110` can be treated as positive 14 and extended as:

```text
y = 8'b0000_1110
```

That is a huge difference.

### Signedness Is Contagious In Expressions

A common safe approach:

```verilog
reg signed [7:0] a;
reg signed [7:0] b;
reg signed [8:0] sum;

always @(*) begin
    sum = a + b;
end
```

If you mix signed and unsigned operands, the result can surprise you. In interview answers, say:

```text
I will make the operands explicitly signed and make the result one bit wider if overflow/carry matters.
```

### Addition Width Rule For Practical RTL

Adding two N-bit unsigned values can require N+1 bits.

```text
max 4-bit value = 15
15 + 15 = 30
30 in binary = 11110 = 5 bits
```

So:

```verilog
reg [3:0] a;
reg [3:0] b;
reg [4:0] sum;

always @(*) begin
    sum = {1'b0, a} + {1'b0, b};
end
```

The concatenation makes the extension explicit.

### Subtraction Width Rule

For unsigned subtraction, decide whether negative results are allowed.

If not:

```verilog
wire [3:0] diff;
assign diff = a - b;
```

This wraps around if `a < b`.

If yes, use signed/wider representation:

```verilog
wire signed [4:0] diff;
assign diff = {1'b0, a} - {1'b0, b};
```

Now the result has room for a sign.

### Safer Literal Habits

Bad:

```verilog
a = 7;
b = -1;
c = 255;
```

Better:

```verilog
a = 3'd7;
b = -8'sd1;
c = 8'd255;
```

Best when signed behavior matters:

```verilog
reg signed [7:0] b;
initial b = -8'sd1;
```

That states width, base, and signed intent.

## D4) How To Debug `x` And `z` In Simulation

Do not ignore `x` and `z`. They are not random noise; they are debug signals.

### When You See `z`

`z` usually means the signal is undriven or tri-stated.

Checklist:

```text
1. Is the signal declared but never assigned?
2. Is a module output port left unconnected?
3. Did I connect input/output directions incorrectly?
4. Did I expect a testbench to drive the signal but forget the assignment?
5. Is a tri-state enable disabled?
```

Example:

```verilog
wire y;

initial begin
    $display("%b", y);
end
```

No driver exists, so `y` is `z`.

Fix:

```verilog
assign y = 1'b0;
```

or connect it to a real module output.

### When You See `x`

`x` usually means unknown or conflict.

Checklist:

```text
1. Did I forget reset?
2. Did I read a reg before assigning it?
3. Do two drivers fight on the same net?
4. Did a case statement miss a branch?
5. Did an if/else fail to assign a value in all paths?
6. Did arithmetic include an x input?
```

Example 1: uninitialized `reg`

```verilog
reg q;
initial $display("%b", q); // x
```

Fix with reset in real RTL:

```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        q <= 1'b0;
    else
        q <= d;
end
```

Example 2: incomplete combinational assignment

```verilog
always @(*) begin
    if (sel)
        y = a;
end
```

When `sel` is 0, `y` is not assigned in this block. That can infer a latch or preserve an old/unknown value.

Fix:

```verilog
always @(*) begin
    if (sel)
        y = a;
    else
        y = b;
end
```

Or default first:

```verilog
always @(*) begin
    y = b;
    if (sel)
        y = a;
end
```

### X Propagation

If one input is unknown, the output may become unknown:

```text
x & 0 = 0
x & 1 = x
x | 1 = 1
x | 0 = x
x ^ 0 = x
x ^ 1 = x
```

Reason:

```text
If the final result depends on the unknown value, output is x.
If the known input already determines the result, output can be known.
```

This is why `x` is helpful. It shows uncertainty moving through the design.

## D5) Synthesizable Templates You Should Memorize

These templates are the safest starting point for beginner RTL.

### Combinational Logic With `assign`

```verilog
module comb_assign(
    input wire a,
    input wire b,
    input wire c,
    output wire y
);
    assign y = (a & b) | c;
endmodule
```

Use for direct Boolean equations.

### Combinational Logic With `always @(*)`

```verilog
module mux4(
    input wire [3:0] d,
    input wire [1:0] sel,
    output reg y
);
    always @(*) begin
        case (sel)
            2'b00: y = d[0];
            2'b01: y = d[1];
            2'b10: y = d[2];
            2'b11: y = d[3];
            default: y = 1'b0;
        endcase
    end
endmodule
```

Important:

```text
Every output assigned in every path.
Use blocking assignment for combinational procedural code.
```

### Combinational Logic With Default Assignment

```verilog
always @(*) begin
    y = 1'b0;

    if (enable)
        y = data;
end
```

This avoids accidental latch inference because `y` always receives a value.

### D Flip-Flop

```verilog
module dff(
    input wire clk,
    input wire rst_n,
    input wire d,
    output reg q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule
```

Important:

```text
Use nonblocking assignment in clocked blocks.
Reset gives known simulation and hardware startup behavior.
```

### Register With Enable

```verilog
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        q <= 1'b0;
    else if (en)
        q <= d;
end
```

When `en` is 0, `q` keeps its previous value. In sequential logic, that is intentional storage.

### Counter

```verilog
reg [3:0] count;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        count <= 4'd0;
    else
        count <= count + 4'd1;
end
```

Notice the sized constants:

```text
4'd0
4'd1
```

### Clean Module Connection

```verilog
wire sum;
wire carry;

half_adder u_half_adder (
    .a(a),
    .b(b),
    .sum(sum),
    .carry(carry)
);
```

Named port connections are safer than positional connections for revision and interviews.

## D6) Interview-Style Mental Models

### If The Interviewer Asks: "What Is A Wire?"

Answer:

```text
A wire is a net. It represents a connection driven by continuous assignments or module outputs. It does not procedurally store a value. If undriven, it reads as z in simulation.
```

### If The Interviewer Asks: "What Is Reg?"

Answer:

```text
In Verilog, reg is a procedural variable. It can hold the last value assigned in an always or initial block during simulation. It does not automatically mean a hardware flip-flop; synthesis depends on the procedural behavior.
```

### If The Interviewer Asks: "Why Did My 3 + 4 Become 1?"

Answer:

```text
Because the variables were probably declared as 1-bit reg. The assignments truncated 3 to 1 and 4 to 0, then 1 + 0 produced 1. The fix is to declare enough bits and size the literals.
```

Example:

```verilog
reg [2:0] a, b;
reg [3:0] c;
```

### If The Interviewer Asks: "What Is The Difference Between x And z?"

Answer:

```text
x means unknown or conflicting value. z means high impedance, usually undriven or tri-stated. x is uncertainty; z is no active driver.
```

### If The Interviewer Asks: "What Happens With Multiple Drivers?"

Answer:

```text
For a normal wire, compatible drivers resolve to that value, but conflicting 0 and 1 drivers produce x. For wor, drivers combine by OR. For wand, drivers combine by AND. In clean RTL, avoid accidental multiple drivers and use mux logic instead.
```

### If The Interviewer Asks: "How Do You Avoid Latches?"

Answer:

```text
In combinational always blocks, assign every output in every possible path. A common technique is to give default assignments at the top of the block, then override them in if/case branches.
```

Example:

```verilog
always @(*) begin
    y = 1'b0;
    case (sel)
        2'b00: y = a;
        2'b01: y = b;
        2'b10: y = c;
        2'b11: y = d;
    endcase
end
```

### If The Interviewer Asks: "Why Size Constants?"

Answer:

```text
Unsized constants can be wider than expected, usually at least 32 bits, and assignment to a smaller signal can truncate silently. Sized constants make width and base explicit, which prevents accidental bit loss.
```

Bad:

```verilog
count <= count + 1;
```

Better:

```verilog
count <= count + 4'd1;
```

### Final Mental Checklist Before Writing RTL

Before you run simulation, check:

```text
1. Are all ports declared with correct direction?
2. Are all internal signals wide enough?
3. Are arithmetic results one bit wider when carry/overflow matters?
4. Are constants sized?
5. Does each combinational output get assigned in every path?
6. Does each sequential register have a reset if needed?
7. Is each signal driven by exactly one clean source?
8. Are testbench-only constructs kept out of synthesizable design code?
```

## Practice Snippets

### Half Adder

```verilog
module half_adder(
    input wire a,
    input wire b,
    output wire sum,
    output wire carry
);
    assign sum = a ^ b;
    assign carry = a & b;
endmodule
```

### Full Adder By Half Adder Instantiation

```verilog
module full_adder(
    input wire a_fa,
    input wire b_fa,
    input wire cin_fa,
    output wire sum_fa,
    output wire carry_fa
);
    wire w1;
    wire w2;
    wire w3;

    half_adder ha1 (
        .a(a_fa),
        .b(b_fa),
        .sum(w1),
        .carry(w2)
    );

    half_adder ha2 (
        .a(w1),
        .b(cin_fa),
        .sum(sum_fa),
        .carry(w3)
    );

    assign carry_fa = w2 | w3;
endmodule
```

### Full Adder Port Connection Testbench

```verilog
module full_adder_tb;
    reg a_tb;
    reg b_tb;
    reg cin_tb;
    wire sum_tb;
    wire carry_tb;

    full_adder dut (
        .a_fa(a_tb),
        .b_fa(b_tb),
        .cin_fa(cin_tb),
        .sum_fa(sum_tb),
        .carry_fa(carry_tb)
    );

    initial begin
        a_tb = 1'b0;
        b_tb = 1'b1;
        cin_tb = 1'b1;
        #1;
        $display("0 + 1 + 1 -> sum=%b carry=%b", sum_tb, carry_tb);

        a_tb = 1'b1;
        b_tb = 1'b1;
        cin_tb = 1'b1;
        #1;
        $display("1 + 1 + 1 -> sum=%b carry=%b", sum_tb, carry_tb);
    end
endmodule
```

Expected idea:

```text
0 + 1 + 1 -> sum=0 carry=1
1 + 1 + 1 -> sum=1 carry=1
```

### Literal And Width Testbench

```verilog
module literals_and_width_tb;
    wire w_from_3bits;
    wire w_from_minus1;

    reg [1:0] two_bit_value;
    reg one_bit_a;
    reg one_bit_b;
    reg one_bit_c;

    reg [2:0] good_a;
    reg [2:0] good_b;
    reg [3:0] good_c;

    assign w_from_3bits = 3'b001;
    assign w_from_minus1 = -1;

    initial begin
        $display("6'o73 = %b", 6'o73);
        $display("8'o73 = %b", 8'o73);
        $display("2'o73 = %b", 2'o73);
        $display("8'hff = %b", 8'hff);

        two_bit_value = 7;
        $display("two_bit_value after 7 = %b", two_bit_value);

        one_bit_a = 3;
        one_bit_b = 4;
        one_bit_c = one_bit_a + one_bit_b;
        $display("1-bit a=%b b=%b c=%b", one_bit_a, one_bit_b, one_bit_c);

        good_a = 3'd3;
        good_b = 3'd4;
        good_c = good_a + good_b;
        $display("good sum = %0d", good_c);

        $display("w_from_3bits=%b", w_from_3bits);
        $display("w_from_minus1=%b", w_from_minus1);
    end
endmodule
```

Expected idea:

```text
6'o73 -> 111011
8'o73 -> 00111011
2'o73 -> 11
8'hff -> 11111111
two_bit_value after 7 -> 11
1-bit a=1 b=0 c=1
good sum -> 7
w_from_3bits -> 1
w_from_minus1 -> 1
```

### Vector Slicing Testbench

```verilog
module vector_slice_tb;
    reg [5:0] a;
    reg b;
    reg [2:0] c;

    initial begin
        a = 6'b111_011;

        b = a[0];
        $display("a[0] = %b", b);

        b = a[2];
        $display("a[2] = %b", b);

        c = a[5:3];
        $display("a[5:3] = %b", c);

        c = a[2:0];
        $display("a[2:0] = %b", c);
    end
endmodule
```

Expected idea:

```text
a[0] = 1
a[2] = 0
a[5:3] = 111
a[2:0] = 011
```

## Source Notes

- Video 1 used for lecture sequence and timestamps: [Introduction to Verilog](https://www.youtube.com/watch?v=IP_8QJ5k2I8)
- Video 2 used for lecture sequence and timestamps: [Verilog Data Types Explained](https://www.youtube.com/watch?v=R57WWiEqkLQ)
- Video 3 used for lecture sequence and timestamps: [Port Connection Rules in Verilog](https://www.youtube.com/watch?v=C219U48xX04)
- Verilog HDL is standardized in IEEE 1364. The 2001 revision is IEEE Std 1364-2001: [IEEE 1364-2001](https://ieeexplore.ieee.org/document/954909)
- IEEE Std 1364-2005 defines the Verilog HDL standard: [IEEE 1364-2005](https://ieeexplore.ieee.org/document/1620780)
- The Verilog examples in this note were syntax-checked with Icarus Verilog. Some examples intentionally produce truncation warnings because they demonstrate width-loss pitfalls.
