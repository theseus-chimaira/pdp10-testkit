
	.globl	cmpsi
cmpsi:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

cmp_eq:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

cmp_ne:
	camn 1,2
	tdza 1,1
	movei 1,1
	popj 17,

cmp_lt:
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

cmp_le:
	camle 1,2
	tdza 1,1
	movei 1,1
	popj 17,

cmp_gt:
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

cmp_ge:
	camge 1,2
	tdza 1,1
	movei 1,1
	popj 17,

ucmp_eq:
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

ucmp_ne:
	camn 1,2
	tdza 1,1
	movei 1,1
	popj 17,

ucmp_lt:
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

ucmp_le:
	tlc 1,400000
	tlc 2,400000
	camle 1,2
	tdza 1,1
	movei 1,1
	popj 17,

ucmp_gt:
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

ucmp_ge:
	tlc 1,400000
	tlc 2,400000
	camge 1,2
	tdza 1,1
	movei 1,1
	popj 17,

cmp_eq_zero:
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

cmp_ne_zero:
	skipe 1
	movei 1,1
	popj 17,

cmp_lt_zero:
	lsh 1,-43
	popj 17,

cmp_le_zero:
	skiple 1
	tdza 1,1
	movei 1,1
	popj 17,

cmp_gt_zero:
	skipg 1
	tdza 1,1
	movei 1,1
	popj 17,

cmp_ge_zero:
	skipge 1
	tdza 1,1
	movei 1,1
	popj 17,

ucmp_eq_zero:
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

ucmp_ne_zero:
	skipe 1
	movei 1,1
	popj 17,

cmp_mem_eq_zero:
	skipe (1)
	tdza 1,1
	movei 1,1
	popj 17,

cmp_mem_ne_zero:
	skipe 1,(1)
	movei 1,1
	popj 17,

cmp_mem_lt_zero:
	move 1,(1)
	lsh 1,-43
	popj 17,

cmp_mem_ge_zero:
	skipge (1)
	tdza 1,1
	movei 1,1
	popj 17,

cmp_global_eq_zero:
	skipe cmp_ga
	tdza 1,1
	movei 1,1
	popj 17,

cmp_global_ne_zero:
	skipe 1,cmp_ga
	movei 1,1
	popj 17,

cmp_global_lt_zero:
	move 1,cmp_ga
	lsh 1,-43
	popj 17,

cmp_global_ge_zero:
	skipge cmp_ga
	tdza 1,1
	movei 1,1
	popj 17,

cmp_volatile_global_eq_zero:
	move 1,cmp_vga
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

cmp_volatile_global_lt_zero:
	move 1,cmp_vga
	lsh 1,-43
	popj 17,

cmp_eq_1:
	movei 6,1
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cmp_ne_1:
	movei 6,1
	camn 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cmp_lt_1:
	skiple 1
	tdza 1,1
	movei 1,1
	popj 17,

cmp_le_1:
	movei 6,1
	camle 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cmp_gt_1:
	movei 6,1
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cmp_ge_1:
	skipg 1
	tdza 1,1
	movei 1,1
	popj 17,

cmp_eq_small:
	movei 6,12345
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cmp_lt_small:
	movei 6,12344
	camle 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cmp_gt_small:
	movei 6,12345
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cmp_eq_right_max:
	movei 6,777777
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cmp_lt_right_max:
	movei 6,777776
	camle 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cmp_gt_right_max:
	movei 6,777777
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cmp_eq_minus_1:
	seto 6,
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cmp_lt_minus_1:
	seto 6,
	caml 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cmp_gt_minus_1:
	skipge 1
	tdza 1,1
	movei 1,1
	popj 17,

cmp_eq_minus_small:
	hrroi 6,765433
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cmp_lt_minus_small:
	hrroi 6,765433
	caml 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cmp_gt_minus_small:
	hrroi 6,765433
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

ucmp_lt_1:
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

ucmp_gt_1:
	skipl 1,1
	cail 1,2
	trna
	tdza 1,1
	movei 1,1
	popj 17,

ucmp_eq_small:
	movei 6,12345
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

ucmp_lt_small:
	skipl 1,1
	cail 1,12345
	tdza 1,1
	movei 1,1
	popj 17,

ucmp_gt_small:
	skipl 1,1
	cail 1,12346
	trna
	tdza 1,1
	movei 1,1
	popj 17,

ucmp_eq_highbit:
	movsi 6,400000
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

