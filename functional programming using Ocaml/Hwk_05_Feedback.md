# Hwk_05 Feedback

Run on April 10, 14:47:58 PM.

**Change log:**
+ Wednesday, April 4: (Sean) Minor test adjustments.
+ Saturday, March 31: (Nathan) Extra credit tests.
+ Friday, March 30: (Sean) Initial version.


## Introduction

+ Pass: Change into directory "Hwk_05".

## Part 1: Evaluating expressions by hand

We will assess this part manually.

+ Pass: Check that file "question_1.txt" exists.

+ Pass: Check that file "question_2.txt" exists.

## Part 2: Efficiently computing the conjunction of a list of Boolean values

We will also assess this part manually.

+ Pass: Check that file "lazy_and.ml" exists.

+ Pass: Check that an OCaml file "lazy_and.ml" has no syntax or type errors.

    OCaml file "lazy_and.ml" has no syntax or type errors.



+ Pass: Check that an OCaml file "lazy_and.ml" has warnings.

    OCaml file "lazy_and.ml" has no warnings.



+ Pass: 
Check that the result of evaluating
   ```
   ands [true; false; true]
   ```
   matches the pattern `false`.

   




+ Pass: 
Check that the result of evaluating
   ```
   ands [true; true; true]
   ```
   matches the pattern `true`.

   




+ Pass: 
Check that the result of evaluating
   ```
   ands []
   ```
   matches the pattern `true`.

   




## Part 3: Implementing Streams in OCaml

+ Pass: Check that file "streams.ml" exists.

+ Pass: Check that an OCaml file "streams.ml" has no syntax or type errors.

    OCaml file "streams.ml" has no syntax or type errors.



+ Pass: Check that an OCaml file "streams.ml" has warnings.

    OCaml file "streams.ml" has no warnings.



### Check: Did you copy `lazy.ml` into your file?

+ Pass: 
Check that the result of evaluating
   ```
   demand (delay (fun () -> ()))
   ```
   matches the pattern `()`.

   




+ Pass: 
Check that the result of evaluating
   ```
   force (ref (Value ()))
   ```
   matches the pattern `()`.

   




+ Pass: 
Check that the result of evaluating
   ```
   demand (ref (Value ()))
   ```
   matches the pattern `()`.

   




### 3.1-3.7

The following tests use helpers from `lazy.ml`.

+ Pass: 
Check that the result of evaluating
   ```
   head (tail (cubes_from_map 5))
   ```
   matches the pattern `216`.

   




+ Pass: 
Check that the result of evaluating
   ```
   head (tail (cubes_from 5))
   ```
   matches the pattern `216`.

   




+ Pass: 
Check that the result of evaluating
   ```
   not (and_fold ns_positive)
   ```
   matches the pattern `true`.

   




+ Pass: 
Check that the result of evaluating
   ```
   head (tail (tail (sieve (from 2))))
   ```
   matches the pattern `5`.

   




+ Pass: 
Check that the result of evaluating
   ```
   head (tail (drop 3 (cubes_from 3)))
   ```
   matches the pattern `343`.

   




+ Pass: 
Check that the result of evaluating
   ```
   head (drop_until (fun v -> v > 35) nats)
   ```
   matches the pattern `36`.

   




+ Pass: 
Check that the result of evaluating
   ```
   sum_positive_prefix (zip (+) ns ns)
   ```
   matches the pattern `14040`.

   




+ Pass: 
Check that the result of evaluating
   ```
   head (tail (cubes_from_zip 5))
   ```
   matches the pattern `216`.

   




## Extra Credit

+ Pass: Check that file "samefringe.ml" exists.

+ Pass: Check that an OCaml file "samefringe.ml" has no syntax or type errors.

    OCaml file "samefringe.ml" has no syntax or type errors.



+ Pass: Check that an OCaml file "samefringe.ml" has warnings.

    OCaml file "samefringe.ml" has no warnings.



+ Pass: 
Check that the result of evaluating
   ```
   eqleaves_lazy t1 t3
   ```
   matches the pattern `true`.

   




+ Pass: 
Check that the result of evaluating
   ```
   eqleaves_lazy t1 t5
   ```
   matches the pattern `false`.

   




+ Pass: 
Check that the result of evaluating
   ```
   eqleaves_lazy t3 t1
   ```
   matches the pattern `true`.

   




+ Pass: 
Check that the result of evaluating
   ```
   eqleaves_lazy t3 t5
   ```
   matches the pattern `false`.

   




+ Pass: 
Check that the result of evaluating
   ```
   eqleaves_lazy t5 t1
   ```
   matches the pattern `false`.

   




+ Pass: 
Check that the result of evaluating
   ```
   eqleaves_lazy t5 t3
   ```
   matches the pattern `false`.

   




## Extlint

Various code style and organization checks are run on your code to detect common errors.

A description of the checks can be found here:  https://github.umn.edu/umn-csci-2041-S18/public-class-repo/blob/master/Course%20Info/extlint.md

### `streams.ml`

+ Pass: Check that file "streams.ml" exists.

+ Pass: **All extlint tests passed!**

### `lazy_and.ml`

+ Pass: Check that file "lazy_and.ml" exists.

+ Pass: **All extlint tests passed!**

### `samefringe.ml`

+ Pass: Check that file "samefringe.ml" exists.

+ Pass: **All extlint tests passed!**

