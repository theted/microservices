\ One hailstone step. Forth reads like a recipe for the stack.
: step ( n -- n' )  dup 2 mod if 3 * 1+ else 2/ then ;
