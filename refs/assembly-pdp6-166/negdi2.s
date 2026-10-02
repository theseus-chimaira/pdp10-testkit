	.data
	.align	2
gn_a:
	.word	0
	.word	4553207
	.align	2
vgn_a:
	.word	777777777777
	.word	777742632117
	.align	2
gun_a:
	.word	0
	.word	123456701234
	.align	2
vgun_a:
	.word	777777777777
	.word	777777777777
	.align	2
gn_pair:
	.word	0
	.word	30071
	.word	777777777777
	.word	777777777733
	.align	2
gun_pair:
	.word	0
	.word	777777
	.word	777777777777
	.word	777777777777
	.align	2
gn_arr:
	.word	0
	.word	0
	.word	0
	.word	1
	.word	777777777777
	.word	777777777777
	.word	0
	.word	123456701234
	.align	2
gun_arr:
	.word	0
	.word	0
	.word	0
	.word	1
	.word	777777777777
	.word	777777777777
	.word	0
	.word	123456701234

negdi_reg:
	setca 1,
	jumpe 2,[aoja 1,.+2]
	movn 2,2
	popj 17,

negdi_zero_sub:
	setca 1,
	jumpe 2,[aoja 1,.+2]
	movn 2,2
	popj 17,

negdi_mem:
	move 4,(1)
	move 5,1(1)
	setca 4,
	jumpe 5,[aoja 4,.+2]
	movn 5,5
	move 1,4
	move 2,5
	popj 17,

negdi_global:
	setcm 1,gn_a
	movn 2,gn_a+1
	jumpe 2,[aoja 1,.+1]
	popj 17,

negdi_volatile:
	move 1,vgn_a
	move 2,vgn_a+1
	setca 1,
	jumpe 2,[aoja 1,.+2]
	movn 2,2
	popj 17,

negdi_const_zero:
	setzb 1,2
	popj 17,

negdi_const_one:
	seto 1,
	movni 2,1
	popj 17,

negdi_const_minus_one:
	movei 1,0
	movei 2,1
	popj 17,

negdi_store:
	setca 2,
	jumpe 3,[aoja 2,.+2]
	movn 3,3
	movem 2,(1)
	movem 3,1(1)
	move 1,2
	move 2,3
	popj 17,

negdi_store_mem:
	move 4,(2)
	move 5,1(2)
	setca 4,
	jumpe 5,[aoja 4,.+2]
	movn 5,5
	movem 4,(1)
	movem 5,1(1)
	move 6,(1)
	move 7,5
	move 1,6
	move 2,7
	popj 17,

negdi_update:
	move 4,(1)
	move 5,1(1)
	setca 4,
	jumpe 5,[aoja 4,.+2]
	movn 5,5
	movem 4,(1)
	movem 5,1(1)
	move 2,(1)
	move 3,5
	move 1,2
	move 2,3
	popj 17,

negdi_struct:
	move 4,(1)
	move 5,1(1)
	setca 4,
	jumpe 5,[aoja 4,.+2]
	movn 5,5
	move 1,4
	move 2,5
	popj 17,

negdi_struct_store:
	move 4,(1)
	move 5,1(1)
	setca 4,
	jumpe 5,[aoja 4,.+2]
	movn 5,5
	movem 4,2(1)
	movem 5,3(1)
	move 2,2(1)
	move 3,5
	move 1,2
	move 2,3
	popj 17,

negdi_array:
	lsh 2,1
	add 2,1
	move 4,(2)
	move 5,1(2)
	setca 4,
	jumpe 5,[aoja 4,.+2]
	movn 5,5
	move 1,4
	move 2,5
	popj 17,

negdi_array_store:
	lsh 2,1
	add 2,1
	move 4,2(2)
	move 5,3(2)
	setca 4,
	jumpe 5,[aoja 4,.+2]
	movn 5,5
	movem 4,(2)
	movem 5,1(2)
	popj 17,

negdi_branch:
	setca 1,
	jumpe 2,[aoja 1,.+2]
	movn 2,2
	jumpl 1,%L21
	jumpn 1,%L20
	cail 2,0
	cail 2,0
	jrst %L20
%L21:
	seto 1,
%L19:
	popj 17,
%L20:
	move 4,1
	ior 4,2
	skipe 1,4
	movei 1,1
	popj 17,

negdi_call_arg:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setcm 10,1
	movn 11,2
	jumpe 11,[aoja 10,.+1]
	move 1,10
	move 2,11
	pushj 17,sink_dint
	move 1,10
	move 2,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

negdi_mix:
	push 17,10
	setcm 6,1
	movn 7,2
	jumpe 7,[aoja 6,.+1]
	setca 3,
	jumpe 4,[aoja 3,.+2]
	movn 4,4
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

unegdi_reg:
	setca 1,
	jumpe 2,[aoja 1,.+2]
	movn 2,2
	popj 17,

unegdi_zero_sub:
	setca 1,
	jumpe 2,[aoja 1,.+2]
	movn 2,2
	popj 17,

unegdi_mem:
	move 4,(1)
	move 5,1(1)
	setca 4,
	jumpe 5,[aoja 4,.+2]
	movn 5,5
	move 1,4
	move 2,5
	popj 17,

