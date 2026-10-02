
	.globl	truncsihi2
truncsihi2:
	hrre 1,1
	popj 17,

trunch_arg:
	hrre 1,1	; extendhisi2
	popj 17,

trunch_second_arg:
	hrre 2,2	; extendhisi2
	move 1,2
	popj 17,

utrunch_arg:
	hrrzi 1,(1)	; zero_extendhisi2
	popj 17,

trunch_local:
	hrre 1,1
	popj 17,

utrunch_local:
	hrrzi 1,(1)	; zero_extendhisi2
	popj 17,

trunch_reuse:
	hrre 1,1
	popj 17,

trunch_add:
	add 1,2
	hrre 1,1
	popj 17,

trunch_sub:
	sub 1,2
	hrre 1,1
	popj 17,

trunch_mul:
	imul 1,2
	hrre 1,1
	popj 17,

trunch_neg:
	movn 1,1
	hrre 1,1
	popj 17,

trunch_xor:
	xor 1,2
	hrre 1,1
	popj 17,

trunch_or:
	ior 1,2
	hrre 1,1
	popj 17,

trunch_and:
	and 1,2
	hrre 1,1
	popj 17,

trunch_shift_left:
	lsh 1,1
	hrre 1,1
	popj 17,

trunch_shift_right:
	lsh 1,21
	ash 1,-22
	popj 17,

trunch_call:
	pushj 17,f
	hrre 1,1
	popj 17,

utrunch_call:
	pushj 17,uf
	hrrzi 1,(1)	; zero_extendhisi2
	popj 17,

trunch_const_zero:
	movei 1,0
	popj 17,

trunch_const_one:
	movei 1,1
	popj 17,

trunch_const_177777:
	movei 1,177777
	popj 17,

trunch_const_377777:
	movei 1,377777
	popj 17,

trunch_const_400000:
	hrroi 1,400000
	popj 17,

trunch_const_777777:
	seto 1,
	popj 17,

trunch_const_1000000:
	movei 1,0
	popj 17,

trunch_const_full:
	movei 1,123456
	popj 17,

trunch_const_minus_one:
	seto 1,
	popj 17,

trunch_const_minus_small:
	hrroi 1,765433
	popj 17,

utrunch_const_777777:
	movei 1,777777
	popj 17,

utrunch_const_1000000:
	movei 1,0
	popj 17,

utrunch_const_full:
	movei 1,123456
	popj 17,

trunch_mem:
	hrre 1,(1)
	popj 17,

trunch_umem:
	hrre 1,(1)
	popj 17,

utrunch_umem:
	hrrz 1,(1)
	popj 17,

trunch_volatile_mem:
	move 1,(1)
	hrre 1,1
	popj 17,

trunch_global:
	hrre 1,trunch_ga
	popj 17,

trunch_global_b:
	hrre 1,trunch_gb
	popj 17,

trunch_volatile_global:
	hrre 1,trunch_vga
	popj 17,

utrunch_global:
	hrrz 1,trunch_uga
	popj 17,

utrunch_volatile_global:
	move 1,trunch_vuga
	hrrz 1,1
	popj 17,

trunch_array:
	andi 1,17
	hrre 1,trunch_sbuf(1)
	popj 17,

trunch_uarray:
	andi 1,17
	hrre 1,trunch_usbuf(1)
	popj 17,

utrunch_uarray:
	andi 1,17
	hrrz 1,trunch_usbuf(1)
	popj 17,

trunch_ptr_array:
	andi 2,17
	add 1,2
	hrre 1,(1)
	popj 17,

trunch_struct_a:
	hrre 1,(1)
	popj 17,

trunch_struct_b:
	hrre 1,1(1)
	popj 17,

trunch_global_struct_a:
	hrre 1,trunch_sgp
	popj 17,

trunch_global_struct_b:
	hrre 1,trunch_sgp+1
	popj 17,

trunch_store_global:
	movem 1,trunch_ha
	popj 17,

