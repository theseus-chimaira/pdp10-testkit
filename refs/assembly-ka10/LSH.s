
lshl_sint_0:
	popj 17,

lshl_sint_1:
	lsh 1,1
	popj 17,

lshl_sint_2:
	lsh 1,2
	popj 17,

lshl_sint_3:
	lsh 1,3
	popj 17,

lshl_sint_9:
	lsh 1,11
	popj 17,

lshl_sint_18:
	hrlz 1,1
	popj 17,

lshl_sint_27:
	lsh 1,33
	popj 17,

lshl_sint_35:
	lsh 1,43
	popj 17,

lshl_usint_0:
	popj 17,

lshl_usint_1:
	lsh 1,1
	popj 17,

lshl_usint_2:
	lsh 1,2
	popj 17,

lshl_usint_3:
	lsh 1,3
	popj 17,

lshl_usint_9:
	lsh 1,11
	popj 17,

lshl_usint_18:
	hrlz 1,1
	popj 17,

lshl_usint_27:
	lsh 1,33
	popj 17,

lshl_usint_35:
	lsh 1,43
	popj 17,

lshr_usint_0:
	popj 17,

lshr_usint_1:
	lsh 1,-1
	popj 17,

lshr_usint_2:
	lsh 1,-2
	popj 17,

lshr_usint_3:
	lsh 1,-3
	popj 17,

lshr_usint_9:
	lsh 1,-11
	popj 17,

lshr_usint_18:
	hlrz 1,1
	popj 17,

lshr_usint_27:
	lsh 1,-33
	popj 17,

lshr_usint_35:
	lsh 1,-43
	popj 17,

lshl_sint_var:
	lsh 1,(2)
	popj 17,

lshl_usint_var:
	lsh 1,(2)
	popj 17,

lshr_usint_var:
	movn 2,2
	lsh 1,(2)
	popj 17,

lshl_sint_plus_1:
	addi 2,1
	lsh 1,(2)
	popj 17,

lshl_usint_plus_1:
	addi 2,1
	lsh 1,(2)
	popj 17,

lshr_usint_plus_1:
	addi 2,1
	movn 2,2
	lsh 1,(2)
	popj 17,

lshl_sint_minus_count:
	movn 2,2
	lsh 1,(2)
	popj 17,

lshl_usint_minus_count:
	movn 2,2
	lsh 1,(2)
	popj 17,

lshr_usint_minus_count:
	movn 2,2
	movn 2,2
	lsh 1,(2)
	popj 17,

lshr_usint_one_minus:
	movei 4,1
	sub 4,2
	move 2,4
	movn 2,2
	lsh 1,(2)
	popj 17,

lshl_usint_one_minus:
	movei 4,1
	sub 4,2
	move 2,4
	lsh 1,(2)
	popj 17,

lshl_sint_mem_count:
	move 4,(2)
	lsh 1,(4)
	popj 17,

lshl_usint_mem_count:
	move 4,(2)
	lsh 1,(4)
	popj 17,

lshr_usint_mem_count:
	move 4,(2)
	movn 4,4
	lsh 1,(4)
	popj 17,

lshl_usint_volatile_count:
	move 4,(2)
	lsh 1,(4)
	popj 17,

lshr_usint_volatile_count:
	move 4,(2)
	movn 4,4
	lsh 1,(4)
	popj 17,

lshl_sint_masked_count:
	andi 2,77
	lsh 1,(2)
	popj 17,

lshl_usint_masked_count:
	andi 2,77
	lsh 1,(2)
	popj 17,

lshr_usint_masked_count:
	andi 2,77
	movn 2,2
	lsh 1,(2)
	popj 17,

lshl_usint_low5_count:
	andi 2,37
	lsh 1,(2)
	popj 17,

lshr_usint_low5_count:
	andi 2,37
	movn 2,2
	lsh 1,(2)
	popj 17,

lshl_from_qi:
	andi 1,777	; zero_extendqisi2
	lsh 1,3
	popj 17,

lshr_from_qi:
	ldb 1,[POINT 6,1,32]
	popj 17,

lshl_from_sqi:
	lsh 1,33
	ash 1,-33
	lsh 1,3
	popj 17,

lshl_from_hi:
	hrrzi 1,(1)	; zero_extendhisi2
	lsh 1,11
	popj 17,

lshr_from_hi:
	ldb 1,[POINT 9,1,26]
	popj 17,

lshl_from_shi:
	hrre 1,1
	lsh 1,11
	popj 17,

lshl_array:
	andi 2,17
	add 1,2
	move 1,(1)
	lsh 1,3
	popj 17,

lshr_array:
	andi 2,17
	add 1,2
	move 1,(1)
	lsh 1,-3
	popj 17,

lshl_array_var:
	andi 2,17
	add 1,2
	move 1,(1)
	lsh 1,(3)
	popj 17,

lshr_array_var:
	andi 2,17
	add 1,2
	move 1,(1)
	movn 3,3
	lsh 1,(3)
	popj 17,

lshl_global:
	andi 1,17
	move 1,lsh_buf(1)
	lsh 1,11
	popj 17,

lshr_global:
	andi 1,17
	move 1,lsh_buf(1)
	lsh 1,-11
	popj 17,

lshl_struct:
	hrlz 1,1(1)
	popj 17,

lshr_struct:
	hlrz 1,1(1)
	popj 17,

lshl_global_struct:
	hrlz 1,lsh_gs+1
	popj 17,

lshr_global_struct:
	hlrz 1,lsh_gs+1
	popj 17,

lshl_store:
	lsh 2,3
	movem 2,(1)
	popj 17,

lshr_store:
	lsh 2,-3
	movem 2,(1)
	popj 17,

