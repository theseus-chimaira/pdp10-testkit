; Bare-metal startup for upstream C execution tests without __test_exit.
; A return from main, exit(status), and abort() all record an observable
; result.  Never turn abort() into a successful return.
.text
.global __start
__start:
	movei 17,__p10rt_upstream_stack-1
	hrli 17,-1000
	movei 1,1
	movem 1,__test_exit
	pushj 17,main
	movem 1,__test_exit
	jrst 4,0

.bss
.global __test_exit
__test_exit:
	.block 1
__p10rt_upstream_stack:
	.block 1000
