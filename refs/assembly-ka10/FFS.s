
ffs_reg:
	setzb 2,3
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L2
	movei 3,44
%L2:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_mem:
	setzb 6,7
	move 4,(1)
	movn 3,4
	move 6,4
	and 6,3
	jffo 6,%L4
	movei 7,44
%L4:
	move 1,7
	subi 1,44
	movn 1,1
	popj 17,

ffs_volatile_mem:
	setzb 6,7
	move 4,(1)
	movn 3,4
	move 6,4
	and 6,3
	jffo 6,%L6
	movei 7,44
%L6:
	move 1,7
	subi 1,44
	movn 1,1
	popj 17,

ffs_unsigned_reg:
	setzb 2,3
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L8
	movei 3,44
%L8:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_unsigned_mem:
	setzb 6,7
	move 4,(1)
	movn 3,4
	move 6,4
	and 6,3
	jffo 6,%L10
	movei 7,44
%L10:
	move 1,7
	subi 1,44
	movn 1,1
	popj 17,

ffs_zero_value:
	setzb 1,2
	movei 4,0
	movn 3,4
	move 1,4
	and 1,3
	jffo 1,%L12
	movei 2,44
%L12:
	move 1,2
	subi 1,44
	movn 1,1
	popj 17,

ffs_low_bit:
	setzb 2,3
	iori 1,1
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L14
	movei 3,44
%L14:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_low_9_bits:
	setzb 2,3
	andi 1,777
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L16
	movei 3,44
%L16:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_low_18_bits:
	setzb 2,3
	hrrz 1,1
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L18
	movei 3,44
%L18:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_high_18_bits:
	setzb 2,3
	hllz 1,1
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L20
	movei 3,44
%L20:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_sign_bit:
	setzb 2,3
	tlo 1,400000
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L22
	movei 3,44
%L22:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_shift_left:
	setzb 6,7
	andi 2,17
	lsh 1,(2)
	movn 4,1
	move 6,1
	and 6,4
	jffo 6,%L24
	movei 7,44
%L24:
	move 1,7
	subi 1,44
	movn 1,1
	popj 17,

ffs_shift_right:
	setzb 6,7
	andi 2,17
	movn 2,2
	ash 1,(2)
	movn 4,1
	move 6,1
	and 6,4
	jffo 6,%L26
	movei 7,44
%L26:
	move 1,7
	subi 1,44
	movn 1,1
	popj 17,

ffs_isolated_lowbit:
	setzb 2,3
	movn 4,1
	and 1,4
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L28
	movei 3,44
%L28:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_complement:
	setzb 2,3
	setca 1,
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L30
	movei 3,44
%L30:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_xor:
	setzb 6,7
	xor 1,2
	movn 4,1
	move 6,1
	and 6,4
	jffo 6,%L32
	movei 7,44
%L32:
	move 1,7
	subi 1,44
	movn 1,1
	popj 17,

ffs_or:
	setzb 6,7
	ior 1,2
	movn 4,1
	move 6,1
	and 6,4
	jffo 6,%L34
	movei 7,44
%L34:
	move 1,7
	subi 1,44
	movn 1,1
	popj 17,

ffs_and:
	setzb 6,7
	and 1,2
	movn 4,1
	move 6,1
	and 6,4
	jffo 6,%L36
	movei 7,44
%L36:
	move 1,7
	subi 1,44
	movn 1,1
	popj 17,

ffs_add:
	setzb 6,7
	add 1,2
	movn 4,1
	move 6,1
	and 6,4
	jffo 6,%L38
	movei 7,44
%L38:
	move 1,7
	subi 1,44
	movn 1,1
	popj 17,

ffs_sub:
	setzb 6,7
	sub 1,2
	movn 4,1
	move 6,1
	and 6,4
	jffo 6,%L40
	movei 7,44
%L40:
	move 1,7
	subi 1,44
	movn 1,1
	popj 17,

ffs_qi_signed:
	setzb 2,3
	lsh 1,33
	ash 1,-33
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L42
	movei 3,44
%L42:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_qi_unsigned:
	setzb 2,3
	andi 1,777	; zero_extendqisi2
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L44
	movei 3,44
