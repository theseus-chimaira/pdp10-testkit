
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
	setzb 4,5
	move 4,1
	idivi 4,3
	move 1,4
	popj 17,

divsi3_const_10:
	setzb 4,5
	move 4,1
	idivi 4,12
	move 1,4
	popj 17,

divsi3_const_octal:
	setzb 4,5
	move 4,1
	idivi 4,123456
	move 1,4
	popj 17,

divsi3_const_neg_octal:
	setzb 4,5
	move 4,1
	idiv 4,[-123456]
	move 1,4
	popj 17,

divsi3_const_low9:
	setzb 4,5
	move 4,1
	idivi 4,777
	move 1,4
	popj 17,

divsi3_const_low18:
	setzb 4,5
	move 4,1
	idivi 4,777777
	move 1,4
	popj 17,

divsi3_const_large:
	setzb 4,5
	move 4,1
	idiv 4,[123456123456]
	move 1,4
	popj 17,

divsi3_const_large_neg:
	setzb 4,5
	move 4,1
	idiv 4,[-123456123]
	move 1,4
	popj 17,

divsi3_reg_reg:
	push 17,10
	move 10,1
	move 1,2
	pushj 17,safe_divisor
	idivm 10,1
	pop 17,10
	popj 17,

divsi3_reg_reg_neg_divisor:
	push 17,10
	move 10,1
	move 1,2
	pushj 17,safe_divisor
	movn 1,1
	idivm 10,1
	pop 17,10
	popj 17,

divsi3_reg_mem:
	push 17,10
	move 10,1
	move 1,(2)
	pushj 17,safe_divisor
	idivm 10,1
	pop 17,10
	popj 17,

divsi3_mem_reg:
	push 17,10
	move 10,(1)
	move 1,2
	pushj 17,safe_divisor
	move 2,1
	idivm 10,2
	move 1,2
	pop 17,10
	popj 17,

divsi3_mem_mem:
	push 17,10
	move 10,(1)
	move 1,(2)
	pushj 17,safe_divisor
	idivm 10,1
	pop 17,10
	popj 17,

divsi3_volatile_divisor:
	push 17,10
	move 10,1
	move 1,(2)
	pushj 17,safe_divisor
	idivm 10,1
	pop 17,10
	popj 17,

divsi3_volatile_dividend:
	push 17,10
	move 10,(1)
	move 1,2
	pushj 17,safe_divisor
	move 2,1
	idivm 10,2
	move 1,2
	pop 17,10
	popj 17,

divsi3_global_dividend:
	pushj 17,safe_divisor
	move 4,divsi3_ga
	idivm 4,1
	popj 17,

divsi3_global_divisor:
	push 17,10
	move 10,1
	move 1,divsi3_gb
	pushj 17,safe_divisor
	idivm 10,1
	pop 17,10
	popj 17,

divsi3_array_dividend:
	push 17,10
	andi 2,17
	add 1,2
	move 10,(1)
	move 1,3
	pushj 17,safe_divisor
	move 3,1
	idivm 10,3
	move 1,3
	pop 17,10
	popj 17,

divsi3_array_divisor:
	push 17,10
	move 10,1
	andi 3,17
	add 2,3
	move 1,(2)
	pushj 17,safe_divisor
	idivm 10,1
	pop 17,10
	popj 17,

divsi3_global_array_dividend:
	push 17,10
	andi 1,17
	move 10,divsi3_buf(1)
	move 1,2
	pushj 17,safe_divisor
	move 2,1
	idivm 10,2
	move 1,2
	pop 17,10
	popj 17,

divsi3_global_array_divisor:
	push 17,10
	move 10,1
	andi 2,17
	move 1,divsi3_buf(2)
	pushj 17,safe_divisor
	idivm 10,1
	pop 17,10
	popj 17,

divsi3_struct_dividend:
	push 17,10
	move 10,1
	move 1,2
	pushj 17,safe_divisor
	move 4,(10)
	idivm 4,1
	pop 17,10
	popj 17,

divsi3_struct_divisor:
	push 17,10
	move 10,1
	move 1,1(2)
	pushj 17,safe_divisor
	idivm 10,1
	pop 17,10
	popj 17,

