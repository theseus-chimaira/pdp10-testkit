
xor_reg_reg:
	xor 1,2
	popj 17,

xor_reg_mem:
	xor 1,(2)
	popj 17,

xor_mem_reg:
	xor 2,(1)
	move 1,2
	popj 17,

xor_mem_mem:
	move 1,(1)
	xor 1,(2)
	popj 17,

xor_global_a:
	xor 1,xor_ga
	popj 17,

xor_global_b:
	move 1,xor_ga
	xor 1,xor_gb
	popj 17,

xor_array:
	andi 2,17
	add 1,2
	xor 3,(1)
	move 1,3
	popj 17,

xor_global_array:
	andi 1,17
	xor 2,xor_buf(1)
	move 1,2
	popj 17,

xor_struct_a:
	xor 2,(1)
	move 1,2
	popj 17,

xor_struct_b:
	xor 2,1(1)
	move 1,2
	popj 17,

xor_global_struct_a:
	xor 1,xor_gp
	popj 17,

xor_global_struct_b:
	xor 1,xor_gp+1
	popj 17,

xor_indirect:
	xor 2,@(1)
	move 1,2
	popj 17,

xor_volatile:
	move 4,1
	move 1,(2)
	xor 1,4
	popj 17,

xori_one:
	xori 1,1
	popj 17,

xori_small:
	xori 1,123456
	popj 17,

xori_low9:
	xori 1,777
	popj 17,

xori_low18:
	xori 1,777777
	popj 17,

xor_literal:
	xor 1,[123456123456]
	popj 17,

xor_literal_alt:
	xor 1,[-252525525253]
	popj 17,

xor_literal_sparse:
	xor 1,[-70707707071]
	popj 17,

xor_literal_sign:
	tlc 1,400000
	popj 17,

xor_literal_all:
	setca 1,
	popj 17,

xor_commuted_small:
	xori 1,123456
	popj 17,

xor_commuted_literal:
	xor 1,[123456123456]
	popj 17,

xorm_reg_mem:
	xorm 1,(2)
	popj 17,

xorm_reg_mem_explicit:
	xorm 1,(2)
	popj 17,

xorm_global_a:
	xorm 1,xor_ga
	popj 17,

xorm_global_b:
	xorm 1,xor_gb
	popj 17,

xorm_array:
	andi 2,17
	add 1,2
	xorm 3,(1)
	popj 17,

xorm_global_array:
	andi 1,17
	xorm 2,xor_buf(1)
	popj 17,

xorm_struct_a:
	xorm 2,(1)
	popj 17,

xorm_struct_b:
	xorm 2,1(1)
	popj 17,

xorm_global_struct_a:
	xorm 1,xor_gp
	popj 17,

xorm_global_struct_b:
	xorm 1,xor_gp+1
	popj 17,

xorm_indirect:
	xorm 2,@(1)
	popj 17,

xorm_volatile:
	move 4,(2)
	xor 4,1
	movem 4,(2)
	popj 17,

xorm_const_small:
	movei 6,123456
	xorm 6,(1)
	popj 17,

xorm_const_literal:
	move 6,[123456123456]
	xorm 6,(1)
	popj 17,

xorm_return_mem:
	xorb 1,(2)
	popj 17,

xorm_return_global:
	xorb 1,xor_ga
	popj 17,

xorm_return_array:
	move 4,1
	andi 2,17
	add 4,2
	move 1,3
	xorb 1,(4)
	popj 17,

xorm_return_struct_a:
	move 4,2
	xorb 4,(1)
	move 1,4
	popj 17,

xorm_return_struct_b:
	move 4,2
	xorb 4,1(1)
	move 1,4
	popj 17,

xorb_mem_return:
	xorb 1,(2)
	popj 17,

xorb_global_return:
	xorb 1,xor_ga
	popj 17,

xorb_array_return:
	move 4,1
	andi 2,17
	add 4,2
	move 1,3
	xorb 1,(4)
	popj 17,

xorb_struct_a_return:
	move 4,2
	xorb 4,(1)
	move 1,4
	popj 17,

