
andcb_reg_reg:
	andcb 1,2
	popj 17,

andcb_reg_mem:
	andcb 1,(2)
	popj 17,

andcb_mem_reg:
	andcb 2,(1)
	move 1,2
	popj 17,

andcb_mem_mem:
	move 1,(1)
	andcb 1,(2)
	popj 17,

andcbi_small:
	andcbi 1,123456
	popj 17,

andcbi_zero:
	setca 1,
	popj 17,

andcbi_one:
	andcbi 1,1
	popj 17,

andcbi_low9:
	andcbi 1,777
	popj 17,

andcbi_low18:
	andcbi 1,777777
	popj 17,

andcb_literal:
	move 6,[-123456123457]
	andca 1,6
	popj 17,

andcb_literal_left:
	move 6,[-123456123457]
	andca 1,6
	popj 17,

andcb_sparse:
	move 6,[252525525252]
	andca 1,6
	popj 17,

andcb_left_half:
	andcai 1,777777
	popj 17,

andcb_right_half:
	andcbi 1,777777
	popj 17,

andcb_high_ones_low_const:
	andcai 1,765432
	popj 17,

andcb_low_ones_high_const:
	movsi 6,654321
	andca 1,6
	popj 17,

andcb_sign_bit:
	hrloi 6,377777
	andca 1,6
	popj 17,

andcb_clear_sign_mask:
	movsi 6,400000
	andca 1,6
	popj 17,

andcbm_reg_mem:
	andcbm 1,(2)
	popj 17,

andcbm_assign:
	andcbm 1,(2)
	popj 17,

andcbm_const:
	hrroi 6,654321
	andcmm 6,(1)
	popj 17,

andcbm_then_load:
	andcbb 1,(2)
	popj 17,

andcb_assign_local:
	andcb 2,1
	andcb 3,2
	move 1,3
	popj 17,

uandcb_reg_reg:
	andcb 1,2
	popj 17,

uandcb_reg_mem:
	andcb 1,(2)
	popj 17,

uandcbi_small:
	andcbi 1,123456
	popj 17,

uandcbi_low18:
	andcbi 1,777777
	popj 17,

uandcb_literal:
	move 6,[-123456123457]
	andca 1,6
	popj 17,

uandcb_left_half:
	andcai 1,777777
	popj 17,

uandcb_right_half:
	andcbi 1,777777
	popj 17,

uandcb_high_ones_low_const:
	andcai 1,765432
	popj 17,

andcb_qi_promote:
	ior 2,1
	lsh 2,33
	ash 2,-33
	setca 2,
	move 1,2
	popj 17,

uandcb_qi_promote:
	ior 2,1
	orcbi 2,777
	move 1,2
	popj 17,

andcb_hi_promote:
	ior 2,1
	hrre 2,2
	setca 2,
	move 1,2
	popj 17,

uandcb_hi_promote:
	hrrzi 2,(2)	; zero_extendhisi2
	andcbi 2,(1)
	move 1,2
	popj 17,

andcb_qi_mask:
	hrroi 1,777000
	popj 17,

andcb_hi_mask:
	movsi 1,777777
	popj 17,

andcb_volatile_mem:
	move 4,1
	move 1,(2)
	andcb 1,4
	popj 17,

andcbm_volatile_mem:
	move 4,(2)
	andcb 4,1
	movem 4,(2)
	popj 17,

andcbi_reg_form:
	andcbi 2,(1)
	move 1,2
	popj 17,

andcbi_reg_plus_form:
	andcbi 2,1234(1)
	move 1,2
	popj 17,

andcb_left_shift_form:
	tlo 2,(1)
	setca 2,
	move 1,2
	popj 17,

andcb_left_shift_plus_form:
	tlo 2,1234(1)
	setca 2,
	move 1,2
	popj 17,

andcbb_reg_memaa:
	andcbb 1,(2)
	popj 17,

andcbb_reg_memab:
	andcbb 1,(2)
	popj 17,

andcbb_reg_memba:
	andcbb 1,(2)
	popj 17,

andcbb_reg_membb:
	andcbb 1,(2)
	popj 17,

andcbb_mem_regaa:
	andcbb 1,(2)
	popj 17,

andcbb_mem_regab:
	andcbb 1,(2)
	popj 17,

andcbb_mem_regba:
	andcbb 1,(2)
	popj 17,

andcbb_mem_regbb:
	andcbb 1,(2)
	popj 17,

uandcbb_reg_memaa:
	andcbb 1,(2)
	popj 17,

uandcbb_reg_memab:
	andcbb 1,(2)
	popj 17,

uandcbb_reg_memba:
	andcbb 1,(2)
	popj 17,

uandcbb_reg_membb:
	andcbb 1,(2)
	popj 17,

