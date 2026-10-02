	.data
	.align	2
gd_a:
	.long	0
	.long	5349
	.align	2
gd_arr:
	.long	0
	.long	1
	.long	0
	.long	2
	.long	0
	.long	3
	.long	0
	.long	4
	.align	2
vgd_a:
	.long	68719476735
	.long	68719476653
	.align	2
ugd_a:
	.long	0
	.long	5349
	.align	2
vugd_a:
	.long	0
	.long	262143
	.align	2
gd_pair:
	.long	0
	.long	8
	.long	0
	.long	16
	.align	2
gd_slot:
	.long	gd_a
	.long	0
	.long	0
	.align	2
ugd_pair:
	.long	0
	.long	24
	.long	0
	.long	32

	.globl	movdi
movdi:
	move 4,-1(17)
	move 1,(4)
	move 2,1(4)
	popj 17,

movdi_arg:
	move 1,-2(17)
	move 2,-1(17)
	popj 17,

movdi_load:
	move 4,(1)
	move 5,1(1)
	move 1,4
	move 2,5
	popj 17,

movdi_store:
	movem 2,(1)
	movem 3,1(1)
	popj 17,

movdi_copy:
	move 4,(2)
	move 5,1(2)
	movem 4,(1)
	movem 5,1(1)
	move 6,(1)
	move 7,5
	move 1,6
	move 2,7
	popj 17,

movdi_double_indirect:
	move 3,(1)
	move 4,(3)
	move 5,1(3)
	move 1,4
	move 2,5
	popj 17,

movdi_store_double_indirect:
	move 4,(1)
	movem 2,(4)
	movem 3,1(4)
	popj 17,

movdi_struct_load:
	move 4,(1)
	move 5,1(1)
	move 1,4
	move 2,5
	popj 17,

movdi_struct_store:
	movem 2,2(1)
	movem 3,3(1)
	popj 17,

movdi_struct_copy:
	move 6,2(2)
	movem 6,(1)
	move 6,3(2)
	movem 6,1(1)
	move 6,(2)
	movem 6,2(1)
	move 2,1(2)
	movem 2,3(1)
	move 4,(1)
	move 5,1(1)
	move 1,4
	move 2,5
	popj 17,

movdi_array_load:
	lsh 2,1
	add 2,1
	move 4,(2)
	move 5,1(2)
	move 1,4
	move 2,5
	popj 17,

movdi_array_store:
	lsh 2,1
	add 2,1
	movem 3,(2)
	movem 4,1(2)
	popj 17,

movdi_global_load:
	move 1,gd_a
	move 2,gd_a+1
	popj 17,

movdi_global_store:
	movem 1,gd_b
	movem 2,gd_b+1
	popj 17,

movdi_volatile_load:
	move 1,vgd_a
	move 2,vgd_a+1
	popj 17,

movdi_volatile_store:
	movem 1,vgd_b
	movem 2,vgd_b+1
	popj 17,

movdi_conditional:
	add 17,[1,,1]
	move 0,-1(17)
	movem 0,(17)
	movem 4,-1(17)
	move 6,-2(17)
	move 7,4
	jumpn 1,%L22
	move 2,6
	move 3,7
%L22:
	move 1,2
	move 2,3
	move 0,(17)
	movem 0,-1(17)
	add 17,[-1,,-1]
	popj 17,

movdi_slot_load:
	move 3,(1)
	move 4,(3)
	move 5,1(3)
	movem 4,1(1)
	movem 5,2(1)
	move 6,1(1)
	move 7,5
	move 1,6
	move 2,7
	popj 17,

movdi_slot_store:
	move 4,(1)
	movem 2,(4)
	movem 3,1(4)
	movem 2,1(1)
	movem 3,2(1)
	popj 17,

movdi_call_arg:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	pushj 17,use_dint
	move 1,10
	move 2,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

movdi_call_return:
	jrst ret_dint

umovdi_arg:
	popj 17,

umovdi_load:
	move 4,(1)
	move 5,1(1)
	move 1,4
	move 2,5
	popj 17,

umovdi_store:
	movem 2,(1)
	movem 3,1(1)
	popj 17,

