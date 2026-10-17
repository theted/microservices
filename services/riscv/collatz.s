# One hailstone step in RISC-V assembly, run by qemu on an x86 machine.
        .section .bss
input:  .space 32
output: .space 24

        .section .text
        .globl _start
_start:
        li a7, 63               # read(0, input, 32)
        li a0, 0
        la a1, input
        li a2, 32
        ecall

        la t0, input            # parse decimal digits into t1
        li t1, 0
        li t3, 10
parse:  lbu t2, 0(t0)
        addi t2, t2, -48
        bgeu t2, t3, step       # unsigned: anything that isn't a digit
        mul t1, t1, t3
        add t1, t1, t2
        addi t0, t0, 1
        j parse

step:   andi t2, t1, 1
        bnez t2, odd
        srli t1, t1, 1
        j print
odd:    slli t2, t1, 1          # 3n + 1 = (n << 1) + n + 1
        add t1, t1, t2
        addi t1, t1, 1

print:  la t0, output + 24      # digits go in backwards, after a newline
        addi t0, t0, -1
        li t2, 10
        sb t2, 0(t0)
digit:  remu t2, t1, t3
        divu t1, t1, t3
        addi t2, t2, 48
        addi t0, t0, -1
        sb t2, 0(t0)
        bnez t1, digit

        li a7, 64               # write(1, t0, end - t0)
        li a0, 1
        mv a1, t0
        la a2, output + 24
        sub a2, a2, t0
        ecall

        li a7, 93               # exit(0)
        li a0, 0
        ecall
