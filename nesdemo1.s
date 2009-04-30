.include "util.inc"
.include "nesdefs.inc"
.segment "ZEROPAGE"
Flashing_color = 30

.segment "CODE"

; write A to PPU and its mirror
write_ppu_reg1:
	sta PPU_CTRL_REG1
	sta PPU_CTRL_REG1
	rts

nmi_vect:
	pha ; save A

	lda PPU_STATUS
	ora #%10000000
	sta PPU_CTRL_REG1

	;lda PPU_CTRL_REG2
	;eor #%01000000
	;sta PPU_CTRL_REG2

	; set PPU to palette RAM
	lda #$3f
	sta PPU_ADDRESS
	lda #0
	sta PPU_ADDRESS

	; set background to a new color
	lda Flashing_color
	inc Flashing_color
	sta PPU_DATA

	pla ; restore A
	rti

irq_vect:
	rti

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

	; set PPU to palette RAM
	lda #$3f
	sta PPU_ADDRESS
	lda #0
	sta PPU_ADDRESS
	
	; set background to blue
	lda #$21
	sta PPU_DATA

	; set 3 foreground colors to white
	lda #$ff
	sta PPU_DATA
	sta PPU_DATA
	sta PPU_DATA

;;; wait for vblank before enabling display
vblankwait3:
	lda PPU_STATUS
	bpl vblankwait3

	; enable scree display
	lda #%00001000 ; enable screen display
	sta PPU_CTRL_REG2

	; scroll to top left
	lda #0 
	sta PPU_CTRL_REG1
	sta PPU_SCROLL_REG
	sta PPU_SCROLL_REG

	; enable NMI on VBlank
	lda PPU_CTRL_REG1
	ora #%10000000
	sta PPU_CTRL_REG1

loop1:
	jmp loop1

.segment "VECTORS"

.addr nmi_vect, reset_vect, irq_vect
