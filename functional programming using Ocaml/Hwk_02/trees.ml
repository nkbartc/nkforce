type 'a tree = Leaf of 'a
             | Fork of 'a * 'a tree * 'a tree

let t1 = Leaf 5
let t2 = Fork (3, Leaf 3, Fork (2, t1, t1))
let t3 = Fork ("Hello", Leaf "World", Leaf "!")
let t4 = Fork (7, Fork (5, Leaf 1, Leaf 2), Fork (6, Leaf 3, Leaf 4))

let rec t_size (t: 'a tree) : int =
  match t with
  | Leaf _ -> 1
  | Fork(_, left, right) -> t_size left + t_size right + 1

let rec t_sum (t: int tree) : int =
  match t with
  | Leaf x -> x
  | Fork(x, left, right) -> t_sum left + t_sum right + x

let rec t_charcount (t: string tree) : int =
  match t with
  | Leaf x -> String.length x
  | Fork(x, left, right) -> t_charcount left + t_charcount right + String.length x

let rec t_concat (t: string tree) : string =
  match t with
  | Leaf x -> x
  | Fork(x, left, right) -> x ^ t_concat left ^ t_concat right

let t5 : string option tree = Fork (Some "a", Leaf (Some "b"), Fork (Some "c", Leaf None, Leaf (Some "d")))
let t7 = Fork (Some 1, Leaf (Some 2), Fork (Some 3, Leaf None, Leaf None))
let t8 = Fork (Some "a", Leaf (Some "b"), Fork (Some "c", Leaf None, Leaf (Some "d")))

let rec t_opt_size (t: 'a option tree) : int =
  match t with
  | Leaf x -> if x = None then 0
              else 1
  | Fork(x, left, right) -> t_opt_size left + t_opt_size right + 1

let rec t_opt_sum (t: int option tree) : int =
  match t with
  | Leaf Some x -> x
  | Leaf None -> 0
  | Fork(Some x, left, right) -> t_opt_sum left + t_opt_sum right + x
  | Fork(None, left, right) -> t_opt_sum left + t_opt_sum right

let rec t_opt_charcount (t: string option tree) : int =
  match t with
  | Leaf Some x -> String.length x
  | Leaf None -> 0
  | Fork(Some x, left, right) -> t_opt_charcount left + t_opt_charcount right + String.length x
  | Fork(None, left, right) -> t_opt_charcount left + t_opt_charcount right

let rec t_opt_concat( t: string option tree) : string =
  match t with
  | Leaf Some x -> x
  | Fork(Some x, left, right) -> x ^ t_opt_concat left ^ t_opt_concat right
  | Leaf None -> ""
  | Fork(None, left, right) -> ""

let rec tfold (l:'a -> 'b) (f:'a -> 'b -> 'b -> 'b)  (t:'a tree) : 'b =
  match t with
  | Leaf v -> l v
  | Fork (v, t1, t2) -> f v (tfold l f t1) (tfold l f t2)

let tf_size (t: 'a tree) : int =
  let l = fun x -> 1
  in
  let f = fun x left right -> (l x) + left + right
  in
  tfold l f t

let tf_sum (t: int tree) : int =
  let l = fun x -> x
  in
  let f = fun x left right -> (l x) + left + right
  in
  tfold l f t

let tf_charcount (t: string tree) : int =
  let l = fun x -> String.length x
  in
  let f = fun x left right -> (l x) + left + right
  in
  tfold l f t

let tf_concat (t: string tree) : string =
  let l = fun x -> x
  in
  let f = fun x left right -> (l x) ^ left ^ right
  in
  tfold l f t

let tf_opt_size (t: 'a option tree) : int =
  let l = fun x -> match x with
                   | None -> 0
                   | _ -> 1
  in
  let f = fun x left right -> (l x) + left + right
  in
  tfold l f t

let tf_opt_sum (t: int option tree) : int =
  let l = fun x -> match x with
                   | Some x -> x
                   | None -> 0
  in
  let f = fun x left right -> (l x) + left + right
  in
  tfold l f t

let tf_opt_charcount (t: string option tree) : int =
  let l = fun x -> match x with
                   | Some x -> String.length x
                   | None -> 0
                   in
  let f = fun x left right -> (l x) + left + right
  in
  tfold l f t

let tf_opt_concat (t: string option tree) : string =
  let l = fun x -> match x with
                   | Some x -> x
                   | None -> ""
                   in
  let f = fun x left right -> (l x) ^ left ^ right
  in
  tfold l f t


type 'a btree = Empty
              | Node of 'a btree * 'a * 'a btree

let t6 = Node (Node (Empty, 3, Empty), 4, Node (Empty, 5, Empty))
let t7 = Node (Node (Node (Empty, 6, Empty), 3, Node (Empty, 7, Empty)), 4, Node (Empty, 5, Node (Empty, 8, Empty)))

let rec bt_insert_by (f: 'a -> 'a -> int) (n: 'a) (t: 'a btree) : 'a btree =
  match t with
  | Empty -> Node (Empty, n, Empty)
  | Node(left, v, right) -> if f n v > 0 then Node(left, v, bt_insert_by f n right)
                            else if f n v < 0 then Node(bt_insert_by f n left, v, right)
                            else t

let rec bt_elem_by (f: 'a -> 'b -> bool) (targ: 'b) (t : 'a btree) : bool =
  match t with
  | Empty -> false
  | Node(left, v, right) -> f v targ || bt_elem_by f targ left || bt_elem_by f targ right



let rec bt_to_list (t: 'a btree) : 'a list =
  match t with
  | Empty -> []
  | Node(left, v, right) -> bt_to_list left @ (v :: bt_to_list right)

(*let rec tfold (l:'a -> 'b) (f:'a -> 'b -> 'b -> 'b)  (t:'a tree) : 'b =
   match t with
   | Leaf v -> l v
   | Fork (v, t1, t2) -> f v (tfold l f t1) (tfold l f t2)*)

(*'b -> ('b -> 'a -> 'b -> 'b) -> 'a btree -> 'b*)

let rec btfold (l: 'b) (f: 'b -> 'a -> 'b -> 'b) (t: 'a btree) : 'b =
  match t with
  | Empty -> l
  | Node (left, v ,right) -> f (btfold l f left) v (btfold l f right)

let btf_elem_by (f: 'a -> 'b -> bool) (targ: 'b) (t : 'a btree) : bool =
  let ff = fun left v right -> if f v targ || left || right then true
                               else false
                               in
                               btfold false ff t

let btf_to_list (t: 'a btree) : 'a list =
  let f = fun left v right ->  left @ (v :: right)
  in
  btfold [] f t


(*the way we write bt_insert_by is using the idea that going as deeper as possible by using compare function until it finds Empty. However, tree fold is not as flexible
as the recursive function, bt_insert_by. For example, btfold has to go through the whole tree first, then we still need to write one or more recursive function, and
lots of if-else statement to help the tree fold function to find the right spot to insert, which make it more complicated and difficult to write than bt_insert_by. *)
