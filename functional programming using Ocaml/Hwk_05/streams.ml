(* The code below is from Professor Eric Van Wyk. *)

(* Types and functions for lazy values *)
type 'a lazee = 'a hidden ref

 and 'a hidden = Value of 'a
               | Thunk of (unit -> 'a)

let delay (unit_to_x: unit -> 'a) : 'a lazee = ref (Thunk unit_to_x)

let force (l: 'a lazee) : unit = match !l with
  | Value _ -> ()
  | Thunk f -> l := Value (f ())

let rec demand (l: 'a lazee) : 'a =
  force l;
  match !l with
  | Value v -> v
  | Thunk f -> raise (Failure "this should not happen")

(* Streams, using lazy values *)
type 'a stream = Cons of 'a * 'a stream lazee

let rec take (n:int) (s : 'a stream) : ('a list) =
 match n, s with
 | 0, _ -> []
 | _, Cons (v, tl) -> v :: take (n-1) (demand tl)

let rec zip (f: 'a -> 'b -> 'c) (s1: 'a stream) (s2: 'b stream) : 'c stream =
  match s1, s2 with
  | Cons (hd1, tl1), Cons (hd2, tl2) ->
    Cons (f hd1 hd2, delay (fun () -> zip f (demand tl1) (demand tl2)))

let rec from n =
  Cons ( n,
         delay (fun () -> from (n+1) )
       )

let rec map (f: 'a -> 'b) (s: 'a stream) : 'b stream =
  match s with
  | Cons (hd, tl) ->
    Cons (f hd, delay (fun () -> map f (demand tl)))

let head (s: 'a stream) : 'a = match s with
  | Cons (v, _) -> v

let tail (s: 'a stream) : 'a stream = match s with
  | Cons (_, tl) -> demand tl

(* The code below is from Ju-Yu, Chou Fu *)

let rec cubes_from (x: int) : int stream =
  Cons(x*x*x, delay(fun () -> cubes_from (x+1)))

let cubes_from_zip (x: int) : int stream =
  let step1 = zip ( * ) (from x) (from x)
  in
  zip ( * ) step1 (from x)

let cubes_from_map (x: int) : int stream =
  map ( fun x -> x*x*x ) (from x)

let rec drop (n: int) (s: 'a stream) : 'a stream =
  match n, s with
  | 0, _ -> s
  | _, Cons (v, tl) -> drop (n-1) (demand tl)

let rec drop_until (f: 'a -> bool) (s: 'a stream) : 'a stream =
  match s with
  | Cons (hd, tl) -> if f hd then Cons (hd, tl)
                     else drop_until f (demand tl)

(*from the work of part1, we can picture that the 1st argument needs to be
a result type and the 2nd argument doesn't need to be computed right away,
but needs to be computed later (call by name). So, we can set the 2nd as a
lazee type.In our foldr function, we first use pattern match. The input lambda
functiontakes hd as the 1st argument and needs stream lazee for the 2nd
argument. So, we need to use delay to transfer the result type given by the
recursive call to a lazee type *)
let rec foldr (f: 'a -> 'b lazee -> 'b ) (s: 'a stream) : 'b =
  match s with
  | Cons (hd, tl) -> f hd (delay(fun () -> foldr f (demand tl)))

let rec and_fold (s: bool stream) : bool =
  match s with
  | Cons (hd, tl) -> if hd then and_fold (demand tl)
                     else false

let sum_positive_prefix (s: int stream) : int =
  foldr (fun x y -> if x > 0 && (demand y) > 0
                    then x + (demand y) else x + 0) s

let rec sift (n: int) (s: int stream) : int stream =
  match s with
  | Cons (hd, tl) -> if (hd mod n) <> 0
                     then Cons(hd, delay (fun () -> sift n (demand tl)))
                     else sift n (demand tl)

let rec sieve (s: int stream) : int stream =
  match s with
  | Cons (hd, tl) -> let temp = sift hd (demand tl)
                     in
                     Cons(hd, delay(fun () -> sieve temp))
