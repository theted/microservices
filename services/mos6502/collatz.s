; One hailstone step in 6502 assembly, the CPU of the Commodore 64, the NES and
; the Apple II. It has no multiply or divide, but it does have a decimal mode:
; with SED, ADC adds binary-coded decimal. So n stays in BCD the whole way,
; two digits per byte, and tripling is literally n + n + n + 1 in decimal.

        .import _read, _write, pushax
        .export _main

        .bss
input:  .res 16
digit:  .res 1
num:    .res 5                  ; ten BCD digits, most significant byte first
twice:  .res 5
output: .res 12
started:.res 1

        .code
_main:  cld

        ; read(0, input, 16)
        lda #0
        tax
        jsr pushax
        lda #<input
        ldx #>input
        jsr pushax
        lda #16
        ldx #0
        jsr _read

        ; Pack the ASCII digits into num, one nibble at a time.
        ldy #0
parse:  lda input,y
        sec
        sbc #'0'
        cmp #10
        bcs parsed              ; not a digit
        sta digit
        ldx #4
shift:  asl num+4
        rol num+3
        rol num+2
        rol num+1
        rol num+0
        dex
        bne shift
        lda num+4
        ora digit
        sta num+4
        iny
        bne parse
parsed:
        lda num+4               ; the last digit's low bit is n's parity
        lsr
        bcs odd

        ; Even: shift right one bit. A digit that caught a bit from the digit
        ; above it now reads 8 or more, but that bit was worth 5, not 8: take 3.
        lsr num+0
        ror num+1
        ror num+2
        ror num+3
        ror num+4
        ldy #0
fix:    lda num,y
        cmp #$80
        bcc fixlow
        sbc #$30
fixlow: tax
        and #$0f
        cmp #$08
        txa
        bcc fixed
        sbc #$03
fixed:  sta num,y
        iny
        cpy #5
        bne fix
        jmp print

        ; Odd: in decimal mode, twice = n + n, then n = twice + n + 1.
odd:    sed
        clc
        ldy #4
double: lda num,y
        adc num,y
        sta twice,y
        dey
        bpl double
        sec                     ; the + 1 rides in as the carry
        ldy #4
triple: lda twice,y
        adc num,y
        sta num,y
        dey
        bpl triple
        cld

        ; Unpack the digits, skipping leading zeros.
print:  ldx #0
        ldy #0
unpack: lda num,y
        lsr
        lsr
        lsr
        lsr
        jsr emit
        lda num,y
        and #$0f
        jsr emit
        iny
        cpy #5
        bne unpack
        lda #10
        sta output,x
        inx

        ; write(1, output, x)
        txa
        pha
        lda #1
        ldx #0
        jsr pushax
        lda #<output
        ldx #>output
        jsr pushax
        pla
        ldx #0
        jsr _write
        lda #0
        tax
        rts

emit:   bne digit_on
        bit started
        bmi digit_on2
        rts
digit_on:
        pha
        lda #$80
        sta started
        pla
digit_on2:
        ora #'0'
        sta output,x
        inx
        rts
