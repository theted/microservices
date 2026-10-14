(* One hailstone step in Standard ML, where type inference grew up. *)
fun step n = if n mod 2 = 0 then n div 2 else 3 * n + 1

val () =
  case Option.mapPartial Int.fromString (TextIO.inputLine TextIO.stdIn) of
      SOME n => print (Int.toString (step n) ^ "\n")
    | NONE => OS.Process.exit OS.Process.failure
