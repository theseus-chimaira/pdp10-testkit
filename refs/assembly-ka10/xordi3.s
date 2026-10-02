	.data
	.align	2
gx_a:
	.long	0
	.long	11219468956
	.align	2
gx_b:
	.long	0
	.long	1402433620
	.align	2
vgx_a:
	.long	0
	.long	2054353
	.align	2
vgx_b:
	.long	68719476735
	.long	68719134345
	.align	2
gux_a:
	.long	0
	.long	11219468956
	.align	2
gux_b:
	.long	68719476735
	.long	68719476735
	.align	2
vgux_a:
	.long	1
	.long	32957304748
	.align	2
vgux_b:
	.long	68719476735
	.long	68719476735
	.align	2
gx_low18_mask:
	.long	0
	.long	262143
	.align	2
gx_low_word_mask:
	.long	1
	.long	34359738367
	.align	2
gx_high_word_mask:
	.long	68719476734
	.long	34359738368
	.align	2
gx_cross_mask:
	.long	85596
	.long	219345
	.align	2
gux_low18_mask:
	.long	0
	.long	262143
	.align	2
gux_low_word_mask:
	.long	1
	.long	34359738367
	.align	2
gux_high_word_mask:
	.long	68719476734
	.long	34359738368
	.align	2
gux_cross_mask:
	.long	466032
	.long	29127
	.align	2
gx_pair:
	.long	0
	.long	342391
	.long	68719476735
	.long	68717422383
	.long	0
	.long	0
	.align	2
gux_pair:
	.long	0
	.long	262143
	.long	68719476735
	.long	68719476735
	.long	0
	.long	0
	.align	2
gx_arr:
	.long	0
	.long	0
	.long	0
	.long	1
	.long	68719476735
	.long	68719476735
	.long	0
	.long	11219468956
	.align	2
gux_arr:
	.long	0
	.long	0
	.long	0
	.long	1
	.long	68719476735
	.long	68719476735
	.long	0
	.long	11219468956

xordi_reg:
	xor 1,3
	xor 2,4
	popj 17,

uxordi_reg:
	xor 1,3
	xor 2,4
	popj 17,

xordi_mem_left:
	move 4,(1)
	move 5,1(1)
	xor 4,2
	xor 5,3
	move 1,4
	move 2,5
	popj 17,

xordi_mem_right:
	move 4,(3)
	move 5,1(3)
	xor 1,4
	xor 2,5
	popj 17,

xordi_mem_mem:
	move 4,(1)
	move 5,1(1)
	move 6,(2)
	move 7,1(2)
	xor 4,6
	xor 5,7
	move 1,4
	move 2,5
	popj 17,

uxordi_mem_mem:
	move 4,(1)
	move 5,1(1)
	move 6,(2)
	move 7,1(2)
	xor 4,6
	xor 5,7
	move 1,4
	move 2,5
	popj 17,

xordi_global:
	move 1,gx_a
	move 2,gx_a+1
	move 4,gx_b
	move 5,gx_b+1
	xor 1,4
	xor 2,5
	popj 17,

uxordi_global:
	move 1,gux_a
	move 2,gux_a+1
	move 4,gux_b
	move 5,gux_b+1
	xor 1,4
	xor 2,5
	popj 17,

xordi_volatile:
	move 1,vgx_a
	move 2,vgx_a+1
	move 4,vgx_b
	move 5,vgx_b+1
	xor 1,4
	xor 2,5
	popj 17,

uxordi_volatile:
	move 1,vgux_a
	move 2,vgux_a+1
	move 4,vgux_b
	move 5,vgux_b+1
	xor 1,4
	xor 2,5
	popj 17,

xordi_const_zero:
	popj 17,

xordi_const_allones:
	setca 1,
	setca 2,
	popj 17,

xordi_const_one:
	xori 2,1
	popj 17,

xordi_low18:
	move 4,gx_low18_mask
	move 5,gx_low18_mask+1
	xor 1,4
	xor 2,5
	popj 17,

xordi_low_word:
	move 4,gx_low_word_mask
	move 5,gx_low_word_mask+1
	xor 1,4
	xor 2,5
	popj 17,

xordi_high_word:
	move 4,gx_high_word_mask
	move 5,gx_high_word_mask+1
	xor 1,4
	xor 2,5
	popj 17,

xordi_cross_mask:
	move 4,gx_cross_mask
	move 5,gx_cross_mask+1
	xor 1,4
	xor 2,5
	popj 17,

uxordi_const_zero:
	popj 17,

uxordi_const_allones:
	setca 1,
	setca 2,
	popj 17,

