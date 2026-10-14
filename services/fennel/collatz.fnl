;; One hailstone step in Fennel, a Lisp that compiles to Lua, served with LuaSocket.
(local socket (require :socket))

(fn step [n]
  (if (= 0 (% n 2)) (// n 2) (+ (* 3 n) 1)))

(io.stdout:setvbuf :line)
(local server (assert (socket.bind "0.0.0.0" 8000)))
(print "Fennel is listening on :8000")

(while true
  (let [client (server:accept)]
    (client:settimeout 5)
    (let [request (or (client:receive :*l) "")]
      (var header (client:receive :*l))
      (while (and header (not= header ""))
        (set header (client:receive :*l)))
      (let [n (tonumber (request:match "[?&]n=(%d+)[ &]"))
            (status body) (if (and n (> n 0))
                              (values "200 OK" (tostring (step n)))
                              (values "400 Bad Request" "need ?n=<positive integer>"))]
        (client:send (string.format "HTTP/1.0 %s\r\nContent-Type: text/plain\r\nContent-Length: %d\r\n\r\n%s"
                                    status (length body) body))))
    (client:close)))
