
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
	setzb 4,5
	move 4,1
	idivi 4,3
	move 1,5
	popj 17,

modi_seven:
	setzb 4,5
	move 4,1
	idivi 4,7
	move 1,5
	popj 17,

modi_small:
	setzb 4,5
	move 4,1
	idivi 4,12345
	move 1,5
	popj 17,

modi_right_max:
	setzb 4,5
	move 4,1
	idivi 4,777777
	move 1,5
	popj 17,

modi_left_const:
	setzb 4,5
	move 4,1
	idiv 4,[123456000000]
	move 1,5
	popj 17,

modi_full_const:
	setzb 4,5
	move 4,1
	idiv 4,[123456123456]
	move 1,5
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
	setzb 4,5
	move 4,1
	idivi 4,12345
	move 1,5
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
	setzb 4,5
	move 3,1
	move 1,2
	idivm 3,1
	move 4,3
	idiv 4,2
	add 1,5
	popj 17,

mod_with_div_store:
	setzb 6,7
	move 5,4
	idivm 3,5
	movem 5,(1)
	move 6,3
	idiv 6,4
	movem 7,(2)
	move 1,7
	popj 17,

mod_recompose:
	setzb 4,5
	move 3,1
	move 1,2
	idivm 3,1
	move 4,3
	idiv 4,2
	imul 1,2
	add 1,5
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
