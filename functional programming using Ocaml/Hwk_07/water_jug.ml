type operation = Fill4GallonJugFromTap
               | Fill3GallonJugFromTap
               | Empty4GallonJugOnGround
               | Empty3GallonJugOnGround
               | Fill4GallonJugFrom3GallonJug
               | Fill3GallonJugFrom4GallonJug
               | Empty4GallonJugInto3GallonJug
               | Empty3GallonJugInto4GallonJug

(*I use a tuple to represent how many gallons that jar 4 and jar 3 have.
the first int is jar 4 and the the second int is jar 3*)
type state = int * int

let fill4GallonJugFromTap (j: state) : state =
  match j with
  | (j4,j3) -> (4,j3)

let fill3GallonJugFromTap (j: state) : state =
  match j with
  | (j4,j3) -> (j4,3)

let empty4GallonJugOnGround (j: state) : state =
  match j with
  | (j4,j3) -> (0,j3)

let empty3GallonJugOnGround (j: state) : state =
  match j with
  | (j4,j3) -> (j4,0)

let fill4GallonJugFrom3GallonJug (j: state) : state =
  match j with
  | (j4,j3) -> let diff = 4 - j4
               in
               (4, j3 - diff)

let fill3GallonJugFrom4GallonJug (j: state) : state =
  match j with
  | (j4,j3) -> let diff = 3 - j3
               in
               (j4 - diff, 3)

let empty4GallonJugInto3GallonJug (j: state) : state =
  match j with
  | (j4,j3) -> (0,j3+j4)

let empty3GallonJugInto4gallonJug (j: state) : state =
  match j with
  | (j4,j3) -> (j4+j3,0)

let ok_state (s : operation * state) : bool =
  match s with
  | (_,(j4,j3)) -> j4 >= 0 && j4 <= 4 && j3 >= 0 && j3 <= 3

let rec final (s: (operation * state) list) : bool =
  match s with
  | [] -> false
  | (op,target) :: rest -> if target = (2,0) then true
                           else final rest

let rec cons_result (s: (operation * state) list) : (operation * state) list =
  match s with
  | [] -> []
  | (op,target) :: rest -> if target = (2,0) then s
                           else (op,target) :: cons_result rest

(*let get_last_state (s: (operation * state) list) : state =
  let target = List.hd (List.rev s)
  in match target with
  | (_,(j4,j3)) -> (j4,j3)*)

(**)
let check_same (j: state) (s: operation * state) : bool =
  match s with
  | (_,state) -> j <> state && (0,0) <> state

let rec no_same_state result osl =
  match osl with
  | [] -> result
  | (op,state) :: tl -> no_same_state (List.filter (check_same state) result) tl

let move (j:state) : (operation * state) list =
  let s1 = match j with
           | (j4,j3) -> if j4 < 4 then [(Fill4GallonJugFromTap,
                                       fill4GallonJugFromTap j)]
                        else [ ]
  in
  let s2 = match j with
           | (j4,j3) -> if j3 < 3 then [(Fill3GallonJugFromTap,
                                       fill3GallonJugFromTap j)]
                        else [ ]
  in
  let s3 = match j with
           | (j4,j3) -> if j4 > 0 then [(Empty4GallonJugOnGround,
                                       empty4GallonJugOnGround j)]
                        else [ ]
  in
  let s4 = match j with
           | (j4,j3) -> if j3 > 0 then [(Empty3GallonJugOnGround,
                                       empty3GallonJugOnGround j)]
                        else [ ]
  in
  let s5 = match j with
           | (j4,j3) -> if j3 > 0
                        && (j4 + j3) >= 4 then [(Fill4GallonJugFrom3GallonJug,
                                               fill4GallonJugFrom3GallonJug j)]
                        else [ ]
  in
  let s6 = match j with
           | (j4,j3) -> if j4 > 0
                        && (j4 + j3) >= 3 then [(Fill3GallonJugFrom4GallonJug,
                                               fill3GallonJugFrom4GallonJug j)]
                        else [ ]
  in
  let s7 = match j with
           | (j4,j3) -> if j4 > 0
                        && (j4 + j3) < 3 then [(Empty4GallonJugInto3GallonJug,
                                              empty4GallonJugInto3GallonJug j)]
                        else [ ]
  in
  let s8 = match j with
           | (j4,j3) -> if j3 > 0
                        && (j4 + j3) < 4 then [(Empty3GallonJugInto4GallonJug,
                                              empty3GallonJugInto4gallonJug j)]
                        else [ ]
  in
  List.filter ok_state (s1@s2@s3@s4@s5@s6@s7@s8)

let describe (four:int) (three:int) : string =
  let describe' jug amount =
      "The " ^ string_of_int jug ^ " gallon jug " ^
      match amount with
      | 0 -> " is empty"
      | 1 -> " contains 1 gallon"
      | x -> " contains " ^ string_of_int x ^ " gallons"
       in
       describe' 4 four ^ ", " ^ describe' 3 three ^ "."

let rec describe_all (s: (operation * state) list) : (operation * string) list=
    match s with
    | [] -> []
    | (op,(j4,j3)) :: rest -> (op, describe j4 j3) :: describe_all rest

let play () : (operation * string) list option =
  let rec helper state osl =
  if state = (2,0) then Some (List.rev (describe_all osl))
  else match no_same_state (move state) osl with
  | [] -> None
  | temp -> (match temp with
            | (op,(j4,j3)) :: rest ->
            (match helper (j4,j3) ((op,(j4,j3)) :: osl) with
             | Some result -> Some result
             | None -> (match rest with
                        |(x,(x1,x2)) :: _ -> helper (x1,x2) ((x,(x1,x2)) :: osl)
                        |[] -> None)))
in helper (0,0) []
