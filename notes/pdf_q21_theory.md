# PDF Theory Notes (Q21)

## 21) Find maximum and second maximum with least comparators

- The question is really asking for a tradeoff:
  how to get both the largest and second-largest values while minimizing comparator hardware.
- If comparator count is the priority, the clean answer is a streaming design with:
  two result registers and one reused comparator.

### Core idea

Keep:

- `max1` = largest value seen so far
- `max2` = second-largest value seen so far

For every new sample:

1. compare it with `max1`
2. if it is not larger than `max1`, compare it with `max2`

That means one comparator can be reused across two cycles/states instead of building two separate comparators.

### Update rules

For a new sample `x`:

- If there is no valid `max1` yet:
  `max1 = x`
- Else if `x >= max1`:
  old `max1` shifts down into `max2`, and `x` becomes new `max1`
- Else if there is no valid `max2` yet, or `x >= max2`:
  `x` becomes new `max2`
- Else:
  ignore `x`

So the important cases are:

```text
if x >= max1:
    max2 <- max1
    max1 <- x
else if x >= max2:
    max2 <- x
```

### Why an FSM is useful here

In the low-area version, one comparator is shared:

- state `CMP1`: compare sample against `max1`
- state `CMP2`: only if needed, compare the same sample against `max2`

So one incoming sample may take:

- 1 cycle if it becomes the new maximum immediately
- 2 cycles if it must also be checked against `max2`

This is the area/latency tradeoff.

### Why this uses the least comparator hardware

If you want to compare against both `max1` and `max2` in the same cycle, you usually need more comparison hardware.
If you reuse one comparator over multiple cycles, hardware area drops, but throughput/latency gets worse.

So the low-area answer is:

- fewer comparators
- more sequential control
- possibly lower throughput

### What to mention in theory/interview

There are two common solution styles:

1. **Low-area streaming solution**
   - one comparator
   - two registers (`max1`, `max2`)
   - FSM/control over multiple cycles

2. **Faster parallel solution**
   - more comparators
   - compare values in parallel, often using a tournament/tree structure
   - lower latency and higher throughput

### Fastest approach

- Use parallel tournament/tree comparisons (winner bracket) to find max quickly.
- Keep losers along winner path, then find second max from that loser set.
- Add pipeline stages for higher clock speed and throughput.
- Tradeoff:
  more comparators/registers for lower latency and higher bandwidth.

### Final takeaway

- If the question emphasizes least comparators, reuse one comparator and accept extra cycles.
- If the question emphasizes speed, use parallel comparisons and accept more area.
