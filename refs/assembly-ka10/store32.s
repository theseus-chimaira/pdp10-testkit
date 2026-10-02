	.data
	.align	2
ga:
	.long	5349
	.long	1
	.align	2
gau:
	.long	5349
	.long	1
	.align	2
gb:
	.word	247120
	.space	3
	.word	400000000000
	.align	2
gbu:
	.word	247120
	.space	3
	.word	400000000000
	.align	2
gc:
	.word	247120
	.long	2
	.align	2
gcu:
	.word	247120
	.long	2
	.align	2
gd:
	.word	247120
	.align	2
gdu:
	.word	247120
	.align	2
ge:
	.word	247137
	.align	2
geu:
	.word	247137
	.align	2
gf:
	.word	247137
	.long	3
	.align	2
gfu:
	.word	247137
	.long	3
	.align	2
gg:
	.long	5349
	.long	68719476729
	.align	2
ggu:
	.long	5349
	.long	511
	.align	2
data32:
	.long	1
	.long	68719476734
	.long	3
	.long	68719476732
	.align	2
udata32:
	.long	1
	.long	2
	.long	3
	.long	4

store_A:
	lsh 2,4
	movem 2,(1)
	popj 17,

store_ret_A:
	lsh 2,4
	movem 2,(1)
	ash 2,-4
	move 1,2
	popj 17,

store_const_A:
	hrroi 6,777760
	movem 6,(1)
	popj 17,

load_A:
	move 1,(1)
	ash 1,-4
	popj 17,

update_A:
	move 4,1
	move 1,(1)
	ash 1,-4
	add 1,2
	lsh 1,4
	movem 1,(4)
	ash 1,-4
	popj 17,

store_AU:
	lsh 2,4
	movem 2,(1)
	popj 17,

store_ret_AU:
	lsh 2,4
	movem 2,(1)
	lsh 2,-4
	move 1,2
	popj 17,

store_const_AU:
	hrroi 6,777760
	movem 6,(1)
	popj 17,

load_AU:
	move 1,(1)
	lsh 1,-4
	popj 17,

update_AU:
	move 4,1
	move 1,(1)
	lsh 1,-4
	add 1,2
	lsh 1,4
	movem 1,(4)
	lsh 1,-4
	popj 17,

store_B:
	lsh 2,4
	movem 2,(1)
	popj 17,

store_ret_B:
	lsh 2,4
	movem 2,(1)
	ash 2,-4
	move 1,2
	popj 17,

store_const_B:
	hrroi 6,777760
	movem 6,(1)
	popj 17,

load_B:
	move 1,(1)
	ash 1,-4
	popj 17,

update_B:
	move 4,1
	move 1,(1)
	ash 1,-4
	add 1,2
	lsh 1,4
	movem 1,(4)
	ash 1,-4
	popj 17,

store_BU:
	lsh 2,4
	movem 2,(1)
	popj 17,

store_ret_BU:
	lsh 2,4
	movem 2,(1)
	lsh 2,-4
	move 1,2
	popj 17,

store_const_BU:
	hrroi 6,777760
	movem 6,(1)
	popj 17,

load_BU:
	move 1,(1)
	lsh 1,-4
	popj 17,

update_BU:
	move 4,1
	move 1,(1)
	lsh 1,-4
	add 1,2
	lsh 1,4
	movem 1,(4)
	lsh 1,-4
	popj 17,

store_C:
	lsh 2,4
	movem 2,(1)
	popj 17,

store_ret_C:
	lsh 2,4
	movem 2,(1)
	ash 2,-4
	move 1,2
	popj 17,

store_const_C:
	hrroi 6,777760
	movem 6,(1)
	popj 17,

load_C:
	move 1,(1)
	ash 1,-4
	popj 17,

update_C:
	move 4,1
	move 1,(1)
	ash 1,-4
	add 1,2
	lsh 1,4
	movem 1,(4)
	ash 1,-4
	popj 17,

store_CU:
	lsh 2,4
	movem 2,(1)
	popj 17,

store_ret_CU:
	lsh 2,4
	movem 2,(1)
	lsh 2,-4
	move 1,2
	popj 17,

