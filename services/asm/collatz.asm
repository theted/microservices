; One hailstone step in x86-64 Linux assembly. No libc: read n from stdin,
; step it, and write it back out, with three syscalls in total.

bits 64
default rel

section .bss
input:      resb 32
output:     resb 24

section .text
global _start
_start:
    xor eax, eax                    ; read(0, input, 32)
    xor edi, edi
    lea rsi, [input]
    mov edx, 32
    syscall

    ; Parse decimal digits until anything else.
    lea rsi, [input]
    xor eax, eax
.parse:
    movzx edx, byte [rsi]
    sub edx, '0'
    cmp edx, 9
    ja .step                        ; unsigned: anything that isn't a digit
    imul rax, rax, 10
    add rax, rdx
    inc rsi
    jmp .parse

.step:
    test al, 1
    jnz .odd
    shr rax, 1
    jmp .print
.odd:
    lea rax, [rax + rax*2 + 1]

    ; Write the digits backwards from the end of the buffer, then a newline.
.print:
    lea rdi, [output + 24]
    dec rdi
    mov byte [rdi], 10
    mov ecx, 10
.digit:
    xor edx, edx
    div rcx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    test rax, rax
    jnz .digit

    mov eax, 1                      ; write(1, rdi, end - rdi)
    lea rdx, [output + 24]
    sub rdx, rdi
    mov rsi, rdi
    mov edi, 1
    syscall

    mov eax, 60                     ; exit(0)
    xor edi, edi
    syscall
