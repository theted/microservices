;;;; One hailstone step in Common Lisp, on SBCL with its own sb-bsd-sockets.
(require :sb-bsd-sockets)

(defparameter +crlf+ (coerce '(#\Return #\Newline) 'string))

(defun hailstone-step (n)
  (if (evenp n) (/ n 2) (1+ (* 3 n))))

(defun query-n (request-line)
  (let ((start (or (search "?n=" request-line) (search "&n=" request-line))))
    (when start
      (let ((n (parse-integer request-line :start (+ start 3) :junk-allowed t)))
        (and n (plusp n) n)))))

(defun serve (stream)
  (let ((request-line (or (read-line stream nil) "")))
    (loop for header = (read-line stream nil)
          while (and header (string/= (string-trim '(#\Return) header) "")))
    (let* ((n (query-n request-line))
           (status (if n "200 OK" "400 Bad Request"))
           (body (if n (princ-to-string (hailstone-step n)) "need ?n=<positive integer>")))
      (format stream "HTTP/1.0 ~a~aContent-Type: text/plain~a~a~a" status +crlf+ +crlf+ +crlf+ body)
      (finish-output stream))))

(let ((server (make-instance 'sb-bsd-sockets:inet-socket :type :stream :protocol :tcp)))
  (setf (sb-bsd-sockets:sockopt-reuse-address server) t)
  (sb-bsd-sockets:socket-bind server #(0 0 0 0) 8000)
  (sb-bsd-sockets:socket-listen server 128)
  (format t "Common Lisp is listening on :8000~%")
  (finish-output)
  (loop
    (let* ((client (sb-bsd-sockets:socket-accept server))
           (stream (sb-bsd-sockets:socket-make-stream client :input t :output t
                                                             :element-type 'character
                                                             :buffering :full)))
      (ignore-errors (serve stream))
      (sb-bsd-sockets:socket-close client))))