divsi3_global_struct_dividend:
	pushj 17,safe_divisor
	move 4,divsi3_gp
	idivm 4,1
	popj 17,

divsi3_global_struct_divisor:
	push 17,10
	move 10,1
	move 1,divsi3_gp+1
	pushj 17,safe_divisor
	idivm 10,1
	pop 17,10
	popj 17,

divsi3_qi_dividend:
	push 17,10
	move 10,1
	move 1,2
	lsh 10,33
	ash 10,-33
	pushj 17,safe_divisor
	idivm 10,1
	pop 17,10
	popj 17,

divsi3_qi_divisor:
	push 17,10
	move 10,1
	andi 2,777	; zero_extendqisi2
	move 1,2
	lsh 1,33
	ash 1,-33
	pushj 17,safe_divisor
	idivm 10,1
	pop 17,10
	popj 17,

divsi3_hi_dividend:
	push 17,10
	move 10,1
	move 1,2
	hrre 10,10
	pushj 17,safe_divisor
	idivm 10,1
	pop 17,10
	popj 17,

divsi3_hi_divisor:
	push 17,10
	move 10,1
	hrrzi 2,(2)	; zero_extendhisi2
	hrre 1,2	; extendhisi2
	pushj 17,safe_divisor
	idivm 10,1
	pop 17,10
	popj 17,

divsi3_expr_dividend:
	push 17,10
	move 10,1
	move 1,3
	add 10,2
	pushj 17,safe_divisor
	idivm 10,1
	pop 17,10
	popj 17,

divsi3_expr_divisor:
	push 17,10
	move 10,1
	add 2,3
	move 1,2
	pushj 17,safe_divisor
	idivm 10,1
	pop 17,10
	popj 17,

divsi3_shifted_dividend:
	push 17,10
	move 10,1
	move 1,2
	lsh 10,3
	pushj 17,safe_divisor
	idivm 10,1
	pop 17,10
	popj 17,

divsi3_shifted_divisor:
	push 17,10
	move 10,1
	ash 2,-3
	move 1,2
	pushj 17,safe_divisor
	idivm 10,1
	pop 17,10
	popj 17,

divsi3_neg_dividend:
	push 17,10
	move 10,1
	move 1,2
	movn 10,10
	pushj 17,safe_divisor
	idivm 10,1
	pop 17,10
	popj 17,

divsi3_neg_result:
	push 17,10
	move 10,1
	move 1,2
	pushj 17,safe_divisor
	idivm 10,1
	movn 1,1
	pop 17,10
	popj 17,

divsi3_store_reg:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	move 1,3
	pushj 17,safe_divisor
	idivm 10,1
	movem 1,(11)
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

divsi3_store_reg_ret:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	move 1,3
	pushj 17,safe_divisor
	idivm 10,1
	movem 1,(11)
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

divsi3_store_mem:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	move 1,(3)
	pushj 17,safe_divisor
	move 4,(10)
	idivm 4,1
	movem 1,(11)
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

divsi3_store_mem_ret:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	move 1,(3)
	pushj 17,safe_divisor
	move 4,(10)
	idivm 4,1
	movem 1,(11)
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

divsi3_memdest:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	move 1,(1)
	pushj 17,safe_divisor
	idivm 11,1
	movem 1,(10)
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

divsi3_memdest_ret:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	move 1,(1)
	pushj 17,safe_divisor
	idivm 10,1
	movem 1,(11)
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

divsi3_memdest_array:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,3
	andi 2,17
	add 11,2
	move 1,(11)
	pushj 17,safe_divisor
	idivm 10,1
	movem 1,(11)
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

divsi3_memdest_array_ret:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,3
	andi 2,17
	add 11,2
	move 1,(11)
	pushj 17,safe_divisor
	idivm 10,1
	movem 1,(11)
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

divsi3_memdest_global:
	push 17,10
	move 10,1
	move 1,divsi3_ga
	pushj 17,safe_divisor
	idivm 10,1
	movem 1,divsi3_ga
	pop 17,10
	popj 17,

