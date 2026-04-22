# Practice Verilog

## PDF Questions (Numbering from shared pages)

| No. | Question | Type | File(s) |
| --- | --- | --- | --- |
| 1 | Difference between blocking and non-blocking statements, and when they are used | Theory | [notes/pdf_q01_q02_theory.md](notes/pdf_q01_q02_theory.md) |
| 2 | Difference between logical and bitwise operators | Theory | [notes/pdf_q01_q02_theory.md](notes/pdf_q01_q02_theory.md) |
| 3 | Write code for logic gates: and, or, xor, nand, nor, xnor | Code | [qa/pdf_q03_q06/q03_logic_gates.v](qa/pdf_q03_q06/q03_logic_gates.v) |
| 4 | Bitwise reduction on a multibit signal | Code | [qa/pdf_q03_q06/q04_bitwise_reduction.v](qa/pdf_q03_q06/q04_bitwise_reduction.v) |
| 5 | Code that multiplies/divides by powers of 2 | Code | [qa/pdf_q03_q06/q05_shift_operations.v](qa/pdf_q03_q06/q05_shift_operations.v) |
| 6 | Perform sign extension | Code | [qa/pdf_q03_q06/q06_sign_extension.v](qa/pdf_q03_q06/q06_sign_extension.v) |
| 7 | Three ways to code a 4:1 mux in Verilog | Code (single file, 3 styles) | [qa/pdf_q07_q11/q07_mux4_styles.v](qa/pdf_q07_q11/q07_mux4_styles.v) |
| 8 | Synthesis result of previous mux coding styles | Theory | [notes/pdf_q08_q11_theory.md](notes/pdf_q08_q11_theory.md) |
| 9 | Asynchronous vs synchronous flip-flops with pros/cons | Code + Theory | [qa/pdf_q07_q11/q09_ff_reset_styles.v](qa/pdf_q07_q11/q09_ff_reset_styles.v), [notes/pdf_q08_q11_theory.md](notes/pdf_q08_q11_theory.md) |
| 10 | Capture input using latch and flip-flop | Code + Theory | [qa/pdf_q07_q11/q10_latch_and_flop.v](qa/pdf_q07_q11/q10_latch_and_flop.v), [notes/pdf_q08_q11_theory.md](notes/pdf_q08_q11_theory.md) |
| 11 | Detect signal transitions in either direction (with timing) | Code + Theory | [qa/pdf_q07_q11/q11_edge_detect.v](qa/pdf_q07_q11/q11_edge_detect.v), [notes/pdf_q08_q11_theory.md](notes/pdf_q08_q11_theory.md) |
| 12 | Design a circuit to detect a 1-cycle pulse input | Code | [qa/pdf_q12_q18/q12_one_cycle_pulse_detect.v](qa/pdf_q12_q18/q12_one_cycle_pulse_detect.v) |
| 13 | Sequence detector for pattern `10110` (4 FSM variants) | Code (single file, variants A/B/C/D) | [qa/pdf_q12_q18/q13_seq_10110_fsms_abcd.v](qa/pdf_q12_q18/q13_seq_10110_fsms_abcd.v) |
| 14 | Detect if pattern `10110` appears in the last 5 inputs | Code + Theory | [qa/pdf_q12_q18/q14_last5_detect_10110.v](qa/pdf_q12_q18/q14_last5_detect_10110.v), [notes/pdf_q14_q18_theory.md](notes/pdf_q14_q18_theory.md) |
| 15 | Generate `start` and rotating `chip_select` pulses from timing | Code + Theory | [qa/pdf_q12_q18/q15_start_and_chipselects.v](qa/pdf_q12_q18/q15_start_and_chipselects.v), [notes/pdf_q14_q18_theory.md](notes/pdf_q14_q18_theory.md) |
| 16 | Debounce/synchronize async input and output one pulse on valid rise | Code | [qa/pdf_q12_q18/q16_sync_debounce_onepulse.v](qa/pdf_q12_q18/q16_sync_debounce_onepulse.v) |
| 17 | Generate Gray code counter (table method + XOR method) | Code + Theory | [qa/pdf_q12_q18/q17_gray_counter_methods.v](qa/pdf_q12_q18/q17_gray_counter_methods.v), [notes/pdf_q14_q18_theory.md](notes/pdf_q14_q18_theory.md) |
| 18 | Design synchronous FIFO with dual-port RAM, full/empty flags | Code + Theory | [qa/pdf_q12_q18/q18_fifo_sync_dualport.v](qa/pdf_q12_q18/q18_fifo_sync_dualport.v), [notes/pdf_q14_q18_theory.md](notes/pdf_q14_q18_theory.md) |
| 19 | Detect if serially received number is divisible by 3 | Code + Theory | [qa/pdf_q19_q20/q19_divisible_by3_fsm.v](qa/pdf_q19_q20/q19_divisible_by3_fsm.v), [notes/pdf_q19_q20_theory.md](notes/pdf_q19_q20_theory.md) |
| 20 | Generate Fibonacci sequence with enable control | Code + Theory | [qa/pdf_q19_q20/q20_fibonacci_enable.v](qa/pdf_q19_q20/q20_fibonacci_enable.v), [notes/pdf_q19_q20_theory.md](notes/pdf_q19_q20_theory.md) |
| 21 | Find maximum and second maximum from a group with least comparators | Code + Theory | [qa/pdf_q21/q21_max_and_second_max_onecmp.v](qa/pdf_q21/q21_max_and_second_max_onecmp.v), [notes/pdf_q21_theory.md](notes/pdf_q21_theory.md) |
| 22 | Generate second/minute/hour ticks from a 1 ms pulse input | Code + Theory | [qa/pdf_q22_q23/q22_time_ticks.v](qa/pdf_q22_q23/q22_time_ticks.v), [notes/pdf_q22_q23_theory.md](notes/pdf_q22_q23_theory.md) |
| 23 | Build waveform B from clock + A timing relationship | Code + Theory | [qa/pdf_q22_q23/q23_timing_b_from_a.v](qa/pdf_q22_q23/q23_timing_b_from_a.v), [notes/pdf_q22_q23_theory.md](notes/pdf_q22_q23_theory.md) |
| 24 | Design a 5-tap FIR filter and discuss an application | Code + Theory | [qa/pdf_q24/q24_fir_5tap.v](qa/pdf_q24/q24_fir_5tap.v), [notes/pdf_q24_theory.md](notes/pdf_q24_theory.md) |
| 25 | Write Verilog code for clock divide-by-2 circuit | Code + Theory | [qa/pdf_q25_q26/q25_clock_div2.v](qa/pdf_q25_q26/q25_clock_div2.v), [notes/pdf_q25_q26_theory.md](notes/pdf_q25_q26_theory.md) |
| 26 | Clock divide-by-3 circuit with 50-50 duty cycle | Code + Theory | [qa/pdf_q25_q26/q26_clock_div3_duty50.v](qa/pdf_q25_q26/q26_clock_div3_duty50.v), [notes/pdf_q25_q26_theory.md](notes/pdf_q25_q26_theory.md) |
| 27 | Clock divide-by-N circuit | Code + Theory | [qa/pdf_q27/q27_clock_div_n.v](qa/pdf_q27/q27_clock_div_n.v), [qa/pdf_q27/q27_clock_divider_variants.v](qa/pdf_q27/q27_clock_divider_variants.v), [notes/pdf_q27_theory.md](notes/pdf_q27_theory.md) |
| 28 | Design a glitch-free clock gating cell with enable | Code + Theory | [qa/pdf_q28_q30/q28_glitch_free_clock_gate.v](qa/pdf_q28_q30/q28_glitch_free_clock_gate.v), [notes/pdf_q28_q30_theory.md](notes/pdf_q28_q30_theory.md) |
| 29 | Detect a rising edge of a signal when clocks are off | Code + Theory | [qa/pdf_q28_q30/q29_async_rise_detect_when_clocks_off.v](qa/pdf_q28_q30/q29_async_rise_detect_when_clocks_off.v), [notes/pdf_q28_q30_theory.md](notes/pdf_q28_q30_theory.md) |
| 30 | Reset synchronizer with async assert and sync deassert | Code + Theory | [qa/pdf_q28_q30/q30_reset_synchronizer.v](qa/pdf_q28_q30/q30_reset_synchronizer.v), [notes/pdf_q28_q30_theory.md](notes/pdf_q28_q30_theory.md) |
| 31 | Design asynchronous FIFO with Gray-coded pointers | Code | [qa/pdf_q31/q31_async_fifo_grayptr.v](qa/pdf_q31/q31_async_fifo_grayptr.v) |
| 32 | Frequency division `/3` for 33.33%, 66.67%, and exact 50% duty cycle | Theory (cited note) | `frequency_division/f_div_3_all_duty_cycles.md` |
| 33 | Frequency division `/5` for 20%, 40%, 60%, 80%, and exact 50% duty cycle | Theory (cited note) | `frequency_division/f_div_5_all_duty_cycles.md` |
| 34 | Frequency division `/7` for 14.29%, 28.57%, 42.86%, 57.14%, 71.43%, 85.71%, and exact 50% duty cycle | Theory (cited note) | `frequency_division/f_div_7_all_duty_cycles.md` |

