
orca_reg_reg:
	orca 1,2
	popj 17,

orca_reg_mem:
	orca 1,(2)
	popj 17,

orca_mem_reg:
	orca 2,(1)
	move 1,2
	popj 17,

orca_mem_mem:
	move 1,(1)
	orca 1,(2)
	popj 17,

orca_global_a:
	orca 1,orca_ga
	popj 17,

orca_global_b:
	move 1,orca_ga
	orca 1,orca_gb
	popj 17,

orca_array:
	andi 2,17
	add 1,2
	orca 3,(1)
	move 1,3
	popj 17,

orca_global_array:
	andi 1,17
	orca 2,orca_buf(1)
	move 1,2
	popj 17,

orca_struct_a:
	orca 2,(1)
	move 1,2
	popj 17,

orca_struct_b:
	orca 2,1(1)
	move 1,2
	popj 17,

orca_global_struct_a:
	orca 1,orca_gp
	popj 17,

orca_global_struct_b:
	orca 1,orca_gp+1
	popj 17,

orcai_small:
	orcai 1,123456
	popj 17,

orcai_zero:
	setca 1,
	popj 17,

orcai_one:
	orcai 1,1
	popj 17,

orcai_low9:
	orcai 1,777
	popj 17,

orcai_low18:
	orcai 1,777777
	popj 17,

orca_literal:
	move 6,[123456123456]
	orca 1,6
	popj 17,

orca_literal_left:
	move 6,[123456123456]
	orca 1,6
	popj 17,

orca_sparse:
	move 6,[-252525525253]
	orca 1,6
	popj 17,

orca_left_half:
	orcbi 1,777777
	popj 17,

orca_right_half:
	orcai 1,777777
	popj 17,

orca_high_ones_low_const:
	orcbi 1,765432
	popj 17,

orca_low_ones_high_const:
	hrloi 6,123456
	orca 1,6
	popj 17,

orca_sign_bit:
	movsi 6,400000
	orca 1,6
	popj 17,

orca_clear_sign_mask:
	hrloi 6,377777
	orca 1,6
	popj 17,

orca_all_ones:
	seto 1,
	popj 17,

orcam_reg_mem:
	orcam 1,(2)
	popj 17,

orcam_assign:
	orcam 1,(2)
	popj 17,

orcam_const:
	hrroi 6,654321
	iorm 6,(1)
	popj 17,

orcam_global:
	orcam 1,orca_ga
	popj 17,

orcam_global_2:
	orcam 1,orca_gb
	popj 17,

orcam_array:
	andi 2,17
	add 1,2
	orcam 3,(1)
	popj 17,

orcam_global_array:
	andi 1,17
	orcam 2,orca_buf(1)
	popj 17,

orcam_struct_a:
	orcam 2,(1)
	popj 17,

orcam_struct_b:
	orcam 2,1(1)
	popj 17,

orcam_then_load:
	orcab 1,(2)
	popj 17,

orca_assign_local:
	andca 2,1
	ior 3,2
	move 1,3
	popj 17,

uorca_reg_reg:
	orca 1,2
	popj 17,

uorca_reg_mem:
	orca 1,(2)
	popj 17,

uorcai_small:
	orcai 1,123456
	popj 17,

uorcai_low18:
	orcai 1,777777
	popj 17,

uorca_literal:
	move 6,[123456123456]
	orca 1,6
	popj 17,

uorca_left_half:
	orcbi 1,777777
	popj 17,

uorca_right_half:
	orcai 1,777777
	popj 17,

uorca_high_ones_low_const:
	orcbi 1,765432
	popj 17,

uorca_low_ones_high_const:
	hrloi 6,123456
	orca 1,6
	popj 17,

orca_qi_promote:
	lsh 1,33
	ash 1,-33
	lsh 2,33
	ash 2,-33
	orca 1,2
	popj 17,

uorca_qi_promote:
	andi 2,777	; zero_extendqisi2
	orcbi 1,777
	ior 2,1
	move 1,2
	popj 17,

orca_hi_promote:
	hrre 1,1
	hrre 2,2
	orca 1,2
	popj 17,

uorca_hi_promote:
	orcbi 1,777777
	iori 1,(2)
	popj 17,

orca_qi_mask:
	seto 1,
	popj 17,

orca_hi_mask:
	seto 1,
	popj 17,

orca_volatile_mem:
	move 4,(2)
	orca 1,4
	popj 17,

orcam_volatile_mem:
	move 4,(2)
	orca 1,4
	movem 1,(2)
	popj 17,

orcai_reg_form:
	hrrz 1,1
	orca 2,1
	move 1,2
	popj 17,

orcai_reg_plus_form:
	movei 1,1234(1)
	orca 2,1
	move 1,2
	popj 17,

orca_left_shift_form:
	hrlz 1,1
	orca 2,1
	move 1,2
	popj 17,

orca_left_shift_plus_form:
	movei 1,1234(1)
	hrlz 1,1
	orca 2,1
	move 1,2
	popj 17,

orca_chain:
	orca 1,2
	orca 2,3
	xor 1,2
	popj 17,

orca_nested:
	andca 2,1
	ior 2,3
	move 1,2
	popj 17,

orcab_reg_memaa:
	orcab 1,(2)
	popj 17,

orcab_reg_memab:
	orcab 1,(2)
	popj 17,

orcab_reg_memba:
	orcab 1,(2)
	popj 17,

orcab_reg_membb:
	orcab 1,(2)
	popj 17,

orcab_mem_regaa:
	orcab 1,(2)
	popj 17,

orcab_mem_regab:
	orcab 1,(2)
	popj 17,

orcab_mem_regba:
	orcab 1,(2)
	popj 17,

orcab_mem_regbb:
	orcab 1,(2)
	popj 17,

uorcab_reg_memaa:
	orcab 1,(2)
	popj 17,

uorcab_reg_memab:
	orcab 1,(2)
	popj 17,

uorcab_reg_memba:
	orcab 1,(2)
	popj 17,

uorcab_reg_membb:
	orcab 1,(2)
	popj 17,

	.bss
orca_ga:
	.space	4
orca_gb:
	.space	4
orca_buf:
	.space	64
orca_gp:
	.space	8