store_const_CU:
	hrroi 6,777760
	movem 6,(1)
	popj 17,

load_CU:
	move 1,(1)
	lsh 1,-4
	popj 17,

update_CU:
	move 4,1
	move 1,(1)
	lsh 1,-4
	add 1,2
	lsh 1,4
	movem 1,(4)
	lsh 1,-4
	popj 17,

store_D:
	lsh 2,4
	movem 2,(1)
	popj 17,

store_ret_D:
	lsh 2,4
	movem 2,(1)
	ash 2,-4
	move 1,2
	popj 17,

store_const_D:
	hrroi 6,777760
	movem 6,(1)
	popj 17,

load_D:
	move 1,(1)
	ash 1,-4
	popj 17,

update_D:
	move 4,1
	move 1,(1)
	ash 1,-4
	add 1,2
	lsh 1,4
	movem 1,(4)
	ash 1,-4
	popj 17,

store_DU:
	lsh 2,4
	movem 2,(1)
	popj 17,

store_ret_DU:
	lsh 2,4
	movem 2,(1)
	lsh 2,-4
	move 1,2
	popj 17,

store_const_DU:
	hrroi 6,777760
	movem 6,(1)
	popj 17,

load_DU:
	move 1,(1)
	lsh 1,-4
	popj 17,

update_DU:
	move 4,1
	move 1,(1)
	lsh 1,-4
	add 1,2
	lsh 1,4
	movem 1,(4)
	lsh 1,-4
	popj 17,

store_E:
	dpb 2,[POINT 32,(1),31]
	popj 17,

store_ret_E:
	dpb 2,[POINT 32,(1),31]
	move 1,(1)
	ash 1,-4
	popj 17,

store_const_E:
	hrroi 6,777760
	iorm 6,(1)
	popj 17,

load_E:
	move 1,(1)
	ash 1,-4
	popj 17,

update_E:
	move 4,(1)
	ash 4,-4
	add 4,2
	dpb 4,[POINT 32,(1),31]
	move 1,(1)
	ash 1,-4
	popj 17,

store_EU:
	dpb 2,[POINT 32,(1),31]
	popj 17,

store_ret_EU:
	dpb 2,[POINT 32,(1),31]
	move 1,(1)
	lsh 1,-4
	popj 17,

store_const_EU:
	hrroi 6,777760
	iorm 6,(1)
	popj 17,

load_EU:
	move 1,(1)
	lsh 1,-4
	popj 17,

update_EU:
	move 4,(1)
	lsh 4,-4
	add 4,2
	dpb 4,[POINT 32,(1),31]
	move 1,(1)
	lsh 1,-4
	popj 17,

store_F:
	dpb 2,[POINT 32,(1),31]
	popj 17,

store_ret_F:
	dpb 2,[POINT 32,(1),31]
	move 1,(1)
	ash 1,-4
	popj 17,

store_const_F:
	hrroi 6,777760
	iorm 6,(1)
	popj 17,

load_F:
	move 1,(1)
	ash 1,-4
	popj 17,

update_F:
	move 4,(1)
	ash 4,-4
	add 4,2
	dpb 4,[POINT 32,(1),31]
	move 1,(1)
	ash 1,-4
	popj 17,

store_FU:
	dpb 2,[POINT 32,(1),31]
	popj 17,

store_ret_FU:
	dpb 2,[POINT 32,(1),31]
	move 1,(1)
	lsh 1,-4
	popj 17,

store_const_FU:
	hrroi 6,777760
	iorm 6,(1)
	popj 17,

load_FU:
	move 1,(1)
	lsh 1,-4
	popj 17,

update_FU:
	move 4,(1)
	lsh 4,-4
	add 4,2
	dpb 4,[POINT 32,(1),31]
	move 1,(1)
	lsh 1,-4
	popj 17,

store_G:
	lsh 2,4
	movem 2,(1)
	popj 17,

store_ret_G:
	lsh 2,4
	movem 2,(1)
	ash 2,-4
	move 1,2
	popj 17,

store_const_G:
	hrroi 6,777760
	movem 6,(1)
	popj 17,

load_G:
	move 1,(1)
	ash 1,-4
	popj 17,

