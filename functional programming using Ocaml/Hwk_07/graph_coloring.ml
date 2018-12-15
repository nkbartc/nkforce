(*first of all, the sample program search_options.ml written by the professor
gives me good inspiration for writing this assignment.

My strategy is let the ocaml to go through all possible combination of node and
color, no matter the combination is valid or not, which is our search space.
When every time the recursive helper function is called, the program checks if
there is a valid solution. check_nosame_color and check_all_have_validcolor do
the job that check if there is a soulition. When the program finds a solution,
returns the result and terminate the program. If there is no solution, the
program continues traversing the search space.

I don't think my program meets the requirement to avoid the potential
inefficiency because my program can't check whether there are two adjcent nodes
have the same color until all nodes are colored in a path. I commment a line in
my main function  that may be a way to avoid continuing with same color nodes.
However, it doesn't even lead to a correct answer.*)

type node = N of int
type edge = node * node
type graph = node list * edge list

type color = C of int
type coloring = (node * color) list

let g1 = ([N 1; N 2; N 3; N 4], [ (N 1,N 2); (N 1,N 3); (N 2,N 3); (N 3,N 4) ])
let g2 = ([N 1; N 2; N 3; N 4; N 5; N 6],
          [])
let g3 = ([N 1; N 2],
          [(N 1,N 2)])

let g1_coloring = [ (N 1,C 1); (N 2,C 2); (N 3,C 3); (N 4,C 2) ]
(*Some [(N 1,C 1); (N 2,C 2); (N 3,C 3); (N 4,C 2)]*)

(*used for check_nosame_color*)
let rec get_color(c: coloring) (target: node) : color =
  match c with
  | [] -> C (-9)
  | ((node,color) :: rest) -> if target = node then color
                              else get_color rest target

let valid_color (c: color) : bool =
  match c with
  | (C x) -> (x > 0) && (x <= 3)

let rec check_all_have_validcolor (g: graph) (c: coloring) : bool =
match g with
| ([],_) -> true
| (((n :: rest), lst)) -> valid_color (get_color c n)
                          && check_all_have_validcolor (rest, lst) c

let rec check_nosame_color (c: coloring) (g: graph) : bool =
  match g with
  | (ns, []) -> true
  | (ns,((n1,n2)::rest)) -> if get_color c n1 = get_color c n2 then false
                            else check_nosame_color c (ns,rest)

let color_option (g: graph) : coloring option =
  let rec helper given_g partial_subset =
    if check_nosame_color partial_subset given_g
    && check_all_have_validcolor g partial_subset
    && partial_subset <> []
    then Some (List.rev partial_subset)
  (*else if not (check_nosame_color partial_subset given_g)
            && partial_subset <> []
         then None*)
    else match given_g with
    |([],[]) -> None
    |([],_) -> None
    |((n::ns),e)->(match helper (ns,e) ((n,C 1)::partial_subset) with
                  |Some result -> Some result
                  |None -> (match helper (ns,e) ((n,C 2)::partial_subset) with
                            | Some result -> Some result
                            | None -> helper (ns,e) ((n,C 3)::partial_subset)))
  in helper g []

exception FoundColoring of coloring

let color_exception (g: graph) : unit =
    let rec helper given_g partial_subset =
      if check_nosame_color partial_subset given_g
      && check_all_have_validcolor g partial_subset
      && partial_subset <> []
      then raise (FoundColoring (List.rev partial_subset))
      else match given_g with
      | ([],[]) -> ()
      | ([],_) -> ()
      | ((n::ns),e) -> helper (ns,e) ((n,C 1)::partial_subset);
                       helper (ns,e) ((n,C 2)::partial_subset);
                       helper (ns,e) ((n,C 3)::partial_subset)
    in helper g []
