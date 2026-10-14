// The befunge93 package is an interpreter library, so this is its command line:
// stdin goes to the & instruction, and the output comes back when @ is reached.
const Befunge = require("befunge93");
const fs = require("node:fs");

const input = fs.readFileSync(0, "utf8").trim();
const befunge = new Befunge();
befunge.onInput = () => input;
befunge.onOutput = () => {};
befunge.run(fs.readFileSync(process.argv[2], "utf8")).then((output) => console.log(output.trim()));
