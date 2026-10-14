;;; collatz.el --- One hailstone step in Emacs Lisp  -*- lexical-binding: t -*-
;; In batch mode, Emacs reads the minibuffer from stdin.

(defun collatz-step (n)
  (if (= (% n 2) 0) (/ n 2) (1+ (* 3 n))))

(princ (format "%d\n" (collatz-step (string-to-number (read-from-minibuffer "")))))
