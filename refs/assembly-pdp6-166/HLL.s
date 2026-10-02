
hll_reg_reg:
	hll 1,2
	popj 17,

hll_sreg_sreg:
	hll 1,2
	popj 17,

hll_reg_mem:
	hll 1,(2)
	popj 17,

hll_sreg_mem:
	hll 1,(2)
	popj 17,

hll_reg_mem_right_preserve:
	hrrz 4,1
	hll 1,(2)
	hrrz 1,4
	popj 17,

hll_from_global_array:
	hll 1,A+1
	popj 17,

hll_from_signed_global_array:
	hll 1,B+1
	popj 17,

hll_from_global_struct:
	hll 1,C
	popj 17,

hll_from_signed_global_struct:
	hll 1,D
	popj 17,

hll_from_indexed_array:
	andi 2,7
	move 4,[POINT 18,A,17]
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	hll 1,(4)
	popj 17,

hll_from_signed_indexed_array:
	andi 2,7
	move 4,[POINT 18,B,17]
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	hll 1,(4)
	popj 17,

hll_from_pointer_index:
	move 4,3
	andi 4,1
	andi 3,7
	ash 3,-1	; ashrsi3_pointer
	add 2,3
	jumpe 4,%L15
%L14:
	ibp 2
	sojn 4,%L14	; decrement_and_branch_until_zero
%L15:
	hll 1,(2)
	popj 17,

hll_from_signed_pointer_index:
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
	hll 1,(2)
	popj 17,

hlli_zero:
	hrrz 1,1
	popj 17,

hlli_one:
	movei 4,1
	hrlz 1,4
	popj 17,

hlli_small:
	movei 4,123456
	hrlz 1,4
	popj 17,

hlli_max:
	hrro 1,1
	popj 17,

hlli_signed_neg_one:
	hrro 1,1
	popj 17,

hlli_signed_small:
	movei 4,123456
	hrlz 1,4
	popj 17,

hll_from_word_shift:
	hll 1,(2)
	popj 17,

hll_from_word_lshr:
	hll 1,(2)
	popj 17,

hll_from_word_index:
	andi 3,7
	add 2,3
	hll 1,(2)
	popj 17,

hll_from_masked_word:
	hll 1,2
	popj 17,

hllz_mem:
	hllz 1,(1)
	popj 17,

hllz_reg:
	hllz 1,1
	popj 17,

hllz_global:
	hllz 1,GW+1
	popj 17,

hllz_index:
	andi 2,7
	add 1,2
	hllz 1,(1)
	popj 17,

hllz_struct:
	hllz 1,1(1)
	popj 17,

uhllz_mem:
	hllz 1,(1)
	popj 17,

uhllz_reg:
	hllz 1,1
	popj 17,

hllo_mem:
	hllo 1,(1)
	popj 17,

hllo_reg:
	hllo 1,1
	popj 17,

hllo_global:
	hllo 1,GW+2
	popj 17,

hllo_index:
	andi 2,7
	add 1,2
	hllo 1,(1)
	popj 17,

hllo_struct:
	hllo 1,2(1)
	popj 17,

uhllo_mem:
	hllo 1,(1)
	popj 17,

uhllo_reg:
	hllo 1,1
	popj 17,

hllm_reg_mem:
	hllm 1,(2)
	popj 17,

hllm_sreg_mem:
	hllm 1,(2)
	popj 17,

hllm_to_global:
	hllm 1,C
	popj 17,

hllm_to_signed_global:
	hllm 1,D
	popj 17,

hllm_to_array:
	hllm 1,A+1
	popj 17,

hllm_to_signed_array:
	hllm 1,B+1
	popj 17,

hllm_to_indexed_array:
	andi 2,7
	move 4,[POINT 18,A,17]
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	hllm 1,(4)
	popj 17,

hllm_to_signed_indexed_array:
	andi 2,7
	move 4,[POINT 18,B,17]
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	hllm 1,(4)
	popj 17,

hllm_to_pointer_index:
	move 4,3
	andi 4,1
	andi 3,7
	ash 3,-1	; ashrsi3_pointer
	add 2,3
	jumpe 4,%L58
%L57:
	ibp 2
	sojn 4,%L57	; decrement_and_branch_until_zero
%L58:
	hllm 1,(2)
	popj 17,

hllm_to_signed_pointer_index:
	move 4,3
	andi 4,1
	andi 3,7
	ash 3,-1	; ashrsi3_pointer
	add 2,3
	jumpe 4,%L62
%L61:
	ibp 2
	sojn 4,%L61	; decrement_and_branch_until_zero
%L62:
	hllm 1,(2)
	popj 17,

hllm_word_from_shift:
	hllm 2,(1)
	popj 17,

hllm_word_from_mem:
	move 2,(2)
	hllm 2,(1)
	popj 17,

hllm_word_from_reg:
	hllm 2,(1)
	popj 17,

hllm_word_return:
	hrrz 4,(1)
	hllz 2,2
	ior 4,2
	movem 4,(1)
	move 1,4
	popj 17,

hllm_word_global:
	hllm 1,GW
	popj 17,

hllm_word_index:
	andi 3,7
	add 1,3
	hllm 2,(1)
	popj 17,

hllm_word_struct:
	hllm 2,1(1)
	popj 17,

hlls_word:
	hrrz 4,(1)
	hllz 2,2
	ior 4,2
	movem 4,(1)
	move 1,4
	popj 17,

hlls_word_mem:
	move 3,1
	hrrz 1,(1)
	hllz 4,(2)
	ior 1,4
	movem 1,(3)
	popj 17,

hlls_word_index:
	move 4,1
	andi 3,7
	add 4,3
	hrrz 1,(4)
	hllz 2,2
	ior 1,2
	movem 1,(4)
	popj 17,

hll_chain:
	move 1,(3)
	popj 17,

hll_signed_chain:
	move 1,(3)
	popj 17,

hllz_then_add:
	hllz 1,(1)
	add 1,2
	popj 17,

hllo_then_xor:
	hllo 1,(1)
	xor 1,2
	popj 17,

hll_call_pressure:
	push 17,10
	move 10,2
	hllm 1,(2)
	pushj 17,clobber
	hlrz 4,(10)
	hrlm 4,C
	pop 17,10
	popj 17,

hll_word_call_pressure:
	push 17,10
	move 10,1
	hllm 2,(1)
	pushj 17,clobber
	hllz 1,(10)
	pop 17,10
	popj 17,

hll_volatile_load:
	move 1,(1)
	hllz 1,1
	popj 17,

hll_volatile_store:
	move 4,(1)
	hllz 2,2
	iori 2,(4)
	movem 2,(1)
	popj 17,

hll_volatile_half_load:
	hlrz 4,(2)
	hrlz 1,4
	popj 17,

hll_volatile_half_store:
	hlrz 1,1
	hrlm 1,(2)
	popj 17,

hll_nested_struct_load:
	hll 1,2(2)
	popj 17,

hll_nested_struct_store:
	hllm 1,(2)
	popj 17,

hll_nested_word_load:
	hllz 1,1(1)
	popj 17,

hll_nested_word_store:
	hllm 2,3(1)
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