unegdi_global:
	setcm 1,gun_a
	movn 2,gun_a+1
	jumpe 2,[aoja 1,.+1]
	popj 17,

unegdi_volatile:
	move 1,vgun_a
	move 2,vgun_a+1
	setca 1,
	jumpe 2,[aoja 1,.+2]
	movn 2,2
	popj 17,

unegdi_store:
	setca 2,
	jumpe 3,[aoja 2,.+2]
	movn 3,3
	movem 2,(1)
	movem 3,1(1)
	move 1,2
	move 2,3
	popj 17,

unegdi_update:
	move 4,(1)
	move 5,1(1)
	setca 4,
	jumpe 5,[aoja 4,.+2]
	movn 5,5
	movem 4,(1)
	movem 5,1(1)
	move 2,(1)
	move 3,5
	move 1,2
	move 2,3
	popj 17,

unegdi_struct:
	move 4,(1)
	move 5,1(1)
	setca 4,
	jumpe 5,[aoja 4,.+2]
	movn 5,5
	move 1,4
	move 2,5
	popj 17,

unegdi_struct_store:
	move 4,(1)
	move 5,1(1)
	setca 4,
	jumpe 5,[aoja 4,.+2]
	movn 5,5
	movem 4,2(1)
	movem 5,3(1)
	move 2,2(1)
	move 3,5
	move 1,2
	move 2,3
	popj 17,

unegdi_array:
	lsh 2,1
	add 2,1
	move 4,(2)
	move 5,1(2)
	setca 4,
	jumpe 5,[aoja 4,.+2]
	movn 5,5
	move 1,4
	move 2,5
	popj 17,

unegdi_array_store:
	lsh 2,1
	add 2,1
	move 4,2(2)
	move 5,3(2)
	setca 4,
	jumpe 5,[aoja 4,.+2]
	movn 5,5
	movem 4,(2)
	movem 5,1(2)
	popj 17,

unegdi_call_arg:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setcm 10,1
	movn 11,2
	jumpe 11,[aoja 10,.+1]
	move 1,10
	move 2,11
	pushj 17,sink_udint
	move 1,10
	move 2,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.globl	use_negdi2
use_negdi2:
	add 17,[20,,20]
	movei 0,-17(17)
	hrli 0,10
	blt 0,-12(17)
	movem 1,-3(17)
	movem 2,-2(17)
	movem 3,-1(17)
	movem 4,(17)
	move 15,-21(17)
	move 6,-3(17)
	movem 6,-11(17)
	move 6,-2(17)
	movem 6,-10(17)
	move 6,-1(17)
	movem 6,-7(17)
	move 6,(17)
	movem 6,-6(17)
	hrloi 6,1777
	movem 6,-5(17)
	hrroi 6,777763
	movem 6,-4(17)
	movei 1,gn_b
	move 2,-3(17)
	move 3,-2(17)
	pushj 17,negdi_store
	movem 1,gn_b
	movem 2,gn_b+1
	pushj 17,negdi_volatile
	movem 1,vgn_b
	movem 2,vgn_b+1
	movei 14,-11(17)
	move 2,15
	andi 2,1
	move 1,14
	pushj 17,negdi_array_store
	move 1,-3(17)
	move 2,-2(17)
	pushj 17,negdi_reg
	move 10,1
	move 11,2
	move 1,-1(17)
	move 2,(17)
	pushj 17,negdi_zero_sub
	move 13,11
	add 13,2
	move 4,13
	tlc 4,400000
	move 3,11
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 12,10
	add 12,1
	add 12,4
	move 1,14
	pushj 17,negdi_mem
	move 11,13
	add 11,2
	move 4,11
	tlc 4,400000
	move 3,13
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 10,12
	add 10,1
	add 10,4
	pushj 17,negdi_global
	move 5,11
	add 5,2
	move 3,5
	tlc 3,400000
	move 6,11
	tlc 6,400000
	caml 3,6
	tdza 3,3
	movei 3,1
	move 4,10
	add 4,1
	add 4,3
	move 6,vgn_b
	move 7,vgn_b+1
	move 11,5
	add 11,7
	move 3,11
	tlc 3,400000
	move 2,5
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 10,4
	add 10,6
	add 10,3
	pushj 17,negdi_const_zero
	move 13,11
	add 13,2
	move 4,13
	tlc 4,400000
	move 3,11
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 12,10
	add 12,1
	add 12,4
	pushj 17,negdi_const_one
	move 11,13
	add 11,2
	move 4,11
	tlc 4,400000
	move 3,13
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 10,12
	add 10,1
	add 10,4
	pushj 17,negdi_const_minus_one
	move 13,11
	add 13,2
	move 4,13
	tlc 4,400000
	move 3,11
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 12,10
	add 12,1
	add 12,4
	move 1,14
	addi 1,4
	move 2,14
	addi 2,2
	pushj 17,negdi_store_mem
	move 11,13
	add 11,2
	move 4,11
	tlc 4,400000
	move 3,13
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 10,12
	add 10,1
	add 10,4
	move 1,14
	pushj 17,negdi_update
	move 13,11
	add 13,2
	move 4,13
	tlc 4,400000
	move 3,11
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 12,10
	add 12,1
	add 12,4
	movei 1,gn_pair
	pushj 17,negdi_struct
	move 11,13
	add 11,2
	move 4,11
	tlc 4,400000
	move 3,13
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 10,12
	add 10,1
	add 10,4
	movei 1,gn_pair
	pushj 17,negdi_struct_store
	move 13,11
	add 13,2
	move 4,13
	tlc 4,400000
	move 3,11
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 12,10
	add 12,1
	add 12,4
	andi 15,3
	movei 1,gn_arr
	move 2,15
	pushj 17,negdi_array
	move 15,13
	add 15,2
	move 4,15
	tlc 4,400000
	move 3,13
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 14,12
	add 14,1
	add 14,4
	move 1,-3(17)
	move 2,-2(17)
	pushj 17,negdi_branch
	move 5,1
	ash 1,-43
	move 11,15
	add 11,5
	move 3,11
	tlc 3,400000
	move 2,15
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 10,14
	add 10,1
	add 10,3
	move 1,-1(17)
	move 2,(17)
	pushj 17,negdi_call_arg
	move 13,11
	add 13,2
	move 4,13
	tlc 4,400000
	move 3,11
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 12,10
	add 12,1
	add 12,4
	move 1,-3(17)
	move 2,-2(17)
	move 3,-1(17)
	move 4,(17)
	pushj 17,negdi_mix
	move 6,1
	move 7,2
	move 2,13
	add 2,7
	move 4,2
	tlc 4,400000
	move 3,13
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 1,12
	add 1,6
	add 1,4
	movei 0,10
	hrli 0,-17(17)
	blt 0,15
	add 17,[-20,,-20]
	popj 17,

	.globl	use_unegdi2