update_G:
	move 4,1
	move 1,(1)
	ash 1,-4
	add 1,2
	lsh 1,4
	movem 1,(4)
	ash 1,-4
	popj 17,

store_GU:
	lsh 2,4
	movem 2,(1)
	popj 17,

store_ret_GU:
	lsh 2,4
	movem 2,(1)
	lsh 2,-4
	move 1,2
	popj 17,

store_const_GU:
	hrroi 6,777760
	movem 6,(1)
	popj 17,

load_GU:
	move 1,(1)
	lsh 1,-4
	popj 17,

update_GU:
	move 4,1
	move 1,(1)
	lsh 1,-4
	add 1,2
	lsh 1,4
	movem 1,(4)
	lsh 1,-4
	popj 17,

store_g_y:
	lsh 2,4
	movem 2,(1)
	dpb 3,[POINT 32,1(1),31]
	popj 17,

store_gu_y:
	lsh 2,4
	movem 2,(1)
	dpb 3,[POINT 32,1(1),31]
	popj 17,

store_named_low:
	dpb 2,[POINT 32,(1),31]
	andi 3,17
	dpb 3,[POINT 4,(1),35]
	popj 17,

store_named_low_u:
	dpb 2,[POINT 32,(1),31]
	andi 3,17
	dpb 3,[POINT 4,(1),35]
	popj 17,

preserve_named_low:
	move 3,(1)
	lsh 3,40
	ash 3,-40
	dpb 2,[POINT 32,(1),31]
	move 4,(1)
	lsh 4,40
	ash 4,-40
	add 3,4
	move 1,3
	popj 17,

preserve_named_low_u:
	ldb 3,[POINT 4,(1),35]
	dpb 2,[POINT 32,(1),31]
	ldb 4,[POINT 4,(1),35]
	add 3,4
	move 1,3
	popj 17,

store_array:
	movei 4,data32
	jumple 1,%L80
%L79:
	ibp 4
	sojg 1,%L79	; decrement_and_branch_until_zero
%L80:
	jumpe 1,%L82
%L81:
	subi 4,1
	aojl 1,%L81
%L82:
	dpb 2,[POINT 32,(4),31]
	popj 17,

store_uarray:
	movei 4,udata32
	jumple 1,%L86
%L85:
	ibp 4
	sojg 1,%L85	; decrement_and_branch_until_zero
%L86:
	jumpe 1,%L88
%L87:
	subi 4,1
	aojl 1,%L87
%L88:
	dpb 2,[POINT 32,(4),31]
	popj 17,

load_array:
	move 1,data32(1)
	ash 1,-4
	popj 17,

load_uarray:
	move 1,udata32(1)
	lsh 1,-4
	popj 17,

store_pointer:
	movem 2,(1)
	popj 17,

store_upointer:
	movem 2,(1)
	popj 17,

update_pointer:
	move 4,2
	addb 4,(1)
	move 1,4
	popj 17,

update_upointer:
	move 4,2
	addb 4,(1)
	move 1,4
	popj 17,

store_indexed_pointer:
	add 1,2
	movem 3,(1)
	move 1,3
	popj 17,

store_indexed_upointer:
	add 1,2
	movem 3,(1)
	move 1,3
	popj 17,

store_volatile_array:
	movei 3,vdata32
	move 4,1
	jumple 1,%L104
%L103:
	ibp 3
	sojg 4,%L103	; decrement_and_branch_until_zero
%L104:
	jumpe 4,%L106
%L105:
	subi 3,1
	aojl 4,%L105
%L106:
	dpb 2,[POINT 32,(3),31]
	move 1,vdata32(1)
	ash 1,-4
	popj 17,

store_volatile_uarray:
	movei 3,vudata32
	move 4,1
	jumple 1,%L110
%L109:
	ibp 3
	sojg 4,%L109	; decrement_and_branch_until_zero
%L110:
	jumpe 4,%L112
%L111:
	subi 3,1
	aojl 4,%L111
%L112:
	dpb 2,[POINT 32,(3),31]
	move 1,vudata32(1)
	lsh 1,-4
	popj 17,

store_volatile_struct:
	lsh 1,4
	movem 1,vga
	move 1,vga
	ash 1,-4
	popj 17,

