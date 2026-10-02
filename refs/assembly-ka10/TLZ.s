
tlz_small:
	tlz 1,654321
	popj 17,

tlz_clear_one_left:
	tlz 1,1
	popj 17,

tlz_clear_highbit:
	tlz 1,400000
	popj 17,

tlz_clear_all_left:
	hrrz 1,1
	popj 17,

tlz_alt1:
	tlz 1,252525
	popj 17,

tlz_alt2:
	tlz 1,525252
	popj 17,

tlz_sparse:
	tlz 1,70707
	popj 17,

tlz_sign_and_low:
	tlz 1,377776
	popj 17,

tlz_max_positive_left:
	tlz 1,400000
	popj 17,

tlz_from_mem:
	move 1,(1)
	tlz 1,654321
	popj 17,

tlz_global:
	move 1,tlz_ga
	tlz 1,654321
	popj 17,

tlz_array:
	andi 2,17
	add 1,2
	move 1,(1)
	tlz 1,654321
	popj 17,

tlz_global_array:
	andi 1,17
	move 1,tlz_buf(1)
	tlz 1,654321
	popj 17,

tlz_struct_a:
	move 1,(1)
	tlz 1,654321
	popj 17,

tlz_struct_b:
	move 1,1(1)
	tlz 1,252525
	popj 17,

tlz_global_struct_a:
	move 1,tlz_gp
	tlz 1,654321
	popj 17,

tlz_global_struct_b:
	move 1,tlz_gp+1
	tlz 1,252525
	popj 17,

tlz_store:
	tlz 2,654321
	movem 2,(1)
	popj 17,

tlz_store_alt:
	tlz 2,252525
	movem 2,(1)
	popj 17,

tlz_store_global:
	tlz 1,654321
	movem 1,tlz_ga
	popj 17,

tlz_update_mem:
	hrloi 6,123456
	andm 6,(1)
	popj 17,

tlz_update_global:
	hrloi 6,123456
	andm 6,tlz_ga
	popj 17,

tlz_update_array:
	andi 2,17
	add 1,2
	hrloi 6,123456
	andm 6,(1)
	popj 17,

tlz_update_global_array:
	andi 1,17
	hrloi 6,123456
	andm 6,tlz_buf(1)
	popj 17,

tlz_update_struct_a:
	hrloi 6,123456
	andm 6,(1)
	popj 17,

tlz_update_struct_b:
	hrloi 6,525252
	andm 6,1(1)
	popj 17,

tlz_update_return:
	move 4,(1)
	tlz 4,654321
	movem 4,(1)
	move 1,4
	popj 17,

tlz_global_update_return:
	move 1,tlz_ga
	tlz 1,654321
	movem 1,tlz_ga
	popj 17,

tlz_chain:
	tlz 1,656725
	popj 17,

tlz_chain_same:
	tlz 1,654321
	popj 17,

tlz_mix_add:
	tlz 1,654321
	add 1,2
	popj 17,

tlz_mix_or:
	tlz 1,654321
	ior 1,2
	popj 17,

tlz_mix_xor:
	tlz 1,654321
	xor 1,2
	popj 17,

tlz_mix_sub:
	tlz 1,654321
	sub 1,2
	popj 17,

utlz_small:
	tlz 1,654321
	popj 17,

utlz_clear_all_left:
	hrrz 1,1
	popj 17,

utlz_clear_highbit:
	tlz 1,400000
	popj 17,

utlz_from_mem:
	move 1,(1)
	tlz 1,654321
	popj 17,

utlz_store:
	tlz 2,654321
	movem 2,(1)
	popj 17,

utlz_update_mem:
	hrloi 6,123456
	andm 6,(1)
	popj 17,

utlz_update_global:
	hrloi 6,123456
	andm 6,tlz_uga
	popj 17,

tlz_qi_promote:
	andi 1,777	; zero_extendqisi2
	popj 17,

tlz_hi_promote:
	hrrzi 1,(1)	; zero_extendhisi2
	popj 17,

tlz_volatile_store:
	tlz 2,654321
	movem 2,(1)
	popj 17,

tlz_volatile_load:
	move 1,(1)
	tlz 1,654321
	popj 17,

	.bss
tlz_ga:
	.space	4
tlz_uga:
	.space	4
tlz_buf:
	.space	64
tlz_gp:
	.space	8
