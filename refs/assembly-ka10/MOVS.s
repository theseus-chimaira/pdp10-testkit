
movs_reg_reg:
	movs 2,2
	move 1,2
	popj 17,

movs_reg_self:
	movs 1,1
	popj 17,

movs_mem:
	movs 1,(1)
	popj 17,

movs_mem_plus:
	movs 1,(1)
	add 1,2
	popj 17,

movs_mem_xor:
	movs 1,(1)
	xor 1,2
	popj 17,

movs_global_a:
	movs 1,movs_ga
	popj 17,

movs_global_b:
	movs 1,movs_gb
	popj 17,

movs_array:
	andi 2,17
	add 1,2
	movs 1,(1)
	popj 17,

movs_global_array:
	andi 1,17
	movs 1,movs_buf(1)
	popj 17,

movs_struct_a:
	movs 1,(1)
	popj 17,

movs_struct_b:
	movs 1,1(1)
	popj 17,

movs_global_struct_a:
	movs 1,movs_gp
	popj 17,

movs_global_struct_b:
	movs 1,movs_gp+1
	popj 17,

movs_indirect:
	movs 1,@(1)
	popj 17,

movsi_zero:
	movei 1,0
	popj 17,

movsi_one:
	movsi 1,1
	popj 17,

movsi_small:
	movsi 1,123456
	popj 17,

movsi_max18:
	movsi 1,777777
	popj 17,

movsi_pattern:
	movsi 1,123456
	popj 17,

movsi_address_global:
	movei 1,movs_ga
	hrlz 1,1
	popj 17,

movsi_address_array:
	movei 1,movs_buf+3
	hrlz 1,1
	popj 17,

movsm_reg_mem:
	movsm 1,(2)
	popj 17,

movsm_reg_global:
	movsm 1,movs_ga
	popj 17,

movsm_reg_array:
	andi 3,17
	add 2,3
	movsm 1,(2)
	popj 17,

movsm_reg_struct_a:
	movsm 1,(2)
	popj 17,

movsm_reg_struct_b:
	movsm 1,1(2)
	popj 17,

movsm_return_original:
	movsm 1,(2)
	popj 17,

movsm_return_swapped:
	movs 1,1
	movem 1,(2)
	popj 17,

movsm_mem_to_mem:
	move 2,(2)
	movsm 2,(1)
	popj 17,

movss_mem:
	move 6,(1)
	movsm 6,(1)
	popj 17,

movss_mem_return:
	movs 4,(1)
	movem 4,(1)
	move 1,4
	popj 17,

movss_global_a:
	move 6,movs_ga
	movsm 6,movs_ga
	popj 17,

movss_global_b:
	move 6,movs_gb
	movsm 6,movs_gb
	popj 17,

movss_array:
	andi 2,17
	add 1,2
	move 6,(1)
	movsm 6,(1)
	popj 17,

movss_global_array:
	andi 1,17
	move 6,movs_buf(1)
	movsm 6,movs_buf(1)
	popj 17,

movss_struct_a:
	move 6,(1)
	movsm 6,(1)
	popj 17,

movss_struct_b:
	move 6,1(1)
	movsm 6,1(1)
	popj 17,

movss_struct_a_return:
	movs 4,(1)
	movem 4,(1)
	move 1,4
	popj 17,

	.bss
movs_ga:
	.space	4
movs_gb:
	.space	4
movs_buf:
	.space	64
movs_gp:
	.space	8
