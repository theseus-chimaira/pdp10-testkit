
tso_reg_reg:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	ior 1,4
	popj 17,

tso_reg_mem:
	move 3,1
	move 4,(2)
	hlre 1,4
	tlo 1,(4)
	ior 1,3
	popj 17,

tso_mem_reg:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	ior 1,(4)
	popj 17,

tso_mem_mem:
	move 3,1
	move 4,(2)
	hlre 1,4
	tlo 1,(4)
	ior 1,(3)
	popj 17,

tso_global_a:
	move 3,tso_ga
	hlre 4,3
	tlo 4,(3)
	ior 4,1
	move 1,4
	popj 17,

tso_global_b:
	move 4,tso_gb
	hlre 1,4
	tlo 1,(4)
	ior 1,tso_ga
	popj 17,

tso_array:
	move 6,1
	andi 3,17
	add 2,3
	move 4,(2)
	hlre 1,4
	tlo 1,(4)
	ior 1,6
	popj 17,

tso_global_array:
	move 3,1
	andi 2,17
	move 4,tso_buf(2)
	hlre 1,4
	tlo 1,(4)
	ior 1,3
	popj 17,

tso_struct_a:
	move 3,1
	move 4,(2)
	hlre 1,4
	tlo 1,(4)
	ior 1,3
	popj 17,

tso_struct_b:
	move 3,1
	move 4,1(2)
	hlre 1,4
	tlo 1,(4)
	ior 1,3
	popj 17,

tso_global_struct_a:
	move 3,tso_gp
	hlre 4,3
	tlo 4,(3)
	ior 4,1
	move 1,4
	popj 17,

tso_global_struct_b:
	move 3,tso_gp+1
	hlre 4,3
	tlo 4,(3)
	ior 4,1
	move 1,4
	popj 17,

tso_indirect:
	move 3,1
	move 4,@(2)
	hlre 1,4
	tlo 1,(4)
	ior 1,3
	popj 17,

tso_volatile:
	move 3,1
	move 4,(2)
	move 1,(2)
	hlre 1,1
	tlo 1,(4)
	ior 1,3
	popj 17,

tso_loaded:
	move 3,1
	move 4,(2)
	hlre 1,4
	tlo 1,(4)
	ior 1,3
	popj 17,

tso_loaded_global:
	move 3,tso_ga
	hlre 4,3
	tlo 4,(3)
	ior 4,1
	move 1,4
	popj 17,

tso_literal_a:
	ior 1,[123456123456]
	popj 17,

tso_literal_b:
	ior 1,[252525525252]
	popj 17,

tso_literal_sparse:
	ior 1,[70707707070]
	popj 17,

tso_literal_left:
	iori 1,123456
	popj 17,

tso_literal_right:
	tlo 1,123456
	popj 17,

tso_literal_highbit:
	iori 1,400000
	popj 17,

tso_literal_all:
	seto 1,
	popj 17,

tso_store:
	hlre 4,3
	tlo 4,(3)
	ior 2,4
	movem 2,(1)
	popj 17,

tso_store_mem:
	move 3,(3)
	hlre 4,3
	tlo 4,(3)
	ior 2,4
	movem 2,(1)
	popj 17,

tso_store_return:
	hlre 4,3
	tlo 4,(3)
	ior 2,4
	movem 2,(1)
	move 1,2
	popj 17,

tso_store_global:
	hlre 4,2
	tlo 4,(2)
	ior 1,4
	movem 1,tso_ga
	popj 17,

tso_store_array:
	andi 4,17
	add 3,4
	hlre 4,2
	tlo 4,(2)
	ior 1,4
	movem 1,(3)
	popj 17,

tso_store_struct_a:
	hlre 4,2
	tlo 4,(2)
	ior 1,4
	movem 1,(3)
	popj 17,

tso_store_struct_b:
	hlre 4,2
	tlo 4,(2)
	ior 1,4
	movem 1,1(3)
	popj 17,

tso_update_mem:
	hlre 4,2
	tlo 4,(2)
	iorm 4,(1)
	popj 17,

tso_update_mem_mem:
	move 3,(2)
	hlre 4,3
	tlo 4,(3)
	iorm 4,(1)
	popj 17,

tso_update_global:
	hlre 4,1
	tlo 4,(1)
	iorm 4,tso_ga
	popj 17,

tso_update_global_mem:
	move 3,(1)
	hlre 4,3
	tlo 4,(3)
	iorm 4,tso_ga
	popj 17,

