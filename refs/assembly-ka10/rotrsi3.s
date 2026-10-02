
	.globl	rotrsi3
rotrsi3:
	movn 2,2
	rot 1,(2)
	popj 17,

rotr_reg_reg:
	movn 2,2
	rot 1,(2)
	popj 17,

rotr_reg_ureg:
	movn 2,2
	rot 1,(2)
	popj 17,

rotr_second_arg:
	movn 3,3
	rot 2,(3)
	move 1,2
	popj 17,

rotr_local:
	movn 2,2
	rot 1,(2)
	popj 17,

rotr_reuse_value:
	movn 2,2
	rot 1,(2)
	popj 17,

rotr_reuse_count:
	movn 2,2
	rot 1,(2)
	popj 17,

rotr_after_add:
	add 1,2
	movn 3,3
	rot 1,(3)
	popj 17,

rotr_after_sub:
	sub 1,2
	movn 3,3
	rot 1,(3)
	popj 17,

rotr_after_and:
	and 1,2
	movn 3,3
	rot 1,(3)
	popj 17,

rotr_after_xor:
	xor 1,2
	movn 3,3
	rot 1,(3)
	popj 17,

rotr_after_or:
	ior 1,2
	movn 3,3
	rot 1,(3)
	popj 17,

rotr_call_count:
	push 17,10
	move 10,1
	pushj 17,f
	movn 1,1
	rot 10,(1)
	move 1,10
	pop 17,10
	popj 17,

rotr_ucall_count:
	push 17,10
	move 10,1
	pushj 17,uf
	movn 1,1
	rot 10,(1)
	move 1,10
	pop 17,10
	popj 17,

rotr_call_value:
	push 17,10
	move 10,1
	pushj 17,uf
	movn 10,10
	rot 1,(10)
	pop 17,10
	popj 17,

rotri_1:
	rot 1,-1
	popj 17,

rotri_2:
	rot 1,-2
	popj 17,

rotri_3:
	rot 1,-3
	popj 17,

rotri_4:
	rot 1,-4
	popj 17,

rotri_5:
	rot 1,-5
	popj 17,

rotri_8:
	rot 1,-10
	popj 17,

rotri_9:
	rot 1,-11
	popj 17,

rotri_17:
	rot 1,-21
	popj 17,

rotri_18:
	movs 1,1
	popj 17,

rotri_19:
	rot 1,21
	popj 17,

rotri_27:
	rot 1,11
	popj 17,

rotri_35:
	rot 1,1
	popj 17,

rotri_high_1:
	tlo 1,400000
	rot 1,-1
	popj 17,

rotri_high_4:
	tlo 1,400000
	rot 1,-4
	popj 17,

rotri_high_18:
	tlo 1,400000
	movs 1,1
	popj 17,

rotri_high_35:
	tlo 1,400000
	rot 1,1
	popj 17,

rotri_const_high:
	movsi 1,200000
	popj 17,

rotri_const_allones:
	seto 1,
	popj 17,

rotri_const_full:
	move 1,[270516270516]
	popj 17,

rotr_mem_value:
	move 1,(1)
	movn 2,2
	rot 1,(2)
	popj 17,

rotr_volatile_mem_value:
	move 1,(1)
	movn 2,2
	rot 1,(2)
	popj 17,

rotr_global_value:
	move 4,rotr_ga
	movn 1,1
	rot 4,(1)
	move 1,4
	popj 17,

rotr_global_b_value:
	move 4,rotr_gb
	movn 1,1
	rot 4,(1)
	move 1,4
	popj 17,

rotr_volatile_global_value:
	move 4,rotr_vga
	movn 1,1
	rot 4,(1)
	move 1,4
	popj 17,

rotr_array_value:
	andi 1,17
	move 1,rotr_buf(1)
	movn 2,2
	rot 1,(2)
	popj 17,

rotr_ptr_array_value:
	andi 2,17
	add 1,2
	move 1,(1)
	movn 3,3
	rot 1,(3)
	popj 17,

rotr_mem_count:
	movn 4,(2)
	rot 1,(4)
	popj 17,

rotr_umem_count:
	movn 4,(2)
	rot 1,(4)
	popj 17,

rotr_volatile_mem_count:
	move 4,(2)
	movn 4,4
	rot 1,(4)
	popj 17,

