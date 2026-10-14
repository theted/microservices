;;; One hailstone step, served by Guile's built-in (web server).

(use-modules (web server)
             (web request)
             (web response)
             (web uri))

(define (step n)
  (if (even? n) (quotient n 2) (+ (* 3 n) 1)))

(define (query-n request)
  (let* ((query (or (uri-query (request-uri request)) ""))
         (pairs (map (lambda (pair) (string-split pair #\=))
                     (string-split query #\&)))
         (value (assoc-ref pairs "n")))
    (and (pair? value) (string->number (car value)))))

(define (collatz request body)
  (let ((n (query-n request)))
    (if (and (exact-integer? n) (positive? n))
        (values '((content-type . (text/plain)))
                (number->string (step n)))
        (values (build-response #:code 400
                                #:headers '((content-type . (text/plain))))
                "need ?n=<positive integer>"))))

(display "Guile is listening on :8000\n")
(run-server collatz 'http (list #:addr INADDR_ANY #:port 8000))
