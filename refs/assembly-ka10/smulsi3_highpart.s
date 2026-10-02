
opaque_si:
	movem 1,smulhp_opaque
	move 1,smulhp_opaque
	popj 17,

mulm1:
	move 4,1
	mul 4,2
	ashc 4,-43
	add 3,5
	move 1,3
	popj 17,

mulm2:
	move 4,1
	mul 4,(2)
	ashc 4,-43
	movem 5,(2)
	popj 17,

smulhp_reg:
	move 4,1
	mul 4,2
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_reg_commuted:
	mul 2,1
	ashc 2,-43
	move 1,3
	popj 17,

smulhp_reg_opaque:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,2
	pushj 17,opaque_si
	move 10,1
	move 1,11
	pushj 17,opaque_si
	mul 10,1
	ashc 10,-43
	move 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

smulhp_local:
	move 4,1
	mul 4,2
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_reuse_left:
	move 4,1
	mul 4,2
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_reuse_right:
	move 4,1
	mul 4,2
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_zero:
	movei 1,0
	popj 17,

smulhp_one:
	ash 1,-43
	popj 17,

smulhp_minus_one:
	mul 1,[-1]
	ashc 1,-43
	move 1,2
	popj 17,

smulhp_small_positive:
	muli 1,123
	ashc 1,-43
	move 1,2
	popj 17,

smulhp_small_negative:
	mul 1,[-123]
	ashc 1,-43
	move 1,2
	popj 17,

smulhp_large_positive:
	muli 1,123456
	ashc 1,-43
	move 1,2
	popj 17,

smulhp_large_negative:
	mul 1,[-123456]
	ashc 1,-43
	move 1,2
	popj 17,

smulhp_const_left:
	muli 1,123456
	ashc 1,-43
	move 1,2
	popj 17,

smulhp_const_negative_left:
	mul 1,[-123456]
	ashc 1,-43
	move 1,2
	popj 17,

smulhp_mem_left:
	move 4,(1)
	mul 4,2
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_mem_right:
	move 4,1
	mul 4,(2)
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_mem_mem:
	move 4,(1)
	mul 4,(2)
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_mem_loaded:
	move 4,(1)
	mul 4,(2)
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_global_left:
	move 4,smulhp_ga
	mul 4,1
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_global_right:
	mul 1,smulhp_ga
	ashc 1,-43
	move 1,2
	popj 17,

smulhp_global_global:
	move 4,smulhp_ga
	mul 4,smulhp_gb
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_volatile_left:
	move 4,smulhp_vga
	mul 4,1
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_volatile_right:
	move 4,smulhp_vga
	mul 1,4
	ashc 1,-43
	move 1,2
	popj 17,

smulhp_volatile_mem:
	move 4,(1)
	move 3,(2)
	mul 4,3
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_array_left:
	andi 2,17
	add 1,2
	move 4,(1)
	mul 4,3
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_array_right:
	move 4,1
	andi 3,17
	add 2,3
	mul 4,(2)
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_array_array:
	andi 2,17
	add 2,1
	andi 3,17
	add 1,3
	move 4,(2)
	mul 4,(1)
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_global_array_left:
	andi 1,17
	move 4,smulhp_buf(1)
	mul 4,2
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_global_array_right:
	move 4,1
	andi 2,17
	mul 4,smulhp_buf(2)
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_global_array_array:
	andi 1,17
	andi 2,17
	move 4,smulhp_buf(1)
	mul 4,smulhp_buf(2)
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_struct_a:
	move 4,(1)
	mul 4,2
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_struct_b:
	mul 2,1(1)
	ashc 2,-43
	move 1,3
	popj 17,

smulhp_struct_ab:
	move 4,(1)
	mul 4,1(1)
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_global_struct_a:
	move 4,smulhp_gp
	mul 4,1
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_global_struct_b:
	mul 1,smulhp_gp+1
	ashc 1,-43
	move 1,2
	popj 17,

smulhp_global_struct_ab:
	move 4,smulhp_gp
	mul 4,smulhp_gp+1
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_three_ab:
	move 4,(1)
	mul 4,1(1)
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_three_bc:
	move 4,1(1)
	mul 4,2(1)
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_indirect_left:
	move 4,@(1)
	mul 4,2
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_indirect_right:
	move 4,1
	mul 4,@(2)
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_indexed_indirect:
	andi 2,17
	add 2,(1)
	move 4,(2)
	mul 4,3
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_expr_add:
	move 4,1
	add 4,2
	mul 4,3
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_expr_sub:
	move 4,1
	sub 4,2
	mul 4,3
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_expr_xor:
	move 4,1
	xor 4,2
	mul 4,3
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_expr_and:
	move 4,1
	and 4,2
	mul 4,3
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_expr_or:
	move 4,1
	ior 4,2
	mul 4,3
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_expr_neg:
	movn 4,1
	mul 4,2
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_expr_shift:
	move 4,1
	ash 4,-3
	mul 4,2
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_two_exprs:
	move 6,1
	add 6,2
	sub 3,4
	mul 6,3
	ashc 6,-43
	move 1,7
	popj 17,

