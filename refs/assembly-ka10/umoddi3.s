	.data
	.align	2
gu_a:
	.long	0
	.long	11219468956
	.align	2
vgu_a:
	.long	68719476735
	.long	68719476735
	.align	2
gu_pair:
	.long	0
	.long	11219468956
	.long	68719476735
	.long	68719476735
	.align	2
gu_arr:
	.long	0
	.long	0
	.long	0
	.long	1
	.long	68719476735
	.long	68719476735
	.long	0
	.long	11219468956
	.long	34359738368
	.long	34359738368

umoddi_mod2:
	movei 1,0
	andi 2,1
	popj 17,

umoddi_mod4:
	movei 1,0
	andi 2,3
	popj 17,

umoddi_mod8:
	movei 1,0
	andi 2,7
	popj 17,

umoddi_mod16:
	movei 1,0
	andi 2,17
	popj 17,

umoddi_mod64:
	movei 1,0
	andi 2,77
	popj 17,

umoddi_mod512:
	movei 1,0
	andi 2,777
	popj 17,

umoddi_mod4096:
	movei 1,0
	andi 2,7777
	popj 17,

umoddi_mod_bigword:
	andi 1,1
	popj 17,

umoddi_mem2:
	move 5,1(1)
	movei 4,0
	andi 5,1
	move 1,4
	move 2,5
	popj 17,

umoddi_mem8:
	move 5,1(1)
	movei 4,0
	andi 5,7
	move 1,4
	move 2,5
	popj 17,

umoddi_global:
	movei 1,0
	move 2,gu_a+1
	andi 2,3
	popj 17,

umoddi_volatile:
	move 1,vgu_a
	move 2,vgu_a+1
	movei 1,0
	andi 2,7
	popj 17,

umoddi_high_const:
	movei 1,0
	movei 2,17
	popj 17,

umoddi_high_shifted:
	setzb 1,2
	popj 17,

umoddi_store:
	movei 2,0
	andi 3,3
	movem 2,(1)
	movem 3,1(1)
	move 1,2
	move 2,3
	popj 17,

umoddi_store_mem:
	move 5,1(2)
	movei 4,0
	andi 5,17
	movem 4,(1)
	movem 5,1(1)
	move 6,(1)
	move 7,5
	move 1,6
	move 2,7
	popj 17,

umoddi_update2:
	move 5,1(1)
	movei 4,0
	andi 5,1
	movem 4,(1)
	movem 5,1(1)
	move 2,(1)
	move 3,5
	move 1,2
	move 2,3
	popj 17,

umoddi_update8:
	move 5,1(1)
	movei 4,0
	andi 5,7
	movem 4,(1)
	movem 5,1(1)
	move 2,(1)
	move 3,5
	move 1,2
	move 2,3
	popj 17,

umoddi_struct:
	move 5,1(1)
	movei 4,0
	andi 5,77
	move 1,4
	move 2,5
	popj 17,

umoddi_struct_store:
	move 5,3(1)
	movei 4,0
	andi 5,17
	movem 4,(2)
	movem 5,1(2)
	move 6,(2)
	move 7,5
	move 1,6
	move 2,7
	popj 17,

umoddi_array:
	lsh 2,1
	add 2,1
	move 5,1(2)
	movei 4,0
	andi 5,3
	move 1,4
	move 2,5
	popj 17,

umoddi_array_store:
	lsh 2,1
	add 2,1
	move 5,3(2)
	movei 4,0
	andi 5,7
	movem 4,(2)
	movem 5,1(2)
	popj 17,

umoddi_branch:
	movei 4,0
	move 5,2
	andi 5,7
	move 2,4
	move 3,5
	move 4,2
	ior 4,3
	movei 1,0
	jumpe 4,%L26
	cail 2,0
	cail 2,1
	jrst %L29
	jumpn 2,%L28
	cail 3,0
	cail 3,4
	trna
	jrst %L28
%L29:
	movei 1,2
%L26:
	popj 17,
