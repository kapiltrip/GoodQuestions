# PDF Q52) Four Gallons of Water

## Question

Using only:

- one 5-gallon bucket
- one 3-gallon bucket
- unlimited water
- no measurement markings

measure exactly:

```text
4 gallons in the 5-gallon bucket
```

## Direct Answer

Track the state as:

```text
(amount in 5-gallon bucket, amount in 3-gallon bucket)
```

Start:

```text
(0, 0)
```

Steps:

```text
1. Fill the 5-gallon bucket.
   (5, 0)

2. Pour from the 5-gallon bucket into the 3-gallon bucket until the 3-gallon bucket is full.
   (2, 3)

3. Empty the 3-gallon bucket.
   (2, 0)

4. Pour the remaining 2 gallons from the 5-gallon bucket into the 3-gallon bucket.
   (0, 2)

5. Fill the 5-gallon bucket again.
   (5, 2)

6. Top off the 3-gallon bucket using water from the 5-gallon bucket.
   The 3-gallon bucket already has 2 gallons, so it needs only 1 more gallon.
   (4, 3)
```

Now the 5-gallon bucket contains:

```text
4 gallons
```

## Why This Works

The key is to create a known leftover amount.

First:

```text
5 - 3 = 2
```

So after filling the 5-gallon bucket and pouring into the 3-gallon bucket, the 5-gallon bucket has exactly 2 gallons left.

Then put that 2 gallons into the 3-gallon bucket.

Now the 3-gallon bucket has:

```text
2 gallons
```

If the 3-gallon bucket has 2 gallons, it needs exactly:

```text
3 - 2 = 1 gallon
```

to become full.

So when you refill the 5-gallon bucket and use it to top off the 3-gallon bucket, exactly 1 gallon leaves the 5-gallon bucket.

Therefore:

```text
5 - 1 = 4 gallons
```

remain in the 5-gallon bucket.

## Alternate Solution

This version starts with the 3-gallon bucket.

State:

```text
(5-gallon bucket, 3-gallon bucket)
```

Steps:

```text
1. Fill the 3-gallon bucket.
   (0, 3)

2. Pour it into the 5-gallon bucket.
   (3, 0)

3. Fill the 3-gallon bucket again.
   (3, 3)

4. Pour from the 3-gallon bucket into the 5-gallon bucket until the 5-gallon bucket is full.
   The 5-gallon bucket has 3 gallons, so it needs 2 more.
   That leaves 1 gallon in the 3-gallon bucket.
   (5, 1)

5. Empty the 5-gallon bucket.
   (0, 1)

6. Pour the 1 gallon from the 3-gallon bucket into the 5-gallon bucket.
   (1, 0)

7. Fill the 3-gallon bucket again.
   (1, 3)

8. Pour the 3 gallons into the 5-gallon bucket.
   (4, 0)
```

Now the 5-gallon bucket contains:

```text
4 gallons
```

## General Method

For bucket problems, the possible measurable quantities are connected to the greatest common divisor:

```text
gcd(bucket1, bucket2)
```

Here:

```text
gcd(5, 3) = 1
```

Because `1` divides `4`, measuring 4 gallons is possible.

If the buckets were, for example:

```text
6 gallons and 4 gallons
```

then:

```text
gcd(6, 4) = 2
```

Only even amounts can be measured exactly.

## Interview Answer

Fill the 5-gallon bucket, pour into the 3-gallon bucket, leaving 2 gallons in the 5-gallon bucket. Empty the 3-gallon bucket, then pour the 2 gallons into it. Fill the 5-gallon bucket again. The 3-gallon bucket already has 2 gallons, so it needs only 1 more gallon. Use the 5-gallon bucket to top it off; exactly 1 gallon is removed from the 5-gallon bucket, leaving exactly 4 gallons.
