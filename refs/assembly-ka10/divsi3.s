
safe_divisor:
	iori 1,1
	popj 17,

divsi3_const_1:
	popj 17,

divsi3_const_m1:
	movn 1,1
	popj 17,

divsi3_const_2:
	move 4,1
	lsh 4,-43
	add 1,4
	ash 1,-1
	popj 17,

divsi3_const_3:
	move 4,[252525252526]
	mul 4,1
	ashc 4,-44
	ash 1,-43
	move 6,5
	sub 6,1
	move 1,6
	popj 17,

divsi3_const_10:
	move 4,[314631463147]
	mul 4,1
	ashc 4,-44
	move 4,5
	ash 4,-2
	ash 1,-43
	sub 4,1
	move 1,4
	popj 17,

divsi3_const_octal:
	move 4,[304002311017]
	mul 4,1
	ashc 4,-44
	move 4,5
	ash 4,-16
	ash 1,-43
	sub 4,1
	move 1,4
	popj 17,

divsi3_const_neg_octal:
	move 4,[304002311017]
	mul 4,1
	ashc 4,-44
	move 4,5
	ash 4,-16
	ash 1,-43
	sub 1,4
	popj 17,

divsi3_const_low9:
	move 4,[-377377377377]
	mul 4,1
	ashc 4,-44
	move 4,1
	add 4,5
	ash 4,-10
	ash 1,-43
	sub 4,1
	move 1,4
	popj 17,

divsi3_const_low18:
	move 4,[-377777377777]
	mul 4,1
	ashc 4,-44
	move 4,1
	add 4,5
	ash 4,-21
	ash 1,-43
	sub 4,1
	move 1,4
	popj 17,

divsi3_const_large:
	move 4,[304002005015]
	mul 4,1
	ashc 4,-44
	move 4,5
	ash 4,-40
	ash 1,-43
	sub 4,1
	move 1,4
	popj 17,

divsi3_const_large_neg:
	move 4,[-167773763135]
	mul 4,1
	ashc 4,-44
	move 4,1
	add 4,5
	ash 4,-30
	ash 1,-43
	sub 1,4
	popj 17,

divsi3_reg_reg:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,1
	move 1,2
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

divsi3_reg_reg_neg_divisor:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,1
	move 1,2
	pushj 17,safe_divisor
	movn 1,1
	move 10,12
	idiv 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

divsi3_reg_mem:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,1
	move 1,(2)
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

divsi3_mem_reg:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,(1)
	move 1,2
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

divsi3_mem_mem:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,(1)
	move 1,(2)
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

divsi3_volatile_divisor:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,1
	move 1,(2)
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

divsi3_volatile_dividend:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,(1)
	move 1,2
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

divsi3_global_dividend:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setzb 10,11
	pushj 17,safe_divisor
	move 10,divsi3_ga
	idiv 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

divsi3_global_divisor:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,1
	move 1,divsi3_gb
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

divsi3_array_dividend:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	andi 2,17
	add 1,2
	move 12,(1)
	move 1,3
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

divsi3_array_divisor:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,1
	andi 3,17
	add 2,3
	move 1,(2)
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

divsi3_global_array_dividend:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	andi 1,17
	move 12,divsi3_buf(1)
	move 1,2
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

divsi3_global_array_divisor:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,1
	andi 2,17
	move 1,divsi3_buf(2)
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

divsi3_struct_dividend:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,1
	move 1,2
	pushj 17,safe_divisor
	move 10,(12)
	idiv 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

divsi3_struct_divisor:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,1
	move 1,1(2)
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

divsi3_global_struct_dividend:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setzb 10,11
	pushj 17,safe_divisor
	move 10,divsi3_gp
	idiv 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

divsi3_global_struct_divisor:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,1
	move 1,divsi3_gp+1
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

divsi3_qi_dividend:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,1
	move 1,2
	lsh 12,33
	ash 12,-33
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

divsi3_qi_divisor:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,1
	andi 2,777	; zero_extendqisi2
	move 1,2
	lsh 1,33
	ash 1,-33
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

divsi3_hi_dividend:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,1
	move 1,2
	hrre 12,12
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

divsi3_hi_divisor:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,1
	hrrzi 2,(2)	; zero_extendhisi2
	hrre 1,2	; extendhisi2
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

divsi3_expr_dividend:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,1
	move 1,3
	add 12,2
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

divsi3_expr_divisor:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,1
	add 2,3
	move 1,2
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

divsi3_shifted_dividend:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,1
	move 1,2
	lsh 12,3
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

divsi3_shifted_divisor:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,1
	ash 2,-3
	move 1,2
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

divsi3_neg_dividend:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,1
	move 1,2
	movn 12,12
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

divsi3_neg_result:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,1
	move 1,2
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	movn 10,10
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

divsi3_store_reg:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	setzb 10,11
	move 13,1
	move 12,2
	move 1,3
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	movem 10,(13)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

divsi3_store_reg_ret:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	setzb 10,11
	move 13,1
	move 12,2
	move 1,3
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	movem 10,(13)
	move 1,10
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

divsi3_store_mem:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	setzb 10,11
	move 13,1
	move 12,2
	move 1,(3)
	pushj 17,safe_divisor
	move 10,(12)
	idiv 10,1
	movem 10,(13)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

divsi3_store_mem_ret:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	setzb 10,11
	move 13,1
	move 12,2
	move 1,(3)
	pushj 17,safe_divisor
	move 10,(12)
	idiv 10,1
	movem 10,(13)
	move 1,10
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

divsi3_memdest:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	setzb 10,11
	move 13,1
	move 12,2
	move 1,(1)
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	movem 10,(13)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

