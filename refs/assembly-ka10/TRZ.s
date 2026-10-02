
trz_small:
	andcmi 1,123456
	popj 17,

trz_one:
	andcmi 1,1
	popj 17,

trz_lowbit:
	andcmi 1,1
	popj 17,

trz_highbit:
	andcmi 1,400000
	popj 17,

trz_all_right:
	hllz 1,1
	popj 17,

trz_alt1:
	andcmi 1,525252
	popj 17,

trz_alt2:
	andcmi 1,252525
	popj 17,

trz_sparse:
	andcmi 1,707070
	popj 17,

trz_sign_low:
	andcmi 1,400001
	popj 17,

trz_maxpos:
	andcmi 1,377777
	popj 17,

trz_from_mem:
	move 1,(1)
	andcmi 1,123456
	popj 17,

trz_global:
	move 1,trz_ga
	andcmi 1,123456
	popj 17,

trz_array:
	andi 2,17
	add 1,2
	move 1,(1)
	andcmi 1,123456
	popj 17,

trz_global_array:
	andi 1,17
	move 1,trz_buf(1)
	andcmi 1,123456
	popj 17,

trz_struct_a:
	move 1,(1)
	andcmi 1,123456
	popj 17,

trz_struct_b:
	move 1,1(1)
	andcmi 1,525252
	popj 17,

trz_global_struct_a:
	move 1,trz_gp
	andcmi 1,123456
	popj 17,

trz_global_struct_b:
	move 1,trz_gp+1
	andcmi 1,525252
	popj 17,

trz_indirect:
	move 1,@(1)
	andcmi 1,123456
	popj 17,

trz_volatile_load:
	move 1,(1)
	andcmi 1,123456
	popj 17,

trz_store:
	andcmi 2,123456
	movem 2,(1)
	popj 17,

trz_store_alt:
	andcmi 2,525252
	movem 2,(1)
	popj 17,

trz_store_global:
	andcmi 1,123456
	movem 1,trz_ga
	popj 17,

trz_update_mem:
	hrroi 6,654321
	andm 6,(1)
	popj 17,

trz_update_global:
	hrroi 6,654321
	andm 6,trz_ga
	popj 17,

trz_update_array:
	andi 2,17
	add 1,2
	hrroi 6,654321
	andm 6,(1)
	popj 17,

trz_update_global_array:
	andi 1,17
	hrroi 6,654321
	andm 6,trz_buf(1)
	popj 17,

trz_update_struct_a:
	hrroi 6,654321
	andm 6,(1)
	popj 17,

trz_update_struct_b:
	hrroi 6,252525
	andm 6,1(1)
	popj 17,

trz_update_return:
	move 4,(1)
	andcmi 4,123456
	movem 4,(1)
	move 1,4
	popj 17,

trz_global_update_return:
	move 1,trz_ga
	andcmi 1,123456
	movem 1,trz_ga
	popj 17,

trz_volatile_store:
	andcmi 2,123456
	movem 2,(1)
	popj 17,

trz_volatile_update:
	move 4,(1)
	andcmi 4,123456
	movem 4,(1)
	popj 17,

trze_clear:
	trne 1,123456
	movei 1,0
	andcmi 1,123456
	popj 17,

trze_select:
	move 4,1
	andcmi 4,123456
	add 2,4
	trne 1,123456
	jrst %L39
	move 2,3
	add 2,4
%L39:
	move 1,2
	popj 17,

trze_call:
	push 17,10
	move 10,1
	andcmi 10,123456
	trne 1,123456
	jrst %L43
%L42:
	move 1,10
	pop 17,10
	popj 17,
%L43:
	pushj 17,f
	add 10,1
	jrst %L42

trze_likely:
	move 4,1
	andcmi 4,123456
	trne 1,123456
	movei 4,0
	move 1,4
	popj 17,

trze_unlikely:
	move 4,1
	andcmi 4,123456
	trne 1,123456
	jrst %L48
