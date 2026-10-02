
	.globl	extendhisi2
extendhisi2:
	hrre 1,1
	popj 17,

exthisi_arg:
	hrre 1,1
	popj 17,

exthisi_second_arg:
	hrre 2,2
	move 1,2
	popj 17,

exthisi_local:
	hrre 1,1
	popj 17,

exthisi_reuse:
	hrre 1,1
	popj 17,

exthisi_plus:
	hrre 1,1
	add 1,2
	popj 17,

exthisi_minus:
	hrre 1,1
	sub 1,2
	popj 17,

exthisi_xor:
	hrre 1,1
	xor 1,2
	popj 17,

exthisi_or:
	hrre 1,1
	ior 1,2
	popj 17,

exthisi_and:
	hrre 1,1
	and 1,2
	popj 17,

exthisi_shift_left:
	hrre 1,1
	lsh 1,1
	popj 17,

exthisi_shift_right:
	lsh 1,22
	ash 1,-23
	popj 17,

exthisi_neg:
	hrre 1,1
	movn 1,1
	popj 17,

exthisi_mem:
	ldb 1,1
	hrre 1,1
	popj 17,

exthisi_mem_local:
	ldb 1,1
	hrre 1,1
	popj 17,

exthisi_mem_plus:
	ldb 1,1
	hrre 1,1
	add 1,2
	popj 17,

exthisi_mem_xor:
	ldb 1,1
	hrre 1,1
	xor 1,2
	popj 17,

exthisi_volatile_mem:
	ldb 1,1
	hrre 1,1
	popj 17,

exthisi_volatile_mem_local:
	ldb 1,1
	hrre 1,1
	popj 17,

exthisi_global:
	hrre 1,exthisi_ga
	popj 17,

exthisi_global_b:
	hrre 1,exthisi_gb
	popj 17,

exthisi_volatile_global:
	hrre 1,exthisi_vga
	popj 17,

exthisi_global_after_call:
	pushj 17,hfunc
	movem 1,exthisi_ga
	pushj 17,clobber
	hrre 1,exthisi_ga
	popj 17,

