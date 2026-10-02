
	.globl	extendqisi2
extendqisi2:
	lsh 1,33
	ash 1,-33
	popj 17,

extqisi_arg:
	lsh 1,33
	ash 1,-33
	popj 17,

extqisi_second_arg:
	lsh 2,33
	ash 2,-33
	move 1,2
	popj 17,

extqisi_local:
	lsh 1,33
	ash 1,-33
	popj 17,

extqisi_reuse:
	lsh 1,33
	ash 1,-33
	popj 17,

extqisi_plus:
	lsh 1,33
	ash 1,-33
	add 1,2
	popj 17,

extqisi_minus:
	lsh 1,33
	ash 1,-33
	sub 1,2
	popj 17,

extqisi_xor:
	lsh 1,33
	ash 1,-33
	xor 1,2
	popj 17,

extqisi_or:
	lsh 1,33
	ash 1,-33
	ior 1,2
	popj 17,

extqisi_and:
	lsh 1,33
	ash 1,-33
	and 1,2
	popj 17,

extqisi_shift_left:
	lsh 1,33
	ash 1,-33
	lsh 1,1
	popj 17,

extqisi_shift_right:
	lsh 1,33
	ash 1,-34
	popj 17,

extqisi_neg:
	lsh 1,33
	ash 1,-33
	movn 1,1
	popj 17,

extqisi_mem:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

extqisi_mem_local:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

extqisi_mem_plus:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	add 1,2
	popj 17,

extqisi_mem_xor:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	xor 1,2
	popj 17,

extqisi_volatile_mem:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

extqisi_volatile_mem_local:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

extqisi_global:
	hrre 1,extqisi_ga
	popj 17,

extqisi_global_b:
	hrre 1,extqisi_gb
	popj 17,

extqisi_volatile_global:
	hrre 1,extqisi_vga
	popj 17,

extqisi_global_after_call:
	pushj 17,qfunc
	movem 1,extqisi_ga
	pushj 17,clobber
	hrre 1,extqisi_ga
	popj 17,

extqisi_array:
	move 4,1
	andi 4,3
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,extqisi_buf,8]
	jumpe 4,%L26
%L25:
	ibp 1
	sojn 4,%L25	; decrement_and_branch_until_zero
%L26:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

extqisi_array_local:
	move 4,1
	andi 4,3
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,extqisi_buf,8]
	jumpe 4,%L29
%L28:
	ibp 1
	sojn 4,%L28	; decrement_and_branch_until_zero
%L29:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

extqisi_array_plus:
	move 4,1
	andi 4,3
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,extqisi_buf,8]
	jumpe 4,%L32
%L31:
	ibp 1
	sojn 4,%L31	; decrement_and_branch_until_zero
%L32:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	add 1,2
	popj 17,

extqisi_ptr_array:
	move 4,2
	andi 4,3
	andi 2,17
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L36
%L35:
	ibp 1
	sojn 4,%L35	; decrement_and_branch_until_zero
%L36:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

extqisi_struct_a:
	move 1,(1)
	ash 1,-33
	popj 17,

extqisi_struct_b:
	move 1,(1)
	lsh 1,11
	ash 1,-33
	popj 17,

extqisi_struct_two:
	move 4,1
	move 1,(1)
	ash 1,-33
	move 4,(4)
	lsh 4,11
	ash 4,-33
	add 1,4
	popj 17,

extqisi_struct_index:
	trnn 2,1
	jrst %L41
	move 1,(1)
	lsh 1,11
	ash 1,-33
%L40:
	popj 17,
%L41:
	move 1,(1)
	lsh 1,22
	ash 1,-33
	popj 17,

extqisi_global_struct_a:
	move 1,extqisi_gp
	ash 1,-33
	popj 17,

extqisi_global_struct_b:
	move 1,extqisi_gp
	lsh 1,11
	ash 1,-33
	popj 17,

extqisi_global_struct_c:
	move 1,extqisi_gt
	lsh 1,22
	ash 1,-33
	popj 17,

extqisi_store_global:
	movem 1,extqisi_sga
	popj 17,

extqisi_store_volatile_global:
	movem 1,extqisi_vsga
	popj 17,

extqisi_store_ptr:
	lsh 2,33
	ash 2,-33
	movem 2,(1)
	popj 17,

extqisi_store_array:
	andi 1,17
	lsh 2,33
	ash 2,-33
	movem 2,extqisi_sbuf(1)
	popj 17,

extqisi_store_from_mem:
	ldb 4,2
	trne 4,400
	orcmi 4,777
	movem 4,(1)
	popj 17,

extqisi_store_from_volatile:
	ldb 4,2
	trne 4,400
	orcmi 4,777
	movem 4,(1)
	popj 17,

extqisi_const_zero:
	movei 1,0
	popj 17,

extqisi_const_one:
	movei 1,1
	popj 17,

extqisi_const_177:
	movei 1,177
	popj 17,

extqisi_const_377:
	movei 1,377
	popj 17,

extqisi_const_400:
	hrroi 1,777400
	popj 17,

extqisi_const_777:
	seto 1,
	popj 17,

extqisi_const_minus_one:
	seto 1,
	popj 17,

extqisi_const_minus_small:
	hrroi 1,777655
	popj 17,

extqisi_from_sint:
	lsh 1,33
	ash 1,-33
	popj 17,

extqisi_from_uint:
	lsh 1,33
	ash 1,-33
	popj 17,

