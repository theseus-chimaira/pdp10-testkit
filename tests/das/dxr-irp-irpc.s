.text
.irp X,1,2,3
.word \X
.endr
.irpc C,"456"
.word \C
.endr
.irp Z
.word 7\Z
.endr
.irp X,1,2
.word \X
.irp X,3,4
.word \X
.endr
.word \X
.endr
.rept 2
.irp Q,5,6
.word \Q
.endr
.endr
.macro OUT
.word \I
.endm
.irp I,11,12
OUT
.endr
.irpc P,"8,9"
.sixbit /\P/
.endr
.irpc N
.word 10\N
.endr
.irp A,1
.irp B,\A,2
.word \B
.endr
.endr
