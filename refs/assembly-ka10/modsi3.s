
modsi3:
	setzb 4,5
	move 4,1
	idiv 4,2
	move 1,5
	popj 17,

mod_reg_reg:
	setzb 4,5
	move 4,1
	idiv 4,2
	move 1,5
	popj 17,

mod_local:
	setzb 4,5
	move 4,1
	idiv 4,2
	move 1,5
	popj 17,

mod_reuse_left:
	setzb 4,5
	move 4,1
	idiv 4,2
	move 1,5
	popj 17,

mod_reuse_right:
	setzb 4,5
	move 4,1
	idiv 4,2
	move 1,5
	popj 17,

mod_chain:
	setzb 4,5
	setzb 6,7
	move 4,1
	idiv 4,2
	move 6,5
	idiv 6,3
	move 1,7
	popj 17,

mod_add_use:
	setzb 4,5
	move 4,1
	idiv 4,2
	add 3,5
	move 1,3
	popj 17,

mod_sub_use:
	setzb 4,5
	move 4,1
	idiv 4,2
	move 6,5
	sub 6,3
	move 1,6
	popj 17,

mod_xor_use:
	setzb 4,5
	move 4,1
	idiv 4,2
	xor 3,5
	move 1,3
	popj 17,

mod_from_call:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,1
	pushj 17,f
	move 10,1
	idiv 10,12
	move 1,11
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

mod_call_rhs:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,1
	pushj 17,f
	move 10,12
	idiv 10,1
	move 1,11
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

mod_reg_mem:
	setzb 4,5
	move 4,1
	idiv 4,(2)
	move 1,5
	popj 17,

mod_mem_reg:
	setzb 4,5
	move 4,(1)
	idiv 4,2
	move 1,5
	popj 17,

mod_mem_mem:
	setzb 4,5
	move 4,(1)
	idiv 4,(2)
	move 1,5
	popj 17,

mod_volatile_mem:
	setzb 4,5
	move 3,(2)
	move 4,1
	idiv 4,3
	move 1,5
	popj 17,

mod_mem_volatile:
	setzb 4,5
	move 3,(1)
	move 4,3
	idiv 4,2
	move 1,5
	popj 17,

mod_global_reg:
	setzb 4,5
	move 4,modsi3_ga
	idiv 4,1
	move 1,5
	popj 17,

mod_reg_global:
	setzb 4,5
	move 4,1
	idiv 4,modsi3_gb
	move 1,5
	popj 17,

mod_volatile_global:
	setzb 4,5
	move 3,modsi3_vga
	move 4,1
	idiv 4,3
	move 1,5
	popj 17,

mod_array_reg:
	setzb 4,5
	andi 2,17
	add 1,2
	move 4,(1)
	idiv 4,3
	move 1,5
	popj 17,

mod_reg_array:
	setzb 4,5
	andi 3,17
	add 2,3
	move 4,1
	idiv 4,(2)
	move 1,5
	popj 17,

mod_global_array:
	setzb 4,5
	andi 1,17
	move 4,modsi3_buf(1)
	idiv 4,2
	move 1,5
	popj 17,

mod_reg_global_array:
	setzb 4,5
	andi 2,17
	move 4,1
	idiv 4,modsi3_buf(2)
	move 1,5
	popj 17,

mod_struct_a:
	setzb 4,5
	move 4,(1)
	idiv 4,2
	move 1,5
	popj 17,

mod_struct_b:
	setzb 4,5
	move 4,1
	idiv 4,1(2)
	move 1,5
	popj 17,

mod_struct_two:
	setzb 4,5
	move 4,(1)
	idiv 4,1(1)
	move 1,5
	popj 17,

mod_struct_three:
	setzb 4,5
	setzb 2,3
	move 4,(1)
	idiv 4,1(1)
	move 2,5
	idiv 2,2(1)
	move 1,3
	popj 17,

mod_global_struct_a:
	setzb 4,5
	move 4,modsi3_gp
	idiv 4,1
	move 1,5
	popj 17,

mod_global_struct_b:
	setzb 4,5
	move 4,1
	idiv 4,modsi3_gp+1
	move 1,5
	popj 17,

mod_global_struct_three:
	setzb 4,5
	move 4,modsi3_gt
	idiv 4,modsi3_gt+2
	move 1,5
	popj 17,

