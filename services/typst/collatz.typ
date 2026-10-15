// One hailstone step in Typst, a typesetting language. n arrives as a
// document input, and `typst query` reads the answer back out of the
// document's metadata, so nothing ever gets typeset.
#let n = int(sys.inputs.n)
#metadata(if calc.even(n) { calc.quo(n, 2) } else { 3 * n + 1 }) <next>
