; game3.s - Jon Mayo - May 4, 2009
;

.include "nesdefs.inc"
.include "util.inc"

.export _start, _nmi_vect, _irq_vect

.ZEROPAGE
ScrollX = 0
ScrollY = 0

.segment "CODE"

.proc _start

	; set PPU to palette RAM
	lda #$3f
	sta PPU_ADDRESS
	lda #0
	sta PPU_ADDRESS
	
	; load first 4 colors
	lda #$0f ; black (don't use $0d)
	sta PPU_DATA
	lda #$16 ; orange
	sta PPU_DATA
	lda #$39 ; yellow
	sta PPU_DATA
	lda #$ff ; white
	sta PPU_DATA

	; init name table data

	; set PPU to Name Table #0
	lda #$20
	sta PPU_ADDRESS
	lda #0
	sta PPU_ADDRESS

	lda #22 ; copy to each entry
	jsr fill_name_table 

	; set PPU to Name Table #2
	lda #$28
	sta PPU_ADDRESS
	lda #0
	sta PPU_ADDRESS

	lda #14 ; copy to each entry
	jsr fill_name_table 

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

@loop_forever:
	jmp @loop_forever
.endproc

fill_name_table: ; A is the value to fill
	ldx #5 ; 5*192 == 960 name table entries
init_name_table1:
	ldy #192
init_name_table2:
	sta PPU_DATA
	; adc #1 ; increment
	dey
	bne init_name_table2 ; branch on Z=0
	dex
	bne init_name_table1 ; branch on Z=0
	rts

_nmi_vect:
	pha ; save A

	lda PPU_STATUS
	ora #%10000000
	sta PPU_CTRL_REG1

	; scroll around
	lda #0 ; load 0 into horizontal
	sta PPU_SCROLL_REG
	lda ScrollY ; vertical
	sta PPU_SCROLL_REG
	inc ScrollY

	pla ; restore A
	rti

_irq_vect:
	rti

.segment "RODATA"
Name_table_entries = 960

