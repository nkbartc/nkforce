(*An even function*)

let even int =
  if int mod 2 = 0 then true else false

(*Euclid's GCD algorithm*)

let rec euclid a b =
  if a < b then euclid a (b-a)       (*gcd(a,b) = gcd(a, b-a), if a<b*)
  else if a > b then euclid (a-b) b  (*gcd(a,b) = gcd(a-b,b) if a>b*)
  else a                             (*gcd(a,b) = a, if a = b*)

(*Simplifying fractions*)

let frac_simplify (a,b) =
  let gcd = euclid a b      (*use euclid as helper*)
  in
  if gcd = 1 then (a,b)     (*gcd = 1. can't simplify any further*)
  else ((a/gcd),(b/gcd))    (*gcd != 1. we can simplify it*)

(*Max in a list of integers*)

let rec max : int list -> int = fun x ->  (*specify the function's type*)
  match x with
  | [] -> raise (Failure "Input list must not be empty")
  | x :: [] -> x
  | x1 :: x2 :: rest -> if x1 > x2 then max (x1::rest)
                        else if x1 < x2 then max (x2::rest)
                        else max (x1::rest)

(*Taking elements from a list*)

let rec take num list = if num < 0 then [] else
  match list with
  | [] -> []
  | x :: rest -> if num = 0 then []
                 else x :: take (num -1) rest
