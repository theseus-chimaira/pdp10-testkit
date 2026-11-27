; Heap-enabled variant; ordinary CRT is unchanged.
; 1024-word stack accommodates the imported large-frame heap clients.
.text
__start:
	; Initialize PDP-10 stack pointer without a symbolic halfword literal.
	; A PUSH/PUSHJ increments both halves before storing, so use base-1.
	movei 17,__p10rt_stack-1
	hrli 17,-2000
	movei 1,1
	movem 1,__test_exit
	pushj 17,__p10rt_heap_init_v59x
	pushj 17,main
	movem 1,__test_exit
	; HALT is JRST with AC field 4; the tiny assembler has JRST, not HALT.
	jrst 4,0

.bss
__p10rt_stack:
	.block 2000
