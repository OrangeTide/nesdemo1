; Utilities for NES programming

;; GENERIC 6502 STUFF

; arithmetic shift right - taken from cc65 manual
.macro  asr     arg

    .if (.not .blank(arg)) .and (.not .match (arg, a))
    .error "Syntax error"
    .endif

    cmp     #$80            ; Bit 7 into carry
    lsr     a               ; Shift carry into bit 7

.endmacro

;; NES Specific things : Graphics and PPU

.macro WaitForVBlank
:
	lda PPU_STATUS
	bpl :-
.endmacro

;; NES Specific things : Gamepads and Input
;; NES Specific things : Sound and Music
