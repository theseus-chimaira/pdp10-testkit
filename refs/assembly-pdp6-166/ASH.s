
ash_const_0:
	popj 17,

ash_const_1:
	ash 1,-1
	popj 17,

ash_const_2:
	ash 1,-2
	popj 17,

ash_const_8:
	ash 1,-10
	popj 17,

ash_const_9:
	ash 1,-11
	popj 17,

ash_const_17:
	ash 1,-21
	popj 17,

ash_const_18:
	hlre 1,1
	popj 17,

ash_const_27:
	ash 1,-33
	popj 17,

ash_const_35:
	ash 1,-43
	popj 17,

ash_var:
	movn 2,2
	ash 1,(2)
	popj 17,

ash_var_neg_count:
	ash 1,(2)
	popj 17,

ash_var_plus_1:
	setca 2,
	ash 1,(2)
	popj 17,

ash_var_minus_1:
	subi 2,1
	movn 2,2
	ash 1,(2)
	popj 17,

ash_one_plus_var:
	setca 2,
	ash 1,(2)
	popj 17,

ash_one_minus_var:
	ash 1,-1(2)
	popj 17,

ash_masked_count:
	andi 2,77
	movn 2,2
	ash 1,(2)
	popj 17,

ash_masked_count_small:
	andi 2,35
	movn 2,2
	ash 1,(2)
	popj 17,

ash_count_from_mem:
	movn 4,(2)
	ash 1,(4)
	popj 17,

ash_count_from_mem_neg:
	ash 1,@(2)
	popj 17,

ash_count_from_mem_plus:
	setcm 4,(2)
	ash 1,(4)
	popj 17,

ash_value_from_mem:
	move 1,(1)
	movn 2,2
	ash 1,(2)
	popj 17,

ash_value_and_count_from_mem:
	move 1,(1)
	movn 4,(2)
	ash 1,(4)
	popj 17,

ash_store_result:
	movn 3,3
	ash 2,(3)
	movem 2,(1)
	move 1,2
	popj 17,

ash_store_void:
	movn 3,3
	ash 2,(3)
	movem 2,(1)
	popj 17,

ash_assign_local:
	movn 2,2
	ash 1,(2)
	movn 3,3
	ash 1,(3)
	popj 17,

ash_assign_mem:
	move 4,(1)
	movn 2,2
	ash 4,(2)
	movem 4,(1)
	move 1,4
	popj 17,

ash_volatile_value:
	move 1,(1)
	movn 2,2
	ash 1,(2)
	popj 17,

ash_volatile_count:
	move 4,(2)
	movn 4,4
	ash 1,(4)
	popj 17,

ash_volatile_store:
	movn 3,3
	ash 2,(3)
	movem 2,(1)
	popj 17,

ash_qi_signed:
	lsh 1,33
	ash 1,-33
	movn 2,2
	ash 1,(2)
	popj 17,

ash_hi_signed:
	hrre 1,1
	movn 2,2
	ash 1,(2)
	popj 17,

ash_qi_signed_const:
	lsh 1,33
	ash 1,-34
	popj 17,

ash_hi_signed_const:
	lsh 1,22
	ash 1,-23
	popj 17,

ash_sign_extend_9:
	lsh 1,33
	ash 1,-33
	popj 17,

ash_sign_extend_18:
	hrre 1,1
	popj 17,

ash_extract_top_half:
	hlre 1,1
	popj 17,

ash_extract_top_byte:
	ash 1,-33
	popj 17,

ash_negative_literal_1:
	seto 1,
	popj 17,

ash_negative_literal_18:
	seto 1,
	popj 17,

ash_signbit_literal:
	seto 1,
	popj 17,

ash_large_positive_literal:
	movei 1,0
	popj 17,

ash_with_add:
	add 1,2
	movn 3,3
	ash 1,(3)
	popj 17,

ash_with_sub:
	sub 1,2
	movn 3,3
	ash 1,(3)
	popj 17,

ash_with_and:
	movn 2,2
	lsh 1,(2)
	popj 17,

ash_two_results:
	move 3,1
	movn 4,2
	ash 1,(4)
	setca 2,
	ash 3,(2)
	add 1,3
	popj 17,

ash_call_pressure:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	movn 2,2
	move 11,1
	ash 11,(2)
	pushj 17,clobber
	ash 10,-1
	add 11,10
	move 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

ash_array_value:
	andi 2,7
	add 1,2
	move 1,(1)
	movn 3,3
	ash 1,(3)
	popj 17,

ash_array_count:
	andi 3,7
	add 2,3
	movn 4,(2)
	ash 1,(4)
	popj 17,

ash_struct_value:
	move 1,1(1)
	movn 2,2
	ash 1,(2)
	popj 17,

ash_struct_count:
	movn 4,2(2)
	ash 1,(4)
	popj 17,

	.comm	p, 4
