// The original JavaScript-on-a-server, CommonJS and all.
const http = require("node:http");

const step = (n) => (n % 2 === 0 ? n / 2 : 3 * n + 1);

http
  .createServer((req, res) => {
    const n = Number(new URL(req.url, "http://localhost").searchParams.get("n"));
    res.setHeader("Content-Type", "text/plain");
    if (!Number.isSafeInteger(n) || n < 1) {
      res.writeHead(400).end("need ?n=<positive integer>");
      return;
    }
    res.end(String(step(n)));
  })
  .listen(8000, () => console.log("JavaScript (Node.js) is listening on :8000"));
