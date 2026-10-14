; Minimal bare-metal C abort() for semantic tests.
; Always report failure, regardless of the previous status value.
.text
.global abort
abort:
	movei 1,1
	movem 1,__test_exit
	jrst 4,0