divsi3_memdest_global_ret:
	push 17,10
	move 10,1
	move 1,divsi3_ga
	pushj 17,safe_divisor
	idivm 10,1
	movem 1,divsi3_ga
	pop 17,10
	popj 17,

divsi3_memdest_struct:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	move 1,1(1)
	pushj 17,safe_divisor
	idivm 10,1
	movem 1,1(11)
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

divsi3_memdest_struct_ret:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	move 1,1(1)
	pushj 17,safe_divisor
	idivm 10,1
	movem 1,1(11)
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

divsi3_branch_eq_zero:
	push 17,10
	move 10,1
	move 1,2
	pushj 17,safe_divisor
	idivm 10,1
	movei 4,1
	jumpe 1,%L62
	move 4,1
%L62:
	move 1,4
	pop 17,10
	popj 17,

divsi3_branch_negative:
	push 17,10
	move 10,1
	move 1,2
	pushj 17,safe_divisor
	idivm 10,1
	camge 1,[-1]
	seto 1,
	pop 17,10
	popj 17,

divsi3_branch_positive:
	push 17,10
	move 10,1
	move 1,2
	pushj 17,safe_divisor
	idivm 10,1
	caige 1,0
	movei 1,0
	pop 17,10
	popj 17,

divsi3_select:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 11,1
	move 10,3
	move 12,4
	move 1,2
	pushj 17,safe_divisor
	move 13,1
	move 1,12
	pushj 17,safe_divisor
	move 12,1
	caml 11,10
	jrst %L69
	move 1,13
	idivm 11,1
%L68:
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,
%L69:
	idivm 10,1
	jrst %L68

divsi3_two_quotients:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 11,1
	move 10,3
	move 13,4
	move 1,2
	pushj 17,safe_divisor
	move 12,1
	move 1,13
	pushj 17,safe_divisor
	move 13,1
	idivm 11,12
	idivm 10,13
	add 12,13
	move 1,12
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

divsi3_call_pressure:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 1,2
	pushj 17,safe_divisor
	move 11,1
	idivm 10,11
	pushj 17,clobber
	add 11,10
	move 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

divsi3_mem_call_pressure:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 1,2
	pushj 17,safe_divisor
	move 10,1
	move 4,(11)
	idivm 4,10
	pushj 17,clobber
	add 10,(11)
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

divsi3_store_call_pressure:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	move 1,(1)
	pushj 17,safe_divisor
	idivm 10,1
	movem 1,(11)
	pushj 17,clobber
	move 1,(11)
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

divsi3_loop_sum:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	move 1,3
	pushj 17,safe_divisor
	setzb 3,6
	caml 3,11
	jrst %L82
	move 2,11
	subi 2,1
%L83:
	move 4,6
	andi 4,17
	add 4,10
	move 4,(4)
	move 7,1
	idivm 4,7
	add 3,7
	addi 6,1
	sojge 2,%L83	; doloop_end
%L82:
	move 1,3
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

divsi3_loop_update:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	move 1,3
	pushj 17,safe_divisor
	movei 6,0
	caml 6,11
	jrst %L93
	move 2,11
	subi 2,1
%L94:
	move 4,6
	andi 4,17
	add 4,10
	move 3,(4)
	move 7,1
	idivm 3,7
	movem 7,(4)
	addi 6,1
	sojge 2,%L94	; doloop_end
%L93:
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

divsi3_loop_memdest:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 15,1
	move 14,2
	move 12,3
	setzb 13,11
	camge 13,2
	jrst %L104
%L106:
	move 1,13
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,
%L104:
	move 10,11
	andi 10,17
	add 10,15
	move 1,(10)
	pushj 17,safe_divisor
	idivm 12,1
	movem 1,(10)
	add 13,1
	addi 11,1
	camge 11,14
	jrst %L104
	jrst %L106

divsi3_1:
	setzb 4,5
	move 4,2
	idivi 4,3
	move 1,4
	popj 17,

divsi3_2:
	push 17,10
	move 10,1
	move 1,2
	pushj 17,safe_divisor
	idivm 10,1
	pop 17,10
	popj 17,

divsi3_3:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	move 1,(2)
	pushj 17,safe_divisor
	idivm 10,1
	movem 1,(11)
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
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
