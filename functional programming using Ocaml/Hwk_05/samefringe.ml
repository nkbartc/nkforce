type 'a bintree
  = Lf of 'a
  | Nd of 'a bintree * 'a bintree

let t1 = Nd(Nd(Lf(1), Lf(2)), Nd(Lf(3), Lf(4)))
and t2 = Nd(Lf(1), Nd(Lf(2), Nd(Lf(3), Lf(4))))
and t3 = Nd(Nd(Nd(Lf(1), Lf(2)), Lf(3)), Lf(4))
and t4 = Nd(Lf(4), Nd(Lf(3), Nd(Lf(2), Lf(1))))
and t5 = Nd(Nd(Nd(Lf(4), Lf(3)), Lf(2)), Lf(1))

(* Trees t1, t2, and t3 have the same fringe. *)
(* Trees t4 and t5 have the same fringe. *)

type 'a lazee = 'a hidden ref
and 'a hidden
	= Value of 'a
	| Thunk of (unit -> 'a);;

let delay (unit_to_x: unit -> 'a) : 'a lazee = ref (Thunk unit_to_x)

let force (l: 'a lazee) : unit = match !l with
  | Value _ -> ()
  | Thunk f -> l := Value (f ())

let rec demand (l: 'a lazee) : 'a =
  force l;
  match !l with
  | Value v -> v
  | Thunk f -> raise (Failure "this should not happen")


type 'a lazy_list
  = Cons of 'a * 'a lazy_list lazee
  | Nil

let rec append_lazy (l1: 'a lazy_list) (l2: 'a lazy_list) : 'a lazy_list =
  match l1 with
  | Nil -> l2
  | Cons(v, tl) -> Cons(v, delay(fun () -> append_lazy (demand tl) l2))

let rec equal_list_lazy (l1: 'a lazy_list) (l2: 'a lazy_list) : bool =
  match (l1, l2) with
  | (Nil, Nil) -> true
  | (Cons(v1,tl1), Cons(v2,tl2)) -> v1 = v2 && equal_list_lazy (demand tl1) (demand tl2)
  | _ -> false

let rec flatten_lazy (t: 'a bintree) : 'a lazy_list =
  match t with
  | Lf(x) -> Cons(x, delay(fun () -> Nil))
  | Nd(l, r) -> append_lazy (flatten_lazy l) (flatten_lazy r)

let eqleaves_lazy (t1: 'a bintree) (t2: 'a bintree) : bool =
  equal_list_lazy (flatten_lazy t1) (flatten_lazy t2)

(*The reason why eqleaves_lazy uses less space than eqleaves_strict is because
eqleaves_Lazy(lazy evaluation) doesn't require all the values at a time. No
memory is needed until a certain value needs to be computed necessarily.*)