## Notebook Theory Questions

| No. | Question | Type | File(s) |
| --- | --- | --- | --- |
| 31 | What is metastability? | Theory | [notes/pdf_q31_metastability.md](notes/pdf_q31_metastability.md) |
| 32 | Design a circuit to synchronize a signal from slow clock domain to fast clock domain | Theory + Code | [notes/pdf_q32_slow_to_fast_sync.md](notes/pdf_q32_slow_to_fast_sync.md) |
| 33 | How would the previous circuit change from fast domain to slow domain? | Theory + Code | [notes/pdf_q33_fast_to_slow_handshake.md](notes/pdf_q33_fast_to_slow_handshake.md) |
| 34 | How would you synchronize a data bus instead? | Theory + Code | [notes/pdf_q34_bus_cdc_handshake.md](notes/pdf_q34_bus_cdc_handshake.md) |
| 35 | Why are Gray coding techniques used for clock domain crossings? | Theory + Code | [notes/pdf_q35_gray_code_cdc.md](notes/pdf_q35_gray_code_cdc.md) |
| 36 | Describe the two components that make up power | Theory | [notes/pdf_q36_q37_power.md](notes/pdf_q36_q37_power.md) |
| 37 | Describe static power and how to reduce it in RTL | Theory | [notes/pdf_q36_q37_power.md](notes/pdf_q36_q37_power.md) |
| 38 | Describe dynamic power | Theory | [notes/pdf_q38_q39_dynamic_low_power_rtl.md](notes/pdf_q38_q39_dynamic_low_power_rtl.md) |
| 39 | Describe low-power techniques with RTL code | Theory + Code | [notes/pdf_q38_q39_dynamic_low_power_rtl.md](notes/pdf_q38_q39_dynamic_low_power_rtl.md) |
| 40 | Define setup time and hold time | Theory | [notes/pdf_q40_q41_sta_boolean.md](notes/pdf_q40_q41_sta_boolean.md) |
| 41 | Venn diagram Boolean logic expression and simplification | Theory + Code | [notes/pdf_q40_q41_sta_boolean.md](notes/pdf_q40_q41_sta_boolean.md) |
| 42 | Transistor-level equivalent of digital logic gates | Theory + Code | [notes/pdf_q42_cmos_logic_gates.md](notes/pdf_q42_cmos_logic_gates.md) |
| 43 | Cross section of a CMOS transistor | Theory | [notes/pdf_q43_cmos_transistor_cross_section.md](notes/pdf_q43_cmos_transistor_cross_section.md) |
| 44 | FSMs, Karnaugh maps, and Gray-code divide-by-3 design | Theory + Code | [notes/pdf_q44_fsm_kmap_gray_code.md](notes/pdf_q44_fsm_kmap_gray_code.md), [qa/pdf_q44/q44_div3_gray_fsm.v](qa/pdf_q44/q44_div3_gray_fsm.v) |
| 45 | Half/full adders and subtractors, including ripple carry/borrow | Theory + Code | [notes/pdf_q45_half_full_adders.md](notes/pdf_q45_half_full_adders.md), [qa/pdf_q45/q45_adders.v](qa/pdf_q45/q45_adders.v) |
| 46 | Create digital logic gates using a 2:1 mux | Theory + Code | [notes/pdf_q46_gates_using_2to1_mux.md](notes/pdf_q46_gates_using_2to1_mux.md), [qa/pdf_q46/q46_gates_using_mux2.v](qa/pdf_q46/q46_gates_using_mux2.v) |
| 47 | Use an XOR gate as a controlled inverter | Theory + Code | [notes/pdf_q47_xor_controlled_inverter.md](notes/pdf_q47_xor_controlled_inverter.md), [qa/pdf_q47/q47_xor_controlled_inverter.v](qa/pdf_q47/q47_xor_controlled_inverter.v) |
| 48 | Design inverter, AND, OR, and XOR using only NAND gates | Theory + Code | [notes/pdf_q48_gates_using_only_nand.md](notes/pdf_q48_gates_using_only_nand.md), [qa/pdf_q48/q48_gates_using_nand.v](qa/pdf_q48/q48_gates_using_nand.v) |
| 49 | Create a 4:1 mux using 2:1 muxes | Theory + Code | [notes/pdf_q49_mux4_using_mux2.md](notes/pdf_q49_mux4_using_mux2.md), [qa/pdf_q49/q49_mux4_from_mux2.v](qa/pdf_q49/q49_mux4_from_mux2.v) |
| 50 | Frequency, period, propagation delay, and maximum frequency | Theory | [notes/pdf_q50_frequency_period_propagation_delay.md](notes/pdf_q50_frequency_period_propagation_delay.md) |
| 51 | Convert decimal 13 to binary, hexadecimal, and octal | Theory | [notes/pdf_q51_decimal_13_conversions.md](notes/pdf_q51_decimal_13_conversions.md) |
