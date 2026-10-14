// One hailstone step in JavaScript, on Node.js.
const step = (n) => (n % 2 === 0 ? n / 2 : 3 * n + 1);

console.log(step(Number(require("node:fs").readFileSync(0, "utf8"))));
