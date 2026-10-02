
orcm_reg_reg:
	orca 2,1
	move 1,2
	popj 17,

orcm_reg_mem:
	orcm 1,(2)
	popj 17,

orcm_mem_reg:
	orcm 2,(1)
	move 1,2
	popj 17,

orcm_mem_mem:
	move 1,(1)
	orcm 1,(2)
	popj 17,

orcm_commuted_reg_reg:
	orca 2,1
	move 1,2
	popj 17,

orcm_commuted_reg_mem:
	orcm 1,(2)
	popj 17,

orcm_global_a:
	orcm 1,orcm_ga
	popj 17,

orcm_global_b:
	move 1,orcm_gb
	orca 1,orcm_ga
	popj 17,

orcm_array:
	andi 2,17
	add 1,2
	orcm 3,(1)
	move 1,3
	popj 17,

orcm_global_array:
	andi 1,17
	orcm 2,orcm_buf(1)
	move 1,2
	popj 17,

orcm_struct_a:
	orcm 2,(1)
	move 1,2
	popj 17,

orcm_struct_b:
	orcm 2,1(1)
	move 1,2
	popj 17,

orcm_global_struct_a:
	orcm 1,orcm_gp
	popj 17,

orcm_global_struct_b:
	orcm 1,orcm_gp+1
	popj 17,

orcmi_small:
	orcmi 1,123456
	popj 17,

orcmi_zero:
	seto 1,
	popj 17,

orcmi_one:
	orcmi 1,1
	popj 17,

orcmi_low9:
	orcmi 1,777
	popj 17,

orcmi_low18:
	hrro 1,1
	popj 17,

orcm_literal:
	ior 1,[-123456123457]
	popj 17,

orcm_literal_commuted:
	ior 1,[-123456123457]
	popj 17,

orcm_sparse:
	ior 1,[252525525252]
	popj 17,

orcm_left_half:
	hllo 1,1
	popj 17,

orcm_right_half:
	hrro 1,1
	popj 17,

orcm_high_ones_low_const:
	iori 1,765432
	popj 17,

orcm_low_ones_high_const:
	tlo 1,654321
	popj 17,

orcm_sign_bit:
	ior 1,[377777777777]
	popj 17,

orcm_clear_sign_mask:
	tlo 1,400000
	popj 17,

orcm_all_ones:
	popj 17,

orcmm_reg_mem:
	orcmm 1,(2)
	popj 17,

orcmm_assign:
	orcmm 1,(2)
	popj 17,

orcmm_const:
	movei 6,123456
	orcmm 6,(1)
	popj 17,

orcmm_global:
	orcmm 1,orcm_ga
	popj 17,

orcmm_global_2:
	orcmm 1,orcm_gb
	popj 17,

orcmm_array:
	andi 2,17
	add 1,2
	orcmm 3,(1)
	popj 17,

orcmm_global_array:
	andi 1,17
	orcmm 2,orcm_buf(1)
	popj 17,

orcmm_struct_a:
	orcmm 2,(1)
	popj 17,

orcmm_struct_b:
	orcmm 2,1(1)
	popj 17,

orcmm_then_load:
	orcmb 1,(2)
	popj 17,

orcm_assign_local:
	orca 2,1
	orca 3,2
	move 1,3
	popj 17,

uorcm_reg_reg:
	orca 2,1
	move 1,2
	popj 17,

uorcm_reg_mem:
	orcm 1,(2)
	popj 17,

uorcmi_small:
	orcmi 1,123456
	popj 17,

uorcmi_low18:
	hrro 1,1
	popj 17,

uorcm_literal:
	ior 1,[-123456123457]
	popj 17,

uorcm_left_half:
	hllo 1,1
	popj 17,

uorcm_right_half:
	hrro 1,1
	popj 17,

uorcm_high_ones_low_const:
	iori 1,765432
	popj 17,

uorcm_low_ones_high_const:
	tlo 1,654321
	popj 17,

orcm_qi_promote:
	lsh 1,33
	ash 1,-33
	lsh 2,33
	ash 2,-33
	orca 2,1
	move 1,2
	popj 17,

uorcm_qi_promote:
	andi 1,777	; zero_extendqisi2
	orcbi 2,777
	ior 1,2
	popj 17,

orcm_hi_promote:
	hrre 1,1
	hrre 2,2
	orca 2,1
	move 1,2
	popj 17,

uorcm_hi_promote:
	orcbi 2,777777
	iori 2,(1)
	move 1,2
	popj 17,

orcm_qi_mask:
	orcmi 1,777
	popj 17,

orcm_hi_mask:
	hrro 1,1
	popj 17,

orcm_volatile_mem:
	move 4,1
	move 1,(2)
	orca 1,4
	popj 17,

orcmm_volatile_mem:
	move 4,(2)
	orca 4,1
	movem 4,(2)
	popj 17,

orcmi_reg_form:
	orcmi 2,(1)
	move 1,2
	popj 17,

orcmi_reg_plus_form:
	orcmi 2,1234(1)
	move 1,2
	popj 17,

orcm_left_shift_form:
	hrlz 1,1
	orca 1,2
	popj 17,

orcm_left_shift_plus_form:
	movei 1,1234(1)
	hrlz 1,1
	orca 1,2
	popj 17,

orcm_chain:
	orcm 1,2
	orca 3,2
	xor 1,3
	popj 17,

orcm_nested:
	andca 1,2
	ior 1,3
	popj 17,

orcmb_reg_memaa:
	orcmb 1,(2)
	popj 17,

orcmb_reg_memab:
	orcmb 1,(2)
	popj 17,

orcmb_reg_memba:
	orcmb 1,(2)
	popj 17,

orcmb_reg_membb:
	orcmb 1,(2)
	popj 17,

orcmb_mem_regaa:
	orcmb 1,(2)
	popj 17,

orcmb_mem_regab:
	orcmb 1,(2)
	popj 17,

orcmb_mem_regba:
	orcmb 1,(2)
	popj 17,

orcmb_mem_regbb:
	orcmb 1,(2)
	popj 17,

uorcmb_reg_memaa:
	orcmb 1,(2)
	popj 17,

uorcmb_reg_memab:
	orcmb 1,(2)
	popj 17,

uorcmb_reg_memba:
	orcmb 1,(2)
	popj 17,

uorcmb_reg_membb:
	orcmb 1,(2)
	popj 17,

	.bss
orcm_ga:
	.space	4
orcm_gb:
	.space	4
orcm_buf:
	.space	64
orcm_gp:
	.space	8
