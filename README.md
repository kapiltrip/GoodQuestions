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
| 15 | Generate `start` and rotating `chip_select` pulses from timing | Code | [qa/pdf_q12_q18/q15_start_and_chipselects.v](qa/pdf_q12_q18/q15_start_and_chipselects.v) |
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
