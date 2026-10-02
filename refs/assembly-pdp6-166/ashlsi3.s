
	.globl	ashlsi3
ashlsi3:
	lsh 1,(2)
	popj 17,

ashl_reg_reg:
	lsh 1,(2)
	popj 17,

uashl_reg_reg:
	lsh 1,(2)
	popj 17,

ashl_second_arg:
	lsh 2,(3)
	move 1,2
	popj 17,

ashl_local:
	lsh 1,(2)
	popj 17,

uashl_local:
	lsh 1,(2)
	popj 17,

ashl_reuse_left:
	lsh 1,(2)
	popj 17,

ashl_reuse_count:
	lsh 1,(2)
	popj 17,

ashl_after_add:
	add 1,2
	lsh 1,(3)
	popj 17,

ashl_after_sub:
	sub 1,2
	lsh 1,(3)
	popj 17,

ashl_after_and:
	and 1,2
	lsh 1,(3)
	popj 17,

ashl_after_xor:
	xor 1,2
	lsh 1,(3)
	popj 17,

ashl_call_count:
	push 17,10
	move 10,1
	pushj 17,f
	lsh 10,(1)
	move 1,10
	pop 17,10
	popj 17,

ashl_call_value:
	push 17,10
	move 10,1
	pushj 17,f
	lsh 1,(10)
	pop 17,10
	popj 17,

uashl_call_count:
	push 17,10
	move 10,1
	pushj 17,uf
	lsh 10,(1)
	move 1,10
	pop 17,10
	popj 17,

ashli_0:
	popj 17,

ashli_1:
	lsh 1,1
	popj 17,

ashli_2:
	lsh 1,2
	popj 17,

ashli_3:
	lsh 1,3
	popj 17,

ashli_4:
	lsh 1,4
	popj 17,

ashli_5:
	lsh 1,5
	popj 17,

ashli_8:
	lsh 1,10
	popj 17,

ashli_9:
	lsh 1,11
	popj 17,

ashli_17:
	lsh 1,21
	popj 17,

ashli_18:
	hrlz 1,1
	popj 17,

ashli_19:
	lsh 1,23
	popj 17,

ashli_27:
	lsh 1,33
	popj 17,

ashli_35:
	lsh 1,43
	popj 17,

uashli_1:
	lsh 1,1
	popj 17,

uashli_8:
	lsh 1,10
	popj 17,

uashli_18:
	hrlz 1,1
	popj 17,

uashli_35:
	lsh 1,43
	popj 17,

ashl_mem_value:
	move 1,(1)
	lsh 1,(2)
	popj 17,

uashl_mem_value:
	move 1,(1)
	lsh 1,(2)
	popj 17,

ashl_volatile_mem_value:
	move 1,(1)
	lsh 1,(2)
	popj 17,

ashl_global_value:
	move 4,1
	move 1,ashl_ga
	lsh 1,(4)
	popj 17,

ashl_global_b_value:
	move 4,1
	move 1,ashl_gb
	lsh 1,(4)
	popj 17,

ashl_volatile_global_value:
	move 4,1
	move 1,ashl_vga
	lsh 1,(4)
	popj 17,

uashl_global_value:
	move 4,1
	move 1,uashl_ga
	lsh 1,(4)
	popj 17,

uashl_volatile_global_value:
	move 4,1
	move 1,uashl_vga
	lsh 1,(4)
	popj 17,

ashl_array_value:
	andi 1,17
	move 1,ashl_buf(1)
	lsh 1,(2)
	popj 17,

uashl_array_value:
	andi 1,17
	move 1,uashl_buf(1)
	lsh 1,(2)
	popj 17,

ashl_ptr_array_value:
	andi 2,17
	add 1,2
	move 1,(1)
	lsh 1,(3)
	popj 17,

ashl_mem_count:
	lsh 1,@(2)
	popj 17,

uashl_mem_count:
	lsh 1,@(2)
	popj 17,

