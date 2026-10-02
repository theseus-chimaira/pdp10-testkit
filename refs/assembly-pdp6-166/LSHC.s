
lshcl_dint_0:
	popj 17,

lshcl_dint_1:
	lshc 1,1
	popj 17,

lshcl_dint_2:
	lshc 1,2
	popj 17,

lshcl_dint_3:
	lshc 1,3
	popj 17,

lshcl_dint_9:
	lshc 1,11
	popj 17,

lshcl_dint_18:
	lshc 1,22
	popj 17,

lshcl_dint_35:
	lshc 1,43
	popj 17,

lshcl_dint_36:
	lshc 1,44
	popj 17,

lshcl_dint_54:
	lshc 1,66
	popj 17,

lshcl_dint_70:
	lshc 1,106
	popj 17,

lshcl_udint_0:
	popj 17,

lshcl_udint_1:
	lshc 1,1
	popj 17,

lshcl_udint_2:
	lshc 1,2
	popj 17,

lshcl_udint_3:
	lshc 1,3
	popj 17,

lshcl_udint_9:
	lshc 1,11
	popj 17,

lshcl_udint_18:
	lshc 1,22
	popj 17,

lshcl_udint_35:
	lshc 1,43
	popj 17,

lshcl_udint_36:
	lshc 1,44
	popj 17,

lshcl_udint_54:
	lshc 1,66
	popj 17,

lshcl_udint_70:
	lshc 1,106
	popj 17,

lshcr_udint_0:
	popj 17,

lshcr_udint_1:
	lshc 1,-1
	popj 17,

lshcr_udint_2:
	lshc 1,-2
	popj 17,

lshcr_udint_3:
	lshc 1,-3
	popj 17,

lshcr_udint_9:
	lshc 1,-11
	popj 17,

lshcr_udint_18:
	lshc 1,-22
	popj 17,

lshcr_udint_35:
	lshc 1,-43
	popj 17,

lshcr_udint_36:
	lshc 1,-44
	popj 17,

lshcr_udint_54:
	lshc 1,-66
	popj 17,

lshcr_udint_70:
	lshc 1,-106
	popj 17,

lshcl_dint_var:
	lshc 1,(3)
	popj 17,

lshcl_udint_var:
	lshc 1,(3)
	popj 17,

lshcr_udint_var:
	movn 3,3
	lshc 1,(3)
	popj 17,

lshcl_dint_plus_1:
	addi 3,1
	lshc 1,(3)
	popj 17,

lshcl_udint_plus_1:
	addi 3,1
	lshc 1,(3)
	popj 17,

lshcr_udint_plus_1:
	addi 3,1
	movn 3,3
	lshc 1,(3)
	popj 17,

lshcl_dint_minus_count:
	movn 3,3
	lshc 1,(3)
	popj 17,

lshcl_udint_minus_count:
	movn 3,3
	lshc 1,(3)
	popj 17,

lshcr_udint_minus_count:
	movn 3,3
	movn 3,3
	lshc 1,(3)
	popj 17,

lshcl_udint_one_minus:
	movei 4,1
	sub 4,3
	move 3,4
	lshc 1,(3)
	popj 17,

lshcr_udint_one_minus:
	movei 4,1
	sub 4,3
	move 3,4
	movn 3,3
	lshc 1,(3)
	popj 17,

lshcl_dint_mem_count:
	move 4,(3)
	lshc 1,(4)
	popj 17,

lshcl_udint_mem_count:
	move 4,(3)
	lshc 1,(4)
	popj 17,

lshcr_udint_mem_count:
	move 4,(3)
	movn 4,4
	lshc 1,(4)
	popj 17,

lshcl_udint_volatile_count:
	move 4,(3)
	lshc 1,(4)
	popj 17,

lshcr_udint_volatile_count:
	move 4,(3)
	movn 4,4
	lshc 1,(4)
	popj 17,

lshcl_dint_masked_count:
	andi 3,177
	lshc 1,(3)
	popj 17,

lshcl_udint_masked_count:
	andi 3,177
	lshc 1,(3)
	popj 17,

lshcr_udint_masked_count:
	andi 3,177
	movn 3,3
	lshc 1,(3)
	popj 17,

lshcl_udint_low6_count:
	andi 3,77
	lshc 1,(3)
	popj 17,

lshcr_udint_low6_count:
	andi 3,77
	movn 3,3
	lshc 1,(3)
	popj 17,

