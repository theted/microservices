;; One hailstone step in Hy, a Lisp that compiles to Python.
(defn step [n]
  (if (= (% n 2) 0) (// n 2) (+ (* 3 n) 1)))

(print (step (int (input))))