ucmp_lt_highbit:
	skipge 1
	tdza 1,1
	movei 1,1
	popj 17,

ucmp_gt_highbit:
	tlc 1,400000
	skipg 1
	tdza 1,1
	movei 1,1
	popj 17,

cmp_eq_left_const:
	movsi 6,123456
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cmp_ne_left_const:
	movsi 6,123456
	camn 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cmp_lt_left_const:
	hrloi 6,123455
	camle 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cmp_gt_left_const:
	movsi 6,123456
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cmp_eq_full_const:
	move 6,[123456123456]
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cmp_ne_full_const:
	move 6,[123456123456]
	camn 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cmp_lt_full_const:
	move 6,[123456123455]
	camle 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cmp_gt_full_const:
	move 6,[123456123456]
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cmp_eq_signbit:
	movsi 6,400000
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cmp_lt_signbit:
	skipge 1
	tdza 1,1
	movei 1,1
	popj 17,

cmp_gt_signbit:
	tlc 1,400000
	skipg 1
	tdza 1,1
	movei 1,1
	popj 17,

cmp_mem_eq_reg:
	move 1,(1)
	came 1,2
	tdza 2,2
	movei 2,1
	move 1,2
	popj 17,

cmp_mem_ne_reg:
	move 1,(1)
	camn 1,2
	tdza 2,2
	movei 2,1
	move 1,2
	popj 17,

cmp_mem_lt_reg:
	move 1,(1)
	caml 1,2
	tdza 2,2
	movei 2,1
	move 1,2
	popj 17,

cmp_mem_le_reg:
	move 1,(1)
	camle 1,2
	tdza 2,2
	movei 2,1
	move 1,2
	popj 17,

cmp_mem_gt_reg:
	move 1,(1)
	camg 1,2
	tdza 2,2
	movei 2,1
	move 1,2
	popj 17,

cmp_mem_ge_reg:
	move 1,(1)
	camge 1,2
	tdza 2,2
	movei 2,1
	move 1,2
	popj 17,

cmp_reg_eq_mem:
	came 1,(2)
	tdza 1,1
	movei 1,1
	popj 17,

cmp_reg_ne_mem:
	camn 1,(2)
	tdza 1,1
	movei 1,1
	popj 17,

cmp_reg_lt_mem:
	caml 1,(2)
	tdza 1,1
	movei 1,1
	popj 17,

cmp_reg_le_mem:
	camle 1,(2)
	tdza 1,1
	movei 1,1
	popj 17,

cmp_reg_gt_mem:
	camg 1,(2)
	tdza 1,1
	movei 1,1
	popj 17,

cmp_reg_ge_mem:
	camge 1,(2)
	tdza 1,1
	movei 1,1
	popj 17,

cmp_global_eq_reg:
	move 6,cmp_ga
	came 6,1
	tdza 1,1
	movei 1,1
	popj 17,

cmp_global_lt_reg:
	move 6,cmp_ga
	caml 6,1
	tdza 1,1
	movei 1,1
	popj 17,

cmp_reg_lt_global:
	caml 1,cmp_gb
	tdza 1,1
	movei 1,1
	popj 17,

cmp_volatile_global_reg:
	move 4,1
	move 1,cmp_vga
	camn 1,4
	tdza 1,1
	movei 1,1
	popj 17,

ucmp_mem_lt_reg:
	move 1,(1)
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

ucmp_mem_gt_reg:
	move 1,(1)
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

ucmp_reg_lt_mem:
	tlc 1,400000
	move 4,(2)
	tlc 4,400000
	caml 1,4
	tdza 1,1
	movei 1,1
	popj 17,

ucmp_reg_gt_mem:
	tlc 1,400000
	move 4,(2)
	tlc 4,400000
	camg 1,4
	tdza 1,1
	movei 1,1
	popj 17,

ucmp_global_lt_reg:
	move 4,1
	move 1,ucmp_ga
	tlc 1,400000
	tlc 4,400000
	caml 1,4
	tdza 1,1
	movei 1,1
	popj 17,

ucmp_reg_lt_global:
	tlc 1,400000
	move 4,ucmp_gb
	tlc 4,400000
	caml 1,4
	tdza 1,1
	movei 1,1
	popj 17,

ucmp_volatile_global_reg:
	move 4,1
	move 1,ucmp_vga
	camn 1,4
	tdza 1,1
	movei 1,1
	popj 17,

cmp_array_eq_reg:
	andi 1,17
	move 1,cmp_buf(1)
	came 1,2
	tdza 2,2
	movei 2,1
	move 1,2
	popj 17,