use_unegdi2:
	add 17,[15,,15]
	movem 16,-14(17)
	movei 0,-13(17)
	hrli 0,10
	blt 0,-6(17)
	move 10,1
	move 11,2
	move 14,3
	move 15,4
	movem 1,-5(17)
	movem 11,-4(17)
	movem 3,-3(17)
	movem 15,-2(17)
	setom -1(17)
	hrroi 6,777763
	movem 6,(17)
	movei 1,gun_b
	move 2,10
	move 3,11
	pushj 17,unegdi_store
	movem 1,gun_b
	movem 2,gun_b+1
	pushj 17,unegdi_volatile
	movem 1,vgun_b
	movem 2,vgun_b+1
	movei 16,-5(17)
	move 2,-16(17)
	andi 2,1
	move 1,16
	pushj 17,unegdi_array_store
	move 1,10
	move 2,11
	pushj 17,unegdi_reg
	move 10,1
	move 11,2
	move 1,14
	move 2,15
	pushj 17,unegdi_zero_sub
	move 13,11
	add 13,2
	move 4,13
	tlc 4,400000
	move 3,11
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 12,10
	add 12,1
	add 12,4
	move 1,16
	pushj 17,unegdi_mem
	move 11,13
	add 11,2
	move 4,11
	tlc 4,400000
	move 3,13
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 10,12
	add 10,1
	add 10,4
	pushj 17,unegdi_global
	move 5,11
	add 5,2
	move 3,5
	tlc 3,400000
	move 6,11
	tlc 6,400000
	caml 3,6
	tdza 3,3
	movei 3,1
	move 4,10
	add 4,1
	add 4,3
	move 6,vgun_b
	move 7,vgun_b+1
	move 11,5
	add 11,7
	move 3,11
	tlc 3,400000
	move 2,5
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 10,4
	add 10,6
	add 10,3
	move 1,16
	pushj 17,unegdi_update
	move 13,11
	add 13,2
	move 4,13
	tlc 4,400000
	move 3,11
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 12,10
	add 12,1
	add 12,4
	movei 1,gun_pair
	pushj 17,unegdi_struct
	move 11,13
	add 11,2
	move 4,11
	tlc 4,400000
	move 3,13
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 10,12
	add 10,1
	add 10,4
	movei 1,gun_pair
	pushj 17,unegdi_struct_store
	move 13,11
	add 13,2
	move 4,13
	tlc 4,400000
	move 3,11
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 12,10
	add 12,1
	add 12,4
	movei 6,3
	andm 6,-16(17)
	movei 1,gun_arr
	move 2,-16(17)
	pushj 17,unegdi_array
	move 11,13
	add 11,2
	move 4,11
	tlc 4,400000
	move 3,13
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 10,12
	add 10,1
	add 10,4
	move 1,14
	move 2,15
	pushj 17,unegdi_call_arg
	move 6,1
	move 7,2
	move 2,11
	add 2,7
	move 4,2
	tlc 4,400000
	move 3,11
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 1,10
	add 1,6
	add 1,4
	move 16,-14(17)
	movei 0,10
	hrli 0,-13(17)
	blt 0,15
	add 17,[-15,,-15]
	popj 17,

	.bss
gn_b:
	.space	8
vgn_b:
	.space	8
gun_b:
	.space	8
vgun_b:
	.space	8
