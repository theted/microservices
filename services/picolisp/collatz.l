# One hailstone step in PicoLisp. (in NIL ...) reads from stdin, not from this file.
(de step (N)
   (if (bit? 1 N)
      (inc (* 3 N))
      (/ N 2) ) )

(prinl (step (in NIL (read))))
(bye)
