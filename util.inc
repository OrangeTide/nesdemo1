
; arithmetic shift right - taken from cc65 manual
.macro  asr     arg

    .if (.not .blank(arg)) .and (.not .match (arg, a))
    .error "Syntax error"
    .endif

    cmp     #$80            ; Bit 7 into carry
    lsr     a               ; Shift carry into bit 7

.endmacro



