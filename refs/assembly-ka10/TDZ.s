
tdz_reg_reg:
	andca 2,1
	move 1,2
	popj 17,

tdz_reg_mem:
	andcm 1,(2)
	popj 17,

tdz_mem_reg:
	andca 2,(1)
	move 1,2
	popj 17,

tdz_mem_mem:
	move 1,(1)
	andcm 1,(2)
	popj 17,

tdz_global_a:
	andcm 1,tdz_ga
	popj 17,

tdz_global_b:
	move 1,tdz_gb
	andca 1,tdz_ga
	popj 17,

tdz_array:
	andi 3,17
	add 2,3
	andcm 1,(2)
	popj 17,

tdz_global_array:
	andi 2,17
	andcm 1,tdz_buf(2)
	popj 17,

tdz_struct_a:
	andcm 1,(2)
	popj 17,

tdz_struct_b:
	andcm 1,1(2)
	popj 17,

tdz_global_struct_a:
	andcm 1,tdz_gp
	popj 17,

tdz_global_struct_b:
	andcm 1,tdz_gp+1
	popj 17,

tdz_indirect:
	andcm 1,@(2)
	popj 17,

tdz_volatile:
	move 4,1
	move 1,(2)
	andca 1,4
	popj 17,

tdz_loaded:
	andcm 1,(2)
	popj 17,

tdz_loaded_global:
	andcm 1,tdz_ga
	popj 17,

tdz_literal_a:
	and 1,[-123456123457]
	popj 17,

tdz_literal_b:
	and 1,[252525525252]
	popj 17,

tdz_literal_sparse:
	and 1,[70707707070]
	popj 17,

tdz_literal_left:
	tlz 1,123456
	popj 17,

tdz_literal_right:
	andcmi 1,123456
	popj 17,

tdz_literal_highbit:
	tlz 1,400000
	popj 17,

tdz_literal_all:
	movei 1,0
	popj 17,

tdz_store:
	andca 3,2
	movem 3,(1)
	popj 17,

tdz_store_mem:
	andcm 2,(3)
	movem 2,(1)
	popj 17,

tdz_store_return:
	andca 3,2
	movem 3,(1)
	move 1,3
	popj 17,

tdz_store_global:
	andca 2,1
	movem 2,tdz_ga
	move 1,2
	popj 17,

tdz_store_array:
	andi 4,17
	add 3,4
	andca 2,1
	movem 2,(3)
	move 1,2
	popj 17,

tdz_store_struct_a:
	andca 2,1
	movem 2,(3)
	move 1,2
	popj 17,

tdz_store_struct_b:
	andca 2,1
	movem 2,1(3)
	move 1,2
	popj 17,

tdz_update_mem:
	andcam 2,(1)
	popj 17,

tdz_update_mem_mem:
	move 2,(2)
	andcam 2,(1)
	popj 17,

tdz_update_global:
	andcam 1,tdz_ga
	popj 17,

tdz_update_global_mem:
	move 1,(1)
	andcam 1,tdz_ga
	popj 17,

tdz_update_array:
	andi 2,17
	add 1,2
	andcam 3,(1)
	popj 17,

tdz_update_global_array:
	andi 1,17
	andcam 2,tdz_buf(1)
	popj 17,

tdz_update_struct_a:
	andcam 2,(1)
	popj 17,

tdz_update_struct_b:
	andcam 2,1(1)
	popj 17,

tdz_update_return:
	move 4,2
	andcab 4,(1)
	move 1,4
	popj 17,

tdz_global_update_return:
	andcab 1,tdz_ga
	popj 17,

tdz_volatile_update:
	move 4,(1)
	andca 2,4
	movem 2,(1)
	popj 17,

tdze_clear:
	move 4,2
	andca 4,1
	tdne 1,2
	movei 4,0
	move 1,4
	popj 17,

tdze_mem:
	move 4,(2)
	move 3,4
	andca 3,1
	tdne 1,4
	movei 3,0
	move 1,3
	popj 17,

tdze_global:
	move 4,tdz_ga
	move 3,4
	andca 3,1
	tdne 1,4
	movei 3,0
	move 1,3
	popj 17,

tdze_select:
	move 6,2
	andca 6,1
	add 3,6
	tdne 1,2
	jrst %L53
	move 3,4
	add 3,6
%L53:
	move 1,3
	popj 17,

tdze_call:
	push 17,10
	move 10,2
	andca 10,1
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

tdze_likely:
	move 4,2
	andca 4,1
	tdne 1,2
	movei 4,0
	move 1,4
	popj 17,

tdze_unlikely:
	move 4,2
	andca 4,1
	tdne 1,2
	jrst %L62
%L61:
	move 1,4
	popj 17,
%L62:
	movei 4,0
	jrst %L61

tdze_literal:
	move 4,1
	and 4,[-123456123457]
	tdne 1,[123456123456]
	movei 4,0
	move 1,4
	popj 17,

