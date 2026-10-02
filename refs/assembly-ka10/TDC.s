
tdc_reg_reg:
	xor 1,2
	popj 17,

tdc_reg_mem:
	xor 1,(2)
	popj 17,

tdc_mem_reg:
	xor 2,(1)
	move 1,2
	popj 17,

tdc_mem_mem:
	move 1,(1)
	xor 1,(2)
	popj 17,

tdc_global_a:
	xor 1,tdc_ga
	popj 17,

tdc_global_b:
	move 1,tdc_ga
	xor 1,tdc_gb
	popj 17,

tdc_array:
	andi 3,17
	add 2,3
	xor 1,(2)
	popj 17,

tdc_global_array:
	andi 2,17
	xor 1,tdc_buf(2)
	popj 17,

tdc_struct_a:
	xor 1,(2)
	popj 17,

tdc_struct_b:
	xor 1,1(2)
	popj 17,

tdc_global_struct_a:
	xor 1,tdc_gp
	popj 17,

tdc_global_struct_b:
	xor 1,tdc_gp+1
	popj 17,

tdc_indirect:
	xor 1,@(2)
	popj 17,

tdc_volatile:
	move 4,1
	move 1,(2)
	xor 1,4
	popj 17,

tdc_loaded:
	xor 1,(2)
	popj 17,

tdc_loaded_global:
	xor 1,tdc_ga
	popj 17,

tdc_literal_a:
	xor 1,[123456123456]
	popj 17,

tdc_literal_b:
	xor 1,[-252525525253]
	popj 17,

tdc_literal_sparse:
	xor 1,[-70707707071]
	popj 17,

tdc_literal_left:
	tlc 1,123456
	popj 17,

tdc_literal_right:
	xori 1,123456
	popj 17,

tdc_literal_highbit:
	tlc 1,400000
	popj 17,

tdc_literal_all:
	setca 1,
	popj 17,

tdc_store:
	xor 2,3
	movem 2,(1)
	popj 17,

tdc_store_mem:
	xor 2,(3)
	movem 2,(1)
	popj 17,

tdc_store_return:
	xor 2,3
	movem 2,(1)
	move 1,2
	popj 17,

tdc_store_global:
	xor 1,2
	movem 1,tdc_ga
	popj 17,

tdc_store_array:
	andi 4,17
	add 3,4
	xor 1,2
	movem 1,(3)
	popj 17,

tdc_store_struct_a:
	xor 1,2
	movem 1,(3)
	popj 17,

tdc_store_struct_b:
	xor 1,2
	movem 1,1(3)
	popj 17,

tdc_update_mem:
	xorm 2,(1)
	popj 17,

tdc_update_mem_mem:
	move 2,(2)
	xorm 2,(1)
	popj 17,

tdc_update_global:
	xorm 1,tdc_ga
	popj 17,

tdc_update_global_mem:
	move 1,(1)
	xorm 1,tdc_ga
	popj 17,

tdc_update_array:
	andi 2,17
	add 1,2
	xorm 3,(1)
	popj 17,

tdc_update_global_array:
	andi 1,17
	xorm 2,tdc_buf(1)
	popj 17,

tdc_update_struct_a:
	xorm 2,(1)
	popj 17,

tdc_update_struct_b:
	xorm 2,1(1)
	popj 17,

tdc_update_return:
	move 4,2
	xorb 4,(1)
	move 1,4
	popj 17,

tdc_global_update_return:
	xorb 1,tdc_ga
	popj 17,

tdc_volatile_update:
	move 4,(1)
	xor 4,2
	movem 4,(1)
	popj 17,

tdce_clear:
	move 4,1
	xor 4,2
	tdne 1,2
	movei 4,0
	move 1,4
	popj 17,

tdce_mem:
	move 4,(2)
	move 3,1
	xor 3,4
	tdne 1,4
	movei 3,0
	move 1,3
	popj 17,

tdce_global:
	move 4,tdc_ga
	move 3,1
	xor 3,4
	tdne 1,4
	movei 3,0
	move 1,3
	popj 17,

tdce_select:
	move 6,1
	xor 6,2
	add 3,6
	tdne 1,2
	jrst %L53
	move 3,4
	add 3,6
%L53:
	move 1,3
	popj 17,

tdce_call:
	push 17,10
	move 10,1
	xor 10,2
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

tdce_likely:
	move 4,1
	xor 4,2
	tdne 1,2
	movei 4,0
	move 1,4
	popj 17,

tdce_unlikely:
	move 4,1
	xor 4,2
	tdne 1,2
	jrst %L62
%L61:
	move 1,4
	popj 17,
%L62:
	movei 4,0
	jrst %L61

tdce_literal:
	move 4,1
	xor 4,[123456123456]
	tdne 1,[123456123456]
	movei 4,0
	move 1,4
	popj 17,

