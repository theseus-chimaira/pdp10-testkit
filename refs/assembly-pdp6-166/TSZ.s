
tsz_reg_reg:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	andca 1,4
	popj 17,

tsz_reg_mem:
	move 3,1
	move 4,(2)
	hlre 1,4
	tlo 1,(4)
	andca 1,3
	popj 17,

tsz_mem_reg:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	andca 1,(4)
	popj 17,

tsz_mem_mem:
	move 3,1
	move 4,(2)
	hlre 1,4
	tlo 1,(4)
	andca 1,(3)
	popj 17,

tsz_global_a:
	move 3,tsz_ga
	hlre 4,3
	tlo 4,(3)
	andca 4,1
	move 1,4
	popj 17,

tsz_global_b:
	move 4,tsz_gb
	hlre 1,4
	tlo 1,(4)
	andca 1,tsz_ga
	popj 17,

tsz_array:
	move 6,1
	andi 3,17
	add 2,3
	move 4,(2)
	hlre 1,4
	tlo 1,(4)
	andca 1,6
	popj 17,

tsz_global_array:
	move 3,1
	andi 2,17
	move 4,tsz_buf(2)
	hlre 1,4
	tlo 1,(4)
	andca 1,3
	popj 17,

tsz_struct_a:
	move 3,1
	move 4,(2)
	hlre 1,4
	tlo 1,(4)
	andca 1,3
	popj 17,

tsz_struct_b:
	move 3,1
	move 4,1(2)
	hlre 1,4
	tlo 1,(4)
	andca 1,3
	popj 17,

tsz_global_struct_a:
	move 3,tsz_gp
	hlre 4,3
	tlo 4,(3)
	andca 4,1
	move 1,4
	popj 17,

tsz_global_struct_b:
	move 3,tsz_gp+1
	hlre 4,3
	tlo 4,(3)
	andca 4,1
	move 1,4
	popj 17,

tsz_indirect:
	move 3,1
	move 4,@(2)
	hlre 1,4
	tlo 1,(4)
	andca 1,3
	popj 17,

tsz_volatile:
	move 3,1
	move 4,(2)
	move 1,(2)
	hlre 1,1
	tlo 1,(4)
	andca 1,3
	popj 17,

tsz_loaded:
	move 3,1
	move 4,(2)
	hlre 1,4
	tlo 1,(4)
	andca 1,3
	popj 17,

tsz_loaded_global:
	move 3,tsz_ga
	hlre 4,3
	tlo 4,(3)
	andca 4,1
	move 1,4
	popj 17,

tsz_literal_a:
	and 1,[-123456123457]
	popj 17,

tsz_literal_b:
	and 1,[-252525525253]
	popj 17,

tsz_literal_sparse:
	and 1,[-70707707071]
	popj 17,

tsz_literal_left:
	andcmi 1,123456
	popj 17,

tsz_literal_right:
	tlz 1,123456
	popj 17,

tsz_literal_highbit:
	andcmi 1,400000
	popj 17,

tsz_literal_all:
	movei 1,0
	popj 17,

tsz_store:
	hlre 4,3
	tlo 4,(3)
	andca 4,2
	movem 4,(1)
	popj 17,

tsz_store_mem:
	move 3,(3)
	hlre 4,3
	tlo 4,(3)
	andca 4,2
	movem 4,(1)
	popj 17,

tsz_store_return:
	move 4,1
	hlre 1,3
	tlo 1,(3)
	andca 1,2
	movem 1,(4)
	popj 17,

tsz_store_global:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	andca 1,4
	movem 1,tsz_ga
	popj 17,

tsz_store_array:
	move 6,1
	andi 4,17
	add 3,4
	hlre 1,2
	tlo 1,(2)
	andca 1,6
	movem 1,(3)
	popj 17,

tsz_store_struct_a:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	andca 1,4
	movem 1,(3)
	popj 17,

tsz_store_struct_b:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	andca 1,4
	movem 1,1(3)
	popj 17,

tsz_update_mem:
	hlre 4,2
	tlo 4,(2)
	andcam 4,(1)
	popj 17,

tsz_update_mem_mem:
	move 3,(2)
	hlre 4,3
	tlo 4,(3)
	andcam 4,(1)
	popj 17,

tsz_update_global:
	hlre 4,1
	tlo 4,(1)
	andcam 4,tsz_ga
	popj 17,

tsz_update_global_mem:
	move 3,(1)
	hlre 4,3
	tlo 4,(3)
	andcam 4,tsz_ga
	popj 17,

