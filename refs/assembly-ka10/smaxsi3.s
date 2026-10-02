
smax:
	camge 1,2
	move 1,2
	popj 17,

smax_commuted:
	camge 2,1
	move 2,1
	move 1,2
	popj 17,

smax_if:
	camge 1,2
	move 1,2
	popj 17,

smax_if_commuted:
	camge 2,1
	move 2,1
	move 1,2
	popj 17,

smax_ge:
	camge 1,2
	move 1,2
	popj 17,

smax_ge_commuted:
	camge 2,1
	move 2,1
	move 1,2
	popj 17,

smax_lt:
	camge 1,2
	move 1,2
	popj 17,

smax_lt_commuted:
	camge 2,1
	move 2,1
	move 1,2
	popj 17,

smax_le:
	camge 2,1
	move 2,1
	move 1,2
	popj 17,

smax_le_commuted:
	camge 1,2
	move 1,2
	popj 17,

smax_zero:
	caige 1,0
	movei 1,0
	popj 17,

smax_zero_commuted:
	caige 1,0
	movei 1,0
	popj 17,

smax_one:
	caige 1,1
	movei 1,1
	popj 17,

smax_minus_one:
	camge 1,[-1]
	seto 1,
	popj 17,

smax_small_positive:
	caige 1,123
	movei 1,123
	popj 17,

smax_small_negative:
	camge 1,[-123]
	move 1,[-123]
	popj 17,

smax_large_positive:
	caige 1,123456
	movei 1,123456
	popj 17,

smax_large_negative:
	camge 1,[-123456]
	move 1,[-123456]
	popj 17,

smax_const_left:
	caige 1,123456
	movei 1,123456
	popj 17,

smax_const_negative_left:
	camge 1,[-123456]
	move 1,[-123456]
	popj 17,

smax_mem:
	move 4,1
	move 1,(2)
	camge 1,4
	move 1,4
	popj 17,

smax_mem_commuted:
	camge 1,(2)
	move 1,(2)
	popj 17,

smax_mem_mem:
	move 4,1
	move 1,(2)
	camge 1,(4)
	move 1,(4)
	popj 17,

smax_global:
	move 4,1
	move 1,smax_ga
	camge 1,4
	move 1,4
	popj 17,

smax_global_commuted:
	camge 1,smax_ga
	move 1,smax_ga
	popj 17,

smax_global_global:
	move 1,smax_gb
	camge 1,smax_ga
	move 1,smax_ga
	popj 17,

smax_volatile_global:
	move 4,1
	move 1,smax_vga
	camge 1,4
	move 1,4
	popj 17,

smax_volatile_mem:
	move 4,1
	move 1,(2)
	camge 1,4
	move 1,4
	popj 17,

smax_array:
	andi 2,17
	add 1,2
	move 1,(1)
	camge 1,3
	move 1,3
	popj 17,

smax_array_commuted:
	andi 2,17
	add 1,2
	camge 3,(1)
	move 3,(1)
	move 1,3
	popj 17,

smax_array_array:
	andi 2,17
	add 2,1
	andi 3,17
	add 1,3
	move 1,(1)
	camge 1,(2)
	move 1,(2)
	popj 17,

smax_global_array:
	andi 1,17
	move 1,smax_buf(1)
	camge 1,2
	move 1,2
	popj 17,

smax_global_array_array:
	move 4,1
	andi 4,17
	andi 2,17
	move 1,smax_buf(2)
	camge 1,smax_buf(4)
	move 1,smax_buf(4)
	popj 17,

smax_struct_a:
	move 1,(1)
	camge 1,2
	move 1,2
	popj 17,

smax_struct_b:
	camge 2,1(1)
	move 2,1(1)
	move 1,2
	popj 17,

smax_struct_ab:
	move 4,1
	move 1,1(1)
	camge 1,(4)
	move 1,(4)
	popj 17,

smax_trip_ab:
	move 4,1
	move 1,1(1)
	camge 1,(4)
	move 1,(4)
	popj 17,

smax_trip_abc:
	move 4,1
	move 1,1(1)
	camge 1,(4)
	move 1,(4)
	camge 1,2(4)
	move 1,2(4)
	popj 17,

smax_global_struct:
	move 1,smax_gp+1
	camge 1,smax_gp
	move 1,smax_gp
	popj 17,

smax_global_trip:
	move 1,smax_gt+1
	camge 1,smax_gt
	move 1,smax_gt
	camge 1,smax_gt+2
	move 1,smax_gt+2
	popj 17,

smax_store:
	camge 3,2
	move 3,2
	movem 3,(1)
	popj 17,

smax_store_return:
	camge 3,2
	move 3,2
	movem 3,(1)
	move 1,3
	popj 17,

smax_store_global:
	camge 2,1
	move 2,1
	movem 2,smax_ga
	popj 17,

smax_store_array:
	andi 2,17
	add 1,2
	camge 4,3
	move 4,3
	movem 4,(1)
	popj 17,

smax_store_struct_a:
	camge 3,2
	move 3,2
	movem 3,(1)
	popj 17,

smax_store_then_use:
	camge 3,2
	move 3,2
	movem 3,(1)
	add 3,4
	move 1,3
	popj 17,

smax_add:
	camge 2,1
	move 2,1
	add 2,3
	move 1,2
	popj 17,

smax_sub:
	camge 2,1
	move 2,1
	sub 2,3
	move 1,2
	popj 17,

