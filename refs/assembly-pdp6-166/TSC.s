
tsc_reg_reg:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	xor 1,4
	popj 17,

tsc_reg_mem:
	move 3,1
	move 4,(2)
	hlre 1,4
	tlo 1,(4)
	xor 1,3
	popj 17,

tsc_mem_reg:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	xor 1,(4)
	popj 17,

tsc_mem_mem:
	move 3,1
	move 4,(2)
	hlre 1,4
	tlo 1,(4)
	xor 1,(3)
	popj 17,

tsc_global_a:
	move 3,tsc_ga
	hlre 4,3
	tlo 4,(3)
	xor 4,1
	move 1,4
	popj 17,

tsc_global_b:
	move 4,tsc_gb
	hlre 1,4
	tlo 1,(4)
	xor 1,tsc_ga
	popj 17,

tsc_array:
	move 6,1
	andi 3,17
	add 2,3
	move 4,(2)
	hlre 1,4
	tlo 1,(4)
	xor 1,6
	popj 17,

tsc_global_array:
	move 3,1
	andi 2,17
	move 4,tsc_buf(2)
	hlre 1,4
	tlo 1,(4)
	xor 1,3
	popj 17,

tsc_struct_a:
	move 3,1
	move 4,(2)
	hlre 1,4
	tlo 1,(4)
	xor 1,3
	popj 17,

tsc_struct_b:
	move 3,1
	move 4,1(2)
	hlre 1,4
	tlo 1,(4)
	xor 1,3
	popj 17,

tsc_global_struct_a:
	move 3,tsc_gp
	hlre 4,3
	tlo 4,(3)
	xor 4,1
	move 1,4
	popj 17,

tsc_global_struct_b:
	move 3,tsc_gp+1
	hlre 4,3
	tlo 4,(3)
	xor 4,1
	move 1,4
	popj 17,

tsc_indirect:
	move 3,1
	move 4,@(2)
	hlre 1,4
	tlo 1,(4)
	xor 1,3
	popj 17,

tsc_volatile:
	move 3,1
	move 4,(2)
	move 1,(2)
	hlre 1,1
	tlo 1,(4)
	xor 1,3
	popj 17,

tsc_loaded:
	move 3,1
	move 4,(2)
	hlre 1,4
	tlo 1,(4)
	xor 1,3
	popj 17,

tsc_loaded_global:
	move 3,tsc_ga
	hlre 4,3
	tlo 4,(3)
	xor 4,1
	move 1,4
	popj 17,

tsc_literal_a:
	xor 1,[123456123456]
	popj 17,

tsc_literal_b:
	xor 1,[252525525252]
	popj 17,

tsc_literal_sparse:
	xor 1,[70707707070]
	popj 17,

tsc_literal_left:
	xori 1,123456
	popj 17,

tsc_literal_right:
	tlc 1,123456
	popj 17,

tsc_literal_highbit:
	xori 1,400000
	popj 17,

tsc_literal_all:
	setca 1,
	popj 17,

tsc_store:
	hlre 4,3
	tlo 4,(3)
	xor 2,4
	movem 2,(1)
	popj 17,

tsc_store_mem:
	move 3,(3)
	hlre 4,3
	tlo 4,(3)
	xor 2,4
	movem 2,(1)
	popj 17,

tsc_store_return:
	hlre 4,3
	tlo 4,(3)
	xor 2,4
	movem 2,(1)
	move 1,2
	popj 17,

tsc_store_global:
	hlre 4,2
	tlo 4,(2)
	xor 1,4
	movem 1,tsc_ga
	popj 17,

tsc_store_array:
	andi 4,17
	add 3,4
	hlre 4,2
	tlo 4,(2)
	xor 1,4
	movem 1,(3)
	popj 17,

tsc_store_struct_a:
	hlre 4,2
	tlo 4,(2)
	xor 1,4
	movem 1,(3)
	popj 17,

tsc_store_struct_b:
	hlre 4,2
	tlo 4,(2)
	xor 1,4
	movem 1,1(3)
	popj 17,

tsc_update_mem:
	hlre 4,2
	tlo 4,(2)
	xorm 4,(1)
	popj 17,

tsc_update_mem_mem:
	move 3,(2)
	hlre 4,3
	tlo 4,(3)
	xorm 4,(1)
	popj 17,

tsc_update_global:
	hlre 4,1
	tlo 4,(1)
	xorm 4,tsc_ga
	popj 17,

tsc_update_global_mem:
	move 3,(1)
	hlre 4,3
	tlo 4,(3)
	xorm 4,tsc_ga
	popj 17,