uxordi_low18:
	move 4,gux_low18_mask
	move 5,gux_low18_mask+1
	xor 1,4
	xor 2,5
	popj 17,

uxordi_low_word:
	move 4,gux_low_word_mask
	move 5,gux_low_word_mask+1
	xor 1,4
	xor 2,5
	popj 17,

uxordi_high_word:
	move 4,gux_high_word_mask
	move 5,gux_high_word_mask+1
	xor 1,4
	xor 2,5
	popj 17,

uxordi_cross_mask:
	move 4,gux_cross_mask
	move 5,gux_cross_mask+1
	xor 1,4
	xor 2,5
	popj 17,

xordi_store:
	add 17,[1,,1]
	move 0,-1(17)
	movem 0,(17)
	movem 4,-1(17)
	move 6,-2(17)
	xor 2,6
	xor 3,4
	movem 2,(1)
	movem 3,1(1)
	move 1,2
	move 2,3
	move 0,(17)
	movem 0,-1(17)
	add 17,[-1,,-1]
	popj 17,

uxordi_store:
	add 17,[1,,1]
	move 0,-1(17)
	movem 0,(17)
	movem 4,-1(17)
	move 6,-2(17)
	xor 2,6
	xor 3,4
	movem 2,(1)
	movem 3,1(1)
	move 1,2
	move 2,3
	move 0,(17)
	movem 0,-1(17)
	add 17,[-1,,-1]
	popj 17,

xordi_store_mem:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 4,(2)
	move 5,1(2)
	move 6,(3)
	move 7,1(3)
	xor 4,6
	xor 5,7
	movem 4,(1)
	movem 5,1(1)
	move 10,(1)
	move 11,5
	move 1,10
	move 2,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

uxordi_store_mem:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 4,(2)
	move 5,1(2)
	move 6,(3)
	move 7,1(3)
	xor 4,6
	xor 5,7
	movem 4,(1)
	movem 5,1(1)
	move 10,(1)
	move 11,5
	move 1,10
	move 2,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

xordi_update_reg:
	move 4,(1)
	move 5,1(1)
	xor 4,2
	xor 5,3
	movem 4,(1)
	movem 5,1(1)
	move 6,(1)
	move 7,5
	move 1,6
	move 2,7
	popj 17,

uxordi_update_reg:
	move 4,(1)
	move 5,1(1)
	xor 4,2
	xor 5,3
	movem 4,(1)
	movem 5,1(1)
	move 6,(1)
	move 7,5
	move 1,6
	move 2,7
	popj 17,

xordi_update_const:
	move 4,(1)
	move 5,1(1)
	move 2,gx_cross_mask
	move 3,gx_cross_mask+1
	xor 4,2
	xor 5,3
	movem 4,(1)
	movem 5,1(1)
	move 6,(1)
	move 7,5
	move 1,6
	move 2,7
	popj 17,

uxordi_update_const:
	move 4,(1)
	move 5,1(1)
	move 2,gux_cross_mask
	move 3,gux_cross_mask+1
	xor 4,2
	xor 5,3
	movem 4,(1)
	movem 5,1(1)
	move 6,(1)
	move 7,5
	move 1,6
	move 2,7
	popj 17,

xordi_struct:
	move 4,(1)
	move 5,1(1)
	move 2,2(1)
	move 3,3(1)
	xor 4,2
	xor 5,3
	move 1,4
	move 2,5
	popj 17,

uxordi_struct:
	move 4,(1)
	move 5,1(1)
	move 2,2(1)
	move 3,3(1)
	xor 4,2
	xor 5,3
	move 1,4
	move 2,5
	popj 17,

xordi_struct_store:
	move 4,(1)
	move 5,1(1)
	move 2,2(1)
	move 3,3(1)
	xor 4,2
	xor 5,3
	movem 4,4(1)
	movem 5,5(1)
	move 6,4(1)
	move 7,5
	move 1,6
	move 2,7
	popj 17,

uxordi_struct_store:
	move 4,(1)
	move 5,1(1)
	move 2,2(1)
	move 3,3(1)
	xor 4,2
	xor 5,3
	movem 4,4(1)
	movem 5,5(1)
	move 6,4(1)
	move 7,5
	move 1,6
	move 2,7
	popj 17,

xordi_array:
	lsh 2,1
	add 2,1
	move 4,(2)
	move 5,1(2)
	move 6,2(2)
	move 7,3(2)
	xor 4,6
	xor 5,7
	move 1,4
	move 2,5
	popj 17,

