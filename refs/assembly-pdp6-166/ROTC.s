
rotcl_const_1:
	rotc 1,1
	popj 17,

rotcl_const_2:
	rotc 1,2
	popj 17,

rotcl_const_8:
	rotc 1,10
	popj 17,

rotcl_const_9:
	rotc 1,11
	popj 17,

rotcl_const_17:
	rotc 1,21
	popj 17,

rotcl_const_18:
	rotc 1,22
	popj 17,

rotcl_const_19:
	rotc 1,23
	popj 17,

rotcl_const_35:
	rotc 1,43
	popj 17,

rotcl_const_36:
	rotc 1,44
	popj 17,

rotcl_const_37:
	rotc 1,-43
	popj 17,

rotcl_const_53:
	rotc 1,-23
	popj 17,

rotcl_const_54:
	rotc 1,-22
	popj 17,

rotcl_const_55:
	rotc 1,-21
	popj 17,

rotcl_const_71:
	rotc 1,-1
	popj 17,

rotcr_const_1:
	rotc 1,-1
	popj 17,

rotcr_const_2:
	rotc 1,-2
	popj 17,

rotcr_const_8:
	rotc 1,-10
	popj 17,

rotcr_const_9:
	rotc 1,-11
	popj 17,

rotcr_const_17:
	rotc 1,-21
	popj 17,

rotcr_const_18:
	rotc 1,-22
	popj 17,

rotcr_const_19:
	rotc 1,-23
	popj 17,

rotcr_const_35:
	rotc 1,-43
	popj 17,

rotcr_const_36:
	rotc 1,44
	popj 17,

rotcr_const_37:
	rotc 1,43
	popj 17,

rotcr_const_53:
	rotc 1,23
	popj 17,

rotcr_const_54:
	rotc 1,22
	popj 17,

rotcr_const_55:
	rotc 1,21
	popj 17,

rotcr_const_71:
	rotc 1,1
	popj 17,

rotcl_reg:
	rotc 1,(3)
	popj 17,

rotcr_reg:
	movn 3,3
	rotc 1,(3)
	popj 17,

rotcl_reg_neg:
	movn 3,3
	rotc 1,(3)
	popj 17,

rotcr_reg_neg:
	rotc 1,(3)
	popj 17,

rotcl_reg_plus_1:
	rotc 1,1(3)
	popj 17,

rotcl_reg_plus_2:
	rotc 1,2(3)
	popj 17,

rotcl_reg_minus_1:
	rotc 1,-1(3)
	popj 17,

rotcl_one_plus_reg:
	rotc 1,1(3)
	popj 17,

rotcl_one_minus_reg:
	movei 4,1
	sub 4,3
	rotc 1,(4)
	popj 17,

rotcr_reg_plus_1:
	movei 4,107
	sub 4,3
	rotc 1,(4)
	popj 17,

rotcr_reg_plus_2:
	movei 4,106
	sub 4,3
	rotc 1,(4)
	popj 17,

rotcr_reg_minus_1:
	movei 4,111
	sub 4,3
	rotc 1,(4)
	popj 17,

rotcr_one_plus_reg:
	movei 4,107
	sub 4,3
	rotc 1,(4)
	popj 17,

rotcr_one_minus_reg:
	rotc 1,-1(3)
	popj 17,

rotcl_mem_count:
	rotc 1,@(3)
	popj 17,

rotcr_mem_count:
	movn 4,(3)
	rotc 1,(4)
	popj 17,

rotcl_global_count:
	rotc 1,@rotc_count
	popj 17,

rotcr_global_count:
	movn 4,rotc_count
	rotc 1,(4)
	popj 17,

rotcl_array_count:
	andi 3,17
	rotc 1,@rotc_counts(3)
	popj 17,

rotcr_array_count:
	andi 3,17
	movn 4,rotc_counts(3)
	rotc 1,(4)
	popj 17,

rotcl_mem_value:
	move 4,(1)
	move 5,1(1)
	rotc 4,(2)
	move 1,4
	move 2,5
	popj 17,

rotcr_mem_value:
	move 4,(1)
	move 5,1(1)
	movn 2,2
	rotc 4,(2)
	move 1,4
	move 2,5
	popj 17,

