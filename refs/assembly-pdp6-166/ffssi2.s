
	.globl	ffssi2
ffssi2:
	pushj 17,ffs
	popj 17,

ffs_arg:
	pushj 17,ffs
	popj 17,

ffs_second_arg:
	move 1,2
	pushj 17,ffs
	popj 17,

uffs_arg:
	pushj 17,ffs
	popj 17,

ffs_local:
	pushj 17,ffs
	popj 17,

uffs_local:
	pushj 17,ffs
	popj 17,

ffs_reuse:
	pushj 17,ffs
	popj 17,

ffs_after_add:
	add 1,2
	pushj 17,ffs
	popj 17,

ffs_after_sub:
	sub 1,2
	pushj 17,ffs
	popj 17,

ffs_after_neg:
	movn 1,1
	pushj 17,ffs
	popj 17,

ffs_after_and:
	and 1,2
	pushj 17,ffs
	popj 17,

ffs_after_or:
	ior 1,2
	pushj 17,ffs
	popj 17,

ffs_after_xor:
	xor 1,2
	pushj 17,ffs
	popj 17,

ffs_after_shift_left:
	lsh 1,(2)
	pushj 17,ffs
	popj 17,

ffs_after_shift_right:
	movn 2,2
	lsh 1,(2)
	pushj 17,ffs
	popj 17,

ffs_call_value:
	pushj 17,f
	pushj 17,ffs
	popj 17,

uffs_call_value:
	pushj 17,uf
	pushj 17,ffs
	popj 17,

ffs_mem:
	move 1,(1)
	pushj 17,ffs
	popj 17,

uffs_mem:
	move 1,(1)
	pushj 17,ffs
	popj 17,

ffs_volatile_mem:
	move 1,(1)
	pushj 17,ffs
	popj 17,

uffs_volatile_mem:
	move 1,(1)
	pushj 17,ffs
	popj 17,

ffs_global:
	move 1,ffs_ga
	pushj 17,ffs
	popj 17,

ffs_global_b:
	move 1,ffs_gb
	pushj 17,ffs
	popj 17,

ffs_volatile_global:
	move 1,ffs_vga
	pushj 17,ffs
	popj 17,

uffs_global:
	move 1,uffs_ga
	pushj 17,ffs
	popj 17,

uffs_global_b:
	move 1,uffs_gb
	pushj 17,ffs
	popj 17,

uffs_volatile_global:
	move 1,uffs_vga
	pushj 17,ffs
	popj 17,

ffs_array:
	andi 1,17
	move 1,ffs_buf(1)
	pushj 17,ffs
	popj 17,

uffs_array:
	andi 1,17
	move 1,uffs_buf(1)
	pushj 17,ffs
	popj 17,

ffs_ptr_array:
	andi 2,17
	add 1,2
	move 1,(1)
	pushj 17,ffs
	popj 17,

uffs_ptr_array:
	andi 2,17
	add 1,2
	move 1,(1)
	pushj 17,ffs
	popj 17,

ffs_struct_a:
	move 1,(1)
	pushj 17,ffs
	popj 17,

ffs_struct_b:
	move 1,1(1)
	pushj 17,ffs
	popj 17,

uffs_struct_a:
	move 1,(1)
	pushj 17,ffs
	popj 17,

uffs_struct_b:
	move 1,1(1)
	pushj 17,ffs
	popj 17,

ffs_global_struct_a:
	move 1,ffs_gp
	pushj 17,ffs
	popj 17,

ffs_global_struct_b:
	move 1,ffs_gp+1
	pushj 17,ffs
	popj 17,

uffs_global_struct_a:
	move 1,uffs_gp
	pushj 17,ffs
	popj 17,

uffs_global_struct_b:
	move 1,uffs_gp+1
	pushj 17,ffs
	popj 17,

ffs_global_struct_three:
	move 1,ffs_gt+2
	pushj 17,ffs
	popj 17,

