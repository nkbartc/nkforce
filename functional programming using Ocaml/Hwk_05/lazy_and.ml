let rec ands (lst: bool list) : bool =
  match lst with
  | [] -> true
  | false :: xs -> false
  | _ :: xs -> ands xs
