;;; One hailstone step in Guile Scheme.
(define (step n)
  (if (even? n) (quotient n 2) (+ (* 3 n) 1)))

(display (step (read)))
(newline)
