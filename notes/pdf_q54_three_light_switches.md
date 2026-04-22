# PDF Q54) The Three Light Switches

## Question

There are three switches in the basement.

Each switch controls one lamp upstairs.

Rules:

- all switches start off
- you may toggle switches any number of times
- you may go upstairs only once
- after going upstairs, you must identify which switch controls which lamp

## Direct Answer

Use three observable lamp states:

```text
on
off but warm
off and cold
```

Steps:

```text
1. Turn Switch 1 on.
2. Leave it on for several minutes.
3. Turn Switch 1 off.
4. Turn Switch 2 on.
5. Leave Switch 3 off.
6. Go upstairs.
```

Now inspect the lamps:

```text
lamp that is on           -> Switch 2
lamp that is off but warm -> Switch 1
lamp that is off and cold -> Switch 3
```

## Why This Works

If you only use on/off state, one upstairs trip gives only two visible categories:

```text
on
off
```

But there are three switches.

The trick is to use heat as extra information.

An incandescent bulb that was on for a while and then turned off remains warm for some time.

So the three switches create three different lamp states:

```text
Switch 1: was on, now off -> lamp is off but warm
Switch 2: is on           -> lamp is on
Switch 3: never on        -> lamp is off and cold
```

This gives exactly three distinguishable outcomes.

## State Table

```text
Switch | Action before going upstairs       | Lamp state upstairs
-------+------------------------------------+--------------------
S1     | on for a while, then turned off    | off but warm
S2     | turned on and left on              | on
S3     | left off the whole time            | off and cold
```

## Digital Design Analogy

This puzzle is really about adding another observable state.

With only light output:

```text
0 = off
1 = on
```

you can distinguish only two classes.

With heat/history:

```text
off and cold
off but warm
on
```

you can distinguish three classes.

In hardware terms, the bulb temperature acts like memory. It records that the switch was previously on.

## Interview Answer

Turn Switch 1 on and leave it on for a few minutes. Then turn Switch 1 off, turn Switch 2 on, and leave Switch 3 off. Go upstairs once. The lamp that is on belongs to Switch 2. The lamp that is off but still warm belongs to Switch 1. The lamp that is off and cold belongs to Switch 3.
