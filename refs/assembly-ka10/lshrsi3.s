
	.globl	lshrsi3
lshrsi3:
	movn 2,2
	lsh 1,(2)
	popj 17,

lshr_reg_reg:
	movn 2,2
	lsh 1,(2)
	popj 17,

lshr_reg_ureg:
	movn 2,2
	lsh 1,(2)
	popj 17,

lshr_second_arg:
	movn 3,3
	lsh 2,(3)
	move 1,2
	popj 17,

lshr_local:
	movn 2,2
	lsh 1,(2)
	popj 17,

lshr_reuse_left:
	movn 2,2
	lsh 1,(2)
	popj 17,

lshr_reuse_count:
	movn 2,2
	lsh 1,(2)
	popj 17,

lshr_after_add:
	add 1,2
	movn 3,3
	lsh 1,(3)
	popj 17,

lshr_after_sub:
	sub 1,2
	movn 3,3
	lsh 1,(3)
	popj 17,

lshr_after_and:
	and 1,2
	movn 3,3
	lsh 1,(3)
	popj 17,

lshr_after_xor:
	xor 1,2
	movn 3,3
	lsh 1,(3)
	popj 17,

lshr_after_or:
	ior 1,2
	movn 3,3
	lsh 1,(3)
	popj 17,

lshr_call_count:
	push 17,10
	move 10,1
	pushj 17,f
	movn 1,1
	lsh 10,(1)
	move 1,10
	pop 17,10
	popj 17,

lshr_ucall_count:
	push 17,10
	move 10,1
	pushj 17,uf
	movn 1,1
	lsh 10,(1)
	move 1,10
	pop 17,10
	popj 17,

lshr_call_value:
	push 17,10
	move 10,1
	pushj 17,uf
	movn 10,10
	lsh 1,(10)
	pop 17,10
	popj 17,

lshri_0:
	popj 17,

lshri_1:
	lsh 1,-1
	popj 17,

lshri_2:
	lsh 1,-2
	popj 17,

lshri_3:
	lsh 1,-3
	popj 17,

lshri_4:
	lsh 1,-4
	popj 17,

lshri_5:
	lsh 1,-5
	popj 17,

lshri_8:
	lsh 1,-10
	popj 17,

lshri_9:
	lsh 1,-11
	popj 17,

lshri_17:
	lsh 1,-21
	popj 17,

lshri_18:
	hlrz 1,1
	popj 17,

lshri_19:
	lsh 1,-23
	popj 17,

lshri_27:
	lsh 1,-33
	popj 17,

lshri_35:
	lsh 1,-43
	popj 17,

lshri_high_1:
	tlo 1,400000
	lsh 1,-1
	popj 17,

lshri_high_4:
	tlo 1,400000
	lsh 1,-4
	popj 17,

lshri_high_18:
	tlo 1,400000
	hlrz 1,1
	popj 17,

lshri_high_35:
	movei 1,1
	popj 17,

lshri_const_high:
	movsi 1,200000
	popj 17,

lshri_const_allones:
	hrloi 1,377777
	popj 17,

lshri_full_const:
	move 1,[12345612345]
	popj 17,

lshr_mem_value:
	move 1,(1)
	movn 2,2
	lsh 1,(2)
	popj 17,

lshr_volatile_mem_value:
	move 1,(1)
	movn 2,2
	lsh 1,(2)
	popj 17,

lshr_global_value:
	move 4,lshr_ga
	movn 1,1
	lsh 4,(1)
	move 1,4
	popj 17,

lshr_global_b_value:
	move 4,lshr_gb
	movn 1,1
	lsh 4,(1)
	move 1,4
	popj 17,

lshr_volatile_global_value:
	move 4,lshr_vga
	movn 1,1
	lsh 4,(1)
	move 1,4
	popj 17,

lshr_array_value:
	andi 1,17
	move 1,lshr_buf(1)
	movn 2,2
	lsh 1,(2)
	popj 17,

lshr_ptr_array_value:
	andi 2,17
	add 1,2
	move 1,(1)
	movn 3,3
	lsh 1,(3)
	popj 17,

lshr_mem_count:
	movn 4,(2)
	lsh 1,(4)
	popj 17,

lshr_umem_count:
	movn 4,(2)
	lsh 1,(4)
	popj 17,

lshr_volatile_mem_count:
	move 4,(2)
	movn 4,4
	lsh 1,(4)
	popj 17,

lshr_global_count:
	movn 4,lshr_count
	lsh 1,(4)
	popj 17,

lshr_uglobal_count:
	movn 4,lshr_ucount
	lsh 1,(4)
	popj 17,