smax_xor:
	camge 2,1
	move 2,1
	xor 2,3
	move 1,2
	popj 17,

smax_or:
	camge 2,1
	move 2,1
	ior 2,3
	move 1,2
	popj 17,

smax_and:
	camge 2,1
	move 2,1
	and 2,3
	move 1,2
	popj 17,

smax_mul:
	camge 2,1
	move 2,1
	imul 2,3
	move 1,2
	popj 17,

smax_nested_add:
	camge 2,1
	move 2,1
	camge 4,3
	move 4,3
	add 2,4
	move 1,2
	popj 17,

smax_nested_max:
	camge 2,1
	move 2,1
	camge 3,2
	move 3,2
	move 1,3
	popj 17,

smax_nested_max4:
	camge 2,1
	move 2,1
	camge 4,3
	move 4,3
	camge 4,2
	move 4,2
	move 1,4
	popj 17,

smax_local:
	camge 2,1
	move 2,1
	move 1,2
	popj 17,

smax_local_sources_live:
	move 4,1
	camle 2,1
	move 1,2
	add 1,4
	add 1,2
	add 1,3
	popj 17,

smax_memory_sources_live:
	move 6,1
	move 4,(2)
	camle 4,(1)
	skipa 1,4
	move 1,(1)
	add 1,(6)
	add 1,4
	add 1,3
	popj 17,

smax_reuse_left:
	camge 2,1
	move 2,1
	move 1,2
	popj 17,

smax_reuse_right:
	camge 2,1
	move 2,1
	move 1,2
	popj 17,

smax_if_result_zero:
	camge 2,1
	move 2,1
	move 1,3
	jumpe 2,%L68
	move 1,4
%L68:
	popj 17,

smax_if_result_nonzero:
	camge 2,1
	move 2,1
	move 1,3
	jumpn 2,%L70
	move 1,4
%L70:
	popj 17,

smax_if_result_negative:
	camge 2,1
	move 2,1
	move 1,3
	jumpl 2,%L72
	move 1,4
%L72:
	popj 17,

smax_if_result_positive:
	camge 2,1
	move 2,1
	move 1,3
	jumple 2,%L76
%L74:
	popj 17,
%L76:
	move 1,4
	popj 17,

smax_likely:
	camge 1,2
	move 1,2
	popj 17,

smax_unlikely:
	camge 1,2
	move 1,2
	popj 17,

smax_after_if:
	jumpe 1,%L82
	addi 2,1
%L83:
	camle 3,2
	skipa 1,3
	move 1,2
	popj 17,
%L82:
	aoja 3,%L83

smax_before_if:
	camge 3,2
	move 3,2
	move 2,3
	add 2,4
	jumpn 1,%L84
	move 2,3
	sub 2,4
%L84:
	move 1,2
	popj 17,

smax_switch:
	move 6,1
	move 4,1
	andi 4,3
	camle 3,2
	skipa 1,3
	move 1,2
	cain 4,1
	popj 17,
	caig 4,1
	jrst %L94
	camle 3,6
	skipa 1,3
	move 1,6
	cain 4,2
	popj 17,
%L91:
	skipge 1,6
	movei 1,0
%L86:
	popj 17,
%L94:
	camle 2,6
	skipa 1,2
	move 1,6
	jumpe 4,%L86
	jrst %L91

smax_loop_pair:
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
	camle 4,1
	move 1,4
	addi 3,1
	sojge 2,%L103	; doloop_end
	popj 17,

smax_loop_two_arrays:
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
	camge 4,(3)
	move 4,(3)
	camle 4,1
	move 1,4
	addi 7,1
	sojge 6,%L113	; doloop_end
	popj 17,

smax_loop_accumulate:
	move 4,3
	subi 3,1
	jumple 4,%L120
%L118:
	camle 2,1
	move 1,2
	addi 2,1
	move 4,3
	subi 3,1
	jumpg 4,%L118
%L120:
	popj 17,

smax_sqi:
	lsh 1,33
	ash 1,-33
	lsh 2,33
	ash 2,-33
	camge 2,1
	move 2,1
	move 1,2
	popj 17,

smax_sqi_si:
	lsh 1,33
	ash 1,-33
	camge 2,1
	move 2,1
	move 1,2
	popj 17,

smax_hi:
	hrre 1,1
	hrre 2,2
	camge 2,1
	move 2,1
	move 1,2
	popj 17,

smax_hi_si:
	hrre 1,1
	camge 2,1
	move 2,1
	move 1,2
	popj 17,

	.globl	smaxsi3_smoke
smaxsi3_smoke:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	move 10,2
	move 11,3
	pushj 17,smax
	move 2,10
	move 3,11
	pushj 17,smax_nested_max
	move 2,11
	move 3,12
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	jrst smax_add

	.globl	sx3mem
sx3mem:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 11,1
	move 12,2
	move 10,3
	pushj 17,smax_mem_mem
	move 2,1
	move 1,11
	move 3,10
	pushj 17,smax_store_return
	move 3,1
	move 1,11
	move 2,12
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	jrst smax_memory_sources_live

	.globl	sx3ctl
sx3ctl:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,2
	move 10,3
	pushj 17,smax_loop_pair
	move 2,1
	move 1,10
	move 3,smax_ga
	move 4,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	jrst smax_before_if

	.bss
smax_ga:
	.space	4
smax_gb:
	.space	4
smax_vga:
	.space	4
smax_buf:
	.space	64
smax_gp:
	.space	8
smax_gt:
	.space	12
