const step = (n: number): number => (n % 2 === 0 ? n / 2 : 3 * n + 1);

Bun.serve({
  port: 8000,
  fetch(req: Request): Response {
    const n = Number(new URL(req.url).searchParams.get("n"));
    if (!Number.isSafeInteger(n) || n < 1) {
      return new Response("need ?n=<positive integer>", { status: 400 });
    }
    return new Response(String(step(n)));
  },
});

console.log("TypeScript (on Bun) is listening on :8000");