cmp_array_lt_reg:
	andi 1,17
	move 1,cmp_buf(1)
	caml 1,2
	tdza 2,2
	movei 2,1
	move 1,2
	popj 17,

cmp_reg_lt_array:
	andi 2,17
	caml 1,cmp_buf(2)
	tdza 1,1
	movei 1,1
	popj 17,

cmp_ptr_array_gt_reg:
	andi 2,17
	add 1,2
	move 1,(1)
	camg 1,3
	tdza 3,3
	movei 3,1
	move 1,3
	popj 17,

ucmp_array_lt_reg:
	andi 1,17
	move 1,ucmp_buf(1)
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

ucmp_reg_lt_array:
	andi 2,17
	tlc 1,400000
	move 4,ucmp_buf(2)
	tlc 4,400000
	caml 1,4
	tdza 1,1
	movei 1,1
	popj 17,

cmp_struct_eq_a:
	move 1,(1)
	came 1,2
	tdza 2,2
	movei 2,1
	move 1,2
	popj 17,

cmp_struct_lt_a:
	move 1,(1)
	caml 1,2
	tdza 2,2
	movei 2,1
	move 1,2
	popj 17,

cmp_struct_gt_b:
	move 1,1(1)
	camg 1,2
	tdza 2,2
	movei 2,1
	move 1,2
	popj 17,

cmp_struct_members:
	move 6,(1)
	caml 6,1(1)
	tdza 1,1
	movei 1,1
	popj 17,

cmp_global_struct_a:
	move 6,cmp_gp
	came 6,1
	tdza 1,1
	movei 1,1
	popj 17,

cmp_global_struct_b:
	move 6,cmp_gp+1
	camge 6,1
	tdza 1,1
	movei 1,1
	popj 17,

ucmp_struct_members:
	move 4,1
	move 1,(1)
	tlc 1,400000
	move 4,1(4)
	tlc 4,400000
	caml 1,4
	tdza 1,1
	movei 1,1
	popj 17,

ucmp_global_struct_a:
	move 4,1
	move 1,ucmp_gp
	tlc 1,400000
	tlc 4,400000
	camg 1,4
	tdza 1,1
	movei 1,1
	popj 17,

cmp_add_eq:
	add 1,2
	came 1,3
	tdza 1,1
	movei 1,1
	popj 17,

cmp_add_lt:
	add 1,2
	caml 1,3
	tdza 1,1
	movei 1,1
	popj 17,

cmp_sub_eq:
	sub 1,2
	came 1,3
	tdza 1,1
	movei 1,1
	popj 17,

cmp_sub_lt:
	sub 1,2
	caml 1,3
	tdza 1,1
	movei 1,1
	popj 17,

cmp_mul_eq:
	imul 1,2
	came 1,3
	tdza 1,1
	movei 1,1
	popj 17,

cmp_and_eq:
	and 1,2
	came 1,3
	tdza 1,1
	movei 1,1
	popj 17,

cmp_xor_ne:
	xor 1,2
	camn 1,3
	tdza 1,1
	movei 1,1
	popj 17,

cmp_or_gt:
	ior 1,2
	camg 1,3
	tdza 1,1
	movei 1,1
	popj 17,

ucmp_add_lt:
	add 1,2
	tlc 1,400000
	tlc 3,400000
	caml 1,3
	tdza 1,1
	movei 1,1
	popj 17,

ucmp_sub_gt:
	sub 1,2
	tlc 1,400000
	tlc 3,400000
	camg 1,3
	tdza 1,1
	movei 1,1
	popj 17,

cmp_right_half_eq:
	hrrz 1,1
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

cmp_right_half_lt:
	hrrz 1,1
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

cmp_right_half_plus_eq:
	movei 1,123(1)
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

cmp_right_half_plus_lt:
	movei 1,123(1)
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

cmp_reg_eq_right_half:
	hrrz 2,2
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

cmp_reg_lt_right_half:
	hrrz 2,2
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

cmp_qi_eq:
	lsh 1,33
	ash 1,-33
	lsh 2,33
	ash 2,-33
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

cmp_qi_lt:
	lsh 1,33
	ash 1,-33
	lsh 2,33
	ash 2,-33
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

cmp_uqi_lt:
	andi 1,777	; zero_extendqisi2
	andi 2,777	; zero_extendqisi2
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

