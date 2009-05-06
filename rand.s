; rand.s - Jon Mayo - May 5, 2009
;
; simplistic 8-bit pseudo-random number generator using shift and XOR with an odd number
;

.export srand, rand

.segment "DATA"
rand_current = 0

.segment "CODE"

; initialize the seed value
.proc srand
	sta rand_current
	rts
.endproc

; get a new random number
.proc rand
	lda rand_current
	lsr
	bcs :+ ; skip on carry set
	eor #123
:
	jmp srand ; store A into rand_current
.endproc