modi_one:
	movei 1,0
	popj 17,

modi_two:
	move 4,1
	lsh 4,-43
	add 4,1
	andcmi 4,1
	sub 1,4
	popj 17,

modi_three:
	move 4,[252525252526]
	mul 4,1
	ashc 4,-44
	move 3,1
	ash 3,-43
	move 6,5
	sub 6,3
	move 4,6
	lsh 4,1
	add 4,6
	sub 1,4
	popj 17,

modi_seven:
	move 4,[-333333333333]
	mul 4,1
	ashc 4,-44
	move 3,1
	add 3,5
	ash 3,-2
	move 4,1
	ash 4,-43
	sub 3,4
	move 4,3
	lsh 4,3
	sub 4,3
	sub 1,4
	popj 17,

modi_small:
	move 4,[61004073261]
	mul 4,1
	ashc 4,-44
	move 4,5
	ash 4,-11
	move 3,1
	ash 3,-43
	sub 4,3
	imuli 4,12345
	sub 1,4
	popj 17,

modi_right_max:
	move 4,[-377777377777]
	mul 4,1
	ashc 4,-44
	move 3,1
	add 3,5
	ash 3,-21
	move 4,1
	ash 4,-43
	sub 3,4
	hrlz 4,3
	sub 4,3
	sub 1,4
	popj 17,

modi_left_const:
	move 4,[304002311017]
	mul 4,1
	ashc 4,-44
	move 4,5
	ash 4,-40
	move 3,1
	ash 3,-43
	sub 4,3
	imul 4,[123456000000]
	sub 1,4
	popj 17,

modi_full_const:
	move 4,[304002005015]
	mul 4,1
	ashc 4,-44
	move 4,5
	ash 4,-40
	move 3,1
	ash 3,-43
	sub 4,3
	imul 4,[123456123456]
	sub 1,4
	popj 17,

modi_minus_one:
	movei 1,0
	popj 17,

modi_minus_two:
	move 4,1
	lsh 4,-43
	add 4,1
	andcmi 4,1
	sub 1,4
	popj 17,

modi_minus_small:
	move 4,[61004073261]
	mul 4,1
	ashc 4,-44
	move 4,5
	ash 4,-11
	move 3,1
	ash 3,-43
	sub 4,3
	imuli 4,12345
	sub 1,4
	popj 17,

mod_const_by_reg:
	move 4,[123456]
	move 5,[0]
	idiv 4,1
	move 1,5
	popj 17,

mod_neg_const_by_reg:
	move 4,[777777654322]
	move 5,[0]
	idiv 4,1
	move 1,5
	popj 17,

mod_full_const_by_reg:
	move 4,[123456123456]
	move 5,[0]
	idiv 4,1
	move 1,5
	popj 17,

mod_left_const_by_reg:
	move 4,[123456000000]
	move 5,[0]
	idiv 4,1
	move 1,5
	popj 17,

mod_store_ptr:
	setzb 4,5
	move 4,2
	idiv 4,3
	movem 5,(1)
	popj 17,

mod_store_ptr_return:
	setzb 4,5
	move 4,2
	idiv 4,3
	movem 5,(1)
	move 1,5
	popj 17,

mod_store_global:
	setzb 4,5
	move 4,1
	idiv 4,2
	movem 5,modsi3_ga
	popj 17,

mod_store_global_return:
	setzb 4,5
	move 4,1
	idiv 4,2
	movem 5,modsi3_ga
	move 1,5
	popj 17,

mod_store_array:
	setzb 4,5
	andi 1,17
	move 4,2
	idiv 4,3
	movem 5,modsi3_buf(1)
	popj 17,

mod_store_array_return:
	setzb 4,5
	andi 1,17
	move 4,2
	idiv 4,3
	movem 5,modsi3_buf(1)
	move 1,5
	popj 17,

mod_store_struct_a:
	setzb 4,5
	move 4,2
	idiv 4,3
	movem 5,(1)
	popj 17,

mod_store_struct_a_return:
	setzb 4,5
	move 4,2
	idiv 4,3
	movem 5,(1)
	move 1,5
	popj 17,

mod_inplace_ptr:
	setzb 4,5
	move 4,(1)
	idiv 4,2
	movem 5,(1)
	popj 17,

