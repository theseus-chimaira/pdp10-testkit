
hrl_reg_reg:
	hrl 1,2
	popj 17,

hrl_sreg_sreg:
	hrl 1,2
	popj 17,

hrl_reg_mem:
	hrl 1,(2)
	popj 17,

hrl_sreg_mem:
	hrl 1,(2)
	popj 17,

hrl_preserve_right:
	hrrz 4,1
	hrl 1,(2)
	hrrz 1,4
	popj 17,

hrl_from_global_array:
	hrl 1,A+1
	popj 17,

hrl_from_signed_global_array:
	hrl 1,B+1
	popj 17,

hrl_from_global_struct:
	hrl 1,C
	popj 17,

hrl_from_signed_global_struct:
	hrl 1,D
	popj 17,

hrl_from_indexed_array:
	andi 2,7
	move 4,[POINT 18,A,17]
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	hll 1,(4)
	popj 17,

hrl_from_signed_indexed_array:
	andi 2,7
	move 4,[POINT 18,B,17]
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	hll 1,(4)
	popj 17,

hrl_from_pointer_index:
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

hrl_from_signed_pointer_index:
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

hrli_zero:
	hrrz 1,1
	popj 17,

hrli_one:
	movei 4,1
	hrlz 1,4
	popj 17,

hrli_small:
	movei 4,123456
	hrlz 1,4
	popj 17,

hrli_max:
	hrro 1,1
	popj 17,

hrli_signed_neg_one:
	hrro 1,1
	popj 17,

hrli_signed_small:
	movei 4,123456
	hrlz 1,4
	popj 17,

hrloi_small:
	hrloi 1,123456
	popj 17,

hrloi_zero:
	movei 1,777777
	popj 17,

hrloi_max:
	seto 1,
	popj 17,

hrl_from_word_right:
	hrl 1,(2)
	popj 17,

hrl_from_signed_word_right:
	hrl 1,(2)
	popj 17,

hrl_from_word_index:
	andi 3,7
	add 2,3
	hrl 1,(2)
	popj 17,

hrl_from_signed_word_index:
	andi 3,7
	add 2,3
	hrl 1,(2)
	popj 17,

hrl_from_masked_word:
	hrlz 1,2
	popj 17,

hrlz_mem:
	hrlz 1,(1)
	popj 17,

hrlz_reg:
	hrlz 1,1
	popj 17,

hrlz_masked_reg:
	hrlz 1,1
	popj 17,

hrlz_global:
	hrlz 1,GW+1
	popj 17,

hrlz_index:
	andi 2,7
	add 1,2
	hrlz 1,(1)
	popj 17,

hrlz_struct:
	hrlz 1,1(1)
	popj 17,

uhrlz_mem:
	hrlz 1,(1)
	popj 17,

uhrlz_reg:
	hrlz 1,1
	popj 17,

uhrlz_masked_reg:
	hrlz 1,1
	popj 17,

hrlo_mem:
	hrlo 1,(1)
	popj 17,

hrlo_reg:
	hrlo 1,1
	popj 17,

hrlo_masked_reg:
	hrlo 1,1
	popj 17,

hrlo_global:
	hrlo 1,GW+2
	popj 17,

hrlo_index:
	andi 2,7
	add 1,2
	hrlo 1,(1)
	popj 17,

hrlo_struct:
	hrlo 1,2(1)
	popj 17,

uhrlo_mem:
	hrlo 1,(1)
	popj 17,

uhrlo_reg:
	hrlo 1,1
	popj 17,

hrle_mem:
	ldb 4,1
	hrre 4,4
	hrlz 1,4
	jumpl 4,%L57
%L56:
	popj 17,
%L57:
	hllo 1,1
	popj 17,

hrle_reg:
	hrre 1,1
	hrlz 4,1
	jumpl 1,%L60
%L59:
	move 1,4
	popj 17,
%L60:
	hllo 4,4
	jrst %L59

hrle_word_mem:
	hrre 4,(1)
	hrlz 1,4
	jumpl 4,%L63
%L62:
	popj 17,
%L63:
	hllo 1,1
	popj 17,

hrle_word_reg:
	hrre 1,1
	hrlz 4,1
	jumpl 1,%L66
%L65:
	move 1,4
	popj 17,
%L66:
	hllo 4,4
	jrst %L65

hrlm_reg_mem:
	hrlm 1,(2)
	popj 17,

hrlm_sreg_mem:
	hrlm 1,(2)
	popj 17,

hrlm_to_global:
	hrlm 1,C
	popj 17,

hrlm_to_signed_global:
	hrlm 1,D
	popj 17,

hrlm_to_array:
	hrlm 1,A+1
	popj 17,

hrlm_to_signed_array:
	hrlm 1,B+1
	popj 17,

hrlm_to_indexed_array:
	andi 2,7
	move 4,[POINT 18,A,17]
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 1,4	; movhi
	popj 17,

