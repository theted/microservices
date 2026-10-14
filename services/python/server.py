from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import parse_qs, urlparse


def step(n: int) -> int:
    return n // 2 if n % 2 == 0 else 3 * n + 1


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        try:
            n = int(parse_qs(urlparse(self.path).query)["n"][0])
            if n < 1:
                raise ValueError(n)
        except (KeyError, ValueError):
            return self.reply(400, "need ?n=<positive integer>")
        self.reply(200, str(step(n)))

    def reply(self, status: int, body: str):
        data = body.encode()
        self.send_response(status)
        self.send_header("Content-Type", "text/plain")
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)


print("Python is listening on :8000", flush=True)
ThreadingHTTPServer(("", 8000), Handler).serve_forever()