ffs_const_zero:
	movei 1,0
	popj 17,

ffs_const_one:
	movei 1,1
	popj 17,

ffs_const_two:
	movei 1,2
	popj 17,

ffs_const_four:
	movei 1,3
	popj 17,

ffs_const_400:
	movei 1,11
	popj 17,

ffs_const_1000:
	movei 1,12
	popj 17,

ffs_const_right_high:
	movei 1,22
	popj 17,

ffs_const_halfword:
	movei 1,23
	popj 17,

ffs_const_left_low:
	movei 1,42
	popj 17,

ffs_const_signbit:
	movei 1,44
	popj 17,

ffs_const_allones:
	movei 1,1
	popj 17,

ffs_const_pattern:
	movei 1,2
	popj 17,

ffs_const_minus_one:
	movei 1,1
	popj 17,

ffs_const_minus_two:
	movei 1,2
	popj 17,

ffs_const_minus_power:
	movei 1,12
	popj 17,

ffs_lowbit_0:
	iori 1,1
	pushj 17,ffs
	popj 17,

ffs_lowbit_1:
	lsh 1,1
	iori 1,2
	pushj 17,ffs
	popj 17,

ffs_lowbit_2:
	lsh 1,2
	iori 1,4
	pushj 17,ffs
	popj 17,

ffs_lowbit_8:
	lsh 1,11
	iori 1,400
	pushj 17,ffs
	popj 17,

ffs_lowbit_9:
	lsh 1,12
	iori 1,1000
	pushj 17,ffs
	popj 17,

ffs_lowbit_17:
	hrlz 1,1
	iori 1,400000
	pushj 17,ffs
	popj 17,

ffs_lowbit_18:
	lsh 1,23
	tlo 1,1
	pushj 17,ffs
	popj 17,

ffs_lowbit_35:
	lsh 1,43
	pushj 17,ffs
	popj 17,

uffs_lowbit_35:
	lsh 1,43
	pushj 17,ffs
	popj 17,

ffs_isolated:
	movn 4,1
	and 4,1
	move 1,4
	pushj 17,ffs
	popj 17,

uffs_isolated:
	movn 4,1
	and 4,1
	move 1,4
	pushj 17,ffs
	popj 17,

ffs_isolated_mem:
	movn 4,(1)
	and 4,(1)
	move 1,4
	pushj 17,ffs
	popj 17,

ffs_isolated_global:
	movn 1,ffs_ga
	and 1,ffs_ga
	pushj 17,ffs
	popj 17,

ffs_masked_low:
	hrrz 1,1
	pushj 17,ffs
	popj 17,

ffs_masked_high:
	hllz 1,1
	pushj 17,ffs
	popj 17,

ffs_masked_sign:
	and 1,[-400000000000]
	pushj 17,ffs
	popj 17,

ffs_shifted_mask:
	hrrz 1,1
	lsh 1,(2)
	pushj 17,ffs
	popj 17,

ffs_store_ptr:
	push 17,10
	move 10,1
	move 1,2
	pushj 17,ffs
	movem 1,(10)
	pop 17,10
	popj 17,

ffs_store_ptr_return:
	push 17,10
	move 10,1
	move 1,2
	pushj 17,ffs
	movem 1,(10)
	pop 17,10
	popj 17,

ffs_store_global:
	pushj 17,ffs
	movem 1,ffs_ga
	popj 17,

ffs_store_global_return:
	pushj 17,ffs
	movem 1,ffs_ga
	popj 17,

ffs_store_array:
	push 17,10
	move 10,1
	andi 10,17
	move 1,2
	pushj 17,ffs
	movem 1,ffs_buf(10)
	pop 17,10
	popj 17,

ffs_store_array_return:
	push 17,10
	move 10,1
	andi 10,17
	move 1,2
	pushj 17,ffs
	movem 1,ffs_buf(10)
	pop 17,10
	popj 17,

