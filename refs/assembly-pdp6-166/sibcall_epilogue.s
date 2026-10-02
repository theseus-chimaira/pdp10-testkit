
bar:
	jrst scalar_memory_forms

baz:
	jrst bar

sibcall_direct0:
	jrst f0

sibcall_direct1:
	jrst f1

sibcall_direct2:
	jrst f2

sibcall_direct3:
	jrst f3

sibcall_direct4:
	jrst f4

sibcall_direct5:
	add 17,[1,,1]
	add 17,[-1,,-1]
	jrst f5

sibcall_direct6:
	add 17,[2,,2]
	move 6,-3(17)
	movem 6,(17)
	move 6,-4(17)
	movem 6,-1(17)
	pushj 17,f6
	add 17,[-2,,-2]
	popj 17,

sibcall_add_arg:
	addi 1,1
	jrst f1

sibcall_sub_arg:
	subi 1,1
	jrst f1

sibcall_neg_arg:
	movn 1,1
	jrst f1

sibcall_not_arg:
	setca 1,
	jrst f1

sibcall_and_arg:
	hrrz 1,1
	jrst f1

sibcall_or_arg:
	iori 1,123456
	jrst f1

sibcall_xor_arg:
	xori 1,525252
	jrst f1

sibcall_shift_left_arg:
	lsh 1,1
	jrst f1

sibcall_shift_right_arg:
	ash 1,-1
	jrst f1

sibcall_two_rewrite:
	move 4,1
	add 1,2
	sub 4,2
	move 2,4
	jrst f2

sibcall_three_rewrite:
	move 4,1
	add 1,2
	add 2,3
	xor 4,3
	move 3,4
	jrst f3

sibcall_wrap1:
	jrst f1

sibcall_wrap2:
	jrst sibcall_wrap1

sibcall_wrap3:
	jrst sibcall_wrap2

sibcall_wrap4:
	jrst sibcall_wrap3

sibcall_wrap_add1:
	addi 1,1
	jrst f1

sibcall_wrap_add2:
	addi 1,1
	jrst sibcall_wrap_add1

sibcall_wrap_add3:
	addi 1,1
	jrst sibcall_wrap_add2

sibcall_global1:
	move 1,sibcall_ga
	jrst f1

sibcall_global2:
	move 2,sibcall_ga
	jrst f2

sibcall_global3:
	move 2,sibcall_ga
	move 3,sibcall_gb
	jrst f3

sibcall_global_expr:
	move 2,1
	add 1,sibcall_ga
	xor 2,sibcall_gb
	jrst f2

sibcall_volatile1:
	move 2,sibcall_vga
	jrst f2

sibcall_volatile_expr:
	move 2,sibcall_vga
	add 1,2
	jrst f2

sibcall_mem1:
	move 1,(1)
	jrst f1

sibcall_mem2:
	move 1,(1)
	move 2,(2)
	jrst f2

sibcall_mem3:
	move 1,(1)
	move 2,(2)
	move 3,(3)
	jrst f3

sibcall_mem_expr:
	move 4,2
	move 2,(1)
	move 4,(4)
	move 1,2
	add 1,4
	xor 2,4
	jrst f2

sibcall_array:
	andi 2,17
	add 1,2
	move 1,(1)
	jrst f1

sibcall_array2:
	move 4,1
	andi 2,17
	add 2,1
	andi 3,17
	add 4,3
	move 1,(2)
	move 2,(4)
	jrst f2

sibcall_global_array:
	andi 1,17
	move 1,sibcall_buf(1)
	jrst f1

sibcall_global_array2:
	andi 1,17
	andi 2,17
	move 1,sibcall_buf(1)
	move 2,sibcall_buf(2)
	jrst f2

sibcall_struct_a:
	move 1,(1)
	jrst f1

sibcall_struct_b:
	move 1,1(1)
	jrst f1

sibcall_struct_ab:
	move 2,1(1)
	move 1,(1)
	jrst f2

sibcall_struct_expr:
	move 2,(1)
	move 4,1(1)
	move 1,2
	add 1,4
	xor 2,4
	jrst f2

sibcall_trip_abc:
	move 2,1(1)
	move 3,2(1)
	move 1,(1)
	jrst f3

sibcall_global_struct:
	move 1,sibcall_gp
	move 2,sibcall_gp+1
	jrst f2

sibcall_global_trip:
	move 1,sibcall_gt
	move 2,sibcall_gt+1
	move 3,sibcall_gt+2
	jrst f3

sibcall_if_else:
	jumpn 1,f1
	move 1,2
%L57:
	jrst f1

sibcall_if_else_two:
	camge 1,2
	jrst f2
	move 1,2
	move 2,3
	jrst f2

sibcall_if_else_mixed:
	move 4,1
	trnn 1,1
	jrst f2
	add 4,2
	move 1,4
	jrst f1

