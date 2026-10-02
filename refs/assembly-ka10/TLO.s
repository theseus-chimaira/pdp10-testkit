
tlo_small:
	tlo 1,123456
	popj 17,

tlo_one:
	tlo 1,1
	popj 17,

tlo_highbit:
	tlo 1,400000
	popj 17,

tlo_all_left:
	hrro 1,1
	popj 17,

tlo_alt1:
	tlo 1,525252
	popj 17,

tlo_alt2:
	tlo 1,252525
	popj 17,

tlo_sparse:
	tlo 1,707070
	popj 17,

tlo_sign_and_low:
	tlo 1,400001
	popj 17,

tlo_max_positive_left:
	tlo 1,377777
	popj 17,

tlo_zero:
	popj 17,

tlo_from_mem:
	move 1,(1)
	tlo 1,123456
	popj 17,

tlo_global:
	move 1,tlo_ga
	tlo 1,123456
	popj 17,

tlo_array:
	andi 2,17
	add 1,2
	move 1,(1)
	tlo 1,123456
	popj 17,

tlo_global_array:
	andi 1,17
	move 1,tlo_buf(1)
	tlo 1,123456
	popj 17,

tlo_struct_a:
	move 1,(1)
	tlo 1,123456
	popj 17,

tlo_struct_b:
	move 1,1(1)
	tlo 1,525252
	popj 17,

tlo_global_struct_a:
	move 1,tlo_gp
	tlo 1,123456
	popj 17,

tlo_global_struct_b:
	move 1,tlo_gp+1
	tlo 1,525252
	popj 17,

tlo_store:
	tlo 2,123456
	movem 2,(1)
	popj 17,

tlo_store_alt:
	tlo 2,525252
	movem 2,(1)
	popj 17,

tlo_store_global:
	tlo 1,123456
	movem 1,tlo_ga
	popj 17,

tlo_update_mem:
	movsi 6,123456
	iorm 6,(1)
	popj 17,

tlo_update_global:
	movsi 6,123456
	iorm 6,tlo_ga
	popj 17,

tlo_update_array:
	andi 2,17
	add 1,2
	movsi 6,123456
	iorm 6,(1)
	popj 17,

tlo_update_global_array:
	andi 1,17
	movsi 6,123456
	iorm 6,tlo_buf(1)
	popj 17,

tlo_update_struct_a:
	movsi 6,123456
	iorm 6,(1)
	popj 17,

tlo_update_struct_b:
	movsi 6,525252
	iorm 6,1(1)
	popj 17,

tlo_update_return:
	move 4,(1)
	tlo 4,123456
	movem 4,(1)
	move 1,4
	popj 17,

tlo_global_update_return:
	move 1,tlo_ga
	tlo 1,123456
	movem 1,tlo_ga
	popj 17,

tlo_chain:
	tlo 1,527656
	popj 17,

tlo_chain_same:
	tlo 1,123456
	popj 17,

tlo_mix_add:
	tlo 1,123456
	add 1,2
	popj 17,

tlo_mix_and:
	tlo 1,123456
	and 1,2
	popj 17,

tlo_mix_xor:
	tlo 1,123456
	xor 1,2
	popj 17,

tlo_mix_sub:
	tlo 1,123456
	sub 1,2
	popj 17,

utlo_small:
	tlo 1,123456
	popj 17,

utlo_all_left:
	hrro 1,1
	popj 17,

utlo_highbit:
	tlo 1,400000
	popj 17,

utlo_from_mem:
	move 1,(1)
	tlo 1,123456
	popj 17,

utlo_store:
	tlo 2,123456
	movem 2,(1)
	popj 17,

utlo_update_mem:
	movsi 6,123456
	iorm 6,(1)
	popj 17,

utlo_update_global:
	movsi 6,123456
	iorm 6,tlo_uga
	popj 17,

tlo_qi_promote:
	andi 1,777	; zero_extendqisi2
	tlo 1,123456
	popj 17,

tlo_hi_promote:
	hrrzi 1,(1)	; zero_extendhisi2
	tlo 1,123456
	popj 17,

tlo_volatile_store:
	tlo 2,123456
	movem 2,(1)
	popj 17,

tlo_volatile_load:
	move 1,(1)
	tlo 1,123456
	popj 17,

	.bss
tlo_ga:
	.space	4
tlo_uga:
	.space	4
tlo_buf:
	.space	64
tlo_gp:
	.space	8
