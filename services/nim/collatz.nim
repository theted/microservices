# One hailstone step from Nim, compiled to C, served by the standard library.
import std/[asynchttpserver, asyncdispatch, strutils, uri]

proc step(n: int): int =
  if n mod 2 == 0: n div 2 else: 3 * n + 1

proc handle(req: Request) {.async.} =
  var n = 0
  for key, value in decodeQuery(req.url.query):
    if key == "n":
      try:
        n = parseInt(value)
      except ValueError:
        discard
  let headers = newHttpHeaders({"Content-Type": "text/plain"})
  if n > 0:
    await req.respond(Http200, $step(n), headers)
  else:
    await req.respond(Http400, "need ?n=<positive integer>", headers)

echo "Nim is listening on :8000"
waitFor newAsyncHttpServer().serve(Port(8000), handle)