rotr_global_count:
	movn 4,rotr_count
	rot 1,(4)
	popj 17,

rotr_uglobal_count:
	movn 4,rotr_ucount
	rot 1,(4)
	popj 17,

rotr_volatile_global_count:
	move 4,rotr_vcount
	movn 4,4
	rot 1,(4)
	popj 17,

rotr_volatile_uglobal_count:
	move 4,rotr_vucount
	movn 4,4
	rot 1,(4)
	popj 17,

rotr_array_count:
	andi 2,17
	movn 4,rotr_counts(2)
	rot 1,(4)
	popj 17,

rotr_uarray_count:
	andi 2,17
	movn 4,rotr_ucounts(2)
	rot 1,(4)
	popj 17,

rotr_mem_value_mem_count:
	move 1,(1)
	movn 4,(2)
	rot 1,(4)
	popj 17,

rotr_global_value_global_count:
	move 1,rotr_ga
	movn 4,rotr_count
	rot 1,(4)
	popj 17,

rotr_struct_value_a:
	move 1,(1)
	movn 2,2
	rot 1,(2)
	popj 17,

rotr_struct_value_b:
	move 1,1(1)
	movn 2,2
	rot 1,(2)
	popj 17,

rotr_struct_count_a:
	movn 4,(2)
	rot 1,(4)
	popj 17,

rotr_struct_count_b:
	movn 4,1(2)
	rot 1,(4)
	popj 17,

rotr_struct_both:
	move 4,1
	move 1,(1)
	movn 4,1(4)
	rot 1,(4)
	popj 17,

rotr_global_struct_value:
	move 4,rotr_gp
	movn 1,1
	rot 4,(1)
	move 1,4
	popj 17,

rotr_global_struct_count:
	movn 4,rotr_cgp+1
	rot 1,(4)
	popj 17,

rotr_global_struct_three:
	move 1,rotr_gt
	movn 4,rotr_gt+2
	rot 1,(4)
	popj 17,

rotr_count_plus_1:
	movei 4,43
	sub 4,2
	rot 1,(4)
	popj 17,

rotr_count_plus_2:
	movei 4,42
	sub 4,2
	rot 1,(4)
	popj 17,

rotr_count_plus_7:
	movei 4,35
	sub 4,2
	rot 1,(4)
	popj 17,

rotr_count_plus_18:
	movei 4,22
	sub 4,2
	rot 1,(4)
	popj 17,

rotr_count_minus_1:
	movei 4,45
	sub 4,2
	rot 1,(4)
	popj 17,

rotr_count_minus_2:
	movei 4,46
	sub 4,2
	rot 1,(4)
	popj 17,

rotr_ucount_plus_1:
	movei 4,43
	sub 4,2
	rot 1,(4)
	popj 17,

rotr_ucount_plus_8:
	movei 4,34
	sub 4,2
	rot 1,(4)
	popj 17,

rotr_mem_count_plus:
	setcm 4,(2)
	rot 1,(4)
	popj 17,

rotr_array_count_plus:
	andi 2,17
	setcm 4,rotr_counts(2)
	rot 1,(4)
	popj 17,

rotr_struct_count_plus:
	setcm 4,1(2)
	rot 1,(4)
	popj 17,

rotr_uqi_value:
	andi 1,777	; zero_extendqisi2
	movn 2,2
	rot 1,(2)
	popj 17,

rotr_uhi_value:
	hrrzi 1,(1)	; zero_extendhisi2
	movn 2,2
	rot 1,(2)
	popj 17,

rotr_qi_value_cast:
	lsh 1,33
	ash 1,-33
	movn 2,2
	rot 1,(2)
	popj 17,

rotr_hi_value_cast:
	hrre 1,1
	movn 2,2
	rot 1,(2)
	popj 17,

rotr_uqi_count:
	andi 2,777	; zero_extendqisi2
	movn 2,2
	rot 1,(2)
	popj 17,

rotr_uhi_count:
	movni 2,(2)
	rot 1,(2)
	popj 17,

rotr_qi_count_cast:
	lsh 2,33
	ash 2,-33
	movn 2,2
	rot 1,(2)
	popj 17,

rotr_hi_count_cast:
	hrre 2,2
	movn 2,2
	rot 1,(2)
	popj 17,

rotr_store_ptr:
	movn 3,3
	rot 2,(3)
	movem 2,(1)
	popj 17,

