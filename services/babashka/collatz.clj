;; One hailstone step in Clojure, run by babashka.
(defn step [n]
  (if (even? n) (quot n 2) (inc (* 3 n))))

(println (step (read)))