tsz_update_array:
	andi 2,17
	add 1,2
	hlre 4,3
	tlo 4,(3)
	andcam 4,(1)
	popj 17,

tsz_update_global_array:
	andi 1,17
	hlre 4,2
	tlo 4,(2)
	andcam 4,tsz_buf(1)
	popj 17,

tsz_update_struct_a:
	hlre 4,2
	tlo 4,(2)
	andcam 4,(1)
	popj 17,

tsz_update_struct_b:
	hlre 4,2
	tlo 4,(2)
	andcam 4,1(1)
	popj 17,

tsz_update_return:
	move 3,1
	hlre 4,2
	tlo 4,(2)
	move 1,4
	andcab 1,(3)
	popj 17,

tsz_global_update_return:
	hlre 4,1
	tlo 4,(1)
	move 1,4
	andcab 1,tsz_ga
	popj 17,

tsz_volatile_update:
	hlre 4,2
	tlo 4,(2)
	move 3,(1)
	andca 4,3
	movem 4,(1)
	popj 17,

tsze_clear:
	hlre 4,2
	tlo 4,(2)
	move 3,4
	andca 3,1
	tdne 1,4
	movei 3,0
	move 1,3
	popj 17,

tsze_mem:
	move 3,(2)
	hlre 4,3
	tlo 4,(3)
	move 3,4
	andca 3,1
	tdne 1,4
	movei 3,0
	move 1,3
	popj 17,

tsze_global:
	move 3,tsz_ga
	hlre 4,3
	tlo 4,(3)
	move 3,4
	andca 3,1
	tdne 1,4
	movei 3,0
	move 1,3
	popj 17,

tsze_select:
	move 6,4
	hlre 4,2
	tlo 4,(2)
	move 2,4
	andca 2,1
	add 3,2
	tdne 1,4
	jrst %L54
	move 3,6
	add 3,2
%L54:
	move 1,3
	popj 17,

tsze_call:
	push 17,10
	hlre 4,2
	tlo 4,(2)
	move 10,4
	andca 10,1
	tdne 1,4
	jrst %L58
%L57:
	move 1,10
	pop 17,10
	popj 17,
%L58:
	pushj 17,f
	add 10,1
	jrst %L57

tsze_likely:
	hlre 4,2
	tlo 4,(2)
	move 3,4
	andca 3,1
	tdne 1,4
	movei 3,0
	move 1,3
	popj 17,

tsze_unlikely:
	hlre 4,2
	tlo 4,(2)
	move 3,4
	andca 3,1
	tdne 1,4
	jrst %L63
%L62:
	move 1,3
	popj 17,
%L63:
	movei 3,0
	jrst %L62

tsze_literal:
	move 4,1
	and 4,[-123456123457]
	tdne 1,[123456123456]
	movei 4,0
	move 1,4
	popj 17,

tsze_literal_highbit:
	move 4,1
	andcmi 4,400000
	trne 1,400000
	movei 4,0
	move 1,4
	popj 17,

tszn_clear:
	hlre 4,2
	tlo 4,(2)
	move 3,4
	andca 3,1
	tdnn 1,4
	movei 3,0
	move 1,3
	popj 17,

tszn_mem:
	move 3,(2)
	hlre 4,3
	tlo 4,(3)
	move 3,4
	andca 3,1
	tdnn 1,4
	movei 3,0
	move 1,3
	popj 17,

tszn_global:
	move 3,tsz_ga
	hlre 4,3
	tlo 4,(3)
	move 3,4
	andca 3,1
	tdnn 1,4
	movei 3,0
	move 1,3
	popj 17,

tszn_select:
	move 6,4
	hlre 4,2
	tlo 4,(2)
	move 2,4
	andca 2,1
	add 3,2
	tdnn 1,4
	jrst %L74
	move 3,6
	add 3,2
%L74:
	move 1,3
	popj 17,

tszn_call:
	push 17,10
	hlre 4,2
	tlo 4,(2)
	move 10,4
	andca 10,1
	tdnn 1,4
	jrst %L78
%L77:
	move 1,10
	pop 17,10
	popj 17,
%L78:
	pushj 17,f
	add 10,1
	jrst %L77

tszn_likely:
	hlre 4,2
	tlo 4,(2)
	move 3,4
	andca 3,1
	tdnn 1,4
	movei 3,0
	move 1,3
	popj 17,

