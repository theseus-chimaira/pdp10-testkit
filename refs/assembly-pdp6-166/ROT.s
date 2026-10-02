
rotl_const_1:
	rot 1,1
	popj 17,

rotl_const_2:
	rot 1,2
	popj 17,

rotl_const_8:
	rot 1,10
	popj 17,

rotl_const_9:
	rot 1,11
	popj 17,

rotl_const_17:
	rot 1,21
	popj 17,

rotl_const_18:
	movs 1,1
	popj 17,

rotl_const_19:
	rot 1,-21
	popj 17,

rotl_const_27:
	rot 1,-11
	popj 17,

rotl_const_35:
	rot 1,-1
	popj 17,

rotr_const_1:
	rot 1,-1
	popj 17,

rotr_const_2:
	rot 1,-2
	popj 17,

rotr_const_8:
	rot 1,-10
	popj 17,

rotr_const_9:
	rot 1,-11
	popj 17,

rotr_const_17:
	rot 1,-21
	popj 17,

rotr_const_18:
	movs 1,1
	popj 17,

rotr_const_19:
	rot 1,21
	popj 17,

rotr_const_27:
	rot 1,11
	popj 17,

rotr_const_35:
	rot 1,1
	popj 17,

rotl_reg:
	rot 1,(2)
	popj 17,

rotr_reg:
	movn 2,2
	rot 1,(2)
	popj 17,

rotl_reg_neg:
	movn 2,2
	rot 1,(2)
	popj 17,

rotr_reg_neg:
	rot 1,(2)
	popj 17,

rotl_reg_plus_1:
	rot 1,1(2)
	popj 17,

rotl_reg_plus_2:
	rot 1,2(2)
	popj 17,

rotl_reg_minus_1:
	rot 1,-1(2)
	popj 17,

rotl_one_plus_reg:
	rot 1,1(2)
	popj 17,

rotl_one_minus_reg:
	movei 4,1
	sub 4,2
	rot 1,(4)
	popj 17,

rotr_reg_plus_1:
	movei 4,43
	sub 4,2
	rot 1,(4)
	popj 17,

rotr_reg_plus_2:
	movei 4,42
	sub 4,2
	rot 1,(4)
	popj 17,

rotr_reg_minus_1:
	movei 4,45
	sub 4,2
	rot 1,(4)
	popj 17,

rotr_one_plus_reg:
	movei 4,43
	sub 4,2
	rot 1,(4)
	popj 17,

rotr_one_minus_reg:
	rot 1,-1(2)
	popj 17,

rotl_mem_count:
	rot 1,@(2)
	popj 17,

rotr_mem_count:
	movn 4,(2)
	rot 1,(4)
	popj 17,

rotl_global_count:
	rot 1,@rot_count
	popj 17,

rotr_global_count:
	movn 4,rot_count
	rot 1,(4)
	popj 17,

rotl_array_count:
	andi 2,17
	rot 1,@rot_counts(2)
	popj 17,

rotr_array_count:
	andi 2,17
	movn 4,rot_counts(2)
	rot 1,(4)
	popj 17,

rotl_mem_value:
	move 1,(1)
	rot 1,(2)
	popj 17,

rotr_mem_value:
	move 1,(1)
	movn 2,2
	rot 1,(2)
	popj 17,

rotl_mem_value_const:
	move 1,(1)
	rot 1,1
	popj 17,

rotr_mem_value_const:
	move 1,(1)
	rot 1,-1
	popj 17,

rotl_global_value:
	move 4,1
	move 1,rot_ga
	rot 1,(4)
	popj 17,

rotr_global_value:
	move 4,rot_ga
	movn 1,1
	rot 4,(1)
	move 1,4
	popj 17,

rotl_global_value_const:
	movs 1,rot_ga
	popj 17,

rotr_global_value_const:
	movs 1,rot_ga
	popj 17,

rotl_array_value:
	andi 1,17
	move 1,rot_buf(1)
	rot 1,(2)
	popj 17,

rotr_array_value:
	andi 1,17
	move 1,rot_buf(1)
	movn 2,2
	rot 1,(2)
	popj 17,