exthisi_array:
	andi 1,17
	move 4,[POINT 18,exthisi_buf,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	hrre 1,1
	popj 17,

exthisi_array_local:
	andi 1,17
	move 4,[POINT 18,exthisi_buf,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	hrre 1,1
	popj 17,

exthisi_array_plus:
	andi 1,17
	move 4,[POINT 18,exthisi_buf,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	hrre 1,1
	add 1,2
	popj 17,

exthisi_ptr_array:
	move 4,2
	andi 4,1
	andi 2,17
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L30
%L29:
	ibp 1
	sojn 4,%L29	; decrement_and_branch_until_zero
%L30:
	ldb 1,1
	hrre 1,1
	popj 17,

exthisi_struct_a:
	hlre 1,(1)
	popj 17,

exthisi_struct_b:
	hrre 1,(1)
	popj 17,

exthisi_struct_two:
	move 4,1
	hlre 1,(1)
	hrre 4,(4)
	add 1,4
	popj 17,

exthisi_struct_index:
	trnn 2,1
	jrst %L35
	hrre 1,(1)
%L34:
	popj 17,
%L35:
	hlre 1,1(1)
	popj 17,

exthisi_global_struct_a:
	hlre 1,exthisi_gp
	popj 17,

exthisi_global_struct_b:
	hrre 1,exthisi_gp
	popj 17,

exthisi_global_struct_c:
	hlre 1,exthisi_gt+1
	popj 17,

exthisi_store_global:
	hrre 1,1
	movem 1,exthisi_sga
	popj 17,

exthisi_store_volatile_global:
	hrre 1,1
	movem 1,exthisi_vsga
	popj 17,

exthisi_store_ptr:
	hrre 2,2
	movem 2,(1)
	popj 17,

exthisi_store_array:
	andi 1,17
	hrre 2,2
	movem 2,exthisi_sbuf(1)
	popj 17,

exthisi_store_from_mem:
	ldb 2,2
	hrrem 2,(1)
	popj 17,

exthisi_store_from_volatile:
	ldb 4,2
	hrre 4,4
	movem 4,(1)
	popj 17,

exthisi_const_zero:
	movei 1,0
	popj 17,

exthisi_const_one:
	movei 1,1
	popj 17,

exthisi_const_177777:
	movei 1,177777
	popj 17,

exthisi_const_377777:
	movei 1,377777
	popj 17,

exthisi_const_400000:
	hrroi 1,400000
	popj 17,

exthisi_const_777777:
	seto 1,
	popj 17,

exthisi_const_minus_one:
	seto 1,
	popj 17,

exthisi_const_minus_small:
	hrroi 1,765433
	popj 17,

exthisi_from_sint:
	hrre 1,1
	popj 17,

exthisi_from_uint:
	hrre 1,1
	popj 17,

exthisi_from_sint_plus:
	add 1,2
	hrre 1,1
	popj 17,

exthisi_from_negative:
	movn 1,1
	hrre 1,1
	popj 17,

exthisi_from_uh_arg:
	hrre 1,1
	popj 17,

exthisi_from_uh_mem:
	ldb 1,1
	hrre 1,1
	popj 17,

exthisi_from_uh_global:
	hrre 1,exthisi_uga
	popj 17,

exthisi_from_uh_array:
	andi 1,17
	move 4,[POINT 18,exthisi_ubuf,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	hrre 1,1
	popj 17,

exthisi_from_uh_struct:
	hrre 1,(1)
	popj 17,

exthisi_from_mask:
	hrre 1,1
	popj 17,

exthisi_from_mask_plus:
	movei 1,123(1)
	hrre 1,1	; extendhisi2
	popj 17,

exthisi_from_call:
	pushj 17,hfunc
	hrre 1,1	; extendhisi2
	popj 17,

exthisi_from_uh_call:
	pushj 17,uhfunc
	hrre 1,1	; extendhisi2
	popj 17,

exthisi_eq_zero:
	hrre 1,1
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

exthisi_ne_zero:
	hrre 1,1
	skipe 1
	movei 1,1
	popj 17,

exthisi_lt_zero:
	ldb 1,[POINT 1,1,18]
	popj 17,

exthisi_ge_zero:
	hrre 1,1
	skipge 1
	tdza 1,1
	movei 1,1
	popj 17,

exthisi_lt_200000:
	hrre 1,1
	movei 6,177777
	camle 1,6
	tdza 1,1
	movei 1,1
	popj 17,

exthisi_gt_200000:
	hrre 1,1
	movei 6,200000
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

exthisi_mem_eq:
	ldb 1,1
	movei 6,777777
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

exthisi_mem_range:
	ldb 4,1
	hrre 4,4
	seto 1,
	camge 4,[-100]
	popj 17,
	movei 6,100
	camg 4,6
	tdza 1,1
	movei 1,1
	popj 17,

exthisi_sum3:
	hrre 1,1
	hrre 2,2
	hrre 3,3
	add 1,2
	add 1,3
	popj 17,

exthisi_sum_mem3:
	ldb 3,1
	hrre 3,3
	move 4,1
	ibp 4
	ldb 2,4
	hrre 2,2
	addi 1,1
	ldb 4,1
	hrre 4,4
	add 3,2
	add 3,4
	move 1,3
	popj 17,

exthisi_mix:
	hrre 1,1
	move 4,3
	andi 4,17
	move 6,3
	andi 6,1
	ash 4,-1	; ashrsi3_pointer
	add 2,4
	jumpe 6,%L81
%L80:
	ibp 2
	sojn 6,%L80	; decrement_and_branch_until_zero
%L81:
	ldb 4,2
	hrre 4,4
	addi 3,1
	andi 3,17
	move 6,[POINT 18,exthisi_buf,17]
	move 0,3
	jumple 0,.+3
	ibp 6
	sojg 0,.-1
	ldb 3,6
	hrre 3,3
	lsh 1,2
	add 4,3
	xor 1,4
	popj 17,

exthisi_unsigned_mix:
	hrrzi 1,(1)	; zero_extendhisi2
	move 4,3
	andi 4,17
	move 6,3
	andi 6,1
	ash 4,-1	; ashrsi3_pointer
	add 2,4
	jumpe 6,%L85
%L84:
	ibp 2
	sojn 6,%L84	; decrement_and_branch_until_zero
%L85:
	addi 3,1
	andi 3,17
	move 6,[POINT 18,exthisi_ubuf,17]
	move 0,3
	jumple 0,.+3
	ibp 6
	sojg 0,.-1
	hrre 1,1	; extendhisi2
	ldb 4,2
	hrre 4,4
	ldb 3,6
	hrre 3,3
	add 1,4
	sub 1,3
	popj 17,

exthisi_store_then_use:
	hrrzi 2,(2)	; zero_extendhisi2
	dpb 2,1	; movhi
	hrre 2,2
	move 1,2
	popj 17,

exthisi_call_local:
	pushj 17,hfunc
	hrre 1,1	; extendhisi2
	popj 17,

	.bss
exthisi_ga:
	.space	4
exthisi_gb:
	.space	4
exthisi_vga:
	.space	4
exthisi_buf:
	.space	32
exthisi_sga:
	.space	4
exthisi_vsga:
	.space	4
exthisi_sbuf:
	.space	64
exthisi_uga:
	.space	4
exthisi_ubuf:
	.space	32
exthisi_gp:
	.space	4
exthisi_gt:
	.space	8
exthisi_ugp:
	.space	4