xorb_struct_b_return:
	move 4,2
	xorb 4,1(1)
	move 1,4
	popj 17,

uxor_reg_reg:
	xor 1,2
	popj 17,

uxor_reg_mem:
	xor 1,(2)
	popj 17,

uxor_global:
	xor 1,xor_uga
	popj 17,

uxor_array:
	andi 2,17
	add 1,2
	xor 3,(1)
	move 1,3
	popj 17,

uxori_small:
	xori 1,123456
	popj 17,

uxori_low18:
	xori 1,777777
	popj 17,

uxor_literal:
	xor 1,[123456123456]
	popj 17,

uxor_literal_all:
	setca 1,
	popj 17,

uxorm_mem:
	xorm 1,(2)
	popj 17,

uxorm_global:
	xorm 1,xor_uga
	popj 17,

uxorm_array:
	andi 2,17
	add 1,2
	xorm 3,(1)
	popj 17,

uxorb_mem_return:
	xorb 1,(2)
	popj 17,

uxorb_global_return:
	xorb 1,xor_uga
	popj 17,

xor_qi:
	xor 2,1
	lsh 2,33
	ash 2,-33
	move 1,2
	popj 17,

xor_uqi:
	xor 2,1
	andi 2,777
	move 1,2
	popj 17,

xor_hi:
	xor 2,1
	hrre 2,2
	move 1,2
	popj 17,

xor_uhi:
	hrrzi 2,(2)	; zero_extendhisi2
	xori 2,(1)
	move 1,2
	popj 17,

xor_qi_mem:
	ldb 2,2
	xor 1,2
	lsh 1,33
	ash 1,-33
	popj 17,

xor_uqi_mem:
	andi 1,777	; zero_extendqisi2
	ldb 2,2
	xor 1,2
	popj 17,

xor_hi_mem:
	ldb 2,2
	xori 2,(1)
	hrre 1,2	; extendhisi2
	popj 17,

xor_uhi_mem:
	ldb 2,2
	xori 2,(1)
	move 1,2
	popj 17,

xorm_qi:
	ldb 6,2
	xor 1,6
	dpb 1,2
	popj 17,

xorm_uqi:
	ldb 6,2
	xor 1,6
	dpb 1,2
	popj 17,

xorm_hi:
	ldb 4,2
	xori 4,(1)
	dpb 4,2	; movhi
	popj 17,

xorm_uhi:
	ldb 4,2
	xori 4,(1)
	dpb 4,2	; movhi
	popj 17,

xor_chain:
	xor 1,2
	xor 1,3
	popj 17,

xor_chain_mem:
	xor 1,(2)
	xor 1,(3)
	popj 17,

xor_self:
	movei 1,0
	popj 17,

xor_store_then_use:
	xor 2,1
	movem 2,(3)
	xor 2,1
	move 1,2
	popj 17,

xorb_reg_memaa:
	xorb 1,(2)
	popj 17,

xorb_reg_memab:
	xorb 1,(2)
	popj 17,

xorb_reg_memba:
	xorb 1,(2)
	popj 17,

xorb_reg_membb:
	xorb 1,(2)
	popj 17,

xorb_mem_regaa:
	xorb 1,(2)
	popj 17,

xorb_mem_regab:
	xorb 1,(2)
	popj 17,

xorb_mem_regba:
	xorb 1,(2)
	popj 17,

xorb_mem_regbb:
	xorb 1,(2)
	popj 17,

uxorb_reg_memaa:
	xorb 1,(2)
	popj 17,

uxorb_reg_memab:
	xorb 1,(2)
	popj 17,

uxorb_reg_memba:
	xorb 1,(2)
	popj 17,

uxorb_reg_membb:
	xorb 1,(2)
	popj 17,

	.bss
xor_ga:
	.space	4
xor_gb:
	.space	4
xor_uga:
	.space	4
xor_buf:
	.space	64
xor_ubuf:
	.space	64
xor_gp:
	.space	8
xor_ugp:
	.space	8