smulhp_call_expr:
	push 17,10
	move 10,1
	pushj 17,f
	mul 1,10
	ashc 1,-43
	move 1,2
	pop 17,10
	popj 17,

smulhp_store:
	move 4,2
	mul 4,3
	ashc 4,-43
	movem 5,(1)
	popj 17,

smulhp_store_return:
	move 4,2
	mul 4,3
	ashc 4,-43
	movem 5,(1)
	move 1,5
	popj 17,

smulhp_store_return_mem:
	move 4,2
	mul 4,3
	ashc 4,-43
	movem 5,(1)
	move 1,5
	popj 17,

smulhp_store_global:
	move 4,1
	mul 4,2
	ashc 4,-43
	movem 5,smulhp_ga
	popj 17,

smulhp_store_global_return:
	move 4,1
	mul 4,2
	ashc 4,-43
	movem 5,smulhp_ga
	move 1,5
	popj 17,

smulhp_store_array:
	move 6,3
	andi 2,17
	add 1,2
	mul 6,4
	ashc 6,-43
	movem 7,(1)
	popj 17,

smulhp_store_array_return:
	move 6,3
	andi 2,17
	add 1,2
	mul 6,4
	ashc 6,-43
	movem 7,(1)
	move 1,7
	popj 17,

smulhp_store_struct_a:
	move 4,2
	mul 4,3
	ashc 4,-43
	movem 5,(1)
	popj 17,

smulhp_store_struct_b_return:
	move 4,2
	mul 4,3
	ashc 4,-43
	movem 5,1(1)
	move 1,5
	popj 17,

smulhp_store_indirect:
	move 4,2
	mul 4,3
	ashc 4,-43
	movem 5,@(1)
	popj 17,

smulhp_volatile_store:
	move 4,2
	mul 4,3
	ashc 4,-43
	movem 5,(1)
	popj 17,

smulhp_add:
	move 4,1
	mul 4,2
	ashc 4,-43
	add 3,5
	move 1,3
	popj 17,

smulhp_sub:
	move 4,1
	mul 4,2
	ashc 4,-43
	move 6,5
	sub 6,3
	move 1,6
	popj 17,

smulhp_xor:
	move 4,1
	mul 4,2
	ashc 4,-43
	xor 3,5
	move 1,3
	popj 17,

smulhp_or:
	move 4,1
	mul 4,2
	ashc 4,-43
	ior 3,5
	move 1,3
	popj 17,

smulhp_and:
	move 4,1
	mul 4,2
	ashc 4,-43
	and 3,5
	move 1,3
	popj 17,

smulhp_mul_again:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 6,1
	mul 6,2
	ashc 6,-43
	move 10,7
	mul 10,3
	move 4,10
	move 5,11
	move 1,5
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

smulhp_sources_live:
	move 6,1
	mul 6,2
	move 4,6
	move 5,7
	ashc 4,-43
	add 1,5
	add 1,2
	add 1,3
	popj 17,

smulhp_memory_sources_live:
	move 1,(1)
	move 2,(2)
	move 6,1
	mul 6,2
	move 4,6
	move 5,7
	ashc 4,-43
	add 1,5
	add 1,2
	add 1,3
	popj 17,

smulhp_two_values:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 6,3
	mul 10,2
	ashc 10,-43
	mul 6,4
	ashc 6,-43
	move 1,7
	add 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

smulhp_two_mems:
	move 6,(1)
	mul 6,(2)
	ashc 6,-43
	move 2,(3)
	mul 2,(4)
	ashc 2,-43
	move 1,3
	add 1,7
	popj 17,

smulhp_branch_zero:
	move 6,1
	mul 6,2
	ashc 6,-43
	move 1,3
	jumpe 7,%L84
	move 1,4
%L84:
	popj 17,

smulhp_branch_nonzero:
	move 6,1
	mul 6,2
	ashc 6,-43
	move 1,3
	jumpn 7,%L86
	move 1,4
%L86:
	popj 17,

smulhp_branch_negative:
	move 6,1
	mul 6,2
	ashc 6,-43
	move 1,3
	jumpl 7,%L88
	move 1,4
%L88:
	popj 17,

smulhp_branch_positive:
	move 6,1
	mul 6,2
	ashc 6,-43
	move 1,3
	jumple 7,%L92
%L90:
	popj 17,
%L92:
	move 1,4
	popj 17,

smulhp_likely:
	move 3,1
	move 6,1
	mul 6,2
	move 4,6
	move 5,7
	ashc 4,-43
	move 1,5
	jumpe 5,%L95
%L93:
	popj 17,
%L95:
	move 1,3
	add 1,2
	popj 17,

smulhp_unlikely:
	move 3,1
	move 6,1
	mul 6,2
	move 4,6
	move 5,7
	ashc 4,-43
	move 1,5
	jumpn 5,%L96
	move 1,3
	add 1,2
%L96:
	popj 17,