uffs_store_ptr:
	push 17,10
	move 10,1
	move 1,2
	pushj 17,ffs
	movem 1,(10)
	pop 17,10
	popj 17,

uffs_store_ptr_return:
	push 17,10
	move 10,1
	move 1,2
	pushj 17,ffs
	movem 1,(10)
	pop 17,10
	popj 17,

ffs_plus:
	push 17,10
	move 10,2
	pushj 17,ffs
	add 1,10
	pop 17,10
	popj 17,

ffs_minus:
	push 17,10
	move 10,2
	pushj 17,ffs
	sub 1,10
	pop 17,10
	popj 17,

ffs_mul:
	push 17,10
	move 10,2
	pushj 17,ffs
	imul 1,10
	pop 17,10
	popj 17,

ffs_xor:
	push 17,10
	move 10,2
	pushj 17,ffs
	xor 1,10
	pop 17,10
	popj 17,

ffs_or:
	push 17,10
	move 10,2
	pushj 17,ffs
	ior 1,10
	pop 17,10
	popj 17,

ffs_and:
	push 17,10
	move 10,2
	pushj 17,ffs
	and 1,10
	pop 17,10
	popj 17,

ffs_twice:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,2
	pushj 17,ffs
	move 10,1
	move 1,11
	pushj 17,ffs
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

ffs_nested:
	pushj 17,ffs
	pushj 17,ffs
	popj 17,

ffs_index_array:
	pushj 17,ffs
	andi 1,17
	move 1,ffs_buf(1)
	popj 17,

ffs_shift_result:
	pushj 17,ffs
	move 4,1
	movei 1,1
	lsh 1,(4)
	popj 17,

ffs_shift_input:
	push 17,10
	move 10,2
	lsh 1,(2)
	pushj 17,ffs
	add 1,10
	pop 17,10
	popj 17,

ffs_eq_zero:
	pushj 17,ffs
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

ffs_ne_zero:
	pushj 17,ffs
	skipe 1
	movei 1,1
	popj 17,

ffs_eq_one:
	pushj 17,ffs
	movei 6,1
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

ffs_gt_one:
	pushj 17,ffs
	movei 6,1
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

ffs_lt_18:
	pushj 17,ffs
	movei 6,21
	camle 1,6
	tdza 1,1
	movei 1,1
	popj 17,

ffs_ge_18:
	pushj 17,ffs
	movei 6,21
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

ffs_if_zero:
	pushj 17,ffs
	skipe 1
	movei 1,1
	popj 17,

ffs_if_nonzero:
	pushj 17,ffs
	skipe 1
	movei 1,1
	popj 17,

ffs_if_low:
	pushj 17,ffs
	seto 4,
	caile 1,11
	movei 4,1
	move 1,4
	popj 17,

ffs_if_high:
	pushj 17,ffs
	movei 4,1
	caig 1,22
	seto 4,
	move 1,4
	popj 17,

ffs_range:
	pushj 17,ffs
	movei 4,0
	jumpe 1,%L108
	seto 4,
	caig 1,21
	jrst %L108
	movei 4,1
	caig 1,22
	movei 4,22
%L108:
	move 1,4
	popj 17,

uffs_eq_zero:
	pushj 17,ffs
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

uffs_ne_zero:
	pushj 17,ffs
	skipe 1
	movei 1,1
	popj 17,

uffs_gt_18:
	pushj 17,ffs
	movei 6,22
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

uffs_if_highbit:
	tlo 1,400000
	pushj 17,ffs
	movei 4,1
	caig 1,22
	seto 4,
	move 1,4
	popj 17,

uffs_range:
	pushj 17,ffs
	movei 4,0
	jumpe 1,%L117
	seto 4,
	caig 1,21
	jrst %L117
	movei 4,1
	caig 1,22
	movei 4,22
%L117:
	move 1,4
	popj 17,

