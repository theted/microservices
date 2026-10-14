;;;; One hailstone step in Common Lisp.
(defun hailstone-step (n)
  (if (evenp n) (/ n 2) (1+ (* 3 n))))

(format t "~d~%" (hailstone-step (parse-integer (read-line))))
