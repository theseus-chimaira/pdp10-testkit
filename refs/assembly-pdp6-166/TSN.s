
tsn_reg_reg:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	and 1,4
	popj 17,

tsn_reg_mem:
	move 3,1
	move 4,(2)
	hlre 1,4
	tlo 1,(4)
	and 1,3
	popj 17,

tsn_mem_reg:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	and 1,(4)
	popj 17,

tsn_mem_mem:
	move 3,1
	move 4,(2)
	hlre 1,4
	tlo 1,(4)
	and 1,(3)
	popj 17,

tsn_global_a:
	move 3,tsn_ga
	hlre 4,3
	tlo 4,(3)
	and 4,1
	move 1,4
	popj 17,

tsn_global_b:
	move 4,tsn_gb
	hlre 1,4
	tlo 1,(4)
	and 1,tsn_ga
	popj 17,

tsn_array:
	move 6,1
	andi 3,17
	add 2,3
	move 4,(2)
	hlre 1,4
	tlo 1,(4)
	and 1,6
	popj 17,

tsn_global_array:
	move 3,1
	andi 2,17
	move 4,tsn_buf(2)
	hlre 1,4
	tlo 1,(4)
	and 1,3
	popj 17,

tsn_struct_a:
	move 3,1
	move 4,(2)
	hlre 1,4
	tlo 1,(4)
	and 1,3
	popj 17,

tsn_struct_b:
	move 3,1
	move 4,1(2)
	hlre 1,4
	tlo 1,(4)
	and 1,3
	popj 17,

tsn_global_struct_a:
	move 3,tsn_gp
	hlre 4,3
	tlo 4,(3)
	and 4,1
	move 1,4
	popj 17,

tsn_global_struct_b:
	move 3,tsn_gp+1
	hlre 4,3
	tlo 4,(3)
	and 4,1
	move 1,4
	popj 17,

tsn_indirect:
	move 3,1
	move 4,@(2)
	hlre 1,4
	tlo 1,(4)
	and 1,3
	popj 17,

tsn_volatile:
	move 3,1
	move 4,(2)
	move 1,(2)
	hlre 1,1
	tlo 1,(4)
	and 1,3
	popj 17,

tsn_loaded:
	move 3,1
	move 4,(2)
	hlre 1,4
	tlo 1,(4)
	and 1,3
	popj 17,

tsn_loaded_global:
	move 3,tsn_ga
	hlre 4,3
	tlo 4,(3)
	and 4,1
	move 1,4
	popj 17,

tsn_loaded_array:
	move 6,1
	andi 3,17
	add 2,3
	move 4,(2)
	hlre 1,4
	tlo 1,(4)
	and 1,6
	popj 17,

tsn_literal_a:
	and 1,[123456123456]
	popj 17,

tsn_literal_b:
	and 1,[252525525252]
	popj 17,

tsn_literal_sparse:
	and 1,[70707707070]
	popj 17,

tsn_literal_left:
	andi 1,123456
	popj 17,

tsn_literal_right:
	and 1,[123456000000]
	popj 17,

tsn_literal_highbit:
	andi 1,400000
	popj 17,

tsn_literal_all:
	popj 17,

tsn_commuted_reg_reg:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	and 1,4
	popj 17,

tsn_commuted_mem:
	move 3,1
	move 4,(2)
	hlre 1,4
	tlo 1,(4)
	and 1,3
	popj 17,

tsn_chain:
	hlre 4,2
	tlo 4,(2)
	and 1,4
	add 1,3
	popj 17,

tsn_chain_and:
	hlre 4,2
	tlo 4,(2)
	and 1,4
	and 1,3
	popj 17,

tsn_chain_or:
	hlre 4,2
	tlo 4,(2)
	and 1,4
	ior 1,3
	popj 17,

tsn_chain_xor:
	hlre 4,2
	tlo 4,(2)
	and 1,4
	xor 1,3
	popj 17,

tsn_store_value:
	hlre 4,2
	tlo 4,(2)
	and 1,4
	movem 1,(3)
	popj 17,

