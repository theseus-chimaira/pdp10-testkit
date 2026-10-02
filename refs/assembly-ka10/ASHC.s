
ashc_r_const_0:
	popj 17,

ashc_r_const_1:
	ashc 1,-1
	popj 17,

ashc_r_const_2:
	ashc 1,-2
	popj 17,

ashc_r_const_8:
	ashc 1,-10
	popj 17,

ashc_r_const_9:
	ashc 1,-11
	popj 17,

ashc_r_const_17:
	ashc 1,-21
	popj 17,

ashc_r_const_18:
	ashc 1,-22
	popj 17,

ashc_r_const_35:
	ashc 1,-43
	popj 17,

ashc_r_const_36:
	ashc 1,-44
	popj 17,

ashc_r_const_37:
	ashc 1,-45
	popj 17,

ashc_r_const_54:
	ashc 1,-66
	popj 17,

ashc_r_const_70:
	ashc 1,-106
	popj 17,

ashc_l_const_1:
	tlne 1,200000
	tloa 1,400000
	tlz 1,400000
	ashc 1,1
	popj 17,

ashc_l_const_2:
	tlne 1,100000
	tloa 1,400000
	tlz 1,400000
	ashc 1,2
	popj 17,

ashc_l_const_8:
	tlne 1,1000
	tloa 1,400000
	tlz 1,400000
	ashc 1,10
	popj 17,

ashc_l_const_9:
	tlne 1,400
	tloa 1,400000
	tlz 1,400000
	ashc 1,11
	popj 17,

ashc_l_const_18:
	trne 1,400000
	tloa 1,400000
	tlz 1,400000
	ashc 1,22
	popj 17,

ashc_l_const_35:
	trne 1,1
	tloa 1,400000
	tlz 1,400000
	ashc 1,43
	popj 17,

ashc_l_const_36:
	lshc 1,45
	tlne 1,400000
	tlo 2,400000
	popj 17,

ashc_l_const_37:
	lshc 1,46
	tlne 1,400000
	tlo 2,400000
	popj 17,

ashc_l_const_70:
	lshc 1,107
	tlne 1,400000
	tlo 2,400000
	popj 17,

ashc_r_var:
	movn 3,3
	ashc 1,(3)
	popj 17,

ashc_l_var:
	lsh 2,1
	lshc 1,(3)
	lsh 2,-1
	tlne 1,400000
	tlo 2,400000
	popj 17,

ashc_r_var_neg_count:
	ashc 1,(3)
	popj 17,

ashc_l_var_neg_count:
	movn 3,3
	lsh 2,1
	lshc 1,(3)
	lsh 2,-1
	tlne 1,400000
	tlo 2,400000
	popj 17,

ashc_r_var_plus_1:
	setca 3,
	ashc 1,(3)
	popj 17,

ashc_r_var_minus_1:
	subi 3,1
	movn 3,3
	ashc 1,(3)
	popj 17,

ashc_r_one_plus_var:
	setca 3,
	ashc 1,(3)
	popj 17,

ashc_r_one_minus_var:
	ashc 1,-1(3)
	popj 17,

ashc_l_var_plus_1:
	lsh 2,1
	lshc 1,1(3)
	lsh 2,-1
	tlne 1,400000
	tlo 2,400000
	popj 17,

ashc_l_var_minus_1:
	lsh 2,1
	lshc 1,-1(3)
	lsh 2,-1
	tlne 1,400000
	tlo 2,400000
	popj 17,

ashc_l_one_plus_var:
	lsh 2,1
	lshc 1,1(3)
	lsh 2,-1
	tlne 1,400000
	tlo 2,400000
	popj 17,

ashc_l_one_minus_var:
	movei 4,1
	sub 4,3
	lsh 2,1
	lshc 1,(4)
	lsh 2,-1
	tlne 1,400000
	tlo 2,400000
	popj 17,

ashc_r_masked_count:
	andi 3,77
	movn 3,3
	ashc 1,(3)
	popj 17,

ashc_l_masked_count:
	andi 3,77
	lsh 2,1
	lshc 1,(3)
	lsh 2,-1
	tlne 1,400000
	tlo 2,400000
	popj 17,

ashc_r_small_masked_count:
	andi 3,35
	movn 3,3
	ashc 1,(3)
	popj 17,

ashc_l_small_masked_count:
	andi 3,35
	lsh 2,1
	lshc 1,(3)
	lsh 2,-1
	tlne 1,400000
	tlo 2,400000
	popj 17,

