;; One hailstone step in Hy: Lisp syntax, Python's standard library underneath.
(import http.server [BaseHTTPRequestHandler ThreadingHTTPServer]
        urllib.parse [parse-qs urlparse])

(defn step [n]
  (if (= (% n 2) 0) (// n 2) (+ (* 3 n) 1)))

(defclass Handler [BaseHTTPRequestHandler]
  (defn do-GET [self]
    (setv raw (get (.get (parse-qs (. (urlparse self.path) query)) "n" ["0"]) 0))
    (setv n (if (.isdigit raw) (int raw) 0))
    (setv [status body] (if (> n 0)
                            [200 (str (step n))]
                            [400 "need ?n=<positive integer>"]))
    (.send-response self status)
    (.send-header self "Content-Type" "text/plain")
    (.end-headers self)
    (.write self.wfile (.encode body))))

(print "Hy is listening on :8000" :flush True)
(.serve-forever (ThreadingHTTPServer #("" 8000) Handler))