ffs_qi:
	lsh 1,33
	ash 1,-33
	pushj 17,ffs
	popj 17,

ffs_uqi:
	andi 1,777	; zero_extendqisi2
	pushj 17,ffs
	popj 17,

ffs_hi:
	hrre 1,1
	pushj 17,ffs
	popj 17,

ffs_uhi:
	hrrzi 1,(1)	; zero_extendhisi2
	pushj 17,ffs
	popj 17,

ffs_qi_plus:
	push 17,10
	move 10,2
	lsh 1,33
	ash 1,-33
	pushj 17,ffs
	add 1,10
	pop 17,10
	popj 17,

ffs_uqi_plus:
	push 17,10
	move 10,2
	andi 1,777	; zero_extendqisi2
	pushj 17,ffs
	add 1,10
	pop 17,10
	popj 17,

ffs_hi_plus:
	push 17,10
	move 10,2
	hrre 1,1
	pushj 17,ffs
	add 1,10
	pop 17,10
	popj 17,

ffs_uhi_plus:
	push 17,10
	move 10,2
	hrrzi 1,(1)	; zero_extendhisi2
	pushj 17,ffs
	add 1,10
	pop 17,10
	popj 17,

ffs_qi_if:
	lsh 1,33
	ash 1,-33
	pushj 17,ffs
	skipe 1
	movei 1,1
	popj 17,

ffs_hi_if:
	hrre 1,1
	pushj 17,ffs
	movei 4,1
	caig 1,11
	seto 4,
	move 1,4
	popj 17,

ffs_switch_like:
	pushj 17,ffs
	movei 4,0
	jumpe 1,%L133
	movei 4,12
	cain 1,1
	jrst %L133
	movei 4,264
	cain 1,22
	jrst %L133
	movei 4,550
	caie 1,44
	move 4,1
%L133:
	move 1,4
	popj 17,

ffs_select_value:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,2
	move 10,3
	pushj 17,ffs
	move 11,1
	move 1,12
	pushj 17,ffs
	camge 11,1
	move 10,12
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

ffs_loop_mask:
	pushj 17,ffs
	movei 4,0
	jumple 1,%L146
%L144:
	add 4,1
	sojg 1,%L144	; decrement_and_branch_until_zero
%L146:
	move 1,4
	popj 17,

ffs_after_call:
	push 17,10
	move 10,(1)
	pushj 17,clobber
	move 1,10
	pushj 17,ffs
	pop 17,10
	popj 17,

ffs_store_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,f
	move 10,1
	pushj 17,clobber
	move 1,10
	pushj 17,ffs
	movem 1,(11)
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

ffs_global_after_call:
	pushj 17,clobber
	move 1,ffs_ga
	pushj 17,ffs
	popj 17,

ffs_volatile_after_call:
	pushj 17,clobber
	move 1,ffs_vga
	pushj 17,ffs
	popj 17,

uffs_after_call:
	push 17,10
	move 10,(1)
	pushj 17,clobber
	move 1,10
	pushj 17,ffs
	pop 17,10
	popj 17,

ffs_two_calls:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	pushj 17,f
	move 10,1
	pushj 17,f
	move 11,1
	move 1,10
	pushj 17,ffs
	move 10,1
	move 1,11
	pushj 17,ffs
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

uffs_two_calls:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	pushj 17,uf
	move 10,1
	pushj 17,uf
	move 11,1
	move 1,10
	pushj 17,ffs
	move 10,1
	move 1,11
	pushj 17,ffs
	xor 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
ffs_ga:
	.space	4
ffs_gb:
	.space	4
ffs_vga:
	.space	4
ffs_buf:
	.space	64
uffs_ga:
	.space	4
uffs_gb:
	.space	4
uffs_vga:
	.space	4
uffs_buf:
	.space	64
ffs_gp:
	.space	8
uffs_gp:
	.space	8
ffs_gt:
	.space	12
