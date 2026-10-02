	.data
	.align	2
gu_a:
	.word	30071
	.align	2
gu_b:
	.word	45
	.align	2
vgu_a:
	.word	777777754554
	.align	2
vgu_b:
	.word	13
	.align	2
gu_pair:
	.word	777777747707
	.word	23
	.align	2
gu_slot:
	.word	0
	.word	7

nonzero_usint:
	movei 4,3
	jumpe 1,%L1
	move 4,1
%L1:
	move 1,4
	popj 17,

udivsi_var:
	push 17,10
	move 10,1
	move 1,2
	pushj 17,nonzero_usint
	move 2,1
	move 1,10
	pushj 17,__udivsi3
	pop 17,10
	popj 17,

udivsi_mem:
	push 17,10
	move 10,1
	move 1,(2)
	pushj 17,nonzero_usint
	move 2,1
	move 1,(10)
	pushj 17,__udivsi3
	pop 17,10
	popj 17,

udivsi_global:
	move 1,gu_b
	pushj 17,nonzero_usint
	move 2,1
	move 1,gu_a
	pushj 17,__udivsi3
	popj 17,

udivsi_volatile:
	push 17,10
	move 10,vgu_a
	move 1,vgu_b
	pushj 17,nonzero_usint
	move 2,1
	move 1,10
	pushj 17,__udivsi3
	pop 17,10
	popj 17,

udivsi_const_3:
	movei 2,3
	pushj 17,__udivsi3
	popj 17,

udivsi_const_5:
	movei 2,5
	pushj 17,__udivsi3
	popj 17,

udivsi_const_37:
	movei 2,45
	pushj 17,__udivsi3
	popj 17,

udivsi_high_num:
	push 17,10
	move 10,1
	tlo 10,400000
	move 1,2
	pushj 17,nonzero_usint
	move 2,1
	move 1,10
	pushj 17,__udivsi3
	pop 17,10
	popj 17,

udivsi_high_den:
	push 17,10
	move 10,1
	tlo 2,200000
	move 1,2
	pushj 17,nonzero_usint
	move 2,1
	move 1,10
	pushj 17,__udivsi3
	pop 17,10
	popj 17,

udivsi_max_num:
	pushj 17,nonzero_usint
	move 2,1
	seto 1,
	pushj 17,__udivsi3
	popj 17,

udivsi_store:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	move 1,3
	pushj 17,nonzero_usint
	move 2,1
	move 1,10
	pushj 17,__udivsi3
	movem 1,(11)
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

udivsi_update:
	push 17,10
	move 10,1
	move 1,2
	pushj 17,nonzero_usint
	move 2,1
	move 1,(10)
	pushj 17,__udivsi3
	movem 1,(10)
	pop 17,10
	popj 17,

udivsi_struct:
	push 17,10
	move 10,1
	move 1,1(1)
	pushj 17,nonzero_usint
	move 2,1
	move 1,(10)
	pushj 17,__udivsi3
	pop 17,10
	popj 17,

udivsi_struct_store:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	move 1,1(1)
	pushj 17,nonzero_usint
	move 2,1
	move 1,(10)
	pushj 17,__udivsi3
	movem 1,(11)
	add 1,1(11)
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

udivsi_branch:
	push 17,10
	move 10,1
	move 1,2
	pushj 17,nonzero_usint
	move 2,1
	move 1,10
	pushj 17,__udivsi3
	movei 3,0
	jumpe 1,%L17
	skipl 3,1
	caml 3,[1000000]
	tdza 3,3
	movei 3,1
	movei 4,2
	sub 4,3
	move 3,4
%L17:
	move 1,3
	pop 17,10
	popj 17,

udivsi_array:
	push 17,10
	move 10,1
	add 10,2
	move 1,1(10)
	pushj 17,nonzero_usint
	move 2,1
	move 1,(10)
	pushj 17,__udivsi3
	pop 17,10
	popj 17,

udivsi_mix:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,3
	move 1,2
	pushj 17,nonzero_usint
	move 2,1
	move 1,10
	pushj 17,__udivsi3
	move 10,1
	addi 1,7
	pushj 17,nonzero_usint
	move 2,1
	move 1,11
	pushj 17,__udivsi3
	add 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

udivsi_call_arg:
	push 17,10
	move 10,1
	move 1,2
	pushj 17,nonzero_usint
	move 2,1
	move 1,10
	pushj 17,__udivsi3
	move 10,1
	pushj 17,use_usint
	move 1,10
	pop 17,10
	popj 17,

	.globl	use_libgcc_udivsi3
use_libgcc_udivsi3:
	add 17,[10,,10]
	movei 0,-7(17)
	hrli 0,10
	blt 0,-3(17)
	move 11,1
	move 12,2
	move 14,3
	move 6,1
	tlo 6,400000
	movem 6,-2(17)
	move 1,2
	pushj 17,nonzero_usint
	movem 1,-1(17)
	movei 6,15
	movem 6,(17)
	movei 1,gu_c
	move 2,11
	move 3,12
	pushj 17,udivsi_store
	movem 1,gu_c
	movei 13,-2(17)
	move 1,13
	move 2,-1(17)
	pushj 17,udivsi_update
	move 1,11
	move 2,12
	pushj 17,udivsi_var
	move 10,1
	move 2,13
	addi 2,2
	move 1,13
	pushj 17,udivsi_mem
	add 10,1
	pushj 17,udivsi_global
	add 10,1
	pushj 17,udivsi_volatile
	add 10,1
	move 1,11
	pushj 17,udivsi_const_3
	add 10,1
	move 1,11
	pushj 17,udivsi_const_5
	add 10,1
	move 1,11
	pushj 17,udivsi_const_37
	add 10,1
	move 1,11
	move 2,12
	pushj 17,udivsi_high_num
	add 10,1
	move 1,11
	move 2,12
	pushj 17,udivsi_high_den
	add 10,1
	move 1,12
	pushj 17,udivsi_max_num
	add 10,1
	movei 1,gu_pair
	pushj 17,udivsi_struct
	add 10,1
	movei 1,gu_pair
	movei 2,gu_slot
	pushj 17,udivsi_struct_store
	add 10,1
	move 1,11
	move 2,12
	pushj 17,udivsi_branch
	add 10,1
	andi 14,1
	move 1,13
	move 2,14
	pushj 17,udivsi_array
	add 10,1
	move 1,11
	move 2,12
	move 3,gu_c
	pushj 17,udivsi_mix
	add 10,1
	move 1,11
	move 2,12
	pushj 17,udivsi_call_arg
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-7(17)
	blt 0,14
	add 17,[-10,,-10]
	popj 17,

	.bss
gu_c:
	.space	4
