	.data
	.align	2
ashldi3_gb:
	.word	0
	.word	30071
	.align	2
ashldi3_ugb:
	.word	0
	.word	152061

	.globl	ashldi3
ashldi3:
	lshc 1,(3)
	popj 17,

uashldi3:
	lshc 1,(3)
	popj 17,

ashldi_reg_reg:
	lshc 1,(3)
	popj 17,

ashldi_ureg_ureg:
	lshc 1,(3)
	popj 17,

ashldi_mem_reg:
	move 4,(1)
	move 5,1(1)
	lshc 4,(2)
	move 1,4
	move 2,5
	popj 17,

ashldi_reg_mem:
	lshc 1,@(3)
	popj 17,

ashldi_mem_mem:
	move 4,(1)
	move 5,1(1)
	lshc 4,@(2)
	move 1,4
	move 2,5
	popj 17,

ashldi_volatile_value:
	move 4,1
	move 1,ashldi3_vga
	move 2,ashldi3_vga+1
	lshc 1,(4)
	popj 17,

ashldi_volatile_count:
	move 4,ashldi3_vcount
	lshc 1,(4)
	popj 17,

ashldi_uvolatile_value:
	move 4,1
	move 1,ashldi3_vuga
	move 2,ashldi3_vuga+1
	lshc 1,(4)
	popj 17,

ashldi_global_count:
	lshc 1,@ashldi3_counts+3
	popj 17,

ashldi_array_value:
	andi 1,7
	lsh 1,1
	move 4,ashldi3_buf(1)
	move 5,ashldi3_buf+1(1)
	lshc 4,(2)
	move 1,4
	move 2,5
	popj 17,

ashldi_array_count:
	andi 3,7
	lshc 1,@ashldi3_counts(3)
	popj 17,

ashldi_uarray_value:
	andi 1,7
	lsh 1,1
	move 4,ashldi3_ubuf(1)
	move 5,ashldi3_ubuf+1(1)
	lshc 4,(2)
	move 1,4
	move 2,5
	popj 17,

ashldi_struct_value:
	move 4,(1)
	move 5,1(1)
	lshc 4,(2)
	move 1,4
	move 2,5
	popj 17,

ashldi_struct_count:
	move 4,(1)
	move 5,1(1)
	lshc 4,@4(1)
	move 1,4
	move 2,5
	popj 17,

ashldi_struct_mix:
	push 17,10
	move 4,(1)
	move 5,1(1)
	lshc 4,(2)
	move 6,5(1)
	move 7,6(1)
	lshc 6,1
	move 2,5
	add 2,7
	move 3,2
	tlc 3,400000
	move 10,5
	tlc 10,400000
	caml 3,10
	tdza 3,3
	movei 3,1
	move 1,4
	add 1,6
	add 1,3
	pop 17,10
	popj 17,

ashldi_ustruct_value:
	move 4,(1)
	move 5,1(1)
	lshc 4,(2)
	move 1,4
	move 2,5
	popj 17,

ashldi_const_0:
	popj 17,

ashldi_const_1:
	lshc 1,1
	popj 17,

ashldi_const_2:
	lshc 1,2
	popj 17,

ashldi_const_3:
	lshc 1,3
	popj 17,

ashldi_const_4:
	lshc 1,4
	popj 17,

ashldi_const_8:
	lshc 1,10
	popj 17,

ashldi_const_17:
	lshc 1,21
	popj 17,

ashldi_const_18:
	lshc 1,22
	popj 17,

ashldi_const_19:
	lshc 1,23
	popj 17,

ashldi_const_35:
	lshc 1,43
	popj 17,

ashldi_const_36:
	lshc 1,44
	popj 17,

ashldi_const_37:
	lshc 1,45
	popj 17,

ashldi_const_63:
	lshc 1,77
	popj 17,

ashldi_const_70:
	lshc 1,106
	popj 17,

ashldi_uconst_1:
	lshc 1,1
	popj 17,

ashldi_uconst_18:
	lshc 1,22
	popj 17,

ashldi_uconst_36:
	lshc 1,44
	popj 17,

ashldi_uconst_70:
	lshc 1,106
	popj 17,

ashldi_mul2:
	lshc 1,1
	popj 17,

ashldi_mul4:
	lshc 1,2
	popj 17,

ashldi_umul8:
	lshc 1,3
	popj 17,

ashldi_store:
	lshc 2,(4)
	movem 2,(1)
	movem 3,1(1)
	move 1,2
	move 2,3
	popj 17,

ashldi_ustore:
	lshc 2,(4)
	movem 2,(1)
	movem 3,1(1)
	move 1,2
	move 2,3
	popj 17,

