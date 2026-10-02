
and_reg_reg:
	and 1,2
	popj 17,

uand_reg_reg:
	and 1,2
	popj 17,

and_reg_mem:
	and 1,(2)
	popj 17,

and_mem_reg:
	and 2,(1)
	move 1,2
	popj 17,

and_mem_mem:
	move 1,(1)
	and 1,(2)
	popj 17,

uand_reg_mem:
	and 1,(2)
	popj 17,

and_volatile_mem:
	move 4,(2)
	and 4,1
	move 1,4
	popj 17,

and_global_reg:
	and 1,andsi3_ga
	popj 17,

and_reg_global:
	and 1,andsi3_gb
	popj 17,

uand_global_reg:
	and 1,andsi3_uga
	popj 17,

and_array_reg:
	andi 2,17
	add 1,2
	and 3,(1)
	move 1,3
	popj 17,

and_reg_array:
	andi 3,17
	add 2,3
	and 1,(2)
	popj 17,

uand_array_reg:
	andi 2,17
	add 1,2
	and 3,(1)
	move 1,3
	popj 17,

and_global_array:
	andi 1,17
	and 2,andsi3_buf(1)
	move 1,2
	popj 17,

and_struct_a:
	and 2,(1)
	move 1,2
	popj 17,

and_struct_b:
	and 2,1(1)
	move 1,2
	popj 17,

and_global_struct:
	and 1,andsi3_gp
	popj 17,

andi_zero:
	movei 1,0
	popj 17,

andi_one:
	andi 1,1
	popj 17,

andi_small:
	andi 1,123456
	popj 17,

andi_low9:
	andi 1,777
	popj 17,

andi_low18:
	hrrz 1,1
	popj 17,

uandi_low18:
	hrrz 1,1
	popj 17,

tlz_small:
	tlz 1,654321
	popj 17,

tlz_zero_left:
	hrrz 1,1
	popj 17,

tlz_clear_one_left_bit:
	tlz 1,400000
	popj 17,

tlz_clear_many_left_bits:
	tlz 1,252525
	popj 17,

tlz_after_expr:
	xor 1,2
	tlz 1,654321
	popj 17,

andcmi_small:
	andcmi 1,123456
	popj 17,

andcmi_one:
	andcmi 1,1
	popj 17,

andcmi_low9:
	andcmi 1,777
	popj 17,

andcmi_low18:
	hllz 1,1
	popj 17,

uandcmi_low18:
	hllz 1,1
	popj 17,

andcmi_after_expr:
	ior 1,2
	andcmi 1,123456
	popj 17,

and_large_literal:
	and 1,[123456123456]
	popj 17,

and_large_literal_left:
	and 1,[123456123456]
	popj 17,

and_sparse_literal:
	and 1,[-252525525253]
	popj 17,

and_left_half_only:
	hllz 1,1
	popj 17,

and_right_half_only:
	hrrz 1,1
	popj 17,

and_sign_bit:
	and 1,[-400000000000]
	popj 17,

uand_large_literal:
	and 1,[123456123456]
	popj 17,

and_const_after_expr:
	add 1,2
	and 1,[123456123456]
	popj 17,

and_qi_promote:
	and 2,1
	lsh 2,33
	ash 2,-33
	move 1,2
	popj 17,

and_uqi_promote:
	and 2,1
	andi 2,777
	move 1,2
	popj 17,

and_hi_promote:
	and 2,1
	hrre 2,2
	move 1,2
	popj 17,

and_uhi_promote:
	hrrzi 2,(2)	; zero_extendhisi2
	andi 2,(1)
	move 1,2
	popj 17,

and_qi_mem:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	and 1,2
	popj 17,

and_uqi_mem:
	ldb 1,1
	and 2,1
	move 1,2
	popj 17,

and_hi_mem:
	ldb 1,1
	hrre 1,1
	and 1,2
	popj 17,

and_uhi_mem:
	ldb 1,1
	and 2,1
	move 1,2
	popj 17,

andm_reg:
	andm 2,(1)
	popj 17,

andm_reg_alt:
	andm 2,(1)
	popj 17,

andm_reg_ret:
	move 4,2
	andb 4,(1)
	move 1,4
	popj 17,

andm_reg_ret_alt:
	move 4,2
	andb 4,(1)
	move 1,4
	popj 17,

andm_mem:
	move 2,(2)
	andm 2,(1)
	popj 17,

andm_mem_ret:
	move 4,(1)
	and 4,(2)
	movem 4,(1)
	move 1,4
	popj 17,

andm_global:
	andm 1,andsi3_ga
	popj 17,

andm_global_ret:
	andb 1,andsi3_ga
	popj 17,

andm_array:
	andi 2,17
	add 1,2
	andm 3,(1)
	popj 17,

andm_array_ret:
	move 4,1
	andi 2,17
	add 4,2
	move 1,3
	andb 1,(4)
	popj 17,

