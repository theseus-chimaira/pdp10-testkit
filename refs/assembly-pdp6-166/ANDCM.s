
andcm_reg_reg:
	andca 2,1
	move 1,2
	popj 17,

andcm_reg_mem:
	andcm 1,(2)
	popj 17,

andcm_mem_reg:
	andca 2,(1)
	move 1,2
	popj 17,

andcm_mem_mem:
	move 1,(1)
	andcm 1,(2)
	popj 17,

andcmi_small:
	andcmi 1,123456
	popj 17,

andcmi_zero:
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

andcm_literal:
	and 1,[-123456123457]
	popj 17,

andcm_literal_left:
	and 1,[-123456123457]
	popj 17,

andcm_sparse:
	and 1,[252525525252]
	popj 17,

andcm_left_half:
	hrrz 1,1
	popj 17,

andcm_right_half:
	hllz 1,1
	popj 17,

andcm_high_ones_low_const:
	andi 1,765432
	popj 17,

andcm_low_ones_high_const:
	and 1,[-123457000000]
	popj 17,

andcm_sign_bit:
	tlz 1,400000
	popj 17,

andcm_clear_sign_mask:
	and 1,[-400000000000]
	popj 17,

andcmm_reg_mem:
	andcam 1,(2)
	popj 17,

andcmm_assign:
	andcam 1,(2)
	popj 17,

andcmm_const:
	hrroi 6,654321
	andm 6,(1)
	popj 17,

andcmm_then_load:
	andcab 1,(2)
	popj 17,

andcm_assign_local:
	andcm 1,2
	andcm 1,3
	popj 17,

uandcm_reg_reg:
	andca 2,1
	move 1,2
	popj 17,

uandcm_reg_mem:
	andcm 1,(2)
	popj 17,

uandcmi_small:
	andcmi 1,123456
	popj 17,

uandcmi_low18:
	hllz 1,1
	popj 17,

uandcm_literal:
	and 1,[-123456123457]
	popj 17,

uandcm_left_half:
	hrrz 1,1
	popj 17,

uandcm_right_half:
	hllz 1,1
	popj 17,

uandcm_high_ones_low_const:
	andi 1,765432
	popj 17,

andcm_qi_promote:
	lsh 1,33
	ash 1,-33
	lsh 2,33
	ash 2,-33
	andca 2,1
	move 1,2
	popj 17,

uandcm_qi_promote:
	andi 1,777	; zero_extendqisi2
	orcbi 2,777
	and 1,2
	popj 17,

andcm_hi_promote:
	hrre 1,1
	hrre 2,2
	andca 2,1
	move 1,2
	popj 17,

uandcm_hi_promote:
	orcbi 2,777777
	andi 2,(1)
	move 1,2
	popj 17,

andcm_qi_mask:
	movei 1,0
	popj 17,

andcm_hi_mask:
	movei 1,0
	popj 17,

andcm_volatile_mem:
	move 4,1
	move 1,(2)
	andca 1,4
	popj 17,

andcmm_volatile_mem:
	move 4,(2)
	andca 1,4
	movem 1,(2)
	popj 17,

andcmi_reg_form:
	andcmi 2,(1)
	move 1,2
	popj 17,

andcmi_reg_plus_form:
	andcmi 2,1234(1)
	move 1,2
	popj 17,

andcm_left_shift_form:
	tlz 2,(1)
	move 1,2
	popj 17,

andcm_left_shift_plus_form:
	tlz 2,1234(1)
	move 1,2
	popj 17,

andcmb_reg_memaa:
	andcmb 1,(2)
	popj 17,

andcmb_reg_memab:
	andcmb 1,(2)
	popj 17,

andcmb_reg_memba:
	andcmb 1,(2)
	popj 17,

andcmb_reg_membb:
	andcmb 1,(2)
	popj 17,

andcmb_mem_regaa:
	andcmb 1,(2)
	popj 17,

andcmb_mem_regab:
	andcmb 1,(2)
	popj 17,

andcmb_mem_regba:
	andcmb 1,(2)
	popj 17,

andcmb_mem_regbb:
	andcmb 1,(2)
	popj 17,

uandcmb_reg_memaa:
	andcmb 1,(2)
	popj 17,

uandcmb_reg_memab:
	andcmb 1,(2)
	popj 17,

uandcmb_reg_memba:
	andcmb 1,(2)
	popj 17,

uandcmb_reg_membb:
	andcmb 1,(2)
	popj 17,

