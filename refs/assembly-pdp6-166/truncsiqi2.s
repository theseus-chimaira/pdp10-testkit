
	.globl	truncsiqi2
truncsiqi2:
	lsh 1,33
	ash 1,-33
	popj 17,

truncq_arg:
	lsh 1,33
	ash 1,-33
	popj 17,

truncq_second_arg:
	lsh 2,33
	ash 2,-33
	move 1,2
	popj 17,

utruncq_arg:
	andi 1,777	; zero_extendqisi2
	popj 17,

truncq_local:
	lsh 1,33
	ash 1,-33
	popj 17,

utruncq_local:
	andi 1,777	; zero_extendqisi2
	popj 17,

truncq_reuse:
	lsh 1,33
	ash 1,-33
	popj 17,

truncq_add:
	add 1,2
	lsh 1,33
	ash 1,-33
	popj 17,

truncq_sub:
	sub 1,2
	lsh 1,33
	ash 1,-33
	popj 17,

truncq_mul:
	imul 1,2
	lsh 1,33
	ash 1,-33
	popj 17,

truncq_neg:
	movn 1,1
	lsh 1,33
	ash 1,-33
	popj 17,

truncq_xor:
	xor 1,2
	lsh 1,33
	ash 1,-33
	popj 17,

truncq_or:
	ior 1,2
	lsh 1,33
	ash 1,-33
	popj 17,

truncq_and:
	and 1,2
	lsh 1,33
	ash 1,-33
	popj 17,

truncq_shift_left:
	lsh 1,1
	lsh 1,33
	ash 1,-33
	popj 17,

truncq_shift_right:
	lsh 1,32
	ash 1,-33
	popj 17,

truncq_call:
	pushj 17,f
	lsh 1,33
	ash 1,-33
	popj 17,

utruncq_call:
	pushj 17,uf
	andi 1,777	; zero_extendqisi2
	popj 17,

truncq_const_zero:
	movei 1,0
	popj 17,

truncq_const_one:
	movei 1,1
	popj 17,

truncq_const_177:
	movei 1,177
	popj 17,

truncq_const_377:
	movei 1,377
	popj 17,

truncq_const_400:
	hrroi 1,777400
	popj 17,

truncq_const_777:
	seto 1,
	popj 17,

truncq_const_1000:
	movei 1,0
	popj 17,

truncq_const_full:
	hrroi 1,777456
	popj 17,

truncq_const_minus_one:
	seto 1,
	popj 17,

truncq_const_minus_small:
	hrroi 1,777655
	popj 17,

utruncq_const_777:
	movei 1,777
	popj 17,

utruncq_const_1000:
	movei 1,0
	popj 17,

utruncq_const_full:
	movei 1,456
	popj 17,

truncq_mem:
	move 1,(1)
	lsh 1,33
	ash 1,-33
	popj 17,

truncq_umem:
	move 1,(1)
	lsh 1,33
	ash 1,-33
	popj 17,

utruncq_umem:
	move 1,(1)
	andi 1,777
	popj 17,

truncq_volatile_mem:
	move 1,(1)
	lsh 1,33
	ash 1,-33
	popj 17,

truncq_global:
	hrre 1,truncq_ga
	popj 17,

truncq_global_b:
	hrre 1,truncq_gb
	popj 17,

truncq_volatile_global:
	hrre 1,truncq_vga
	popj 17,

utruncq_global:
	move 1,truncq_uga
	andi 1,777
	popj 17,

utruncq_volatile_global:
	move 1,truncq_vuga
	andi 1,777
	popj 17,

truncq_array:
	andi 1,17
	move 1,truncq_sbuf(1)
	lsh 1,33
	ash 1,-33
	popj 17,

truncq_uarray:
	andi 1,17
	move 1,truncq_usbuf(1)
	lsh 1,33
	ash 1,-33
	popj 17,

utruncq_uarray:
	andi 1,17
	move 1,truncq_usbuf(1)
	andi 1,777
	popj 17,

truncq_ptr_array:
	andi 2,17
	add 1,2
	move 1,(1)
	lsh 1,33
	ash 1,-33
	popj 17,

truncq_struct_a:
	move 1,(1)
	lsh 1,33
	ash 1,-33
	popj 17,

truncq_struct_b:
	move 1,1(1)
	lsh 1,33
	ash 1,-33
	popj 17,

truncq_global_struct_a:
	move 1,truncq_sgp
	lsh 1,33
	ash 1,-33
	popj 17,

truncq_global_struct_b:
	move 1,truncq_sgp+1
	lsh 1,33
	ash 1,-33
	popj 17,

truncq_store_global:
	movem 1,truncq_qa
	popj 17,

truncq_store_global_u:
	movem 1,truncq_uqa
	popj 17,

truncq_store_volatile_global:
	movem 1,truncq_vqa
	popj 17,

truncq_store_volatile_global_u:
	movem 1,truncq_vuqa
	popj 17,

truncq_store_ptr:
	dpb 2,1
	popj 17,

truncq_store_uptr:
	dpb 2,1
	popj 17,

