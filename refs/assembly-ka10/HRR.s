
hrr_reg_reg:
	hrr 1,2
	popj 17,

hrr_sreg_sreg:
	hrr 1,2
	popj 17,

hrr_reg_mem:
	hrr 1,(2)
	popj 17,

hrr_sreg_mem:
	hrr 1,(2)
	popj 17,

hrr_preserve_left:
	hlrz 4,1
	hrr 1,(2)
	hrlz 1,4
	popj 17,

hrr_from_global_array:
	hrr 1,A+1
	popj 17,

hrr_from_signed_global_array:
	hrr 1,B+1
	popj 17,

hrr_from_global_struct:
	hrr 1,C
	popj 17,

hrr_from_signed_global_struct:
	hrr 1,D
	popj 17,

hrr_from_indexed_array:
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

hrr_from_signed_indexed_array:
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

hrr_from_pointer_index:
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

hrr_from_signed_pointer_index:
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

hrr_nested_struct_load:
	hrr 1,2(2)
	popj 17,

hrr_nested_signed_struct_load:
	hrr 1,3(2)
	popj 17,

hrri_zero:
	hllz 1,1
	popj 17,

hrri_one:
	movei 4,1
	hrrz 1,4
	popj 17,

hrri_small:
	movei 4,123456
	hrrz 1,4
	popj 17,

hrri_max:
	hllo 1,1
	popj 17,

hrri_signed_neg_one:
	hllo 1,1
	popj 17,

hrri_signed_small:
	movei 4,123456
	hrrz 1,4
	popj 17,

hrri_from_global_address:
	move 4,[POINT 18,A,17]
	hrrz 1,4
	popj 17,

hrri_from_struct_address:
	movei 4,GW+1
	hrrz 1,4
	popj 17,

hrrz_mem:
	hrrz 1,(1)
	popj 17,

hrrz_global_array:
	hrrz 1,A+1
	popj 17,

hrrz_global_struct:
	hrrz 1,C
	popj 17,

hrrz_word_mem:
	hrrz 1,(1)
	popj 17,

hrrz_word_reg:
	hrrz 1,1
	popj 17,

hrrz_word_global:
	hrrz 1,GW+1
	popj 17,

hrrz_word_index:
	andi 2,7
	add 1,2
	hrrz 1,(1)
	popj 17,

hrrz_word_struct:
	hrrz 1,1(1)
	popj 17,

hrrz_add:
	hrrz 1,(1)
	add 1,2
	popj 17,

hrrz_xor:
	hrrz 1,(1)
	xor 1,2
	popj 17,

hrre_mem:
	hrre 1,(1)
	popj 17,

hrre_global_array:
	hrre 1,B+1
	popj 17,

hrre_global_struct:
	hrre 1,D
	popj 17,

hrre_word_mem:
	move 4,(1)
	hrrz 3,4
	hrro 1,3
	trnn 4,400000
	move 1,3
	popj 17,

hrre_word_reg:
	hrrz 3,1
	hrro 4,3
	trnn 1,400000
	move 4,3
	move 1,4
	popj 17,

hrre_word_global:
	move 4,GW+2
	hrrz 3,4
	hrro 1,3
	trnn 4,400000
	move 1,3
	popj 17,

hrre_word_index:
	andi 2,7
	add 1,2
	move 4,(1)
	hrrz 3,4
	hrro 1,3
	trnn 4,400000
	move 1,3
	popj 17,

hrre_word_struct:
	move 4,2(1)
	hrrz 3,4
	hrro 1,3
	trnn 4,400000
	move 1,3
	popj 17,

hrre_add:
	move 4,(1)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	add 1,2
	popj 17,

hrro_mem:
	hrro 1,(1)
	popj 17,

hrro_reg:
	hrro 1,1
	popj 17,

hrro_global:
	hrro 1,GW
	popj 17,

hrro_index:
	andi 2,7
	add 1,2
	hrro 1,(1)
	popj 17,

hrroi_zero:
	movsi 1,777777
	popj 17,

hrroi_one:
	hrroi 1,1
	popj 17,

hrroi_small:
	hrroi 1,123456
	popj 17,

hrroi_max:
	seto 1,
	popj 17,

hrrm_reg_mem:
	hrrm 1,(2)
	popj 17,

hrrm_sreg_mem:
	hrrm 1,(2)
	popj 17,

hrrm_to_global:
	hrrm 1,C
	popj 17,

hrrm_to_signed_global:
	hrrm 1,D
	popj 17,

hrrm_to_array:
	hrrm 1,A+1
	popj 17,

hrrm_to_signed_array:
	hrrm 1,B+1
	popj 17,

hrrm_to_indexed_array:
	move 4,2
	andi 4,1
	andi 2,7
	ash 2,-1	; ashrsi3_pointer
	add 2,[POINT 18,A,17]
	jumpe 4,%L90
%L89:
	ibp 2
	sojn 4,%L89	; decrement_and_branch_until_zero
%L90:
	dpb 1,2	; movhi
	popj 17,