%L44:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_hi_signed:
	setzb 2,3
	hrre 1,1
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L46
	movei 3,44
%L46:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_hi_unsigned:
	setzb 2,3
	hrrzi 1,(1)	; zero_extendhisi2
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L48
	movei 3,44
%L48:
	move 1,3
	subi 1,44
	movn 1,1
	popj 17,

ffs_array:
	setzb 6,7
	andi 2,7
	add 1,2
	move 4,(1)
	movn 3,4
	move 6,4
	and 6,3
	jffo 6,%L51
	movei 7,44
%L51:
	move 1,7
	subi 1,44
	movn 1,1
	popj 17,

ffs_struct:
	setzb 6,7
	move 4,1(1)
	movn 3,4
	move 6,4
	and 6,3
	jffo 6,%L53
	movei 7,44
%L53:
	move 1,7
	subi 1,44
	movn 1,1
	popj 17,

ffs_store:
	setzb 6,7
	move 3,1
	movn 4,2
	move 6,2
	and 6,4
	jffo 6,%L55
	movei 7,44
%L55:
	move 1,7
	subi 1,44
	movn 1,1
	movem 1,(3)
	popj 17,

ffs_store_void:
	setzb 6,7
	movn 4,2
	move 6,2
	and 6,4
	jffo 6,%L57
	movei 7,44
%L57:
	move 4,7
	subi 4,44
	movnm 4,(1)
	popj 17,

ffs_branch_zero:
	setzb 2,3
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L59
	movei 3,44
%L59:
	move 4,3
	subi 4,44
	movn 1,4
	movei 4,1
	jumpe 1,%L58
	move 4,1
%L58:
	move 1,4
	popj 17,

ffs_branch_nonzero:
	setzb 2,3
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L62
	movei 3,44
%L62:
	move 4,3
	subi 4,44
	movn 4,4
	move 1,4
	addi 1,1
	jumpn 4,%L61
	movei 1,0
%L61:
	popj 17,

ffs_compare_low:
	setzb 2,3
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L65
	movei 3,44
%L65:
	move 4,3
	subi 4,44
	movn 4,4
	move 1,4
	caile 4,11
	movei 1,0
	popj 17,

ffs_compare_high:
	setzb 2,3
	movn 4,1
	move 2,1
	and 2,4
	jffo 2,%L68
	movei 3,44
%L68:
	move 4,3
	subi 4,44
	movn 4,4
	move 1,4
	caig 4,22
	movei 1,0
	popj 17,

ffs_two_values:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setzb 6,7
	setzb 10,11
	movn 4,1
	move 6,1
	and 6,4
	jffo 6,%L71
	movei 7,44
%L71:
	move 4,7
	subi 4,44
	movn 1,4
	movn 4,2
	move 10,2
	and 10,4
	jffo 10,%L72
	movei 11,44
%L72:
	move 4,11
	subi 4,44
	sub 1,4
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

ffs_call_pressure:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setzb 7,10
	move 11,1
	movn 4,11
	move 7,11
	and 7,4
	jffo 7,%L74
	movei 10,44
%L74:
	subi 10,44
	movn 10,10
	pushj 17,clobber
	add 10,11
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

ffs_loop:
	push 17,10
	setzb 6,7
	move 10,1
	setzb 1,5
	caml 1,2
	jrst %L84
	subi 2,1
%L85:
	move 4,5
	andi 4,7
	add 4,10
	move 4,(4)
	movn 3,4
	move 6,4
	and 6,3
	jffo 6,%L81
	movei 7,44
%L81:
	move 4,7
	subi 4,44
	sub 1,4
	addi 5,1
	sojge 2,%L85	; doloop_end
%L84:
	pop 17,10
	popj 17,

ffs_nested_expr:
	setzb 6,7
	movn 4,1
	and 4,1
	xor 2,3
	iori 4,(2)
	movn 3,4
	move 6,4
	and 6,3
	jffo 6,%L87
	movei 7,44
%L87:
	move 1,7
	subi 1,44
	movn 1,1
	popj 17,

	.comm	p, 4
