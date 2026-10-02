
move_reg_reg:
	move 1,2
	popj 17,

umove_reg_reg:
	move 1,2
	popj 17,

move_mem:
	move 1,(1)
	popj 17,

umove_mem:
	move 1,(1)
	popj 17,

move_mem_plus:
	add 2,(1)
	move 1,2
	popj 17,

move_mem_minus:
	move 1,(1)
	sub 1,2
	popj 17,

move_mem_and:
	and 2,(1)
	move 1,2
	popj 17,

move_mem_or:
	ior 2,(1)
	move 1,2
	popj 17,

move_mem_xor:
	xor 2,(1)
	move 1,2
	popj 17,

move_volatile_mem:
	move 1,(1)
	popj 17,

umove_volatile_mem:
	move 1,(1)
	popj 17,

move_global_a:
	move 1,move_ga
	popj 17,

move_global_b:
	move 1,move_gb
	popj 17,

umove_global_a:
	move 1,move_uga
	popj 17,

move_array:
	andi 2,17
	add 1,2
	move 1,(1)
	popj 17,

umove_array:
	andi 2,17
	add 1,2
	move 1,(1)
	popj 17,

move_global_array:
	andi 1,17
	move 1,move_buf(1)
	popj 17,

umove_global_array:
	andi 1,17
	move 1,move_ubuf(1)
	popj 17,

move_struct_a:
	move 1,(1)
	popj 17,

move_struct_b:
	move 1,1(1)
	popj 17,

move_global_struct_a:
	move 1,move_gp
	popj 17,

move_global_struct_b:
	move 1,move_gt+1
	popj 17,

move_indirect:
	move 1,@(1)
	popj 17,

move_indexed_indirect:
	andi 2,17
	add 2,(1)
	move 1,(2)
	popj 17,

movei_zero:
	movei 1,0
	popj 17,

movei_one:
	movei 1,1
	popj 17,

movei_minus_one:
	seto 1,
	popj 17,

movei_small:
	movei 1,123456
	popj 17,

movei_low9:
	movei 1,777
	popj 17,

movei_low18:
	movei 1,777777
	popj 17,

umovei_low18:
	movei 1,777777
	popj 17,

movei_addr_like_a:
	movei 1,400
	popj 17,

movei_addr_like_b:
	movei 1,1234
	popj 17,

move_large_literal:
	move 1,[123456123456]
	popj 17,

move_large_literal_ones:
	seto 1,
	popj 17,

move_large_literal_left:
	movsi 1,777777
	popj 17,

move_large_literal_right:
	movei 1,777777
	popj 17,

umove_large_literal:
	move 1,[123456123456]
	popj 17,

move_const_after_reg:
	movei 1,123456
	popj 17,

move_literal_after_reg:
	move 1,[123456123456]
	popj 17,

move_reg_after_const:
	popj 17,

move_select_const:
	movei 4,123456
	jumpn 1,%L45
	move 4,[123456123456]
%L45:
	move 1,4
	popj 17,

move_select_reg:
	jumpn 3,%L47
	move 1,2
%L47:
	popj 17,

movem_reg_mem:
	movem 1,(2)
	popj 17,

umovem_reg_mem:
	movem 1,(2)
	popj 17,

movem_reg_mem_ret:
	movem 1,(2)
	popj 17,

movem_reg_mem_ret_arg:
	movem 1,(2)
	popj 17,

movem_const:
	movei 6,123456
	movem 6,(1)
	popj 17,

movem_literal:
	move 6,[123456123456]
	movem 6,(1)
	popj 17,

movem_zero:
	setzm (1)
	popj 17,

movem_minus_one:
	setom (1)
	popj 17,

movem_global:
	movem 1,move_ga
	popj 17,

umovem_global:
	movem 1,move_uga
	popj 17,

movem_global_ret:
	movem 1,move_gb
	popj 17,

movem_array:
	andi 2,17
	add 1,2
	movem 3,(1)
	popj 17,

