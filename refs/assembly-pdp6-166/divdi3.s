	.data
	.align	2
gd_a:
	.word	777777777777
	.word	777777416700
	.align	2
vgd_a:
	.word	777777777777
	.word	777742632117
	.align	2
gd_pair:
	.word	777777777777
	.word	777777552401
	.word	0
	.word	30071
	.align	2
gd_arr:
	.word	777777777777
	.word	777776777777
	.word	0
	.word	777777
	.word	777777777777
	.word	777777777733
	.word	0
	.word	4553207

divdi_by_2:
	jumpge 1,.+4
	jfcl 17,.+1
	addi 2,1
	jcry0 [aoja 1,.+1]
	lshc 1,-1
	tlne 1,200000
	tlo 1,400000
	popj 17,

divdi_by_4:
	jumpge 1,.+4
	jfcl 17,.+1
	addi 2,3
	jcry0 [aoja 1,.+1]
	lshc 1,-2
	tlne 1,100000
	tlo 1,600000
	popj 17,

divdi_by_8:
	jumpge 1,.+4
	jfcl 17,.+1
	addi 2,7
	jcry0 [aoja 1,.+1]
	lshc 1,-3
	tlne 1,40000
	tlo 1,700000
	popj 17,

divdi_by_16:
	jumpge 1,.+4
	jfcl 17,.+1
	addi 2,17
	jcry0 [aoja 1,.+1]
	lshc 1,-4
	tlne 1,20000
	tlo 1,740000
	popj 17,

divdi_by_64:
	jumpge 1,.+4
	jfcl 17,.+1
	addi 2,77
	jcry0 [aoja 1,.+1]
	lshc 1,-6
	tlne 1,4000
	tlo 1,770000
	popj 17,

divdi_by_512:
	jumpge 1,.+4
	jfcl 17,.+1
	addi 2,777
	jcry0 [aoja 1,.+1]
	lshc 1,-11
	tlne 1,400
	tlo 1,777000
	popj 17,

divdi_by_4096:
	jumpge 1,.+4
	jfcl 17,.+1
	addi 2,7777
	jcry0 [aoja 1,.+1]
	lshc 1,-14
	tlne 1,40
	tlo 1,777700
	popj 17,

divdi_by_262144:
	jumpge 1,.+4
	jfcl 17,.+1
	addi 2,777777
	jcry0 [aoja 1,.+1]
	lshc 1,-22
	trne 1,400000
	hrro 1,1
	popj 17,

divdi_mem_2:
	move 4,(1)
	move 5,1(1)
	move 1,4
	move 2,5
	jumpge 1,.+4
	jfcl 17,.+1
	addi 2,1
	jcry0 [aoja 1,.+1]
	lshc 1,-1
	tlne 1,200000
	tlo 1,400000
	popj 17,

divdi_mem_8:
	move 4,(1)
	move 5,1(1)
	move 1,4
	move 2,5
	jumpge 1,.+4
	jfcl 17,.+1
	addi 2,7
	jcry0 [aoja 1,.+1]
	lshc 1,-3
	tlne 1,40000
	tlo 1,700000
	popj 17,

divdi_global_4:
	move 1,gd_a
	move 2,gd_a+1
	jumpge 1,.+4
	jfcl 17,.+1
	addi 2,3
	jcry0 [aoja 1,.+1]
	lshc 1,-2
	tlne 1,100000
	tlo 1,600000
	popj 17,

divdi_volatile_16:
	move 1,vgd_a
	move 2,vgd_a+1
	jumpge 1,.+4
	jfcl 17,.+1
	addi 2,17
	jcry0 [aoja 1,.+1]
	lshc 1,-4
	tlne 1,20000
	tlo 1,740000
	popj 17,

divdi_neg_num_2:
	setca 1,
	jumpe 2,[aoja 1,.+2]
	movn 2,2
	jumpge 1,.+4
	jfcl 17,.+1
	addi 2,1
	jcry0 [aoja 1,.+1]
	lshc 1,-1
	tlne 1,200000
	tlo 1,400000
	popj 17,

