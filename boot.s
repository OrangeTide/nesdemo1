; boot.s - Jon Mayo - May 4, 2009
;
; Start-up file for NES
;

.include "nesdefs.inc"
.include "util.inc"

.import _start, _nmi_vect, _irq_vect

.segment "CODE"

; write A to PPU and its mirror
write_ppu_reg1:
	sta PPU_CTRL_REG1
	sta PPU_CTRL_REG1
	rts

reset_vect:
	; init cpu
	sei
	cld	; doesn't do anything on a real NES cpu

	; reset stack pointer
	ldx #255
	txs

	; init PPU REG1
	lda #0
	sta PPU_CTRL_REG1
	sta PPU_CTRL_REG2

	WaitForVBlank ; wait for first vblank

;;; clear ram
; TODO

	WaitForVBlank ; wait for second vblank

;;; we could do a cold boot / warm boot check here


	jsr _start
	jmp reset_vect ; reset if _start ever returns

.segment "VECTORS"

.addr _nmi_vect, reset_vect, _irq_vect