andm_global_array:
	andi 1,17
	andm 2,andsi3_buf(1)
	popj 17,

andm_struct_a:
	move 4,2
	andb 4,(1)
	move 1,4
	popj 17,

andm_struct_b:
	move 4,2
	andb 4,1(1)
	move 1,4
	popj 17,

andm_global_struct:
	andb 1,andsi3_gp+1
	popj 17,

andm_volatile:
	move 4,(1)
	and 4,2
	movem 4,(1)
	popj 17,

andm_volatile_ret:
	move 4,(1)
	and 4,2
	movem 4,(1)
	move 1,(1)
	popj 17,

andm_const_small:
	movei 6,123456
	andm 6,(1)
	popj 17,

andm_const_small_ret:
	move 4,(1)
	andi 4,123456
	movem 4,(1)
	move 1,4
	popj 17,

andm_const_low18:
	move 6,(1)
	hrrzm 6,(1)
	popj 17,

andm_const_low18_ret:
	hrrzs 4,(1)
	move 1,4
	popj 17,

andm_const_tlz:
	hrloi 6,123456
	andm 6,(1)
	popj 17,

andm_const_tlz_ret:
	move 4,(1)
	tlz 4,654321
	movem 4,(1)
	move 1,4
	popj 17,

andm_const_andcmi:
	hrroi 6,654321
	andm 6,(1)
	popj 17,

andm_const_andcmi_ret:
	move 4,(1)
	andcmi 4,123456
	movem 4,(1)
	move 1,4
	popj 17,

andm_const_large:
	move 6,[123456123456]
	andm 6,(1)
	popj 17,

andm_const_large_ret:
	move 4,(1)
	and 4,[123456123456]
	movem 4,(1)
	move 1,4
	popj 17,

andm_const_zero:
	setzm (1)
	popj 17,

andm_const_zero_ret:
	setzb 1,(1)
	popj 17,

andm_const_ones:
	popj 17,

andm_const_ones_ret:
	move 1,(1)
	popj 17,

and_reg_mask_right:
	hrrz 2,2
	and 2,1
	move 1,2
	popj 17,

and_reg_mask_left_clear:
	move 4,1
	movei 1,777777
	and 1,4
	popj 17,

and_reg_mask_clear_low:
	orcbi 2,777777
	and 2,1
	move 1,2
	popj 17,

and_shifted_mask:
	hrlz 2,2
	and 2,1
	move 1,2
	popj 17,

and_nested1:
	and 1,2
	and 1,3
	popj 17,

and_nested_const:
	xor 1,2
	and 1,2
	andi 1,123456
	popj 17,

and_nested_large_const:
	ior 2,1
	and 2,1
	and 2,[123456123456]
	move 1,2
	popj 17,

and_store_then_use:
	move 4,2
	andb 4,(1)
	and 4,2
	move 1,4
	popj 17,

and_call_pressure:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	and 10,11
	pushj 17,clobber
	and 10,11
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

and_mem_call_pressure:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	and 10,(1)
	pushj 17,clobber
	and 10,(11)
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

and_loop_sum:
	move 7,1
	setzb 1,6
	caml 1,2
	popj 17,
	subi 2,1
%L108:
	move 4,6
	andi 4,17
	add 4,7
	move 4,(4)
	and 4,3
	add 1,4
	addi 6,1
	sojge 2,%L108	; doloop_end
	popj 17,

and_loop_update:
	movei 6,0
	caml 6,2
	popj 17,
	subi 2,1
%L119:
	move 4,6
	andi 4,17
	add 4,1
	andm 3,(4)
	addi 6,1
	sojge 2,%L119	; doloop_end
	popj 17,

and_loop_update_sum:
	move 5,1
	move 6,3
	setzb 1,7
	caml 1,2
	popj 17,
	subi 2,1
%L131:
	move 4,7
	andi 4,17
	add 4,5
	move 3,6
	andb 3,(4)
	add 1,3
	addi 7,1
	sojge 2,%L131	; doloop_end
	popj 17,

and_branch_zero:
	andi 1,123456
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

and_branch_nonzero:
	move 4,1
	trnn 1,123456
	movei 4,0
	move 1,4
	popj 17,

and_branch_sign:
	skipge 1
	tdza 1,1
	movei 1,1
	subi 1,1
	popj 17,

and1:
	and 1,2
	popj 17,

and2:
	and 1,(2)
	popj 17,

andi:
	andi 1,123456
	popj 17,

tlz:
	tlz 1,654321
	popj 17,

andcmi:
	andcmi 1,123456
	popj 17,

and3:
	and 1,[123456123456]
	popj 17,

andm:
	andb 1,(2)
	popj 17,

	.bss
andsi3_ga:
	.space	4
andsi3_gb:
	.space	4
andsi3_uga:
	.space	4
andsi3_buf:
	.space	64
andsi3_ubuf:
	.space	64
andsi3_gp:
	.space	8
andsi3_gt:
	.space	12
