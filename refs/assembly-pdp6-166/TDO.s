
tdo_reg_reg:
	ior 1,2
	popj 17,

tdo_reg_mem:
	ior 1,(2)
	popj 17,

tdo_mem_reg:
	ior 2,(1)
	move 1,2
	popj 17,

tdo_mem_mem:
	move 1,(1)
	ior 1,(2)
	popj 17,

tdo_global_a:
	ior 1,tdo_ga
	popj 17,

tdo_global_b:
	move 1,tdo_ga
	ior 1,tdo_gb
	popj 17,

tdo_array:
	andi 3,17
	add 2,3
	ior 1,(2)
	popj 17,

tdo_global_array:
	andi 2,17
	ior 1,tdo_buf(2)
	popj 17,

tdo_struct_a:
	ior 1,(2)
	popj 17,

tdo_struct_b:
	ior 1,1(2)
	popj 17,

tdo_global_struct_a:
	ior 1,tdo_gp
	popj 17,

tdo_global_struct_b:
	ior 1,tdo_gp+1
	popj 17,

tdo_indirect:
	ior 1,@(2)
	popj 17,

tdo_volatile:
	move 4,1
	move 1,(2)
	ior 1,4
	popj 17,

tdo_loaded:
	ior 1,(2)
	popj 17,

tdo_loaded_global:
	ior 1,tdo_ga
	popj 17,

tdo_literal_a:
	ior 1,[123456123456]
	popj 17,

tdo_literal_b:
	ior 1,[-252525525253]
	popj 17,

tdo_literal_sparse:
	ior 1,[-70707707071]
	popj 17,

tdo_literal_left:
	tlo 1,123456
	popj 17,

tdo_literal_right:
	iori 1,123456
	popj 17,

tdo_literal_highbit:
	tlo 1,400000
	popj 17,

tdo_literal_all:
	seto 1,
	popj 17,

tdo_store:
	ior 2,3
	movem 2,(1)
	popj 17,

tdo_store_mem:
	ior 2,(3)
	movem 2,(1)
	popj 17,

tdo_store_return:
	ior 2,3
	movem 2,(1)
	move 1,2
	popj 17,

tdo_store_global:
	ior 1,2
	movem 1,tdo_ga
	popj 17,

tdo_store_array:
	andi 4,17
	add 3,4
	ior 1,2
	movem 1,(3)
	popj 17,

tdo_store_struct_a:
	ior 1,2
	movem 1,(3)
	popj 17,

tdo_store_struct_b:
	ior 1,2
	movem 1,1(3)
	popj 17,

tdo_update_mem:
	iorm 2,(1)
	popj 17,

tdo_update_mem_mem:
	move 2,(2)
	iorm 2,(1)
	popj 17,

tdo_update_global:
	iorm 1,tdo_ga
	popj 17,

tdo_update_global_mem:
	move 1,(1)
	iorm 1,tdo_ga
	popj 17,

tdo_update_array:
	andi 2,17
	add 1,2
	iorm 3,(1)
	popj 17,

tdo_update_global_array:
	andi 1,17
	iorm 2,tdo_buf(1)
	popj 17,

tdo_update_struct_a:
	iorm 2,(1)
	popj 17,

tdo_update_struct_b:
	iorm 2,1(1)
	popj 17,

tdo_update_return:
	move 4,2
	iorb 4,(1)
	move 1,4
	popj 17,

tdo_global_update_return:
	iorb 1,tdo_ga
	popj 17,

tdo_volatile_update:
	move 4,(1)
	ior 4,2
	movem 4,(1)
	popj 17,

tdoe_clear:
	move 4,1
	ior 4,2
	tdne 1,2
	movei 4,0
	move 1,4
	popj 17,

tdoe_mem:
	move 4,(2)
	move 3,1
	ior 3,4
	tdne 1,4
	movei 3,0
	move 1,3
	popj 17,

tdoe_global:
	move 4,tdo_ga
	move 3,1
	ior 3,4
	tdne 1,4
	movei 3,0
	move 1,3
	popj 17,

tdoe_select:
	move 6,1
	ior 6,2
	add 3,6
	tdne 1,2
	jrst %L53
	move 3,4
	add 3,6
%L53:
	move 1,3
	popj 17,

tdoe_call:
	push 17,10
	move 10,1
	ior 10,2
	tdne 1,2
	jrst %L57
%L56:
	move 1,10
	pop 17,10
	popj 17,
%L57:
	pushj 17,f
	add 10,1
	jrst %L56

tdoe_likely:
	move 4,1
	ior 4,2
	tdne 1,2
	movei 4,0
	move 1,4
	popj 17,

tdoe_unlikely:
	move 4,1
	ior 4,2
	tdne 1,2
	jrst %L62
%L61:
	move 1,4
	popj 17,
%L62:
	movei 4,0
	jrst %L61

tdoe_literal:
	move 4,1
	ior 4,[123456123456]
	tdne 1,[123456123456]
	movei 4,0
	move 1,4
	popj 17,

