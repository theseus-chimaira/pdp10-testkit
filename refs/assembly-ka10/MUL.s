
mul_reg_reg:
	move 4,1
	mul 4,2
	move 1,4
	move 2,5
	popj 17,

mul_reg_mem:
	move 4,1
	mul 4,(2)
	move 1,4
	move 2,5
	popj 17,

mul_mem_reg:
	move 1,(1)
	mul 1,2
	popj 17,

mul_mem_mem:
	move 1,(1)
	mul 1,(2)
	popj 17,

mul_global_a:
	mul 1,mul_ga
	popj 17,

mul_global_b:
	move 1,mul_ga
	mul 1,mul_gb
	popj 17,

mul_array:
	andi 2,17
	add 1,2
	mul 3,(1)
	move 1,3
	move 2,4
	popj 17,

mul_global_array:
	andi 1,17
	mul 2,mul_buf(1)
	move 1,2
	move 2,3
	popj 17,

mul_struct_a:
	mul 2,(1)
	move 1,2
	move 2,3
	popj 17,

mul_struct_b:
	mul 2,1(1)
	move 1,2
	move 2,3
	popj 17,

mul_global_struct_a:
	mul 1,mul_gp
	popj 17,

mul_global_struct_b:
	mul 1,mul_gp+1
	popj 17,

muli_one:
	move 4,1
	move 2,1
	ash 4,-43
	move 1,4
	popj 17,

muli_two:
	muli 1,2
	popj 17,

muli_small:
	muli 1,123456
	popj 17,

muli_max18:
	muli 1,777777
	popj 17,

mul_literal:
	mul 1,[123456123456]
	popj 17,

mul_literal_2:
	mul 1,[377777000000]
	popj 17,

mul_literal_neg:
	mul 1,[-123456]
	popj 17,

mul_commuted_literal:
	mul 1,[123456123456]
	popj 17,

mul_commuted_small:
	muli 1,123456
	popj 17,

mul_store_reg:
	move 4,2
	mul 4,3
	movem 4,(1)
	movem 5,1(1)
	popj 17,

mul_store_mem:
	move 4,2
	mul 4,(3)
	movem 4,(1)
	movem 5,1(1)
	popj 17,

mul_store_return:
	move 4,2
	mul 4,3
	movem 4,(1)
	movem 5,1(1)
	move 6,(1)
	move 7,5
	move 1,6
	move 2,7
	popj 17,

mul_low_reg:
	imul 1,2
	popj 17,

mul_low_mem:
	imul 1,(2)
	popj 17,

mul_high_reg:
	move 4,1
	mul 4,2
	ashc 4,-43
	move 1,5
	popj 17,

mul_high_mem:
	move 4,1
	mul 4,(2)
	ashc 4,-43
	move 1,5
	popj 17,

mul_high_literal:
	mul 1,[123456123456]
	ashc 1,-43
	move 1,2
	popj 17,

mulm_reg_mem:
	move 4,1
	mul 4,(2)
	ashc 4,-43
	movem 5,(2)
	popj 17,

mulm_mem_reg:
	move 4,(1)
	mul 4,2
	ashc 4,-43
	movem 5,(1)
	popj 17,

mulm_global:
	mul 1,mul_ga
	ashc 1,-43
	movem 2,mul_ga
	popj 17,

mulm_global_2:
	move 4,mul_gb
	mul 4,1
	ashc 4,-43
	movem 5,mul_gb
	popj 17,

mulm_array:
	andi 2,17
	add 1,2
	mul 3,(1)
	ashc 3,-43
	movem 4,(1)
	popj 17,

mulm_global_array:
	andi 1,17
	mul 2,mul_buf(1)
	ashc 2,-43
	movem 3,mul_buf(1)
	popj 17,

mulm_struct_a:
	mul 2,(1)
	ashc 2,-43
	movem 3,(1)
	popj 17,

mulm_struct_b:
	move 4,1(1)
	mul 4,2
	ashc 4,-43
	movem 5,1(1)
	popj 17,

mulm_const_small:
	move 4,(1)
	muli 4,123456
	ashc 4,-43
	movem 5,(1)
	popj 17,

mulm_const_literal:
	move 4,(1)
	mul 4,[123456123456]
	ashc 4,-43
	movem 5,(1)
	popj 17,

mulb_reg_mem:
	move 4,1
	mul 4,(2)
	ashc 4,-43
	movem 5,(2)
	move 1,5
	popj 17,

mulb_mem_reg:
	move 4,(1)
	mul 4,2
	ashc 4,-43
	movem 5,(1)
	move 1,5
	popj 17,

mulb_global:
	mul 1,mul_ga
	ashc 1,-43
	movem 2,mul_ga
	move 1,2
	popj 17,

mulb_global_2:
	move 4,mul_gb
	mul 4,1
	ashc 4,-43
	movem 5,mul_gb
	move 1,5
	popj 17,

mulb_array:
	andi 2,17
	add 1,2
	mul 3,(1)
	ashc 3,-43
	movem 4,(1)
	move 1,4
	popj 17,

mulb_global_array:
	andi 1,17
	mul 2,mul_buf(1)
	ashc 2,-43
	movem 3,mul_buf(1)
	move 1,3
	popj 17,

mulb_struct_a:
	mul 2,(1)
	ashc 2,-43
	movem 3,(1)
	move 1,3
	popj 17,

mulb_struct_b:
	move 4,1(1)
	mul 4,2
	ashc 4,-43
	movem 5,1(1)
	move 1,5
	popj 17,

mulb_self:
	move 4,(1)
	mul 4,4
	ashc 4,-43
	movem 5,(1)
	move 1,5
	popj 17,

umul_reg_reg:
	push 17,10
	move 6,1
	move 4,2
	move 7,6
	mul 7,4
	move 1,7
	move 2,10
	move 3,6
	ash 3,-43
	and 3,4
	add 1,3
	ash 4,-43
	and 4,6
	add 1,4
	pop 17,10
	popj 17,

umul_reg_mem:
	push 17,10
	move 6,1
	move 3,(2)
	move 7,1
	mul 7,3
	move 1,7
	move 2,10
	move 4,6
	ash 4,-43
	and 4,3
	add 1,4
	ash 3,-43
	and 3,6
	add 1,3
	pop 17,10
	popj 17,

umuli_small:
	move 4,1
	move 6,1
	muli 6,123456
	move 1,6
	move 2,7
	ash 4,-43
	andi 4,123456
	add 1,4
	popj 17,

umul_literal:
	move 4,1
	move 6,1
	mul 6,[123456123456]
	move 1,6
	move 2,7
	ash 4,-43
	and 4,[123456123456]
	add 1,4
	popj 17,

umul_low:
	imul 1,2
	popj 17,

	.bss
mul_ga:
	.space	4
mul_gb:
	.space	4
mul_gc:
	.space	4
mul_buf:
	.space	64
mul_gp:
	.space	8