tdce_literal_highbit:
	move 4,1
	tlc 4,400000
	jumpge 1,%L66
	movei 4,0
%L66:
	move 1,4
	popj 17,

tdce_literal_all:
	setcm 4,1
	jumpe 1,%L68
	movei 4,0
%L68:
	move 1,4
	popj 17,

tdcn_clear:
	move 4,1
	xor 4,2
	tdnn 1,2
	movei 4,0
	move 1,4
	popj 17,

tdcn_mem:
	move 4,(2)
	move 3,1
	xor 3,4
	tdnn 1,4
	movei 3,0
	move 1,3
	popj 17,

tdcn_global:
	move 4,tdc_ga
	move 3,1
	xor 3,4
	tdnn 1,4
	movei 3,0
	move 1,3
	popj 17,

tdcn_select:
	move 6,1
	xor 6,2
	add 3,6
	tdnn 1,2
	jrst %L75
	move 3,4
	add 3,6
%L75:
	move 1,3
	popj 17,

tdcn_call:
	push 17,10
	move 10,1
	xor 10,2
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

tdcn_likely:
	move 4,1
	xor 4,2
	tdnn 1,2
	movei 4,0
	move 1,4
	popj 17,

tdcn_unlikely:
	move 4,1
	xor 4,2
	tdnn 1,2
	jrst %L84
%L83:
	move 1,4
	popj 17,
%L84:
	movei 4,0
	jrst %L83

tdcn_literal:
	move 4,1
	xor 4,[123456123456]
	tdnn 1,[123456123456]
	movei 4,0
	move 1,4
	popj 17,

tdcn_literal_highbit:
	move 4,1
	tlc 4,400000
	jumpl 1,%L88
	movei 4,0
%L88:
	move 1,4
	popj 17,

tdcn_literal_all:
	setcm 4,1
	jumpn 1,%L90
	movei 4,0
%L90:
	move 1,4
	popj 17,

tdca_goto:
	xor 1,2
%L92:
	popj 17,

tdca_mem_goto:
	xor 1,(2)
%L94:
	popj 17,

tdca_select:
	xor 1,2
%L97:
	popj 17,

tdca_call:
	push 17,10
	move 10,1
	xor 10,2
%L99:
	pushj 17,f
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

tdc_chain:
	xor 1,2
	xor 1,3
	popj 17,

tdc_chain_same:
	popj 17,

tdc_mix_add:
	xor 1,2
	add 1,3
	popj 17,

tdc_mix_and:
	xor 1,2
	and 1,3
	popj 17,

tdc_mix_or:
	xor 1,2
	ior 1,3
	popj 17,

tdc_mix_sub:
	xor 1,2
	sub 1,3
	popj 17,

tdc_from_expr:
	add 1,2
	xor 1,3
	popj 17,

tdc_from_xor_expr:
	xor 1,2
	xor 1,3
	popj 17,

tdc_two_tests:
	xor 1,2
	tdne 1,3
	xor 1,3
	popj 17,

utdc_reg_reg:
	xor 1,2
	popj 17,

utdc_reg_mem:
	xor 1,(2)
	popj 17,

utdc_global:
	xor 1,tdc_uga
	popj 17,

utdc_array:
	andi 3,17
	add 2,3
	xor 1,(2)
	popj 17,

utdc_global_array:
	andi 2,17
	xor 1,tdc_ubuf(2)
	popj 17,

utdc_struct_a:
	xor 1,(2)
	popj 17,

utdc_global_struct_a:
	xor 1,tdc_ugp
	popj 17,

utdc_literal:
	xor 1,[123456123456]
	popj 17,

utdc_update_mem:
	xorm 2,(1)
	popj 17,

utdc_update_global:
	xorm 1,tdc_uga
	popj 17,

utdc_update_return:
	move 4,2
	xorb 4,(1)
	move 1,4
	popj 17,

utdce_bool:
	move 4,1
	xor 4,2
	skipe 4
	movei 4,1
	tdnn 1,2
	movei 4,0
	move 1,4
	popj 17,

utdcn_bool:
	move 4,1
	xor 4,2
	skipe 4
	movei 4,1
	tdne 1,2
	movei 4,0
	move 1,4
	popj 17,

tdc_qi:
	andi 2,777	; zero_extendqisi2
	xor 2,1
	move 1,2
	popj 17,

tdc_hi:
	xori 1,(2)
	popj 17,

tdc_qi_mem:
	ldb 2,2
	xor 1,2
	popj 17,

tdc_hi_mem:
	ldb 2,2
	xor 1,2
	popj 17,

	.bss
tdc_ga:
	.space	4
tdc_gb:
	.space	4
tdc_uga:
	.space	4
tdc_buf:
	.space	64
tdc_ubuf:
	.space	64
tdc_gp:
	.space	8
tdc_ugp:
	.space	8
