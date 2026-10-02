
tro_small:
	iori 1,123456
	popj 17,

tro_one:
	iori 1,1
	popj 17,

tro_highbit:
	iori 1,400000
	popj 17,

tro_all_right:
	hllo 1,1
	popj 17,

tro_alt1:
	iori 1,525252
	popj 17,

tro_alt2:
	iori 1,252525
	popj 17,

tro_sparse:
	iori 1,707070
	popj 17,

tro_sign_low:
	iori 1,400001
	popj 17,

tro_maxpos:
	iori 1,377777
	popj 17,

tro_from_mem:
	move 1,(1)
	iori 1,123456
	popj 17,

tro_global:
	move 1,tro_ga
	iori 1,123456
	popj 17,

tro_array:
	andi 2,17
	add 1,2
	move 1,(1)
	iori 1,123456
	popj 17,

tro_global_array:
	andi 1,17
	move 1,tro_buf(1)
	iori 1,123456
	popj 17,

tro_struct_a:
	move 1,(1)
	iori 1,123456
	popj 17,

tro_struct_b:
	move 1,1(1)
	iori 1,525252
	popj 17,

tro_global_struct_a:
	move 1,tro_gp
	iori 1,123456
	popj 17,

tro_global_struct_b:
	move 1,tro_gp+1
	iori 1,525252
	popj 17,

tro_indirect:
	move 1,@(1)
	iori 1,123456
	popj 17,

tro_volatile_load:
	move 1,(1)
	iori 1,123456
	popj 17,

tro_store:
	iori 2,123456
	movem 2,(1)
	popj 17,

tro_store_alt:
	iori 2,525252
	movem 2,(1)
	popj 17,

tro_store_global:
	iori 1,123456
	movem 1,tro_ga
	popj 17,

tro_update_mem:
	movei 6,123456
	iorm 6,(1)
	popj 17,

tro_update_global:
	movei 6,123456
	iorm 6,tro_ga
	popj 17,

tro_update_array:
	andi 2,17
	add 1,2
	movei 6,123456
	iorm 6,(1)
	popj 17,

tro_update_global_array:
	andi 1,17
	movei 6,123456
	iorm 6,tro_buf(1)
	popj 17,

tro_update_struct_a:
	movei 6,123456
	iorm 6,(1)
	popj 17,

tro_update_struct_b:
	movei 6,525252
	iorm 6,1(1)
	popj 17,

tro_update_return:
	move 4,(1)
	iori 4,123456
	movem 4,(1)
	move 1,4
	popj 17,

tro_global_update_return:
	move 1,tro_ga
	iori 1,123456
	movem 1,tro_ga
	popj 17,

tro_volatile_store:
	iori 2,123456
	movem 2,(1)
	popj 17,

tro_volatile_update:
	move 4,(1)
	iori 4,123456
	movem 4,(1)
	popj 17,

troe_clear:
	move 4,1
	iori 4,123456
	trne 1,123456
	movei 4,0
	move 1,4
	popj 17,

troe_select:
	move 4,1
	iori 4,123456
	add 2,4
	trne 1,123456
	jrst %L38
	move 2,3
	add 2,4
%L38:
	move 1,2
	popj 17,

troe_call:
	push 17,10
	move 10,1
	iori 10,123456
	trne 1,123456
	jrst %L42
%L41:
	move 1,10
	pop 17,10
	popj 17,
%L42:
	pushj 17,f
	add 10,1
	jrst %L41

troe_likely:
	move 4,1
	iori 4,123456
	trne 1,123456
	movei 4,0
	move 1,4
	popj 17,

troe_unlikely:
	move 4,1
	iori 4,123456
	trne 1,123456
	jrst %L47
%L46:
	move 1,4
	popj 17,
%L47:
	movei 4,0
	jrst %L46

troe_highbit:
	move 4,1
	iori 4,400000
	trne 1,400000
	movei 4,0
	move 1,4
	popj 17,

