module type OrderedSig = sig
  type t
  val eq: t -> t -> bool
  val lt: t -> t -> bool
  val leq: t -> t -> bool
  end

module Int : (OrderedSig with type t = int) = struct
  type t = int
  let eq x y = (x = y)
  let lt x y = (x < y)
  let leq x y = (x <= y)
  end