trunch_store_global_u:
	movem 1,trunch_uha
	popj 17,

trunch_store_volatile_global:
	movem 1,trunch_vha
	popj 17,

trunch_store_volatile_global_u:
	movem 1,trunch_vuha
	popj 17,

trunch_store_ptr:
	dpb 2,1	; movhi
	popj 17,

trunch_store_uptr:
	dpb 2,1	; movhi
	popj 17,

trunch_store_array:
	move 4,1
	andi 4,1
	andi 1,17
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,trunch_hbuf,17]
	jumpe 4,%L58
%L57:
	ibp 1
	sojn 4,%L57	; decrement_and_branch_until_zero
%L58:
	dpb 2,1	; movhi
	popj 17,

trunch_store_uarray:
	move 4,1
	andi 4,1
	andi 1,17
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,trunch_uhbuf,17]
	jumpe 4,%L61
%L60:
	ibp 1
	sojn 4,%L60	; decrement_and_branch_until_zero
%L61:
	dpb 2,1	; movhi
	popj 17,

trunch_store_struct_a:
	hrlm 2,(1)
	popj 17,

trunch_store_struct_b:
	hrrm 2,(1)
	popj 17,

trunch_store_ustruct_a:
	hrlm 2,(1)
	popj 17,

trunch_store_ustruct_b:
	hrrm 2,(1)
	popj 17,

trunch_store_global_return:
	movem 1,trunch_ha
	hrre 1,1
	popj 17,

trunch_store_global_u_return:
	movem 1,trunch_uha
	hrrz 1,1
	popj 17,

trunch_store_ptr_return:
	dpb 2,1	; movhi
	hrre 2,2
	move 1,2
	popj 17,

trunch_store_uptr_return:
	dpb 2,1	; movhi
	hrrz 2,2
	move 1,2
	popj 17,

trunch_store_array_return:
	move 4,1
	andi 4,1
	andi 1,17
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,trunch_hbuf,17]
	jumpe 4,%L72
%L71:
	ibp 1
	sojn 4,%L71	; decrement_and_branch_until_zero
%L72:
	dpb 2,1	; movhi
	hrre 1,2
	popj 17,

trunch_store_uarray_return:
	move 4,1
	andi 4,1
	andi 1,17
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,trunch_uhbuf,17]
	jumpe 4,%L75
%L74:
	ibp 1
	sojn 4,%L74	; decrement_and_branch_until_zero
%L75:
	dpb 2,1	; movhi
	hrrz 1,2
	popj 17,

trunch_to_sint:
	hrre 1,1
	popj 17,

utrunch_to_usint:
	hrrzi 1,(1)	; zero_extendhisi2
	popj 17,

trunch_add_to_sint:
	add 1,2
	hrre 1,1
	popj 17,

utrunch_add_to_usint:
	add 1,2
	hrrzi 1,(1)	; zero_extendhisi2
	popj 17,

trunch_mask_then_sint:
	hrre 1,1
	popj 17,

trunch_full_then_sint:
	xori 1,123456
	hrre 1,1
	popj 17,

utrunch_full_then_usint:
	xori 1,123456
	hrrzi 1,(1)	; zero_extendhisi2
	popj 17,

trunch_inc_global:
	hlrz 6,trunch_ha
	add 1,6
	movem 1,trunch_ha
	popj 17,

trunch_inc_global_return:
	hlrz 6,trunch_ha
	add 1,6
	movem 1,trunch_ha
	hrre 1,1
	popj 17,

trunch_sub_global:
	hlrz 6,trunch_ha
	sub 6,1
	movem 6,trunch_ha
	popj 17,

trunch_sub_global_return:
	hlrz 6,trunch_ha
	sub 6,1
	movem 6,trunch_ha
	hrre 1,6
	popj 17,

trunch_xor_global:
	hlrz 6,trunch_ha
	xor 1,6
	movem 1,trunch_ha
	popj 17,