truncq_store_array:
	andi 1,17
	move 4,[POINT 9,truncq_qbuf,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

truncq_store_uarray:
	andi 1,17
	move 4,[POINT 9,truncq_uqbuf,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

truncq_store_struct_a:
	dpb 2,[POINT 9,(1),8]
	popj 17,

truncq_store_struct_b:
	dpb 2,[POINT 9,(1),17]
	popj 17,

truncq_store_ustruct_a:
	dpb 2,[POINT 9,(1),8]
	popj 17,

truncq_store_ustruct_b:
	dpb 2,[POINT 9,(1),17]
	popj 17,

truncq_store_global_return:
	movem 1,truncq_qa
	lsh 1,33
	ash 1,-33
	popj 17,

truncq_store_global_u_return:
	movem 1,truncq_uqa
	andi 1,777
	popj 17,

truncq_store_ptr_return:
	dpb 2,1
	lsh 2,33
	ash 2,-33
	move 1,2
	popj 17,

truncq_store_uptr_return:
	dpb 2,1
	andi 2,777
	move 1,2
	popj 17,

truncq_store_array_return:
	andi 1,17
	move 4,[POINT 9,truncq_qbuf,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	lsh 2,33
	ash 2,-33
	move 1,2
	popj 17,

truncq_store_uarray_return:
	andi 1,17
	move 4,[POINT 9,truncq_uqbuf,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	andi 2,777
	move 1,2
	popj 17,

truncq_to_sint:
	lsh 1,33
	ash 1,-33
	popj 17,

utruncq_to_usint:
	andi 1,777	; zero_extendqisi2
	popj 17,

truncq_add_to_sint:
	add 1,2
	lsh 1,33
	ash 1,-33
	popj 17,

utruncq_add_to_usint:
	add 1,2
	andi 1,777	; zero_extendqisi2
	popj 17,

truncq_mask_then_sint:
	lsh 1,33
	ash 1,-33
	popj 17,

truncq_full_then_sint:
	eqvi 1,321
	lsh 1,33
	ash 1,-33
	popj 17,

utruncq_full_then_usint:
	eqvi 1,321
	andi 1,777	; zero_extendqisi2
	popj 17,

truncq_inc_global:
	ldb 6,[POINT 18,truncq_qa,35]
	add 1,6
	movem 1,truncq_qa
	popj 17,

truncq_inc_global_return:
	ldb 6,[POINT 18,truncq_qa,35]
	add 1,6
	movem 1,truncq_qa
	lsh 1,33
	ash 1,-33
	popj 17,

truncq_sub_global:
	ldb 6,[POINT 18,truncq_qa,35]
	sub 6,1
	movem 6,truncq_qa
	popj 17,

truncq_sub_global_return:
	ldb 6,[POINT 18,truncq_qa,35]
	sub 6,1
	movem 6,truncq_qa
	move 1,6
	lsh 1,33
	ash 1,-33
	popj 17,

truncq_xor_global:
	ldb 6,[POINT 18,truncq_qa,35]
	xor 1,6
	movem 1,truncq_qa
	popj 17,

truncq_xor_global_return:
	ldb 6,[POINT 18,truncq_qa,35]
	xor 1,6
	movem 1,truncq_qa
	lsh 1,33
	ash 1,-33
	popj 17,

truncq_inc_ptr:
	ldb 6,1
	add 2,6
	dpb 2,1
	popj 17,

truncq_inc_ptr_return:
	ldb 6,1
	add 2,6
	dpb 2,1
	lsh 2,33
	ash 2,-33
	move 1,2
	popj 17,

truncq_inc_array:
	andi 1,17
	move 3,[POINT 9,truncq_qbuf,8]
	move 0,1
	jumple 0,.+3
	ibp 3
	sojg 0,.-1
	ldb 4,3
	add 2,4
	dpb 2,3
	popj 17,

truncq_inc_array_return:
	andi 1,17
	move 3,[POINT 9,truncq_qbuf,8]
	move 0,1
	jumple 0,.+3
	ibp 3
	sojg 0,.-1
	ldb 4,3
	add 2,4
	dpb 2,3
	lsh 2,33
	ash 2,-33
	move 1,2
	popj 17,

truncq_eq_zero:
	lsh 1,33
	ash 1,-33
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

truncq_ne_zero:
	lsh 1,33
	ash 1,-33
	skipe 1
	movei 1,1
	popj 17,

truncq_lt_zero:
	ldb 1,[POINT 1,1,27]
	popj 17,

truncq_ge_zero:
	lsh 1,33
	ash 1,-33
	skipge 1
	tdza 1,1
	movei 1,1
	popj 17,

truncq_eq_177:
	lsh 1,33
	ash 1,-33
	movei 6,177
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

truncq_eq_minus_one:
	lsh 1,33
	ash 1,-33
	seto 6,
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

utruncq_gt_400:
	andi 1,777	; zero_extendqisi2
	tlc 1,400000
	move 6,[-377777777400]
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

truncq_range:
	lsh 1,33
	ash 1,-33
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

truncq_after_call:
	push 17,10
	move 10,(1)
	pushj 17,clobber
	lsh 10,33
	ash 10,-33
	move 1,10
	pop 17,10
	popj 17,

truncq_call_after_load:
	push 17,10
	move 10,(1)
	pushj 17,clobber
	pushj 17,f
	add 10,1
	lsh 10,33
	ash 10,-33
	move 1,10
	pop 17,10
	popj 17,

truncq_store_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,f
	move 10,1
	pushj 17,clobber
	dpb 10,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

truncq_global_after_call:
	pushj 17,clobber
	hrre 1,truncq_ga
	popj 17,

	.bss
truncq_ga:
	.space	4
truncq_gb:
	.space	4
truncq_vga:
	.space	4
truncq_sbuf:
	.space	64
truncq_uga:
	.space	4
truncq_vuga:
	.space	4
truncq_usbuf:
	.space	64
truncq_qa:
	.space	4
truncq_qb:
	.space	4
truncq_vqa:
	.space	4
truncq_qbuf:
	.space	16
truncq_uqa:
	.space	4
truncq_vuqa:
	.space	4
truncq_uqbuf:
	.space	16
truncq_gp:
	.space	4
truncq_ugp:
	.space	4
truncq_sgp:
	.space	8