ashc_r_count_from_mem:
	movn 4,(3)
	ashc 1,(4)
	popj 17,

ashc_l_count_from_mem:
	lsh 2,1
	lshc 1,@(3)
	lsh 2,-1
	tlne 1,400000
	tlo 2,400000
	popj 17,

ashc_r_count_from_mem_neg:
	ashc 1,@(3)
	popj 17,

ashc_l_count_from_mem_neg:
	movn 4,(3)
	lsh 2,1
	lshc 1,(4)
	lsh 2,-1
	tlne 1,400000
	tlo 2,400000
	popj 17,

ashc_r_count_from_mem_plus:
	setcm 4,(3)
	ashc 1,(4)
	popj 17,

ashc_l_count_from_mem_plus:
	move 4,(3)
	addi 4,1
	lsh 2,1
	lshc 1,(4)
	lsh 2,-1
	tlne 1,400000
	tlo 2,400000
	popj 17,

ashc_r_value_from_mem:
	move 4,(1)
	move 5,1(1)
	movn 2,2
	ashc 4,(2)
	move 1,4
	move 2,5
	popj 17,

ashc_l_value_from_mem:
	move 4,(1)
	move 5,1(1)
	lsh 5,1
	lshc 4,(2)
	lsh 5,-1
	tlne 4,400000
	tlo 5,400000
	move 1,4
	move 2,5
	popj 17,

ashc_r_value_and_count_from_mem:
	move 4,(1)
	move 5,1(1)
	movn 3,(2)
	ashc 4,(3)
	move 1,4
	move 2,5
	popj 17,

ashc_l_value_and_count_from_mem:
	move 4,(1)
	move 5,1(1)
	lsh 5,1
	lshc 4,@(2)
	lsh 5,-1
	tlne 4,400000
	tlo 5,400000
	move 1,4
	move 2,5
	popj 17,

ashc_r_store_result:
	movn 4,4
	ashc 2,(4)
	movem 2,(1)
	movem 3,1(1)
	move 6,(1)
	move 7,3
	move 1,6
	move 2,7
	popj 17,

ashc_l_store_result:
	lsh 3,1
	lshc 2,(4)
	lsh 3,-1
	tlne 2,400000
	tlo 3,400000
	movem 2,(1)
	movem 3,1(1)
	move 6,(1)
	move 7,3
	move 1,6
	move 2,7
	popj 17,

ashc_r_store_void:
	movn 4,4
	ashc 2,(4)
	movem 2,(1)
	movem 3,1(1)
	popj 17,

ashc_l_store_void:
	lsh 3,1
	lshc 2,(4)
	lsh 3,-1
	tlne 2,400000
	tlo 3,400000
	movem 2,(1)
	movem 3,1(1)
	popj 17,

ashc_r_assign_local:
	movn 3,3
	ashc 1,(3)
	movn 4,4
	ashc 1,(4)
	popj 17,

ashc_l_assign_local:
	lsh 2,1
	lshc 1,(3)
	lsh 2,-1
	tlne 1,400000
	tlo 2,400000
	lsh 2,1
	lshc 1,(4)
	lsh 2,-1
	tlne 1,400000
	tlo 2,400000
	popj 17,

ashc_r_assign_mem:
	move 4,(1)
	move 5,1(1)
	movn 2,2
	ashc 4,(2)
	movem 4,(1)
	movem 5,1(1)
	move 6,(1)
	move 7,5
	move 1,6
	move 2,7
	popj 17,

ashc_l_assign_mem:
	move 4,(1)
	move 5,1(1)
	lsh 5,1
	lshc 4,(2)
	lsh 5,-1
	tlne 4,400000
	tlo 5,400000
	movem 4,(1)
	movem 5,1(1)
	move 6,(1)
	move 7,5
	move 1,6
	move 2,7
	popj 17,

ashc_r_volatile_value:
	move 4,(1)
	move 5,1(1)
	movn 2,2
	ashc 4,(2)
	move 1,4
	move 2,5
	popj 17,

ashc_l_volatile_value:
	move 4,(1)
	move 5,1(1)
	lsh 5,1
	lshc 4,(2)
	lsh 5,-1
	tlne 4,400000
	tlo 5,400000
	move 1,4
	move 2,5
	popj 17,

ashc_r_volatile_count:
	move 4,(3)
	movn 4,4
	ashc 1,(4)
	popj 17,

