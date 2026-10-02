	.data
	.align	2
iordi3_gb:
	.long	0
	.long	1
	.align	2
iordi3_ugb:
	.long	0
	.long	1

make_iordi3_dint:
	move 3,1
	move 4,2
	move 2,1
	ash 3,-43
	move 1,3
	lshc 1,45
	tlne 1,400000
	tlo 2,400000
	move 5,4
	movei 4,0
	ior 1,4
	ior 2,5
	popj 17,

make_iordi3_udint:
	move 5,1
	movei 4,0
	lshc 4,45
	tlne 4,400000
	tlo 5,400000
	move 3,2
	movei 2,0
	ior 4,2
	ior 5,3
	move 1,4
	move 2,5
	popj 17,

iordi_reg_reg:
	ior 1,3
	ior 2,4
	popj 17,

iordi_ureg_ureg:
	ior 1,3
	ior 2,4
	popj 17,

iordi_reg_mem:
	move 4,(3)
	move 5,1(3)
	ior 1,4
	ior 2,5
	popj 17,

iordi_mem_reg:
	move 4,(1)
	move 5,1(1)
	ior 4,2
	ior 5,3
	move 1,4
	move 2,5
	popj 17,

iordi_mem_mem:
	move 4,(1)
	move 5,1(1)
	move 6,(2)
	move 7,1(2)
	ior 4,6
	ior 5,7
	move 1,4
	move 2,5
	popj 17,

iordi_umem_umem:
	move 4,(1)
	move 5,1(1)
	move 6,(2)
	move 7,1(2)
	ior 4,6
	ior 5,7
	move 1,4
	move 2,5
	popj 17,

iordi_or_zero:
	popj 17,

iordi_or_allones:
	seto 1,
	movni 2,1
	popj 17,

iordi_or_one:
	iori 2,1
	popj 17,

iordi_or_low18:
	hllo 2,2
	popj 17,

iordi_or_low_word:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	movei 1,0
	seto 2,
	pushj 17,make_iordi3_dint
	ior 10,1
	ior 11,2
	move 1,10
	move 2,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

iordi_or_high_word:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	seto 1,
	movei 2,0
	pushj 17,make_iordi3_dint
	ior 10,1
	ior 11,2
	move 1,10
	move 2,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

iordi_or_cross_mask:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	movei 1,123456
	movei 2,654321
	pushj 17,make_iordi3_dint
	ior 10,1
	ior 11,2
	move 1,10
	move 2,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

iordi_uor_zero:
	popj 17,

iordi_uor_allones:
	seto 1,
	seto 2,
	popj 17,

iordi_uor_cross_mask:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	movei 1,707070
	movei 2,70707
	pushj 17,make_iordi3_udint
	ior 10,1
	ior 11,2
	move 1,10
	move 2,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

iordi_global:
	move 1,iordi3_ga
	move 2,iordi3_ga+1
	move 4,iordi3_gb
	move 5,iordi3_gb+1
	ior 1,4
	ior 2,5
	popj 17,

iordi_uglobal:
	move 1,iordi3_uga
	move 2,iordi3_uga+1
	move 4,iordi3_ugb
	move 5,iordi3_ugb+1
	ior 1,4
	ior 2,5
	popj 17,

iordi_volatile:
	move 1,iordi3_vga
	move 2,iordi3_vga+1
	move 4,iordi3_vgb
	move 5,iordi3_vgb+1
	ior 1,4
	ior 2,5
	popj 17,

iordi_uvolatile:
	move 1,iordi3_vuga
	move 2,iordi3_vuga+1
	hllo 2,2
	popj 17,

iordi_array:
	lsh 1,1
	lsh 2,1
	move 4,iordi3_buf(1)
	move 5,iordi3_buf+1(1)
	move 6,iordi3_buf(2)
	move 7,iordi3_buf+1(2)
	ior 4,6
	ior 5,7
	move 1,4
	move 2,5
	popj 17,

