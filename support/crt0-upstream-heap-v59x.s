; Heap-enabled variant; ordinary CRT is unchanged.
; 1024-word stack accommodates the imported large-frame heap clients.
; Bare-metal startup for upstream C execution tests without __test_exit.
; A return from main, exit(status), and abort() all record an observable
; result.  Never turn abort() into a successful return.
.text
.global __start
__start:
	movei 17,__p10rt_upstream_stack-1
	hrli 17,-2000
	movei 1,1
	movem 1,__test_exit
	pushj 17,__p10rt_heap_init_v59x
	pushj 17,main
	movem 1,__test_exit
	jrst 4,0

.bss
.global __test_exit
__test_exit:
	.block 1
__p10rt_upstream_stack:
	.block 2000
