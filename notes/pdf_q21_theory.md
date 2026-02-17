# PDF Theory Notes (Q21)

## 21) Find maximum and second maximum with least comparators

- Lowest-area streaming approach:
  use two registers (`max1`, `max2`) and one shared comparator.
- For each incoming number:
  first compare with `max1`; if not larger, compare with `max2`.
- This can be done with one comparator reused across two FSM states.
- Tradeoff:
  low area, but one sample may take up to 2 cycles.

## Fastest approach

- Use parallel tournament/tree comparisons (winner bracket) to find max quickly.
- Keep losers along winner path, then find second max from that loser set.
- Add pipeline stages for higher clock speed and throughput.
- Tradeoff:
  more comparators/registers for lower latency and higher bandwidth.
