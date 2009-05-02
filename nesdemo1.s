; nesdemo1.s - Jon Mayo - April 30, 2009
;
; flashes the screen randomly.
; uses CHR-RAM and loads data manually.
;

.include "nesdefs.inc"
.include "util.inc"
.segment "ZEROPAGE"
Flashing_color = 30

.segment "RODATA"
Name_table_entries = 960

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

	WaitForVBlank ; wait for first vblank

	;;; clear ram
	; TODO

	WaitForVBlank ; wait for second vblank

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

	; set PPU to CHR-RAM (Pattern Table 0)
	lda #$0
	sta PPU_ADDRESS
	lda #0
	sta PPU_ADDRESS

	; plane0
	lda #%11111111
	sta PPU_DATA
	lda #%10000001
	sta PPU_DATA
	lda #%10100101
	sta PPU_DATA
	lda #%10100101
	sta PPU_DATA
	lda #%10000001
	sta PPU_DATA
	lda #%10111101
	sta PPU_DATA
	lda #%10011001
	sta PPU_DATA
	lda #%10000001
	sta PPU_DATA
	lda #%11111111
	sta PPU_DATA

	; plane1
	lda #%11111111
	sta PPU_DATA
	lda #%10000001
	sta PPU_DATA
	lda #%10000001
	sta PPU_DATA
	lda #%10000001
	sta PPU_DATA
	lda #%10000001
	sta PPU_DATA
	lda #%10000001
	sta PPU_DATA
	lda #%10000001
	sta PPU_DATA
	lda #%10000001
	sta PPU_DATA
	lda #%11111111
	sta PPU_DATA

	; set PPU to Name Table 0
	lda #$20
	sta PPU_ADDRESS
	lda #0
	sta PPU_ADDRESS

	; init name table data
	ldx #$03 ; $3c0 = 960 name table entries
	lda #0 ; copy a 0 to each entry
init_name_table1:
	ldy #$c0
init_name_table2:
	sta PPU_DATA
	dey
	bne init_name_table2 ; branch on Z=0
	dex
	bne init_name_table1 ; branch on Z=0

	WaitForVBlank ; wait for vblank before enabling display

	; enable screen display %fffpcsit
	; - black background
	; - sprites off
	; - background visible
	; - no sprite clipping
	; - no background clipping
	; - color display
	lda #%00001110 ; enable screen display
	sta PPU_CTRL_REG2

	; scroll to top left
	lda #0 
	sta PPU_SCROLL_REG
	sta PPU_SCROLL_REG

	; enable NMI on VBlank.
	; - use VRAM $0000 for background and sprite pattern table.
	; - 8x8 sprites.
	; - use VRAM $2000 for name table
	lda #%10000000
	sta PPU_CTRL_REG1

loop_forever:
	jmp loop_forever

.segment "VECTORS"

.addr nmi_vect, reset_vect, irq_vect