ashc_l_volatile_count:
	move 4,(3)
	lsh 2,1
	lshc 1,(4)
	lsh 2,-1
	tlne 1,400000
	tlo 2,400000
	popj 17,

ashc_r_volatile_store:
	movn 4,4
	ashc 2,(4)
	movem 2,(1)
	movem 3,1(1)
	popj 17,

ashc_l_volatile_store:
	lsh 3,1
	lshc 2,(4)
	lsh 3,-1
	tlne 2,400000
	tlo 3,400000
	movem 2,(1)
	movem 3,1(1)
	popj 17,

ashc_from_sint_r:
	move 5,1
	ash 1,-43
	move 4,1
	movn 2,2
	ashc 4,(2)
	move 1,4
	move 2,5
	popj 17,

ashc_from_sint_l:
	move 5,1
	ash 1,-43
	move 4,1
	lsh 5,1
	lshc 4,(2)
	lsh 5,-1
	tlne 4,400000
	tlo 5,400000
	move 1,4
	move 2,5
	popj 17,

ashc_from_uint_l:
	move 5,1
	movei 4,0
	lsh 5,1
	lshc 4,(2)
	lsh 5,-1
	tlne 4,400000
	tlo 5,400000
	move 1,4
	move 2,5
	popj 17,

ashc_from_qi_r:
	lsh 1,33
	ash 1,-33
	move 5,1
	ash 1,-43
	move 4,1
	movn 2,2
	ashc 4,(2)
	move 1,4
	move 2,5
	popj 17,

ashc_from_qi_l:
	lsh 1,33
	ash 1,-33
	move 5,1
	ash 1,-43
	move 4,1
	lsh 5,1
	lshc 4,(2)
	lsh 5,-1
	tlne 4,400000
	tlo 5,400000
	move 1,4
	move 2,5
	popj 17,

ashc_from_hi_r:
	hrre 1,1
	move 5,1
	ash 1,-43
	move 4,1
	movn 2,2
	ashc 4,(2)
	move 1,4
	move 2,5
	popj 17,

ashc_from_hi_l:
	hrre 1,1
	move 5,1
	ash 1,-43
	move 4,1
	lsh 5,1
	lshc 4,(2)
	lsh 5,-1
	tlne 4,400000
	tlo 5,400000
	move 1,4
	move 2,5
	popj 17,

ashc_sign_extend_9:
	lshc 1,100
	tlne 1,400000
	tlo 2,400000
	ashc 1,-77
	popj 17,

ashc_sign_extend_18:
	lshc 1,67
	tlne 1,400000
	tlo 2,400000
	ashc 1,-66
	popj 17,

ashc_sign_extend_36:
	lshc 1,45
	tlne 1,400000
	tlo 2,400000
	ashc 1,-44
	popj 17,

ashc_extract_high_word:
	ashc 1,-44
	popj 17,

ashc_extract_high_half:
	ashc 1,-66
	popj 17,

ashc_negative_literal_1:
	seto 1,
	movni 2,1
	popj 17,

ashc_negative_literal_36:
	seto 1,
	movni 2,1
	popj 17,

ashc_negative_literal_70:
	seto 1,
	movni 2,1
	popj 17,

ashc_one_l_35:
	move 1,[1]
	move 2,[0]
	popj 17,

ashc_one_l_36:
	move 1,[2]
	move 2,[0]
	popj 17,

ashc_one_l_70:
	move 1,[400000000000]
	move 2,[400000000000]
	popj 17,

ashc_with_add:
	push 17,10
	move 6,1
	move 7,2
	move 2,7
	add 2,4
	move 5,2
	tlc 5,400000
	move 10,7
	tlc 10,400000
	caml 5,10
	tdza 5,5
	movei 5,1
	move 1,6
	add 1,3
	add 1,5
	movn 4,-2(17)
	ashc 1,(4)
	pop 17,10
	popj 17,

ashc_with_sub:
	push 17,10
	move 6,1
	move 7,2
	move 2,7
	sub 2,4
	move 5,2
	tlc 5,400000
	move 10,7
	tlc 10,400000
	camg 5,10
	tdza 5,5
	movei 5,1
	move 1,6
	sub 1,3
	sub 1,5
	movn 4,-2(17)
	ashc 1,(4)
	pop 17,10
	popj 17,

