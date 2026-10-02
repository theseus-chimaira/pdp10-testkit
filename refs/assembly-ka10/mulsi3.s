
mulsi3:
	imul 1,2
	popj 17,

mul_reg_reg:
	imul 1,2
	popj 17,

umul_reg_reg:
	imul 1,2
	popj 17,

mul_local:
	imul 1,2
	popj 17,

mul_reuse_left:
	imul 1,2
	popj 17,

mul_reuse_right:
	imul 2,1
	move 1,2
	popj 17,

mul_chain:
	imul 1,2
	imul 1,3
	popj 17,

mul_add_use:
	imul 1,2
	add 1,3
	popj 17,

mul_sub_use:
	imul 1,2
	sub 1,3
	popj 17,

mul_xor_use:
	imul 1,2
	xor 1,3
	popj 17,

mul_from_call:
	push 17,10
	move 10,1
	pushj 17,f
	imul 1,10
	pop 17,10
	popj 17,

mul_call_rhs:
	push 17,10
	move 10,1
	pushj 17,f
	imul 10,1
	move 1,10
	pop 17,10
	popj 17,

umul_from_call:
	push 17,10
	move 10,1
	pushj 17,uf
	imul 1,10
	pop 17,10
	popj 17,

mul_reg_mem:
	imul 1,(2)
	popj 17,

mul_mem_reg:
	imul 2,(1)
	move 1,2
	popj 17,

mul_mem_mem:
	move 1,(1)
	imul 1,(2)
	popj 17,

mul_volatile_mem:
	move 4,1
	move 1,(2)
	imul 1,4
	popj 17,

mul_mem_volatile:
	move 1,(1)
	imul 1,2
	popj 17,

mul_global_reg:
	imul 1,mulsi3_ga
	popj 17,

mul_reg_global:
	imul 1,mulsi3_gb
	popj 17,

mul_volatile_global:
	move 4,1
	move 1,mulsi3_vga
	imul 1,4
	popj 17,

umul_global_reg:
	imul 1,umulsi3_ga
	popj 17,

umul_reg_global:
	imul 1,umulsi3_gb
	popj 17,

umul_volatile_global:
	move 4,1
	move 1,umulsi3_vga
	imul 1,4
	popj 17,

mul_array_reg:
	andi 2,17
	add 1,2
	imul 3,(1)
	move 1,3
	popj 17,

mul_reg_array:
	andi 3,17
	add 2,3
	imul 1,(2)
	popj 17,

mul_global_array:
	andi 1,17
	imul 2,mulsi3_buf(1)
	move 1,2
	popj 17,

mul_reg_global_array:
	andi 2,17
	imul 1,mulsi3_buf(2)
	popj 17,

umul_array_reg:
	andi 2,17
	add 1,2
	imul 3,(1)
	move 1,3
	popj 17,

umul_reg_array:
	andi 3,17
	add 2,3
	imul 1,(2)
	popj 17,

umul_global_array:
	andi 1,17
	imul 2,umulsi3_buf(1)
	move 1,2
	popj 17,

mul_struct_a:
	imul 2,(1)
	move 1,2
	popj 17,

mul_struct_b:
	imul 2,1(1)
	move 1,2
	popj 17,

mul_struct_two:
	move 6,(1)
	imul 6,1(1)
	move 1,6
	popj 17,

mul_struct_three:
	move 4,(1)
	imul 4,1(1)
	imul 4,2(1)
	move 1,4
	popj 17,

mul_global_struct_a:
	imul 1,mulsi3_gp
	popj 17,

mul_global_struct_b:
	imul 1,mulsi3_gp+1
	popj 17,

mul_global_struct_three:
	move 1,mulsi3_gt
	imul 1,mulsi3_gt+2
	popj 17,

umul_global_struct_a:
	imul 1,umulsi3_gp
	popj 17,

muli_zero:
	movei 1,0
	popj 17,

muli_one:
	popj 17,

muli_two:
	lsh 1,1
	popj 17,

muli_three:
	move 4,1
	lsh 1,1
	add 1,4
	popj 17,

muli_small:
	imuli 1,12345
	popj 17,

muli_right_max:
	move 4,1
	hrlz 1,1
	sub 1,4
	popj 17,

muli_left_const:
	imul 1,[123456000000]
	popj 17,

muli_full_const:
	imul 1,[123456123456]
	popj 17,

muli_minus_one:
	movn 1,1
	popj 17,

muli_minus_two:
	imul 1,[-2]
	popj 17,

