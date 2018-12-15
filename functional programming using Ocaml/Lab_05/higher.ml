(*Group: Ju-Yu, Chou Fu; Jiayue Lin; minh trab.*)

(*All evens*)

let all_evens list =
  List.filter (fun x -> x mod 2 = 0) list

(*Increment all*)

let increment_all list =
  List.map (fun x -> x + 1) list

(*Max of integers as a fold*)

let max_fold list =
  let larger = fun a b -> if a > b then a else b in
  match list with
  | [] -> raise (Failure "Input list must not be empty")
  | x :: [] -> x
  | _ -> List.fold_left larger (List.hd list) list

(*Sum and prod in one pass*)

let sum_prod list =
  let multiple = fun a b -> a * b in
  match list with
  | [] -> (0,1)
  | _  -> ((List.fold_right (+) list 0), (List.fold_right (multiple) list 1))

(*Splitting up a list.*)

(*let split s list =
    let accu = ([],[])
    in
    let f (result, temp) a = if s a then ((List.rev temp) :: result, [])
                             else (result, a::temp)
    in
    let (result, temp) = List.fold_left f accu list
    in
    List.rev result @ [temp]*)

(*improved split fun*)
(*changes:*)
(*1: type annotations*)
(*2: type abbreviations*)
(*3: raise exception*)
let split (f : 'a -> bool) (lst: 'a list) : ('a list list) =
  if lst = [] then raise (Failure("empty list!"))
  else
  let accu: ('a list list * 'a list)= ([],[])
  in
  let f (result, temp) x = if f x then ((List.rev temp) :: result, [])
                           else (result, x::temp)
                           in
  let (result, temp) = List.fold_left f accu lst
  in
  List.rev result @ [temp]
