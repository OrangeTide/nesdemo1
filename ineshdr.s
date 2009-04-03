; creates an iNES header using ca65 assembler

.segment "INESHDR"
.byt "NES", 26
.byt 1	; number of 16KiB PRG segments
.byt 1	; number of 8KiB CHR segments
.byt 0	; mapper
.byt 0	; extended mapper
.byt 0	; number of 8KiB RAM segments
.byt 0
.byt 0
.byt 0
.byt 0, 0, 0, 0
