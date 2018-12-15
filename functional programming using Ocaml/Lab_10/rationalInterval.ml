open Intervals

let rec euclid a b =
  if a < b then euclid a (b-a)       (*gcd(a,b) = gcd(a, b-a), if a<b*)
  else if a > b then euclid (a-b) b  (*gcd(a,b) = gcd(a-b,b) if a>b*)
  else a

let frac_simplify (a,b) =
  let gcd = euclid a b      (*use euclid as helper*)
  in
  if gcd = 1 then (a,b)     (*gcd = 1. can't simplify any further*)
  else ((a/gcd),(b/gcd))    (*gcd != 1. we can simplify it*)

module Rational_comparable : (Comparable with type t = int * int) = struct
  type t = int * int
  let compare (x1,y1) (x2,y2) = if y2 * x1 > x2 * y1 then 1 else if  y2 * x1 < x2 * y1  then -1 else 0
  let to_string (x,y) = let (a, b) = frac_simplify (x,y)
                        in
                        string_of_int a ^ "/" ^ string_of_int b

end

module Rational_interval = Make_interval(Rational_comparable)



(* The following line now works. *)
let i = Rational_interval.create (3, 4) (5,6)
