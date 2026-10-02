
	.globl	zero_extendqisi2
zero_extendqisi2:
	andi 1,777	; zero_extendqisi2
	popj 17,

zxqisi_arg:
	andi 1,777	; zero_extendqisi2
	popj 17,

zxqisi_second_arg:
	andi 2,777	; zero_extendqisi2
	move 1,2
	popj 17,

zxqisi_local:
	andi 1,777	; zero_extendqisi2
	popj 17,

zxqisi_reuse:
	andi 1,777	; zero_extendqisi2
	popj 17,

zxqisi_plus:
	andi 1,777	; zero_extendqisi2
	add 1,2
	popj 17,

zxqisi_minus:
	andi 1,777	; zero_extendqisi2
	sub 1,2
	popj 17,

zxqisi_xor:
	andi 1,777	; zero_extendqisi2
	xor 1,2
	popj 17,

zxqisi_or:
	andi 1,777	; zero_extendqisi2
	ior 1,2
	popj 17,

zxqisi_and:
	andi 1,777	; zero_extendqisi2
	and 1,2
	popj 17,

zxqisi_shift_left:
	andi 1,777	; zero_extendqisi2
	lsh 1,1
	popj 17,

zxqisi_shift_right:
	ldb 1,[POINT 8,1,34]
	popj 17,

zxqisi_mem:
	ldb 1,1
	popj 17,

zxqisi_mem_local:
	ldb 1,1
	popj 17,

zxqisi_mem_plus:
	ldb 1,1
	add 2,1
	move 1,2
	popj 17,

zxqisi_mem_xor:
	ldb 1,1
	xor 2,1
	move 1,2
	popj 17,

zxqisi_volatile_mem:
	ldb 1,1
	popj 17,

zxqisi_volatile_mem_local:
	ldb 1,1
	popj 17,

zxqisi_global:
	move 1,zxqisi_ga
	popj 17,

zxqisi_global_b:
	move 1,zxqisi_gb
	popj 17,

zxqisi_volatile_global:
	move 1,zxqisi_vga
	popj 17,

zxqisi_global_after_call:
	pushj 17,uqfunc
	movem 1,zxqisi_ga
	pushj 17,clobber
	move 1,zxqisi_ga
	popj 17,

zxqisi_array:
	move 4,1
	andi 4,3
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,zxqisi_buf,8]
	jumpe 4,%L25
%L24:
	ibp 1
	sojn 4,%L24	; decrement_and_branch_until_zero
%L25:
	ldb 1,1
	popj 17,

zxqisi_array_local:
	move 4,1
	andi 4,3
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,zxqisi_buf,8]
	jumpe 4,%L28
%L27:
	ibp 1
	sojn 4,%L27	; decrement_and_branch_until_zero
%L28:
	ldb 1,1
	popj 17,

zxqisi_array_plus:
	move 4,1
	andi 4,3
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,zxqisi_buf,8]
	jumpe 4,%L31
%L30:
	ibp 1
	sojn 4,%L30	; decrement_and_branch_until_zero
%L31:
	ldb 1,1
	add 2,1
	move 1,2
	popj 17,

zxqisi_ptr_array:
	move 4,2
	andi 4,3
	andi 2,17
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L35
%L34:
	ibp 1
	sojn 4,%L34	; decrement_and_branch_until_zero
%L35:
	ldb 1,1
	popj 17,

zxqisi_struct_a:
	move 1,(1)
	lsh 1,-33
	popj 17,

zxqisi_struct_b:
	ldb 1,[POINT 9,(1),17]
	popj 17,

zxqisi_struct_index:
	trnn 2,1
	jrst %L39
	ldb 1,[POINT 9,(1),17]
%L38:
	popj 17,
%L39:
	ldb 1,[POINT 9,(1),26]
	popj 17,

zxqisi_global_struct_a:
	move 1,zxqisi_gp
	lsh 1,-33
	popj 17,

zxqisi_global_struct_b:
	ldb 1,[POINT 9,zxqisi_gp,17]
	popj 17,

zxqisi_global_struct_c:
	ldb 1,[POINT 9,zxqisi_gt,26]
	popj 17,