lshr_volatile_global_count:
	move 4,lshr_vcount
	movn 4,4
	lsh 1,(4)
	popj 17,

lshr_volatile_uglobal_count:
	move 4,lshr_vucount
	movn 4,4
	lsh 1,(4)
	popj 17,

lshr_array_count:
	andi 2,17
	movn 4,lshr_counts(2)
	lsh 1,(4)
	popj 17,

lshr_uarray_count:
	andi 2,17
	movn 4,lshr_ucounts(2)
	lsh 1,(4)
	popj 17,

lshr_mem_value_mem_count:
	move 1,(1)
	movn 4,(2)
	lsh 1,(4)
	popj 17,

lshr_global_value_global_count:
	move 1,lshr_ga
	movn 4,lshr_count
	lsh 1,(4)
	popj 17,

lshr_struct_value_a:
	move 1,(1)
	movn 2,2
	lsh 1,(2)
	popj 17,

lshr_struct_value_b:
	move 1,1(1)
	movn 2,2
	lsh 1,(2)
	popj 17,

lshr_struct_count_a:
	movn 4,(2)
	lsh 1,(4)
	popj 17,

lshr_struct_count_b:
	movn 4,1(2)
	lsh 1,(4)
	popj 17,

lshr_struct_both:
	move 4,1
	move 1,(1)
	movn 4,1(4)
	lsh 1,(4)
	popj 17,

lshr_global_struct_value:
	move 4,lshr_gp
	movn 1,1
	lsh 4,(1)
	move 1,4
	popj 17,

lshr_global_struct_count:
	movn 4,lshr_cgp+1
	lsh 1,(4)
	popj 17,

lshr_global_struct_three:
	move 1,lshr_gt
	movn 4,lshr_gt+2
	lsh 1,(4)
	popj 17,

lshr_count_plus_1:
	setca 2,
	lsh 1,(2)
	popj 17,

lshr_count_plus_2:
	addi 2,2
	movn 2,2
	lsh 1,(2)
	popj 17,

lshr_count_plus_7:
	addi 2,7
	movn 2,2
	lsh 1,(2)
	popj 17,

lshr_count_plus_18:
	addi 2,22
	movn 2,2
	lsh 1,(2)
	popj 17,

lshr_count_minus_1:
	subi 2,1
	movn 2,2
	lsh 1,(2)
	popj 17,

lshr_count_minus_2:
	subi 2,2
	movn 2,2
	lsh 1,(2)
	popj 17,

lshr_ucount_plus_1:
	setca 2,
	lsh 1,(2)
	popj 17,

lshr_ucount_plus_8:
	addi 2,10
	movn 2,2
	lsh 1,(2)
	popj 17,

lshr_mem_count_plus:
	setcm 4,(2)
	lsh 1,(4)
	popj 17,

lshr_array_count_plus:
	andi 2,17
	setcm 4,lshr_counts(2)
	lsh 1,(4)
	popj 17,

lshr_struct_count_plus:
	setcm 4,1(2)
	lsh 1,(4)
	popj 17,

lshr_uqi_value:
	andi 1,777	; zero_extendqisi2
	movn 2,2
	ash 1,(2)
	popj 17,

lshr_uhi_value:
	hrrzi 1,(1)	; zero_extendhisi2
	movn 2,2
	ash 1,(2)
	popj 17,

lshr_qi_value_cast:
	lsh 1,33
	ash 1,-33
	movn 2,2
	lsh 1,(2)
	popj 17,

lshr_hi_value_cast:
	hrre 1,1
	movn 2,2
	lsh 1,(2)
	popj 17,

lshr_uqi_count:
	andi 2,777	; zero_extendqisi2
	movn 2,2
	lsh 1,(2)
	popj 17,

lshr_uhi_count:
	movni 2,(2)
	lsh 1,(2)
	popj 17,

lshr_qi_count_cast:
	lsh 2,33
	ash 2,-33
	movn 2,2
	lsh 1,(2)
	popj 17,

lshr_hi_count_cast:
	hrre 2,2
	movn 2,2
	lsh 1,(2)
	popj 17,

lshr_store_ptr:
	movn 3,3
	lsh 2,(3)
	movem 2,(1)
	popj 17,

lshr_store_ptr_return:
	movn 3,3
	lsh 2,(3)
	movem 2,(1)
	move 1,2
	popj 17,

lshr_store_global:
	movn 2,2
	lsh 1,(2)
	movem 1,lshr_ga
	popj 17,

lshr_store_global_return:
	movn 2,2
	lsh 1,(2)
	movem 1,lshr_ga
	popj 17,

