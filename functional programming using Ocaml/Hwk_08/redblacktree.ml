(*the invariants for red-black tree:
  1. a red node must have 2 black nodes
  2. each path to a leaf must have the same amount of black node
  3. a leaf must be a black node & root must be a black node
  4. the data structure must also obey the invariants of BST

  extra credit:
  my strategy is to go thorough 2 paths to the leaves at the same time to see
  if they have the same number of black nodes. If 2 paths reach leaves with the
  number of black nodes, then go thorough another pair of paths. Otherwise
  return false and terminate check_black_num function right away, which
  indicates that the data structure is not a red-black tree. 
 *)
open Ordered

module type RedBlackSetSig = sig
  type elem
  type color = R | B
  type t = E | T of color * t * elem * t

  val check_black_num: t -> bool
  val check_color: t -> bool
  val check_bst: t -> bool
  val isRedBlackTree: t -> bool
  val empty: t
  val insert: elem -> t -> t
  val member: elem -> t -> bool
end

module RedBlackTree (O:OrderedSig) : (RedBlackSetSig with type elem = O.t) = struct
  type elem = O.t
  type color = R | B
  type t = E | T of color * t * elem * t

  let empty = E
  let lt = O.lt

  let rec member x t =
    match x,t with
    | (x, E) -> false
    | (x, T(_,a,y,b)) -> if lt x y then member x a
                         else if lt y x then member x b
                         else true

  let rec balance c t1 v t2 =
    match c, t1, v, t2 with
    | B,T(R, T(R,a,x,b),y,c),z,d
    | B,T(R,a,x,T(R,b,y,c)),z,d
    | B,a,x,T(R,T(R,b,y,c),z,d)
    | B,a,x,T(R,b,y,T(R,c,z,d)) -> T(R,T(B,a,x,b),y,T(B,c,z,d))
    | (a,b,c,d) -> T (a,b,c,d)

  let insert x s =
      let rec ins t =
      match t with
      | E -> T(R,E,x,E)
      | T(color,a,y,b) as s ->
          if lt x y
          then balance color (ins a) y b
          else if lt y x
          then balance color a y (ins b)
          else s
      in match ins s with
      | E -> raise (Failure "Empty")
      | T(_,a,y,b)-> T(B,a,y,b)

  let rec check_allsamenum num_list =
    match num_list with
    | x1::x2::xs -> if x1 = x2 then check_allsamenum (x2::xs)
                    else false
    | _ -> true

  (* my original check_black_num func
    let check_black_num given_rbtree =
    let rec helper tree cur num_lst =
      match tree with
      | E -> cur :: num_lst
      | T(c,l,_,r) -> match c with
                      | B -> helper l (cur+1) num_lst @ helper r (cur+1) num_lst
                      | R -> helper l cur num_lst @ helper r cur num_lst
    in
    check_allsamenum (helper given_rbtree 0 [])*)

  let rec get_black_num num tree =
    match tree with
    | E -> num
    | T(B,l,_,_) -> get_black_num (num+1) l
    | T(R,l,_,_) -> get_black_num num l

  let rec check_black_num tree =
    match tree with
    | E -> true
    | T(c,l,_,r) -> if (get_black_num 0 l) = (get_black_num 0 r)
                      then check_black_num l && check_black_num r
                      else false

  let get_value tree cur =
    match tree with
    | E -> cur
    | T(_,_,x,_) -> x

  let check_bst given_rbtree =
    let rec helper tree =
      match tree with
      | E -> true
      | T(c,l,x,r) -> match c with
                      | B -> if x >= get_value l x && x <= get_value r x
                             then helper l && helper r
                             else false
                      | R -> if x >= get_value l x && x <= get_value r x
                             then helper l && helper r
                             else false
    in helper given_rbtree

  let get_color tree =
    match tree with
    | E -> B
    | T (color,_,_,_) -> color

  let check_color given_rbtree =
    let rec helper tree =
      match tree with
      | E -> true
      | T(c,l,_,r) -> match c with
                      | B -> helper l && helper r
                      | R -> if get_color l = R || get_color r = R then false
                             else helper l && helper r
    in
    helper given_rbtree

  let isRedBlackTree given_rbtree =
    check_black_num given_rbtree
    && check_color given_rbtree
    && check_bst given_rbtree

end

module RBTI = RedBlackTree (Int)

let h1 = RBTI.empty
let h2 = RBTI.insert 20 h1
let h3 = RBTI.insert 30 h2
let h4 = RBTI.insert 10 h3
let h5 = RBTI.insert 40 h4

let t1 = RBTI.isRedBlackTree h1
let t2 = RBTI.isRedBlackTree h2
let t3 = RBTI.isRedBlackTree h3
let t4 = RBTI.isRedBlackTree h4
let t5 = RBTI.isRedBlackTree h5
