/*
Q9 STUDY NOTE: asynchronous reset vs synchronous reset flip-flops

Both modules below describe positive-edge-triggered D flip-flops with an
active-high reset. The difference is when the reset is allowed to affect q.

Main rule from the Verilog code:
    - If reset is in the sensitivity list with the clock, it is asynchronous.
    - If reset is tested only inside an always @(posedge clk), it is synchronous.

Why nonblocking assignment is used:
    q <= ...

    These are sequential always blocks, so nonblocking assignments model
    flip-flop updates correctly. The value of q updates after the active event,
    matching the idea that all flip-flops sample together on a clock edge.

Asynchronous reset behavior:
    always @(posedge clk or posedge rst)

    q resets immediately when rst has a rising edge, even if no clock edge
    occurs. Hardware usually maps this to a flip-flop with an asynchronous
    clear/reset pin, if that primitive exists in the target device/library.

    Deeper pros:
        - Works even when the clock is not running.
          This is the biggest practical advantage. If a clock domain is gated,
          stalled, not locked yet, or intentionally stopped, an asynchronous
          reset can still force registers into the reset state.

        - Reset assertion is immediate.
          As soon as rst goes active, the flop is cleared without waiting for
          the next posedge clk. This is useful for emergency fault handling,
          power-on reset entry, or logic that must be forced safe before the
          first valid clock edge arrives.

        - Often maps directly to a real flop clear/preset pin.
          Many FPGA slices and ASIC standard-cell flops have asynchronous clear
          or preset pins. If your target has the right primitive, this coding
          style directly expresses that hardware.

        - Useful for bringing hardware into a known state at startup.
          Some systems need reset assertion before clocks and PLLs/MMCMs are
          stable. An asynchronous reset can hold state elements cleared while
          the clocking system is still coming up.

    Deeper cons:
        - Reset release is the dangerous part.
          Assertion is easy: rst=1 forces q=0. Deassertion is harder: if rst
          goes 1->0 too close to a clock edge, the flop can violate recovery or
          removal timing. That is similar in spirit to setup/hold timing, but
          for asynchronous control pins. The result can be metastability or
          different flops leaving reset on different clock cycles.

        - One reset signal feeding multiple clock domains is an RDC problem.
          RDC means reset-domain crossing. If the same asynchronous reset is
          released into many clock domains without per-domain synchronization,
          each domain may observe reset release at a different unsafe time.
          The normal fix is a reset synchronizer per destination clock domain.

        - A glitch on rst is immediately visible to hardware.
          Because rst is an asynchronous control, a narrow unwanted pulse can
          clear the flop even if no clock edge happens. This makes filtering,
          clean board-level reset generation, and proper reset distribution
          important.

        - Timing analysis is more subtle.
          Async reset assertion is not treated like normal data launched and
          captured by a clock. The important checks around reset release are
          recovery and removal checks. These are easy to ignore accidentally if
          the reset is treated like a false path without a synchronization plan.

        - Can reduce optimization freedom.
          Retiming, register balancing, shift-register inference, DSP packing,
          BRAM/register absorption, and other optimizations may be harder when
          a register has an asynchronous control pin. Some hard blocks support
          only specific reset styles, so an async reset can force extra fabric
          logic or prevent ideal mapping.

        - High-fanout global async resets can be costly.
          A reset net that touches thousands of flops can become a difficult
          routing/timing/control-set signal. FPGA tools may need replication or
          special routing. More unique reset/control combinations can also hurt
          packing efficiency.

    Common real-design practice:
        Asynchronous assert, synchronous deassert.
        That means reset may go active immediately, but its release is passed
        through a reset synchronizer for each clock domain.

Synchronous reset behavior:
    always @(posedge clk)

    rst is only sampled on the rising clock edge. If rst changes between clock
    edges, q does not change until the next posedge clk. Hardware may map this
    to a flip-flop synchronous reset input, or to logic/muxing on the D input,
    depending on the synthesis tool and target architecture.

    Deeper pros:
        - Reset assertion and release both happen on clock edges.
          q changes only on posedge clk. That makes reset behavior line up with
          the rest of the synchronous logic in the clock domain.

        - Easier timing model.
          Synchronous reset is checked like normal synchronous logic: rst must
          meet setup/hold timing to the active clock edge. This is usually more
          straightforward than reasoning about async recovery/removal timing.

        - Safer reset release inside a running clock domain.
          Because q leaves reset only on a clock edge, all flops in that domain
          can leave reset in a clocked, timed way, assuming rst has been routed
          and timed properly.

        - More synthesis and implementation flexibility.
          The tool may implement the reset using a dedicated synchronous reset
          pin, or as logic on the D path. This can help retiming, register
          duplication, SRL inference, DSP/BRAM pipeline packing, and other
          architecture-specific optimizations.

        - Short reset glitches are less likely to affect state.
          A glitch between clock edges will not change q unless it is present
          when the active clock edge samples rst. This is not a substitute for
          synchronization or clean reset design, but it is less immediately
          sensitive than an async reset pin.

        - Fits fully synchronous design style.
          Most RTL timing closure assumes that state changes happen because of
          clocks. Synchronous resets keep reset behavior inside that same model.

    Deeper cons:
        - The clock must be running.
          If the clock is stopped, gated off, not locked, or not yet available,
          q cannot reset. The reset request waits until a posedge clk occurs.

        - Reset pulse width matters.
          rst must stay active long enough to be sampled by at least one active
          clock edge. A reset pulse that starts and ends between two clock edges
          is completely missed.

        - External or cross-domain reset still needs synchronization.
          A synchronous reset is only safe if rst is synchronous to clk. If rst
          comes from a button, another clock domain, a PLL lock signal, or board
          reset circuitry, it must be synchronized before being used as a
          synchronous reset in this domain.

        - Reset can add data-path logic.
          If the target flop does not use a dedicated synchronous reset pin, the
          tool may build reset as a mux before D:
              D_to_flop = rst ? 1'b0 : d;
          That mux can add delay on the D path and affect timing.

        - High-fanout synchronous reset nets can still be expensive.
          Even though the reset is synchronous, a reset signal driving many
          flops still has fanout, routing, skew, and timing cost. Large designs
          often need reset replication or local reset generation.

        - Not every register needs a reset.
          In FPGA design, unnecessary resets can block SRL/RAM/DSP inference or
          add routing pressure. Reset only state that truly needs a known value;
          let pure datapath pipelines flush naturally when possible.

Interview answer:
    q09_a is an asynchronously reset D flip-flop because rst is part of the
    event control: @(posedge clk or posedge rst). q goes to 0 immediately when
    rst rises.

    q09_b is a synchronously reset D flip-flop because the event control is only
    @(posedge clk). rst is checked only on the clock edge, so q changes because
    of reset only on posedge clk.

Sources checked:
    - AMD Vivado UG949 discusses synchronous and asynchronous reset coding and
      notes that synchronous resets can improve resource usage/performance for
      some FPGA hard resources.
    - AMD Vivado UG906 discusses asynchronous reset synchronizers and safe reset
      deassertion in a destination clock domain.
    - Intel Quartus design recommendations warn that reset/control conditions
      should match the target device architecture for best synthesis results.
*/

module q09_a (
    input  wire clk,
    input  wire rst,
    input  wire d,
    output reg  q
);
    // Asynchronous active-high reset:
    // rst is in the sensitivity list, so a posedge rst triggers this block even
    // without a clock edge. If rst is 1, q clears immediately.
    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

module q09_b (
    input  wire clk,
    input  wire rst,
    input  wire d,
    output reg  q
);
    // Synchronous active-high reset:
    // only clk is in the sensitivity list. rst is sampled on posedge clk, so
    // q does not clear until the next clock edge where rst is 1.
    always @(posedge clk) begin
        if (rst)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule
