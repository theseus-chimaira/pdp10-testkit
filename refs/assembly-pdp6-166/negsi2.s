
negsi2:
	movn 1,1
	popj 17,

neg_arg:
	movn 1,1
	popj 17,

uneg_arg:
	movn 1,1
	popj 17,

neg_second_arg:
	movn 2,2
	move 1,2
	popj 17,

neg_local:
	movn 1,1
	popj 17,

neg_reuse:
	movn 1,1
	popj 17,

neg_after_add:
	add 1,2
	movn 1,1
	popj 17,

neg_after_sub:
	sub 2,1
	move 1,2
	popj 17,

neg_after_mul:
	imul 1,2
	movn 1,1
	popj 17,

neg_after_xor:
	xor 1,2
	movn 1,1
	popj 17,

neg_call:
	pushj 17,f
	movn 1,1
	popj 17,

neg_call_plus:
	push 17,10
	move 10,1
	pushj 17,f
	sub 10,1
	move 1,10
	pop 17,10
	popj 17,

uneg_call:
	pushj 17,uf
	movn 1,1
	popj 17,

neg_mem:
	movn 1,(1)
	popj 17,

neg_mem_local:
	movn 1,(1)
	popj 17,

neg_volatile_mem:
	move 1,(1)
	movn 1,1
	popj 17,

neg_global:
	movn 1,negsi2_ga
	popj 17,

neg_global_b:
	movn 1,negsi2_gb
	popj 17,

neg_volatile_global:
	move 1,negsi2_vga
	movn 1,1
	popj 17,

uneg_global:
	movn 1,unegsi2_ga
	popj 17,

uneg_volatile_global:
	move 1,unegsi2_vga
	movn 1,1
	popj 17,

neg_array:
	andi 1,17
	movn 1,negsi2_buf(1)
	popj 17,

neg_ptr_array:
	andi 2,17
	add 1,2
	movn 1,(1)
	popj 17,

uneg_array:
	andi 1,17
	movn 1,unegsi2_buf(1)
	popj 17,

neg_struct_a:
	movn 1,(1)
	popj 17,

neg_struct_b:
	movn 1,1(1)
	popj 17,

neg_struct_sum:
	move 6,(1)
	add 6,1(1)
	movn 1,6
	popj 17,

neg_struct_three:
	move 4,1
	move 1,(1)
	sub 1,1(4)
	add 1,2(4)
	movn 1,1
	popj 17,

neg_global_struct_a:
	movn 1,negsi2_gp
	popj 17,

neg_global_struct_b:
	movn 1,negsi2_gp+1
	popj 17,

neg_global_struct_c:
	movn 1,negsi2_gt+2
	popj 17,

uneg_global_struct_a:
	movn 1,unegsi2_gp
	popj 17,

neg_const_zero:
	movei 1,0
	popj 17,

neg_const_one:
	seto 1,
	popj 17,

neg_const_two:
	hrroi 1,777776
	popj 17,

neg_const_small:
	hrroi 1,765433
	popj 17,

neg_const_right_max:
	hrroi 1,1
	popj 17,

neg_const_left:
	movsi 1,654322
	popj 17,

neg_const_full:
	move 1,[-123456123456]
	popj 17,

uneg_const_one:
	seto 1,
	popj 17,

uneg_const_right_max:
	hrroi 1,1
	popj 17,

neg_right_half:
	movni 1,(1)
	popj 17,

neg_right_half_mem:
	hrrz 1,(1)
	movn 1,1
	popj 17,

neg_right_half_global:
	hrrz 1,negsi2_ga
	movn 1,1
	popj 17,

neg_right_half_plus:
	movni 1,123(1)
	popj 17,

neg_right_half_plus_big:
	movni 1,777(1)
	popj 17,

neg_right_half_array:
	andi 1,17
	move 1,negsi2_buf(1)
	addi 1,123
	movni 1,(1)
	popj 17,

uneg_right_half:
	movni 1,(1)
	popj 17,

uneg_right_half_plus:
	movni 1,123(1)
	popj 17,

neg_store_ptr:
	movnm 2,(1)
	popj 17,

neg_store_ptr_return:
	movn 2,2
	movem 2,(1)
	move 1,2
	popj 17,

neg_store_global:
	movnm 1,negsi2_ga
	popj 17,

neg_store_global_return:
	movn 1,1
	movem 1,negsi2_ga
	popj 17,

neg_store_array:
	andi 1,17
	movnm 2,negsi2_buf(1)
	popj 17,

neg_store_array_return:
	andi 1,17
	movn 2,2
	movem 2,negsi2_buf(1)
	move 1,2
	popj 17,

neg_store_struct_a:
	movnm 2,(1)
	popj 17,

neg_store_struct_a_return:
	movn 2,2
	movem 2,(1)
	move 1,2
	popj 17,

uneg_store_ptr:
	movnm 2,(1)
	popj 17,

uneg_store_ptr_return:
	movn 2,2
	movem 2,(1)
	move 1,2
	popj 17,

neg_inplace_ptr:
	movns (1)
	popj 17,

neg_inplace_ptr_return:
	movns 4,(1)
	move 1,4
	popj 17,

neg_inplace_global:
	movns negsi2_ga
	popj 17,

neg_inplace_global_return:
	movns 1,negsi2_ga
	popj 17,

neg_inplace_array:
	andi 1,17
	movns negsi2_buf(1)
	popj 17,

neg_inplace_array_return:
	andi 1,17
	movns 4,negsi2_buf(1)
	move 1,4
	popj 17,

neg_inplace_struct_a:
	movns (1)
	popj 17,

neg_inplace_struct_a_return:
	movns 4,(1)
	move 1,4
	popj 17,

uneg_inplace_ptr:
	movns (1)
	popj 17,

uneg_inplace_ptr_return:
	movns 4,(1)
	move 1,4
	popj 17,

uneg_inplace_global:
	movns unegsi2_ga
	popj 17,

uneg_inplace_global_return:
	movns 1,unegsi2_ga
	popj 17,

neg_plus:
	sub 2,1
	move 1,2
	popj 17,

neg_minus:
	movn 1,1
	sub 1,2
	popj 17,

neg_xor:
	movn 1,1
	xor 1,2
	popj 17,

neg_and:
	movn 1,1
	and 1,2
	popj 17,

neg_or:
	movn 1,1
	ior 1,2
	popj 17,

neg_shift_left:
	movn 1,1
	lsh 1,1
	popj 17,

neg_shift_right:
	movn 1,1
	ash 1,-1
	popj 17,

neg_sum3:
	movn 1,1
	sub 1,2
	sub 1,3
	popj 17,

neg_mem_mix:
	movn 1,(1)
	sub 1,2
	popj 17,

neg_array_mix:
	andi 1,17
	movn 1,negsi2_buf(1)
	movn 2,2
	xor 1,2
	popj 17,

neg_eq_zero:
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

neg_ne_zero:
	skipe 1
	movei 1,1
	popj 17,

neg_lt_zero:
	movn 1,1
	lsh 1,-43
	popj 17,

neg_ge_zero:
	subi 1,1
	lsh 1,-43
	popj 17,

neg_gt_const:
	movn 1,1
	movei 6,123
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

neg_range:
	movn 1,1
	seto 4,
	camge 1,[-100]
	jrst %L88
	movei 6,100
	camg 1,6
	tdza 4,4
	movei 4,1
%L88:
	move 1,4
	popj 17,

neg_mem_eq_zero:
	skipe (1)
	tdza 1,1
	movei 1,1
	popj 17,

neg_inplace_branch:
	movns 4,(1)
	lsh 4,-43
	move 1,4
	popj 17,

neg_after_call:
	push 17,10
	move 10,(1)
	pushj 17,clobber
	movn 10,10
	move 1,10
	pop 17,10
	popj 17,

neg_call_after_load:
	push 17,10
	move 10,(1)
	pushj 17,clobber
	pushj 17,f
	sub 10,1
	move 1,10
	pop 17,10
	popj 17,

neg_store_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,f
	move 10,1
	pushj 17,clobber
	movn 10,10
	movem 10,(11)
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

neg_global_after_call:
	push 17,10
	pushj 17,f
	move 10,1
	pushj 17,clobber
	move 1,negsi2_ga
	sub 1,10
	pop 17,10
	popj 17,

neg_inplace_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	movns 1,(10)
	pop 17,10
	popj 17,

	.bss
negsi2_ga:
	.space	4
negsi2_gb:
	.space	4
negsi2_gc:
	.space	4
negsi2_vga:
	.space	4
negsi2_buf:
	.space	64
unegsi2_ga:
	.space	4
unegsi2_vga:
	.space	4
unegsi2_buf:
	.space	64
negsi2_gp:
	.space	8
negsi2_gt:
	.space	12
unegsi2_gp:
	.space	8
