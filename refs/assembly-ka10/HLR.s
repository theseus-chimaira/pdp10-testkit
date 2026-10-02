
hlr_reg_reg:
	hlr 1,2
	popj 17,

hlr_sreg_sreg:
	hlr 1,2
	popj 17,

hlr_reg_mem:
	hlr 1,(2)
	popj 17,

hlr_sreg_mem:
	hlr 1,(2)
	popj 17,

hlr_preserve_left:
	hlrz 4,1
	hlr 1,(2)
	hrlz 1,4
	popj 17,

hlr_from_global_array:
	hlr 1,A+1
	popj 17,

hlr_from_signed_global_array:
	hlr 1,B+1
	popj 17,

hlr_from_global_struct:
	hlr 1,C
	popj 17,

hlr_from_signed_global_struct:
	hlr 1,D
	popj 17,

hlr_from_indexed_array:
	move 4,2
	andi 4,1
	andi 2,7
	ash 2,-1	; ashrsi3_pointer
	add 2,[POINT 18,A,17]
	jumpe 4,%L12
%L11:
	ibp 2
	sojn 4,%L11	; decrement_and_branch_until_zero
%L12:
	hlr 1,(2)
	popj 17,

hlr_from_signed_indexed_array:
	move 4,2
	andi 4,1
	andi 2,7
	ash 2,-1	; ashrsi3_pointer
	add 2,[POINT 18,B,17]
	jumpe 4,%L15
%L14:
	ibp 2
	sojn 4,%L14	; decrement_and_branch_until_zero
%L15:
	hlr 1,(2)
	popj 17,

hlr_from_pointer_index:
	move 4,3
	andi 4,1
	andi 3,7
	ash 3,-1	; ashrsi3_pointer
	add 2,3
	jumpe 4,%L19
%L18:
	ibp 2
	sojn 4,%L18	; decrement_and_branch_until_zero
%L19:
	hlr 1,(2)
	popj 17,

hlr_from_signed_pointer_index:
	move 4,3
	andi 4,1
	andi 3,7
	ash 3,-1	; ashrsi3_pointer
	add 2,3
	jumpe 4,%L23
%L22:
	ibp 2
	sojn 4,%L22	; decrement_and_branch_until_zero
%L23:
	hlr 1,(2)
	popj 17,

hlri_zero:
	hllz 1,1
	popj 17,

hlri_one:
	movei 4,1
	hrrz 1,4
	popj 17,

hlri_small:
	movei 4,123456
	hrrz 1,4
	popj 17,

hlri_max:
	hllo 1,1
	popj 17,

hlri_signed_neg_one:
	hllo 1,1
	popj 17,

hlri_signed_small:
	movei 4,123456
	hrrz 1,4
	popj 17,

hlr_from_word_shift:
	hlr 1,(2)
	popj 17,

hlr_from_signed_word_shift:
	hlr 1,(2)
	popj 17,

hlr_from_word_index:
	andi 3,7
	add 2,3
	hlr 1,(2)
	popj 17,

hlr_from_signed_word_index:
	andi 3,7
	add 2,3
	hlr 1,(2)
	popj 17,

hlr_from_masked_word:
	hlr 1,2
	popj 17,

hlrz_mem:
	hlrz 1,(1)
	popj 17,

hlrz_global_array:
	hlrz 1,A+1
	popj 17,

hlrz_global_struct:
	hlrz 1,C
	popj 17,

hlrz_word_mem:
	hlrz 1,(1)
	popj 17,

hlrz_word_reg:
	hlrz 1,1
	popj 17,

hlrz_word_global:
	hlre 1,GW+1
	popj 17,

hlrz_word_index:
	andi 2,7
	add 1,2
	hlrz 1,(1)
	popj 17,

hlrz_word_struct:
	hlrz 1,1(1)
	popj 17,

hlre_mem:
	hlre 1,(1)
	popj 17,

hlre_global_array:
	hlre 1,B+1
	popj 17,

hlre_global_struct:
	hlre 1,D
	popj 17,

hlre_word_mem:
	hlre 1,(1)
	popj 17,

hlre_word_reg:
	hlre 1,1
	popj 17,

hlre_word_global:
	hlre 1,GW+2
	popj 17,

hlre_word_index:
	andi 2,7
	add 1,2
	hlre 1,(1)
	popj 17,

hlre_word_struct:
	hlre 1,2(1)
	popj 17,

hlro_mem:
	hlro 1,(1)
	popj 17,

hlro_reg:
	hlro 1,1
	popj 17,

hlro_global:
	hlre 1,GW
	hrro 1,1
	popj 17,

hlro_index:
	andi 2,7
	add 1,2
	hlro 1,(1)
	popj 17,

hlrm_reg_mem:
	hlrm 1,(2)
	popj 17,

hlrm_sreg_mem:
	hlrm 1,(2)
	popj 17,

hlrm_to_global:
	hlrm 1,C
	popj 17,

hlrm_to_signed_global:
	hlrm 1,D
	popj 17,

hlrm_to_array:
	hlrm 1,A+1
	popj 17,

hlrm_to_signed_array:
	hlrm 1,B+1
	popj 17,

