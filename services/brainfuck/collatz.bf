One hailstone step in Brainfuck
with eight bit cells and no numbers bigger than nine anywhere
Every digit is a block of ten cells and the arithmetic is long hand
just like at school

Read the digits into blocks of ten cells each: marker / digit / carry / scratch
Block one is a leading zero so that tripling always has room to grow
    >>>>>>>>>>+>>>>>>>>>>>,----------[--------------------------------------
    <+>>>>>>>>>>>,----------]
Parity of the last digit: copy it and toggle two flags once per unit
    <<<<<<<<<<[->>+>+<<<]>>>[-<<<+>>>]>>>>>>>>>>+<<<<<<<<<<<[->>>>>>>>>>[->>
    +<<]>[-<+>]>[-<+>]<<<<<<<<<<<<]
Odd: triple and add one from the right with a carry of zero to two
    >>>>>>>>>>[-<<<<<<<<<<<+<<[>[->>+++<<]>[->+<]>>++++++++++<[->-[>+>>]>[+[
    -<+>]>+>>]<<<<<]>[-]>[-<<<<+>>>>]>[-<<<<<<<<<<<<<<+>>>>>>>>>>>>>>]<<<<<<
    <<<<<<<<<<]>>>>>>>>>>[>>>>>>>>>>]>>>]
Even: halve from the left and pass the remainder on as five
    >[-<<<<<<<<<<<<<<[<<<<<<<<<<]>>>>>>>>>>[>[->>+>+<<<]>>>[-<<<+>>>]>>+<<<[
    ->>[->>+<<]>[-<+>]>[-<+>]<<<<]>>>[-]<[-<<<<->>>>>>>>>>>+<<<<<<<]<<<<[-->
    >+<<]>>[-<<+>>]<[-<+++++>]>>>>>>>>]>>>>]
Skip leading zero digits by passing a flag along until a digit is not zero
    <<<<<<<<<<<<<<[<<<<<<<<<<]>>>>>>>>>>>>>>>>>>>+[-<<<<<<<<[->>+>>+<<<<]>>>
    >[-<<<<+>>>>]<+<[>-<[-]]>[->>>>>>>>>>>>>>>+<<<<<<<<<<<<<<<]>>>>>>>>>>>>>
    >>]
Print the rest as ASCII digits and a newline
    <<<<<<<<<<<<<<<<<<<[>++++++++++++++++++++++++++++++++++++++++++++++++.>>
    >>>>>>>]++++++++++.