umovdi_global_load:
	move 1,ugd_a
	move 2,ugd_a+1
	popj 17,

umovdi_volatile_load:
	move 1,vugd_a
	move 2,vugd_a+1
	popj 17,

umovdi_volatile_store:
	movem 1,vugd_b
	movem 2,vugd_b+1
	popj 17,

umovdi_struct_load:
	move 4,(1)
	move 5,1(1)
	move 1,4
	move 2,5
	popj 17,

	.globl	use_movdi_double_indirect
use_movdi_double_indirect:
	add 17,[22,,22]
	movem 10,-21(17)
	movem 11,-20(17)
	movem 12,-17(17)
	move 5,-23(17)
	move 11,-26(17)
	move 6,gd_a
	movem 6,-16(17)
	move 6,gd_a+1
	movem 6,-15(17)
	move 6,(5)
	movem 6,-14(17)
	move 6,1(5)
	movem 6,-13(17)
	move 6,11
	andi 6,1
	lsh 6,1
	xmovei 7,gd_arr(6)
	move 6,gd_arr(6)
	movem 6,-12(17)
	move 7,1(7)
	movem 7,-11(17)
	movei 10,-16(17)
	move 12,10
	addi 12,2
	move 6,-16(17)
	movem 6,-10(17)
	move 6,-15(17)
	movem 6,-7(17)
	move 6,-14(17)
	movem 6,-6(17)
	move 6,-13(17)
	movem 6,-5(17)
	movem 12,-4(17)
	move 6,-12(17)
	movem 6,-3(17)
	move 6,-11(17)
	movem 6,-2(17)
	movem 5,(17)
	pushj 17,movdi
	pushj 17,movdi_global_store
	move 1,12
	pushj 17,movdi_load
	move 2,1
	move 3,2
	addi 10,4
	move 1,10
	pushj 17,movdi_store
	movei 1,gd_b
	move 2,10
	pushj 17,movdi_copy
	move 1,-24(17)
	pushj 17,movdi_double_indirect
	move 2,1
	move 3,2
	movei 12,-4(17)
	move 1,12
	pushj 17,movdi_store_double_indirect
	move 1,-25(17)
	pushj 17,movdi_struct_load
	move 2,1
	move 3,2
	movei 10,-10(17)
	move 1,10
	pushj 17,movdi_struct_store
	move 1,10
	movei 2,gd_pair
	pushj 17,movdi_struct_copy
	move 2,11
	andi 2,3
	movei 1,gd_arr
	pushj 17,movdi_array_load
	move 3,1
	move 4,2
	addi 11,1
	andi 11,3
	movei 1,gd_arr
	move 2,11
	pushj 17,movdi_array_store
	pushj 17,movdi_volatile_load
	pushj 17,movdi_volatile_store
	movei 1,gd_slot
	pushj 17,movdi_slot_load
	move 10,1
	move 11,2
	move 1,12
	move 2,10
	move 3,11
	pushj 17,movdi_slot_store
	move 1,10
	move 2,11
	pushj 17,movdi_call_arg
	pushj 17,movdi_call_return
	move 10,-21(17)
	move 11,-20(17)
	move 12,-17(17)
	add 17,[-22,,-22]
	popj 17,

	.globl	use_umovdi_double_indirect
use_umovdi_double_indirect:
	add 17,[4,,4]
	move 6,ugd_a
	movem 6,-3(17)
	move 6,ugd_a+1
	movem 6,-2(17)
	move 6,(1)
	movem 6,-1(17)
	move 1,1(1)
	movem 1,(17)
	movei 1,-3(17)
	pushj 17,umovdi_load
	move 2,1
	move 3,2
	movei 1,ugd_b
	pushj 17,umovdi_store
	pushj 17,umovdi_volatile_load
	pushj 17,umovdi_volatile_store
	movei 1,ugd_pair
	pushj 17,umovdi_struct_load
	add 17,[-4,,-4]
	popj 17,

	.bss
gd_b:
	.space	8
vgd_b:
	.space	8
ugd_b:
	.space	8
vugd_b:
	.space	8