hlrm_to_indexed_array:
	move 4,2
	andi 4,1
	andi 2,7
	ash 2,-1	; ashrsi3_pointer
	add 2,[POINT 18,A,17]
	jumpe 4,%L68
%L67:
	ibp 2
	sojn 4,%L67	; decrement_and_branch_until_zero
%L68:
	hllm 1,(2)
	popj 17,

hlrm_to_signed_indexed_array:
	move 4,2
	andi 4,1
	andi 2,7
	ash 2,-1	; ashrsi3_pointer
	add 2,[POINT 18,B,17]
	jumpe 4,%L71
%L70:
	ibp 2
	sojn 4,%L70	; decrement_and_branch_until_zero
%L71:
	hllm 1,(2)
	popj 17,

hlrm_to_pointer_index:
	move 4,3
	andi 4,1
	andi 3,7
	ash 3,-1	; ashrsi3_pointer
	add 2,3
	jumpe 4,%L75
%L74:
	ibp 2
	sojn 4,%L74	; decrement_and_branch_until_zero
%L75:
	hllm 1,(2)
	popj 17,

hlrm_to_signed_pointer_index:
	move 4,3
	andi 4,1
	andi 3,7
	ash 3,-1	; ashrsi3_pointer
	add 2,3
	jumpe 4,%L79
%L78:
	ibp 2
	sojn 4,%L78	; decrement_and_branch_until_zero
%L79:
	hllm 1,(2)
	popj 17,

hlrm_word_from_reg:
	hlrm 2,(1)
	popj 17,

hlrm_word_from_mem:
	move 2,(2)
	hlrm 2,(1)
	popj 17,

hlrm_word_return:
	hllz 4,(1)
	hlrz 2,2
	ior 4,2
	movem 4,(1)
	move 1,4
	popj 17,

hlrm_word_global:
	hlrm 1,GW
	popj 17,

hlrm_word_index:
	andi 3,7
	add 1,3
	hlrm 2,(1)
	popj 17,

hlrm_word_struct:
	hlrm 2,1(1)
	popj 17,

hlrzm_word:
	hrrzm 2,(1)
	popj 17,

hlrzm_word_from_word:
	hlrzm 2,(1)
	popj 17,

hlrzm_word_global:
	hrrzm 1,GW
	popj 17,

hlrzm_word_index:
	andi 3,7
	add 1,3
	hrrzm 2,(1)
	popj 17,

hlrem_word:
	hrre 2,2
	movem 2,(1)
	popj 17,

hlrem_word_from_word:
	hlrem 2,(1)
	popj 17,

hlrem_word_global:
	hrre 1,1
	movem 1,GW+1
	popj 17,

hlrem_word_index:
	andi 3,7
	add 1,3
	hrre 2,2
	movem 2,(1)
	popj 17,

hlrom_word:
	hlro 2,2
	movem 2,(1)
	popj 17,

hlrom_word_global:
	hlro 1,1
	movem 1,GW+2
	popj 17,

hlrs_word:
	hllz 4,(1)
	hlrz 2,2
	ior 4,2
	movem 4,(1)
	move 1,4
	popj 17,

hlrs_word_mem:
	move 3,1
	hllz 1,(1)
	hlrz 4,(2)
	ior 1,4
	movem 1,(3)
	popj 17,

hlrs_word_index:
	move 4,1
	andi 3,7
	add 4,3
	hllz 1,(4)
	hlrz 2,2
	ior 1,2
	movem 1,(4)
	popj 17,

hlr_chain:
	movs 1,(3)
	popj 17,

hlr_signed_chain:
	movs 1,(3)
	popj 17,

hlrz_then_add:
	hlrz 1,(1)
	add 1,2
	popj 17,

hlre_then_add:
	hlre 1,(1)
	add 1,2
	popj 17,

hlro_then_xor:
	hlro 1,(1)
	xor 1,2
	popj 17,

hlr_call_pressure:
	push 17,10
	move 10,2
	hlrm 1,(2)
	pushj 17,clobber
	move 10,(10)
	hrrm 10,C
	pop 17,10
	popj 17,

hlr_word_call_pressure:
	push 17,10
	move 10,1
	hlrm 2,(1)
	pushj 17,clobber
	hrrz 1,(10)
	pop 17,10
	popj 17,

hlr_volatile_load:
	move 1,(1)
	hlre 1,1
	popj 17,

hlr_volatile_store:
	move 4,(1)
	hllz 4,4
	hlrz 2,2
	ior 4,2
	movem 4,(1)
	popj 17,

hlr_volatile_half_load:
	hlrz 4,(2)
	hrrz 1,4
	popj 17,

hlr_volatile_half_store:
	hlrz 1,1
	hrrm 1,(2)
	popj 17,

hlr_nested_struct_load:
	hlr 1,2(2)
	popj 17,

hlr_nested_struct_store:
	hlrm 1,(2)
	popj 17,

hlr_nested_word_load:
	hlrz 1,2(1)
	popj 17,

hlr_nested_word_store:
	hlrm 2,3(1)
	popj 17,

	.bss
A:
	.space	16
B:
	.space	16
C:
	.space	4
D:
	.space	4
WA:
	.space	32
WB:
	.space	32
GW:
	.space	12
GH:
	.space	16