lshcl_from_sint:
	move 4,1
	move 2,1
	ash 4,-43
	move 1,4
	lshc 1,22
	popj 17,

lshcr_from_sint:
	move 4,1
	move 2,1
	ash 4,-43
	move 1,4
	lshc 1,-22
	popj 17,

lshcl_from_usint:
	move 2,1
	movei 1,0
	lshc 1,44
	popj 17,

lshcr_from_usint:
	hlrz 1,1
	move 2,1
	movei 1,0
	popj 17,

lshcl_from_qi:
	move 4,1
	lsh 4,33
	ash 4,-33
	move 2,4
	ash 4,-43
	move 1,4
	lshc 1,11
	popj 17,

lshcl_from_uqi:
	move 2,1
	andi 2,777
	movei 1,0
	lshc 1,11
	popj 17,

lshcl_from_hi:
	hrre 4,1
	move 2,4
	ash 4,-43
	move 1,4
	lshc 1,22
	popj 17,

lshcl_from_uhi:
	hrrz 2,1
	movei 1,0
	lshc 1,22
	popj 17,

lshcr_array:
	andi 2,17
	lsh 2,1
	add 2,1
	move 4,(2)
	move 5,1(2)
	lshc 4,-11
	move 1,4
	move 2,5
	popj 17,

lshcl_array:
	andi 2,17
	lsh 2,1
	add 2,1
	move 4,(2)
	move 5,1(2)
	lshc 4,11
	move 1,4
	move 2,5
	popj 17,

lshcr_array_var:
	andi 2,17
	lsh 2,1
	add 2,1
	move 4,(2)
	move 5,1(2)
	movn 3,3
	lshc 4,(3)
	move 1,4
	move 2,5
	popj 17,

lshcl_array_var:
	andi 2,17
	lsh 2,1
	add 2,1
	move 4,(2)
	move 5,1(2)
	lshc 4,(3)
	move 1,4
	move 2,5
	popj 17,

lshcr_global:
	andi 1,17
	lsh 1,1
	move 4,lshc_buf(1)
	move 5,lshc_buf+1(1)
	lshc 4,-22
	move 1,4
	move 2,5
	popj 17,

lshcl_global:
	andi 1,17
	lsh 1,1
	move 4,lshc_buf(1)
	move 5,lshc_buf+1(1)
	lshc 4,22
	move 1,4
	move 2,5
	popj 17,

lshcr_struct:
	move 4,2(1)
	move 5,3(1)
	lshc 4,-44
	move 1,4
	move 2,5
	popj 17,

lshcl_struct:
	move 4,2(1)
	move 5,3(1)
	lshc 4,44
	move 1,4
	move 2,5
	popj 17,

lshcr_global_struct:
	move 1,lshc_gs+2
	move 2,lshc_gs+3
	lshc 1,-44
	popj 17,

lshcl_global_struct:
	move 1,lshc_gs+2
	move 2,lshc_gs+3
	lshc 1,44
	popj 17,

lshcl_store:
	lshc 2,11
	movem 2,(1)
	movem 3,1(1)
	popj 17,

lshcr_store:
	lshc 2,-11
	movem 2,(1)
	movem 3,1(1)
	popj 17,

lshcl_store_ret:
	lshc 2,22
	movem 2,(1)
	movem 3,1(1)
	move 4,(1)
	move 5,3
	move 1,4
	move 2,5
	popj 17,

lshcr_store_ret:
	lshc 2,-22
	movem 2,(1)
	movem 3,1(1)
	move 4,(1)
	move 5,3
	move 1,4
	move 2,5
	popj 17,

lshcl_store_var:
	lshc 2,(4)
	movem 2,(1)
	movem 3,1(1)
	popj 17,

lshcr_store_var:
	movn 4,4
	lshc 2,(4)
	movem 2,(1)
	movem 3,1(1)
	popj 17,

lshcl_compound:
	move 4,(1)
	move 5,1(1)
	lshc 4,1
	movem 4,(1)
	movem 5,1(1)
	popj 17,

lshcr_compound:
	move 4,(1)
	move 5,1(1)
	lshc 4,-1
	movem 4,(1)
	movem 5,1(1)
	popj 17,

lshcl_compound_18:
	move 4,(1)
	move 5,1(1)
	lshc 4,22
	movem 4,(1)
	movem 5,1(1)
	popj 17,

lshcr_compound_18:
	move 4,(1)
	move 5,1(1)
	lshc 4,-22
	movem 4,(1)
	movem 5,1(1)
	popj 17,

