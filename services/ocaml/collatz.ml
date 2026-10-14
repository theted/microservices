(* One hailstone step in OCaml. *)
let step n = if n mod 2 = 0 then n / 2 else (3 * n) + 1

let () = Scanf.scanf " %d" (fun n -> Printf.printf "%d\n" (step n))
