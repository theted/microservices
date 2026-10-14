# One hailstone step in Janet, a small Lisp with an event loop and net/server built in.
(defn step [n]
  (if (even? n) (div n 2) (+ (* 3 n) 1)))

(def query-n
  (peg/compile ~{:param (* (set "?&") "n=" (number :d+))
                 :main (* (any (if-not :param 1)) :param)}))

(defn handler [conn]
  (defer (:close conn)
    (def request (string (or (:read conn 4096) "")))
    (def n (first (or (peg/match query-n request) [])))
    (if (and n (> n 0))
      (:write conn (string "HTTP/1.0 200 OK\r\nContent-Type: text/plain\r\n\r\n" (step n)))
      (:write conn "HTTP/1.0 400 Bad Request\r\nContent-Type: text/plain\r\n\r\nneed ?n=<positive integer>"))))

(print "Janet is listening on :8000")
(net/server "0.0.0.0" 8000 handler)
