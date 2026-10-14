#lang racket/base
;; One hailstone step in Racket, served with nothing but racket/tcp.
(require racket/tcp)

(define (step n)
  (if (even? n) (quotient n 2) (+ (* 3 n) 1)))

(define (read-crlf-line in)
  (define line (read-line in 'return-linefeed))
  (if (eof-object? line) "" line))

(define (handle in out)
  (define request (read-crlf-line in))
  (let skip-headers ()
    (unless (string=? (read-crlf-line in) "")
      (skip-headers)))
  (define found (regexp-match #rx"[?&]n=([0-9]+)[ &]" request))
  (define n (and found (string->number (cadr found))))
  (define-values (status body)
    (if (and n (positive? n))
        (values "200 OK" (number->string (step n)))
        (values "400 Bad Request" "need ?n=<positive integer>")))
  (fprintf out "HTTP/1.0 ~a\r\nContent-Type: text/plain\r\nContent-Length: ~a\r\n\r\n~a"
           status (bytes-length (string->bytes/utf-8 body)) body))

(define listener (tcp-listen 8000 128 #t))
(printf "Racket is listening on :8000\n")
(flush-output)

(let loop ()
  (define-values (in out) (tcp-accept listener))
  (thread (lambda ()
            (with-handlers ([exn:fail? void])
              (handle in out))
            (close-input-port in)
            (close-output-port out)))
  (loop))
