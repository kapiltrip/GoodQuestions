# PDF Q56) Einstein's Riddle

## Question

There are five houses in a row.

Each house has:

- one color
- one nationality
- one drink
- one cigar brand
- one pet

No two houses share the same value in any category.

Clues:

```text
1.  The Brit lives in the red house.
2.  The Swede keeps dogs as pets.
3.  The Dane drinks tea.
4.  The green house is immediately left of the white house.
5.  The green house's owner drinks coffee.
6.  The owner who smokes Pall Mall rears birds.
7.  The owner of the yellow house smokes Dunhill.
8.  The owner living in the center house drinks milk.
9.  The Norwegian lives in the first house.
10. The owner who smokes Blends lives next to the one who keeps cats.
11. The owner who keeps horses lives next to the one who smokes Dunhill.
12. The owner who smokes Bluemasters drinks beer.
13. The German smokes Prince.
14. The Norwegian lives next to the blue house.
15. The owner who smokes Blends lives next to the one who drinks water.
```

Question:

```text
Who owns the fish?
```

## Direct Answer

```text
The German owns the fish.
```

Final arrangement:

```text
House | Color  | Nationality | Drink  | Pet   | Cigar
------+--------+-------------+--------+-------+------------
1     | Yellow | Norwegian   | Water  | Cats  | Dunhill
2     | Blue   | Dane        | Tea    | Horse | Blends
3     | Red    | Brit        | Milk   | Birds | Pall Mall
4     | Green  | German      | Coffee | Fish  | Prince
5     | White  | Swede       | Beer   | Dogs  | Bluemasters
```

## Step-by-Step Reasoning

Number the houses:

```text
1 2 3 4 5
```

From clues:

```text
Norwegian is in house 1.
Milk is in house 3.
Norwegian lives next to blue house.
```

Since house 1 has only one neighbor, house 2 must be blue:

```text
House 1: Norwegian
House 2: Blue
House 3: Milk
```

## Placing Green and White

The green house is immediately left of the white house.

Possible adjacent pairs:

```text
1-2
2-3
3-4
4-5
```

But house 2 is blue, so green/white cannot use `1-2` or `2-3`.

House 3 has milk, and green drinks coffee, so house 3 cannot be green.

That leaves:

```text
Green = house 4
White = house 5
```

So:

```text
House 4: Green, Coffee
House 5: White
```

## Placing Red, Brit, Yellow, and Dunhill

The Brit lives in the red house.

Known colors:

```text
House 2 = Blue
House 4 = Green
House 5 = White
```

Remaining colors:

```text
Red
Yellow
```

for houses:

```text
1 and 3
```

House 1 has Norwegian, so it cannot be Brit. Therefore house 1 cannot be red.

So:

```text
House 3 = Red, Brit
House 1 = Yellow
```

The yellow house owner smokes Dunhill:

```text
House 1: Yellow, Norwegian, Dunhill
```

## Using Horse Next to Dunhill

The horse owner lives next to the Dunhill smoker.

Dunhill is in house 1.

House 1 has only one neighbor:

```text
House 2
```

Therefore:

```text
House 2: Horse
```

## Drinks

Known drinks:

```text
House 3 = Milk
House 4 = Coffee
```

The Dane drinks tea.

The Bluemasters smoker drinks beer.

The remaining drinks are:

```text
Tea, Beer, Water
```

for houses:

```text
1, 2, 5
```

House 1 is Norwegian, so it is not Dane. Therefore house 1 does not drink tea.

House 1 also smokes Dunhill, so it cannot be Bluemasters and therefore cannot be beer.

So house 1 must drink water:

```text
House 1: Water
```

Now clue 15 says the Blends smoker lives next to the one who drinks water.

Water is house 1, so Blends must be next door:

```text
House 2: Blends
```

The Dane drinks tea. House 2 is not yet assigned nationality and house 2 has no drink yet, so:

```text
House 2: Dane, Tea
```

Then the remaining drink for house 5 is:

```text
Beer
```

and the Bluemasters smoker drinks beer:

```text
House 5: Beer, Bluemasters
```

## Nationalities and Cigars

Known nationalities:

```text
House 1 = Norwegian
House 2 = Dane
House 3 = Brit
```

Remaining:

```text
German
Swede
```

Known cigars:

```text
House 1 = Dunhill
House 2 = Blends
House 5 = Bluemasters
```

Remaining:

```text
Pall Mall
Prince
```

The German smokes Prince.

The Pall Mall smoker keeps birds.

House 5 already smokes Bluemasters, so house 5 cannot be German because the German smokes Prince.

Therefore:

```text
House 4 = German, Prince
House 5 = Swede
```

The Swede keeps dogs:

```text
House 5 = Dogs
```

The remaining cigar for house 3 is:

```text
Pall Mall
```

The Pall Mall smoker keeps birds:

```text
House 3 = Birds
```

## Pets

Known pets:

```text
House 2 = Horse
House 3 = Birds
House 5 = Dogs
```

Remaining pets:

```text
Cats
Fish
```

Clue 10 says:

```text
The Blends smoker lives next to the one who keeps cats.
```

Blends is in house 2.

House 2's neighbors are:

```text
House 1
House 3
```

House 3 has birds, so house 1 must have cats:

```text
House 1 = Cats
```

The only remaining pet is fish:

```text
House 4 = Fish
```

House 4 is German.

Therefore:

```text
The German owns the fish.
```

## Final Table

```text
House | Color  | Nationality | Drink  | Pet   | Cigar
------+--------+-------------+--------+-------+------------
1     | Yellow | Norwegian   | Water  | Cats  | Dunhill
2     | Blue   | Dane        | Tea    | Horse | Blends
3     | Red    | Brit        | Milk   | Birds | Pall Mall
4     | Green  | German      | Coffee | Fish  | Prince
5     | White  | Swede       | Beer   | Dogs  | Bluemasters
```

## Interview Answer

The German owns the fish. The final arrangement is: house 1 is yellow, Norwegian, water, cats, Dunhill; house 2 is blue, Dane, tea, horse, Blends; house 3 is red, Brit, milk, birds, Pall Mall; house 4 is green, German, coffee, fish, Prince; and house 5 is white, Swede, beer, dogs, Bluemasters.
