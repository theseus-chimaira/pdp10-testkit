
	.globl	ashrsi3
ashrsi3:
	movn 2,2
	ash 1,(2)
	popj 17,

ashr_reg_reg:
	movn 2,2
	ash 1,(2)
	popj 17,

ashr_second_arg:
	movn 3,3
	ash 2,(3)
	move 1,2
	popj 17,

ashr_local:
	movn 2,2
	ash 1,(2)
	popj 17,

ashr_reuse_left:
	movn 2,2
	ash 1,(2)
	popj 17,

ashr_reuse_count:
	movn 2,2
	ash 1,(2)
	popj 17,

ashr_after_add:
	add 1,2
	movn 3,3
	ash 1,(3)
	popj 17,

ashr_after_sub:
	sub 1,2
	movn 3,3
	ash 1,(3)
	popj 17,

ashr_after_and:
	and 1,2
	movn 3,3
	ash 1,(3)
	popj 17,

ashr_after_xor:
	xor 1,2
	movn 3,3
	ash 1,(3)
	popj 17,

ashr_after_neg:
	movn 1,1
	movn 2,2
	ash 1,(2)
	popj 17,

ashr_call_count:
	push 17,10
	move 10,1
	pushj 17,f
	movn 1,1
	ash 10,(1)
	move 1,10
	pop 17,10
	popj 17,

ashr_call_value:
	push 17,10
	move 10,1
	pushj 17,f
	movn 10,10
	ash 1,(10)
	pop 17,10
	popj 17,

ashri_0:
	popj 17,

ashri_1:
	ash 1,-1
	popj 17,

ashri_2:
	ash 1,-2
	popj 17,

ashri_3:
	ash 1,-3
	popj 17,

ashri_4:
	ash 1,-4
	popj 17,

ashri_5:
	ash 1,-5
	popj 17,

ashri_8:
	ash 1,-10
	popj 17,

ashri_9:
	ash 1,-11
	popj 17,

ashri_17:
	ash 1,-21
	popj 17,

ashri_18:
	hlre 1,1
	popj 17,

ashri_19:
	ash 1,-23
	popj 17,

ashri_27:
	ash 1,-33
	popj 17,

ashri_35:
	ash 1,-43
	popj 17,

ashri_neg_1:
	movn 1,1
	ash 1,-1
	popj 17,

ashri_neg_4:
	movn 1,1
	ash 1,-4
	popj 17,

ashri_neg_18:
	movn 1,1
	hlre 1,1
	popj 17,

ashri_const_neg_one:
	seto 1,
	popj 17,

ashri_const_signbit_like:
	movsi 1,200000
	popj 17,

ashri_full_const:
	move 1,[12345612345]
	popj 17,

ashr_mem_value:
	move 1,(1)
	movn 2,2
	ash 1,(2)
	popj 17,

ashr_volatile_mem_value:
	move 1,(1)
	movn 2,2
	ash 1,(2)
	popj 17,

ashr_global_value:
	move 4,ashr_ga
	movn 1,1
	ash 4,(1)
	move 1,4
	popj 17,

ashr_global_b_value:
	move 4,ashr_gb
	movn 1,1
	ash 4,(1)
	move 1,4
	popj 17,

ashr_volatile_global_value:
	move 4,ashr_vga
	movn 1,1
	ash 4,(1)
	move 1,4
	popj 17,

ashr_array_value:
	andi 1,17
	move 1,ashr_buf(1)
	movn 2,2
	ash 1,(2)
	popj 17,

ashr_ptr_array_value:
	andi 2,17
	add 1,2
	move 1,(1)
	movn 3,3
	ash 1,(3)
	popj 17,

ashr_mem_count:
	movn 4,(2)
	ash 1,(4)
	popj 17,

ashr_volatile_mem_count:
	move 4,(2)
	movn 4,4
	ash 1,(4)
	popj 17,

ashr_global_count:
	movn 4,ashr_count
	ash 1,(4)
	popj 17,

ashr_volatile_global_count:
	move 4,ashr_vcount
	movn 4,4
	ash 1,(4)
	popj 17,

ashr_array_count:
	andi 2,17
	movn 4,ashr_counts(2)
	ash 1,(4)
	popj 17,