trunch_xor_global_return:
	hlrz 6,trunch_ha
	xor 1,6
	movem 1,trunch_ha
	hrre 1,1
	popj 17,

trunch_inc_ptr:
	ldb 6,1
	add 2,6
	dpb 2,1	; movhi
	popj 17,

trunch_inc_ptr_return:
	ldb 6,1
	add 2,6
	dpb 2,1	; movhi
	hrre 2,2
	move 1,2
	popj 17,

trunch_inc_array:
	move 7,1
	andi 7,17
	move 6,1
	andi 6,1
	move 4,6
	move 3,7
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,trunch_hbuf,17]
	jumpe 6,%L93
%L92:
	ibp 3
	sojn 4,%L92	; decrement_and_branch_until_zero
%L93:
	move 1,7
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,trunch_hbuf,17]
	skipn 4,6
	jrst %L95
%L94:
	ibp 1
	sojn 4,%L94	; decrement_and_branch_until_zero
%L95:
	ldb 1,1
	add 2,1
	dpb 2,3	; movhi
	popj 17,

trunch_inc_array_return:
	move 7,1
	andi 7,17
	move 6,1
	andi 6,1
	move 4,6
	move 3,7
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,trunch_hbuf,17]
	jumpe 6,%L98
%L97:
	ibp 3
	sojn 4,%L97	; decrement_and_branch_until_zero
%L98:
	move 1,7
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,trunch_hbuf,17]
	skipn 4,6
	jrst %L100
%L99:
	ibp 1
	sojn 4,%L99	; decrement_and_branch_until_zero
%L100:
	ldb 1,1
	add 1,2
	dpb 1,3	; movhi
	hrre 1,1
	popj 17,

trunch_eq_zero:
	hrre 1,1
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

trunch_ne_zero:
	hrre 1,1
	skipe 1
	movei 1,1
	popj 17,

trunch_lt_zero:
	ldb 1,[POINT 1,1,18]
	popj 17,

trunch_ge_zero:
	hrre 1,1
	skipge 1
	tdza 1,1
	movei 1,1
	popj 17,

trunch_eq_177777:
	hrre 1,1
	movei 6,177777
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

trunch_eq_minus_one:
	hrre 1,1
	seto 6,
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

utrunch_gt_400000:
	hrrzi 1,(1)	; zero_extendhisi2
	tlc 1,400000
	move 6,[-377777400000]
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

trunch_range:
	hrre 1,1
	seto 4,
	camge 1,[-100]
	jrst %L108
	movei 6,100
	camg 1,6
	tdza 4,4
	movei 4,1
%L108:
	move 1,4
	popj 17,

trunch_after_call:
	push 17,10
	move 10,(1)
	pushj 17,clobber
	hrre 10,10
	move 1,10
	pop 17,10
	popj 17,

trunch_call_after_load:
	push 17,10
	move 10,(1)
	pushj 17,clobber
	pushj 17,f
	add 10,1
	hrre 10,10
	move 1,10
	pop 17,10
	popj 17,

trunch_store_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,f
	move 10,1
	pushj 17,clobber
	dpb 10,11	; movhi
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

trunch_global_after_call:
	pushj 17,clobber
	hrre 1,trunch_ga
	popj 17,

	.bss
trunch_ga:
	.space	4
trunch_gb:
	.space	4
trunch_vga:
	.space	4
trunch_sbuf:
	.space	64
trunch_uga:
	.space	4
trunch_vuga:
	.space	4
trunch_usbuf:
	.space	64
trunch_ha:
	.space	4
trunch_hb:
	.space	4
trunch_vha:
	.space	4
trunch_hbuf:
	.space	32
trunch_uha:
	.space	4
trunch_vuha:
	.space	4
trunch_uhbuf:
	.space	32
trunch_gp:
	.space	4
trunch_ugp:
	.space	4
trunch_sgp:
	.space	8
