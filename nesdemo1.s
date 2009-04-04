.include "util.inc"
.include "nesdefs.inc"
.segment "CODE"

nmi_vect:
	rti

irq_vect:
	rti

reset_vect:
;;; init cpu
; TODO

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

loop1:
	jmp loop1

.segment "VECTORS"

.addr nmi_vect, reset_vect, irq_vect