ashl_volatile_mem_count:
	move 4,(2)
	lsh 1,(4)
	popj 17,

ashl_global_count:
	lsh 1,@ashl_count
	popj 17,

ashl_volatile_global_count:
	move 4,ashl_vcount
	lsh 1,(4)
	popj 17,

ashl_array_count:
	andi 2,17
	lsh 1,@ashl_counts(2)
	popj 17,

ashl_mem_value_mem_count:
	move 1,(1)
	lsh 1,@(2)
	popj 17,

ashl_global_value_global_count:
	move 1,ashl_ga
	lsh 1,@ashl_count
	popj 17,

ashl_struct_value_a:
	move 1,(1)
	lsh 1,(2)
	popj 17,

ashl_struct_value_b:
	move 1,1(1)
	lsh 1,(2)
	popj 17,

ashl_struct_count_a:
	lsh 1,@(2)
	popj 17,

ashl_struct_count_b:
	lsh 1,@1(2)
	popj 17,

ashl_struct_both:
	move 4,1
	move 1,(1)
	lsh 1,@1(4)
	popj 17,

uashl_struct_both:
	move 4,1
	move 1,(1)
	lsh 1,@1(4)
	popj 17,

ashl_global_struct_value:
	move 4,1
	move 1,ashl_gp
	lsh 1,(4)
	popj 17,

ashl_global_struct_count:
	lsh 1,@ashl_gp+1
	popj 17,

ashl_global_struct_three:
	move 1,ashl_gt
	lsh 1,@ashl_gt+2
	popj 17,

ashl_count_plus_1:
	lsh 1,1(2)
	popj 17,

ashl_count_plus_2:
	lsh 1,2(2)
	popj 17,

ashl_count_plus_7:
	lsh 1,7(2)
	popj 17,

ashl_count_plus_18:
	lsh 1,22(2)
	popj 17,

ashl_count_minus_1:
	lsh 1,-1(2)
	popj 17,

ashl_count_minus_2:
	lsh 1,-2(2)
	popj 17,

uashl_count_plus_1:
	lsh 1,1(2)
	popj 17,

uashl_count_plus_8:
	lsh 1,10(2)
	popj 17,

ashl_mem_count_plus:
	move 4,(2)
	addi 4,1
	lsh 1,(4)
	popj 17,

ashl_array_count_plus:
	andi 2,17
	move 4,ashl_counts(2)
	addi 4,1
	lsh 1,(4)
	popj 17,

ashl_struct_count_plus:
	move 4,1(2)
	addi 4,1
	lsh 1,(4)
	popj 17,

ashl_qi_value:
	lsh 1,33
	ash 1,-33
	lsh 1,(2)
	popj 17,

ashl_uqi_value:
	andi 1,777	; zero_extendqisi2
	lsh 1,(2)
	popj 17,

ashl_hi_value:
	hrre 1,1
	lsh 1,(2)
	popj 17,

ashl_uhi_value:
	hrrzi 1,(1)	; zero_extendhisi2
	lsh 1,(2)
	popj 17,

ashl_qi_count:
	lsh 2,33
	ash 2,-33
	lsh 1,(2)
	popj 17,

ashl_uqi_count:
	andi 2,777	; zero_extendqisi2
	lsh 1,(2)
	popj 17,

ashl_hi_count:
	hrre 2,2
	lsh 1,(2)
	popj 17,

ashl_uhi_count:
	hrrzi 2,(2)	; zero_extendhisi2
	lsh 1,(2)
	popj 17,

ashl_store_ptr:
	lsh 2,(3)
	movem 2,(1)
	popj 17,

ashl_store_ptr_return:
	lsh 2,(3)
	movem 2,(1)
	move 1,2
	popj 17,

ashl_store_global:
	lsh 1,(2)
	movem 1,ashl_ga
	popj 17,

ashl_store_global_return:
	lsh 1,(2)
	movem 1,ashl_ga
	popj 17,

ashl_store_array:
	andi 1,17
	lsh 2,(3)
	movem 2,ashl_buf(1)
	popj 17,

