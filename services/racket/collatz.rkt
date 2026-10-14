#lang racket/base
;; One hailstone step in Racket.
(define (step n)
  (if (even? n) (quotient n 2) (+ (* 3 n) 1)))

(displayln (step (read)))