rotcl_mem_value_const:
	move 4,(1)
	move 5,1(1)
	rotc 4,1
	move 1,4
	move 2,5
	popj 17,

rotcr_mem_value_const:
	move 4,(1)
	move 5,1(1)
	rotc 4,-1
	move 1,4
	move 2,5
	popj 17,

rotcl_global_value:
	move 4,1
	move 1,rotc_ga
	move 2,rotc_ga+1
	rotc 1,(4)
	popj 17,

rotcr_global_value:
	move 4,1
	move 1,rotc_ga
	move 2,rotc_ga+1
	movn 4,4
	rotc 1,(4)
	popj 17,

rotcl_global_value_const:
	move 1,rotc_ga
	move 2,rotc_ga+1
	rotc 1,44
	popj 17,

rotcr_global_value_const:
	move 1,rotc_ga
	move 2,rotc_ga+1
	rotc 1,44
	popj 17,

rotcl_array_value:
	andi 1,17
	lsh 1,1
	move 4,rotc_buf(1)
	move 5,rotc_buf+1(1)
	rotc 4,(2)
	move 1,4
	move 2,5
	popj 17,

rotcr_array_value:
	andi 1,17
	lsh 1,1
	move 4,rotc_buf(1)
	move 5,rotc_buf+1(1)
	movn 2,2
	rotc 4,(2)
	move 1,4
	move 2,5
	popj 17,

rotcl_struct_a:
	move 4,(1)
	move 5,1(1)
	rotc 4,(2)
	move 1,4
	move 2,5
	popj 17,

rotcr_struct_a:
	move 4,(1)
	move 5,1(1)
	movn 2,2
	rotc 4,(2)
	move 1,4
	move 2,5
	popj 17,

rotcl_struct_b:
	move 4,2(1)
	move 5,3(1)
	rotc 4,(2)
	move 1,4
	move 2,5
	popj 17,

rotcr_struct_b:
	move 4,2(1)
	move 5,3(1)
	movn 2,2
	rotc 4,(2)
	move 1,4
	move 2,5
	popj 17,

rotcl_global_struct_a:
	move 4,rotc_gp
	move 5,rotc_gp+1
	rotc 4,(1)
	move 1,4
	move 2,5
	popj 17,

rotcr_global_struct_a:
	move 4,rotc_gp
	move 5,rotc_gp+1
	movn 1,1
	rotc 4,(1)
	move 1,4
	move 2,5
	popj 17,

rotcl_global_struct_b_const:
	move 1,rotc_gp+2
	move 2,rotc_gp+3
	rotc 1,22
	popj 17,

rotcr_global_struct_b_const:
	move 1,rotc_gp+2
	move 2,rotc_gp+3
	rotc 1,-22
	popj 17,

rotcl_store:
	rotc 2,(4)
	movem 2,(1)
	movem 3,1(1)
	popj 17,

rotcr_store:
	movn 4,4
	rotc 2,(4)
	movem 2,(1)
	movem 3,1(1)
	popj 17,

rotcl_store_const:
	rotc 2,44
	movem 2,(1)
	movem 3,1(1)
	popj 17,

rotcr_store_const:
	rotc 2,44
	movem 2,(1)
	movem 3,1(1)
	popj 17,

rotcl_store_global:
	rotc 1,(3)
	movem 1,rotc_ga
	movem 2,rotc_ga+1
	popj 17,

rotcr_store_global:
	movn 3,3
	rotc 1,(3)
	movem 1,rotc_gb
	movem 2,rotc_gb+1
	popj 17,

rotcl_store_return:
	rotc 2,(4)
	movem 2,(1)
	movem 3,1(1)
	move 6,(1)
	move 7,3
	move 1,6
	move 2,7
	popj 17,

rotcr_store_return:
	movn 4,4
	rotc 2,(4)
	movem 2,(1)
	movem 3,1(1)
	move 6,(1)
	move 7,3
	move 1,6
	move 2,7
	popj 17,

rotcl_update_mem:
	move 4,(1)
	move 5,1(1)
	rotc 4,(2)
	movem 4,(1)
	movem 5,1(1)
	popj 17,

rotcr_update_mem:
	move 4,(1)
	move 5,1(1)
	movn 2,2
	rotc 4,(2)
	movem 4,(1)
	movem 5,1(1)
	popj 17,

