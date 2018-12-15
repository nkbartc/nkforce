type expr
  = Val of value

  | Add of expr * expr
  | Sub of expr * expr
  | Mul of expr * expr
  | Div of expr * expr

  | Lt of expr * expr
  | Eq of expr * expr
  | And of expr * expr
  | Not of expr

  | Let of string * expr * expr
  | Id of string

  | App of expr * expr
  | Lambda of string * expr

  | LetRec of string * expr * expr
  | If of expr * expr * expr

and value
  = Int of int
  | Bool of bool
  | Closure of string * expr * environment


and environment = (string * value) list


let rec lookup (n: string) (env: environment) : value =
  match env with
  | [] -> raise (Failure ("Name \"" ^ n ^ "\" not in scope"))
  | (n',v)::_ when n' = n -> v
  | _::rest -> lookup n rest


let rec freevars (e: expr) : string list =
  match e with
  | Val _ -> []
  | Add (e1, e2) -> freevars e1 @ freevars e2
  | Sub (e1, e2) -> freevars e1 @ freevars e2
  | Mul (e1, e2) -> freevars e1 @ freevars e2
  | Div (e1, e2) -> freevars e1 @ freevars e2

  | Lt  (e1, e2) -> freevars e1 @ freevars e2
  | Eq  (e1, e2) -> freevars e1 @ freevars e2
  | And (e1, e2) -> freevars e1 @ freevars e2
  | Not e1       -> freevars e1

  | Let (n, dexpr, body) ->
     freevars dexpr @ (List.filter (fun n' -> n <> n') (freevars body))
  | Id n -> [n]

  | App (e1,e2) -> freevars e1 @ freevars e2
  | Lambda (str, e1) -> (List.filter (fun n' -> str <> n') (freevars e1))

  | LetRec (str,e1,e2) -> (List.filter (fun n' -> str <> n') (freevars e1)) @ (List.filter (fun n' -> str <> n') (freevars e2))
  | If (e1,e2,e3) -> freevars e1 @ freevars e2 @ freevars e3


  let rec eval (env: environment) (e: expr) : value =
    match e with
    | Val v -> v

    | Add (e1, e2) ->
      ( match eval env e1, eval env e2 with
        | Int i1, Int i2 -> Int (i1 + i2)
        | _, _ -> raise (Failure "incompatible values on Add")
      )
    | Sub (e1, e2) ->
       ( match eval env e1, eval env e2 with
         | Int i1, Int i2 -> Int (i1 - i2)
         | _, _ -> raise (Failure "incompatible values on Sub")
       )
    | Mul (e1, e2) ->
       ( match eval env e1, eval env e2 with
         | Int i1, Int i2 -> Int (i1 * i2)
         | _, _ -> raise (Failure "incompatible values on Mul")
       )
    | Div (e1, e2) ->
       ( match eval env e1, eval env e2 with
         | Int i1, Int i2 -> Int (i1 / i2)
         | _, _ -> raise (Failure "incompatible values on Div")
       )

    | Lt (e1, e2) ->
       ( match eval env e1, eval env e2 with
         | Int i1, Int i2 -> Bool (i1 < i2)
         | _, _ -> raise (Failure "incompatible values on Lt")
       )
    | And (e1, e2) ->
       ( match eval env e1, eval env e2 with
         | Bool b1, Bool b2 -> Bool (b1 && b2)
         | _, _ -> raise (Failure "incompatible values on And")
       )
    | Eq (e1, e2) ->
       ( match eval env e1, eval env e2 with
         | Int i1, Int i2 -> Bool (i1 = i2)
         | Bool b1, Bool b2 -> Bool (b1 = b2)
         | _, _ -> raise (Failure "incompatible values on Eq")
       )
    | Not e1 ->
       ( match eval env e1 with
         | Bool b -> Bool (not b)
         | _ -> raise (Failure "incompatible value on Not")
       )

    | Let (n, bexpr, body) ->
       let bexpr_v = eval env bexpr in
       eval ((n,bexpr_v)::env) body

    | Id n -> lookup n env

    | If (e1, e2, e3) ->
       ( match eval env e1 with
         | Bool b1 -> if b1 then eval env e2 else eval env e3
         | _ -> raise (Failure "incompatible value on If")
       )

    | Lambda (str, e1) -> Closure (str, e1, env)

    | App (e1, e2) ->
       let test1 = eval env e1
       in
       let test2 = eval env e2
       in
       (match test1, test2 with
       | Closure _, Closure _ -> raise (Failure "incompatible value on App")
       | Closure (str, e, env2), v -> eval (((str, v) :: env2) @ env) e
       | _ -> raise (Failure "incompatible value on App")
       )

    | LetRec (fun_name, e1, e2) ->
       (match e1 with
       | Lambda (n, e) -> let v = Closure (n, e, (fun_name, Closure (n, e, env)) :: env)
                           in
                           eval ((fun_name, v) :: env) e2
       | _ -> raise (Failure "incompatible value on LetRec")
       )

let rec serialize (e: expr) : string =
    match e with
    | Val v -> (match v with
               | Int x -> "Val (Int " ^ string_of_int x ^ ")"
               | Bool x -> "Val (Bool " ^ string_of_bool x ^ ")"
               | _ -> raise (Failure ("Will only serialize integer and Boolean values"))
               )
    | Add (e1,e2) -> "Add (" ^ serialize e1 ^ ", " ^ serialize e2 ^ ")"
    | Sub (e1,e2) -> "Sub (" ^ serialize e1 ^ ", " ^ serialize e2 ^ ")"
    | Mul (e1,e2) -> "Mul (" ^ serialize e1 ^ ", " ^ serialize e2 ^ ")"
    | Div (e1,e2) -> "Div (" ^ serialize e1 ^ ", " ^ serialize e2 ^ ")"

    | Lt  (e1,e2) -> "Lt (" ^ serialize e1 ^ ", " ^ serialize e2 ^ ")"
    | Eq  (e1,e2) -> "Eq (" ^ serialize e1 ^ ", " ^ serialize e2 ^ ")"
    | And (e1,e2) -> "And (" ^ serialize e1 ^ ", " ^ serialize e2 ^ ")"
    | Not e1      -> "Not (" ^ serialize e1 ^ ")"

    | Let (str,e1,e2) -> "Let (\"" ^ str ^ "\", " ^ serialize e1 ^ ", " ^ serialize e2 ^ ")"
    | Id  str -> "Id \"" ^ str ^ "\""

    | App (e1,e2) -> "App (" ^ serialize e1 ^ ", " ^ serialize e2 ^ ")"
    | Lambda (str, e1) -> "Lambda (\"" ^ str ^ "\", " ^ serialize e1 ^ ")"

    | LetRec (str,e1,e2) -> "LetRec (\"" ^ str ^ "\", " ^ serialize e1 ^ ", " ^ serialize e2 ^ ")"
    | If (e1,e2,e3) -> "If (" ^ serialize e1 ^ ", " ^ serialize e2 ^ ", " ^ serialize e3 ^ ")"

let rec unparse (e: expr) : string =
        match e with
        | Val v -> (match v with
                   | Int x -> string_of_int x
                   | Bool x -> string_of_bool x
                   | _ -> raise (Failure ("Will only serialize intger and Boolean values"))
                   )
        | Add (e1,e2) -> "(" ^ unparse e1 ^ " + " ^ unparse e2 ^ ")"
        | Sub (e1,e2) -> "(" ^ unparse e1 ^ " - " ^ unparse e2 ^ ")"
        | Mul (e1,e2) -> "(" ^ unparse e1 ^ " * " ^ unparse e2 ^ ")"
        | Div (e1,e2) -> "(" ^ unparse e1 ^ " / " ^ unparse e2 ^ ")"

        | Lt  (e1,e2) -> "(" ^ unparse e1 ^ " < " ^ unparse e2 ^ ")"
        | Eq  (e1,e2) -> "(" ^ unparse e1 ^ " = " ^ unparse e2 ^ ")"
        | And (e1,e2) -> "(" ^ unparse e1 ^ " && " ^ unparse e2 ^ ")"
        | Not e1      -> "(not " ^ unparse e1 ^ ")"

        | Let (str,e1,e2) -> "(let " ^ str ^ " = " ^ unparse e1 ^ " in " ^ unparse e2 ^ ")"
        | Id  str -> str

        | App (e1,e2) -> "(" ^ unparse e1 ^ " " ^ unparse e2 ^ ")"
        | Lambda (str, e1) -> "(fun " ^ str ^ " -> " ^ unparse e1 ^ ")"

        | LetRec (str,e1,e2) -> "(let rec " ^ str ^ " = " ^ unparse e1 ^ " in " ^ unparse e2 ^ ")"
        | If (e1,e2,e3) -> "(if " ^ unparse e1 ^ " then " ^ unparse e2 ^ " else " ^ unparse e3 ^ ")"


let evaluate e = eval [] e


(* Some sample expressions and their value *)
let e1 = Add (Val (Int 1), Mul (Val (Int 2), Val (Int 3)))
let v1 = evaluate e1

let e2 = Sub (Val (Int 10), Div (e1, Val (Int 2)))
let v2 = evaluate e2

let e3 = Eq (e1, e2)
let e4 = Lt (e1, e2)

let e5 = Not e4

(* ``let y = 5 in let x = y + 5 in x + y'' *)
let e6 = Let ("y",
              Val (Int 5),
              Let ("x",
                   Add (Id "y", Val (Int 5)),
                   Add (Id "x", Id "y")
                  )
             )

let () =
  assert (serialize e1 = "Add (Val (Int 1), Mul (Val (Int 2), Val (Int 3)))");
  assert (serialize e6 =
            "Let (\"y\", Val (Int 5), Let (\"x\", " ^
              "Add (Id \"y\", Val (Int 5)), Add (Id \"x\", Id \"y\")))")


(* ``let x = 3 < 5 in x && let x = 1 + 2 in x = 3 *)
let e7 = Let ("x",
              Lt (Val (Int 3), Val (Int 5)),
              And (Id "x",
                   Let ("x",
                        Add (Val (Int 1), Val (Int 2)),
                        Eq (Id "x", Val (Int 3))
                       )
                  )
             )

let () =
  assert (evaluate e1 = Int 7);
  assert (evaluate e2 = Int 7);
  assert (evaluate e3 = Bool true);
  assert (evaluate e4 = Bool false);
  assert (evaluate e5 = Bool true);
  assert (evaluate e6 = Int 15);
  assert (evaluate e7 = Bool true)


(* increment *)
let inc = Lambda ("n", Add(Id "n", Val (Int 1)))

let add = Lambda ("x",
                  Lambda ("y", Add (Id "x", Id "y"))
                 )
let inc' = App (add, Val (Int 1))

(* The add2 closure *)
let add2app =
  Let ("add2",
       Let ("two", Val (Int 2), Lambda ("x", Add (Id "x", Id "two"))),
       App (Id "add2", Val (Int 4)))

let () =
  assert (evaluate (App (inc, Val (Int 4))) = Int 5);
  assert (evaluate (Add (Val (Int 2), Val (Int 3))) = Int 5);
  assert (evaluate (App (inc', Val (Int 4))) = Int 5);
  assert (evaluate add2app = Int 6)


(* sumToN *)
let sumToN : expr =
    LetRec ("sumToN",
            Lambda ("n",
                    If (Eq (Id "n", Val (Int 0)),
                        Val (Int 0),
                        Add (Id "n",
                             App (Id "sumToN",
                                  Sub (Id "n", Val (Int 1))
                                 )
                            )
                       )
                   ),
            Id "sumToN"
           )

(* factorial *)
let fact : expr =
    LetRec ("fact",
            Lambda ("n",
                    If (Eq (Id "n", Val (Int 0)),
                        Val (Int 1),
                        Mul (Id "n",
                             App (Id "fact",
                                  Sub (Id "n", Val (Int 1))
                                 )
                            )
                       )
                   ),
            Id "fact"
           )

(* Assert expressions to test our functions. *)
let () =
  assert (evaluate (App (sumToN, Val (Int 4))) = Int 10);
  assert (evaluate (App (sumToN, Val (Int 10))) = Int 55);
  assert (evaluate (App (sumToN, Val (Int 100))) = Int 5050);
  assert (evaluate (App (fact, Val (Int 0))) = Int 1);
  assert (evaluate (App (fact, Val (Int 1))) = Int 1);
  assert (evaluate (App (fact, Val (Int 2))) = Int 2);
  assert (evaluate (App (fact, Val (Int 4))) = Int 24)



(* If utop gets to this point without raising an ``assert`` exception
   then all tests have passed. *)
let () =
  print_endline ("Success! All tests passed.")
