
	.globl	rotlsi3
rotlsi3:
	rot 1,(2)
	popj 17,

rotl_reg_reg:
	rot 1,(2)
	popj 17,

rotl_reg_ureg:
	rot 1,(2)
	popj 17,

rotl_second_arg:
	rot 2,(3)
	move 1,2
	popj 17,

rotl_local:
	rot 1,(2)
	popj 17,

rotl_reuse_value:
	rot 1,(2)
	popj 17,

rotl_reuse_count:
	rot 1,(2)
	popj 17,

rotl_after_add:
	add 1,2
	rot 1,(3)
	popj 17,

rotl_after_sub:
	sub 1,2
	rot 1,(3)
	popj 17,

rotl_after_and:
	and 1,2
	rot 1,(3)
	popj 17,

rotl_after_xor:
	xor 1,2
	rot 1,(3)
	popj 17,

rotl_after_or:
	ior 1,2
	rot 1,(3)
	popj 17,

rotl_call_count:
	push 17,10
	move 10,1
	pushj 17,f
	rot 10,(1)
	move 1,10
	pop 17,10
	popj 17,

rotl_ucall_count:
	push 17,10
	move 10,1
	pushj 17,uf
	rot 10,(1)
	move 1,10
	pop 17,10
	popj 17,

rotl_call_value:
	push 17,10
	move 10,1
	pushj 17,uf
	rot 1,(10)
	pop 17,10
	popj 17,

rotli_1:
	rot 1,1
	popj 17,

rotli_2:
	rot 1,2
	popj 17,

rotli_3:
	rot 1,3
	popj 17,

rotli_4:
	rot 1,4
	popj 17,

rotli_5:
	rot 1,5
	popj 17,

rotli_8:
	rot 1,10
	popj 17,

rotli_9:
	rot 1,11
	popj 17,

rotli_17:
	rot 1,21
	popj 17,

rotli_18:
	movs 1,1
	popj 17,

rotli_19:
	rot 1,-21
	popj 17,

rotli_27:
	rot 1,-11
	popj 17,

rotli_35:
	rot 1,-1
	popj 17,

rotli_high_1:
	tlo 1,400000
	rot 1,1
	popj 17,

rotli_high_4:
	tlo 1,400000
	rot 1,4
	popj 17,

rotli_high_18:
	tlo 1,400000
	movs 1,1
	popj 17,

rotli_high_35:
	tlo 1,400000
	rot 1,-1
	popj 17,

rotli_const_high:
	movei 1,1
	popj 17,

rotli_const_allones:
	seto 1,
	popj 17,

rotli_const_full:
	move 1,[-64353064354]
	popj 17,

rotl_mem_value:
	move 1,(1)
	rot 1,(2)
	popj 17,

rotl_volatile_mem_value:
	move 1,(1)
	rot 1,(2)
	popj 17,

rotl_global_value:
	move 4,1
	move 1,rotl_ga
	rot 1,(4)
	popj 17,

rotl_global_b_value:
	move 4,1
	move 1,rotl_gb
	rot 1,(4)
	popj 17,

rotl_volatile_global_value:
	move 4,1
	move 1,rotl_vga
	rot 1,(4)
	popj 17,

rotl_array_value:
	andi 1,17
	move 1,rotl_buf(1)
	rot 1,(2)
	popj 17,

rotl_ptr_array_value:
	andi 2,17
	add 1,2
	move 1,(1)
	rot 1,(3)
	popj 17,

rotl_mem_count:
	rot 1,@(2)
	popj 17,

rotl_umem_count:
	rot 1,@(2)
	popj 17,

rotl_volatile_mem_count:
	move 4,(2)
	rot 1,(4)
	popj 17,

rotl_global_count:
	rot 1,@rotl_count
	popj 17,

rotl_uglobal_count:
	rot 1,@rotl_ucount
	popj 17,

rotl_volatile_global_count:
	move 4,rotl_vcount
	rot 1,(4)
	popj 17,

rotl_volatile_uglobal_count:
	move 4,rotl_vucount
	rot 1,(4)
	popj 17,

rotl_array_count:
	andi 2,17
	rot 1,@rotl_counts(2)
	popj 17,

rotl_uarray_count:
	andi 2,17
	rot 1,@rotl_ucounts(2)
	popj 17,

rotl_mem_value_mem_count:
	move 1,(1)
	rot 1,@(2)
	popj 17,

rotl_global_value_global_count:
	move 1,rotl_ga
	rot 1,@rotl_count
	popj 17,

rotl_struct_value_a:
	move 1,(1)
	rot 1,(2)
	popj 17,

rotl_struct_value_b:
	move 1,1(1)
	rot 1,(2)
	popj 17,

rotl_struct_count_a:
	rot 1,@(2)
	popj 17,

rotl_struct_count_b:
	rot 1,@1(2)
	popj 17,

rotl_struct_both:
	move 4,1
	move 1,(1)
	rot 1,@1(4)
	popj 17,

rotl_global_struct_value:
	move 4,1
	move 1,rotl_gp
	rot 1,(4)
	popj 17,

rotl_global_struct_count:
	rot 1,@rotl_cgp+1
	popj 17,

rotl_global_struct_three:
	move 1,rotl_gt
	rot 1,@rotl_gt+2
	popj 17,

rotl_count_plus_1:
	rot 1,1(2)
	popj 17,

rotl_count_plus_2:
	rot 1,2(2)
	popj 17,

rotl_count_plus_7:
	rot 1,7(2)
	popj 17,

rotl_count_plus_18:
	rot 1,22(2)
	popj 17,

rotl_count_minus_1:
	rot 1,-1(2)
	popj 17,