lshcl_compound_36:
	move 4,(1)
	move 5,1(1)
	lshc 4,44
	movem 4,(1)
	movem 5,1(1)
	popj 17,

lshcr_compound_36:
	move 4,(1)
	move 5,1(1)
	lshc 4,-44
	movem 4,(1)
	movem 5,1(1)
	popj 17,

lshcl_compound_var:
	move 4,(1)
	move 5,1(1)
	lshc 4,(2)
	movem 4,(1)
	movem 5,1(1)
	popj 17,

lshcr_compound_var:
	move 4,(1)
	move 5,1(1)
	movn 2,2
	lshc 4,(2)
	movem 4,(1)
	movem 5,1(1)
	popj 17,

lshcl_compound_global:
	move 4,lshc_sink
	move 5,lshc_sink+1
	lshc 4,1
	movem 4,lshc_sink
	movem 5,lshc_sink+1
	popj 17,

lshcr_compound_global:
	move 4,lshc_sink
	move 5,lshc_sink+1
	lshc 4,-1
	movem 4,lshc_sink
	movem 5,lshc_sink+1
	popj 17,

lshcl_compound_ret:
	move 4,(1)
	move 5,1(1)
	lshc 4,11
	movem 4,(1)
	movem 5,1(1)
	move 2,(1)
	move 3,5
	move 1,2
	move 2,3
	popj 17,

lshcr_compound_ret:
	move 4,(1)
	move 5,1(1)
	lshc 4,-11
	movem 4,(1)
	movem 5,1(1)
	move 2,(1)
	move 3,5
	move 1,2
	move 2,3
	popj 17,

lshcl_or_low:
	lshc 1,44
	move 4,3
	movei 3,0
	ior 1,3
	ior 2,4
	popj 17,

lshcr_or_high:
	lshc 1,-44
	move 5,3
	movei 4,0
	lshc 4,22
	ior 1,4
	ior 2,5
	popj 17,

lshcl_xor:
	lshc 1,11
	xor 1,3
	xor 2,4
	popj 17,

lshcr_xor:
	lshc 1,-11
	xor 1,3
	xor 2,4
	popj 17,

lshcl_add:
	push 17,10
	move 6,1
	move 7,2
	lshc 6,11
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
	pop 17,10
	popj 17,

lshcr_add:
	push 17,10
	move 6,1
	move 7,2
	lshc 6,-11
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
	pop 17,10
	popj 17,

lshcl_and_mask:
	movei 1,0
	hrrz 2,2
	lshc 1,44
	popj 17,

lshcr_and_mask:
	move 4,1
	move 5,2
	lshc 4,-44
	movei 1,0
	hrrz 2,5
	popj 17,

lshcl_then_lshcr:
	lshc 1,44
	lshc 1,-44
	popj 17,

lshcr_then_lshcl:
	lshc 1,-44
	lshc 1,44
	popj 17,

lshcl_two_counts:
	lshc 1,(3)
	lshc 1,(4)
	popj 17,

lshcr_two_counts:
	movn 3,3
	lshc 1,(3)
	movn 4,4
	lshc 1,(4)
	popj 17,

lshcl_nested:
	push 17,10
	move 5,-2(17)
	andi 5,77
	move 6,1
	xor 6,3
	move 7,2
	xor 7,4
	lshc 6,(5)
	lshc 3,-22
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
	pop 17,10
	popj 17,

lshcr_nested:
	push 17,10
	move 5,-2(17)
	andi 5,77
	move 6,1
	xor 6,3
	move 7,2
	xor 7,4
	movn 5,5
	lshc 6,(5)
	lshc 3,22
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
	pop 17,10
	popj 17,

lshcl_call_pressure:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	move 13,2
	move 10,1
	move 11,2
	lshc 10,(3)
	pushj 17,clobber
	move 2,11
	add 2,13
	move 4,2
	tlc 4,400000
	move 3,11
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 1,10
	add 1,12
	add 1,4
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

lshcr_call_pressure:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	move 13,2
	movn 3,3
	move 10,1
	move 11,2
	lshc 10,(3)
	pushj 17,clobber
	move 2,11
	add 2,13
	move 4,2
	tlc 4,400000
	move 3,11
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 1,10
	add 1,12
	add 1,4
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

lshcl_loop:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	setzb 12,13
	move 15,1
	setzb 10,11
	movei 14,0
	caml 14,2
	jrst %L116
	move 1,2
	subi 1,1
