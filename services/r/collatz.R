# One hailstone step from R, using base R's own server sockets (R >= 4.0).
step <- function(n) if (n %% 2 == 0) n %/% 2 else 3 * n + 1

server <- serverSocket(8000)
cat("R is listening on :8000\n")

repeat {
  client <- tryCatch(socketAccept(server, blocking = TRUE, open = "r+", timeout = 3600),
                     error = function(e) NULL)
  if (is.null(client)) next

  request <- readLines(client, n = 1)
  repeat {
    header <- readLines(client, n = 1)
    if (length(header) == 0 || header == "") break
  }

  match <- regmatches(request, regexec("[?&]n=([0-9]+)[ &]", request))[[1]]
  n <- if (length(match) == 2) as.numeric(match[2]) else 0
  if (n > 0) {
    status <- "200 OK"
    body <- sprintf("%.0f", step(n))
  } else {
    status <- "400 Bad Request"
    body <- "need ?n=<positive integer>"
  }
  cat(sprintf("HTTP/1.0 %s\r\nContent-Type: text/plain\r\nContent-Length: %d\r\n\r\n%s",
              status, nchar(body, "bytes"), body), file = client)
  close(client)
}