rotl_count_minus_2:
	rot 1,-2(2)
	popj 17,

rotl_ucount_plus_1:
	rot 1,1(2)
	popj 17,

rotl_ucount_plus_8:
	rot 1,10(2)
	popj 17,

rotl_mem_count_plus:
	move 4,(2)
	addi 4,1
	rot 1,(4)
	popj 17,

rotl_array_count_plus:
	andi 2,17
	move 4,rotl_counts(2)
	addi 4,1
	rot 1,(4)
	popj 17,

rotl_struct_count_plus:
	move 4,1(2)
	addi 4,1
	rot 1,(4)
	popj 17,

rotl_uqi_value:
	andi 1,777	; zero_extendqisi2
	rot 1,(2)
	popj 17,

rotl_uhi_value:
	hrrzi 1,(1)	; zero_extendhisi2
	rot 1,(2)
	popj 17,

rotl_qi_value_cast:
	lsh 1,33
	ash 1,-33
	rot 1,(2)
	popj 17,

rotl_hi_value_cast:
	hrre 1,1
	rot 1,(2)
	popj 17,

rotl_uqi_count:
	andi 2,777	; zero_extendqisi2
	rot 1,(2)
	popj 17,

rotl_uhi_count:
	hrrzi 2,(2)	; zero_extendhisi2
	rot 1,(2)
	popj 17,

rotl_qi_count_cast:
	lsh 2,33
	ash 2,-33
	rot 1,(2)
	popj 17,

rotl_hi_count_cast:
	hrre 2,2
	rot 1,(2)
	popj 17,

rotl_store_ptr:
	rot 2,(3)
	movem 2,(1)
	popj 17,

rotl_store_ptr_return:
	rot 2,(3)
	movem 2,(1)
	move 1,2
	popj 17,

rotl_store_global:
	rot 1,(2)
	movem 1,rotl_ga
	popj 17,

rotl_store_global_return:
	rot 1,(2)
	movem 1,rotl_ga
	popj 17,

rotl_store_array:
	andi 1,17
	rot 2,(3)
	movem 2,rotl_buf(1)
	popj 17,

rotl_store_array_return:
	andi 1,17
	rot 2,(3)
	movem 2,rotl_buf(1)
	move 1,2
	popj 17,

rotl_inplace_ptr:
	move 4,(1)
	rot 4,(2)
	movem 4,(1)
	popj 17,

rotl_inplace_ptr_return:
	move 4,1
	move 1,(1)
	rot 1,(2)
	movem 1,(4)
	popj 17,

rotl_inplace_global:
	move 4,rotl_ga
	rot 4,(1)
	movem 4,rotl_ga
	popj 17,

rotl_inplace_global_return:
	move 4,1
	move 1,rotl_ga
	rot 1,(4)
	movem 1,rotl_ga
	popj 17,

rotl_inplace_array:
	andi 1,17
	move 4,rotl_buf(1)
	rot 4,(2)
	movem 4,rotl_buf(1)
	popj 17,

rotl_inplace_array_return:
	andi 1,17
	move 4,rotl_buf(1)
	rot 4,(2)
	movem 4,rotl_buf(1)
	move 1,4
	popj 17,

rotl_plus:
	rot 1,(2)
	add 1,3
	popj 17,

rotl_minus:
	rot 1,(2)
	sub 1,3
	popj 17,

rotl_xor:
	rot 1,(2)
	xor 1,3
	popj 17,

rotl_or:
	rot 1,(2)
	ior 1,3
	popj 17,

rotl_and:
	rot 1,(2)
	and 1,3
	popj 17,

rotl_twice:
	rot 1,(2)
	rot 1,(3)
	popj 17,

rotl_mix:
	rot 1,(2)
	rot 3,1
	xor 1,3
	popj 17,

rotl_eq_zero:
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

rotl_ne_zero:
	skipe 1
	movei 1,1
	popj 17,

rotl_lt_const:
	rot 1,(2)
	skipl 1,1
	cail 1,12345
	tdza 1,1
	movei 1,1
	popj 17,

rotl_gt_const:
	rot 1,(2)
	skipl 1,1
	cail 1,12346
	trna
	tdza 1,1
	movei 1,1
	popj 17,

rotl_high_after_rotate:
	tlo 1,400000
	rot 1,(2)
	skipl 1,1
	caml 1,[1000000]
	trna
	tdza 1,1
	movei 1,1
	popj 17,

rotl_range:
	rot 1,(2)
	tlc 1,400000
	seto 4,
	camg 1,[-377777777701]
	jrst %L105
	hrloi 6,400000
	camg 1,6
	tdza 4,4
	movei 4,1
%L105:
	move 1,4
	popj 17,

rotl_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,2
	move 10,(1)
	pushj 17,clobber
	rot 10,(11)
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

rotl_count_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,(2)
	pushj 17,clobber
	rot 10,(11)
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

rotl_store_after_call:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 10,1
	move 11,2
	pushj 17,f
	move 12,1
	pushj 17,clobber
	rot 11,(12)
	movem 11,(10)
	move 1,11
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

rotl_global_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,uf
	move 10,1
	pushj 17,clobber
	rot 10,(11)
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
rotl_ga:
	.space	4
rotl_gb:
	.space	4
rotl_vga:
	.space	4
rotl_buf:
	.space	64
rotl_count:
	.space	4
rotl_vcount:
	.space	4
rotl_counts:
	.space	64
rotl_ucount:
	.space	4
rotl_vucount:
	.space	4
rotl_ucounts:
	.space	64
rotl_gp:
	.space	8
rotl_gt:
	.space	12
rotl_cgp:
	.space	8