ashl_store_array_return:
	andi 1,17
	lsh 2,(3)
	movem 2,ashl_buf(1)
	move 1,2
	popj 17,

uashl_store_ptr:
	lsh 2,(3)
	movem 2,(1)
	popj 17,

uashl_store_ptr_return:
	lsh 2,(3)
	movem 2,(1)
	move 1,2
	popj 17,

ashl_inplace_ptr:
	move 4,(1)
	lsh 4,(2)
	movem 4,(1)
	popj 17,

ashl_inplace_ptr_return:
	move 4,1
	move 1,(1)
	lsh 1,(2)
	movem 1,(4)
	popj 17,

ashl_inplace_global:
	move 4,ashl_ga
	lsh 4,(1)
	movem 4,ashl_ga
	popj 17,

ashl_inplace_global_return:
	move 4,1
	move 1,ashl_ga
	lsh 1,(4)
	movem 1,ashl_ga
	popj 17,

ashl_inplace_array:
	andi 1,17
	move 4,ashl_buf(1)
	lsh 4,(2)
	movem 4,ashl_buf(1)
	popj 17,

ashl_inplace_array_return:
	andi 1,17
	move 4,ashl_buf(1)
	lsh 4,(2)
	movem 4,ashl_buf(1)
	move 1,4
	popj 17,

uashl_inplace_ptr:
	move 4,(1)
	lsh 4,(2)
	movem 4,(1)
	popj 17,

uashl_inplace_ptr_return:
	move 4,1
	move 1,(1)
	lsh 1,(2)
	movem 1,(4)
	popj 17,

ashl_plus:
	lsh 1,(2)
	add 1,3
	popj 17,

ashl_minus:
	lsh 1,(2)
	sub 1,3
	popj 17,

ashl_xor:
	lsh 1,(2)
	xor 1,3
	popj 17,

ashl_or:
	lsh 1,(2)
	ior 1,3
	popj 17,

ashl_and:
	lsh 1,(2)
	and 1,3
	popj 17,

ashl_twice:
	lsh 1,(2)
	lsh 1,(3)
	popj 17,

ashl_mix:
	lsh 1,(2)
	lsh 3,1
	xor 1,3
	popj 17,

ashl_eq_zero:
	lsh 1,(2)
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

ashl_ne_zero:
	lsh 1,(2)
	skipe 1
	movei 1,1
	popj 17,

ashl_lt_zero:
	lsh 1,(2)
	lsh 1,-43
	popj 17,

ashl_ge_zero:
	lsh 1,(2)
	skipge 1
	tdza 1,1
	movei 1,1
	popj 17,

ashl_gt_const:
	lsh 1,(2)
	movei 6,12345
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

ashl_range:
	lsh 1,(2)
	seto 4,
	camge 1,[-100]
	jrst %L109
	movei 6,100
	camg 1,6
	tdza 4,4
	movei 4,1
%L109:
	move 1,4
	popj 17,

ashl_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,2
	move 10,(1)
	pushj 17,clobber
	lsh 10,(11)
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

ashl_count_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,(2)
	pushj 17,clobber
	lsh 10,(11)
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

ashl_store_after_call:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 10,1
	move 11,2
	pushj 17,f
	move 12,1
	pushj 17,clobber
	lsh 11,(12)
	movem 11,(10)
	move 1,11
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

ashl_global_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,f
	move 10,1
	pushj 17,clobber
	lsh 10,(11)
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
ashl_ga:
	.space	4
ashl_gb:
	.space	4
ashl_vga:
	.space	4
ashl_buf:
	.space	64
uashl_ga:
	.space	4
uashl_gb:
	.space	4
uashl_vga:
	.space	4
uashl_buf:
	.space	64
ashl_count:
	.space	4
ashl_vcount:
	.space	4
ashl_counts:
	.space	64
ashl_gp:
	.space	8
uashl_gp:
	.space	8
ashl_gt:
	.space	12