%L47:
	move 1,4
	popj 17,
%L48:
	movei 4,0
	jrst %L47

trze_highbit:
	move 4,1
	andcmi 4,400000
	trne 1,400000
	movei 4,0
	move 1,4
	popj 17,

trze_all:
	hllz 4,1
	hrrz 1,1
	jumpe 1,%L52
	movei 4,0
%L52:
	move 1,4
	popj 17,

trzn_clear:
	trnn 1,123456
	movei 1,0
	andcmi 1,123456
	popj 17,

trzn_select:
	move 4,1
	andcmi 4,123456
	add 2,4
	trnn 1,123456
	jrst %L55
	move 2,3
	add 2,4
%L55:
	move 1,2
	popj 17,

trzn_call:
	push 17,10
	move 10,1
	andcmi 10,123456
	trnn 1,123456
	jrst %L59
%L58:
	move 1,10
	pop 17,10
	popj 17,
%L59:
	pushj 17,f
	add 10,1
	jrst %L58

trzn_likely:
	move 4,1
	andcmi 4,123456
	trnn 1,123456
	movei 4,0
	move 1,4
	popj 17,

trzn_unlikely:
	move 4,1
	andcmi 4,123456
	trnn 1,123456
	jrst %L64
%L63:
	move 1,4
	popj 17,
%L64:
	movei 4,0
	jrst %L63

trzn_highbit:
	move 4,1
	andcmi 4,400000
	trnn 1,400000
	movei 4,0
	move 1,4
	popj 17,

trzn_all:
	hllz 4,1
	hrrz 1,1
	jumpn 1,%L68
	movei 4,0
%L68:
	move 1,4
	popj 17,

trza_goto:
	andcmi 1,123456
%L70:
	popj 17,

trza_select:
	andcmi 1,123456
%L73:
	popj 17,

trza_call:
	push 17,10
	move 10,1
	andcmi 10,123456
%L75:
	pushj 17,f
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

trz_chain:
	andcmi 1,527656
	popj 17,

trz_chain_same:
	andcmi 1,123456
	popj 17,

trz_mix_add:
	andcmi 1,123456
	add 1,2
	popj 17,

trz_mix_or:
	andcmi 1,123456
	ior 1,2
	popj 17,

trz_mix_xor:
	andcmi 1,123456
	xor 1,2
	popj 17,

trz_mix_sub:
	andcmi 1,123456
	sub 1,2
	popj 17,

trz_two_tests:
	andcmi 1,123456
	trne 1,404200
	andcmi 1,525252
	popj 17,

trz_from_expr:
	add 1,2
	andcmi 1,123456
	popj 17,

trz_from_xor_expr:
	xor 1,2
	andcmi 1,123456
	popj 17,

utrz_small:
	andcmi 1,123456
	popj 17,

utrz_highbit:
	andcmi 1,400000
	popj 17,

utrz_all_right:
	hllz 1,1
	popj 17,

utrz_from_mem:
	move 1,(1)
	andcmi 1,123456
	popj 17,

utrz_store:
	andcmi 2,123456
	movem 2,(1)
	popj 17,

utrz_update_mem:
	hrroi 6,654321
	andm 6,(1)
	popj 17,

utrz_update_global:
	hrroi 6,654321
	andm 6,trz_uga
	popj 17,

utrze_bool:
	move 4,1
	andcmi 4,123456
	skipe 4
	movei 4,1
	trnn 1,123456
	movei 4,0
	move 1,4
	popj 17,

utrzn_bool:
	move 4,1
	andcmi 4,123456
	skipe 4
	movei 4,1
	trne 1,123456
	movei 4,0
	move 1,4
	popj 17,

trz_qi_promote:
	andi 1,321
	popj 17,

trz_hi_promote:
	andi 1,654321
	popj 17,

	.bss
trz_ga:
	.space	4
trz_uga:
	.space	4
trz_buf:
	.space	64
trz_gp:
	.space	8
