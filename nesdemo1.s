.segment "CODE"

nmi_vect:
	rti

irq_vect:
	rti

reset_vect:
;;; init cpu
; TODO

;;; wait for vblank
; TODO

;;; clear ram
; TODO

;;; wait for vblank
; TODO

loop1:
	jmp loop1

.segment "VECTORS"

.addr nmi_vect, reset_vect, irq_vect
