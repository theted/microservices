# One hailstone step in Janet.
(defn step [n]
  (if (even? n) (div n 2) (+ (* 3 n) 1)))

(print (step (scan-number (string/trim (file/read stdin :line)))))