divdi_sum_8:
	push 17,10
	move 7,2
	add 7,4
	move 5,7
	tlc 5,400000
	move 10,2
	tlc 10,400000
	caml 5,10
	tdza 5,5
	movei 5,1
	move 6,1
	add 6,3
	add 6,5
	move 1,6
	move 2,7
	jumpge 1,.+4
	jfcl 17,.+1
	addi 2,7
	jcry0 [aoja 1,.+1]
	lshc 1,-3
	tlne 1,40000
	tlo 1,700000
	pop 17,10
	popj 17,

divdi_diff_4:
	push 17,10
	move 7,2
	sub 7,4
	move 5,7
	tlc 5,400000
	move 10,2
	tlc 10,400000
	camg 5,10
	tdza 5,5
	movei 5,1
	move 6,1
	sub 6,3
	sub 6,5
	move 1,6
	move 2,7
	jumpge 1,.+4
	jfcl 17,.+1
	addi 2,3
	jcry0 [aoja 1,.+1]
	lshc 1,-2
	tlne 1,100000
	tlo 1,600000
	pop 17,10
	popj 17,

divdi_store_2:
	move 4,1
	move 1,2
	move 2,3
	jumpge 1,.+4
	jfcl 17,.+1
	addi 2,1
	jcry0 [aoja 1,.+1]
	lshc 1,-1
	tlne 1,200000
	tlo 1,400000
	movem 1,(4)
	movem 2,1(4)
	popj 17,

divdi_store_64:
	jumpge 2,.+4
	jfcl 17,.+1
	addi 3,77
	jcry0 [aoja 2,.+1]
	lshc 2,-6
	tlne 2,4000
	tlo 2,770000
	movem 2,(1)
	movem 3,1(1)
	move 4,(1)
	move 5,3
	move 1,4
	move 2,5
	popj 17,

divdi_update_2:
	move 4,(1)
	move 5,1(1)
	jumpge 4,.+4
	jfcl 17,.+1
	addi 5,1
	jcry0 [aoja 4,.+1]
	lshc 4,-1
	tlne 4,200000
	tlo 4,400000
	movem 4,(1)
	movem 5,1(1)
	popj 17,

divdi_update_8:
	move 4,(1)
	move 5,1(1)
	jumpge 4,.+4
	jfcl 17,.+1
	addi 5,7
	jcry0 [aoja 4,.+1]
	lshc 4,-3
	tlne 4,40000
	tlo 4,700000
	movem 4,(1)
	movem 5,1(1)
	popj 17,

divdi_struct_4:
	move 4,(1)
	move 5,1(1)
	move 1,4
	move 2,5
	jumpge 1,.+4
	jfcl 17,.+1
	addi 2,3
	jcry0 [aoja 1,.+1]
	lshc 1,-2
	tlne 1,100000
	tlo 1,600000
	popj 17,

divdi_struct_sum_16:
	push 17,10
	move 2,(1)
	move 3,1(1)
	move 6,2(1)
	move 7,3(1)
	move 5,3
	add 5,7
	move 1,5
	tlc 1,400000
	move 10,3
	tlc 10,400000
	caml 1,10
	tdza 1,1
	movei 1,1
	move 4,2
	add 4,6
	add 4,1
	move 1,4
	move 2,5
	jumpge 1,.+4
	jfcl 17,.+1
	addi 2,17
	jcry0 [aoja 1,.+1]
	lshc 1,-4
	tlne 1,20000
	tlo 1,740000
	pop 17,10
	popj 17,

