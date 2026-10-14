;; One hailstone step in Fennel, a Lisp that compiles to Lua.
(fn step [n]
  (if (= 0 (% n 2)) (// n 2) (+ (* 3 n) 1)))

(print (step (io.read :n)))