iordi_uarray:
	lsh 1,1
	lsh 2,1
	move 4,iordi3_ubuf(1)
	move 5,iordi3_ubuf+1(1)
	move 6,iordi3_ubuf(2)
	move 7,iordi3_ubuf+1(2)
	ior 4,6
	ior 5,7
	move 1,4
	move 2,5
	popj 17,

iordi_struct:
	move 4,(1)
	move 5,1(1)
	move 2,2(1)
	move 3,3(1)
	ior 4,2
	ior 5,3
	move 1,4
	move 2,5
	popj 17,

iordi_ustruct:
	move 4,(1)
	move 5,1(1)
	move 2,2(1)
	move 3,3(1)
	ior 4,2
	ior 5,3
	move 1,4
	move 2,5
	popj 17,

iordi_nested:
	move 4,(1)
	move 5,1(1)
	move 2,2(1)
	move 3,3(1)
	ior 4,2
	ior 5,3
	move 6,4(1)
	move 7,5(1)
	ior 4,6
	ior 5,7
	move 1,4
	move 2,5
	popj 17,

iordi_store:
	add 17,[1,,1]
	move 0,-1(17)
	movem 0,(17)
	movem 4,-1(17)
	move 6,-2(17)
	ior 2,6
	ior 3,4
	movem 2,(1)
	movem 3,1(1)
	move 1,2
	move 2,3
	move 0,(17)
	movem 0,-1(17)
	add 17,[-1,,-1]
	popj 17,

iordi_ustore:
	add 17,[1,,1]
	move 0,-1(17)
	movem 0,(17)
	movem 4,-1(17)
	move 6,-2(17)
	ior 2,6
	ior 3,4
	movem 2,(1)
	movem 3,1(1)
	move 1,2
	move 2,3
	move 0,(17)
	movem 0,-1(17)
	add 17,[-1,,-1]
	popj 17,

iordi_update_reg:
	move 4,(1)
	move 5,1(1)
	ior 4,2
	ior 5,3
	movem 4,(1)
	movem 5,1(1)
	popj 17,

iordi_update_low18:
	move 5,1(1)
	hllo 5,5
	movem 5,1(1)
	popj 17,

iordi_update_allones:
	hrloi 6,1777
	movem 6,(1)
	setom 1(1)
	popj 17,

iordi_update_cross:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	movei 1,700000
	movei 2,7777
	pushj 17,make_iordi3_dint
	move 10,(12)
	move 11,1(12)
	ior 10,1
	ior 11,2
	movem 10,(12)
	movem 11,1(12)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

iordi_branch:
	move 6,1
	ior 6,3
	move 7,2
	ior 7,4
	move 4,6
	ior 4,7
	movei 1,0
	jumpe 4,%L34
	jumpl 6,%L37
	jumpn 6,%L36
	cail 7,0
	cail 7,0
	jrst %L36
%L37:
	seto 1,
%L34:
	popj 17,
%L36:
	movei 1,1
	popj 17,

iordi_call:
	ior 1,3
	ior 2,4
	jrst sink_dint

iordi_ucall:
	ior 1,3
	ior 2,4
	jrst sink_udint

	.globl	use_iordi3
