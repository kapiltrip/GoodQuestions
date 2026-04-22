# PDF Q43) Cross Section of a CMOS Transistor

## Index

1. [43) Cross section of a CMOS transistor](#43-cross-section-of-a-cmos-transistor)
2. [Direct answer](#direct-answer)
3. [What CMOS means](#what-cmos-means)
4. [MOSFET terminals](#mosfet-terminals)
5. [NMOS cross section](#nmos-cross-section)
6. [PMOS cross section](#pmos-cross-section)
7. [How the gate controls the channel](#how-the-gate-controls-the-channel)
8. [Body ties and body diodes](#body-ties-and-body-diodes)
9. [CMOS inverter from the cross section](#cmos-inverter-from-the-cross-section)
10. [Why CMOS has low static power](#why-cmos-has-low-static-power)
11. [Process node table](#process-node-table)
12. [Layout and implementation notes](#layout-and-implementation-notes)
13. [Common mistakes](#common-mistakes)
14. [43) Interview answer](#43-interview-answer)

## 43) Cross section of a CMOS transistor

The page shows a simplified cross section with an NMOS device and a PMOS device built on the same silicon substrate.

For an RTL engineer, the goal is not to become a process engineer. The goal is to be able to explain:

- where NMOS and PMOS devices sit physically
- what source, drain, gate, and body mean
- why NMOS body is usually tied to `GND`
- why PMOS body/well is usually tied to `VDD`
- how the gate voltage creates or removes a conducting channel
- why CMOS logic has low static current in steady state

## Direct answer

A CMOS cross section contains both NMOS and PMOS transistors.

In a common p-substrate CMOS process:

```text
NMOS:
    built directly in p-type substrate or p-well
    source/drain are n+ diffusion regions
    body is p-type and usually tied to GND

PMOS:
    built inside an n-well
    source/drain are p+ diffusion regions
    body is n-type well and usually tied to VDD
```

Both devices have:

```text
G = gate
S = source
D = drain
B = body/bulk
```

The gate is separated from the silicon by a very thin gate oxide. The gate voltage controls whether a conducting channel exists between source and drain.

## What CMOS means

CMOS means:

```text
Complementary Metal-Oxide-Semiconductor
```

Complementary means the logic uses both:

- NMOS transistors
- PMOS transistors

In digital CMOS logic:

- NMOS devices are strong at pulling a node down to `0`.
- PMOS devices are strong at pulling a node up to `1`.

This complementary behavior is the basis for inverter, NAND, NOR, and standard-cell logic.

The word "metal" is historical. Older MOS gates used metal. Modern processes often use polysilicon or metal gate stacks depending on the technology generation, but the name MOS/CMOS remains.

## MOSFET terminals

A MOSFET has four terminals:

```text
G = gate
S = source
D = drain
B = body, bulk, or well
```

### Gate

The gate is the control terminal. It sits above the channel region and is insulated from the semiconductor by gate oxide.

Ideally, DC current does not flow into the gate because the gate is insulated.

In real devices, there is small gate leakage, especially in very advanced processes.

### Source and drain

The source and drain are heavily doped diffusion regions.

For an NMOS:

```text
source/drain are n+
body is p-type
```

For a PMOS:

```text
source/drain are p+
body is n-type
```

In a symmetric MOS device, source and drain can look physically similar. In a circuit, the source is normally the terminal used as the reference for `VGS`.

Common digital convention:

```text
NMOS source often near GND
PMOS source often near VDD
```

### Body

The body is the silicon region in which the device is built.

For normal digital CMOS:

```text
NMOS body -> lowest potential, usually GND
PMOS body -> highest potential, usually VDD
```

This avoids forward-biasing parasitic junction diodes.

## NMOS cross section

Simplified NMOS view:

```text
       G
       |
   gate conductor
  ----------------  thin gate oxide
 n+      p-type      n+
 S      channel      D
 |                   |
 +-------------------+
      p-substrate or p-well
             |
             B tied to GND through p+ tap
```

Physical parts:

- `n+ source`: heavily doped n-type source diffusion
- `n+ drain`: heavily doped n-type drain diffusion
- `p-substrate` or `p-well`: body region
- `gate oxide`: thin insulator between gate and silicon
- `gate`: control electrode
- `p+ body tap`: contact used to tie body to `GND`

Operation:

- If `VGS < VTN`, no strong n-channel exists, so NMOS is OFF.
- If `VGS > VTN`, an n-type inversion channel forms under the gate, so NMOS can conduct.

Digital shorthand:

```text
NMOS gate = 0 -> OFF
NMOS gate = 1 -> ON
```

## PMOS cross section

Simplified PMOS view:

```text
       G
       |
   gate conductor
  ----------------  thin gate oxide
 p+      n-type      p+
 S      channel      D
 |                   |
 +-------------------+
          n-well
             |
             B tied to VDD through n+ well tap
```

Physical parts:

- `p+ source`: heavily doped p-type source diffusion
- `p+ drain`: heavily doped p-type drain diffusion
- `n-well`: PMOS body region
- `gate oxide`: thin insulator between gate and silicon
- `gate`: control electrode
- `n+ well tap`: contact used to tie n-well/body to `VDD`

Operation:

- If the gate is close to the source voltage, PMOS is OFF.
- If the gate is sufficiently lower than the source, a p-type inversion channel forms and PMOS turns ON.

Digital shorthand:

```text
PMOS gate = 0 -> ON
PMOS gate = 1 -> OFF
```

For a PMOS with source at `VDD`, the important control voltage is:

```text
VSG = VS - VG
```

PMOS turns on when `VSG` is larger than the threshold magnitude.

## How the gate controls the channel

The gate is insulated from the body by oxide, so it controls the channel through an electric field.

### NMOS channel formation

NMOS body is p-type, so it has many holes as majority carriers.

When the gate voltage is raised:

1. holes are repelled from the region under the gate
2. a depletion region forms
3. with enough gate voltage, electrons are attracted to the surface
4. an n-type inversion channel forms between source and drain

Then current can flow through the channel.

### PMOS channel formation

PMOS body is n-type, so it has many electrons as majority carriers.

When the gate voltage is pulled low relative to the source:

1. electrons are repelled from the surface
2. holes are attracted to the surface
3. a p-type inversion channel forms between source and drain

Then current can flow through the channel.

Interview shorthand:

```text
Gate voltage creates an inversion layer under the oxide.
That inversion layer acts like a controllable channel between source and drain.
```

## Body ties and body diodes

The source/drain diffusion and body form PN junctions.

For NMOS:

```text
n+ source/drain inside p-body
```

Each n+/p junction is a diode.

For PMOS:

```text
p+ source/drain inside n-well
```

Each p+/n junction is also a diode.

To keep those junction diodes reverse-biased:

```text
NMOS body is tied to GND
PMOS body is tied to VDD
```

That is why the cross-section drawing includes body contacts:

- p+ substrate tap for NMOS body
- n+ well tap for PMOS body

### Body effect

If source and body are not at the same potential, the threshold voltage changes.

This is called body effect.

For digital standard cells, tying body to the correct rail makes the device behavior predictable and helps avoid accidental diode conduction.

### Latch-up note

CMOS wells and substrate form parasitic bipolar structures. If disturbed badly, these can create a low-resistance path from `VDD` to `GND`. This failure mode is called latch-up.

Practical layout uses:

- well taps
- substrate taps
- guard rings in sensitive areas
- spacing rules

to reduce latch-up risk.

## CMOS inverter from the cross section

A CMOS inverter connects one PMOS and one NMOS like this:

```text
          VDD
           |
        PMOS source
input -> PMOS gate
        PMOS drain
           |
           +---- output Y
           |
        NMOS drain
input -> NMOS gate
        NMOS source
           |
          GND
```

Body connections:

```text
PMOS body/n-well -> VDD
NMOS body        -> GND
```

When input is `0`:

```text
PMOS ON
NMOS OFF
Y pulled to VDD
```

When input is `1`:

```text
PMOS OFF
NMOS ON
Y pulled to GND
```

Truth table:

```text
A | Y
--+--
0 | 1
1 | 0
```

## Why CMOS has low static power

In ideal steady state, a CMOS inverter does not have a direct path from `VDD` to `GND`.

Input `0`:

```text
PMOS ON, NMOS OFF
VDD -> output
no path to GND
```

Input `1`:

```text
PMOS OFF, NMOS ON
output -> GND
no path to VDD
```

So static CMOS mainly consumes power when:

- nodes switch and capacitances charge/discharge
- leakage current flows through off devices
- short-circuit current flows briefly during input transitions

This connects directly to the earlier power questions:

```text
dynamic power = switching activity
static power  = leakage
```

## Process node table

The page includes a technology-node history table. A compact version is:

```text
Year | Process
-----+--------
1989 | 800 nm
1994 | 600 nm
1995 | 350 nm
1997 | 250 nm
1999 | 180 nm
2001 | 130 nm
2004 |  90 nm
2006 |  65 nm
2008 |  45 nm
2010 |  32 nm
2012 |  22 nm
2014 |  14 nm
2016 |  10 nm
2018 |   7 nm
2020 |   5 nm
```

Important interview caveat:

```text
Modern process node names are technology generation labels.
They are not always equal to one literal physical transistor dimension.
```

Older node names were more directly related to physical dimensions such as gate length. In modern FinFET/GAAFET-era processes, node naming is more of an industry generation marker and depends on density, performance, power, and foundry naming.

For a frontend RTL interview, it is usually enough to know the rough sequence and to avoid claiming that "5 nm" means every transistor feature is exactly 5 nm.

## Layout and implementation notes

### Diffusion

Source and drain regions are created by doping the silicon.

Heavy doping is written as:

```text
n+ = heavily doped n-type
p+ = heavily doped p-type
```

### Wells

In a p-substrate process:

- NMOS can be built in p-substrate or p-well.
- PMOS needs an n-well so its body is n-type.

In more advanced processes, there can be twin wells, triple wells, deep n-wells, isolation structures, FinFETs, or gate-all-around structures. The simple cross section is still useful for basic CMOS reasoning.

### Contacts and metal

The source, drain, gate, and body regions are connected to upper metal layers through contacts and vias.

RTL designers do not place these contacts directly, but physical design and standard-cell layout do.

### Standard cells

An RTL line like:

```verilog
assign y = ~(a & b);
```

does not directly draw transistors. It tells synthesis the Boolean function. The synthesis tool chooses a NAND standard cell from the library. That standard cell already contains the transistor layout, wells, diffusion, contacts, and metal.

## Common mistakes

### Mistake 1: saying B means base

In MOSFET diagrams:

```text
B = body or bulk
```

It is not the same as a BJT base terminal.

### Mistake 2: forgetting the well/body tie

For normal CMOS digital logic:

```text
NMOS body -> GND
PMOS body -> VDD
```

Leaving bodies floating is not normal for standard-cell digital logic.

### Mistake 3: saying source and drain are always physically different

In many MOS structures, source and drain regions can be physically similar. In circuit operation, the source/drain role depends on voltages and current direction.

For digital logic, the convention is:

```text
NMOS source near GND
PMOS source near VDD
```

### Mistake 4: saying CMOS has zero power

CMOS has low static power ideally, but real CMOS still has:

- leakage current
- dynamic switching power
- short-circuit current during transitions
- memory and clock-tree power

### Mistake 5: treating process node names as exact dimensions

Modern node names are not exact single physical dimensions. They are technology labels.

## 43) Interview answer

A CMOS cross section contains NMOS and PMOS devices on the same chip. In a common p-substrate process, the NMOS is built in p-type substrate or p-well with n+ source and drain regions, and its body is tied to `GND`. The PMOS is built inside an n-well with p+ source and drain regions, and its n-well/body is tied to `VDD`. Each transistor has gate, source, drain, and body terminals. The gate is separated from the silicon by gate oxide and controls whether an inversion channel forms between source and drain. NMOS turns on for a high gate voltage and pulls nodes down well; PMOS turns on for a low gate voltage and pulls nodes up well. Body ties keep parasitic junction diodes reverse-biased and make device behavior predictable.
