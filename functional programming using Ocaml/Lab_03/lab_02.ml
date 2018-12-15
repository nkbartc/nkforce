(*name: Ju-Yu, Chou Fu*)
(*group with shin yin teh, Nicholas Ng*)

(*No need to change*)
let circle_circum_v1 = fun r -> 3.1415 *. 2.0 *. r

(*I can make a change at line 8 by spliting let, in , and pi *. 2.0 *. r into 3 lines *)
let circle_circum_v2 r =
	let pi = 3.1415
	in
	pi *. 2.0 *. r

(*no need to change*)
let rec product xs =
	match xs with
	| [] -> 1
	| x::rest -> x * product rest

(*I didn't use either raise or @*)
(*Using raise can avoid special case for either zero element or one element in a list*)
let rec sum_sqrdiffs xs =
	match xs with
	| x1::x2::[]-> (x1 - x2) * (x1 - x2)
	| x1::x2::rest -> (x1 - x2) * (x1 - x2) + sum_sqrdiffs (x2::rest)
	| _ -> raise (Failure "sum_sqrdiffs input list needs at least two elements")


let distance (x1,y1) (x2,y2) =
	sqrt ((x1 -. x2)** 2.0 +. (y1 -. y2)** 2.0)

(*I can use distance() as a helper. This make my function look more simple*)
let triangle_perimeter (x1,y1) (x2,y2) (x3,y3) = distance (x1,y1) (x2,y2) +. distance (x2,y2) (x3,y3) +. distance (x3,y3) (x1,y1)
