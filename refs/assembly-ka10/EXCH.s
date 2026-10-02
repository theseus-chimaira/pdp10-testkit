
exch_reg_mem:
	exch 1,(2)
	popj 17,

exch_reg_mem_alt:
	exch 1,(2)
	popj 17,

exch_reg_mem_return_new_mem:
	movem 1,(2)
	popj 17,

exch_reg_mem_sum:
	move 4,1
	move 1,(2)
	movem 4,(2)
	add 1,4
	popj 17,

exch_reg_mem_void:
	movem 1,(2)
	popj 17,

exch_global:
	exch 1,exga
	popj 17,

exch_global_alt:
	exch 1,exgb
	popj 17,

exch_global_sum:
	move 4,1
	move 1,exga
	movem 4,exga
	add 1,4
	popj 17,

uexch_reg_mem:
	exch 1,(2)
	popj 17,

uexch_global:
	exch 1,exua
	popj 17,

exch_array:
	andi 3,7
	add 2,3
	exch 1,(2)
	popj 17,

exch_array_alt:
	move 4,1
	andi 3,7
	add 2,3
	move 1,(2)
	movem 4,(2)
	popj 17,

exch_array_sum:
	andi 3,7
	add 2,3
	move 4,1
	move 1,(2)
	movem 4,(2)
	add 1,4
	popj 17,

exch_struct_member:
	exch 1,1(2)
	popj 17,

exch_struct_member_alt:
	exch 1,2(2)
	popj 17,

exch_global_struct:
	exch 1,exgs+1
	popj 17,

exch_volatile:
	exch 1,(2)
	popj 17,

exch_volatile_sum:
	move 3,1
	exch 3,(2)
	move 1,(2)
	add 1,3
	popj 17,

exch_volatile_void:
	exch 1,(2)
	popj 17,

exch_call_pressure:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	exch 11,(2)
	pushj 17,clobber
	add 11,(10)
	move 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

exch_two_swaps:
	move 4,(3)
	movem 2,(3)
	add 4,1
	add 4,2
	move 1,4
	popj 17,

exch_two_memory:
	move 4,(2)
	move 6,(3)
	movem 6,(2)
	movem 4,(3)
	move 4,1
	move 1,(2)
	movem 4,(2)
	add 1,4
	add 1,(3)
	popj 17,

exch_local_spill:
	move 4,1
	addi 2,2
	addi 4,1
	move 1,(3)
	movem 4,(3)
	add 1,2
	add 1,4
	popj 17,

exch_ptr_chain:
	move 4,(2)
	exch 1,(4)
	popj 17,

exch_indexed_ptr_chain:
	andi 3,7
	add 3,(2)
	move 4,1
	move 1,(3)
	movem 4,(3)
	add 1,4
	popj 17,

	.comm	exga, 4
	.comm	exgb, 4
	.comm	exua, 4
	.comm	exub, 4
	.comm	exgs, 12
