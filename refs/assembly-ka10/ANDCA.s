
andca_reg_reg:
	andca 1,2
	popj 17,

andca_reg_mem:
	andca 1,(2)
	popj 17,

andca_mem_reg:
	andca 2,(1)
	move 1,2
	popj 17,

andca_mem_mem:
	move 1,(1)
	andca 1,(2)
	popj 17,

andcai_small:
	andcai 1,123456
	popj 17,

andcai_zero:
	movei 1,0
	popj 17,

andcai_one:
	andcai 1,1
	popj 17,

andcai_low9:
	andcai 1,777
	popj 17,

andcai_low18:
	andcai 1,777777
	popj 17,

andca_literal:
	move 6,[123456123456]
	andca 1,6
	popj 17,

andca_literal_left:
	move 6,[123456123456]
	andca 1,6
	popj 17,

andca_sparse:
	move 6,[-252525525253]
	andca 1,6
	popj 17,

andca_left_half:
	andcbi 1,777777
	popj 17,

andca_right_half:
	andcai 1,777777
	popj 17,

andca_high_ones_low_const:
	andcbi 1,765432
	popj 17,

andca_low_ones_high_const:
	hrloi 6,123456
	andca 1,6
	popj 17,

andca_sign_bit:
	movsi 6,400000
	andca 1,6
	popj 17,

andca_clear_sign_mask:
	hrloi 6,377777
	andca 1,6
	popj 17,

andcam_reg_mem:
	andcam 1,(2)
	popj 17,

andcam_assign:
	andcam 1,(2)
	popj 17,

andcam_const:
	hrroi 6,654321
	andm 6,(1)
	popj 17,

andcam_then_load:
	andcab 1,(2)
	popj 17,

andca_assign_local:
	orca 2,1
	and 3,2
	move 1,3
	popj 17,

uandca_reg_reg:
	andca 1,2
	popj 17,

uandca_reg_mem:
	andca 1,(2)
	popj 17,

uandcai_small:
	andcai 1,123456
	popj 17,

uandcai_low18:
	andcai 1,777777
	popj 17,

uandca_literal:
	move 6,[123456123456]
	andca 1,6
	popj 17,

uandca_left_half:
	andcbi 1,777777
	popj 17,

uandca_right_half:
	andcai 1,777777
	popj 17,

uandca_high_ones_low_const:
	andcbi 1,765432
	popj 17,

andca_qi_promote:
	lsh 1,33
	ash 1,-33
	lsh 2,33
	ash 2,-33
	andca 1,2
	popj 17,

uandca_qi_promote:
	andi 2,777	; zero_extendqisi2
	orcbi 1,777
	and 2,1
	move 1,2
	popj 17,

andca_hi_promote:
	hrre 1,1
	hrre 2,2
	andca 1,2
	popj 17,

uandca_hi_promote:
	orcbi 1,777777
	andi 1,(2)
	popj 17,

andca_qi_mask:
	andcai 1,777
	popj 17,

andca_hi_mask:
	andcai 1,777777
	popj 17,

andca_volatile_mem:
	move 4,(2)
	andca 1,4
	popj 17,

andcam_volatile_mem:
	move 4,(2)
	andca 1,4
	movem 1,(2)
	popj 17,

andcai_reg_form:
	andca 2,1
	hrrz 2,2
	move 1,2
	popj 17,

andcai_reg_plus_form:
	addi 1,1234
	andca 2,1
	hrrz 2,2
	move 1,2
	popj 17,

andca_left_shift_form:
	hrlz 1,1
	andca 2,1
	move 1,2
	popj 17,

andca_left_shift_plus_form:
	movei 1,1234(1)
	hrlz 1,1
	andca 2,1
	move 1,2
	popj 17,

andcab_reg_memaa:
	andcab 1,(2)
	popj 17,

andcab_reg_memab:
	andcab 1,(2)
	popj 17,

andcab_reg_memba:
	andcab 1,(2)
	popj 17,

andcab_reg_membb:
	andcab 1,(2)
	popj 17,

andcab_mem_regaa:
	andcab 1,(2)
	popj 17,

andcab_mem_regab:
	andcab 1,(2)
	popj 17,

andcab_mem_regba:
	andcab 1,(2)
	popj 17,

andcab_mem_regbb:
	andcab 1,(2)
	popj 17,

uandcab_reg_memaa:
	andcab 1,(2)
	popj 17,

uandcab_reg_memab:
	andcab 1,(2)
	popj 17,

uandcab_reg_memba:
	andcab 1,(2)
	popj 17,

uandcab_reg_membb:
	andcab 1,(2)
	popj 17,

