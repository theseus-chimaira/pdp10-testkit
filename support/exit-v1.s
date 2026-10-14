; Minimal bare-metal C exit(status) for semantic tests.
; AC1 is the C return-value register.  HALT via JRST 4,0.
.text
.global exit
exit:
	movem 1,__test_exit
	jrst 4,0