store_volatile_named_low:
	andi 2,17
	dpb 2,[POINT 4,vge,35]
	dpb 1,[POINT 32,vge,31]
	move 1,vge
	lsh 1,40
	ash 1,-40
	popj 17,

store_volatile_pair:
	lsh 1,4
	movem 1,vgg
	dpb 2,[POINT 32,vgg+1,31]
	move 1,vgg
	ash 1,-4
	move 4,vgg+1
	ash 4,-4
	add 1,4
	popj 17,

stack_store32:
	add 17,[2,,2]
	move 4,1
	lsh 4,4
	ash 4,-4
	dpb 4,[POINT 32,-1(17),31]
	dpb 4,[POINT 32,(17),31]
	move 1,-1(17)
	ash 1,-4
	move 4,(17)
	ash 4,-4
	add 1,4
	add 17,[-2,,-2]
	popj 17,

stack_ustore32:
	add 17,[2,,2]
	move 4,1
	tlz 4,740000
	dpb 4,[POINT 32,-1(17),31]
	dpb 4,[POINT 32,(17),31]
	move 1,-1(17)
	lsh 1,-4
	move 4,(17)
	lsh 4,-4
	add 1,4
	add 17,[-2,,-2]
	popj 17,

branch_store32:
	dpb 2,[POINT 32,(1),31]
	seto 4,
	skipge (1)
	jrst %L118
	move 4,(1)
	andcmi 4,17
	jumpn 4,%L120
	move 4,(1)
	lsh 4,40
	ash 4,-40
%L118:
	move 1,4
	popj 17,
%L120:
	move 4,(1)
	lsh 4,40
	ash 4,-40
	aoja 4,%L118

branch_ustore32:
	dpb 2,[POINT 32,(1),31]
	move 4,(1)
	lsh 4,-4
	jumpn 4,%L122
	ldb 1,[POINT 4,(1),35]
%L121:
	popj 17,
%L122:
	ldb 1,[POINT 4,(1),35]
	aoja 1,%L121

	.globl	use_store32
