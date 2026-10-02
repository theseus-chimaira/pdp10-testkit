
trne_clear_small:
	trne 1,123456
	movei 1,0
	popj 17,

trne_clear_one:
	trne 1,1
	movei 1,0
	popj 17,

trne_clear_lowbit:
	trne 1,1
	movei 1,0
	popj 17,

trne_clear_highbit:
	trne 1,400000
	movei 1,0
	popj 17,

trne_clear_all:
	hrrz 4,1
	jumpe 4,%L10
	movei 1,0
%L10:
	popj 17,

trne_clear_alt1:
	trne 1,525252
	movei 1,0
	popj 17,

trne_clear_alt2:
	trne 1,252525
	movei 1,0
	popj 17,

trne_clear_sparse:
	trne 1,707070
	movei 1,0
	popj 17,

trne_clear_sign_low:
	trne 1,400001
	movei 1,0
	popj 17,

trne_clear_maxpos:
	trne 1,377777
	movei 1,0
	popj 17,

trne_clear_likely_small:
	trne 1,123456
	movei 1,0
	popj 17,

trne_clear_likely_all:
	hrrz 4,1
	jumpe 4,%L24
	movei 1,0
%L24:
	popj 17,

trne_clear_likely_highbit:
	trne 1,400000
	movei 1,0
	popj 17,

trne_clear_unlikely_small:
	trnn 1,123456
%L28:
	popj 17,
	movei 1,0
	popj 17,

trne_clear_unlikely_all:
	hrrz 4,1
	jumpn 4,%L32
%L31:
	popj 17,
%L32:
	movei 1,0
	popj 17,

trne_clear_unlikely_highbit:
	trnn 1,400000
%L34:
	popj 17,
	movei 1,0
	popj 17,

trne_bool_small:
	andi 1,123456
	skipe 1
	movei 1,1
	popj 17,

trne_bool_one:
	andi 1,1
	popj 17,

trne_bool_highbit:
	ldb 1,[POINT 1,1,18]
	popj 17,

trne_bool_all:
	hrrz 1,1
	skipe 1
	movei 1,1
	popj 17,

trne_bool_alt1:
	andi 1,525252
	skipe 1
	movei 1,1
	popj 17,

trne_select_small:
	trnn 1,123456
	move 2,3
	move 1,2
	popj 17,

trne_select_highbit:
	trnn 1,400000
	move 2,3
	move 1,2
	popj 17,

trne_select_all:
	hrrz 1,1
	jumpn 1,%L45
	move 2,3
%L45:
	move 1,2
	popj 17,

trne_call_small:
	trnn 1,123456
%L48:
	popj 17,
	pushj 17,f
	popj 17,

trne_call_highbit:
	trnn 1,400000
%L51:
	popj 17,
	pushj 17,f
	popj 17,

trne_call_all:
	hrrz 4,1
	jumpn 4,%L55
%L54:
	popj 17,
%L55:
	pushj 17,f
	popj 17,

trne_explicit_ne:
	trne 1,123456
	movei 1,0
	popj 17,

trne_explicit_ne_highbit:
	trne 1,400000
	movei 1,0
	popj 17,

trne_explicit_ne_all:
	hrrz 4,1
	jumpe 4,%L61
	movei 1,0
%L61:
	popj 17,

trne_branch_return:
	trnn 1,123456
	move 2,3
	move 1,2
	popj 17,

trne_branch_return_highbit:
	trnn 1,400000
	move 2,3
	move 1,2
	popj 17,

trne_branch_return_all:
	hrrz 1,1
	jumpn 1,%L66
	move 2,3
%L66:
	move 1,2
	popj 17,

trne_store_global:
	trne 1,123456
	movem 1,trne_ga
	popj 17,

trne_store_global_zero:
	trne 1,123456
	setzm trne_ga
	popj 17,

trne_store_global_highbit:
	trne 1,400000
	movem 1,trne_ga
	popj 17,

trne_use_global:
	trne 1,123456
	move 1,trne_ga
	popj 17,

trne_use_global_highbit:
	trne 1,400000
	move 1,trne_ga
	popj 17,

trne_mix_add:
	trne 1,123456
	add 1,2
	popj 17,

trne_mix_xor:
	trne 1,123456
	xor 1,2
	popj 17,

trne_mix_or:
	trne 1,123456
	ior 1,2
	popj 17,

trne_mix_and:
	trne 1,123456
	and 1,2
	popj 17,

trne_nested:
	trnn 1,123456
	popj 17,
	movei 1,0
	trnn 2,1
	move 1,2
	popj 17,

trne_two_tests:
	trne 1,123456
	movei 1,0
	trne 1,525252
	movei 1,1
	popj 17,

trne_chain:
	trne 1,123456
	move 1,2
	trne 1,400000
	movei 1,0
	popj 17,

trne_from_mem_value:
	move 1,(1)
	trne 1,123456
	movei 1,0
	popj 17,

trne_from_global_value:
	move 1,trne_ga
	trne 1,123456
	movei 1,0
	popj 17,

trne_from_expr:
	add 1,2
	trne 1,123456
	movei 1,0
	popj 17,

trne_from_xor_expr:
	xor 1,2
	trne 1,123456
	movei 1,0
	popj 17,

utrne_clear_small:
	trne 1,123456
	movei 1,0
	popj 17,

utrne_clear_highbit:
	trne 1,400000
	movei 1,0
	popj 17,

utrne_clear_all:
	hrrz 4,1
	jumpe 4,%L109
	movei 1,0
%L109:
	popj 17,

utrne_bool_small:
	andi 1,123456
	skipe 1
	movei 1,1
	popj 17,

utrne_store_global:
	trne 1,123456
	movem 1,trne_uga
	popj 17,

trne_qi_promote:
	andi 1,777	; zero_extendqisi2
	jumpe 1,%L114
	movei 1,0
%L114:
	popj 17,

trne_hi_promote:
	hrrzi 1,(1)	; zero_extendhisi2
	jumpe 1,%L116
	movei 1,0
%L116:
	popj 17,

	.bss
trne_ga:
	.space	4
trne_uga:
	.space	4