zxqisi_store_global:
	andi 1,777
	movem 1,zxqisi_sga
	popj 17,

zxqisi_store_volatile_global:
	andi 1,777	; zero_extendqisi2
	movem 1,zxqisi_vsga
	popj 17,

zxqisi_store_ptr:
	andi 2,777
	movem 2,(1)
	popj 17,

zxqisi_store_array:
	andi 1,17
	andi 2,777
	movem 2,zxqisi_sbuf(1)
	popj 17,

zxqisi_store_from_mem:
	ldb 4,2
	movem 4,(1)
	popj 17,

zxqisi_store_from_volatile:
	ldb 4,2
	movem 4,(1)
	popj 17,

zxqisi_const_zero:
	movei 1,0
	popj 17,

zxqisi_const_one:
	movei 1,1
	popj 17,

zxqisi_const_377:
	movei 1,377
	popj 17,

zxqisi_const_400:
	movei 1,400
	popj 17,

zxqisi_const_777:
	movei 1,777
	popj 17,

zxqisi_from_sint:
	andi 1,777	; zero_extendqisi2
	popj 17,

zxqisi_from_sint_plus:
	add 1,2
	andi 1,777	; zero_extendqisi2
	popj 17,

zxqisi_from_negative:
	andi 1,777	; zero_extendqisi2
	popj 17,

zxqisi_eq_zero:
	andi 1,777	; zero_extendqisi2
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

zxqisi_ne_zero:
	andi 1,777	; zero_extendqisi2
	skipe 1
	movei 1,1
	popj 17,

zxqisi_lt_400:
	andi 1,777	; zero_extendqisi2
	tlc 1,400000
	move 6,[-377777777401]
	camle 1,6
	tdza 1,1
	movei 1,1
	popj 17,

zxqisi_gt_400:
	andi 1,777	; zero_extendqisi2
	tlc 1,400000
	move 6,[-377777777400]
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

zxqisi_mem_eq:
	ldb 1,1
	movei 6,777
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

zxqisi_mem_range:
	ldb 4,1
	tlo 4,400000
	seto 1,
	camg 4,[-377777777701]
	popj 17,
	move 6,[-377777777101]
	camg 4,6
	tdza 1,1
	movei 1,1
	popj 17,

zxqisi_sum3:
	andi 1,777	; zero_extendqisi2
	andi 2,777	; zero_extendqisi2
	andi 3,777	; zero_extendqisi2
	add 1,2
	add 1,3
	popj 17,

zxqisi_sum_mem3:
	move 4,1
	ibp 4
	move 3,4
	ldb 4,4
	ldb 1,1
	add 4,1
	move 1,4
	ildb 3,3
	add 1,3
	popj 17,

zxqisi_mix:
	andi 1,777	; zero_extendqisi2
	move 4,3
	andi 4,17
	move 6,3
	andi 6,3
	ash 4,-2	; ashrsi3_pointer
	add 2,4
	jumpe 6,%L70
%L69:
	ibp 2
	sojn 6,%L69	; decrement_and_branch_until_zero
%L70:
	ldb 2,2
	move 4,3
	aos 6,4
	andi 6,3
	move 3,4
	andi 3,17
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,zxqisi_buf,8]
	jumpe 6,%L72
%L71:
	ibp 3
	sojn 6,%L71	; decrement_and_branch_until_zero
%L72:
	lsh 1,2
	ldb 3,3
	add 2,3
	xor 1,2
	popj 17,

zxqisi_call:
	pushj 17,uqfunc
	andi 1,777	; zero_extendqisi2
	popj 17,

zxqisi_call_local:
	pushj 17,uqfunc
	andi 1,777	; zero_extendqisi2
	popj 17,

	.bss
zxqisi_ga:
	.space	4
zxqisi_gb:
	.space	4
zxqisi_vga:
	.space	4
zxqisi_buf:
	.space	16
zxqisi_sga:
	.space	4
zxqisi_vsga:
	.space	4
zxqisi_sbuf:
	.space	64
zxqisi_gp:
	.space	4
zxqisi_gt:
	.space	4