ashr_mem_value_mem_count:
	move 1,(1)
	movn 4,(2)
	ash 1,(4)
	popj 17,

ashr_global_value_global_count:
	move 1,ashr_ga
	movn 4,ashr_count
	ash 1,(4)
	popj 17,

ashr_struct_value_a:
	move 1,(1)
	movn 2,2
	ash 1,(2)
	popj 17,

ashr_struct_value_b:
	move 1,1(1)
	movn 2,2
	ash 1,(2)
	popj 17,

ashr_struct_count_a:
	movn 4,(2)
	ash 1,(4)
	popj 17,

ashr_struct_count_b:
	movn 4,1(2)
	ash 1,(4)
	popj 17,

ashr_struct_both:
	move 4,1
	move 1,(1)
	movn 4,1(4)
	ash 1,(4)
	popj 17,

ashr_global_struct_value:
	move 4,ashr_gp
	movn 1,1
	ash 4,(1)
	move 1,4
	popj 17,

ashr_global_struct_count:
	movn 4,ashr_gp+1
	ash 1,(4)
	popj 17,

ashr_global_struct_three:
	move 1,ashr_gt
	movn 4,ashr_gt+2
	ash 1,(4)
	popj 17,

ashr_count_plus_1:
	setca 2,
	ash 1,(2)
	popj 17,

ashr_count_plus_2:
	addi 2,2
	movn 2,2
	ash 1,(2)
	popj 17,

ashr_count_plus_7:
	addi 2,7
	movn 2,2
	ash 1,(2)
	popj 17,

ashr_count_plus_18:
	addi 2,22
	movn 2,2
	ash 1,(2)
	popj 17,

ashr_count_minus_1:
	subi 2,1
	movn 2,2
	ash 1,(2)
	popj 17,

ashr_count_minus_2:
	subi 2,2
	movn 2,2
	ash 1,(2)
	popj 17,

ashr_mem_count_plus:
	setcm 4,(2)
	ash 1,(4)
	popj 17,

ashr_array_count_plus:
	andi 2,17
	setcm 4,ashr_counts(2)
	ash 1,(4)
	popj 17,

ashr_struct_count_plus:
	setcm 4,1(2)
	ash 1,(4)
	popj 17,

ashr_qi_value:
	lsh 1,33
	ash 1,-33
	movn 2,2
	ash 1,(2)
	popj 17,

ashr_uqi_value:
	andi 1,777	; zero_extendqisi2
	movn 2,2
	ash 1,(2)
	popj 17,

ashr_hi_value:
	hrre 1,1
	movn 2,2
	ash 1,(2)
	popj 17,

ashr_uhi_value:
	hrrzi 1,(1)	; zero_extendhisi2
	movn 2,2
	ash 1,(2)
	popj 17,

ashr_qi_count:
	lsh 2,33
	ash 2,-33
	movn 2,2
	ash 1,(2)
	popj 17,

ashr_uqi_count:
	andi 2,777	; zero_extendqisi2
	movn 2,2
	ash 1,(2)
	popj 17,

ashr_hi_count:
	hrre 2,2
	movn 2,2
	ash 1,(2)
	popj 17,

ashr_uhi_count:
	movni 2,(2)
	ash 1,(2)
	popj 17,

ashr_store_ptr:
	movn 3,3
	ash 2,(3)
	movem 2,(1)
	popj 17,

ashr_store_ptr_return:
	movn 3,3
	ash 2,(3)
	movem 2,(1)
	move 1,2
	popj 17,

ashr_store_global:
	movn 2,2
	ash 1,(2)
	movem 1,ashr_ga
	popj 17,

ashr_store_global_return:
	movn 2,2
	ash 1,(2)
	movem 1,ashr_ga
	popj 17,

ashr_store_array:
	andi 1,17
	movn 3,3
	ash 2,(3)
	movem 2,ashr_buf(1)
	popj 17,

ashr_store_array_return:
	andi 1,17
	movn 3,3
	ash 2,(3)
	movem 2,ashr_buf(1)
	move 1,2
	popj 17,

ashr_inplace_ptr:
	move 4,(1)
	movn 2,2
	ash 4,(2)
	movem 4,(1)
	popj 17,

