.include "util.inc"
.include "nesdefs.inc"
.segment "CODE"

; write A to PPU and its mirror
write_ppu_reg1:
	sta PPU_CTRL_REG1
	sta PPU_CTRL_REG1
	rts

nmi_vect:
	lda PPU_STATUS
	pla
	ora #127
	sta PPU_CTRL_REG1
	rti

irq_vect:
	rti

reset_vect:

; init cpu
	sei
	cld	; doesn't do anything on a real NES cpu
; init PPU REG1
	lda #16
	sta PPU_CTRL_REG1
; reset stack pointer
	ldx #255
	txs

;;; wait for first vblank
vblankwait1:
	lda PPU_STATUS
	bpl vblankwait1

;;; clear ram
; TODO

;;; wait for second vblank
vblankwait2:
	lda PPU_STATUS
	bpl vblankwait2

;;; we could do a cold boot / warm boot check here

	ora #127
	sta PPU_CTRL_REG1

loop1:
	jmp loop1

.segment "VECTORS"

.addr nmi_vect, reset_vect, irq_vect