extqisi_from_sint_plus:
	add 1,2
	lsh 1,33
	ash 1,-33
	popj 17,

extqisi_from_negative:
	movn 1,1
	lsh 1,33
	ash 1,-33
	popj 17,

extqisi_from_uq_arg:
	lsh 1,33
	ash 1,-33
	popj 17,

extqisi_from_uq_mem:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

extqisi_from_uq_global:
	hrre 1,extqisi_uga
	popj 17,

extqisi_from_uq_array:
	move 4,1
	andi 4,3
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,extqisi_ubuf,8]
	jumpe 4,%L68
%L67:
	ibp 1
	sojn 4,%L67	; decrement_and_branch_until_zero
%L68:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

extqisi_from_uq_struct:
	move 1,(1)
	lsh 1,11
	ash 1,-33
	popj 17,

extqisi_from_mask:
	lsh 1,33
	ash 1,-33
	popj 17,

extqisi_from_mask_plus:
	addi 1,123
	lsh 1,33
	ash 1,-33
	popj 17,

extqisi_from_call:
	pushj 17,qfunc
	lsh 1,33
	ash 1,-33
	popj 17,

extqisi_from_uq_call:
	pushj 17,uqfunc
	lsh 1,33
	ash 1,-33
	popj 17,

extqisi_eq_zero:
	lsh 1,33
	ash 1,-33
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

extqisi_ne_zero:
	lsh 1,33
	ash 1,-33
	skipe 1
	movei 1,1
	popj 17,

extqisi_lt_zero:
	ldb 1,[POINT 1,1,27]
	popj 17,

extqisi_ge_zero:
	lsh 1,33
	ash 1,-33
	skipge 1
	tdza 1,1
	movei 1,1
	popj 17,

extqisi_lt_200:
	lsh 1,33
	ash 1,-33
	movei 6,177
	camle 1,6
	tdza 1,1
	movei 1,1
	popj 17,

extqisi_gt_200:
	lsh 1,33
	ash 1,-33
	movei 6,200
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

extqisi_mem_eq:
	ldb 1,1
	movei 6,777
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

extqisi_mem_range:
	ldb 4,1
	trne 4,400
	orcmi 4,777
	seto 1,
	camge 4,[-100]
	popj 17,
	movei 6,100
	camg 4,6
	tdza 1,1
	movei 1,1
	popj 17,

extqisi_sum3:
	lsh 1,33
	ash 1,-33
	lsh 2,33
	ash 2,-33
	lsh 3,33
	ash 3,-33
	add 1,2
	add 1,3
	popj 17,

extqisi_sum_mem3:
	ldb 4,1
	trne 4,400
	orcmi 4,777
	ildb 2,1
	trne 2,400
	orcmi 2,777
	ildb 3,1
	trne 3,400
	orcmi 3,777
	add 4,2
	add 4,3
	move 1,4
	popj 17,

extqisi_mix:
	lsh 1,33
	ash 1,-33
	move 4,3
	andi 4,17
	move 6,3
	andi 6,3
	ash 4,-2	; ashrsi3_pointer
	add 2,4
	jumpe 6,%L89
%L88:
	ibp 2
	sojn 6,%L88	; decrement_and_branch_until_zero
%L89:
	ldb 2,2
	trne 2,400
	orcmi 2,777
	move 4,3
	aos 6,4
	andi 6,3
	move 3,4
	andi 3,17
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,extqisi_buf,8]
	jumpe 6,%L91
%L90:
	ibp 3
	sojn 6,%L90	; decrement_and_branch_until_zero
%L91:
	ldb 4,3
	trne 4,400
	orcmi 4,777
	lsh 1,2
	add 2,4
	xor 1,2
	popj 17,

extqisi_unsigned_mix:
	andi 1,777	; zero_extendqisi2
	move 4,3
	andi 4,17
	move 6,3
	andi 6,3
	ash 4,-2	; ashrsi3_pointer
	add 2,4
	jumpe 6,%L95
%L94:
	ibp 2
	sojn 6,%L94	; decrement_and_branch_until_zero
%L95:
	ldb 2,2
	move 4,3
	aos 6,4
	andi 6,3
	move 3,4
	andi 3,17
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,extqisi_ubuf,8]
	jumpe 6,%L97
%L96:
	ibp 3
	sojn 6,%L96	; decrement_and_branch_until_zero
%L97:
	lsh 1,33
	ash 1,-33
	move 4,2
	lsh 4,33
	ash 4,-33
	ldb 3,3
	trne 3,400
	orcmi 3,777
	add 1,4
	sub 1,3
	popj 17,

extqisi_store_then_use:
	andi 2,777	; zero_extendqisi2
	dpb 2,1
	lsh 2,33
	ash 2,-33
	move 1,2
	popj 17,

extqisi_call_local:
	pushj 17,qfunc
	lsh 1,33
	ash 1,-33
	popj 17,

	.bss
extqisi_ga:
	.space	4
extqisi_gb:
	.space	4
extqisi_vga:
	.space	4
extqisi_buf:
	.space	16
extqisi_sga:
	.space	4
extqisi_vsga:
	.space	4
extqisi_sbuf:
	.space	64
extqisi_uga:
	.space	4
extqisi_ubuf:
	.space	16
extqisi_gp:
	.space	4
extqisi_gt:
	.space	4
extqisi_ugp:
	.space	4