%L117:
	move 4,14
	andi 4,17
	lsh 4,1
	add 4,15
	move 12,(4)
	move 13,1(4)
	move 6,12
	move 7,13
	lshc 6,1
	move 5,11
	add 5,7
	move 3,5
	tlc 3,400000
	move 2,11
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 4,10
	add 4,6
	add 4,3
	move 10,4
	move 11,5
	addi 14,1
	sojge 1,%L117	; doloop_end
%L116:
	move 1,10
	move 2,11
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,

lshcr_loop:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	setzb 12,13
	move 15,1
	setzb 10,11
	movei 14,0
	caml 14,2
	jrst %L126
	move 1,2
	subi 1,1
%L127:
	move 4,14
	andi 4,17
	lsh 4,1
	add 4,15
	move 12,(4)
	move 13,1(4)
	move 6,12
	move 7,13
	lshc 6,-1
	move 5,11
	add 5,7
	move 3,5
	tlc 3,400000
	move 2,11
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 4,10
	add 4,6
	add 4,3
	move 10,4
	move 11,5
	addi 14,1
	sojge 1,%L127	; doloop_end
%L126:
	move 1,10
	move 2,11
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,

lshcl_loop_var:
	add 17,[7,,7]
	movem 16,-6(17)
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	setzb 12,13
	move 16,1
	move 15,3
	setzb 10,11
	movei 14,0
	caml 14,2
	jrst %L136
	move 1,2
	subi 1,1
%L137:
	move 4,14
	andi 4,17
	lsh 4,1
	add 4,16
	move 12,(4)
	move 13,1(4)
	move 6,12
	move 7,13
	lshc 6,(15)
	move 5,11
	add 5,7
	move 3,5
	tlc 3,400000
	move 2,11
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 4,10
	add 4,6
	add 4,3
	move 10,4
	move 11,5
	addi 14,1
	sojge 1,%L137	; doloop_end
%L136:
	move 1,10
	move 2,11
	move 16,-6(17)
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-7,,-7]
	popj 17,

lshcr_loop_var:
	add 17,[7,,7]
	movem 16,-6(17)
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	setzb 12,13
	move 16,1
	setzb 10,11
	movei 14,0
	caml 14,2
	jrst %L146
	movn 15,3
	move 1,2
	subi 1,1
%L147:
	move 4,14
	andi 4,17
	lsh 4,1
	add 4,16
	move 12,(4)
	move 13,1(4)
	move 6,12
	move 7,13
	lshc 6,(15)
	move 5,11
	add 5,7
	move 3,5
	tlc 3,400000
	move 2,11
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 4,10
	add 4,6
	add 4,3
	move 10,4
	move 11,5
	addi 14,1
	sojge 1,%L147	; doloop_end
%L146:
	move 1,10
	move 2,11
	move 16,-6(17)
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-7,,-7]
	popj 17,

lshcl_compare_nonzero:
	lshc 1,44
	move 4,1
	ior 4,2
	jumpn 4,%L148
	movei 1,0
	movei 2,1
%L148:
	popj 17,

lshcr_compare_nonzero:
	lshc 1,-44
	move 4,1
	ior 4,2
	jumpn 4,%L150
	movei 1,0
	movei 2,1
%L150:
	popj 17,

lshcl_select:
	lshc 1,22
	skipe -1(17)
	popj 17,
	move 1,3
	move 2,4
	lshc 1,44
	popj 17,

lshcr_select:
	lshc 1,-22
	skipe -1(17)
	popj 17,
	move 1,3
	move 2,4
	lshc 1,-44
	popj 17,

lshcl1:
	lshc 1,1
	popj 17,

lshcl2:
	lshc 1,(3)
	popj 17,

lshcl3:
	addi 3,1
	lshc 1,(3)
	popj 17,

lshcr1:
	lshc 1,-1
	popj 17,

lshcr2:
	movn 3,3
	lshc 1,(3)
	popj 17,

lshcr3:
	movn 3,3
	movn 3,3
	lshc 1,(3)
	popj 17,

lshcr4:
	addi 3,1
	movn 3,3
	lshc 1,(3)
	popj 17,

lshcr5:
	movei 4,1
	sub 4,3
	move 3,4
	movn 3,3
	lshc 1,(3)
	popj 17,

	.bss
lshc_sink:
	.space	8
lshc_buf:
	.space	128
lshc_gs:
	.space	24