rotl_struct_a:
	move 1,(1)
	rot 1,(2)
	popj 17,

rotr_struct_a:
	move 1,(1)
	movn 2,2
	rot 1,(2)
	popj 17,

rotl_struct_b:
	move 1,1(1)
	rot 1,(2)
	popj 17,

rotr_struct_b:
	move 1,1(1)
	movn 2,2
	rot 1,(2)
	popj 17,

rotl_global_struct_a:
	move 4,1
	move 1,rot_gp
	rot 1,(4)
	popj 17,

rotr_global_struct_a:
	move 4,rot_gp
	movn 1,1
	rot 4,(1)
	move 1,4
	popj 17,

rotl_global_struct_b_const:
	move 1,rot_gp+1
	rot 1,11
	popj 17,

rotr_global_struct_b_const:
	move 1,rot_gp+1
	rot 1,-11
	popj 17,

rotl_store:
	rot 2,(3)
	movem 2,(1)
	popj 17,

rotr_store:
	movn 3,3
	rot 2,(3)
	movem 2,(1)
	popj 17,

rotl_store_const:
	movsm 2,(1)
	popj 17,

rotr_store_const:
	movsm 2,(1)
	popj 17,

rotl_store_global:
	rot 1,(2)
	movem 1,rot_ga
	popj 17,

rotr_store_global:
	movn 2,2
	rot 1,(2)
	movem 1,rot_gb
	popj 17,

rotl_store_return:
	rot 2,(3)
	movem 2,(1)
	move 1,2
	popj 17,

rotr_store_return:
	movn 3,3
	rot 2,(3)
	movem 2,(1)
	move 1,2
	popj 17,

rotl_update_mem:
	move 4,(1)
	rot 4,(2)
	movem 4,(1)
	popj 17,

rotr_update_mem:
	move 4,(1)
	movn 2,2
	rot 4,(2)
	movem 4,(1)
	popj 17,

rotl_update_mem_const:
	move 4,(1)
	rot 4,1
	movem 4,(1)
	popj 17,

rotr_update_mem_const:
	move 4,(1)
	rot 4,-1
	movem 4,(1)
	popj 17,

rotl_update_global:
	move 4,rot_ga
	rot 4,(1)
	movem 4,rot_ga
	popj 17,

rotr_update_global:
	move 4,rot_gb
	movn 1,1
	rot 4,(1)
	movem 4,rot_gb
	popj 17,

rotl_mix_add:
	rot 1,(2)
	add 1,3
	popj 17,

rotr_mix_add:
	movn 2,2
	rot 1,(2)
	add 1,3
	popj 17,

rotl_mix_xor:
	rot 1,(2)
	xor 1,3
	popj 17,

rotr_mix_xor:
	movn 2,2
	rot 1,(2)
	xor 1,3
	popj 17,

rotl_chain:
	rot 1,(2)
	rot 1,(3)
	popj 17,

rotr_chain:
	movn 2,2
	rot 1,(2)
	movn 3,3
	rot 1,(3)
	popj 17,

rotl_rotr_chain:
	rot 1,(2)
	movn 3,3
	rot 1,(3)
	popj 17,

rotr_rotl_chain:
	movn 2,2
	rot 1,(2)
	rot 1,(3)
	popj 17,

rotl_small_type:
	hrrzi 1,(1)	; zero_extendhisi2
	rot 1,(2)
	popj 17,

rotr_small_type:
	hrrzi 1,(1)	; zero_extendhisi2
	movn 2,2
	rot 1,(2)
	popj 17,

rotl_byte_type:
	andi 1,777	; zero_extendqisi2
	rot 1,(2)
	popj 17,

rotr_byte_type:
	andi 1,777	; zero_extendqisi2
	movn 2,2
	rot 1,(2)
	popj 17,

	.bss
rot_ga:
	.space	4
rot_gb:
	.space	4
rot_count:
	.space	4
rot_counts:
	.space	64
rot_buf:
	.space	64
rot_gp:
	.space	8
