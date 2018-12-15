(*the invariants for binomial tree:
  1. every tree must have correct rank
  2. every tree must have correct number of children in its tree list
  3. a binomial tree must obey the minimum heap property

  the invariants for binomial:
  1. all member in the list must be a binomial tree
  2. all member must not have the same rank
  3. all members must be stored in increasing order of rank
*)

open Ordered

module type BinomialHeapSig = sig
  type elem
  type tree = Node of int * elem * tree list
  type t = tree list

  val isBinomialTree: tree -> bool
  val isBinomialHeap: t -> bool
  val empty: t
  val rank: tree -> int
  val root: tree -> elem
  val insert: elem -> t -> t
  val merge: t -> t -> t
  val findMin: t -> elem
  val findMinDirect: t -> elem
  val deleteMin: t -> t
  end

  module BinomialHeap (O:OrderedSig) : (BinomialHeapSig with type elem = O.t) = struct
    type elem = O.t
    type tree = Node of int * elem * tree list
    type t = tree list

    let leq = O.leq

    let empty = []

    let rank n =
      match n with
      | Node (r, x, c) -> r

    let root n =
      match n with
      | Node (r, x, c) -> x

    let link t1 t2 =
      match t1, t2 with
      | Node (r, x1, c1), Node (_, x2, c2) ->
        if leq x1 x2 then Node (r+1, x1, t2::c1)
        else Node (r+1, x2, t1::c2)

    let rec insTree t1 t2 = match t1,t2 with
      | t, [] -> [t]
      | t, (x::xs) ->
        if rank t < rank x
        then t::(x::xs)
        else insTree (link t x) xs

    let insert x ts = insTree (Node (0, x, [])) ts

    let rec merge trees1 trees2 = match trees1, trees2 with
      | ts1, [] -> ts1
      | [], ts2 -> ts2
      | (t1::ts1), (t2::ts2) ->
        if rank t1 < rank t2
        then t1::(merge ts1 (t2::ts2))
        else if rank t2 < rank t1
        then t2::(merge (t1::ts1) ts2)
        else insTree (link t1 t2) (merge ts1 ts2)

    let findMinDirect o_heap =
      match o_heap with
      | [] -> raise (Failure "empty")
      | x::_ -> let rec helper trees cur =
                match trees with
                | t1::t2::ts -> if root t1 < root t2
                                then helper (t1::ts) (root t1)
                                else helper (t2::ts) (root t2)
                | [t1] -> root t1
                | _ -> cur
                in helper o_heap (root x)


    let rec removeMinTree trees = match trees with
      | [] -> raise (Failure "empty")
      | [t] -> (t, [])
      | t::ts ->
        let (t', ts') = removeMinTree ts
        in
        if root t < root t'
        then (t, ts)
        else (t', t::ts')

    let findMin ts = let (t, _) = removeMinTree ts in root t

    let deleteMin ts =
      let (Node (_, _, ts1), ts2) = removeMinTree ts
      in merge (List.rev ts1) ts2

    let rec check_children_rank p_rank (Node(r,x,c)) =
      match p_rank, c with
      | n, [] -> n = 0
      | n, t::ts -> if (n-1) = (rank t)
                    then check_children_rank (n-1) (Node(r, x, ts))
                    else false

    let rec ands (lst: bool list) : bool =
      match lst with
      | [] -> true
      | false :: xs -> false
      | _ :: xs -> ands xs

  let check_min o_tree =
    let rec helper (Node(r,x,c)) =
      match c with
      | [] -> true
      | c' :: cs' -> if not(x <= root c') then false
                    else helper c' && helper (Node(r,x,cs'))
    in
    helper o_tree

  let isBinomialTree o_tree =
    let rec helper (Node(r,x,c) as t) result =
        if not(check_children_rank r t) then false :: result
        else match c with
             | [] -> true :: result
             | c' :: cs' -> (helper c' result) @ helper (Node(r-1,x,cs')) result
    in
    ands (helper o_tree []) && check_min o_tree

  let rec ranksize o_heap =
    match o_heap with
    | t1::t2::ts -> if rank t1 < rank t2 then ranksize (t2::ts)
                    else false
    | _ -> true

  let iBT_checkall o_heap =
    let result = List.map isBinomialTree o_heap
    in
    ands result


    let check_all_min o_heap =
      let result = List.map check_min o_heap
      in
      ands result

    let isBinomialHeap o_heap =
      ranksize o_heap && iBT_checkall o_heap

  end

  module BHI = BinomialHeap(Int)

  let h1 = BHI.empty
  let h2 = BHI.insert 20 h1
  let h3 = BHI.insert 30 h2
  let h4 = BHI.insert 10 h3
  let h5 = BHI.insert 40 h4
  let test2 = BHI.isBinomialHeap h2
  let test3 = BHI.isBinomialHeap h3
  let test4 = BHI.isBinomialHeap h4
  let test5 = BHI.isBinomialHeap h5

  let m1 = BHI.findMin h5

  let h6 = BHI.deleteMin h5
  let test6 = BHI.isBinomialHeap h6
  let t1 = BHI.Node(1, 20, [BHI.Node(0,30,[])])
  let test7 = BHI.isBinomialTree t1

  let m2 = BHI.findMin h6
  let m3 = BHI.findMinDirect h6