tso_update_array:
	andi 2,17
	add 1,2
	hlre 4,3
	tlo 4,(3)
	iorm 4,(1)
	popj 17,

tso_update_global_array:
	andi 1,17
	hlre 4,2
	tlo 4,(2)
	iorm 4,tso_buf(1)
	popj 17,

tso_update_struct_a:
	hlre 4,2
	tlo 4,(2)
	iorm 4,(1)
	popj 17,

tso_update_struct_b:
	hlre 4,2
	tlo 4,(2)
	iorm 4,1(1)
	popj 17,

tso_update_return:
	move 3,1
	hlre 4,2
	tlo 4,(2)
	move 1,4
	iorb 1,(3)
	popj 17,

tso_global_update_return:
	hlre 4,1
	tlo 4,(1)
	move 1,4
	iorb 1,tso_ga
	popj 17,

tso_volatile_update:
	hlre 3,2
	tlo 3,(2)
	move 4,(1)
	ior 4,3
	movem 4,(1)
	popj 17,

tsoe_clear:
	hlre 4,2
	tlo 4,(2)
	move 3,1
	ior 3,4
	tdne 1,4
	movei 3,0
	move 1,3
	popj 17,

tsoe_mem:
	move 3,(2)
	hlre 4,3
	tlo 4,(3)
	move 3,1
	ior 3,4
	tdne 1,4
	movei 3,0
	move 1,3
	popj 17,

tsoe_global:
	move 3,tso_ga
	hlre 4,3
	tlo 4,(3)
	move 3,1
	ior 3,4
	tdne 1,4
	movei 3,0
	move 1,3
	popj 17,

tsoe_select:
	move 6,4
	hlre 4,2
	tlo 4,(2)
	move 2,1
	ior 2,4
	add 3,2
	tdne 1,4
	jrst %L54
	move 3,6
	add 3,2
%L54:
	move 1,3
	popj 17,

tsoe_call:
	push 17,10
	hlre 4,2
	tlo 4,(2)
	move 10,1
	ior 10,4
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

tsoe_likely:
	hlre 4,2
	tlo 4,(2)
	move 3,1
	ior 3,4
	tdne 1,4
	movei 3,0
	move 1,3
	popj 17,

tsoe_unlikely:
	hlre 4,2
	tlo 4,(2)
	move 3,1
	ior 3,4
	tdne 1,4
	jrst %L63
%L62:
	move 1,3
	popj 17,
%L63:
	movei 3,0
	jrst %L62

tsoe_literal:
	move 4,[123456123456]
	move 3,1
	ior 3,4
	tdne 1,4
	movei 3,0
	move 1,3
	popj 17,

tsoe_literal_highbit:
	move 4,1
	iori 4,400000
	trne 1,400000
	movei 4,0
	move 1,4
	popj 17,

tsoe_literal_all:
	skipe 1
	tdza 1,1
	movei 1,1
	movn 1,1
	popj 17,

tson_clear:
	hlre 4,2
	tlo 4,(2)
	move 3,1
	ior 3,4
	tdnn 1,4
	movei 3,0
	move 1,3
	popj 17,

tson_mem:
	move 3,(2)
	hlre 4,3
	tlo 4,(3)
	move 3,1
	ior 3,4
	tdnn 1,4
	movei 3,0
	move 1,3
	popj 17,

tson_global:
	move 3,tso_ga
	hlre 4,3
	tlo 4,(3)
	move 3,1
	ior 3,4
	tdnn 1,4
	movei 3,0
	move 1,3
	popj 17,

tson_select:
	move 6,4
	hlre 4,2
	tlo 4,(2)
	move 2,1
	ior 2,4
	add 3,2
	tdnn 1,4
	jrst %L76
	move 3,6
	add 3,2
%L76:
	move 1,3
	popj 17,

tson_call:
	push 17,10
	hlre 4,2
	tlo 4,(2)
	move 10,1
	ior 10,4
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

tson_likely:
	hlre 4,2
	tlo 4,(2)
	move 3,1
	ior 3,4
	tdnn 1,4
	movei 3,0
	move 1,3
	popj 17,

tson_unlikely:
	hlre 4,2
	tlo 4,(2)
	move 3,1
	ior 3,4
	tdnn 1,4
	jrst %L85
%L84:
	move 1,3
	popj 17,
%L85:
	movei 3,0
	jrst %L84

