let circle_circum_v1 = fun r -> 3.1415 *. 2.0 *. r

let circle_circum_v2 r = 
	let pi = 3.1415 in pi *. 2.0 *. r

let rec product xs =
	match xs with
	| [] -> 1 
	| x::rest -> x * product rest

let rec sum_sqrdiffs xs =
	match xs with
	| x1::x2::[]-> (x1 - x2) * (x1 - x2)
	| x1::x2::rest -> (x1 - x2) * (x1 - x2) + sum_sqrdiffs (x2::rest)

let distance (x1,y1) (x2,y2) =
	sqrt ((x1 -. x2)** 2.0 +. (y1 -. y2)** 2.0)
	
let triangle_perimeter (x1,y1) (x2,y2) (x3,y3) =
	sqrt ((x1 -. x2)** 2.0 +. (y1 -. y2)** 2.0) +.
	sqrt ((x2 -. x3)** 2.0 +. (y2 -. y3)** 2.0) +.
	sqrt ((x3 -. x1)** 2.0 +. (y3 -. y1)** 2.0)