uxordi_array:
	lsh 2,1
	add 2,1
	move 4,(2)
	move 5,1(2)
	move 6,2(2)
	move 7,3(2)
	xor 4,6
	xor 5,7
	move 1,4
	move 2,5
	popj 17,

xordi_array_store:
	lsh 2,1
	add 2,1
	move 4,(2)
	move 5,1(2)
	move 6,2(2)
	move 7,3(2)
	xor 4,6
	xor 5,7
	movem 4,(2)
	movem 5,1(2)
	popj 17,

uxordi_array_store:
	lsh 2,1
	add 2,1
	move 4,(2)
	move 5,1(2)
	move 6,2(2)
	move 7,3(2)
	xor 4,6
	xor 5,7
	movem 4,(2)
	movem 5,1(2)
	popj 17,

xordi_branch:
	move 6,1
	xor 6,3
	move 7,2
	xor 7,4
	jumpl 6,%L52
	jumpn 6,%L51
	cail 7,0
	cail 7,0
	jrst %L51
%L52:
	seto 1,
%L50:
	popj 17,
%L51:
	move 4,6
	ior 4,7
	skipe 1,4
	movei 1,1
	popj 17,

uxordi_branch:
	xor 1,3
	xor 2,4
	ior 1,2
	skipe 1
	movei 1,1
	popj 17,

xordi_call_arg:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	xor 10,3
	xor 11,4
	move 1,10
	move 2,11
	pushj 17,sink_dint
	move 1,10
	move 2,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

uxordi_call_arg:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	xor 10,3
	xor 11,4
	move 1,10
	move 2,11
	pushj 17,sink_udint
	move 1,10
	move 2,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.globl	use_xordi3
use_xordi3:
	add 17,[21,,21]
	movem 16,-20(17)
	movei 0,-17(17)
	hrli 0,10
	blt 0,-12(17)
	move 10,1
	move 11,2
	move 12,3
	move 13,4
	move 16,-22(17)
	movem 1,-11(17)
	movem 11,-10(17)
	movem 3,-7(17)
	movem 13,-6(17)
	move 6,gx_cross_mask
	movem 6,-5(17)
	move 7,gx_cross_mask+1
	movem 7,-4(17)
	movem 3,(17)
	move 4,13
	movei 1,gx_c
	move 2,10
	move 3,11
	pushj 17,xordi_store
	movem 1,gx_c
	movem 2,gx_c+1
	pushj 17,xordi_volatile
	movem 1,vgx_c
	movem 2,vgx_c+1
	movei 6,-11(17)
	movem 6,-1(17)
	andi 16,1
	move 1,6
	move 2,16
	pushj 17,xordi_array_store
	move 1,10
	move 2,11
	move 3,12
	move 4,13
	pushj 17,xordi_reg
	pushj 17,sink_dint
	move 1,-1(17)
	move 2,12
	move 3,13
	pushj 17,xordi_mem_left
	pushj 17,sink_dint
	move 15,-1(17)
	addi 15,2
	move 1,10
	move 2,11
	move 3,15
	pushj 17,xordi_mem_right
	pushj 17,sink_dint
	move 14,-1(17)
	addi 14,4
	move 1,-1(17)
	move 2,14
	pushj 17,xordi_mem_mem
	pushj 17,sink_dint
	pushj 17,xordi_global
	pushj 17,sink_dint
	move 6,vgx_c
	move 7,vgx_c+1
	move 1,6
	move 2,7
	pushj 17,sink_dint
	move 1,10
	move 2,11
	pushj 17,xordi_const_zero
	pushj 17,sink_dint
	move 1,10
	move 2,11
	pushj 17,xordi_const_allones
	pushj 17,sink_dint
	move 1,10
	move 2,11
	pushj 17,xordi_const_one
	pushj 17,sink_dint
	move 1,10
	move 2,11
	pushj 17,xordi_low18
	pushj 17,sink_dint
	move 1,10
	move 2,11
	pushj 17,xordi_low_word
	pushj 17,sink_dint
	move 1,10
	move 2,11
	pushj 17,xordi_high_word
	pushj 17,sink_dint
	move 1,10
	move 2,11
	pushj 17,xordi_cross_mask
	pushj 17,sink_dint
	move 1,14
	move 2,-1(17)
	move 3,15
	pushj 17,xordi_store_mem
	pushj 17,sink_dint
	move 1,-1(17)
	move 2,12
	move 3,13
	pushj 17,xordi_update_reg
	pushj 17,sink_dint
	move 1,15
	pushj 17,xordi_update_const
	pushj 17,sink_dint
	movei 1,gx_pair
	pushj 17,xordi_struct
	pushj 17,sink_dint
	movei 1,gx_pair
	pushj 17,xordi_struct_store
	pushj 17,sink_dint
	movei 1,gx_arr
	move 2,16
	pushj 17,xordi_array
	pushj 17,sink_dint
	move 1,10
	move 2,11
	move 3,12
	move 4,13
	pushj 17,xordi_branch
	move 4,1
	move 2,1
	ash 4,-43
	move 1,4
	pushj 17,sink_dint
	move 1,10
	move 2,11
	move 3,12
	move 4,13
	pushj 17,xordi_call_arg
	movem 1,-3(17)
	movem 2,-2(17)
	pushj 17,sink_dint
	move 1,-3(17)
	move 2,-2(17)
	move 16,-20(17)
	movei 0,10
	hrli 0,-17(17)
	blt 0,15
	add 17,[-21,,-21]
	popj 17,

	.globl	use_uxordi3