rotcl_update_mem_const:
	move 4,(1)
	move 5,1(1)
	rotc 4,1
	movem 4,(1)
	movem 5,1(1)
	popj 17,

rotcr_update_mem_const:
	move 4,(1)
	move 5,1(1)
	rotc 4,-1
	movem 4,(1)
	movem 5,1(1)
	popj 17,

rotcl_update_global:
	move 4,rotc_ga
	move 5,rotc_ga+1
	rotc 4,(1)
	movem 4,rotc_ga
	movem 5,rotc_ga+1
	popj 17,

rotcr_update_global:
	move 4,rotc_gb
	move 5,rotc_gb+1
	movn 1,1
	rotc 4,(1)
	movem 4,rotc_gb
	movem 5,rotc_gb+1
	popj 17,

rotcl_mix_add:
	add 17,[3,,3]
	move 0,-3(17)
	movem 0,-2(17)
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	movem 4,-3(17)
	move 6,-4(17)
	rotc 10,(3)
	move 2,11
	add 2,4
	move 4,2
	tlc 4,400000
	move 3,11
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 1,10
	add 1,6
	add 1,4
	move 10,-1(17)
	move 11,(17)
	move 0,-2(17)
	movem 0,-3(17)
	add 17,[-3,,-3]
	popj 17,

rotcr_mix_add:
	add 17,[3,,3]
	move 0,-3(17)
	movem 0,-2(17)
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	movem 4,-3(17)
	move 6,-4(17)
	movn 3,3
	rotc 10,(3)
	move 2,11
	add 2,4
	move 4,2
	tlc 4,400000
	move 3,11
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 1,10
	add 1,6
	add 1,4
	move 10,-1(17)
	move 11,(17)
	move 0,-2(17)
	movem 0,-3(17)
	add 17,[-3,,-3]
	popj 17,

rotcl_mix_xor:
	add 17,[1,,1]
	move 0,-1(17)
	movem 0,(17)
	movem 4,-1(17)
	move 6,-2(17)
	rotc 1,(3)
	xor 1,6
	xor 2,4
	move 0,(17)
	movem 0,-1(17)
	add 17,[-1,,-1]
	popj 17,

rotcr_mix_xor:
	add 17,[1,,1]
	move 0,-1(17)
	movem 0,(17)
	movem 4,-1(17)
	move 6,-2(17)
	movn 3,3
	rotc 1,(3)
	xor 1,6
	xor 2,4
	move 0,(17)
	movem 0,-1(17)
	add 17,[-1,,-1]
	popj 17,

rotcl_chain:
	rotc 1,(3)
	rotc 1,(4)
	popj 17,

rotcr_chain:
	movn 3,3
	rotc 1,(3)
	movn 4,4
	rotc 1,(4)
	popj 17,

rotcl_rotcr_chain:
	rotc 1,(3)
	movn 4,4
	rotc 1,(4)
	popj 17,

rotcr_rotcl_chain:
	movn 3,3
	rotc 1,(3)
	rotc 1,(4)
	popj 17,

rotcl_from_halves:
	move 4,2
	move 2,1
	movei 1,0
	lshc 1,44
	move 5,4
	movei 4,0
	ior 1,4
	ior 2,5
	rotc 1,(3)
	popj 17,

rotcr_from_halves:
	move 4,2
	move 2,1
	movei 1,0
	lshc 1,44
	move 5,4
	movei 4,0
	ior 1,4
	ior 2,5
	movn 3,3
	rotc 1,(3)
	popj 17,

rotcl_low_word:
	rotc 1,(3)
	move 1,2
	popj 17,

rotcr_low_word:
	movn 3,3
	rotc 1,(3)
	move 1,2
	popj 17,

rotcl_high_word:
	rotc 1,(3)
	lshc 1,-44
	move 1,2
	popj 17,

rotcr_high_word:
	movn 3,3
	rotc 1,(3)
	lshc 1,-44
	move 1,2
	popj 17,

	.bss
rotc_ga:
	.space	8
rotc_gb:
	.space	8
rotc_count:
	.space	4
rotc_counts:
	.space	64
rotc_buf:
	.space	128
rotc_gp:
	.space	16
