
trc_small:
	xori 1,123456
	popj 17,

trc_one:
	xori 1,1
	popj 17,

trc_highbit:
	xori 1,400000
	popj 17,

trc_all_right:
	xori 1,777777
	popj 17,

trc_alt1:
	xori 1,525252
	popj 17,

trc_alt2:
	xori 1,252525
	popj 17,

trc_sparse:
	xori 1,707070
	popj 17,

trc_sign_low:
	xori 1,400001
	popj 17,

trc_maxpos:
	xori 1,377777
	popj 17,

trc_from_mem:
	move 1,(1)
	xori 1,123456
	popj 17,

trc_global:
	move 1,trc_ga
	xori 1,123456
	popj 17,

trc_array:
	andi 2,17
	add 1,2
	move 1,(1)
	xori 1,123456
	popj 17,

trc_global_array:
	andi 1,17
	move 1,trc_buf(1)
	xori 1,123456
	popj 17,

trc_struct_a:
	move 1,(1)
	xori 1,123456
	popj 17,

trc_struct_b:
	move 1,1(1)
	xori 1,525252
	popj 17,

trc_global_struct_a:
	move 1,trc_gp
	xori 1,123456
	popj 17,

trc_global_struct_b:
	move 1,trc_gp+1
	xori 1,525252
	popj 17,

trc_indirect:
	move 1,@(1)
	xori 1,123456
	popj 17,

trc_volatile_load:
	move 1,(1)
	xori 1,123456
	popj 17,

trc_store:
	xori 2,123456
	movem 2,(1)
	popj 17,

trc_store_alt:
	xori 2,525252
	movem 2,(1)
	popj 17,

trc_store_global:
	xori 1,123456
	movem 1,trc_ga
	popj 17,

trc_update_mem:
	movei 6,123456
	xorm 6,(1)
	popj 17,

trc_update_global:
	movei 6,123456
	xorm 6,trc_ga
	popj 17,

trc_update_array:
	andi 2,17
	add 1,2
	movei 6,123456
	xorm 6,(1)
	popj 17,

trc_update_global_array:
	andi 1,17
	movei 6,123456
	xorm 6,trc_buf(1)
	popj 17,

trc_update_struct_a:
	movei 6,123456
	xorm 6,(1)
	popj 17,

trc_update_struct_b:
	movei 6,525252
	xorm 6,1(1)
	popj 17,

trc_update_return:
	move 4,(1)
	xori 4,123456
	movem 4,(1)
	move 1,4
	popj 17,

trc_global_update_return:
	move 1,trc_ga
	xori 1,123456
	movem 1,trc_ga
	popj 17,

trc_volatile_store:
	xori 2,123456
	movem 2,(1)
	popj 17,

trc_volatile_update:
	move 4,(1)
	xori 4,123456
	movem 4,(1)
	popj 17,

trce_clear:
	move 4,1
	xori 4,123456
	trne 1,123456
	movei 4,0
	move 1,4
	popj 17,

trce_select:
	move 4,1
	xori 4,123456
	add 2,4
	trne 1,123456
	jrst %L38
	move 2,3
	add 2,4
%L38:
	move 1,2
	popj 17,

trce_call:
	push 17,10
	move 10,1
	xori 10,123456
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

trce_likely:
	move 4,1
	xori 4,123456
	trne 1,123456
	movei 4,0
	move 1,4
	popj 17,

trce_unlikely:
	move 4,1
	xori 4,123456
	trne 1,123456
	jrst %L47
%L46:
	move 1,4
	popj 17,
%L47:
	movei 4,0
	jrst %L46

trce_highbit:
	move 4,1
	xori 4,400000
	trne 1,400000
	movei 4,0
	move 1,4
	popj 17,

trce_all:
	move 4,1
	xori 4,777777
	hrrz 1,1
	jumpe 1,%L51
	movei 4,0
%L51:
	move 1,4
	popj 17,

trce_alt:
	move 4,1
	xori 4,525252
	trne 1,525252
	movei 4,0
	move 1,4
	popj 17,

trcn_clear:
	move 4,1
	xori 4,123456
	trnn 1,123456
	movei 4,0
	move 1,4
	popj 17,

trcn_select:
	move 4,1
	xori 4,123456
	add 2,4
	trnn 1,123456
	jrst %L56
	move 2,3
	add 2,4
%L56:
	move 1,2
	popj 17,

trcn_call:
	push 17,10
	move 10,1
	xori 10,123456
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

trcn_likely:
	move 4,1
	xori 4,123456
	trnn 1,123456
	movei 4,0
	move 1,4
	popj 17,

trcn_unlikely:
	move 4,1
	xori 4,123456
	trnn 1,123456
	jrst %L65
%L64:
	move 1,4
	popj 17,
%L65:
	movei 4,0
	jrst %L64

trcn_highbit:
	move 4,1
	xori 4,400000
	trnn 1,400000
	movei 4,0
	move 1,4
	popj 17,

trcn_all:
	move 4,1
	xori 4,777777
	hrrz 1,1
	jumpn 1,%L69
	movei 4,0
%L69:
	move 1,4
	popj 17,

trcn_alt:
	move 4,1
	xori 4,525252
	trnn 1,525252
	movei 4,0
	move 1,4
	popj 17,

trca_goto:
	xori 1,123456
%L73:
	popj 17,

trca_select:
	xori 1,123456
%L76:
	popj 17,

trca_call:
	push 17,10
	move 10,1
	xori 10,123456
%L78:
	pushj 17,f
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

trc_chain:
	xori 1,406604
	popj 17,

trc_chain_same:
	popj 17,

trc_mix_add:
	xori 1,123456
	add 1,2
	popj 17,

trc_mix_and:
	xori 1,123456
	and 1,2
	popj 17,

trc_mix_or:
	xori 1,123456
	ior 1,2
	popj 17,

trc_mix_sub:
	xori 1,123456
	sub 1,2
	popj 17,

trc_two_tests:
	xori 1,123456
	trne 1,525252
	xori 1,525252
	popj 17,

trc_from_expr:
	add 1,2
	xori 1,123456
	popj 17,

trc_from_xor_expr:
	xor 1,2
	xori 1,123456
	popj 17,

utrc_small:
	xori 1,123456
	popj 17,

utrc_highbit:
	xori 1,400000
	popj 17,

utrc_all_right:
	xori 1,777777
	popj 17,

utrc_from_mem:
	move 1,(1)
	xori 1,123456
	popj 17,

utrc_store:
	xori 2,123456
	movem 2,(1)
	popj 17,

utrc_update_mem:
	movei 6,123456
	xorm 6,(1)
	popj 17,

utrc_update_global:
	movei 6,123456
	xorm 6,trc_uga
	popj 17,

utrc_update_return:
	move 4,(1)
	xori 4,123456
	movem 4,(1)
	move 1,4
	popj 17,

utrce_bool:
	move 4,1
	xori 4,123456
	skipe 4
	movei 4,1
	trnn 1,123456
	movei 4,0
	move 1,4
	popj 17,

utrcn_bool:
	move 4,1
	xori 4,123456
	skipe 4
	movei 4,1
	trne 1,123456
	movei 4,0
	move 1,4
	popj 17,

trc_qi_promote:
	andi 1,777	; zero_extendqisi2
	xori 1,123456
	popj 17,

trc_hi_promote:
	hrrzi 1,(1)	; zero_extendhisi2
	xori 1,123456
	popj 17,

	.bss
trc_ga:
	.space	4
trc_uga:
	.space	4
trc_buf:
	.space	64
trc_gp:
	.space	8