tsn_store_only:
	hlre 4,2
	tlo 4,(2)
	and 1,4
	movem 1,(3)
	popj 17,

tsn_store_global:
	hlre 4,2
	tlo 4,(2)
	and 1,4
	movem 1,tsn_ga
	popj 17,

tsn_store_global_only:
	hlre 4,2
	tlo 4,(2)
	and 1,4
	movem 1,tsn_ga
	popj 17,

tsn_store_array:
	andi 4,17
	add 3,4
	hlre 4,2
	tlo 4,(2)
	and 1,4
	movem 1,(3)
	popj 17,

tsn_store_struct_a:
	hlre 4,2
	tlo 4,(2)
	and 1,4
	movem 1,(3)
	popj 17,

tsn_store_struct_b:
	hlre 4,2
	tlo 4,(2)
	and 1,4
	movem 1,1(3)
	popj 17,

tsn_two_sources:
	move 6,1
	hlre 1,2
	tlo 1,(2)
	and 1,6
	hlre 4,3
	tlo 4,(3)
	and 4,6
	add 1,4
	popj 17,

tsn_two_mem_sources:
	move 6,1
	move 4,(2)
	hlre 1,4
	tlo 1,(4)
	and 1,6
	move 3,(3)
	hlre 4,3
	tlo 4,(3)
	and 4,6
	add 1,4
	popj 17,

tsn_after_add:
	move 4,1
	add 4,3
	hlre 1,2
	tlo 1,(2)
	and 1,4
	popj 17,

tsn_after_xor:
	move 4,1
	xor 4,3
	hlre 1,2
	tlo 1,(2)
	and 1,4
	popj 17,

tsn_after_or:
	move 4,1
	ior 4,3
	hlre 1,2
	tlo 1,(2)
	and 1,4
	popj 17,

utsn_reg_reg:
	movs 2,2
	and 2,1
	move 1,2
	popj 17,

utsn_reg_mem:
	move 4,1
	movs 1,(2)
	and 1,4
	popj 17,

utsn_global:
	move 4,1
	movs 1,tsn_uga
	and 1,4
	popj 17,

utsn_array:
	move 4,1
	andi 3,17
	add 2,3
	movs 1,(2)
	and 1,4
	popj 17,

utsn_global_array:
	andi 2,17
	movs 4,tsn_ubuf(2)
	and 4,1
	move 1,4
	popj 17,

utsn_struct_a:
	move 4,1
	movs 1,(2)
	and 1,4
	popj 17,

utsn_global_struct_a:
	move 4,1
	movs 1,tsn_ugp
	and 1,4
	popj 17,

utsn_literal:
	and 1,[123456123456]
	popj 17,

utsn_literal_right:
	and 1,[123456000000]
	popj 17,

utsn_literal_left:
	andi 1,123456
	popj 17,

utsn_store_value:
	movs 2,2
	and 1,2
	movem 1,(3)
	popj 17,

tsn_qi:
	hrlz 2,2
	and 2,[777000000]
	and 2,1
	move 1,2
	popj 17,

tsn_hi:
	hrlz 2,2
	and 2,1
	move 1,2
	popj 17,

tsn_qi_mem:
	move 3,1
	ldb 4,2
	hlre 1,4
	tlo 1,(4)
	and 1,3
	popj 17,

tsn_hi_mem:
	move 3,1
	ldb 4,2
	hlre 1,4
	tlo 1,(4)
	and 1,3
	popj 17,

tsn_signed_qi:
	lsh 2,33
	ash 2,-33
	hlre 4,2
	tlo 4,(2)
	and 4,1
	move 1,4
	popj 17,

tsn_signed_hi:
	move 4,1
	move 1,2
	lsh 1,22
	ash 1,-43
	tlo 1,(2)
	and 1,4
	popj 17,

	.bss
tsn_ga:
	.space	4
tsn_gb:
	.space	4
tsn_uga:
	.space	4
tsn_buf:
	.space	64
tsn_ubuf:
	.space	64
tsn_gp:
	.space	8
tsn_ugp:
	.space	8