tdoe_literal_highbit:
	move 4,1
	tlo 4,400000
	jumpge 1,%L66
	movei 4,0
%L66:
	move 1,4
	popj 17,

tdoe_literal_all:
	skipe 1
	tdza 1,1
	movei 1,1
	movn 1,1
	popj 17,

tdon_clear:
	move 4,1
	ior 4,2
	tdnn 1,2
	movei 4,0
	move 1,4
	popj 17,

tdon_mem:
	move 4,(2)
	move 3,1
	ior 3,4
	tdnn 1,4
	movei 3,0
	move 1,3
	popj 17,

tdon_global:
	move 4,tdo_ga
	move 3,1
	ior 3,4
	tdnn 1,4
	movei 3,0
	move 1,3
	popj 17,

tdon_select:
	move 6,1
	ior 6,2
	add 3,6
	tdnn 1,2
	jrst %L75
	move 3,4
	add 3,6
%L75:
	move 1,3
	popj 17,

tdon_call:
	push 17,10
	move 10,1
	ior 10,2
	tdnn 1,2
	jrst %L79
%L78:
	move 1,10
	pop 17,10
	popj 17,
%L79:
	pushj 17,f
	add 10,1
	jrst %L78

tdon_likely:
	move 4,1
	ior 4,2
	tdnn 1,2
	movei 4,0
	move 1,4
	popj 17,

tdon_unlikely:
	move 4,1
	ior 4,2
	tdnn 1,2
	jrst %L84
%L83:
	move 1,4
	popj 17,
%L84:
	movei 4,0
	jrst %L83

tdon_literal:
	move 4,1
	ior 4,[123456123456]
	tdnn 1,[123456123456]
	movei 4,0
	move 1,4
	popj 17,

tdon_literal_highbit:
	move 4,1
	tlo 4,400000
	jumpl 1,%L88
	movei 4,0
%L88:
	move 1,4
	popj 17,

tdon_literal_all:
	skipe 1
	movei 1,1
	movn 1,1
	popj 17,

tdoa_goto:
	ior 1,2
%L92:
	popj 17,

tdoa_mem_goto:
	ior 1,(2)
%L94:
	popj 17,

tdoa_select:
	ior 1,2
%L97:
	popj 17,

tdoa_call:
	push 17,10
	move 10,1
	ior 10,2
%L99:
	pushj 17,f
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

tdo_chain:
	ior 1,2
	ior 1,3
	popj 17,

tdo_chain_same:
	ior 1,2
	popj 17,

tdo_mix_add:
	ior 1,2
	add 1,3
	popj 17,

tdo_mix_and:
	ior 1,2
	and 1,3
	popj 17,

tdo_mix_xor:
	ior 1,2
	xor 1,3
	popj 17,

tdo_mix_sub:
	ior 1,2
	sub 1,3
	popj 17,

tdo_from_expr:
	add 1,2
	ior 1,3
	popj 17,

tdo_from_xor_expr:
	xor 1,2
	ior 1,3
	popj 17,

tdo_two_tests:
	ior 1,2
	tdne 1,3
	ior 1,3
	popj 17,

utdo_reg_reg:
	ior 1,2
	popj 17,

utdo_reg_mem:
	ior 1,(2)
	popj 17,

utdo_global:
	ior 1,tdo_uga
	popj 17,

utdo_array:
	andi 3,17
	add 2,3
	ior 1,(2)
	popj 17,

utdo_global_array:
	andi 2,17
	ior 1,tdo_ubuf(2)
	popj 17,

utdo_struct_a:
	ior 1,(2)
	popj 17,

utdo_global_struct_a:
	ior 1,tdo_ugp
	popj 17,

utdo_literal:
	ior 1,[123456123456]
	popj 17,

utdo_update_mem:
	iorm 2,(1)
	popj 17,

utdo_update_global:
	iorm 1,tdo_uga
	popj 17,

utdo_update_return:
	move 4,2
	iorb 4,(1)
	move 1,4
	popj 17,

utdoe_bool:
	move 4,1
	ior 4,2
	skipe 4
	movei 4,1
	tdnn 1,2
	movei 4,0
	move 1,4
	popj 17,

utdon_bool:
	move 4,1
	ior 4,2
	skipe 4
	movei 4,1
	tdne 1,2
	movei 4,0
	move 1,4
	popj 17,

tdo_qi:
	andi 2,777	; zero_extendqisi2
	ior 2,1
	move 1,2
	popj 17,

tdo_hi:
	iori 1,(2)
	popj 17,

tdo_qi_mem:
	ldb 2,2
	ior 1,2
	popj 17,

tdo_hi_mem:
	ldb 2,2
	ior 1,2
	popj 17,

	.bss
tdo_ga:
	.space	4
tdo_gb:
	.space	4
tdo_uga:
	.space	4
tdo_buf:
	.space	64
tdo_ubuf:
	.space	64
tdo_gp:
	.space	8
tdo_ugp:
	.space	8