ashldi_update:
	move 4,(1)
	move 5,1(1)
	lshc 4,(2)
	movem 4,(1)
	movem 5,1(1)
	popj 17,

ashldi_update_const:
	move 4,(1)
	move 5,1(1)
	lshc 4,44
	movem 4,(1)
	movem 5,1(1)
	popj 17,

ashldi_update_assign:
	move 4,(1)
	move 5,1(1)
	lshc 4,(2)
	movem 4,(1)
	movem 5,1(1)
	popj 17,

ashldi_uupdate_assign:
	move 4,(1)
	move 5,1(1)
	lshc 4,(2)
	movem 4,(1)
	movem 5,1(1)
	popj 17,

ashldi_branch:
	lshc 1,(3)
	jumpl 1,%L48
	jumpn 1,%L47
	cail 2,0
	cail 2,0
	jrst %L47
%L48:
	seto 1,
%L46:
	popj 17,
%L47:
	move 4,1
	ior 4,2
	skipe 1,4
	movei 1,1
	popj 17,

ashldi_ubranch:
	move 6,1
	move 7,2
	lshc 6,(3)
	move 4,6
	ior 4,7
	movei 3,0
	jumpe 4,%L50
	move 3,6
	tlc 3,400000
	move 4,1
	tlc 4,400000
	camle 3,4
	jrst %L53
	camn 6,1
	jrst %L54
%L52:
	seto 3,
%L50:
	move 1,3
	popj 17,
%L54:
	move 3,7
	tlc 3,400000
	move 4,2
	tlc 4,400000
	camg 3,4
	jrst %L52
%L53:
	movei 3,1
	jrst %L50

ashldi_call_arg:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	lshc 10,(3)
	move 1,10
	move 2,11
	pushj 17,sink_dint
	move 1,10
	move 2,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

ashldi_ucall_arg:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	lshc 10,(3)
	move 1,10
	move 2,11
	pushj 17,sink_udint
	move 1,10
	move 2,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.globl	use_ashldi3