umovem_array:
	andi 2,17
	add 1,2
	movem 3,(1)
	popj 17,

movem_array_ret:
	andi 2,17
	add 1,2
	movem 3,(1)
	move 1,3
	popj 17,

movem_global_array:
	andi 1,17
	movem 2,move_buf(1)
	popj 17,

umovem_global_array:
	andi 1,17
	movem 2,move_ubuf(1)
	popj 17,

movem_struct_a:
	movem 2,(1)
	popj 17,

movem_struct_b:
	movem 2,1(1)
	popj 17,

movem_struct_ret:
	movem 2,1(1)
	move 1,2
	popj 17,

movem_global_struct_a:
	movem 1,move_gp
	popj 17,

movem_global_struct_b:
	movem 1,move_gt+1
	popj 17,

movem_volatile:
	movem 1,(2)
	popj 17,

movem_volatile_ret:
	movem 1,(2)
	move 1,(2)
	popj 17,

movem_indirect:
	movem 2,@(1)
	popj 17,

movem_indexed_indirect:
	andi 2,17
	add 2,(1)
	movem 3,(2)
	popj 17,

move_store_reload:
	move 4,(2)
	movem 4,(1)
	move 1,4
	popj 17,

move_store_reload_reg:
	movem 2,(1)
	move 1,2
	popj 17,

move_two_loads:
	move 1,(1)
	add 1,(2)
	popj 17,

move_two_stores:
	movem 3,(1)
	movem 4,(2)
	popj 17,

move_copy_chain:
	move 1,(1)
	movem 1,(2)
	movem 1,(3)
	popj 17,

move_call_pressure_load:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,(1)
	pushj 17,clobber
	add 10,(11)
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

move_call_pressure_store:
	push 17,10
	move 10,1
	movem 2,(1)
	pushj 17,clobber
	move 1,(10)
	pop 17,10
	popj 17,

move_loop_load:
	move 6,1
	setzb 1,3
	caml 1,2
	popj 17,
	subi 2,1
%L95:
	move 4,3
	andi 4,17
	add 4,6
	add 1,(4)
	addi 3,1
	sojge 2,%L95	; doloop_end
	popj 17,

move_loop_store:
	movei 6,0
	caml 6,2
	popj 17,
	subi 2,1
%L105:
	move 4,6
	andi 4,17
	add 4,1
	movem 3,(4)
	addi 3,1
	addi 6,1
	sojge 2,%L105	; doloop_end
	popj 17,

move_qi_to_sint:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

move_uqi_to_usint:
	ldb 1,1
	popj 17,

move_hi_to_sint:
	ldb 1,1
	hrre 1,1
	popj 17,

move_uhi_to_usint:
	ldb 1,1
	popj 17,

movem_sint_to_qi:
	dpb 2,1
	popj 17,

movem_usint_to_uqi:
	dpb 2,1
	popj 17,

movem_sint_to_hi:
	dpb 2,1	; movhi
	popj 17,

movem_usint_to_uhi:
	dpb 2,1	; movhi
	popj 17,

moves_mem:
	move 1,(1)
	popj 17,

umoves_mem:
	move 1,(1)
	popj 17,

moves_array:
	andi 2,17
	add 1,2
	move 1,(1)
	popj 17,

moves_struct:
	move 1,1(1)
	popj 17,

moves_volatile:
	move 4,(1)
	movem 4,(1)
	move 1,4
	popj 17,

move1:
	move 1,2
	popj 17,

move2:
	move 1,(2)
	popj 17,

movei:
	movei 1,123456
	popj 17,

move3:
	move 1,[123456123456]
	popj 17,

movem:
	movem 1,(2)
	popj 17,

	.bss
move_ga:
	.space	4
move_gb:
	.space	4
move_gc:
	.space	4
move_uga:
	.space	4
move_ugb:
	.space	4
move_buf:
	.space	64
move_ubuf:
	.space	64
move_gp:
	.space	8
move_gt:
	.space	12
