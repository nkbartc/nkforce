let p1 = "Hello world!\n\n How are you today? \t\t I hope all is well. "
let p1f = "Hello world!\nHow are you\ntoday? I\nhope all is\nwell."

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

(*modified split function*)
let split s list =
    let accu = ([],[])
    in
    let f (result, temp) a = if s a then (List.rev temp :: result, [])
                             else (result, a::temp)
    in
    let (result, temp) = List.fold_left f accu list
    in
    List.rev (List.rev temp :: result)

let explode (s: string) : char list =
    let l = String.length s
    in
    let rec f i =
    if i = l then [] else s.[i] :: f (i+1)
    in f 0

(*helper function for split. sntr stands for space, new line, tab, and overwrite*)
let spntr_bool = fun c -> if (c = ' ') || (c = '\n') || (c = '\t') || (c = '\r') then true else false

(*helper function to delete empty strings left by split*)
let clean_empty = fun accu x -> if x = "" then accu else x :: accu



(*main function*)
let format string int =
  let c_list = explode string in (*explode string into char list*)
  let mass_list_list = split spntr_bool c_list in (*use split to get rid of spaces, new lines, tabs, and overwrites*)
  let s_list = List.map implode mass_list_list in (*use implode to turn mass_list_list into string list*)
  let clean_list = List.rev (List.fold_left clean_empty [] s_list) in
  let makeit = fun (list, size) x ->
  if size + (String.length x) > int then ((x :: ("\n" :: list)), 1 + String.length x)
  else if size + (String.length x) = int then (x :: (" " :: list), int)
  else (x :: (" " :: list), 1 + size + String.length x) in
  let (almost, size) = List.fold_left makeit ([],0) clean_list in
  String.trim (String.concat "" (List.rev almost)) (*concat the string, then trim it*)
