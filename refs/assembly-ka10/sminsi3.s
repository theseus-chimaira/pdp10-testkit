
smin:
	camle 1,2
	move 1,2
	popj 17,

smin_commuted:
	camle 2,1
	move 2,1
	move 1,2
	popj 17,

smin_if:
	camle 1,2
	move 1,2
	popj 17,

smin_if_commuted:
	camle 2,1
	move 2,1
	move 1,2
	popj 17,

smin_le:
	camle 1,2
	move 1,2
	popj 17,

smin_le_commuted:
	camle 2,1
	move 2,1
	move 1,2
	popj 17,

smin_gt:
	camle 1,2
	move 1,2
	popj 17,

smin_gt_commuted:
	camle 2,1
	move 2,1
	move 1,2
	popj 17,

smin_ge:
	camle 2,1
	move 2,1
	move 1,2
	popj 17,

smin_ge_commuted:
	camle 1,2
	move 1,2
	popj 17,

smin_zero:
	caile 1,0
	movei 1,0
	popj 17,

smin_zero_commuted:
	caile 1,0
	movei 1,0
	popj 17,

smin_one:
	caile 1,1
	movei 1,1
	popj 17,

smin_minus_one:
	camle 1,[-1]
	seto 1,
	popj 17,

smin_small_positive:
	caile 1,123
	movei 1,123
	popj 17,

smin_small_negative:
	camle 1,[-123]
	move 1,[-123]
	popj 17,

smin_large_positive:
	caile 1,123456
	movei 1,123456
	popj 17,

smin_large_negative:
	camle 1,[-123456]
	move 1,[-123456]
	popj 17,

smin_const_left:
	caile 1,123456
	movei 1,123456
	popj 17,

smin_const_negative_left:
	camle 1,[-123456]
	move 1,[-123456]
	popj 17,

smin_mem:
	move 4,1
	move 1,(2)
	camle 1,4
	move 1,4
	popj 17,

smin_mem_commuted:
	camle 1,(2)
	move 1,(2)
	popj 17,

smin_mem_mem:
	move 4,1
	move 1,(2)
	camle 1,(4)
	move 1,(4)
	popj 17,

smin_global:
	move 4,1
	move 1,smin_ga
	camle 1,4
	move 1,4
	popj 17,

smin_global_commuted:
	camle 1,smin_ga
	move 1,smin_ga
	popj 17,

smin_global_global:
	move 1,smin_gb
	camle 1,smin_ga
	move 1,smin_ga
	popj 17,

smin_volatile_global:
	move 4,1
	move 1,smin_vga
	camle 1,4
	move 1,4
	popj 17,

smin_volatile_mem:
	move 4,1
	move 1,(2)
	camle 1,4
	move 1,4
	popj 17,

smin_array:
	andi 2,17
	add 1,2
	move 1,(1)
	camle 1,3
	move 1,3
	popj 17,

smin_array_commuted:
	andi 2,17
	add 1,2
	camle 3,(1)
	move 3,(1)
	move 1,3
	popj 17,

smin_array_array:
	andi 2,17
	add 2,1
	andi 3,17
	add 1,3
	move 1,(1)
	camle 1,(2)
	move 1,(2)
	popj 17,

smin_global_array:
	andi 1,17
	move 1,smin_buf(1)
	camle 1,2
	move 1,2
	popj 17,

smin_global_array_array:
	move 4,1
	andi 4,17
	andi 2,17
	move 1,smin_buf(2)
	camle 1,smin_buf(4)
	move 1,smin_buf(4)
	popj 17,

smin_struct_a:
	move 1,(1)
	camle 1,2
	move 1,2
	popj 17,

smin_struct_b:
	camle 2,1(1)
	move 2,1(1)
	move 1,2
	popj 17,

smin_struct_ab:
	move 4,1
	move 1,1(1)
	camle 1,(4)
	move 1,(4)
	popj 17,

smin_trip_ab:
	move 4,1
	move 1,1(1)
	camle 1,(4)
	move 1,(4)
	popj 17,

smin_trip_abc:
	move 4,1
	move 1,1(1)
	camle 1,(4)
	move 1,(4)
	camle 1,2(4)
	move 1,2(4)
	popj 17,

smin_global_struct:
	move 1,smin_gp+1
	camle 1,smin_gp
	move 1,smin_gp
	popj 17,

smin_global_trip:
	move 1,smin_gtrip+1
	camle 1,smin_gtrip
	move 1,smin_gtrip
	camle 1,smin_gtrip+2
	move 1,smin_gtrip+2
	popj 17,

smin_store:
	camle 3,2
	move 3,2
	movem 3,(1)
	popj 17,

smin_store_return:
	camle 3,2
	move 3,2
	movem 3,(1)
	move 1,3
	popj 17,

smin_store_global:
	camle 2,1
	move 2,1
	movem 2,smin_ga
	popj 17,

smin_store_array:
	andi 2,17
	add 1,2
	camle 4,3
	move 4,3
	movem 4,(1)
	popj 17,

smin_store_struct_a:
	camle 3,2
	move 3,2
	movem 3,(1)
	popj 17,

smin_store_then_use:
	camle 3,2
	move 3,2
	movem 3,(1)
	add 3,4
	move 1,3
	popj 17,

smin_add:
	camle 2,1
	move 2,1
	add 2,3
	move 1,2
	popj 17,

smin_sub:
	camle 2,1
	move 2,1
	sub 2,3
	move 1,2
	popj 17,

smin_xor:
	camle 2,1
	move 2,1
	xor 2,3
	move 1,2
	popj 17,

smin_or:
	camle 2,1
	move 2,1
	ior 2,3
	move 1,2
	popj 17,

