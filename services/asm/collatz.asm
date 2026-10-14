; One hailstone step over HTTP, in x86-64 Linux assembly.
; No libc and no runtime: a handful of raw syscalls and about a kilobyte of binary.

bits 64
default rel

%define SYS_READ        0
%define SYS_CLOSE       3
%define SYS_SOCKET      41
%define SYS_ACCEPT      43
%define SYS_SENDTO      44
%define SYS_BIND        49
%define SYS_LISTEN      50
%define SYS_SETSOCKOPT  54
%define SYS_EXIT        60

%define AF_INET         2
%define SOCK_STREAM     1
%define SOL_SOCKET      1
%define SO_REUSEADDR    2
%define MSG_NOSIGNAL    0x4000

section .data
sockaddr:   dw AF_INET
            db 0x1f, 0x40           ; port 8000, network byte order
            dd 0                    ; INADDR_ANY
            dq 0
one:        dd 1
ok:         db "HTTP/1.0 200 OK", 13, 10, "Content-Type: text/plain", 13, 10, 13, 10
ok_len      equ $ - ok
bad:        db "HTTP/1.0 400 Bad Request", 13, 10, "Content-Type: text/plain", 13, 10, 13, 10
            db "need ?n=<positive integer>"
bad_len     equ $ - bad

section .bss
request:    resb 4096
digits:     resb 24

section .text
global _start
_start:
    mov eax, SYS_SOCKET
    mov edi, AF_INET
    mov esi, SOCK_STREAM
    xor edx, edx
    syscall
    test eax, eax
    js die
    mov r12d, eax                   ; r12 = listening socket

    mov eax, SYS_SETSOCKOPT
    mov edi, r12d
    mov esi, SOL_SOCKET
    mov edx, SO_REUSEADDR
    lea r10, [one]
    mov r8d, 4
    syscall

    mov eax, SYS_BIND
    mov edi, r12d
    lea rsi, [sockaddr]
    mov edx, 16
    syscall
    test eax, eax
    jnz die

    mov eax, SYS_LISTEN
    mov edi, r12d
    mov esi, 128
    syscall

serve:
    mov eax, SYS_ACCEPT
    mov edi, r12d
    xor esi, esi
    xor edx, edx
    syscall
    test eax, eax
    js serve
    mov r13d, eax                   ; r13 = client socket

    mov eax, SYS_READ
    mov edi, r13d
    lea rsi, [request]
    mov edx, 4095
    syscall
    test rax, rax
    jle hang_up
    lea rsi, [request]
    mov byte [rsi + rax], 0

    ; Scan the request line for "?n=" or "&n=".
find:
    mov al, [rsi]
    test al, al
    jz reject
    cmp al, 10
    je reject
    cmp al, '?'
    je .separator
    cmp al, '&'
    jne .next
.separator:
    cmp word [rsi + 1], 'n='
    je found
.next:
    inc rsi
    jmp find

found:
    add rsi, 3
    xor eax, eax                    ; rax = n
    xor ecx, ecx                    ; digits read
parse:
    movzx edx, byte [rsi]
    sub edx, '0'
    cmp edx, 9
    ja parsed                       ; unsigned: anything that isn't a digit
    imul rax, rax, 10
    add rax, rdx
    inc rsi
    inc ecx
    cmp ecx, 18
    ja reject
    jmp parse
parsed:
    test rax, rax
    jz reject

    ; The business logic.
    test al, 1
    jnz .odd
    shr rax, 1
    jmp .itoa
.odd:
    lea rax, [rax + rax*2 + 1]

    ; Write the digits backwards from the end of the buffer.
.itoa:
    lea rdi, [digits + 24]
    mov rbx, rdi
    mov ecx, 10
.digit:
    xor edx, edx
    div rcx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    test rax, rax
    jnz .digit
    sub rbx, rdi                    ; rbx = digit count
    mov r14, rdi                    ; r14 = first digit

    lea rsi, [ok]
    mov edx, ok_len
    call send
    mov rsi, r14
    mov rdx, rbx
    call send
    jmp hang_up

reject:
    lea rsi, [bad]
    mov edx, bad_len
    call send

hang_up:
    mov eax, SYS_CLOSE
    mov edi, r13d
    syscall
    jmp serve

; send(rsi = buffer, rdx = length) to the client socket; never raises SIGPIPE.
send:
    mov eax, SYS_SENDTO
    mov edi, r13d
    mov r10d, MSG_NOSIGNAL
    xor r8d, r8d
    xor r9d, r9d
    syscall
    ret

die:
    mov eax, SYS_EXIT
    mov edi, 1
    syscall
