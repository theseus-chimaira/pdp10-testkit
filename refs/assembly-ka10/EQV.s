
eqv_reg_reg:
	eqv 1,2
	popj 17,

eqv_reg_mem:
	eqv 1,(2)
	popj 17,

eqv_mem_reg:
	eqv 2,(1)
	move 1,2
	popj 17,

eqv_mem_mem:
	move 1,(1)
	eqv 1,(2)
	popj 17,

eqvi_small:
	eqvi 1,123456
	popj 17,

eqvi_zero:
	setca 1,
	popj 17,

eqvi_one:
	eqvi 1,1
	popj 17,

eqvi_low9:
	eqvi 1,777
	popj 17,

eqvi_low18:
	tlc 1,777777
	popj 17,

eqv_const_small:
	eqvi 1,123456
	popj 17,

eqv_const_zero:
	setca 1,
	popj 17,

eqv_const_one:
	eqvi 1,1
	popj 17,

eqv_const_low18:
	tlc 1,777777
	popj 17,

eqv_literal:
	xor 1,[-123456123457]
	popj 17,

eqv_literal_left:
	xor 1,[-123456123457]
	popj 17,

eqvi_literal:
	xor 1,[-123456123457]
	popj 17,

eqv_sparse:
	xor 1,[252525525252]
	popj 17,

eqvi_sparse:
	xor 1,[252525525252]
	popj 17,

eqv_left_half:
	xori 1,777777
	popj 17,

eqv_right_half:
	tlc 1,777777
	popj 17,

eqv_sign_bit:
	xor 1,[377777777777]
	popj 17,

eqv_clear_sign_mask:
	tlc 1,400000
	popj 17,

eqv_high_ones_low_const:
	xori 1,765432
	popj 17,

eqv_low_ones_high_const:
	tlc 1,654321
	popj 17,

eqvm_reg_mem:
	eqvm 1,(2)
	popj 17,

eqvm_mem_reg:
	eqvm 1,(2)
	popj 17,

eqvm_const:
	hrroi 6,654321
	xorm 6,(1)
	popj 17,

eqvm_literal:
	move 6,[-123456123457]
	xorm 6,(1)
	popj 17,

eqvm_then_load:
	eqvb 1,(2)
	popj 17,

eqv_assign_local:
	eqv 1,2
	eqv 1,3
	popj 17,

eqv_assign_mixed:
	eqv 2,1
	eqv 3,2
	move 1,3
	popj 17,

ueqv_reg_reg:
	eqv 1,2
	popj 17,

ueqv_reg_mem:
	eqv 1,(2)
	popj 17,

ueqvi_small:
	eqvi 1,123456
	popj 17,

ueqvi_low18:
	tlc 1,777777
	popj 17,

ueqv_literal:
	xor 1,[-123456123457]
	popj 17,

ueqvi_literal:
	xor 1,[-123456123457]
	popj 17,

ueqv_left_half:
	xori 1,777777
	popj 17,

ueqv_right_half:
	tlc 1,777777
	popj 17,

ueqv_high_ones_low_const:
	xori 1,765432
	popj 17,

eqv_qi_promote:
	xor 2,1
	lsh 2,33
	ash 2,-33
	setca 2,
	move 1,2
	popj 17,

ueqv_qi_promote:
	xor 2,1
	orcbi 2,777
	move 1,2
	popj 17,

eqv_hi_promote:
	xor 2,1
	hrre 2,2
	setca 2,
	move 1,2
	popj 17,

ueqv_hi_promote:
	hrrzi 2,(2)	; zero_extendhisi2
	eqvi 2,(1)
	move 1,2
	popj 17,

eqvi_qi_mask:
	orcmi 1,777
	popj 17,

eqvi_hi_mask:
	hrro 1,1
	popj 17,

eqv_volatile_mem:
	move 4,1
	move 1,(2)
	eqv 1,4
	popj 17,

eqvm_volatile_mem:
	move 4,(2)
	eqv 4,1
	movem 4,(2)
	popj 17,

eqv_array_value:
	andi 3,7
	add 2,3
	eqv 1,(2)
	popj 17,

eqvm_array_value:
	andi 3,7
	add 2,3
	eqvm 1,(2)
	popj 17,

eqv_struct_value:
	eqv 1,1(2)
	popj 17,

eqvm_struct_value:
	eqvm 1,2(2)
	popj 17,

eqvi_reg_mask:
	orcbi 1,777777
	xor 2,1
	move 1,2
	popj 17,

eqvi_reg_mask_plus:
	eqvi 2,1234(1)
	move 1,2
	popj 17,

eqv_left_shift_mask:
	hrlz 1,1
	eqv 1,2
	popj 17,

eqv_left_shift_mask_plus:
	movei 1,1234(1)
	hrlz 1,1
	eqv 1,2
	popj 17,

eqv_call_pressure:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	eqv 10,(2)
	pushj 17,clobber
	add 10,(11)
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

eqv_two_results:
	eqv 2,1
	eqv 1,3
	add 2,1
	move 1,2
	popj 17,

eqvb_reg_memaa:
	eqvb 1,(2)
	popj 17,

eqvb_reg_memab:
	eqvb 1,(2)
	popj 17,

eqvb_reg_memba:
	eqvb 1,(2)
	popj 17,

eqvb_reg_membb:
	eqvb 1,(2)
	popj 17,

eqvb_mem_regaa:
	eqvb 1,(2)
	popj 17,

eqvb_mem_regab:
	eqvb 1,(2)
	popj 17,

eqvb_mem_regba:
	eqvb 1,(2)
	popj 17,

eqvb_mem_regbb:
	eqvb 1,(2)
	popj 17,

ueqvb_reg_memaa:
	eqvb 1,(2)
	popj 17,

ueqvb_reg_memab:
	eqvb 1,(2)
	popj 17,

ueqvb_reg_memba:
	eqvb 1,(2)
	popj 17,

ueqvb_reg_membb:
	eqvb 1,(2)
	popj 17,

	.comm	p, 4