rotr_store_ptr_return:
	movn 3,3
	rot 2,(3)
	movem 2,(1)
	move 1,2
	popj 17,

rotr_store_global:
	movn 2,2
	rot 1,(2)
	movem 1,rotr_ga
	popj 17,

rotr_store_global_return:
	movn 2,2
	rot 1,(2)
	movem 1,rotr_ga
	popj 17,

rotr_store_array:
	andi 1,17
	movn 3,3
	rot 2,(3)
	movem 2,rotr_buf(1)
	popj 17,

rotr_store_array_return:
	andi 1,17
	movn 3,3
	rot 2,(3)
	movem 2,rotr_buf(1)
	move 1,2
	popj 17,

rotr_inplace_ptr:
	move 4,(1)
	movn 2,2
	rot 4,(2)
	movem 4,(1)
	popj 17,

rotr_inplace_ptr_return:
	move 4,(1)
	movn 2,2
	rot 4,(2)
	movem 4,(1)
	move 1,4
	popj 17,

rotr_inplace_global:
	move 4,rotr_ga
	movn 1,1
	rot 4,(1)
	movem 4,rotr_ga
	popj 17,

rotr_inplace_global_return:
	move 4,rotr_ga
	movn 1,1
	rot 4,(1)
	movem 4,rotr_ga
	move 1,4
	popj 17,

rotr_inplace_array:
	andi 1,17
	move 4,rotr_buf(1)
	movn 2,2
	rot 4,(2)
	movem 4,rotr_buf(1)
	popj 17,

rotr_inplace_array_return:
	andi 1,17
	move 4,rotr_buf(1)
	movn 2,2
	rot 4,(2)
	movem 4,rotr_buf(1)
	move 1,4
	popj 17,

rotr_plus:
	movn 2,2
	rot 1,(2)
	add 1,3
	popj 17,

rotr_minus:
	movn 2,2
	rot 1,(2)
	sub 1,3
	popj 17,

rotr_xor:
	movn 2,2
	rot 1,(2)
	xor 1,3
	popj 17,

rotr_or:
	movn 2,2
	rot 1,(2)
	ior 1,3
	popj 17,

rotr_and:
	movn 2,2
	rot 1,(2)
	and 1,3
	popj 17,

rotr_twice:
	movn 2,2
	rot 1,(2)
	movn 3,3
	rot 1,(3)
	popj 17,

rotr_mix:
	movn 2,2
	rot 1,(2)
	rot 3,-1
	xor 1,3
	popj 17,

rotr_eq_zero:
	movn 2,2
	rot 1,(2)
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

rotr_ne_zero:
	movn 2,2
	rot 1,(2)
	skipe 1
	movei 1,1
	popj 17,

rotr_lt_const:
	movn 2,2
	rot 1,(2)
	skipl 1,1
	cail 1,12345
	tdza 1,1
	movei 1,1
	popj 17,

rotr_gt_const:
	movn 2,2
	rot 1,(2)
	skipl 1,1
	cail 1,12346
	trna
	tdza 1,1
	movei 1,1
	popj 17,

rotr_high_after_rotate:
	tlo 1,400000
	movn 2,2
	rot 1,(2)
	skipl 1,1
	caml 1,[1000000]
	trna
	tdza 1,1
	movei 1,1
	popj 17,

rotr_range:
	movn 2,2
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

rotr_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,2
	move 11,(1)
	pushj 17,clobber
	movn 10,10
	rot 11,(10)
	move 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

rotr_count_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,(2)
	pushj 17,clobber
	movn 10,10
	rot 11,(10)
	move 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

rotr_store_after_call:
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
	rot 11,(10)
	movem 11,(12)
	move 1,11
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

rotr_global_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	pushj 17,uf
	move 11,1
	pushj 17,clobber
	movn 10,10
	rot 11,(10)
	move 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
rotr_ga:
	.space	4
rotr_gb:
	.space	4
rotr_vga:
	.space	4
rotr_buf:
	.space	64
rotr_count:
	.space	4
rotr_vcount:
	.space	4
rotr_counts:
	.space	64
rotr_ucount:
	.space	4
rotr_vucount:
	.space	4
rotr_ucounts:
	.space	64
rotr_gp:
	.space	8
rotr_gt:
	.space	12
rotr_cgp:
	.space	8