tszn_unlikely:
	hlre 4,2
	tlo 4,(2)
	move 3,4
	andca 3,1
	tdnn 1,4
	jrst %L83
%L82:
	move 1,3
	popj 17,
%L83:
	movei 3,0
	jrst %L82

tszn_literal:
	move 4,1
	and 4,[-123456123457]
	tdnn 1,[123456123456]
	movei 4,0
	move 1,4
	popj 17,

tszn_literal_highbit:
	move 4,1
	andcmi 4,400000
	trnn 1,400000
	movei 4,0
	move 1,4
	popj 17,

tsza_goto:
	hlre 4,2
	tlo 4,(2)
	andcm 1,4
%L89:
	popj 17,

tsza_mem_goto:
	move 3,(2)
	hlre 4,3
	tlo 4,(3)
	andcm 1,4
%L91:
	popj 17,

tsza_select:
	hlre 4,2
	tlo 4,(2)
	andcm 1,4
%L94:
	popj 17,

tsza_call:
	push 17,10
	move 10,1
	hlre 4,2
	tlo 4,(2)
	andcm 10,4
%L96:
	pushj 17,f
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

tsz_chain:
	move 6,1
	hlre 4,2
	tlo 4,(2)
	andcm 6,4
	hlre 1,3
	tlo 1,(3)
	andca 1,6
	popj 17,

tsz_chain_same:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	andca 1,4
	popj 17,

tsz_mix_add:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	andca 1,4
	add 1,3
	popj 17,

tsz_mix_or:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	andca 1,4
	ior 1,3
	popj 17,

tsz_mix_xor:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	andca 1,4
	xor 1,3
	popj 17,

tsz_mix_sub:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	andca 1,4
	sub 1,3
	popj 17,

tsz_from_expr:
	move 4,1
	add 4,2
	hlre 1,3
	tlo 1,(3)
	andca 1,4
	popj 17,

tsz_from_xor_expr:
	move 4,1
	xor 4,2
	hlre 1,3
	tlo 1,(3)
	andca 1,4
	popj 17,

tsz_two_tests:
	hlre 4,2
	tlo 4,(2)
	andcm 1,4
	hlre 4,3
	tlo 4,(3)
	tdne 1,4
	andcm 1,4
	popj 17,

utsz_reg_reg:
	movs 2,2
	andca 2,1
	move 1,2
	popj 17,

utsz_reg_mem:
	move 4,1
	movs 1,(2)
	andca 1,4
	popj 17,

utsz_global:
	move 4,1
	movs 1,tsz_uga
	andca 1,4
	popj 17,

utsz_array:
	move 4,1
	andi 3,17
	add 2,3
	movs 1,(2)
	andca 1,4
	popj 17,

utsz_global_array:
	andi 2,17
	movs 4,tsz_ubuf(2)
	andca 4,1
	move 1,4
	popj 17,

utsz_struct_a:
	move 4,1
	movs 1,(2)
	andca 1,4
	popj 17,

utsz_global_struct_a:
	move 4,1
	movs 1,tsz_ugp
	andca 1,4
	popj 17,

utsz_literal:
	and 1,[-123456123457]
	popj 17,

utsz_update_mem:
	movs 2,2
	andcam 2,(1)
	popj 17,

utsz_update_global:
	movs 1,1
	andcam 1,tsz_uga
	popj 17,

utsz_update_return:
	movs 2,2
	move 4,2
	andcab 4,(1)
	move 1,4
	popj 17,

utsze_bool:
	movs 2,2
	move 4,2
	andca 4,1
	skipe 4
	movei 4,1
	tdnn 1,2
	movei 4,0
	move 1,4
	popj 17,

utszn_bool:
	movs 2,2
	move 4,2
	andca 4,1
	skipe 4
	movei 4,1
	tdne 1,2
	movei 4,0
	move 1,4
	popj 17,

tsz_qi:
	hrlz 2,2
	hrloi 6,777000
	orca 2,6
	and 2,1
	move 1,2
	popj 17,

tsz_hi:
	tlz 1,(2)
	popj 17,

tsz_qi_mem:
	ldb 2,2
	tlz 1,(2)
	popj 17,

tsz_hi_mem:
	ldb 2,2
	tlz 1,(2)
	popj 17,

	.bss
tsz_ga:
	.space	4
tsz_gb:
	.space	4
tsz_uga:
	.space	4
tsz_buf:
	.space	64
tsz_ubuf:
	.space	64
tsz_gp:
	.space	8
tsz_ugp:
	.space	8
