// One hailstone step in TypeScript, run as-is by Bun.
const step = (n: number): number => (n % 2 === 0 ? n / 2 : 3 * n + 1);

console.log(step(Number(await Bun.stdin.text())));
