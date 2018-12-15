(*length*)

let length list =
  let cut = fun accu a -> accu + 1 in
  List.fold_left cut 0 list

(*andf*)

let andf list =
  let compare = fun accu a -> if accu && a then true else false in
  List.fold_left compare true list

(*orf*)

let orf list =
  let compare = fun accu a -> if accu || a then true else false in
  List.fold_left compare false list

(*is-element*)

let is_elem elem list =
  let compare = fun accu a -> accu || (elem = a) in
    List.fold_left compare false list

(*list reverse*)

let rev list =
  let add = fun accu a -> a :: accu in
    List.fold_left add [] list

(*ASCII sum*)

let ascii_sum list =
  let ascii_add = fun accu a -> accu + (Char.code a) in
    List.fold_left ascii_add 0 list

(*lebowski*)

let lebowski list =
  let dude = fun accu a -> if a = '.' then accu @ [','; ' '; 'd'; 'u'; 'd'; 'e'; '.']
                           else accu @ [a]
                           in
                           List.fold_left dude [] list