use_uxordi3:
	add 17,[21,,21]
	movem 16,-20(17)
	movei 0,-17(17)
	hrli 0,10
	blt 0,-12(17)
	move 10,1
	move 11,2
	move 12,3
	move 13,4
	move 16,-22(17)
	movem 1,-11(17)
	movem 11,-10(17)
	movem 3,-7(17)
	movem 13,-6(17)
	move 6,gux_cross_mask
	movem 6,-5(17)
	move 7,gux_cross_mask+1
	movem 7,-4(17)
	movem 3,(17)
	move 4,13
	movei 1,gux_c
	move 2,10
	move 3,11
	pushj 17,uxordi_store
	movem 1,gux_c
	movem 2,gux_c+1
	pushj 17,uxordi_volatile
	movem 1,vgux_c
	movem 2,vgux_c+1
	movei 6,-11(17)
	movem 6,-1(17)
	andi 16,1
	move 1,6
	move 2,16
	pushj 17,uxordi_array_store
	move 1,10
	move 2,11
	move 3,12
	move 4,13
	pushj 17,uxordi_reg
	pushj 17,sink_udint
	move 15,-1(17)
	addi 15,4
	move 1,-1(17)
	move 2,15
	pushj 17,uxordi_mem_mem
	pushj 17,sink_udint
	pushj 17,uxordi_global
	pushj 17,sink_udint
	move 6,vgux_c
	move 7,vgux_c+1
	move 1,6
	move 2,7
	pushj 17,sink_udint
	move 1,10
	move 2,11
	pushj 17,uxordi_const_zero
	pushj 17,sink_udint
	move 1,10
	move 2,11
	pushj 17,uxordi_const_allones
	pushj 17,sink_udint
	move 1,10
	move 2,11
	pushj 17,uxordi_low18
	pushj 17,sink_udint
	move 1,10
	move 2,11
	pushj 17,uxordi_low_word
	pushj 17,sink_udint
	move 1,10
	move 2,11
	pushj 17,uxordi_high_word
	pushj 17,sink_udint
	move 1,10
	move 2,11
	pushj 17,uxordi_cross_mask
	pushj 17,sink_udint
	move 14,-1(17)
	addi 14,2
	move 1,15
	move 2,-1(17)
	move 3,14
	pushj 17,uxordi_store_mem
	pushj 17,sink_udint
	move 1,-1(17)
	move 2,12
	move 3,13
	pushj 17,uxordi_update_reg
	pushj 17,sink_udint
	move 1,14
	pushj 17,uxordi_update_const
	pushj 17,sink_udint
	movei 1,gux_pair
	pushj 17,uxordi_struct
	pushj 17,sink_udint
	movei 1,gux_pair
	pushj 17,uxordi_struct_store
	pushj 17,sink_udint
	movei 1,gux_arr
	move 2,16
	pushj 17,uxordi_array
	pushj 17,sink_udint
	move 1,10
	move 2,11
	move 3,12
	move 4,13
	pushj 17,uxordi_branch
	move 4,1
	move 2,1
	ash 4,-43
	move 1,4
	pushj 17,sink_udint
	move 1,10
	move 2,11
	move 3,12
	move 4,13
	pushj 17,uxordi_call_arg
	movem 1,-3(17)
	movem 2,-2(17)
	pushj 17,sink_udint
	move 1,-3(17)
	move 2,-2(17)
	move 16,-20(17)
	movei 0,10
	hrli 0,-17(17)
	blt 0,15
	add 17,[-21,,-21]
	popj 17,

	.bss
gx_c:
	.space	8
vgx_c:
	.space	8
gux_c:
	.space	8
vgux_c:
	.space	8