tson_literal:
	move 4,[123456123456]
	move 3,1
	ior 3,4
	tdnn 1,4
	movei 3,0
	move 1,3
	popj 17,

tson_literal_highbit:
	move 4,1
	iori 4,400000
	trnn 1,400000
	movei 4,0
	move 1,4
	popj 17,

tson_literal_all:
	skipe 1
	movei 1,1
	movn 1,1
	popj 17,

tsoa_goto:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	ior 1,4
%L93:
	popj 17,

tsoa_mem_goto:
	move 3,1
	move 4,(2)
	hlre 1,4
	tlo 1,(4)
	ior 1,3
%L95:
	popj 17,

tsoa_select:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	ior 1,4
%L98:
	popj 17,

tsoa_call:
	push 17,10
	move 10,1
	hlre 4,2
	tlo 4,(2)
	ior 10,4
%L100:
	pushj 17,f
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

tso_chain:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	ior 1,4
	hlre 4,3
	tlo 4,(3)
	ior 1,4
	popj 17,

tso_chain_same:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	ior 1,4
	popj 17,

tso_mix_add:
	hlre 4,2
	tlo 4,(2)
	ior 1,4
	add 1,3
	popj 17,

tso_mix_and:
	hlre 4,2
	tlo 4,(2)
	ior 1,4
	and 1,3
	popj 17,

tso_mix_xor:
	hlre 4,2
	tlo 4,(2)
	ior 1,4
	xor 1,3
	popj 17,

tso_mix_sub:
	hlre 4,2
	tlo 4,(2)
	ior 1,4
	sub 1,3
	popj 17,

tso_from_expr:
	move 4,1
	add 4,2
	hlre 1,3
	tlo 1,(3)
	ior 1,4
	popj 17,

tso_from_xor_expr:
	move 4,1
	xor 4,2
	hlre 1,3
	tlo 1,(3)
	ior 1,4
	popj 17,

tso_two_tests:
	hlre 4,2
	tlo 4,(2)
	ior 1,4
	hlre 4,3
	tlo 4,(3)
	tdne 1,4
	ior 1,4
	popj 17,

utso_reg_reg:
	movs 2,2
	ior 2,1
	move 1,2
	popj 17,

utso_reg_mem:
	move 4,1
	movs 1,(2)
	ior 1,4
	popj 17,

utso_global:
	move 4,1
	movs 1,tso_uga
	ior 1,4
	popj 17,

utso_array:
	move 4,1
	andi 3,17
	add 2,3
	movs 1,(2)
	ior 1,4
	popj 17,

utso_global_array:
	andi 2,17
	movs 4,tso_ubuf(2)
	ior 4,1
	move 1,4
	popj 17,

utso_struct_a:
	move 4,1
	movs 1,(2)
	ior 1,4
	popj 17,

utso_global_struct_a:
	move 4,1
	movs 1,tso_ugp
	ior 1,4
	popj 17,

utso_literal:
	ior 1,[123456123456]
	popj 17,

utso_update_mem:
	movs 2,2
	iorm 2,(1)
	popj 17,

utso_update_global:
	movs 1,1
	iorm 1,tso_uga
	popj 17,

utso_update_return:
	movs 2,2
	move 4,2
	iorb 4,(1)
	move 1,4
	popj 17,

utsoe_bool:
	movs 2,2
	move 4,1
	ior 4,2
	skipe 4
	movei 4,1
	tdnn 1,2
	movei 4,0
	move 1,4
	popj 17,

utson_bool:
	movs 2,2
	move 4,1
	ior 4,2
	skipe 4
	movei 4,1
	tdne 1,2
	movei 4,0
	move 1,4
	popj 17,

tso_qi:
	hrlz 2,2
	and 2,[777000000]
	ior 2,1
	move 1,2
	popj 17,

tso_hi:
	tlo 1,(2)
	popj 17,

tso_qi_mem:
	move 3,1
	ldb 4,2
	hlre 1,4
	tlo 1,(4)
	ior 1,3
	popj 17,

tso_hi_mem:
	move 3,1
	ldb 4,2
	hlre 1,4
	tlo 1,(4)
	ior 1,3
	popj 17,

	.bss
tso_ga:
	.space	4
tso_gb:
	.space	4
tso_uga:
	.space	4
tso_buf:
	.space	64
tso_ubuf:
	.space	64
tso_gp:
	.space	8
tso_ugp:
	.space	8
