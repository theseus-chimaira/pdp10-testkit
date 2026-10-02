
jffo_reg:
	jrst __builtin_pdp10_jffo

jffo_mem:
	move 1,(1)
	jrst __builtin_pdp10_jffo

jffo_volatile_mem:
	move 1,(1)
	jrst __builtin_pdp10_jffo

jffo_zero:
	movei 1,0
	jrst __builtin_pdp10_jffo

jffo_low_bit:
	iori 1,1
	jrst __builtin_pdp10_jffo

jffo_sign_bit:
	tlo 1,400000
	jrst __builtin_pdp10_jffo

jffo_low_9:
	andi 1,777
	jrst __builtin_pdp10_jffo

jffo_low_18:
	hrrz 1,1
	jrst __builtin_pdp10_jffo

jffo_high_18:
	hllz 1,1
	jrst __builtin_pdp10_jffo

jffo_literal_small:
	movei 1,123456
	jrst __builtin_pdp10_jffo

jffo_literal_big:
	move 1,[123456123456]
	jrst __builtin_pdp10_jffo

jffo_literal_sparse:
	move 1,[-252525525253]
	jrst __builtin_pdp10_jffo

jffo_or:
	ior 1,2
	jrst __builtin_pdp10_jffo

jffo_and:
	and 1,2
	jrst __builtin_pdp10_jffo

jffo_xor:
	xor 1,2
	jrst __builtin_pdp10_jffo

jffo_complement:
	setca 1,
	jrst __builtin_pdp10_jffo

jffo_shift_left:
	andi 2,17
	lsh 1,(2)
	jrst __builtin_pdp10_jffo

jffo_shift_right:
	andi 2,17
	movn 2,2
	lsh 1,(2)
	jrst __builtin_pdp10_jffo

jffo_add:
	add 1,2
	jrst __builtin_pdp10_jffo

jffo_sub:
	sub 1,2
	jrst __builtin_pdp10_jffo

jffo_isolated_lowbit:
	movn 4,1
	and 1,4
	jrst __builtin_pdp10_jffo

jffo_qi_unsigned:
	andi 1,777	; zero_extendqisi2
	jrst __builtin_pdp10_jffo

jffo_qi_signed:
	lsh 1,33
	ash 1,-33
	jrst __builtin_pdp10_jffo

jffo_hi_unsigned:
	hrrzi 1,(1)	; zero_extendhisi2
	jrst __builtin_pdp10_jffo

jffo_hi_signed:
	hrre 1,1
	jrst __builtin_pdp10_jffo

jffo_array:
	andi 2,7
	add 1,2
	move 1,(1)
	jrst __builtin_pdp10_jffo

jffo_struct:
	move 1,1(1)
	jrst __builtin_pdp10_jffo

jffo_store:
	push 17,10
	move 10,1
	move 1,2
	pushj 17,__builtin_pdp10_jffo
	movem 1,(10)
	pop 17,10
	popj 17,

jffo_store_void:
	push 17,10
	move 10,1
	move 1,2
	pushj 17,__builtin_pdp10_jffo
	movem 1,(10)
	pop 17,10
	popj 17,

jffo_branch_zero:
	pushj 17,__builtin_pdp10_jffo
	caige 1,0
	movei 1,0
	popj 17,

jffo_branch_nonzero:
	pushj 17,__builtin_pdp10_jffo
	move 4,1
	addi 4,1
	jumpl 1,%L35
%L33:
	move 1,4
	popj 17,
%L35:
	seto 4,
	jrst %L33

jffo_compare_low:
	pushj 17,__builtin_pdp10_jffo
	move 4,1
	caile 1,11
	movei 4,0
	move 1,4
	popj 17,

jffo_compare_high:
	pushj 17,__builtin_pdp10_jffo
	move 4,1
	caig 1,22
	movei 4,0
	move 1,4
	popj 17,

jffo_two_values:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,2
	pushj 17,__builtin_pdp10_jffo
	move 11,1
	move 1,10
	pushj 17,__builtin_pdp10_jffo
	add 11,1
	move 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

jffo_call_pressure:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 1,10
	pushj 17,__builtin_pdp10_jffo
	move 11,1
	pushj 17,clobber
	add 11,10
	move 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

jffo_loop:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 13,1
	move 12,2
	setzb 11,10
	camge 11,2
	jrst %L48
%L50:
	move 1,11
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,
%L48:
	move 4,10
	andi 4,7
	add 4,13
	move 1,(4)
	pushj 17,__builtin_pdp10_jffo
	add 11,1
	addi 10,1
	camge 10,12
	jrst %L48
	jrst %L50

jffo_nested_expr:
	move 4,1
	movn 1,1
	and 1,4
	xor 2,3
	iori 1,(2)
	jrst __builtin_pdp10_jffo

jffo_jump_form_zero:
	movei 1,0
	move 2,1
	movei 1,0
	move 3,[POINT 18,%L53,35]
	pushj 17,__builtin_jffo
%L53:
	movei 1,0
	popj 17,

jffo_jump_form_nonzero:
	iori 1,1
	move 2,1
	movei 1,0
	move 3,[POINT 18,%L57,35]
	pushj 17,__builtin_jffo
%L57:
	movei 1,0
	popj 17,

jffo_jump_form_reg:
	move 2,1
	movei 1,0
	move 3,[POINT 18,%L61,35]
	pushj 17,__builtin_jffo
%L61:
	seto 1,
	popj 17,

jffo_jump_form_mem:
	move 1,(1)
	move 2,1
	movei 1,0
	move 3,[POINT 18,%L65,35]
	pushj 17,__builtin_jffo
%L65:
	seto 1,
	popj 17,

jffo_jump_form_dint:
	move 3,[POINT 18,%L69,35]
	pushj 17,__builtin_jffo
%L69:
	seto 1,
	popj 17,

jffo_jump_form_dint_mem:
	move 4,(1)
	move 5,1(1)
	move 1,4
	move 2,5
	move 3,[POINT 18,%L73,35]
	pushj 17,__builtin_jffo
%L73:
	seto 1,
	popj 17,

jffo_jump_form_two_labels:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 4,1
	move 10,2
	move 5,4
	movei 4,0
	move 11,10
	movei 10,0
	move 1,4
	move 2,5
	move 3,[POINT 18,%L77,35]
	pushj 17,__builtin_jffo
	move 1,10
	move 2,11
	move 3,[POINT 18,%L80,35]
	pushj 17,__builtin_jffo
%L77:
%L80:
%L83:
	movei 1,0
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.comm	p, 4
