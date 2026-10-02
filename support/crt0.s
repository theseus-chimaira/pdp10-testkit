.text
__start:
	; Initialize PDP-10 stack pointer without a symbolic halfword literal.
	; A PUSH/PUSHJ increments both halves before storing, so use base-1.
	movei 17,__p10rt_stack-1
	hrli 17,-1000
	movei 1,1
	movem 1,__test_exit
	pushj 17,main
	movem 1,__test_exit
	; HALT is JRST with AC field 4; the tiny assembler has JRST, not HALT.
	jrst 4,0

.bss
__p10rt_stack:
	.block 1000
