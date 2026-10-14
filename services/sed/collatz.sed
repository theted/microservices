# One hailstone step in sed, by text substitution alone: sed has no numbers.
# Odd numbers are tripled (plus one) digit by digit from the right, with the
# carry riding along as a letter: a, b or c for a carry of 0, 1 or 2.
# Even numbers are halved digit by digit from the left, with < marking a
# leftover 10 for the next digit and > marking none.

/[13579]$/b odd

s/^/>/
:halve
s/>0/0>/; s/>1/0</; s/>2/1>/; s/>3/1</; s/>4/2>/
s/>5/2</; s/>6/3>/; s/>7/3</; s/>8/4>/; s/>9/4</
s/<0/5>/; s/<1/5</; s/<2/6>/; s/<3/6</; s/<4/7>/
s/<5/7</; s/<6/8>/; s/<7/8</; s/<8/9>/; s/<9/9</
/[<>][0-9]/b halve
s/>$//
s/^0*//
b

:odd
s/$/b/
:triple
s/0a/a0/; s/0b/a1/; s/0c/a2/
s/1a/a3/; s/1b/a4/; s/1c/a5/
s/2a/a6/; s/2b/a7/; s/2c/a8/
s/3a/a9/; s/3b/b0/; s/3c/b1/
s/4a/b2/; s/4b/b3/; s/4c/b4/
s/5a/b5/; s/5b/b6/; s/5c/b7/
s/6a/b8/; s/6b/b9/; s/6c/c0/
s/7a/c1/; s/7b/c2/; s/7c/c3/
s/8a/c4/; s/8b/c5/; s/8c/c6/
s/9a/c7/; s/9b/c8/; s/9c/c9/
/[0-9][abc]/b triple
s/^a//
s/^b/1/
s/^c/2/