ashr_inplace_ptr_return:
	move 4,(1)
	movn 2,2
	ash 4,(2)
	movem 4,(1)
	move 1,4
	popj 17,

ashr_inplace_global:
	move 4,ashr_ga
	movn 1,1
	ash 4,(1)
	movem 4,ashr_ga
	popj 17,

ashr_inplace_global_return:
	move 4,ashr_ga
	movn 1,1
	ash 4,(1)
	movem 4,ashr_ga
	move 1,4
	popj 17,

ashr_inplace_array:
	andi 1,17
	move 4,ashr_buf(1)
	movn 2,2
	ash 4,(2)
	movem 4,ashr_buf(1)
	popj 17,

ashr_inplace_array_return:
	andi 1,17
	move 4,ashr_buf(1)
	movn 2,2
	ash 4,(2)
	movem 4,ashr_buf(1)
	move 1,4
	popj 17,

ashr_plus:
	movn 2,2
	ash 1,(2)
	add 1,3
	popj 17,

ashr_minus:
	movn 2,2
	ash 1,(2)
	sub 1,3
	popj 17,

ashr_xor:
	movn 2,2
	ash 1,(2)
	xor 1,3
	popj 17,

ashr_or:
	movn 2,2
	ash 1,(2)
	ior 1,3
	popj 17,

ashr_and:
	movn 2,2
	ash 1,(2)
	and 1,3
	popj 17,

ashr_twice:
	movn 2,2
	ash 1,(2)
	movn 3,3
	ash 1,(3)
	popj 17,

ashr_mix:
	movn 2,2
	ash 1,(2)
	ash 3,-1
	xor 1,3
	popj 17,

ashr_eq_zero:
	movn 2,2
	ash 1,(2)
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

ashr_ne_zero:
	movn 2,2
	ash 1,(2)
	skipe 1
	movei 1,1
	popj 17,

ashr_lt_zero:
	movn 2,2
	ash 1,(2)
	lsh 1,-43
	popj 17,

ashr_ge_zero:
	skipge 1
	tdza 1,1
	movei 1,1
	popj 17,

ashr_gt_const:
	movn 2,2
	ash 1,(2)
	movei 6,12345
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

ashr_range:
	movn 2,2
	ash 1,(2)
	seto 4,
	camge 1,[-100]
	jrst %L97
	movei 6,100
	camg 1,6
	tdza 4,4
	movei 4,1
%L97:
	move 1,4
	popj 17,

ashr_div_2:
	move 4,1
	lsh 4,-43
	add 1,4
	ash 1,-1
	popj 17,

ashr_div_4:
	jumpl 1,%L103
%L102:
	ash 1,-2
	popj 17,
%L103:
	addi 1,3
	jrst %L102

ashr_div_8:
	jumpl 1,%L106
%L105:
	ash 1,-3
	popj 17,
%L106:
	addi 1,7
	jrst %L105

ashr_mod_2:
	move 4,1
	lsh 4,-43
	add 4,1
	andcmi 4,1
	sub 1,4
	popj 17,

ashr_mod_4:
	move 4,1
	jumpl 1,%L110
%L109:
	andcmi 4,3
	sub 1,4
	popj 17,
%L110:
	addi 4,3
	jrst %L109

ashr_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,2
	move 11,(1)
	pushj 17,clobber
	movn 10,10
	ash 11,(10)
	move 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

ashr_count_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,(2)
	pushj 17,clobber
	movn 10,10
	ash 11,(10)
	move 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

ashr_store_after_call:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	move 11,2
	pushj 17,f
	move 10,1
	pushj 17,clobber
	movn 10,10
	ash 11,(10)
	movem 11,(12)
	move 1,11
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

ashr_global_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	pushj 17,f
	move 11,1
	pushj 17,clobber
	movn 10,10
	ash 11,(10)
	move 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
ashr_ga:
	.space	4
ashr_gb:
	.space	4
ashr_vga:
	.space	4
ashr_buf:
	.space	64
ashr_count:
	.space	4
ashr_vcount:
	.space	4
ashr_counts:
	.space	64
ashr_gp:
	.space	8
ashr_gt:
	.space	12
