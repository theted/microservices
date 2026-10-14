;;; collatz.el --- Emacs, but it's a microservice  -*- lexical-binding: t -*-

;; Run with: emacs --batch -l collatz.el

(defun collatz-step (n)
  (if (= (% n 2) 0) (/ n 2) (1+ (* 3 n))))

(defun collatz-reply (proc status body)
  (process-send-string
   proc (format "HTTP/1.0 %s\r\nContent-Type: text/plain\r\nContent-Length: %d\r\n\r\n%s"
                status (string-bytes body) body))
  (delete-process proc))

(defun collatz-filter (proc chunk)
  "Collect the request in CHUNKs; answer once the headers are complete."
  (let ((request (concat (process-get proc :request) chunk)))
    (process-put proc :request request)
    (when (string-search "\r\n\r\n" request)
      (if (string-match "\\`GET [^ ]*[?&]n=\\([0-9]+\\)[ &]" request)
          (let ((n (string-to-number (match-string 1 request))))
            (if (> n 0)
                (collatz-reply proc "200 OK" (number-to-string (collatz-step n)))
              (collatz-reply proc "400 Bad Request" "need ?n=<positive integer>")))
        (collatz-reply proc "400 Bad Request" "need ?n=<positive integer>")))))

(make-network-process :name "collatz"
                      :server t
                      :host "0.0.0.0"
                      :service 8000
                      :family 'ipv4
                      :coding 'binary
                      :noquery t
                      :filter #'collatz-filter)

(message "Emacs is listening on :8000")
(while t
  (accept-process-output nil 1))