muli_minus_small:
	imul 1,[-12345]
	popj 17,

umuli_one:
	popj 17,

umuli_two:
	lsh 1,1
	popj 17,

umuli_right_max:
	move 4,1
	hrlz 1,1
	sub 1,4
	popj 17,

umuli_full_const:
	imul 1,[123456123456]
	popj 17,

mul_right_half:
	imuli 1,(2)
	popj 17,

mul_right_half_commuted:
	imuli 1,(2)
	popj 17,

mul_right_half_plus:
	imuli 1,123(2)
	popj 17,

mul_right_half_array:
	move 4,1
	andi 3,17
	add 2,3
	hrrz 1,(2)
	imul 1,4
	popj 17,

umul_right_half:
	imuli 1,(2)
	popj 17,

umul_right_half_plus:
	imuli 1,123(2)
	popj 17,

mul_store_plain:
	imulm 2,(1)
	popj 17,

mul_store_commuted:
	imulm 2,(1)
	popj 17,

mul_store_return:
	move 4,2
	imulb 4,(1)
	move 1,4
	popj 17,

mul_store_commuted_return:
	move 4,2
	imulb 4,(1)
	move 1,4
	popj 17,

mul_store_global:
	imulm 1,mulsi3_ga
	popj 17,

mul_store_global_commuted:
	imulm 1,mulsi3_ga
	popj 17,

mul_store_global_return:
	imulb 1,mulsi3_ga
	popj 17,

mul_store_global_commuted_return:
	imulb 1,mulsi3_ga
	popj 17,

mul_store_array:
	andi 1,17
	imulm 2,mulsi3_buf(1)
	popj 17,

mul_store_array_commuted:
	andi 1,17
	imulm 2,mulsi3_buf(1)
	popj 17,

mul_store_array_return:
	andi 1,17
	move 4,2
	imulb 4,mulsi3_buf(1)
	move 1,4
	popj 17,

mul_store_array_commuted_return:
	andi 1,17
	move 4,2
	imulb 4,mulsi3_buf(1)
	move 1,4
	popj 17,

mul_store_struct_a:
	imulm 2,(1)
	popj 17,

mul_store_struct_a_return:
	move 4,2
	imulb 4,(1)
	move 1,4
	popj 17,

umul_store_plain:
	imulm 2,(1)
	popj 17,

umul_store_return:
	move 4,2
	imulb 4,(1)
	move 1,4
	popj 17,

mul_pow2_2:
	lsh 1,1
	popj 17,

mul_pow2_4:
	lsh 1,2
	popj 17,

mul_pow2_8:
	lsh 1,3
	popj 17,

mul_pow2_16:
	lsh 1,4
	popj 17,

umul_pow2_4:
	lsh 1,2
	popj 17,

mul_eq_zero:
	imul 1,2
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

mul_ne_zero:
	imul 1,2
	skipe 1
	movei 1,1
	popj 17,

mul_lt_zero:
	imul 1,2
	lsh 1,-43
	popj 17,

mul_ge_zero:
	imul 1,2
	skipge 1
	tdza 1,1
	movei 1,1
	popj 17,

mul_gt_const:
	imul 1,2
	movei 6,123
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

mul_range:
	imul 1,2
	seto 4,
	camge 1,[-100]
	jrst %L92
	movei 6,100
	camg 1,6
	tdza 4,4
	movei 4,1
%L92:
	move 1,4
	popj 17,

mul_after_call:
	push 17,10
	move 10,(1)
	pushj 17,clobber
	pushj 17,f
	imul 10,1
	move 1,10
	pop 17,10
	popj 17,

mul_store_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	pushj 17,f
	move 11,1
	pushj 17,clobber
	move 1,11
	imulb 1,(10)
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

mul_global_after_call:
	push 17,10
	pushj 17,f
	move 10,1
	pushj 17,clobber
	imul 10,mulsi3_ga
	move 1,10
	pop 17,10
	popj 17,

	.bss
mulsi3_ga:
	.space	4
mulsi3_gb:
	.space	4
mulsi3_gc:
	.space	4
mulsi3_vga:
	.space	4
mulsi3_buf:
	.space	64
umulsi3_ga:
	.space	4
umulsi3_gb:
	.space	4
umulsi3_vga:
	.space	4
umulsi3_buf:
	.space	64
mulsi3_gp:
	.space	8
mulsi3_gt:
	.space	12
umulsi3_gp:
	.space	8