smin_and:
	camle 2,1
	move 2,1
	and 2,3
	move 1,2
	popj 17,

smin_mul:
	camle 2,1
	move 2,1
	imul 2,3
	move 1,2
	popj 17,

smin_nested_add:
	camle 2,1
	move 2,1
	camle 4,3
	move 4,3
	add 2,4
	move 1,2
	popj 17,

smin_nested_min:
	camle 2,1
	move 2,1
	camle 3,2
	move 3,2
	move 1,3
	popj 17,

smin_nested_min4:
	camle 2,1
	move 2,1
	camle 4,3
	move 4,3
	camle 4,2
	move 4,2
	move 1,4
	popj 17,

smin_local:
	camle 2,1
	move 2,1
	move 1,2
	popj 17,

smin_local_sources_live:
	move 4,1
	camge 2,1
	move 1,2
	add 1,4
	add 1,2
	add 1,3
	popj 17,

smin_memory_sources_live:
	move 6,1
	move 4,(2)
	camge 4,(1)
	skipa 1,4
	move 1,(1)
	add 1,(6)
	add 1,4
	add 1,3
	popj 17,

smin_reuse_left:
	camle 2,1
	move 2,1
	move 1,2
	popj 17,

smin_reuse_right:
	camle 2,1
	move 2,1
	move 1,2
	popj 17,

smin_if_result_zero:
	camle 2,1
	move 2,1
	move 1,3
	jumpe 2,%L68
	move 1,4
%L68:
	popj 17,

smin_if_result_nonzero:
	camle 2,1
	move 2,1
	move 1,3
	jumpn 2,%L70
	move 1,4
%L70:
	popj 17,

smin_if_result_negative:
	camle 2,1
	move 2,1
	move 1,3
	jumpl 2,%L72
	move 1,4
%L72:
	popj 17,

smin_if_result_positive:
	camle 2,1
	move 2,1
	move 1,3
	jumple 2,%L76
%L74:
	popj 17,
%L76:
	move 1,4
	popj 17,

smin_likely:
	camle 1,2
	move 1,2
	popj 17,

smin_unlikely:
	camle 1,2
	move 1,2
	popj 17,

smin_after_if:
	jumpe 1,%L82
	subi 2,1
%L83:
	camge 3,2
	skipa 1,3
	move 1,2
	popj 17,
%L82:
	soja 3,%L83

smin_before_if:
	camle 3,2
	move 3,2
	move 2,3
	add 2,4
	jumpn 1,%L84
	move 2,3
	sub 2,4
%L84:
	move 1,2
	popj 17,

smin_switch:
	move 6,1
	move 4,1
	andi 4,3
	camge 3,2
	skipa 1,3
	move 1,2
	cain 4,1
	popj 17,
	caig 4,1
	jrst %L94
	camge 3,6
	skipa 1,3
	move 1,6
	cain 4,2
	popj 17,
%L91:
	skiple 1,6
	movei 1,0
%L86:
	popj 17,
%L94:
	camge 2,6
	skipa 1,2
	move 1,6
	jumpe 4,%L86
	jrst %L91

smin_loop_pair:
	move 6,1
	move 1,(1)
	movei 3,1
	caml 3,2
	popj 17,
	subi 2,2
%L103:
	move 4,3
	andi 4,17
	add 4,6
	move 4,(4)
	camge 4,1
	move 1,4
	addi 3,1
	sojge 2,%L103	; doloop_end
	popj 17,

smin_loop_two_arrays:
	move 5,1
	move 1,(1)
	movei 7,0
	caml 7,3
	popj 17,
	move 6,3
	subi 6,1
%L113:
	move 4,7
	andi 4,17
	move 3,5
	add 3,4
	add 4,2
	move 4,(4)
	camle 4,(3)
	move 4,(3)
	camge 4,1
	move 1,4
	addi 7,1
	sojge 6,%L113	; doloop_end
	popj 17,

smin_loop_accumulate:
	move 4,3
	subi 3,1
	jumple 4,%L120
%L118:
	camge 2,1
	move 1,2
	subi 2,1
	move 4,3
	subi 3,1
	jumpg 4,%L118
%L120:
	popj 17,

smin_sqi:
	lsh 1,33
	ash 1,-33
	lsh 2,33
	ash 2,-33
	camle 2,1
	move 2,1
	move 1,2
	popj 17,

smin_sqi_si:
	lsh 1,33
	ash 1,-33
	camle 2,1
	move 2,1
	move 1,2
	popj 17,

smin_hi:
	hrre 1,1
	hrre 2,2
	camle 2,1
	move 2,1
	move 1,2
	popj 17,

smin_hi_si:
	hrre 1,1
	camle 2,1
	move 2,1
	move 1,2
	popj 17,

	.globl	sminsi3_smoke
sminsi3_smoke:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	move 10,2
	move 11,3
	pushj 17,smin
	move 2,10
	move 3,11
	pushj 17,smin_nested_min
	move 2,11
	move 3,12
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	jrst smin_add

	.globl	sn3mem
sn3mem:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 11,1
	move 12,2
	move 10,3
	pushj 17,smin_mem_mem
	move 2,1
	move 1,11
	move 3,10
	pushj 17,smin_store_return
	move 3,1
	move 1,11
	move 2,12
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	jrst smin_memory_sources_live

	.globl	sn3ctl
sn3ctl:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,2
	move 10,3
	pushj 17,smin_loop_pair
	move 2,1
	move 1,10
	move 3,smin_ga
	move 4,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	jrst smin_before_if

	.bss
smin_ga:
	.space	4
smin_gb:
	.space	4
smin_vga:
	.space	4
smin_buf:
	.space	64
smin_gp:
	.space	8
smin_gtrip:
	.space	12