mod_inplace_ptr_return:
	setzb 4,5
	move 4,(1)
	idiv 4,2
	movem 5,(1)
	move 1,5
	popj 17,

mod_inplace_global:
	setzb 4,5
	move 4,modsi3_ga
	idiv 4,1
	movem 5,modsi3_ga
	popj 17,

mod_inplace_global_return:
	setzb 4,5
	move 4,modsi3_ga
	idiv 4,1
	movem 5,modsi3_ga
	move 1,5
	popj 17,

mod_inplace_array:
	setzb 4,5
	andi 1,17
	move 4,modsi3_buf(1)
	idiv 4,2
	movem 5,modsi3_buf(1)
	popj 17,

mod_inplace_array_return:
	setzb 4,5
	andi 1,17
	move 4,modsi3_buf(1)
	idiv 4,2
	movem 5,modsi3_buf(1)
	move 1,5
	popj 17,

mod_negative_lhs:
	setzb 4,5
	movn 4,1
	idiv 4,2
	move 1,5
	popj 17,

mod_negative_rhs:
	setzb 4,5
	movn 2,2
	move 4,1
	idiv 4,2
	move 1,5
	popj 17,

mod_both_negative:
	setzb 4,5
	movn 2,2
	movn 4,1
	idiv 4,2
	move 1,5
	popj 17,

mod_abs_like:
	setzb 4,5
	move 4,1
	idiv 4,2
	movm 1,5
	popj 17,

mod_eq_zero:
	setzb 4,5
	move 4,1
	idiv 4,2
	skipe 5
	tdza 1,1
	movei 1,1
	popj 17,

mod_ne_zero:
	setzb 4,5
	move 4,1
	idiv 4,2
	skipe 1,5
	movei 1,1
	popj 17,

mod_lt_zero:
	setzb 4,5
	move 4,1
	idiv 4,2
	move 1,5
	lsh 1,-43
	popj 17,

mod_ge_zero:
	setzb 4,5
	move 4,1
	idiv 4,2
	move 1,5
	skipge 1
	tdza 1,1
	movei 1,1
	popj 17,

mod_gt_const:
	setzb 4,5
	move 4,1
	idiv 4,2
	movei 6,123
	camg 5,6
	tdza 1,1
	movei 1,1
	popj 17,

mod_range:
	setzb 4,5
	move 4,1
	idiv 4,2
	seto 1,
	camge 5,[-100]
	popj 17,
	movei 6,100
	camg 5,6
	tdza 1,1
	movei 1,1
	popj 17,

mod_with_div_sum:
	setzb 6,7
	setzb 4,5
	move 6,1
	idiv 6,2
	move 4,1
	idiv 4,2
	add 6,5
	move 1,6
	popj 17,

mod_with_div_store:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setzb 6,7
	setzb 10,11
	move 6,3
	idiv 6,4
	movem 6,(1)
	move 10,3
	idiv 10,4
	movem 11,(2)
	move 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

mod_recompose:
	setzb 4,5
	setzb 6,7
	move 4,1
	idiv 4,2
	move 6,1
	idiv 6,2
	imul 2,4
	add 2,7
	move 1,2
	popj 17,

mod_after_call:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	setzb 10,11
	move 13,2
	move 12,(1)
	pushj 17,clobber
	move 10,12
	idiv 10,13
	move 1,11
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

mod_call_after_load:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,(1)
	pushj 17,clobber
	pushj 17,f
	move 10,12
	idiv 10,1
	move 1,11
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

mod_store_after_call:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	setzb 10,11
	move 12,1
	pushj 17,f
	move 13,1
	pushj 17,clobber
	move 10,13
	idiv 10,(12)
	movem 11,(12)
	move 1,11
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

mod_global_after_call:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	setzb 10,11
	move 13,1
	pushj 17,f
	move 12,1
	pushj 17,clobber
	move 10,12
	idiv 10,modsi3_ga
	add 13,11
	move 1,13
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

	.bss
modsi3_ga:
	.space	4
modsi3_gb:
	.space	4
modsi3_vga:
	.space	4
modsi3_buf:
	.space	64
modsi3_gp:
	.space	8
modsi3_gt:
	.space	12