divsi3_memdest_ret:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	setzb 10,11
	move 13,1
	move 12,2
	move 1,(1)
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	movem 10,(13)
	move 1,10
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

divsi3_memdest_array:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	setzb 10,11
	move 13,1
	move 12,3
	andi 2,17
	add 13,2
	move 1,(13)
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	movem 10,(13)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

divsi3_memdest_array_ret:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	setzb 10,11
	move 13,1
	move 12,3
	andi 2,17
	add 13,2
	move 1,(13)
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	movem 10,(13)
	move 1,10
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

divsi3_memdest_global:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,1
	move 1,divsi3_ga
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	movem 10,divsi3_ga
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

divsi3_memdest_global_ret:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,1
	move 1,divsi3_ga
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	movem 10,divsi3_ga
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

divsi3_memdest_struct:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	setzb 10,11
	move 13,1
	move 12,2
	move 1,1(1)
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	movem 10,1(13)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

divsi3_memdest_struct_ret:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	setzb 10,11
	move 13,1
	move 12,2
	move 1,1(1)
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	movem 10,1(13)
	move 1,10
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

divsi3_branch_eq_zero:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,1
	move 1,2
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	movei 1,1
	jumpe 10,%L62
	move 1,10
%L62:
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

divsi3_branch_negative:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,1
	move 1,2
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	camge 10,[-1]
	seto 10,
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

divsi3_branch_positive:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,1
	move 1,2
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	caige 10,0
	movei 10,0
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

divsi3_select:
	add 17,[10,,10]
	movei 0,-7(17)
	hrli 0,10
	blt 0,-2(17)
	setzb 6,7
	setzb 14,15
	move 11,1
	move 10,3
	move 12,4
	move 1,2
	movem 6,-1(17)
	movem 7,(17)
	pushj 17,safe_divisor
	move 13,1
	move 1,12
	pushj 17,safe_divisor
	move 12,1
	move 7,(17)
	caml 11,10
	jrst %L69
	move 6,11
	idiv 6,13
	move 1,6
%L68:
	movei 0,10
	hrli 0,-7(17)
	blt 0,15
	add 17,[-10,,-10]
	popj 17,
%L69:
	move 14,10
	idiv 14,1
	move 1,14
	jrst %L68

divsi3_two_quotients:
	add 17,[10,,10]
	movem 16,-7(17)
	movei 0,-6(17)
	hrli 0,10
	blt 0,-1(17)
	setzb 12,13
	setzb 10,11
	move 14,1
	move 15,3
	move 1,2
	movem 4,(17)
	pushj 17,safe_divisor
	move 16,1
	move 4,(17)
	move 1,4
	pushj 17,safe_divisor
	move 12,14
	idiv 12,16
	move 10,15
	idiv 10,1
	add 10,12
	move 1,10
	move 16,-7(17)
	movei 0,10
	hrli 0,-6(17)
	blt 0,15
	add 17,[-10,,-10]
	popj 17,

divsi3_call_pressure:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,1
	move 1,2
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	pushj 17,clobber
	add 10,12
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

divsi3_mem_call_pressure:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,1
	move 1,2
	pushj 17,safe_divisor
	move 10,(12)
	idiv 10,1
	pushj 17,clobber
	add 10,(12)
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

divsi3_store_call_pressure:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	setzb 10,11
	move 13,1
	move 12,2
	move 1,(1)
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	movem 10,(13)
	pushj 17,clobber
	move 1,(13)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

divsi3_loop_sum:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	setzb 10,11
	move 12,1
	move 13,2
	move 1,3
	pushj 17,safe_divisor
	setzb 6,3
	caml 6,13
	jrst %L82
	move 2,13
	subi 2,1
%L83:
	move 4,3
	andi 4,17
	add 4,12
	move 10,(4)
	idiv 10,1
	add 6,10
	addi 3,1
	sojge 2,%L83	; doloop_end
%L82:
	move 1,6
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

divsi3_loop_update:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	setzb 10,11
	move 12,1
	move 13,2
	move 1,3
	pushj 17,safe_divisor
	movei 3,0
	caml 3,13
	jrst %L93
	move 2,13
	subi 2,1
%L94:
	move 4,3
	andi 4,17
	add 4,12
	move 10,(4)
	idiv 10,1
	movem 10,(4)
	addi 3,1
	sojge 2,%L94	; doloop_end
%L93:
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

divsi3_loop_memdest:
	add 17,[10,,10]
	movem 16,-7(17)
	movei 0,-6(17)
	hrli 0,10
	blt 0,-1(17)
	setzb 11,12
	movem 1,(17)
	move 16,2
	move 14,3
	setzb 15,13
	camge 15,2
	jrst %L104
%L106:
	move 1,15
	move 16,-7(17)
	movei 0,10
	hrli 0,-6(17)
	blt 0,15
	add 17,[-10,,-10]
	popj 17,
%L104:
	move 10,13
	andi 10,17
	add 10,(17)
	move 1,(10)
	pushj 17,safe_divisor
	move 11,14
	idiv 11,1
	movem 11,(10)
	add 15,11
	addi 13,1
	camge 13,16
	jrst %L104
	jrst %L106

divsi3_1:
	move 4,[252525252526]
	mul 4,2
	ashc 4,-44
	ash 2,-43
	move 6,5
	sub 6,2
	move 1,6
	popj 17,

divsi3_2:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	move 12,1
	move 1,2
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

divsi3_3:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	setzb 10,11
	move 12,1
	move 13,2
	move 1,(2)
	pushj 17,safe_divisor
	move 10,12
	idiv 10,1
	movem 10,(13)
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

	.bss
divsi3_ga:
	.space	4
divsi3_gb:
	.space	4
divsi3_buf:
	.space	64
divsi3_gp:
	.space	8