hrrm_to_signed_indexed_array:
	move 4,2
	andi 4,1
	andi 2,7
	ash 2,-1	; ashrsi3_pointer
	add 2,[POINT 18,B,17]
	jumpe 4,%L93
%L92:
	ibp 2
	sojn 4,%L92	; decrement_and_branch_until_zero
%L93:
	dpb 1,2	; movhi
	popj 17,

hrrm_to_pointer_index:
	move 4,3
	andi 4,1
	andi 3,7
	ash 3,-1	; ashrsi3_pointer
	add 2,3
	jumpe 4,%L97
%L96:
	ibp 2
	sojn 4,%L96	; decrement_and_branch_until_zero
%L97:
	dpb 1,2	; movhi
	popj 17,

hrrm_to_signed_pointer_index:
	move 4,3
	andi 4,1
	andi 3,7
	ash 3,-1	; ashrsi3_pointer
	add 2,3
	jumpe 4,%L101
%L100:
	ibp 2
	sojn 4,%L100	; decrement_and_branch_until_zero
%L101:
	dpb 1,2	; movhi
	popj 17,

hrrm_word_from_reg:
	hrrm 2,(1)
	popj 17,

hrrm_word_from_mem:
	move 2,(2)
	hrrm 2,(1)
	popj 17,

hrrm_word_return:
	move 4,1
	hllz 1,(1)
	iori 1,(2)
	movem 1,(4)
	popj 17,

hrrm_word_global:
	hrrm 1,GW
	popj 17,

hrrm_word_global_mem:
	move 1,(1)
	hrrm 1,GW+1
	popj 17,

hrrm_word_index:
	andi 3,7
	add 1,3
	hrrm 2,(1)
	popj 17,

hrrm_word_struct:
	hrrm 2,1(1)
	popj 17,

hrrm_nested_struct_store:
	hrrm 1,(2)
	popj 17,

hrrm_nested_signed_struct_store:
	hrrm 1,1(2)
	popj 17,

hrrzm_word:
	hrrzm 2,(1)
	popj 17,

hrrzm_word_from_word:
	hrrzm 2,(1)
	popj 17,

hrrzm_word_global:
	hrrzm 1,GW
	popj 17,

hrrzm_word_index:
	andi 3,7
	add 1,3
	hrrzm 2,(1)
	popj 17,

hrrem_word:
	hrre 2,2
	movem 2,(1)
	popj 17,

hrrem_word_from_word:
	hrrz 4,2
	trne 2,400000
	hrro 4,4
	movem 4,(1)
	popj 17,

hrrem_word_global:
	hrre 1,1
	movem 1,GW+1
	popj 17,

hrrem_word_index:
	andi 3,7
	add 1,3
	hrre 2,2
	movem 2,(1)
	popj 17,

hrrom_word:
	hrrom 2,(1)
	popj 17,

hrrom_word_global:
	hrrom 1,GW+2
	popj 17,

hrrom_word_index:
	andi 3,7
	add 1,3
	hrrom 2,(1)
	popj 17,

hrr_chain:
	move 1,(3)
	popj 17,

hrr_signed_chain:
	move 1,(3)
	popj 17,

hrr_call_pressure:
	push 17,10
	move 10,2
	hrrm 1,(2)
	pushj 17,clobber
	move 10,(10)
	hrrm 10,C
	pop 17,10
	popj 17,

hrr_word_call_pressure:
	push 17,10
	move 10,1
	hrrm 2,(1)
	pushj 17,clobber
	hrrz 1,(10)
	pop 17,10
	popj 17,

hrr_volatile_load:
	move 1,(1)
	hrrz 1,1
	popj 17,

hrre_volatile_load:
	move 4,(1)
	hrrz 3,4
	move 4,(1)
	hrro 1,3
	trnn 4,400000
	move 1,3
	popj 17,

hrr_volatile_store:
	move 4,(1)
	hllz 4,4
	iori 4,(2)
	movem 4,(1)
	popj 17,

hrr_volatile_array_store:
	andi 1,7
	move 4,VWA(1)
	hllz 4,4
	iori 4,(2)
	movem 4,VWA(1)
	popj 17,

hrr_volatile_half_load:
	hrrz 4,(2)
	hrrz 1,4
	popj 17,

hrr_volatile_half_store:
	hrrz 1,1
	hrrm 1,(2)
	popj 17,

hrr_nested_word_load:
	hrrz 1,2(1)
	popj 17,

hrr_nested_word_store:
	hrrm 2,3(1)
	popj 17,

hrr_global_mix:
	move 6,1
	andi 6,7
	move 4,1
	andi 4,1
	move 3,6
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,A,17]
	jumpe 4,%L144
%L143:
	ibp 3
	sojn 4,%L143	; decrement_and_branch_until_zero
%L144:
	ldb 3,3
	hrrm 3,C
	hrrm 2,D
	addi 1,1
	andi 1,7
	move 7,UWA(6)
	hrrzm 7,UWA(1)
	move 4,WA(6)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	hrrz 4,C
	add 1,4
	hrre 4,D
	add 1,4
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
UWA:
	.space	32
VWA:
	.space	32
GW:
	.space	12
GH:
	.space	16
