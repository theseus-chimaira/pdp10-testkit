
tlne_clear_small:
	tlne 1,123456
	movei 1,0
	popj 17,

tlne_clear_one:
	tlne 1,1
	movei 1,0
	popj 17,

tlne_clear_highbit:
	caige 1,0
	movei 1,0
	popj 17,

tlne_clear_all:
	tlne 1,777777
	movei 1,0
	popj 17,

tlne_clear_alt1:
	tlne 1,525252
	movei 1,0
	popj 17,

tlne_clear_alt2:
	tlne 1,252525
	movei 1,0
	popj 17,

tlne_clear_sparse:
	tlne 1,707070
	movei 1,0
	popj 17,

tlne_clear_sign_low:
	tlne 1,400001
	movei 1,0
	popj 17,

tlne_clear_maxpos:
	tlne 1,377777
	movei 1,0
	popj 17,

tlne_clear_likely_small:
	tlne 1,123456
	movei 1,0
	popj 17,

tlne_clear_likely_all:
	tlne 1,777777
	movei 1,0
	popj 17,

tlne_clear_likely_highbit:
	caige 1,0
	movei 1,0
	popj 17,

tlne_clear_unlikely_small:
	tlnn 1,123456
%L26:
	popj 17,
	movei 1,0
	popj 17,

tlne_clear_unlikely_all:
	tlnn 1,777777
%L29:
	popj 17,
	movei 1,0
	popj 17,

tlne_clear_unlikely_highbit:
	caige 1,0
	movei 1,0
	popj 17,

tlne_bool_small:
	and 1,[123456000000]
	skipe 1
	movei 1,1
	popj 17,

tlne_bool_one:
	ldb 1,[POINT 1,1,17]
	popj 17,

tlne_bool_highbit:
	lsh 1,-43
	popj 17,

tlne_bool_all:
	hllz 1,1
	skipe 1
	movei 1,1
	popj 17,

tlne_bool_alt1:
	and 1,[-252526000000]
	skipe 1
	movei 1,1
	popj 17,

tlne_select_small:
	tlnn 1,123456
	move 2,3
	move 1,2
	popj 17,

tlne_select_highbit:
	jumpl 1,%L40
	move 2,3
%L40:
	move 1,2
	popj 17,

tlne_select_all:
	tlnn 1,777777
	move 2,3
	move 1,2
	popj 17,

tlne_call_small:
	tlnn 1,123456
%L45:
	popj 17,
	pushj 17,f
	popj 17,

tlne_call_highbit:
	jumpl 1,%L49
%L48:
	popj 17,
%L49:
	pushj 17,f
	popj 17,

tlne_call_all:
	tlnn 1,777777
%L51:
	popj 17,
	pushj 17,f
	popj 17,

tlne_explicit_ne:
	tlne 1,123456
	movei 1,0
	popj 17,

tlne_explicit_ne_highbit:
	caige 1,0
	movei 1,0
	popj 17,

tlne_explicit_ne_all:
	tlne 1,777777
	movei 1,0
	popj 17,

tlne_branch_return:
	tlnn 1,123456
	move 2,3
	move 1,2
	popj 17,

tlne_branch_return_highbit:
	jumpl 1,%L61
	move 2,3
%L61:
	move 1,2
	popj 17,

tlne_branch_return_all:
	tlnn 1,777777
	move 2,3
	move 1,2
	popj 17,

tlne_store_global:
	tlne 1,123456
	movem 1,tlne_ga
	popj 17,

tlne_store_global_zero:
	tlne 1,123456
	setzm tlne_ga
	popj 17,

tlne_store_global_highbit:
	jumpge 1,%L70
	movem 1,tlne_ga
%L70:
	popj 17,

tlne_use_global:
	tlne 1,123456
	move 1,tlne_ga
	popj 17,

tlne_use_global_highbit:
	jumpge 1,%L74
	move 1,tlne_ga
%L74:
	popj 17,

tlne_mix_add:
	tlne 1,123456
	add 1,2
	popj 17,

tlne_mix_xor:
	tlne 1,123456
	xor 1,2
	popj 17,

tlne_mix_or:
	tlne 1,123456
	ior 1,2
	popj 17,

tlne_mix_and:
	tlne 1,123456
	and 1,2
	popj 17,

tlne_nested:
	tlnn 1,123456
	popj 17,
	movei 1,0
	trnn 2,1
	move 1,2
	popj 17,

tlne_two_tests:
	tlne 1,123456
	movei 1,0
	tlne 1,525252
	movei 1,1
	popj 17,

tlne_chain:
	tlne 1,123456
	move 1,2
	caige 1,0
	movei 1,0
	popj 17,

tlne_from_mem_value:
	move 1,(1)
	tlne 1,123456
	movei 1,0
	popj 17,

tlne_from_global_value:
	move 1,tlne_ga
	tlne 1,123456
	movei 1,0
	popj 17,

tlne_from_expr:
	add 1,2
	tlne 1,123456
	movei 1,0
	popj 17,

tlne_from_xor_expr:
	xor 1,2
	tlne 1,123456
	movei 1,0
	popj 17,

utlne_clear_small:
	tlne 1,123456
	movei 1,0
	popj 17,

utlne_clear_highbit:
	caige 1,0
	movei 1,0
	popj 17,

utlne_clear_all:
	tlne 1,777777
	movei 1,0
	popj 17,

utlne_bool_small:
	and 1,[123456000000]
	skipe 1
	movei 1,1
	popj 17,

utlne_store_global:
	tlne 1,123456
	movem 1,tlne_uga
	popj 17,

tlne_qi_promote:
	andi 1,777	; zero_extendqisi2
	hrlz 1,1
	tlne 1,456
	movei 1,0
	popj 17,

tlne_hi_promote:
	hrlz 1,1
	tlne 1,123456
	movei 1,0
	popj 17,

	.bss
tlne_ga:
	.space	4
tlne_uga:
	.space	4