smulhp_call_pressure_reg:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 6,1
	mul 6,2
	move 4,6
	move 5,7
	ashc 4,-43
	move 10,5
	pushj 17,clobber
	add 10,11
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

smulhp_call_pressure_mem:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 4,(1)
	mul 4,(2)
	ashc 4,-43
	move 10,5
	pushj 17,clobber
	add 10,(11)
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

smulhp_store_call_pressure:
	push 17,10
	move 10,1
	move 4,2
	mul 4,3
	ashc 4,-43
	movem 5,(1)
	pushj 17,clobber
	move 1,(10)
	pop 17,10
	popj 17,

smulhp_loop_sum:
	move 7,1
	setzb 1,6
	caml 1,2
	popj 17,
	subi 2,1
%L110:
	move 4,6
	andi 4,17
	add 4,7
	move 4,(4)
	mul 4,3
	ashc 4,-43
	add 1,5
	addi 6,1
	sojge 2,%L110	; doloop_end
	popj 17,

smulhp_loop_store:
	move 7,3
	movei 6,0
	caml 6,2
	popj 17,
	subi 2,1
%L121:
	move 3,6
	andi 3,17
	add 3,1
	move 4,(3)
	mul 4,7
	ashc 4,-43
	movem 5,(3)
	addi 6,1
	sojge 2,%L121	; doloop_end
	popj 17,

smulhp_loop_store_sum:
	push 17,10
	move 10,1
	move 7,3
	setzb 1,6
	caml 1,2
	jrst %L132
	subi 2,1
%L133:
	move 3,6
	andi 3,17
	add 3,10
	move 4,(3)
	mul 4,7
	ashc 4,-43
	movem 5,(3)
	add 1,5
	addi 6,1
	sojge 2,%L133	; doloop_end
%L132:
	pop 17,10
	popj 17,

smulhp_qi:
	move 4,1
	lsh 4,33
	ash 4,-33
	lsh 2,33
	ash 2,-33
	mul 4,2
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_hi:
	hrre 4,1
	hrre 2,2
	mul 4,2
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_qi_si:
	move 4,1
	lsh 4,33
	ash 4,-33
	mul 4,2
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_hi_si:
	hrre 4,1
	mul 4,2
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_qi_mem:
	ldb 4,1
	trne 4,400
	orcmi 4,777
	mul 4,2
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_hi_mem:
	ldb 4,1
	hrre 4,4
	mul 4,2
	ashc 4,-43
	move 1,5
	popj 17,

smulhp_both_regaa:
	move 4,1
	mul 4,(2)
	ashc 4,-43
	movem 5,(2)
	move 1,5
	popj 17,

smulhp_both_regab:
	move 4,1
	mul 4,(2)
	ashc 4,-43
	movem 5,(2)
	move 1,5
	popj 17,

smulhp_both_regba:
	move 4,1
	mul 4,(2)
	ashc 4,-43
	movem 5,(2)
	move 1,5
	popj 17,

smulhp_both_regbb:
	move 4,1
	mul 4,(2)
	ashc 4,-43
	movem 5,(2)
	move 1,5
	popj 17,

smulhp_both_memaa:
	move 4,(2)
	mul 4,1
	ashc 4,-43
	movem 5,(2)
	move 1,5
	popj 17,

smulhp_both_memab:
	move 4,(2)
	mul 4,1
	ashc 4,-43
	movem 5,(2)
	move 1,5
	popj 17,

smulhp_both_memba:
	move 4,(2)
	mul 4,1
	ashc 4,-43
	movem 5,(2)
	move 1,5
	popj 17,

smulhp_both_membb:
	move 4,(2)
	mul 4,1
	ashc 4,-43
	movem 5,(2)
	move 1,5
	popj 17,

	.globl	smulsi3_highpart_smoke
smulsi3_highpart_smoke:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	move 13,2
	move 11,3
	pushj 17,smulhp_reg
	move 10,1
	move 1,13
	move 2,11
	move 3,12
	pushj 17,smulhp_add
	add 10,1
	move 1,12
	move 2,11
	move 3,13
	pushj 17,smulhp_expr_sub
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

	.globl	shpmem
shpmem:
	add 17,[5,,5]
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	move 14,2
	move 13,3
	pushj 17,smulhp_mem_mem
	move 11,1
	move 1,12
	move 2,11
	move 3,13
	pushj 17,smulhp_store_return
	move 10,1
	add 10,11
	move 1,12
	move 2,14
	move 3,13
	pushj 17,smulhp_memory_sources_live
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-5,,-5]
	popj 17,

	.globl	shpctl
shpctl:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,2
	move 11,3
	pushj 17,smulhp_loop_sum
	move 10,1
	move 2,11
	move 3,12
	move 4,11
	pushj 17,smulhp_branch_nonzero
	add 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

	.bss
smulhp_ga:
	.space	4
smulhp_gb:
	.space	4
smulhp_gc:
	.space	4
smulhp_vga:
	.space	4
smulhp_opaque:
	.space	4
smulhp_buf:
	.space	64
smulhp_gp:
	.space	8
smulhp_gt:
	.space	12
