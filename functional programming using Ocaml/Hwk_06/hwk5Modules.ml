open StreamModules

module type Hwk5Sig = sig
  type 'a stream
  val take: int -> 'a stream -> 'a list
  val head: 'a stream -> 'a
  val zip: ('a -> 'b -> 'c) -> 'a stream -> 'b stream -> 'c stream

  val from: int -> int stream
  val nats: int stream
  val cubes_from: int -> int stream
  val cubes_from_zip: int -> int stream
  val cubes_from_map: int -> int stream
  val drop: int -> 'a stream -> 'a stream
  val drop_until: ('a -> bool) -> 'a stream -> 'a stream
  val sum_positive_prefix: int stream -> int
  val primes: int stream
end

module Hwk5(S: StreamSig) : Hwk5Sig = struct
   (* add elements here to complete the functor *)
   type 'a stream = 'a S.t
   let take = S.take
   let head = S.head
   let zip  = S.zip

   let rec from (n: int) : int stream =
     S.Cons (n,
            S.delay (fun () -> from (n+1) )
            )
   let nats : int stream = from 1

   let rec cubes_from (n: int) : int stream =
    S.Cons (n*n*n, S.delay(fun () -> cubes_from (n+1)))

   let cubes_from_zip (n: int) : int stream =
    let step1 = zip ( * ) (from n) (from n)
    in
    zip ( * ) step1 (from n)

   let cubes_from_map (n: int) : int stream =
    S.map ( fun n -> n*n*n ) (from n)

   let rec drop (n: int) (s: 'a stream) : 'a stream =
    match n, s with
    | 0, _ -> s
    | _, S.Cons (v, tl) -> drop (n-1) (S.demand tl)

   let rec drop_until (f: 'a -> bool) (s: 'a stream) : 'a stream =
    match s with
    | S.Cons (hd, tl) -> if f hd then S.Cons (hd, tl)
                       else drop_until f (S.demand tl)

   let rec foldr (f: 'a -> 'b S.lazee -> 'b ) (s: 'a stream) : 'b =
    match s with
    | S.Cons (hd, tl) -> f hd (S.delay(fun () -> foldr f (S.demand tl)))

   let sum_positive_prefix (s: int stream) : int =
    foldr (fun x y -> if x > 0 && (S.demand y) > 0
                      then x + (S.demand y) else x + 0) s

   let rec sift (n: int) (s: int stream) : int stream =
    match s with
    | S.Cons (hd, tl) -> if (hd mod n) <> 0
                       then S.Cons(hd, S.delay (fun () -> sift n (S.demand tl)))
                       else sift n (S.demand tl)

   let rec sieve (s: int stream) : int stream =
    match s with
    | S.Cons (hd, tl) -> let temp = sift hd (S.demand tl)
                       in
                       S.Cons(hd, S.delay(fun () -> sieve temp))

   let primes : int stream = sieve (from 2)

end