divdi_struct_store:
	add 17,[13,,13]
	movem 16,-12(17)
	movei 0,-11(17)
	hrli 0,10
	blt 0,-4(17)
	setzm -3(17)
	setzm -2(17)
	setzm -1(17)
	setzm (17)
	move 10,2
	move 4,(1)
	move 5,1(1)
	jumpge 4,.+4
	jfcl 17,.+1
	addi 5,1
	jcry0 [aoja 4,.+1]
	lshc 4,-1
	tlne 4,200000
	tlo 4,400000
	movem 4,(10)
	movem 5,1(10)
	move 11,2(1)
	move 12,3(1)
	move 4,11
	move 5,12
	jumpge 4,.+4
	jfcl 17,.+1
	addi 5,3
	jcry0 [aoja 4,.+1]
	lshc 4,-2
	tlne 4,100000
	tlo 4,600000
	movem 4,2(10)
	movem 5,3(10)
	move 6,(1)
	move 7,1(1)
	move 15,2(1)
	move 16,3(1)
	move 5,7
	add 5,16
	move 3,5
	tlc 3,400000
	move 2,7
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 4,6
	add 4,15
	add 4,3
	move 6,4
	move 7,5
	jumpge 6,.+4
	jfcl 17,.+1
	addi 7,7
	jcry0 [aoja 6,.+1]
	lshc 6,-3
	tlne 6,40000
	tlo 6,700000
	movem 6,4(10)
	movem 7,5(10)
	move 13,(10)
	move 14,1(10)
	move 5,2(10)
	movem 5,-3(17)
	move 5,3(10)
	movem 5,-2(17)
	add 5,14
	move 3,5
	tlc 3,400000
	move 2,14
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 4,-3(17)
	add 4,13
	add 4,3
	move 10,4(10)
	movem 10,-1(17)
	movem 7,(17)
	move 2,7
	add 2,5
	move 3,2
	tlc 3,400000
	move 6,5
	tlc 6,400000
	caml 3,6
	tdza 3,3
	movei 3,1
	move 1,-1(17)
	add 1,4
	add 1,3
	move 16,-12(17)
	movei 0,10
	hrli 0,-11(17)
	blt 0,15
	add 17,[-13,,-13]
	popj 17,

divdi_array_2:
	lsh 2,1
	add 2,1
	move 4,(2)
	move 5,1(2)
	move 1,4
	move 2,5
	jumpge 1,.+4
	jfcl 17,.+1
	addi 2,1
	jcry0 [aoja 1,.+1]
	lshc 1,-1
	tlne 1,200000
	tlo 1,400000
	popj 17,

divdi_array_32:
	lsh 2,1
	add 2,1
	move 4,(2)
	move 5,1(2)
	move 1,4
	move 2,5
	jumpge 1,.+4
	jfcl 17,.+1
	addi 2,37
	jcry0 [aoja 1,.+1]
	lshc 1,-5
	tlne 1,10000
	tlo 1,760000
	popj 17,

divdi_branch_2:
	jumpge 1,.+4
	jfcl 17,.+1
	addi 2,1
	jcry0 [aoja 1,.+1]
	lshc 1,-1
	tlne 1,200000
	tlo 1,400000
	jumpl 1,%L56
	jumpn 1,%L55
	cail 2,0
	cail 2,0
	jrst %L55
%L56:
	seto 1,
%L53:
	popj 17,
%L55:
	move 4,1
	ior 4,2
	skipe 1,4
	movei 1,1
	popj 17,

divdi_call_arg_4:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	jumpge 10,.+4
	jfcl 17,.+1
	addi 11,3
	jcry0 [aoja 10,.+1]
	lshc 10,-2
	tlne 10,100000
	tlo 10,600000
	move 1,10
	move 2,11
	pushj 17,use_dint
	move 1,10
	move 2,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

divdi_chain:
	move 6,1
	move 7,2
	jumpge 6,.+4
	jfcl 17,.+1
	addi 7,1
	jcry0 [aoja 6,.+1]
	lshc 6,-1
	tlne 6,200000
	tlo 6,400000
	move 5,7
	addi 5,7
	move 3,5
	tlc 3,400000
	move 2,7
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 4,6
	add 4,3
	move 6,4
	move 7,5
	jumpge 6,.+4
	jfcl 17,.+1
	addi 7,3
	jcry0 [aoja 6,.+1]
	lshc 6,-2
	tlne 6,100000
	tlo 6,600000
	move 5,7
	subi 5,3
	move 3,5
	tlc 3,400000
	move 2,7
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 4,6
	subi 4,1
	add 4,3
	move 6,4
	move 7,5
	jumpge 6,.+4
	jfcl 17,.+1
	addi 7,7
	jcry0 [aoja 6,.+1]
	lshc 6,-3
	tlne 6,40000
	tlo 6,700000
	move 1,6
	move 2,7
	popj 17,

	.globl	udvdi3