hrlm_to_signed_indexed_array:
	andi 2,7
	move 4,[POINT 18,B,17]
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 1,4	; movhi
	popj 17,

hrlm_to_pointer_index:
	move 4,3
	andi 4,1
	andi 3,7
	ash 3,-1	; ashrsi3_pointer
	add 2,3
	jumpe 4,%L78
%L77:
	ibp 2
	sojn 4,%L77	; decrement_and_branch_until_zero
%L78:
	dpb 1,2	; movhi
	popj 17,

hrlm_to_signed_pointer_index:
	move 4,3
	andi 4,1
	andi 3,7
	ash 3,-1	; ashrsi3_pointer
	add 2,3
	jumpe 4,%L82
%L81:
	ibp 2
	sojn 4,%L81	; decrement_and_branch_until_zero
%L82:
	dpb 1,2	; movhi
	popj 17,

hrlm_word_from_reg:
	hrlm 2,(1)
	popj 17,

hrlm_word_from_mem:
	move 2,(2)
	hrlm 2,(1)
	popj 17,

hrlm_word_return:
	move 4,1
	hrrz 1,(1)
	tlo 1,(2)
	movem 1,(4)
	popj 17,

hrlm_word_global:
	hrlm 1,GW
	popj 17,

hrlm_word_index:
	andi 3,7
	add 1,3
	hrlm 2,(1)
	popj 17,

hrlm_word_struct:
	hrlm 2,1(1)
	popj 17,

hrlzm_word:
	hrlzm 2,(1)
	popj 17,

hrlzm_word_from_word:
	hrlzm 2,(1)
	popj 17,

hrlzm_word_global:
	hrlzm 1,GW
	popj 17,

hrlzm_word_index:
	andi 3,7
	add 1,3
	hrlzm 2,(1)
	popj 17,

hrlom_word:
	hrlo 2,2
	movem 2,(1)
	popj 17,

hrlom_word_from_word:
	hrlo 2,2
	movem 2,(1)
	popj 17,

hrlom_word_global:
	hrlo 1,1
	movem 1,GW+1
	popj 17,

hrlom_word_index:
	andi 3,7
	add 1,3
	hrlo 2,2
	movem 2,(1)
	popj 17,

hrlem_word:
	hrlz 4,2
	trne 2,400000
	jrst %L103
%L102:
	movem 4,(1)
	popj 17,
%L103:
	hllo 4,4
	jrst %L102

hrlem_word_from_half:
	hrre 2,2
	hrlz 4,2
	jumpl 2,%L106
%L105:
	movem 4,(1)
	popj 17,
%L106:
	hllo 4,4
	jrst %L105

hrlem_word_global:
	hrlz 4,1
	trne 1,400000
	jrst %L109
%L108:
	movem 4,GW+2
	popj 17,
%L109:
	hllo 4,4
	jrst %L108

hrls_word:
	move 4,1
	hrrz 1,(1)
	tlo 1,(2)
	movem 1,(4)
	popj 17,

hrls_word_mem:
	move 3,1
	hrrz 1,(1)
	hrlz 4,(2)
	ior 1,4
	movem 1,(3)
	popj 17,

hrls_word_index:
	move 4,1
	andi 3,7
	add 4,3
	hrrz 1,(4)
	tlo 1,(2)
	movem 1,(4)
	popj 17,

hrl_chain:
	movs 1,(3)
	popj 17,

hrl_signed_chain:
	movs 1,(3)
	popj 17,

hrlz_then_add:
	hrlz 1,(1)
	add 1,2
	popj 17,

hrlo_then_xor:
	hrlo 1,(1)
	xor 1,2
	popj 17,

hrl_call_pressure:
	push 17,10
	move 10,2
	hrlm 1,(2)
	pushj 17,clobber
	hlrz 4,(10)
	hrlm 4,C
	pop 17,10
	popj 17,

hrl_word_call_pressure:
	push 17,10
	move 10,1
	hrlm 2,(1)
	pushj 17,clobber
	hllz 1,(10)
	pop 17,10
	popj 17,

hrl_volatile_load:
	move 1,(1)
	hrlz 1,1
	popj 17,

hrl_volatile_store:
	move 4,(1)
	hrlz 2,2
	iori 2,(4)
	movem 2,(1)
	popj 17,

hrl_volatile_half_load:
	hrrz 4,(2)
	hrlz 1,4
	popj 17,

hrl_volatile_half_store:
	hrrz 1,1
	hrlm 1,(2)
	popj 17,

hrl_nested_struct_load:
	hrl 1,2(2)
	popj 17,

hrl_nested_struct_store:
	hrlm 1,(2)
	popj 17,

hrl_nested_word_load:
	hrlz 1,2(1)
	popj 17,

hrl_nested_word_store:
	hrlm 2,3(1)
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
