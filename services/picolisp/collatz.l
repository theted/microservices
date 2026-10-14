# One hailstone step in PicoLisp, whose tiny interpreter has sockets built in.
(de step (N)
   (if (bit? 1 N)
      (inc (* 3 N))
      (/ N 2) ) )

(de query-n (Line)
   (and
      (match '(@A "n" "=" @Digits " " @Rest) (chop Line))
      (gt0 (format (pack @Digits))) ) )

(de answer (Sock)
   (let N (in Sock (prog1 (query-n (line T)) (while (line T))))
      (out Sock
         (if N
            (prin "HTTP/1.0 200 OK^M^JContent-Type: text/plain^M^J^M^J" (step N))
            (prin "HTTP/1.0 400 Bad Request^M^JContent-Type: text/plain^M^J^M^Jneed ?n=<positive integer>") ) ) ) )

(let Port (port 8000)
   (prinl "PicoLisp is listening on :8000")
   (flush)
   (loop
      (let Sock (listen Port)
         (answer Sock)
         (close Sock) ) ) )