use_iordi3:
	add 17,[17,,17]
	movem 16,-16(17)
	movei 0,-15(17)
	hrli 0,10
	blt 0,-10(17)
	movem 1,-7(17)
	movem 2,-6(17)
	movem 3,-5(17)
	movem 4,-4(17)
	move 16,-20(17)
	move 6,-7(17)
	movem 6,iordi3_buf
	move 6,-6(17)
	movem 6,iordi3_buf+1
	move 6,-5(17)
	movem 6,iordi3_buf+2
	move 6,-4(17)
	movem 6,iordi3_buf+3
	movei 1,123456
	movei 2,654321
	pushj 17,make_iordi3_dint
	movem 1,iordi3_buf+4
	movem 2,iordi3_buf+5
	move 6,-7(17)
	movem 6,iordi3_ubuf
	move 6,-6(17)
	movem 6,iordi3_ubuf+1
	move 6,-5(17)
	movem 6,iordi3_ubuf+2
	move 6,-4(17)
	movem 6,iordi3_ubuf+3
	move 6,-7(17)
	movem 6,iordi3_gp
	move 6,-6(17)
	movem 6,iordi3_gp+1
	move 6,-5(17)
	movem 6,iordi3_gp+2
	move 6,-4(17)
	movem 6,iordi3_gp+3
	move 6,-7(17)
	movem 6,iordi3_ugp
	move 6,-6(17)
	movem 6,iordi3_ugp+1
	move 6,-5(17)
	movem 6,iordi3_ugp+2
	move 6,-4(17)
	movem 6,iordi3_ugp+3
	move 4,[iordi3_gp,,iordi3_gn]
	blt 4,iordi3_gn+3
	move 6,iordi3_buf+4
	movem 6,iordi3_gn+4
	movem 2,iordi3_gn+5
	move 1,-7(17)
	move 2,-6(17)
	move 3,-5(17)
	move 4,-4(17)
	pushj 17,iordi_reg_reg
	move 12,1
	move 13,2
	move 1,-7(17)
	move 2,-6(17)
	movei 3,iordi3_buf+2
	pushj 17,iordi_reg_mem
	move 10,12
	ior 10,1
	move 11,13
	ior 11,2
	movei 1,iordi3_buf
	move 2,-5(17)
	move 3,-4(17)
	pushj 17,iordi_mem_reg
	move 12,10
	ior 12,1
	move 13,11
	ior 13,2
	movei 1,iordi3_buf
	movei 2,iordi3_buf+2
	pushj 17,iordi_mem_mem
	move 10,12
	ior 10,1
	move 11,13
	ior 11,2
	move 1,-7(17)
	move 2,-6(17)
	pushj 17,iordi_or_zero
	move 12,10
	ior 12,1
	move 13,11
	ior 13,2
	move 1,-5(17)
	move 2,-4(17)
	pushj 17,iordi_or_allones
	move 10,12
	ior 10,1
	move 11,13
	ior 11,2
	move 1,-7(17)
	move 2,-6(17)
	pushj 17,iordi_or_one
	move 12,10
	ior 12,1
	move 13,11
	ior 13,2
	move 1,-7(17)
	move 2,-6(17)
	pushj 17,iordi_or_low18
	move 14,12
	ior 14,1
	move 15,13
	ior 15,2
	move 1,-7(17)
	move 2,-6(17)
	pushj 17,iordi_or_low_word
	move 10,1
	move 11,2
	ior 10,14
	ior 11,15
	move 1,-5(17)
	move 2,-4(17)
	pushj 17,iordi_or_high_word
	move 12,1
	move 13,2
	ior 12,10
	ior 13,11
	move 1,-7(17)
	move 2,-6(17)
	pushj 17,iordi_or_cross_mask
	move 10,1
	move 11,2
	ior 10,12
	ior 11,13
	pushj 17,iordi_global
	move 12,10
	ior 12,1
	move 13,11
	ior 13,2
	pushj 17,iordi_volatile
	move 14,1
	move 15,2
	ior 14,12
	ior 15,13
	move 6,16
	andi 6,1
	movem 6,-3(17)
	addi 16,1
	andi 16,1
	move 1,6
	move 2,16
	pushj 17,iordi_array
	move 10,14
	ior 10,1
	move 11,15
	ior 11,2
	movei 1,iordi3_gp
	pushj 17,iordi_struct
	move 12,10
	ior 12,1
	move 13,11
	ior 13,2
	movei 1,iordi3_gn
	pushj 17,iordi_nested
	move 10,12
	ior 10,1
	move 11,13
	ior 11,2
	move 6,-5(17)
	movem 6,(17)
	move 4,-4(17)
	movei 1,iordi3_gc
	move 2,-7(17)
	move 3,-6(17)
	pushj 17,iordi_store
	move 6,10
	ior 6,1
	movem 6,-2(17)
	move 6,11
	ior 6,2
	movem 6,-1(17)
	movei 1,iordi3_gc
	move 2,-2(17)
	move 3,-1(17)
	pushj 17,iordi_update_reg
	movei 1,iordi3_gc
	pushj 17,iordi_update_low18
	movei 1,iordi3_gc
	pushj 17,iordi_update_allones
	movei 1,iordi3_gc
	pushj 17,iordi_update_cross
	move 1,-7(17)
	move 2,-6(17)
	move 3,-5(17)
	move 4,-4(17)
	pushj 17,iordi_ureg_ureg
	move 12,1
	move 13,2
	movei 1,iordi3_ubuf
	movei 2,iordi3_ubuf+2
	pushj 17,iordi_umem_umem
	move 10,12
	ior 10,1
	move 11,13
	ior 11,2
	move 1,-7(17)
	move 2,-6(17)
	pushj 17,iordi_uor_zero
	move 12,10
	ior 12,1
	move 13,11
	ior 13,2
	move 1,-5(17)
	move 2,-4(17)
	pushj 17,iordi_uor_allones
	move 14,12
	ior 14,1
	move 15,13
	ior 15,2
	move 1,-7(17)
	move 2,-6(17)
	pushj 17,iordi_uor_cross_mask
	move 10,1
	move 11,2
	ior 10,14
	ior 11,15
	pushj 17,iordi_uglobal
	move 12,10
	ior 12,1
	move 13,11
	ior 13,2
	pushj 17,iordi_uvolatile
	move 10,1
	move 11,2
	ior 10,12
	ior 11,13
	move 1,-3(17)
	move 2,16
	pushj 17,iordi_uarray
	move 12,10
	ior 12,1
	move 13,11
	ior 13,2
	movei 1,iordi3_ugp
	pushj 17,iordi_ustruct
	move 10,12
	ior 10,1
	move 11,13
	ior 11,2
	move 6,-5(17)
	movem 6,(17)
	move 4,-4(17)
	movei 1,iordi3_uga
	move 2,-7(17)
	move 3,-6(17)
	pushj 17,iordi_ustore
	move 12,1
	move 13,2
	ior 12,10
	ior 13,11
	move 1,-7(17)
	move 2,-6(17)
	move 3,-5(17)
	move 4,-4(17)
	pushj 17,iordi_call
	move 1,-7(17)
	move 2,-6(17)
	move 3,-5(17)
	move 4,-4(17)
	pushj 17,iordi_ucall
	move 10,-2(17)
	ior 10,12
	move 11,-1(17)
	ior 11,13
	move 1,-7(17)
	move 2,-6(17)
	move 3,-5(17)
	move 4,-4(17)
	pushj 17,iordi_branch
	move 5,1
	ash 1,-43
	ior 10,1
	ior 11,5
	move 4,iordi3_gc
	move 5,iordi3_gc+1
	ior 10,4
	ior 11,5
	move 1,10
	move 2,11
	move 16,-16(17)
	movei 0,10
	hrli 0,-15(17)
	blt 0,15
	add 17,[-17,,-17]
	popj 17,

	.bss
iordi3_ga:
	.space	8
iordi3_gc:
	.space	8
iordi3_uga:
	.space	8
iordi3_vga:
	.space	8
iordi3_vgb:
	.space	8
iordi3_vuga:
	.space	8
iordi3_buf:
	.space	64
iordi3_ubuf:
	.space	64
iordi3_gp:
	.space	16
iordi3_ugp:
	.space	16
iordi3_gn:
	.space	24