tdze_literal_highbit:
	move 4,1
	tlz 4,400000
	jumpge 1,%L66
	movei 4,0
%L66:
	move 1,4
	popj 17,

tdzn_clear:
	move 4,2
	andca 4,1
	tdnn 1,2
	movei 4,0
	move 1,4
	popj 17,

tdzn_mem:
	move 4,(2)
	move 3,4
	andca 3,1
	tdnn 1,4
	movei 3,0
	move 1,3
	popj 17,

tdzn_global:
	move 4,tdz_ga
	move 3,4
	andca 3,1
	tdnn 1,4
	movei 3,0
	move 1,3
	popj 17,

tdzn_select:
	move 6,2
	andca 6,1
	add 3,6
	tdnn 1,2
	jrst %L73
	move 3,4
	add 3,6
%L73:
	move 1,3
	popj 17,

tdzn_call:
	push 17,10
	move 10,2
	andca 10,1
	tdnn 1,2
	jrst %L77
%L76:
	move 1,10
	pop 17,10
	popj 17,
%L77:
	pushj 17,f
	add 10,1
	jrst %L76

tdzn_likely:
	move 4,2
	andca 4,1
	tdnn 1,2
	movei 4,0
	move 1,4
	popj 17,

tdzn_unlikely:
	move 4,2
	andca 4,1
	tdnn 1,2
	jrst %L82
%L81:
	move 1,4
	popj 17,
%L82:
	movei 4,0
	jrst %L81

tdzn_literal:
	move 4,1
	and 4,[-123456123457]
	tdnn 1,[123456123456]
	movei 4,0
	move 1,4
	popj 17,

tdzn_literal_highbit:
	move 4,1
	tlz 4,400000
	jumpl 1,%L86
	movei 4,0
%L86:
	move 1,4
	popj 17,

tdza_goto:
	andcm 1,2
%L88:
	popj 17,

tdza_mem_goto:
	andcm 1,(2)
%L90:
	popj 17,

tdza_select:
	andcm 1,2
%L93:
	popj 17,

tdza_call:
	push 17,10
	move 10,1
	andcm 10,2
%L95:
	pushj 17,f
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

tdz_chain:
	andcm 1,2
	andca 3,1
	move 1,3
	popj 17,

tdz_chain_same:
	andca 2,1
	move 1,2
	popj 17,

tdz_mix_add:
	andca 2,1
	add 2,3
	move 1,2
	popj 17,

tdz_mix_or:
	andca 2,1
	ior 2,3
	move 1,2
	popj 17,

tdz_mix_xor:
	andca 2,1
	xor 2,3
	move 1,2
	popj 17,

tdz_mix_sub:
	andca 2,1
	sub 2,3
	move 1,2
	popj 17,

tdz_from_expr:
	add 1,2
	andca 3,1
	move 1,3
	popj 17,

tdz_from_xor_expr:
	xor 1,2
	andca 3,1
	move 1,3
	popj 17,

tdz_two_tests:
	andcm 1,2
	tdne 1,3
	andcm 1,3
	popj 17,

utdz_reg_reg:
	andca 2,1
	move 1,2
	popj 17,

utdz_reg_mem:
	andcm 1,(2)
	popj 17,

utdz_global:
	andcm 1,tdz_uga
	popj 17,

utdz_array:
	andi 3,17
	add 2,3
	andcm 1,(2)
	popj 17,

utdz_global_array:
	andi 2,17
	andcm 1,tdz_ubuf(2)
	popj 17,

utdz_struct_a:
	andcm 1,(2)
	popj 17,

utdz_global_struct_a:
	andcm 1,tdz_ugp
	popj 17,

utdz_literal:
	and 1,[-123456123457]
	popj 17,

utdz_update_mem:
	andcam 2,(1)
	popj 17,

utdz_update_global:
	andcam 1,tdz_uga
	popj 17,

utdz_update_return:
	move 4,2
	andcab 4,(1)
	move 1,4
	popj 17,

utdze_bool:
	move 4,2
	andca 4,1
	skipe 4
	movei 4,1
	tdnn 1,2
	movei 4,0
	move 1,4
	popj 17,

utdzn_bool:
	move 4,2
	andca 4,1
	skipe 4
	movei 4,1
	tdne 1,2
	movei 4,0
	move 1,4
	popj 17,

tdz_qi:
	orcbi 2,777
	and 1,2
	popj 17,

tdz_hi:
	andcmi 1,(2)
	popj 17,

tdz_qi_mem:
	ldb 2,2
	andcm 1,2
	popj 17,

tdz_hi_mem:
	ldb 2,2
	andcm 1,2
	popj 17,

	.bss
tdz_ga:
	.space	4
tdz_gb:
	.space	4
tdz_uga:
	.space	4
tdz_buf:
	.space	64
tdz_ubuf:
	.space	64
tdz_gp:
	.space	8
tdz_ugp:
	.space	8
