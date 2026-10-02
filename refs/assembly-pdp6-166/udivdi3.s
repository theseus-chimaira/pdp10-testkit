	.data
	.align	2
gu_a:
	.word	0
	.word	123456701234
	.align	2
vgu_a:
	.word	777777777777
	.word	777777777777
	.align	2
gu_pair:
	.word	0
	.word	123456701234
	.word	777777777777
	.word	777777777777
	.align	2
gu_arr:
	.word	0
	.word	0
	.word	0
	.word	1
	.word	777777777777
	.word	777777777777
	.word	0
	.word	123456701234
	.word	200000000000
	.word	0

udivdi_div2:
	lshc 1,-1
	popj 17,

udivdi_div4:
	lshc 1,-2
	popj 17,

udivdi_div8:
	lshc 1,-3
	popj 17,

udivdi_div16:
	lshc 1,-4
	popj 17,

udivdi_div64:
	lshc 1,-6
	popj 17,

udivdi_div512:
	lshc 1,-11
	popj 17,

udivdi_div4096:
	lshc 1,-14
	popj 17,

udivdi_div_bigword:
	lshc 1,-44
	popj 17,

udivdi_mem2:
	move 4,(1)
	move 5,1(1)
	lshc 4,-1
	move 1,4
	move 2,5
	popj 17,

udivdi_mem8:
	move 4,(1)
	move 5,1(1)
	lshc 4,-3
	move 1,4
	move 2,5
	popj 17,

udivdi_global:
	move 1,gu_a
	move 2,gu_a+1
	lshc 1,-2
	popj 17,

udivdi_volatile:
	move 1,vgu_a
	move 2,vgu_a+1
	lshc 1,-3
	popj 17,

udivdi_high_const:
	move 1,[377777777777]
	move 2,[777777777777]
	popj 17,

udivdi_high_shifted:
	move 1,[20000000]
	move 2,[0]
	popj 17,

udivdi_store:
	lshc 2,-2
	movem 2,(1)
	movem 3,1(1)
	move 1,2
	move 2,3
	popj 17,

udivdi_store_mem:
	move 4,(2)
	move 5,1(2)
	lshc 4,-4
	movem 4,(1)
	movem 5,1(1)
	move 6,(1)
	move 7,5
	move 1,6
	move 2,7
	popj 17,

udivdi_update2:
	move 4,(1)
	move 5,1(1)
	lshc 4,-1
	movem 4,(1)
	movem 5,1(1)
	move 2,(1)
	move 3,5
	move 1,2
	move 2,3
	popj 17,

udivdi_update8:
	move 4,(1)
	move 5,1(1)
	lshc 4,-3
	movem 4,(1)
	movem 5,1(1)
	move 2,(1)
	move 3,5
	move 1,2
	move 2,3
	popj 17,

udivdi_struct:
	move 4,(1)
	move 5,1(1)
	lshc 4,-6
	move 1,4
	move 2,5
	popj 17,

udivdi_struct_store:
	move 4,2(1)
	move 5,3(1)
	lshc 4,-4
	movem 4,(2)
	movem 5,1(2)
	move 6,(2)
	move 7,5
	move 1,6
	move 2,7
	popj 17,

udivdi_array:
	lsh 2,1
	add 2,1
	move 4,(2)
	move 5,1(2)
	lshc 4,-2
	move 1,4
	move 2,5
	popj 17,

udivdi_array_store:
	lsh 2,1
	add 2,1
	move 4,2(2)
	move 5,3(2)
	lshc 4,-3
	movem 4,(2)
	movem 5,1(2)
	popj 17,

udivdi_branch:
	lshc 1,-3
	move 4,1
	ior 4,2
	movei 3,0
	jumpe 4,%L26
	cail 1,0
	cail 1,1
	jrst %L29
	jumpn 1,%L28
	cail 2,0
	caml 2,[1000000]
	trna
	jrst %L28
%L29:
	movei 3,2
%L26:
	move 1,3
	popj 17,
%L28:
	movei 3,1
	jrst %L26

udivdi_call_arg:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	lshc 10,-4
	move 1,10
	move 2,11
	pushj 17,sink_udint
	move 1,10
	move 2,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.globl	use_udivdi3
use_udivdi3:
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
	movsi 6,200000
	movem 6,-3(17)
	setzm -2(17)
	setzm -1(17)
	move 6,[123456701234]
	movem 6,(17)
	pushj 17,udivdi_div2
	pushj 17,sink_udint
	move 1,10
	move 2,11
	pushj 17,udivdi_div4
	pushj 17,sink_udint
	move 1,10
	move 2,11
	pushj 17,udivdi_div8
	pushj 17,sink_udint
	move 1,10
	move 2,11
	pushj 17,udivdi_div16
	pushj 17,sink_udint
	move 1,10
	move 2,11
	pushj 17,udivdi_div64
	pushj 17,sink_udint
	move 1,10
	move 2,11
	pushj 17,udivdi_div512
	pushj 17,sink_udint
	move 1,10
	move 2,11
	pushj 17,udivdi_div4096
	pushj 17,sink_udint
	move 1,10
	move 2,11
	pushj 17,udivdi_div_bigword
	pushj 17,sink_udint
	movei 12,-7(17)
	move 1,12
	pushj 17,udivdi_mem2
	pushj 17,sink_udint
	move 13,12
	addi 13,2
	move 1,13
	pushj 17,udivdi_mem8
	pushj 17,sink_udint
	pushj 17,udivdi_global
	pushj 17,sink_udint
	pushj 17,udivdi_volatile
	pushj 17,sink_udint
	pushj 17,udivdi_high_const
	pushj 17,sink_udint
	pushj 17,udivdi_high_shifted
	pushj 17,sink_udint
	movei 1,gu_b
	move 2,10
	move 3,11
	pushj 17,udivdi_store
	pushj 17,sink_udint
	move 1,12
	addi 1,6
	move 2,12
	addi 2,4
	pushj 17,udivdi_store_mem
	pushj 17,sink_udint
	move 1,12
	pushj 17,udivdi_update2
	pushj 17,sink_udint
	move 1,13
	pushj 17,udivdi_update8
	pushj 17,sink_udint
	movei 1,gu_pair
	pushj 17,udivdi_struct
	pushj 17,sink_udint
	movei 1,gu_pair
	movei 2,gu_slot
	pushj 17,udivdi_struct_store
	pushj 17,sink_udint
	move 2,14
	andi 2,3
	movei 1,gu_arr
	pushj 17,udivdi_array
	pushj 17,sink_udint
	andi 14,1
	move 1,12
	move 2,14
	pushj 17,udivdi_array_store
	move 1,10
	move 2,11
	pushj 17,udivdi_branch
	move 13,1
	ash 1,-43
	move 12,1
	move 1,12
	move 2,13
	pushj 17,sink_udint
	move 1,10
	move 2,11
	pushj 17,udivdi_call_arg
	move 12,1
	move 13,2
	pushj 17,sink_udint
	movem 12,vgu_b
	movem 13,vgu_b+1
	move 1,12
	move 2,13
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