cmp_hi_eq:
	hrre 1,1
	hrre 2,2
	came 1,2
	tdza 1,1
	movei 1,1
	popj 17,

cmp_hi_lt:
	hrre 1,1
	hrre 2,2
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

cmp_uhi_lt:
	hrrzi 1,(1)	; zero_extendhisi2
	hrrzi 2,(2)	; zero_extendhisi2
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

cmp_qi_reg:
	lsh 1,33
	ash 1,-33
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

cmp_hi_reg:
	hrre 1,1
	camge 1,2
	tdza 1,1
	movei 1,1
	popj 17,

cmp_uqi_reg:
	andi 1,777	; zero_extendqisi2
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

cmp_uhi_reg:
	hrrzi 1,(1)	; zero_extendhisi2
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

cmp_if_eq:
	move 4,2
	addi 4,1
	came 1,2
	subi 4,2
	move 1,4
	popj 17,

cmp_if_ne:
	move 4,1
	sub 4,2
	camn 1,2
	jrst %L138
%L136:
	move 1,4
	popj 17,
%L138:
	move 4,1
	jrst %L136

cmp_if_lt:
	seto 4,
	caml 1,2
	movei 4,1
	move 1,4
	popj 17,

cmp_if_le:
	seto 4,
	camle 1,2
	movei 4,1
	move 1,4
	popj 17,

cmp_if_gt:
	movei 4,1
	camg 1,2
	seto 4,
	move 1,4
	popj 17,

cmp_if_ge:
	movei 4,1
	camge 1,2
	seto 4,
	move 1,4
	popj 17,

ucmp_if_lt:
	tlc 1,400000
	tlc 2,400000
	seto 4,
	caml 1,2
	movei 4,1
	move 1,4
	popj 17,

ucmp_if_ge:
	tlc 1,400000
	tlc 2,400000
	movei 4,1
	camge 1,2
	seto 4,
	move 1,4
	popj 17,

cmp_range_signed:
	seto 4,
	camge 1,[-100]
	jrst %L151
	movei 6,100
	camg 1,6
	tdza 4,4
	movei 4,1
%L151:
	move 1,4
	popj 17,

cmp_range_unsigned:
	tlc 1,400000
	seto 4,
	camg 1,[-377777777701]
	jrst %L154
	hrloi 6,400000
	camg 1,6
	tdza 4,4
	movei 4,1
%L154:
	move 1,4
	popj 17,

cmp_between:
	seto 4,
	camge 1,2
	jrst %L157
	camg 1,3
	tdza 4,4
	movei 4,1
%L157:
	move 1,4
	popj 17,

ucmp_between:
	tlc 1,400000
	tlc 2,400000
	seto 4,
	camge 1,2
	jrst %L160
	tlc 3,400000
	camg 1,3
	tdza 4,4
	movei 4,1
%L160:
	move 1,4
	popj 17,

cmp_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,2
	move 10,(1)
	pushj 17,clobber
	came 10,11
	tdza 10,10
	movei 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

cmp_call_result:
	push 17,10
	move 10,1
	pushj 17,f
	caml 1,10
	tdza 1,1
	movei 1,1
	pop 17,10
	popj 17,

cmp_two_call_results:
	push 17,10
	pushj 17,f
	move 10,1
	pushj 17,f
	camn 10,1
	tdza 10,10
	movei 10,1
	move 1,10
	pop 17,10
	popj 17,

ucmp_call_result:
	push 17,10
	move 10,1
	pushj 17,uf
	tlc 1,400000
	tlc 10,400000
	camg 1,10
	tdza 1,1
	movei 1,1
	pop 17,10
	popj 17,

cmp_store_after_compare:
	camle 2,3
	move 2,3
	movem 2,(1)
	move 1,2
	popj 17,

cmp_global_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,10
	move 6,cmp_ga
	camn 6,10
	jrst %L172
%L170:
	pop 17,10
	popj 17,
%L172:
	move 1,cmp_gb
	jrst %L170

cmp_volatile_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 1,cmp_vga
	camn 1,10
	tdza 1,1
	movei 1,1
	pop 17,10
	popj 17,

	.bss
cmp_ga:
	.space	4
cmp_gb:
	.space	4
cmp_vga:
	.space	4
cmp_buf:
	.space	64
ucmp_ga:
	.space	4
ucmp_gb:
	.space	4
ucmp_vga:
	.space	4
ucmp_buf:
	.space	64
cmp_gp:
	.space	8
ucmp_gp:
	.space	8