use_ashldi3:
	add 17,[32,,32]
	movem 16,-31(17)
	movei 0,-30(17)
	hrli 0,10
	blt 0,-23(17)
	setzm -7(17)
	setzm -6(17)
	setzm -5(17)
	setzm -4(17)
	setzm -3(17)
	setzm -2(17)
	move 14,1
	move 15,2
	move 16,-33(17)
	movem 1,-22(17)
	movem 15,-21(17)
	movem 3,-20(17)
	movem 4,-17(17)
	setzm -16(17)
	movei 6,7
	movem 6,-15(17)
	movem 16,-14(17)
	movei 7,22
	movem 7,-13(17)
	movei 6,44
	movem 6,-12(17)
	movem 1,ashldi3_ga
	movem 2,ashldi3_ga+1
	movem 3,ashldi3_gb
	movem 4,ashldi3_gb+1
	movem 1,ashldi3_gp
	movem 15,ashldi3_gp+1
	movem 3,ashldi3_gp+2
	movem 4,ashldi3_gp+3
	movem 1,ashldi3_gn
	movem 15,ashldi3_gn+1
	movem 3,ashldi3_gn+2
	movem 4,ashldi3_gn+3
	movem 16,ashldi3_gn+4
	movem 3,ashldi3_gn+5
	movem 4,ashldi3_gn+6
	move 3,16
	pushj 17,ashldi3
	move 6,1
	move 7,2
	move 1,14
	move 2,15
	move 3,16
	movem 6,-1(17)
	movem 7,(17)
	pushj 17,uashldi3
	move 6,-1(17)
	move 7,(17)
	move 11,7
	add 11,2
	move 4,11
	tlc 4,400000
	move 3,7
	tlc 3,400000
	caml 4,3
	tdza 4,4
	movei 4,1
	move 10,6
	add 10,1
	add 10,4
	move 1,14
	move 2,15
	move 3,16
	pushj 17,ashldi_reg_reg
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
	movei 7,-22(17)
	movem 7,-11(17)
	move 1,7
	move 2,16
	pushj 17,ashldi_mem_reg
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
	movei 6,-14(17)
	move 1,14
	move 2,15
	move 3,6
	movem 6,-1(17)
	pushj 17,ashldi_reg_mem
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
	move 7,-11(17)
	addi 7,2
	movem 7,-10(17)
	move 6,-1(17)
	addi 6,1
	move 1,7
	move 2,6
	pushj 17,ashldi_mem_mem
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
	move 1,16
	pushj 17,ashldi_volatile_value
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
	pushj 17,ashldi_volatile_count
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
	pushj 17,ashldi_global_count
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
	move 1,-34(17)
	move 2,16
	pushj 17,ashldi_array_value
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
	move 3,-34(17)
	pushj 17,ashldi_array_count
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
	movei 1,ashldi3_gp
	move 2,16
	pushj 17,ashldi_struct_value
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
	movei 1,ashldi3_gn
	pushj 17,ashldi_struct_count
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
	movei 1,ashldi3_gn
	move 2,16
	pushj 17,ashldi_struct_mix
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
	pushj 17,ashldi_const_0
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
	pushj 17,ashldi_const_1
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
	pushj 17,ashldi_const_2
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
	pushj 17,ashldi_const_3
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
	pushj 17,ashldi_const_4
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
	pushj 17,ashldi_const_8
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
	pushj 17,ashldi_const_17
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
	pushj 17,ashldi_const_18
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
	pushj 17,ashldi_const_19
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
	pushj 17,ashldi_const_35
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
	pushj 17,ashldi_const_36
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
	pushj 17,ashldi_const_37
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
	pushj 17,ashldi_const_63
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
	pushj 17,ashldi_const_70
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
	pushj 17,ashldi_uconst_1
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
	pushj 17,ashldi_uconst_18
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
	pushj 17,ashldi_uconst_36
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
	pushj 17,ashldi_uconst_70
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
	pushj 17,ashldi_mul2
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
	pushj 17,ashldi_mul4
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
	pushj 17,ashldi_umul8
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
	movei 1,ashldi3_gc
	move 2,14
	move 3,15
	move 4,16
	pushj 17,ashldi_store
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
	movei 1,ashldi3_uga
	move 2,14
	move 3,15
	move 4,16
	pushj 17,ashldi_ustore
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
	move 1,-11(17)
	move 2,16
	pushj 17,ashldi_update
	move 1,-10(17)
	pushj 17,ashldi_update_const
	movei 6,4
	addm 6,-11(17)
	move 4,-34(17)
	andi 4,1
	movei 7,-22(17)
	add 4,7
	move 1,-11(17)
	move 2,6(4)
	pushj 17,ashldi_update_assign
	movei 1,ashldi3_uga
	move 2,16
	pushj 17,ashldi_uupdate_assign
	move 6,-22(17)
	movem 6,-7(17)
	move 7,-21(17)
	movem 7,-6(17)
	move 5,7
	add 5,13
	move 3,5
	tlc 3,400000
	move 2,13
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 4,-7(17)
	add 4,12
	add 4,3
	move 6,-20(17)
	movem 6,-5(17)
	move 7,-17(17)
	movem 7,-4(17)
	move 3,7
	add 3,5
	move 1,3
	tlc 1,400000
	move 6,5
	tlc 6,400000
	caml 1,6
	tdza 1,1
	movei 1,1
	move 2,-5(17)
	add 2,4
	add 2,1
	move 6,-16(17)
	movem 6,-3(17)
	move 7,-15(17)
	movem 7,-2(17)
	add 7,3
	move 4,7
	tlc 4,400000
	move 1,3
	tlc 1,400000
	caml 4,1
	tdza 4,4
	movei 4,1
	move 6,-3(17)
	add 6,2
	add 6,4
	move 1,14
	move 2,15
	move 3,16
	movem 6,-1(17)
	movem 7,(17)
	pushj 17,ashldi_branch
	move 5,1
	ash 1,-43
	move 6,-1(17)
	move 7,(17)
	move 13,7
	add 13,5
	move 3,13
	tlc 3,400000
	move 2,7
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 12,6
	add 12,1
	add 12,3
	move 1,14
	move 2,15
	move 3,16
	pushj 17,ashldi_ubranch
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
	move 1,14
	move 2,15
	move 3,16
	pushj 17,ashldi_call_arg
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
	move 3,16
	pushj 17,ashldi_ucall_arg
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
	move 1,16
	pushj 17,ashldi_uvolatile_value
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
	move 1,-34(17)
	move 2,16
	pushj 17,ashldi_uarray_value
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
	movei 1,ashldi3_ugp
	move 2,16
	pushj 17,ashldi_ustruct_value
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
	move 3,16
	pushj 17,ashldi_ureg_ureg
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
	move 16,-31(17)
	movei 0,10
	hrli 0,-30(17)
	blt 0,15
	add 17,[-32,,-32]
	popj 17,

	.bss
ashldi3_ga:
	.space	8
ashldi3_gc:
	.space	8
ashldi3_uga:
	.space	8
ashldi3_vga:
	.space	8
ashldi3_vgb:
	.space	8
ashldi3_vuga:
	.space	8
ashldi3_vcount:
	.space	4
ashldi3_buf:
	.space	64
ashldi3_ubuf:
	.space	64
ashldi3_counts:
	.space	32
ashldi3_gp:
	.space	16
ashldi3_ugp:
	.space	16
ashldi3_gn:
	.space	28