lshr_store_array:
	andi 1,17
	movn 3,3
	lsh 2,(3)
	movem 2,lshr_buf(1)
	popj 17,

lshr_store_array_return:
	andi 1,17
	movn 3,3
	lsh 2,(3)
	movem 2,lshr_buf(1)
	move 1,2
	popj 17,

lshr_inplace_ptr:
	move 4,(1)
	movn 2,2
	lsh 4,(2)
	movem 4,(1)
	popj 17,

lshr_inplace_ptr_return:
	move 4,(1)
	movn 2,2
	lsh 4,(2)
	movem 4,(1)
	move 1,4
	popj 17,

lshr_inplace_global:
	move 4,lshr_ga
	movn 1,1
	lsh 4,(1)
	movem 4,lshr_ga
	popj 17,

lshr_inplace_global_return:
	move 4,lshr_ga
	movn 1,1
	lsh 4,(1)
	movem 4,lshr_ga
	move 1,4
	popj 17,

lshr_inplace_array:
	andi 1,17
	move 4,lshr_buf(1)
	movn 2,2
	lsh 4,(2)
	movem 4,lshr_buf(1)
	popj 17,

lshr_inplace_array_return:
	andi 1,17
	move 4,lshr_buf(1)
	movn 2,2
	lsh 4,(2)
	movem 4,lshr_buf(1)
	move 1,4
	popj 17,

lshr_plus:
	movn 2,2
	lsh 1,(2)
	add 1,3
	popj 17,

lshr_minus:
	movn 2,2
	lsh 1,(2)
	sub 1,3
	popj 17,

lshr_xor:
	movn 2,2
	lsh 1,(2)
	xor 1,3
	popj 17,

lshr_or:
	movn 2,2
	lsh 1,(2)
	ior 1,3
	popj 17,

lshr_and:
	movn 2,2
	lsh 1,(2)
	and 1,3
	popj 17,

lshr_twice:
	movn 2,2
	lsh 1,(2)
	movn 3,3
	lsh 1,(3)
	popj 17,

lshr_mix:
	movn 2,2
	lsh 1,(2)
	lsh 3,-1
	xor 1,3
	popj 17,

lshr_eq_zero:
	movn 2,2
	lsh 1,(2)
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

lshr_ne_zero:
	movn 2,2
	lsh 1,(2)
	skipe 1
	movei 1,1
	popj 17,

lshr_lt_const:
	movn 2,2
	lsh 1,(2)
	skipl 1,1
	cail 1,12345
	tdza 1,1
	movei 1,1
	popj 17,

lshr_gt_const:
	movn 2,2
	lsh 1,(2)
	skipl 1,1
	cail 1,12346
	trna
	tdza 1,1
	movei 1,1
	popj 17,

lshr_high_after_shift:
	tlo 1,400000
	movn 2,2
	lsh 1,(2)
	skipl 1,1
	caml 1,[1000000]
	trna
	tdza 1,1
	movei 1,1
	popj 17,

lshr_range:
	movn 2,2
	lsh 1,(2)
	tlc 1,400000
	seto 4,
	camg 1,[-377777777701]
	jrst %L106
	hrloi 6,400000
	camg 1,6
	tdza 4,4
	movei 4,1
%L106:
	move 1,4
	popj 17,

lshr_udiv_2:
	lsh 1,-1
	popj 17,

lshr_udiv_4:
	lsh 1,-2
	popj 17,

lshr_udiv_8:
	lsh 1,-3
	popj 17,

lshr_udiv_512:
	lsh 1,-11
	popj 17,

lshr_umod_2:
	andi 1,1
	popj 17,

lshr_umod_4:
	andi 1,3
	popj 17,

lshr_umod_8:
	andi 1,7
	popj 17,

lshr_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,2
	move 11,(1)
	pushj 17,clobber
	movn 10,10
	lsh 11,(10)
	move 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

lshr_count_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,(2)
	pushj 17,clobber
	movn 10,10
	lsh 11,(10)
	move 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

lshr_store_after_call:
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
	lsh 11,(10)
	movem 11,(12)
	move 1,11
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

lshr_global_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	pushj 17,uf
	move 11,1
	pushj 17,clobber
	movn 10,10
	lsh 11,(10)
	move 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
lshr_ga:
	.space	4
lshr_gb:
	.space	4
lshr_vga:
	.space	4
lshr_buf:
	.space	64
lshr_count:
	.space	4
lshr_vcount:
	.space	4
lshr_counts:
	.space	64
lshr_ucount:
	.space	4
lshr_vucount:
	.space	4
lshr_ucounts:
	.space	64
lshr_gp:
	.space	8
lshr_gt:
	.space	12
lshr_cgp:
	.space	8