tsc_update_array:
	andi 2,17
	add 1,2
	hlre 4,3
	tlo 4,(3)
	xorm 4,(1)
	popj 17,

tsc_update_global_array:
	andi 1,17
	hlre 4,2
	tlo 4,(2)
	xorm 4,tsc_buf(1)
	popj 17,

tsc_update_struct_a:
	hlre 4,2
	tlo 4,(2)
	xorm 4,(1)
	popj 17,

tsc_update_struct_b:
	hlre 4,2
	tlo 4,(2)
	xorm 4,1(1)
	popj 17,

tsc_update_return:
	move 3,1
	hlre 4,2
	tlo 4,(2)
	move 1,4
	xorb 1,(3)
	popj 17,

tsc_global_update_return:
	hlre 4,1
	tlo 4,(1)
	move 1,4
	xorb 1,tsc_ga
	popj 17,

tsc_volatile_update:
	hlre 3,2
	tlo 3,(2)
	move 4,(1)
	xor 4,3
	movem 4,(1)
	popj 17,

tsce_clear:
	hlre 4,2
	tlo 4,(2)
	move 3,1
	xor 3,4
	tdne 1,4
	movei 3,0
	move 1,3
	popj 17,

tsce_mem:
	move 3,(2)
	hlre 4,3
	tlo 4,(3)
	move 3,1
	xor 3,4
	tdne 1,4
	movei 3,0
	move 1,3
	popj 17,

tsce_global:
	move 3,tsc_ga
	hlre 4,3
	tlo 4,(3)
	move 3,1
	xor 3,4
	tdne 1,4
	movei 3,0
	move 1,3
	popj 17,

tsce_select:
	move 6,4
	hlre 4,2
	tlo 4,(2)
	move 2,1
	xor 2,4
	add 3,2
	tdne 1,4
	jrst %L54
	move 3,6
	add 3,2
%L54:
	move 1,3
	popj 17,

tsce_call:
	push 17,10
	hlre 4,2
	tlo 4,(2)
	move 10,1
	xor 10,4
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

tsce_likely:
	hlre 4,2
	tlo 4,(2)
	move 3,1
	xor 3,4
	tdne 1,4
	movei 3,0
	move 1,3
	popj 17,

tsce_unlikely:
	hlre 4,2
	tlo 4,(2)
	move 3,1
	xor 3,4
	tdne 1,4
	jrst %L63
%L62:
	move 1,3
	popj 17,
%L63:
	movei 3,0
	jrst %L62

tsce_literal:
	move 4,[123456123456]
	move 3,1
	xor 3,4
	tdne 1,4
	movei 3,0
	move 1,3
	popj 17,

tsce_literal_highbit:
	move 4,1
	xori 4,400000
	trne 1,400000
	movei 4,0
	move 1,4
	popj 17,

tsce_literal_all:
	setcm 4,1
	jumpe 1,%L69
	movei 4,0
%L69:
	move 1,4
	popj 17,

tscn_clear:
	hlre 4,2
	tlo 4,(2)
	move 3,1
	xor 3,4
	tdnn 1,4
	movei 3,0
	move 1,3
	popj 17,

tscn_mem:
	move 3,(2)
	hlre 4,3
	tlo 4,(3)
	move 3,1
	xor 3,4
	tdnn 1,4
	movei 3,0
	move 1,3
	popj 17,

tscn_global:
	move 3,tsc_ga
	hlre 4,3
	tlo 4,(3)
	move 3,1
	xor 3,4
	tdnn 1,4
	movei 3,0
	move 1,3
	popj 17,

tscn_select:
	move 6,4
	hlre 4,2
	tlo 4,(2)
	move 2,1
	xor 2,4
	add 3,2
	tdnn 1,4
	jrst %L76
	move 3,6
	add 3,2
%L76:
	move 1,3
	popj 17,

tscn_call:
	push 17,10
	hlre 4,2
	tlo 4,(2)
	move 10,1
	xor 10,4
	tdnn 1,4
	jrst %L80
%L79:
	move 1,10
	pop 17,10
	popj 17,
%L80:
	pushj 17,f
	add 10,1
	jrst %L79

tscn_likely:
	hlre 4,2
	tlo 4,(2)
	move 3,1
	xor 3,4
	tdnn 1,4
	movei 3,0
	move 1,3
	popj 17,

tscn_unlikely:
	hlre 4,2
	tlo 4,(2)
	move 3,1
	xor 3,4
	tdnn 1,4
	jrst %L85
%L84:
	move 1,3
	popj 17,
