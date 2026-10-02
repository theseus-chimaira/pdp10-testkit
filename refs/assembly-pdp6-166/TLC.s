
tlc_small:
	tlc 1,123456
	popj 17,

tlc_one:
	tlc 1,1
	popj 17,

tlc_lowbit:
	tlc 1,1
	popj 17,

tlc_highbit:
	tlc 1,400000
	popj 17,

tlc_all_left:
	tlc 1,777777
	popj 17,

tlc_alt1:
	tlc 1,525252
	popj 17,

tlc_alt2:
	tlc 1,252525
	popj 17,

tlc_sparse:
	tlc 1,707070
	popj 17,

tlc_sign_and_low:
	tlc 1,400001
	popj 17,

tlc_max_positive_left:
	tlc 1,377777
	popj 17,

tlc_zero:
	popj 17,

tlc_from_mem:
	move 1,(1)
	tlc 1,123456
	popj 17,

tlc_global:
	move 1,tlc_ga
	tlc 1,123456
	popj 17,

tlc_array:
	andi 2,17
	add 1,2
	move 1,(1)
	tlc 1,123456
	popj 17,

tlc_global_array:
	andi 1,17
	move 1,tlc_buf(1)
	tlc 1,123456
	popj 17,

tlc_struct_a:
	move 1,(1)
	tlc 1,123456
	popj 17,

tlc_struct_b:
	move 1,1(1)
	tlc 1,525252
	popj 17,

tlc_global_struct_a:
	move 1,tlc_gp
	tlc 1,123456
	popj 17,

tlc_global_struct_b:
	move 1,tlc_gp+1
	tlc 1,525252
	popj 17,

tlc_store:
	tlc 2,123456
	movem 2,(1)
	popj 17,

tlc_store_alt:
	tlc 2,525252
	movem 2,(1)
	popj 17,

tlc_store_global:
	tlc 1,123456
	movem 1,tlc_ga
	popj 17,

tlc_update_mem:
	movsi 6,123456
	xorm 6,(1)
	popj 17,

tlc_update_global:
	movsi 6,123456
	xorm 6,tlc_ga
	popj 17,

tlc_update_array:
	andi 2,17
	add 1,2
	movsi 6,123456
	xorm 6,(1)
	popj 17,

tlc_update_global_array:
	andi 1,17
	movsi 6,123456
	xorm 6,tlc_buf(1)
	popj 17,

tlc_update_struct_a:
	movsi 6,123456
	xorm 6,(1)
	popj 17,

tlc_update_struct_b:
	movsi 6,525252
	xorm 6,1(1)
	popj 17,

tlc_update_return:
	move 4,(1)
	tlc 4,123456
	movem 4,(1)
	move 1,4
	popj 17,

tlc_global_update_return:
	move 1,tlc_ga
	tlc 1,123456
	movem 1,tlc_ga
	popj 17,

tlc_chain:
	tlc 1,406604
	popj 17,

tlc_chain_same:
	popj 17,

tlc_mix_add:
	tlc 1,123456
	add 1,2
	popj 17,

tlc_mix_and:
	tlc 1,123456
	and 1,2
	popj 17,

tlc_mix_or:
	tlc 1,123456
	ior 1,2
	popj 17,

tlc_mix_xor:
	xor 1,2
	tlc 1,123456
	popj 17,

utlc_small:
	tlc 1,123456
	popj 17,

utlc_all_left:
	tlc 1,777777
	popj 17,

utlc_highbit:
	tlc 1,400000
	popj 17,

utlc_from_mem:
	move 1,(1)
	tlc 1,123456
	popj 17,

utlc_store:
	tlc 2,123456
	movem 2,(1)
	popj 17,

utlc_update_mem:
	movsi 6,123456
	xorm 6,(1)
	popj 17,

utlc_update_global:
	movsi 6,123456
	xorm 6,tlc_uga
	popj 17,

tlc_qi_promote:
	andi 1,777	; zero_extendqisi2
	tlc 1,123456
	popj 17,

tlc_hi_promote:
	hrrzi 1,(1)	; zero_extendhisi2
	tlc 1,123456
	popj 17,

tlc_volatile_store:
	tlc 2,123456
	movem 2,(1)
	popj 17,

tlc_volatile_load:
	move 1,(1)
	tlc 1,123456
	popj 17,

	.bss
tlc_ga:
	.space	4
tlc_uga:
	.space	4
tlc_buf:
	.space	64
tlc_gp:
	.space	8
