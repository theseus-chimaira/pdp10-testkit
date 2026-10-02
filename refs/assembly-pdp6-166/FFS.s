
ffs_reg:
	pushj 17,ffs
	popj 17,

ffs_mem:
	move 1,(1)
	pushj 17,ffs
	popj 17,

ffs_volatile_mem:
	move 1,(1)
	pushj 17,ffs
	popj 17,

ffs_unsigned_reg:
	pushj 17,ffs
	popj 17,

ffs_unsigned_mem:
	move 1,(1)
	pushj 17,ffs
	popj 17,

ffs_zero_value:
	movei 1,0
	pushj 17,ffs
	popj 17,

ffs_low_bit:
	iori 1,1
	pushj 17,ffs
	popj 17,

ffs_low_9_bits:
	andi 1,777
	pushj 17,ffs
	popj 17,

ffs_low_18_bits:
	hrrz 1,1
	pushj 17,ffs
	popj 17,

ffs_high_18_bits:
	hllz 1,1
	pushj 17,ffs
	popj 17,

ffs_sign_bit:
	tlo 1,400000
	pushj 17,ffs
	popj 17,

ffs_shift_left:
	andi 2,17
	lsh 1,(2)
	pushj 17,ffs
	popj 17,

ffs_shift_right:
	andi 2,17
	movn 2,2
	ash 1,(2)
	pushj 17,ffs
	popj 17,

ffs_isolated_lowbit:
	movn 4,1
	and 1,4
	pushj 17,ffs
	popj 17,

ffs_complement:
	setca 1,
	pushj 17,ffs
	popj 17,

ffs_xor:
	xor 1,2
	pushj 17,ffs
	popj 17,

ffs_or:
	ior 1,2
	pushj 17,ffs
	popj 17,

ffs_and:
	and 1,2
	pushj 17,ffs
	popj 17,

ffs_add:
	add 1,2
	pushj 17,ffs
	popj 17,

ffs_sub:
	sub 1,2
	pushj 17,ffs
	popj 17,

ffs_qi_signed:
	lsh 1,33
	ash 1,-33
	pushj 17,ffs
	popj 17,

ffs_qi_unsigned:
	andi 1,777	; zero_extendqisi2
	pushj 17,ffs
	popj 17,

ffs_hi_signed:
	hrre 1,1
	pushj 17,ffs
	popj 17,

ffs_hi_unsigned:
	hrrzi 1,(1)	; zero_extendhisi2
	pushj 17,ffs
	popj 17,

ffs_array:
	andi 2,7
	add 1,2
	move 1,(1)
	pushj 17,ffs
	popj 17,

ffs_struct:
	move 1,1(1)
	pushj 17,ffs
	popj 17,

ffs_store:
	push 17,10
	move 10,1
	move 1,2
	pushj 17,ffs
	movem 1,(10)
	pop 17,10
	popj 17,

ffs_store_void:
	push 17,10
	move 10,1
	move 1,2
	pushj 17,ffs
	movem 1,(10)
	pop 17,10
	popj 17,

ffs_branch_zero:
	pushj 17,ffs
	movei 4,1
	jumpe 1,%L30
	move 4,1
%L30:
	move 1,4
	popj 17,

ffs_branch_nonzero:
	pushj 17,ffs
	move 4,1
	addi 4,1
	jumpn 1,%L32
	movei 4,0
%L32:
	move 1,4
	popj 17,

ffs_compare_low:
	pushj 17,ffs
	move 4,1
	caile 1,11
	movei 4,0
	move 1,4
	popj 17,

ffs_compare_high:
	pushj 17,ffs
	move 4,1
	caig 1,22
	movei 4,0
	move 1,4
	popj 17,

ffs_two_values:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,2
	pushj 17,ffs
	move 11,1
	move 1,10
	pushj 17,ffs
	add 11,1
	move 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

ffs_call_pressure:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 1,10
	pushj 17,ffs
	move 11,1
	pushj 17,clobber
	add 11,10
	move 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

ffs_loop:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 13,1
	move 12,2
	setzb 11,10
	caml 11,2
	jrst %L48
%L46:
	move 4,10
	andi 4,7
	add 4,13
	move 1,(4)
	pushj 17,ffs
	add 11,1
	addi 10,1
	camge 10,12
	jrst %L46
%L48:
	move 1,11
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

ffs_nested_expr:
	move 4,1
	movn 1,1
	and 1,4
	xor 2,3
	iori 1,(2)
	pushj 17,ffs
	popj 17,

	.comm	p, 4