use_store32:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 11,1
	move 12,2
	move 13,3
	andi 13,3
	movei 1,ga
	move 2,11
	pushj 17,store_A
	movei 1,gau
	move 2,11
	pushj 17,store_AU
	movei 1,gb
	move 2,11
	pushj 17,store_B
	movei 1,gbu
	move 2,11
	pushj 17,store_BU
	movei 1,gc
	move 2,12
	pushj 17,store_C
	movei 1,gcu
	move 2,12
	pushj 17,store_CU
	move 15,11
	add 15,12
	movei 1,gd
	move 2,15
	pushj 17,store_D
	movei 1,gdu
	move 2,15
	pushj 17,store_DU
	move 14,11
	sub 14,12
	movei 1,ge
	move 2,14
	pushj 17,store_E
	movei 1,geu
	move 2,14
	pushj 17,store_EU
	move 10,11
	xor 10,12
	movei 1,gf
	move 2,10
	pushj 17,store_F
	movei 1,gfu
	move 2,10
	pushj 17,store_FU
	movei 1,gg
	move 2,11
	pushj 17,store_G
	movei 1,ggu
	move 2,12
	pushj 17,store_GU
	movei 1,gg
	move 2,11
	move 3,12
	pushj 17,store_g_y
	movei 1,ggu
	move 2,11
	move 3,12
	pushj 17,store_gu_y
	movei 1,ge
	move 2,11
	move 3,12
	pushj 17,store_named_low
	movei 1,geu
	move 2,11
	move 3,12
	pushj 17,store_named_low_u
	move 1,13
	move 2,11
	pushj 17,store_array
	move 1,13
	move 2,12
	pushj 17,store_uarray
	move 1,13
	addi 1,1
	andi 1,3
	xmovei 1,data32(1)
	move 2,12
	pushj 17,store_pointer
	move 1,13
	addi 1,2
	andi 1,3
	xmovei 1,udata32(1)
	move 2,11
	pushj 17,store_upointer
	movei 1,ga
	move 2,11
	pushj 17,store_ret_A
	move 10,1
	movei 1,gau
	move 2,12
	pushj 17,store_ret_AU
	add 10,1
	movei 1,gb
	move 2,11
	pushj 17,store_ret_B
	add 10,1
	movei 1,gbu
	move 2,12
	pushj 17,store_ret_BU
	add 10,1
	move 2,11
	addi 2,1
	movei 1,gc
	pushj 17,store_ret_C
	add 10,1
	move 2,12
	addi 2,1
	movei 1,gcu
	pushj 17,store_ret_CU
	add 10,1
	move 2,11
	addi 2,2
	movei 1,gd
	pushj 17,store_ret_D
	add 10,1
	move 2,12
	addi 2,2
	movei 1,gdu
	pushj 17,store_ret_DU
	add 10,1
	move 2,11
	addi 2,3
	movei 1,ge
	pushj 17,store_ret_E
	add 10,1
	move 2,12
	addi 2,3
	movei 1,geu
	pushj 17,store_ret_EU
	add 10,1
	move 2,11
	addi 2,4
	movei 1,gf
	pushj 17,store_ret_F
	add 10,1
	move 2,12
	addi 2,4
	movei 1,gfu
	pushj 17,store_ret_FU
	add 10,1
	move 2,11
	addi 2,5
	movei 1,gg
	pushj 17,store_ret_G
	add 10,1
	move 2,12
	addi 2,5
	movei 1,ggu
	pushj 17,store_ret_GU
	add 10,1
	movei 1,ga
	movei 2,1
	pushj 17,update_A
	add 10,1
	movei 1,gau
	movei 2,1
	pushj 17,update_AU
	add 10,1
	movei 1,gb
	movei 2,1
	pushj 17,update_B
	add 10,1
	movei 1,gbu
	movei 2,1
	pushj 17,update_BU
	add 10,1
	movei 1,ge
	movei 2,1
	pushj 17,update_E
	add 10,1
	movei 1,geu
	movei 2,1
	pushj 17,update_EU
	add 10,1
	movei 1,ge
	move 2,11
	pushj 17,preserve_named_low
	add 10,1
	movei 1,geu
	move 2,12
	pushj 17,preserve_named_low_u
	add 10,1
	movei 1,ga
	pushj 17,load_A
	add 10,1
	movei 1,gau
	pushj 17,load_AU
	add 10,1
	move 1,13
	pushj 17,load_array
	add 10,1
	move 1,13
	pushj 17,load_uarray
	add 10,1
	xmovei 1,data32(13)
	movei 2,7
	pushj 17,update_pointer
	add 10,1
	xmovei 1,udata32(13)
	movei 2,7
	pushj 17,update_upointer
	add 10,1
	movei 1,data32
	move 2,13
	move 3,15
	pushj 17,store_indexed_pointer
	add 10,1
	movei 1,udata32
	move 2,13
	move 3,14
	pushj 17,store_indexed_upointer
	add 10,1
	move 1,13
	move 2,11
	pushj 17,store_volatile_array
	add 10,1
	move 1,13
	move 2,12
	pushj 17,store_volatile_uarray
	add 10,1
	move 1,11
	pushj 17,store_volatile_struct
	add 10,1
	move 1,11
	move 2,12
	pushj 17,store_volatile_named_low
	add 10,1
	move 1,11
	move 2,12
	pushj 17,store_volatile_pair
	add 10,1
	move 1,11
	pushj 17,stack_store32
	add 10,1
	move 1,12
	pushj 17,stack_ustore32
	add 10,1
	movei 1,ge
	move 2,11
	pushj 17,branch_store32
	add 10,1
	movei 1,geu
	move 2,12
	pushj 17,branch_ustore32
	add 10,1
	movei 1,ga
	pushj 17,store_const_A
	movei 1,gau
	pushj 17,store_const_AU
	movei 1,gb
	pushj 17,store_const_B
	movei 1,gbu
	pushj 17,store_const_BU
	movei 1,ge
	pushj 17,store_const_E
	movei 1,geu
	pushj 17,store_const_EU
	move 1,10
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,

	.bss
vga:
	.space	8
vge:
	.space	4
vgg:
	.space	8
vdata32:
	.space	16
vudata32:
	.space	16
