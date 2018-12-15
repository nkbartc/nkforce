let read_file (file_name: string) : char list =
  let ic = open_in file_name
  in
  let rec read_chars ic =
    try
      let next_char = input_char ic
      in next_char :: read_chars ic
    with
      _ -> []
  in read_chars ic


let implode (cs: char list) : string =
  String.concat "" (List.map  (String.make 1) cs)

let split s list =
    let accu = ([],[])
    in
    let f (result, temp) a = if s a then (List.rev temp :: result, [])
                             else (result, a::temp)
    in
    let (result, temp) = List.fold_left f accu list
    in
    List.rev result @ [temp]

let is_elem elem list =
  let compare = fun accu a -> accu || (elem = a) in
  List.fold_left compare false list

let d1 = "../../public-class-repo/Homework/Files/words-small.txt"
let d2 = "../../public-class-repo/Homework/Files/words-google-10000.txt"

let answers fname =
  let mess_list = read_file fname in
  let trush_bool = fun c -> if (c = '\n') || (c = ' ') then true else false in
  let c_list_list = split trush_bool mess_list in
  let s_list = List.map implode c_list_list in
  let w4_list = List.filter (fun x -> String.length x = 4) s_list in (*make a list with 4 letter words*)
  let w6_list = List.filter (fun x -> String.length x = 6) s_list in (*make a list with 6 letter words*)
  let w4er = fun accu a -> if is_elem (String.sub a 1 4) w4_list then a :: accu else accu in
  let result = List.fold_left w4er [] w6_list in
  List.rev result

let pretty_answers s_list =
  List.map (fun x -> (String.sub x 1 4, x)) s_list
