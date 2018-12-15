-------------------------------------------------------------------------------
# Hwk_05 Manual Assessment

This document was generated on April 12, 21:43:40 PM.

*Results are for this repository as it appeared on 
2018-04-05 17:15.*

**Changelog:**
+ Wednesday, April 11: Initial version.


## Introduction

This is the manual assessment for Hwk_05 (not including extra credit). You
should also have an automated assessment, `Hwk_05_Assessment.md`, in your
repository. A manual assessment for the extra credit will appear within a week
after the extra credit due date, if applicable.

Note: If you received full points for a problem and your grader left no
comments, you get an animal fact. ([Source](https://www.mnn.com/earth-matters/animals/blogs/36-random-animal-facts-that-may-surprise-you))


## Part 1: Evaluating expressions by hand

### Question 1

+ _1_ / _1_ : Check for name and Internet ID.
+ _3_ / _3_ : Check call by value evaluation.
+ _2_ / _3_ : Check call by name evaluation.
+ _3_ / _3_ : Check lazy (call by need) evaluation.

#### Comments

Call by Name - Evalutating evens_from when not necessary


### Question 2

+ _1_ / _1_ : Check for name and Internet ID.
+ _3_ / _3_ : Check call by value for `andr`.
+ _3_ / _3_ : Check call by name for `andr`.
+ _3_ / _3_ : Check call by value for `andl`.
+ _2_ / _3_ : Check call by name for `andl`.
+ _3_ / _3_ : Check for statement on which evaluation is most efficient and why.

#### Comments

andl - Call by Name - the call to the outtermost and would have been made first
andr - Call by Name - be careful with your parenthesis.


## Part 2: Efficiently computing the conjunction of a list of Boolean values

+ _6_ / _6_ : Check if `ands` avoids examining the entire list unless necessary.

### Comments

Less time separates the existence of humans and the tyrannosaurus rex than the T-rex and the stegosaurus.


## Part 3: Implementing Streams in OCaml

### 3.1 ``cubes_from``

No manual assessment for this objective.

### 3.2 ``cubes_from_zip``

+ _1_ / _1_ : Check if `cubes_from_zip` uses `zip`.

### 3.3 ``cubes_from_map``

+ _1_ / _1_ : Check if `cubes_from_map` uses `map`.

### 3.4 ``drop``

No manual assessment for this objective.

### 3.5 ``drop_until``

No manual assessment for this objective.

### 3.6 ``foldr``, ``and_fold``, and ``sum_positive_prefix``

+ _3_ / _3_ : Check if `foldr` has the correct type annotations.
+ _1_ / _1_ : Check if `foldr`'s type includes `lazee`.
+ _1_ / _1_ : Check if `foldr` has exactly two input arguments.
+ _10_ / _10_ : Check for comment explaining `foldr`'s type and how it works.
+ _5_ / _5_ : Inspect `foldr` function definition.

#### Comments

Dogs' sense of smell is about 100,000 times stronger than humans', but they have just one-sixth our number of taste buds.

#### ``and_fold``

+ _0_ / _1_ : Check if `and_fold` uses `foldr`.

#### ``sum_positive_prefix``

+ _1_ / _1_ : Check if `sum_positive_prefix` uses `foldr`.

### 3.7 The Sieve of Eratosthenes, "``sieve``"

#### The ``sieve`` function

This inspection is mostly for partial credit if your `sieve` function does not
work for the automated tests. You will lose points here if your `sieve`
definition exhibits conceptual errors, is hard to understand, or is missing.

+ _10_ / _10_ : Inspect `sieve` function definition for partial credit.


## Turning in your work

As mentioned in the homework protocol, this part of your score is based on your
code quality.

+ _10_ / _10_ : Writing transparent code.

### Comments

Less time separates the existence of humans and the tyrannosaurus rex than the T-rex and the stegosaurus.

## End of Manual Assessment

**Total score: _73_ / _76_**

Add this score to your total for automated tests in `Hwk_05_Assessment.md`. The
sum is your score for Hwk_05 (out of 100).

-------------------------------------------------------------------------------