udvdi3:
	add 17,[23,,23]
	movem 16,-22(17)
	movei 0,-21(17)
	hrli 0,10
	blt 0,-14(17)
	move 14,1
	move 15,2
	movem 3,-3(17)
	movem 4,-2(17)
	move 16,-24(17)
	movem 1,-13(17)
	movem 15,-12(17)
	move 6,-3(17)
	movem 6,-11(17)
	move 6,-2(17)
	movem 6,-10(17)
	andi 16,3
	move 4,16
	lsh 4,1
	move 6,gd_arr(4)
	movem 6,-7(17)
	move 4,gd_arr+1(4)
	movem 4,-6(17)
	hrloi 6,1777
	movem 6,-5(17)
	movsi 6,777777
	movem 6,-4(17)
	movei 1,gd_b
	move 2,14
	move 3,15
	pushj 17,divdi_store_2
	movem 1,gd_b
	movem 2,gd_b+1
	movei 6,-13(17)
	movem 6,-1(17)
	move 1,6
	pushj 17,divdi_update_2
	move 6,-1(17)
	addi 6,2
	movem 6,(17)
	move 1,6
	pushj 17,divdi_update_8
	move 1,14
	move 2,15
	pushj 17,divdi_by_2
	move 12,1
	move 13,2
	move 1,14
	move 2,15
	pushj 17,divdi_by_4
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
	pushj 17,divdi_by_8
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
	move 2,15
	pushj 17,divdi_by_16
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
	pushj 17,divdi_by_64
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
	move 2,15
	pushj 17,divdi_by_512
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
	pushj 17,divdi_by_4096
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
	move 2,15
	pushj 17,divdi_by_262144
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
	move 1,-1(17)
	pushj 17,divdi_mem_2
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
	move 1,(17)
	pushj 17,divdi_mem_8
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
	pushj 17,divdi_global_4
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
	pushj 17,divdi_volatile_16
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
	move 1,-3(17)
	move 2,-2(17)
	pushj 17,divdi_neg_num_2
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
	move 2,15
	move 3,-3(17)
	move 4,-2(17)
	pushj 17,divdi_sum_8
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
	move 3,-3(17)
	move 4,-2(17)
	pushj 17,divdi_diff_4
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
	move 1,-1(17)
	addi 1,4
	move 2,-3(17)
	move 3,-2(17)
	pushj 17,divdi_store_64
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
	movei 1,gd_pair
	pushj 17,divdi_struct_4
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
	movei 1,gd_pair
	pushj 17,divdi_struct_sum_16
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
	movei 1,gd_pair
	movei 2,gd_slot
	pushj 17,divdi_struct_store
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
	move 1,-1(17)
	move 2,16
	pushj 17,divdi_array_2
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
	movei 1,gd_arr
	move 2,16
	pushj 17,divdi_array_32
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
	move 2,15
	pushj 17,divdi_branch_2
	move 5,1
	ash 1,-43
	move 11,13
	add 11,5
	move 3,11
	tlc 3,400000
	move 2,13
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 10,12
	add 10,1
	add 10,3
	move 1,-3(17)
	move 2,-2(17)
	pushj 17,divdi_call_arg_4
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
	move 2,-2(17)
	add 2,15
	move 4,2
	tlc 4,400000
	move 3,15
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 1,-3(17)
	add 1,14
	add 1,4
	pushj 17,divdi_chain
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
	move 16,-22(17)
	movei 0,10
	hrli 0,-21(17)
	blt 0,15
	add 17,[-23,,-23]
	popj 17,

	.bss
gd_b:
	.space	8
gd_slot:
	.space	24