ashc_left_with_add:
	push 17,10
	move 6,1
	move 7,2
	move 2,7
	add 2,4
	move 5,2
	tlc 5,400000
	move 10,7
	tlc 10,400000
	caml 5,10
	tdza 5,5
	movei 5,1
	move 1,6
	add 1,3
	add 1,5
	lsh 2,1
	lshc 1,@-2(17)
	lsh 2,-1
	tlne 1,400000
	tlo 2,400000
	pop 17,10
	popj 17,

ashc_two_right_results:
	push 17,10
	move 4,1
	move 5,2
	movn 2,3
	move 6,4
	move 7,5
	ashc 6,(2)
	setca 3,
	ashc 4,(3)
	move 2,7
	add 2,5
	move 3,2
	tlc 3,400000
	move 10,7
	tlc 10,400000
	caml 3,10
	tdza 3,3
	movei 3,1
	move 1,6
	add 1,4
	add 1,3
	pop 17,10
	popj 17,

ashc_two_left_results:
	push 17,10
	move 4,1
	move 5,2
	move 6,1
	move 7,2
	lsh 7,1
	lshc 6,(3)
	lsh 7,-1
	tlne 6,400000
	tlo 7,400000
	lsh 5,1
	lshc 4,1(3)
	lsh 5,-1
	tlne 4,400000
	tlo 5,400000
	move 2,7
	add 2,5
	move 3,2
	tlc 3,400000
	move 10,7
	tlc 10,400000
	caml 3,10
	tdza 3,3
	movei 3,1
	move 1,6
	add 1,4
	add 1,3
	pop 17,10
	popj 17,

ashc_mixed_results:
	push 17,10
	move 4,1
	move 5,2
	movn 2,3
	move 6,4
	move 7,5
	ashc 6,(2)
	lsh 5,1
	lshc 4,1(3)
	lsh 5,-1
	tlne 4,400000
	tlo 5,400000
	move 2,7
	add 2,5
	move 3,2
	tlc 3,400000
	move 10,7
	tlc 10,400000
	caml 3,10
	tdza 3,3
	movei 3,1
	move 1,6
	add 1,4
	add 1,3
	pop 17,10
	popj 17,

ashc_call_pressure:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 10,1
	move 11,2
	movn 3,3
	move 12,1
	move 13,2
	ashc 12,(3)
	pushj 17,clobber
	ashc 10,-1
	move 2,13
	add 2,11
	move 4,2
	tlc 4,400000
	move 3,13
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 1,12
	add 1,10
	add 1,4
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

ashc_left_call_pressure:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 10,1
	move 11,2
	move 12,1
	move 13,2
	lsh 13,1
	lshc 12,(3)
	lsh 13,-1
	tlne 12,400000
	tlo 13,400000
	pushj 17,clobber
	tlne 10,200000
	tloa 10,400000
	tlz 10,400000
	ashc 10,1
	move 2,13
	add 2,11
	move 4,2
	tlc 4,400000
	move 3,13
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 1,12
	add 1,10
	add 1,4
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

ashc_array_value:
	andi 2,7
	lsh 2,1
	add 2,1
	move 4,(2)
	move 5,1(2)
	movn 3,3
	ashc 4,(3)
	move 1,4
	move 2,5
	popj 17,

ashc_array_count:
	andi 4,7
	add 3,4
	movn 4,(3)
	ashc 1,(4)
	popj 17,

ashc_left_array_value:
	andi 2,7
	lsh 2,1
	add 2,1
	move 4,(2)
	move 5,1(2)
	lsh 5,1
	lshc 4,(3)
	lsh 5,-1
	tlne 4,400000
	tlo 5,400000
	move 1,4
	move 2,5
	popj 17,

ashc_left_array_count:
	andi 4,7
	add 3,4
	lsh 2,1
	lshc 1,@(3)
	lsh 2,-1
	tlne 1,400000
	tlo 2,400000
	popj 17,

ashc_struct_value:
	move 4,2(1)
	move 5,3(1)
	movn 2,2
	ashc 4,(2)
	move 1,4
	move 2,5
	popj 17,

ashc_struct_count:
	movn 4,4(3)
	ashc 1,(4)
	popj 17,

ashc_left_struct_value:
	move 4,2(1)
	move 5,3(1)
	lsh 5,1
	lshc 4,(2)
	lsh 5,-1
	tlne 4,400000
	tlo 5,400000
	move 1,4
	move 2,5
	popj 17,

ashc_left_struct_count:
	lsh 2,1
	lshc 1,@4(3)
	lsh 2,-1
	tlne 1,400000
	tlo 2,400000
	popj 17,

	.comm	p, 4