troe_all:
	hllo 4,1
	hrrz 1,1
	jumpe 1,%L51
	movei 4,0
%L51:
	move 1,4
	popj 17,

troe_alt:
	move 4,1
	iori 4,525252
	trne 1,525252
	movei 4,0
	move 1,4
	popj 17,

tron_clear:
	move 4,1
	iori 4,123456
	trnn 1,123456
	movei 4,0
	move 1,4
	popj 17,

tron_select:
	move 4,1
	iori 4,123456
	add 2,4
	trnn 1,123456
	jrst %L56
	move 2,3
	add 2,4
%L56:
	move 1,2
	popj 17,

tron_call:
	push 17,10
	move 10,1
	iori 10,123456
	trnn 1,123456
	jrst %L60
%L59:
	move 1,10
	pop 17,10
	popj 17,
%L60:
	pushj 17,f
	add 10,1
	jrst %L59

tron_likely:
	move 4,1
	iori 4,123456
	trnn 1,123456
	movei 4,0
	move 1,4
	popj 17,

tron_unlikely:
	move 4,1
	iori 4,123456
	trnn 1,123456
	jrst %L65
%L64:
	move 1,4
	popj 17,
%L65:
	movei 4,0
	jrst %L64

tron_highbit:
	move 4,1
	iori 4,400000
	trnn 1,400000
	movei 4,0
	move 1,4
	popj 17,

tron_all:
	hllo 4,1
	hrrz 1,1
	jumpn 1,%L69
	movei 4,0
%L69:
	move 1,4
	popj 17,

tron_alt:
	move 4,1
	iori 4,525252
	trnn 1,525252
	movei 4,0
	move 1,4
	popj 17,

troa_goto:
	iori 1,123456
%L73:
	popj 17,

troa_select:
	iori 1,123456
%L76:
	popj 17,

troa_call:
	push 17,10
	move 10,1
	iori 10,123456
%L78:
	pushj 17,f
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

tro_chain:
	iori 1,527656
	popj 17,

tro_chain_same:
	iori 1,123456
	popj 17,

tro_mix_add:
	iori 1,123456
	add 1,2
	popj 17,

tro_mix_and:
	iori 1,123456
	and 1,2
	popj 17,

tro_mix_xor:
	iori 1,123456
	xor 1,2
	popj 17,

tro_mix_sub:
	iori 1,123456
	sub 1,2
	popj 17,

tro_two_tests:
	iori 1,123456
	trne 1,525252
	iori 1,525252
	popj 17,

tro_from_expr:
	add 1,2
	iori 1,123456
	popj 17,

tro_from_xor_expr:
	xor 1,2
	iori 1,123456
	popj 17,

utro_small:
	iori 1,123456
	popj 17,

utro_highbit:
	iori 1,400000
	popj 17,

utro_all_right:
	hllo 1,1
	popj 17,

utro_from_mem:
	move 1,(1)
	iori 1,123456
	popj 17,

utro_store:
	iori 2,123456
	movem 2,(1)
	popj 17,

utro_update_mem:
	movei 6,123456
	iorm 6,(1)
	popj 17,

utro_update_global:
	movei 6,123456
	iorm 6,tro_uga
	popj 17,

utro_update_return:
	move 4,(1)
	iori 4,123456
	movem 4,(1)
	move 1,4
	popj 17,

utroe_bool:
	andi 1,123456
	skipe 1
	movei 1,1
	popj 17,

utron_bool:
	andi 1,123456
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

tro_qi_promote:
	andi 1,777	; zero_extendqisi2
	iori 1,123456
	popj 17,

tro_hi_promote:
	hrrzi 1,(1)	; zero_extendhisi2
	iori 1,123456
	popj 17,

	.bss
tro_ga:
	.space	4
tro_uga:
	.space	4
tro_buf:
	.space	64
tro_gp:
	.space	8