%L28:
	movei 1,1
	popj 17,

umoddi_call_arg:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	movei 10,0
	andi 11,17
	move 1,10
	move 2,11
	pushj 17,sink_udint
	move 1,10
	move 2,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

umoddi_chain:
	move 4,1
	move 5,2
	andi 5,77
	movei 1,0
	move 2,5
	andi 2,7
	popj 17,

	.globl	use_umoddi3
use_umoddi3:
	add 17,[15,,15]
	movei 0,-14(17)
	hrli 0,10
	blt 0,-10(17)
	move 10,1
	move 11,2
	move 14,3
	movem 1,-7(17)
	movem 11,-6(17)
	setom -5(17)
	setom -4(17)
	movsi 6,400000
	movem 6,-3(17)
	movem 6,-2(17)
	setzm -1(17)
	move 6,[123456701234]
	movem 6,(17)
	pushj 17,umoddi_mod2
	pushj 17,sink_udint
	move 1,10
	move 2,11
	pushj 17,umoddi_mod4
	pushj 17,sink_udint
	move 1,10
	move 2,11
	pushj 17,umoddi_mod8
	pushj 17,sink_udint
	move 1,10
	move 2,11
	pushj 17,umoddi_mod16
	pushj 17,sink_udint
	move 1,10
	move 2,11
	pushj 17,umoddi_mod64
	pushj 17,sink_udint
	move 1,10
	move 2,11
	pushj 17,umoddi_mod512
	pushj 17,sink_udint
	move 1,10
	move 2,11
	pushj 17,umoddi_mod4096
	pushj 17,sink_udint
	move 1,10
	move 2,11
	pushj 17,umoddi_mod_bigword
	pushj 17,sink_udint
	movei 12,-7(17)
	move 1,12
	pushj 17,umoddi_mem2
	pushj 17,sink_udint
	move 13,12
	addi 13,2
	move 1,13
	pushj 17,umoddi_mem8
	pushj 17,sink_udint
	pushj 17,umoddi_global
	pushj 17,sink_udint
	pushj 17,umoddi_volatile
	pushj 17,sink_udint
	pushj 17,umoddi_high_const
	pushj 17,sink_udint
	pushj 17,umoddi_high_shifted
	pushj 17,sink_udint
	movei 1,gu_b
	move 2,10
	move 3,11
	pushj 17,umoddi_store
	pushj 17,sink_udint
	move 1,12
	addi 1,6
	move 2,12
	addi 2,4
	pushj 17,umoddi_store_mem
	pushj 17,sink_udint
	move 1,12
	pushj 17,umoddi_update2
	pushj 17,sink_udint
	move 1,13
	pushj 17,umoddi_update8
	pushj 17,sink_udint
	movei 1,gu_pair
	pushj 17,umoddi_struct
	pushj 17,sink_udint
	movei 1,gu_pair
	movei 2,gu_slot
	pushj 17,umoddi_struct_store
	pushj 17,sink_udint
	move 2,14
	andi 2,3
	movei 1,gu_arr
	pushj 17,umoddi_array
	pushj 17,sink_udint
	andi 14,1
	move 1,12
	move 2,14
	pushj 17,umoddi_array_store
	move 1,10
	move 2,11
	pushj 17,umoddi_branch
	move 4,1
	move 2,1
	ash 4,-43
	move 1,4
	pushj 17,sink_udint
	move 1,10
	move 2,11
	pushj 17,umoddi_call_arg
	pushj 17,sink_udint
	move 1,10
	move 2,11
	pushj 17,umoddi_chain
	move 10,1
	move 11,2
	pushj 17,sink_udint
	movem 10,vgu_b
	movem 11,vgu_b+1
	move 1,10
	move 2,11
	movei 0,10
	hrli 0,-14(17)
	blt 0,14
	add 17,[-15,,-15]
	popj 17,

	.bss
gu_b:
	.space	8
vgu_b:
	.space	8
gu_slot:
	.space	16