sibcall_nested:
	jumpe 1,f3
	jumpe 2,%L65
	jrst f1
%L65:
	move 2,3
	jrst f2
%L64:
	jrst f3

sibcall_cond_global:
	skipe sibcall_ga
	jrst f1
	move 2,sibcall_gb
	jrst f2

sibcall_cond_mem:
	skipn (1)
	jrst %L69
	move 1,2
	jrst f1
%L69:
	move 1,2
	movei 2,0
	jrst f2

sibcall_switch:
	move 4,1
	move 3,2
	andi 4,3
	cain 4,1
	jrst f2
	caig 4,1
	jrst %L79
	cain 4,2
	jrst %L74
%L75:
	move 1,3
%L78:
	jrst f1
%L74:
	move 3,sibcall_ga
	jrst f3
%L79:
	jumpe 4,f1
	jrst %L75

sibcall_switch_dense:
	move 6,1
	move 4,1
	andi 4,7
	jumpl 4,%L89
	caile 4,6
	jrst %L89
	jrst @%L90(4)
%L90:
	.word	.93
	.word	.83
	.word	.92
	.word	.85
	.word	.91
	.word	.87
	.word	.88
%L83:
	move 1,2
%L93:
	jrst f1
%L89:
	move 1,3
	jrst f1
%L92:
	jrst f2
%L85:
	move 1,2
	move 2,3
	jrst f2
%L91:
	jrst f3
%L87:
	move 1,3
	move 3,6
	jrst f3
%L88:
	move 4,sibcall_ga
	jrst f4

sibcall_fptr1:
	move 4,1
	move 1,2
	pushj 17,(4)
	popj 17,

sibcall_fptr2:
	move 4,1
	move 1,2
	move 2,3
	pushj 17,(4)
	popj 17,

sibcall_fptr_expr:
	move 4,1
	move 1,2
	add 1,3
	xor 2,3
	pushj 17,(4)
	popj 17,

sibcall_external_fptr:
	jrst fptr

sibcall_external_fptr2:
	jrst gptr

sibcall_local1:
	add 1,2
	jrst f1

sibcall_local2:
	add 1,2
	add 2,3
	jrst f2

sibcall_local3:
	move 4,3
	add 1,2
	xor 4,2
	move 3,1
	sub 3,4
	move 2,4
	jrst f3

sibcall_local_memory:
	move 4,2
	move 2,(1)
	move 4,(4)
	move 1,2
	add 1,4
	xor 2,4
	jrst f2

sibcall_store_then_call:
	movem 2,(1)
	move 1,2
	jrst f1

sibcall_store_expr_then_call:
	add 2,3
	movem 2,(1)
	move 1,2
	move 2,3
	jrst f2

sibcall_store_global_then_call:
	movem 1,sibcall_ga
	jrst f1

sibcall_store_struct_then_call:
	move 4,2
	movem 2,(1)
	move 2,1(1)
	move 1,4
	jrst f2

not_sibcall_add_after:
	pushj 17,f1
	addi 1,1
	popj 17,

not_sibcall_sub_after:
	push 17,10
	move 10,1
	pushj 17,f1
	sub 1,10
	pop 17,10
	popj 17,

not_sibcall_store_after:
	push 17,10
	move 10,1
	move 1,2
	pushj 17,f1
	movem 1,(10)
	pop 17,10
	popj 17,

not_sibcall_use_after:
	push 17,10
	move 10,1
	pushj 17,f2
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

not_sibcall_cond_after:
	push 17,10
	move 10,1
	pushj 17,f2
	move 4,1
	jumpn 1,%L111
	move 4,10
%L111:
	move 1,4
	pop 17,10
	popj 17,

	.globl	sibcall_epilogue_smoke
sibcall_epilogue_smoke:
	trne 1,1
	jrst sibcall_direct1
	trne 2,1
	jrst sibcall_direct2
	trne 3,1
	jrst sibcall_if_else
	jrst sibcall_switch

	.globl	sbcmem
sbcmem:
	trne 3,1
	jrst sibcall_mem2
	trnn 3,2
	jrst sibcall_local_memory
	move 2,3
	jrst sibcall_store_then_call

	.globl	sbcneg
sbcneg:
	trne 2,1
	jrst %L126
	trnn 2,2
	jrst %L125
	move 2,3
	jrst not_sibcall_store_after
%L125:
	move 1,2
	move 2,3
	jrst not_sibcall_use_after
%L126:
	move 1,2
	jrst not_sibcall_add_after

	.bss
sibcall_ga:
	.space	4
sibcall_gb:
	.space	4
sibcall_gc:
	.space	4
sibcall_vga:
	.space	4
sibcall_buf:
	.space	64
sibcall_gp:
	.space	8
sibcall_gt:
	.space	12
