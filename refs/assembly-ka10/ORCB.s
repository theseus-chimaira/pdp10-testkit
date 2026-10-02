
orcb_reg_reg:
	orcb 1,2
	popj 17,

orcb_reg_mem:
	orcb 1,(2)
	popj 17,

orcb_mem_reg:
	orcb 2,(1)
	move 1,2
	popj 17,

orcb_mem_mem:
	move 1,(1)
	orcb 1,(2)
	popj 17,

orcb_global_a:
	orcb 1,orcb_ga
	popj 17,

orcb_global_b:
	move 1,orcb_ga
	orcb 1,orcb_gb
	popj 17,

orcb_array:
	andi 2,17
	add 1,2
	orcb 3,(1)
	move 1,3
	popj 17,

orcb_global_array:
	andi 1,17
	orcb 2,orcb_buf(1)
	move 1,2
	popj 17,

orcb_struct_a:
	orcb 2,(1)
	move 1,2
	popj 17,

orcb_struct_b:
	orcb 2,1(1)
	move 1,2
	popj 17,

orcb_global_struct_a:
	orcb 1,orcb_gp
	popj 17,

orcb_global_struct_b:
	orcb 1,orcb_gp+1
	popj 17,

orcbi_small:
	orcbi 1,123456
	popj 17,

orcbi_zero:
	seto 1,
	popj 17,

orcbi_one:
	orcbi 1,1
	popj 17,

orcbi_low9:
	orcbi 1,777
	popj 17,

orcbi_low18:
	orcbi 1,777777
	popj 17,

orcb_literal:
	move 6,[-123456123457]
	orca 1,6
	popj 17,

orcb_literal_left:
	move 6,[-123456123457]
	orca 1,6
	popj 17,

orcb_sparse:
	move 6,[252525525252]
	orca 1,6
	popj 17,

orcb_left_half:
	orcai 1,777777
	popj 17,

orcb_right_half:
	orcbi 1,777777
	popj 17,

orcb_high_ones_low_const:
	orcai 1,765432
	popj 17,

orcb_low_ones_high_const:
	movsi 6,654321
	orca 1,6
	popj 17,

orcb_sign_bit:
	hrloi 6,377777
	orca 1,6
	popj 17,

orcb_clear_sign_mask:
	movsi 6,400000
	orca 1,6
	popj 17,

orcb_all_ones:
	setca 1,
	popj 17,

orcbm_reg_mem:
	orcbm 1,(2)
	popj 17,

orcbm_assign:
	orcbm 1,(2)
	popj 17,

orcbm_const:
	hrroi 6,654321
	orcmm 6,(1)
	popj 17,

orcbm_global:
	orcbm 1,orcb_ga
	popj 17,

orcbm_global_2:
	orcbm 1,orcb_gb
	popj 17,

orcbm_array:
	andi 2,17
	add 1,2
	orcbm 3,(1)
	popj 17,

orcbm_global_array:
	andi 1,17
	orcbm 2,orcb_buf(1)
	popj 17,

orcbm_struct_a:
	orcbm 2,(1)
	popj 17,

orcbm_struct_b:
	orcbm 2,1(1)
	popj 17,

orcbm_then_load:
	orcbb 1,(2)
	popj 17,

orcb_assign_local:
	orcb 2,1
	orcb 3,2
	move 1,3
	popj 17,

uorcb_reg_reg:
	orcb 1,2
	popj 17,

uorcb_reg_mem:
	orcb 1,(2)
	popj 17,

uorcbi_small:
	orcbi 1,123456
	popj 17,

uorcbi_low18:
	orcbi 1,777777
	popj 17,

uorcb_literal:
	move 6,[-123456123457]
	orca 1,6
	popj 17,

uorcb_left_half:
	orcai 1,777777
	popj 17,

uorcb_right_half:
	orcbi 1,777777
	popj 17,

uorcb_high_ones_low_const:
	orcai 1,765432
	popj 17,

uorcb_low_ones_high_const:
	movsi 6,654321
	orca 1,6
	popj 17,

orcb_qi_promote:
	and 2,1
	lsh 2,33
	ash 2,-33
	setca 2,
	move 1,2
	popj 17,

uorcb_qi_promote:
	and 2,1
	orcbi 2,777
	move 1,2
	popj 17,

orcb_hi_promote:
	and 2,1
	hrre 2,2
	setca 2,
	move 1,2
	popj 17,

uorcb_hi_promote:
	hrrzi 2,(2)	; zero_extendhisi2
	orcbi 2,(1)
	move 1,2
	popj 17,

orcb_qi_mask:
	orcbi 1,777
	popj 17,

orcb_hi_mask:
	orcbi 1,777777
	popj 17,

orcb_volatile_mem:
	move 4,1
	move 1,(2)
	orcb 1,4
	popj 17,

orcbm_volatile_mem:
	move 4,(2)
	orcb 4,1
	movem 4,(2)
	popj 17,

orcbi_reg_form:
	orcbi 2,(1)
	move 1,2
	popj 17,

orcbi_reg_plus_form:
	orcbi 2,1234(1)
	move 1,2
	popj 17,

orcb_left_shift_form:
	hrlz 1,1
	orcb 1,2
	popj 17,

orcb_left_shift_plus_form:
	movei 1,1234(1)
	hrlz 1,1
	orcb 1,2
	popj 17,

orcb_chain:
	orcb 1,2
	orcb 2,3
	xor 1,2
	popj 17,

orcb_nested:
	and 1,2
	orca 3,1
	move 1,3
	popj 17,

orcbb_reg_memaa:
	orcbb 1,(2)
	popj 17,

orcbb_reg_memab:
	orcbb 1,(2)
	popj 17,

orcbb_reg_memba:
	orcbb 1,(2)
	popj 17,

orcbb_reg_membb:
	orcbb 1,(2)
	popj 17,

orcbb_mem_regaa:
	orcbb 1,(2)
	popj 17,

orcbb_mem_regab:
	orcbb 1,(2)
	popj 17,

orcbb_mem_regba:
	orcbb 1,(2)
	popj 17,

orcbb_mem_regbb:
	orcbb 1,(2)
	popj 17,

uorcbb_reg_memaa:
	orcbb 1,(2)
	popj 17,

uorcbb_reg_memab:
	orcbb 1,(2)
	popj 17,

uorcbb_reg_memba:
	orcbb 1,(2)
	popj 17,

uorcbb_reg_membb:
	orcbb 1,(2)
	popj 17,

	.bss
orcb_ga:
	.space	4
orcb_gb:
	.space	4
orcb_buf:
	.space	64
orcb_gp:
	.space	8