lshl_store_ret:
	lsh 2,11
	movem 2,(1)
	move 1,2
	popj 17,

lshr_store_ret:
	lsh 2,-11
	movem 2,(1)
	move 1,2
	popj 17,

lshl_store_var:
	lsh 2,(3)
	movem 2,(1)
	popj 17,

lshr_store_var:
	movn 3,3
	lsh 2,(3)
	movem 2,(1)
	popj 17,

lshl_compound:
	move 4,(1)
	lsh 4,1
	movem 4,(1)
	popj 17,

lshr_compound:
	move 4,(1)
	lsh 4,-1
	movem 4,(1)
	popj 17,

lshl_compound_9:
	move 4,(1)
	lsh 4,11
	movem 4,(1)
	popj 17,

lshr_compound_9:
	move 4,(1)
	lsh 4,-11
	movem 4,(1)
	popj 17,

lshl_compound_var:
	move 4,(1)
	lsh 4,(2)
	movem 4,(1)
	popj 17,

lshr_compound_var:
	move 4,(1)
	movn 2,2
	lsh 4,(2)
	movem 4,(1)
	popj 17,

lshl_compound_global:
	move 4,lsh_sink
	lsh 4,1
	movem 4,lsh_sink
	popj 17,

lshr_compound_global:
	move 4,lsh_sink
	lsh 4,-1
	movem 4,lsh_sink
	popj 17,

lshl_compound_ret:
	move 4,1
	move 1,(1)
	lsh 1,3
	movem 1,(4)
	popj 17,

lshr_compound_ret:
	move 4,(1)
	lsh 4,-3
	movem 4,(1)
	move 1,4
	popj 17,

lshl_and_mask:
	hrlz 1,1
	popj 17,

lshr_and_mask:
	hlrz 1,1
	popj 17,

lshl_or_mask:
	lsh 1,11
	andi 2,777
	ior 1,2
	popj 17,

lshr_or_mask:
	lsh 1,-11
	hllz 2,2
	ior 2,1
	move 1,2
	popj 17,

lshl_xor:
	lsh 1,3
	xor 1,2
	popj 17,

lshr_xor:
	lsh 1,-3
	xor 1,2
	popj 17,

lshl_add:
	lsh 1,3
	add 1,2
	popj 17,

lshr_add:
	lsh 1,-3
	add 1,2
	popj 17,

lshl_nested:
	andi 3,17
	xor 1,2
	lsh 1,(3)
	lsh 2,-3
	add 1,2
	popj 17,

lshr_nested:
	andi 3,17
	xor 1,2
	movn 3,3
	lsh 1,(3)
	lsh 2,3
	add 1,2
	popj 17,

lshl_two_counts:
	lsh 1,(2)
	lsh 1,(3)
	popj 17,

lshr_two_counts:
	movn 2,2
	lsh 1,(2)
	movn 3,3
	lsh 1,(3)
	popj 17,

lshl_then_lshr:
	hrrz 1,1
	popj 17,

lshr_then_lshl:
	hllz 1,1
	popj 17,

lshl_call_pressure:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,1
	lsh 11,(2)
	pushj 17,clobber
	add 11,10
	move 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

lshr_call_pressure:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	movn 2,2
	move 11,1
	lsh 11,(2)
	pushj 17,clobber
	add 11,10
	move 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

lshl_loop:
	move 6,1
	setzb 1,3
	caml 1,2
	popj 17,
	subi 2,1
%L107:
	move 4,3
	andi 4,17
	add 4,6
	move 4,(4)
	lsh 4,1
	add 1,4
	addi 3,1
	sojge 2,%L107	; doloop_end
	popj 17,

lshr_loop:
	move 6,1
	setzb 1,3
	caml 1,2
	popj 17,
	subi 2,1
%L117:
	move 4,3
	andi 4,17
	add 4,6
	move 4,(4)
	lsh 4,-1
	add 1,4
	addi 3,1
	sojge 2,%L117	; doloop_end
	popj 17,

lshl_loop_var:
	move 7,1
	setzb 1,6
	caml 1,2
	popj 17,
	subi 2,1
%L127:
	move 4,6
	andi 4,17
	add 4,7
	move 4,(4)
	lsh 4,(3)
	add 1,4
	addi 6,1
	sojge 2,%L127	; doloop_end
	popj 17,

lshr_loop_var:
	move 7,1
	setzb 1,6
	caml 1,2
	popj 17,
	movn 3,3
	subi 2,1
%L137:
	move 4,6
	andi 4,17
	add 4,7
	move 4,(4)
	lsh 4,(3)
	add 1,4
	addi 6,1
	sojge 2,%L137	; doloop_end
	popj 17,

	.globl	lshl1
lshl1:
	lsh 1,1
	popj 17,

	.globl	lshl2
lshl2:
	lsh 1,(2)
	popj 17,

	.globl	lshl3
lshl3:
	addi 2,1
	lsh 1,(2)
	popj 17,

	.globl	lshr1
lshr1:
	lsh 1,-1
	popj 17,

	.globl	lshr2
lshr2:
	movn 2,2
	lsh 1,(2)
	popj 17,

	.globl	lshr3
lshr3:
	movn 2,2
	movn 2,2
	lsh 1,(2)
	popj 17,

	.globl	lshr4
lshr4:
	addi 2,1
	movn 2,2
	lsh 1,(2)
	popj 17,

	.globl	lshr5
lshr5:
	movei 4,1
	sub 4,2
	move 2,4
	movn 2,2
	lsh 1,(2)
	popj 17,

	.bss
lsh_sink:
	.space	4
lsh_buf:
	.space	64
lsh_gs:
	.space	12