%L85:
	movei 3,0
	jrst %L84

tscn_literal:
	move 4,[123456123456]
	move 3,1
	xor 3,4
	tdnn 1,4
	movei 3,0
	move 1,3
	popj 17,

tscn_literal_highbit:
	move 4,1
	xori 4,400000
	trnn 1,400000
	movei 4,0
	move 1,4
	popj 17,

tscn_literal_all:
	setcm 4,1
	jumpn 1,%L91
	movei 4,0
%L91:
	move 1,4
	popj 17,

tsca_goto:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	xor 1,4
%L93:
	popj 17,

tsca_mem_goto:
	move 3,1
	move 4,(2)
	hlre 1,4
	tlo 1,(4)
	xor 1,3
%L95:
	popj 17,

tsca_select:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	xor 1,4
%L98:
	popj 17,

tsca_call:
	push 17,10
	move 10,1
	hlre 4,2
	tlo 4,(2)
	xor 10,4
%L100:
	pushj 17,f
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

tsc_chain:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	xor 1,4
	hlre 4,3
	tlo 4,(3)
	xor 1,4
	popj 17,

tsc_mix_add:
	hlre 4,2
	tlo 4,(2)
	xor 1,4
	add 1,3
	popj 17,

tsc_mix_and:
	hlre 4,2
	tlo 4,(2)
	xor 1,4
	and 1,3
	popj 17,

tsc_mix_or:
	hlre 4,2
	tlo 4,(2)
	xor 1,4
	ior 1,3
	popj 17,

tsc_mix_sub:
	hlre 4,2
	tlo 4,(2)
	xor 1,4
	sub 1,3
	popj 17,

tsc_from_expr:
	move 4,1
	add 4,2
	hlre 1,3
	tlo 1,(3)
	xor 1,4
	popj 17,

tsc_from_xor_expr:
	move 4,1
	xor 4,2
	hlre 1,3
	tlo 1,(3)
	xor 1,4
	popj 17,

tsc_two_tests:
	hlre 4,2
	tlo 4,(2)
	xor 1,4
	hlre 4,3
	tlo 4,(3)
	tdne 1,4
	xor 1,4
	popj 17,

utsc_reg_reg:
	movs 2,2
	xor 2,1
	move 1,2
	popj 17,

utsc_reg_mem:
	move 4,1
	movs 1,(2)
	xor 1,4
	popj 17,

utsc_global:
	move 4,1
	movs 1,tsc_uga
	xor 1,4
	popj 17,

utsc_array:
	move 4,1
	andi 3,17
	add 2,3
	movs 1,(2)
	xor 1,4
	popj 17,

utsc_global_array:
	andi 2,17
	movs 4,tsc_ubuf(2)
	xor 4,1
	move 1,4
	popj 17,

utsc_struct_a:
	move 4,1
	movs 1,(2)
	xor 1,4
	popj 17,

utsc_global_struct_a:
	move 4,1
	movs 1,tsc_ugp
	xor 1,4
	popj 17,

utsc_literal:
	xor 1,[123456123456]
	popj 17,

utsc_update_mem:
	movs 2,2
	xorm 2,(1)
	popj 17,

utsc_update_global:
	movs 1,1
	xorm 1,tsc_uga
	popj 17,

utsc_update_return:
	movs 2,2
	move 4,2
	xorb 4,(1)
	move 1,4
	popj 17,

utsce_bool:
	movs 2,2
	move 4,1
	xor 4,2
	skipe 4
	movei 4,1
	tdnn 1,2
	movei 4,0
	move 1,4
	popj 17,

utscn_bool:
	movs 2,2
	move 4,1
	xor 4,2
	skipe 4
	movei 4,1
	tdne 1,2
	movei 4,0
	move 1,4
	popj 17,

tsc_qi:
	hrlz 2,2
	and 2,[777000000]
	xor 2,1
	move 1,2
	popj 17,

tsc_hi:
	tlc 1,(2)
	popj 17,

tsc_qi_mem:
	move 3,1
	ldb 4,2
	hlre 1,4
	tlo 1,(4)
	xor 1,3
	popj 17,

tsc_hi_mem:
	move 3,1
	ldb 4,2
	hlre 1,4
	tlo 1,(4)
	xor 1,3
	popj 17,

	.bss
tsc_ga:
	.space	4
tsc_gb:
	.space	4
tsc_uga:
	.space	4
tsc_buf:
	.space	64
tsc_ubuf:
	.space	64
tsc_gp:
	.space	8
tsc_ugp:
	.space	8
