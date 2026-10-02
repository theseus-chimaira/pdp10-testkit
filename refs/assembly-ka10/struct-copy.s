	.data
	.align	2
g_one:
	.long	1
	.align	2
g_pair:
	.long	1
	.long	2
	.align	2
g_quad:
	.long	1
	.long	2
	.long	3
	.long	4
	.align	2
g_large:
	.long	0
	.long	1
	.long	2
	.long	3
	.long	4
	.long	5
	.long	6
	.long	7
	.long	8
	.long	9
	.long	10
	.long	11
	.long	12
	.long	13
	.long	14
	.long	15
	.long	16
	.long	17
	.long	18
	.long	19
	.align	2
g_dint:
	.long	0
	.long	1
	.long	68719476735
	.long	68719476734
	.align	2
g_qi:
	.word	1776003004
	.space	2

	.word	773006000000
sc_fn:
	addi 1,1
	popj 17,

copy_arg_one:
	popj 17,

copy_load_one:
	move 1,(1)
	popj 17,

copy_store_one:
	move 2,(2)
	movem 2,(1)
	popj 17,

copy_index_one:
	add 2,1
	add 1,3
	move 1,(1)
	movem 1,(2)
	popj 17,

copy_cond_one:
	jumpe 3,%L10
	move 1,2
%L10:
	popj 17,

copy_arg_pair:
	popj 17,

copy_load_pair:
	move 4,(1)
	move 5,1(1)
	move 1,4
	move 2,5
	popj 17,

copy_store_pair:
	move 6,(2)
	movem 6,(1)
	move 2,1(2)
	movem 2,1(1)
	popj 17,

copy_index_pair:
	lsh 2,1
	add 2,1
	lsh 3,1
	add 3,1
	move 6,(3)
	movem 6,(2)
	move 3,1(3)
	movem 3,1(2)
	move 4,(2)
	move 5,3
	move 1,4
	move 2,5
	popj 17,

copy_cond_pair:
	skipn -1(17)
	popj 17,
	move 1,3
	move 2,4
	popj 17,

copy_arg_quad:
	add 17,[4,,4]
	movem 1,-3(17)
	movem 2,-2(17)
	movem 3,-1(17)
	movem 4,(17)
	move 6,4
	move 1,-3(17)
	move 2,-2(17)
	move 3,-1(17)
	move 4,6
	add 17,[-4,,-4]
	popj 17,

copy_load_quad:
	push 17,10
	move 6,(1)
	move 7,1(1)
	move 5,2(1)
	move 10,3(1)
	move 1,6
	move 2,7
	move 3,5
	move 4,10
	pop 17,10
	popj 17,

copy_store_quad:
	movei 4,(1)
	hrl 4,2
	blt 4,3(1)
	popj 17,

copy_index_quad:
	push 17,10
	lsh 2,2
	add 2,1
	lsh 3,2
	add 3,1
	movei 4,(2)
	hrl 4,3
	blt 4,3(2)
	move 6,(2)
	move 7,1(2)
	move 5,2(2)
	move 10,3(2)
	move 1,6
	move 2,7
	move 3,5
	move 4,10
	pop 17,10
	popj 17,

copy_cond_quad:
	add 17,[4,,4]
	movem 1,-3(17)
	movem 2,-2(17)
	movem 3,-1(17)
	movem 4,(17)
	skipn -11(17)
	jrst %L28
	movei 3,-3(17)
	hrli 3,-10(17)
	blt 3,(17)
%L28:
	move 6,4
	move 1,-3(17)
	move 2,-2(17)
	move 3,-1(17)
	move 4,6
	add 17,[-4,,-4]
	popj 17,

copy_arg_large:
	add 17,[3,,3]
	move 0,-3(17)
	movem 0,(17)
	movem 2,-3(17)
	movem 3,-2(17)
	movem 4,-1(17)
	movei 4,(1)
	hrli 4,-24(17)
	blt 4,23(1)
	move 0,(17)
	movem 0,-3(17)
	add 17,[-3,,-3]
	popj 17,

copy_load_large:
	push 17,10
	move 10,1
	tlo 1,331100
	tlo 2,331100
	movei 3,120
	pushj 17,memmove
	move 1,10
	pop 17,10
	popj 17,

copy_store_large:
	movei 4,(1)
	hrl 4,2
	blt 4,23(1)
	popj 17,

copy_index_large:
	push 17,10
	move 10,1
	imuli 3,24
	add 3,2
	imuli 4,24
	add 4,2
	movei 2,(3)
	hrl 2,4
	blt 2,23(3)
	tlo 1,331100
	tlo 3,331100
	move 2,3
	movei 3,120
	pushj 17,memmove
	move 1,10
	pop 17,10
	popj 17,

copy_cond_large:
	add 17,[3,,3]
	move 0,-3(17)
	movem 0,(17)
	move 6,1
	movem 2,-3(17)
	movem 3,-2(17)
	movem 4,-1(17)
	skipn -51(17)
	jrst %L41
	movei 4,-24(17)
	hrli 4,-50(17)
	blt 4,-1(17)
%L41:
	movei 4,(6)
	hrli 4,-24(17)
	blt 4,23(6)
	move 0,(17)
	movem 0,-3(17)
	add 17,[-3,,-3]
	popj 17,

copy_arg_dint:
	add 17,[4,,4]
	movem 1,-3(17)
	movem 2,-2(17)
	movem 3,-1(17)
	movem 4,(17)
	move 6,4
	move 1,-3(17)
	move 2,-2(17)
	move 3,-1(17)
	move 4,6
	add 17,[-4,,-4]
	popj 17,

copy_load_dint:
	push 17,10
	move 6,(1)
	move 7,1(1)
	move 5,2(1)
	move 10,3(1)
	move 1,6
	move 2,7
	move 3,5
	move 4,10
	pop 17,10
	popj 17,

copy_store_dint:
	movei 4,(1)
	hrl 4,2
	blt 4,3(1)
	popj 17,

copy_index_dint:
	push 17,10
	lsh 2,2
	add 2,1
	lsh 3,2
	add 3,1
	movei 4,(2)
	hrl 4,3
	blt 4,3(2)
	move 6,(2)
	move 7,1(2)
	move 5,2(2)
	move 10,3(2)
	move 1,6
	move 2,7
	move 3,5
	move 4,10
	pop 17,10
	popj 17,

copy_cond_dint:
	add 17,[4,,4]
	movem 1,-3(17)
	movem 2,-2(17)
	movem 3,-1(17)
	movem 4,(17)
	skipn -11(17)
	jrst %L50
	movei 3,-3(17)
	hrli 3,-10(17)
	blt 3,(17)
%L50:
	move 6,4
	move 1,-3(17)
	move 2,-2(17)
	move 3,-1(17)
	move 4,6
	add 17,[-4,,-4]
	popj 17,

copy_arg_qi:
	popj 17,

copy_load_qi:
	move 4,(1)
	move 5,1(1)
	move 1,4
	move 2,5
	popj 17,

copy_store_qi:
	move 6,(2)
	movem 6,(1)
	move 2,1(2)
	movem 2,1(1)
	popj 17,

copy_index_qi:
	push 17,10
	lsh 2,3
	move 4,2
	andi 4,3
	move 6,2
	ash 6,-2	; ashrsi3_pointer
	add 6,1
	jumpe 4,%L57
%L56:
	ibp 6
	sojn 4,%L56	; decrement_and_branch_until_zero
%L57:
	movei 4,0
	ash 3,1
	add 3,1
	jumpe 4,%L60
%L59:
	ibp 3
	sojn 4,%L59	; decrement_and_branch_until_zero
%L60:
	move 5,(3)
	movem 5,(6)
	move 3,1(3)
	movem 3,1(6)
	movei 4,0
	ash 2,-2	; ashrsi3_pointer
	add 2,1
	jumpe 4,%L63
%L62:
	ibp 2
	sojn 4,%L62	; decrement_and_branch_until_zero
%L63:
	move 7,(2)
	move 10,1(2)
	move 1,7
	move 2,10
	pop 17,10
	popj 17,

copy_cond_qi:
	skipn -1(17)
	popj 17,
	move 1,3
	move 2,4
	popj 17,

copy_arg_half:
	add 17,[3,,3]
	move 0,-3(17)
	movem 0,(17)
	movem 2,-3(17)
	movem 3,-2(17)
	movem 4,-1(17)
	movei 4,(1)
	hrli 4,-5(17)
	blt 4,4(1)
	move 0,(17)
	movem 0,-3(17)
	add 17,[-3,,-3]
	popj 17,

copy_load_half:
	push 17,10
	move 10,1
	tlc 1,113300
	tlc 2,113300
	movei 3,24
	pushj 17,memmove
	move 1,10
	pop 17,10
	popj 17,

copy_store_half:
	movei 4,(1)
	hrl 4,2
	blt 4,4(1)
	popj 17,

copy_index_half:
	push 17,10
	move 10,1
	move 7,2
	imuli 3,12
	move 1,3
	andi 1,1
	move 6,3
	ash 6,-1	; ashrsi3_pointer
	add 6,2
	jumpe 1,%L74
%L73:
	ibp 6
	sojn 1,%L73	; decrement_and_branch_until_zero
%L74:
	imuli 4,12
	movei 1,0
	ash 4,-1	; ashrsi3_pointer
	add 4,7
	jumpe 1,%L77
%L76:
	ibp 4
	sojn 1,%L76	; decrement_and_branch_until_zero
%L77:
	movei 1,(6)
	hrl 1,4
	blt 1,4(6)
	movei 4,0
	move 2,3
	ash 2,-1	; ashrsi3_pointer
	add 2,7
	jumpe 4,%L80
%L79:
	ibp 2
	sojn 4,%L79	; decrement_and_branch_until_zero
%L80:
	move 1,10
	tlc 1,113300
	tlc 2,113300
	movei 3,24
	pushj 17,memmove
	move 1,10
	pop 17,10
	popj 17,

copy_cond_half:
	add 17,[3,,3]
	move 0,-3(17)
	movem 0,(17)
	move 6,1
	movem 2,-3(17)
	movem 3,-2(17)
	movem 4,-1(17)
	skipn -13(17)
	jrst %L84
	movei 4,-5(17)
	hrli 4,-12(17)
	blt 4,-1(17)
%L84:
	movei 4,(6)
	hrli 4,-5(17)
	blt 4,4(6)
	move 0,(17)
	movem 0,-3(17)
	add 17,[-3,,-3]
	popj 17,

copy_arg_bytes:
	add 17,[2,,2]
	movem 1,-1(17)
	movem 2,(17)
	move 4,-1(17)
	move 5,2
	move 1,4
	move 2,5
	add 17,[-2,,-2]
	popj 17,

copy_load_bytes:
	move 4,(1)
	move 5,1(1)
	move 1,4
	move 2,5
	popj 17,

copy_store_bytes:
	movei 4,(1)
	hrl 4,2
	blt 4,1(1)
	popj 17,

copy_index_bytes:
	push 17,10
	lsh 2,3
	move 4,2
	andi 4,3
	move 6,2
	ash 6,-2	; ashrsi3_pointer
	add 6,1
	jumpe 4,%L91
%L90:
	ibp 6
	sojn 4,%L90	; decrement_and_branch_until_zero
%L91:
	movei 4,0
	ash 3,1
	add 3,1
	jumpe 4,%L94
%L93:
	ibp 3
	sojn 4,%L93	; decrement_and_branch_until_zero
%L94:
	movei 4,(6)
	hrl 4,3
	blt 4,1(6)
	movei 4,0
	ash 2,-2	; ashrsi3_pointer
	add 2,1
	jumpe 4,%L97
%L96:
	ibp 2
	sojn 4,%L96	; decrement_and_branch_until_zero
%L97:
	move 7,(2)
	move 10,1(2)
	move 1,7
	move 2,10
	pop 17,10
	popj 17,

copy_cond_bytes:
	add 17,[4,,4]
	movem 1,-3(17)
	movem 2,-2(17)
	movem 3,-1(17)
	movem 4,(17)
	skipn -5(17)
	jrst %L99
	movei 4,-3(17)
	hrli 4,-1(17)
	blt 4,-2(17)
%L99:
	move 6,-3(17)
	move 7,-2(17)
	move 1,6
	move 2,7
	add 17,[-4,,-4]
	popj 17,

copy_arg_sc32:
	add 17,[7,,7]
	movei 0,-6(17)
	hrli 0,10
	blt 0,-3(17)
	movei 11,0
	movem 1,-2(17)
	movem 2,-1(17)
	movem 3,(17)
	move 5,-2(17)
	move 12,-1(17)
	move 13,3
	move 10,3
	move 1,5
	move 2,12
	move 3,13
	move 4,11
	movei 0,10
	hrli 0,-6(17)
	blt 0,13
	add 17,[-7,,-7]
	popj 17,

copy_load_sc32:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	movei 11,0
	move 5,(1)
	move 12,1(1)
	move 13,2(1)
	move 10,13
	move 1,5
	move 2,12
	move 3,13
	move 4,11
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

copy_store_sc32:
	movei 4,(1)
	hrl 4,2
	blt 4,2(1)
	popj 17,

copy_index_sc32:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	movei 11,0
	move 4,2
	lsh 4,1
	add 4,2
	add 4,1
	move 2,3
	lsh 2,1
	add 2,3
	add 2,1
	movei 3,(4)
	hrl 3,2
	blt 3,2(4)
	move 5,(4)
	move 12,1(4)
	move 13,2(4)
	move 10,13
	move 1,5
	move 2,12
	move 3,13
	move 4,11
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

copy_cond_sc32:
	add 17,[10,,10]
	move 0,-10(17)
	movem 0,-7(17)
	movei 0,-6(17)
	hrli 0,10
	blt 0,-3(17)
	movei 13,0
	movem 1,-2(17)
	movem 2,-1(17)
	movem 3,(17)
	movem 4,-10(17)
	skipn -13(17)
	jrst %L108
	movei 4,-2(17)
	hrli 4,-12(17)
	blt 4,(17)
%L108:
	move 6,-2(17)
	move 7,-1(17)
	move 5,3
	move 10,6
	move 11,7
	move 12,3
	move 1,6
	move 2,7
	move 3,5
	move 4,13
	movei 0,10
	hrli 0,-6(17)
	blt 0,13
	move 0,-7(17)
	movem 0,-10(17)
	add 17,[-10,,-10]
	popj 17,

copy_arg_packed:
	add 17,[4,,4]
	movem 1,-3(17)
	movem 2,-2(17)
	movem 3,-1(17)
	movem 4,(17)
	move 6,4
	and 6,[-1000000000]
	ldb 4,[POINT 9,(17),17]
	dpb 4,[POINT 9,6,17]
	ldb 4,[POINT 9,(17),26]
	dpb 4,[POINT 9,6,26]
	move 4,(17)
	dpb 4,[POINT 9,6,35]
	move 1,-3(17)
	move 2,-2(17)
	move 3,-1(17)
	move 4,6
	add 17,[-4,,-4]
	popj 17,

copy_load_packed:
	push 17,10
	move 6,(1)
	move 7,1(1)
	move 5,2(1)
	move 10,3(1)
	move 1,6
	move 2,7
	move 3,5
	move 4,10
	pop 17,10
	popj 17,

copy_store_packed:
	movei 3,20
	jrst memcpy

copy_index_packed:
	push 17,10
	move 10,2
	lsh 10,2
	add 10,1
	lsh 3,2
	add 3,1
	move 1,10
	move 2,3
	movei 3,20
	pushj 17,memcpy
	move 6,(10)
	move 7,1(10)
	move 5,2(10)
	move 10,3(10)
	move 1,6
	move 2,7
	move 3,5
	move 4,10
	pop 17,10
	popj 17,

copy_cond_packed:
	add 17,[4,,4]
	movem 1,-3(17)
	movem 2,-2(17)
	movem 3,-1(17)
	movem 4,(17)
	skipe -11(17)
	jrst %L124
%L121:
	move 1,-3(17)
	move 2,-2(17)
	move 3,-1(17)
	move 4,(17)
	add 17,[-4,,-4]
	popj 17,
%L124:
	movei 2,-10(17)
	tlo 2,331100
	movei 1,-3(17)
	tlo 1,331100
	movei 3,20
	pushj 17,memcpy
	jrst %L121

copy_arg_arrays:
	add 17,[3,,3]
	move 0,-3(17)
	movem 0,(17)
	movem 2,-3(17)
	movem 3,-2(17)
	movem 4,-1(17)
	movei 4,(1)
	hrli 4,-23(17)
	blt 4,22(1)
	move 0,(17)
	movem 0,-3(17)
	add 17,[-3,,-3]
	popj 17,

copy_load_arrays:
	push 17,10
	move 10,1
	tlo 1,331100
	tlo 2,331100
	movei 3,114
	pushj 17,memmove
	move 1,10
	pop 17,10
	popj 17,

copy_store_arrays:
	movei 4,(1)
	hrl 4,2
	blt 4,22(1)
	popj 17,

copy_index_arrays:
	push 17,10
	move 10,1
	imuli 3,23
	add 3,2
	imuli 4,23
	add 4,2
	movei 2,(3)
	hrl 2,4
	blt 2,22(3)
	tlo 1,331100
	tlo 3,331100
	move 2,3
	movei 3,114
	pushj 17,memmove
	move 1,10
	pop 17,10
	popj 17,

copy_cond_arrays:
	add 17,[3,,3]
	move 0,-3(17)
	movem 0,(17)
	move 6,1
	movem 2,-3(17)
	movem 3,-2(17)
	movem 4,-1(17)
	skipn -47(17)
	jrst %L137
	movei 4,-23(17)
	hrli 4,-46(17)
	blt 4,-1(17)
%L137:
	movei 4,(6)
	hrli 4,-23(17)
	blt 4,22(6)
	move 0,(17)
	movem 0,-3(17)
	add 17,[-3,,-3]
	popj 17,

copy_arg_nested:
	add 17,[3,,3]
	move 0,-3(17)
	movem 0,(17)
	movem 2,-3(17)
	movem 3,-2(17)
	movem 4,-1(17)
	movei 4,(1)
	hrli 4,-36(17)
	blt 4,35(1)
	move 0,(17)
	movem 0,-3(17)
	add 17,[-3,,-3]
	popj 17,

copy_load_nested:
	push 17,10
	move 10,1
	tlo 1,331100
	tlo 2,331100
	movei 3,170
	pushj 17,memmove
	move 1,10
	pop 17,10
	popj 17,

copy_store_nested:
	movei 4,(1)
	hrl 4,2
	blt 4,35(1)
	popj 17,

copy_index_nested:
	push 17,10
	move 10,1
	imuli 3,36
	add 3,2
	imuli 4,36
	add 4,2
	movei 2,(3)
	hrl 2,4
	blt 2,35(3)
	tlo 1,331100
	tlo 3,331100
	move 2,3
	movei 3,170
	pushj 17,memmove
	move 1,10
	pop 17,10
	popj 17,

copy_cond_nested:
	add 17,[3,,3]
	move 0,-3(17)
	movem 0,(17)
	move 6,1
	movem 2,-3(17)
	movem 3,-2(17)
	movem 4,-1(17)
	skipn -75(17)
	jrst %L150
	movei 4,-36(17)
	hrli 4,-74(17)
	blt 4,-1(17)
%L150:
	movei 4,(6)
	hrli 4,-36(17)
	blt 4,35(6)
	move 0,(17)
	movem 0,-3(17)
	add 17,[-3,,-3]
	popj 17,

copy_arg_ptrs:
	add 17,[3,,3]
	move 0,-3(17)
	movem 0,(17)
	movem 2,-3(17)
	movem 3,-2(17)
	movem 4,-1(17)
	movei 4,(1)
	hrli 4,-5(17)
	blt 4,4(1)
	move 0,(17)
	movem 0,-3(17)
	add 17,[-3,,-3]
	popj 17,

copy_load_ptrs:
	push 17,10
	move 10,1
	tlo 1,331100
	tlo 2,331100
	movei 3,24
	pushj 17,memmove
	move 1,10
	pop 17,10
	popj 17,

copy_store_ptrs:
	movei 4,(1)
	hrl 4,2
	blt 4,4(1)
	popj 17,

copy_index_ptrs:
	push 17,10
	move 10,1
	move 1,2
	move 2,3
	lsh 2,2
	add 2,3
	add 2,1
	move 3,4
	lsh 3,2
	add 3,4
	add 3,1
	movei 4,(2)
	hrl 4,3
	blt 4,4(2)
	move 1,10
	tlo 1,331100
	tlo 2,331100
	movei 3,24
	pushj 17,memmove
	move 1,10
	pop 17,10
	popj 17,

copy_cond_ptrs:
	add 17,[3,,3]
	move 0,-3(17)
	movem 0,(17)
	move 6,1
	movem 2,-3(17)
	movem 3,-2(17)
	movem 4,-1(17)
	skipn -13(17)
	jrst %L163
	movei 4,-5(17)
	hrli 4,-12(17)
	blt 4,-1(17)
%L163:
	movei 4,(6)
	hrli 4,-5(17)
	blt 4,4(6)
	move 0,(17)
	movem 0,-3(17)
	add 17,[-3,,-3]
	popj 17,

copy_union_arg:
	add 17,[3,,3]
	move 0,-3(17)
	movem 0,(17)
	movem 2,-3(17)
	movem 3,-2(17)
	movem 4,-1(17)
	movei 4,(1)
	hrli 4,-24(17)
	blt 4,23(1)
	move 0,(17)
	movem 0,-3(17)
	add 17,[-3,,-3]
	popj 17,

copy_union_store:
	movei 4,(1)
	hrl 4,2
	blt 4,23(1)
	popj 17,

make_pair:
	move 4,1
	move 5,2
	move 1,4
	move 2,5
	popj 17,

make_large:
	add 17,[24,,24]
	movei 3,-23(17)
	movei 4,23
%L175:
	movem 2,(3)
	addi 3,1
	addi 2,1
	sojge 4,%L175	; doloop_end
	movei 4,(1)
	hrli 4,-23(17)
	blt 4,23(1)
	add 17,[-24,,-24]
	popj 17,

make_nested:
	add 17,[64,,64]
	movem 10,-63(17)
	movem 11,-62(17)
	move 11,1
	move 10,2
	move 1,2
	aos 2,10
	pushj 17,make_pair
	movem 1,-61(17)
	movem 2,-60(17)
	move 6,g_qi
	movem 6,-57(17)
	move 6,g_qi+1
	movem 6,-56(17)
	movei 4,-55(17)
	hrli 4,g_half
	blt 4,-51(17)
	addi 10,1
	movei 1,-23(17)
	move 2,10
	pushj 17,make_large
	movei 4,-50(17)
	hrli 4,-23(17)
	blt 4,-25(17)
	addi 10,1
	movem 10,-24(17)
	movei 4,(11)
	hrli 4,-61(17)
	blt 4,35(11)
	move 1,11
	move 10,-63(17)
	move 11,-62(17)
	add 17,[-64,,-64]
	popj 17,

sum_pair:
	add 1,2
	popj 17,

sum_quad:
	add 17,[4,,4]
	movem 1,-3(17)
	movem 2,-2(17)
	movem 3,-1(17)
	movem 4,(17)
	move 1,-3(17)
	add 1,-2(17)
	add 1,-1(17)
	add 1,4
	add 17,[-4,,-4]
	popj 17,

sum_large:
	add 17,[4,,4]
	move 0,-4(17)
	movem 0,(17)
	movem 1,-4(17)
	movem 2,-3(17)
	movem 3,-2(17)
	movem 4,-1(17)
	move 1,-24(17)
	add 1,-21(17)
	add 1,-15(17)
	add 1,-7(17)
	add 1,4
	move 0,(17)
	movem 0,-4(17)
	add 17,[-4,,-4]
	popj 17,

sum_nested:
	add 17,[4,,4]
	move 0,-4(17)
	movem 0,(17)
	movem 1,-4(17)
	movem 2,-3(17)
	movem 3,-2(17)
	movem 4,-1(17)
	move 1,-36(17)
	add 1,-35(17)
	add 1,-25(17)
	add 1,-2(17)
	add 1,4
	move 0,(17)
	movem 0,-4(17)
	add 17,[-4,,-4]
	popj 17,

copy_globals:
	add 17,[56,,56]
	movem 10,-55(17)
	movem 11,-54(17)
	move 1,g_one
	pushj 17,copy_arg_one
	movem 1,g_one
	move 1,g_pair
	move 2,g_pair+1
	pushj 17,copy_arg_pair
	movem 1,g_pair
	movem 2,g_pair+1
	move 1,g_quad
	move 2,g_quad+1
	move 3,g_quad+2
	move 4,g_quad+3
	pushj 17,copy_arg_quad
	movem 1,-53(17)
	movem 2,-52(17)
	movem 3,-51(17)
	movem 4,-50(17)
	movei 4,g_quad
	hrli 4,-53(17)
	blt 4,g_quad+3
	movei 4,-20(17)
	hrli 4,g_large
	blt 4,(17)
	move 2,g_large+21
	move 3,g_large+22
	move 4,g_large+23
	movei 1,g_large
	pushj 17,copy_arg_large
	move 1,g_dint
	move 2,g_dint+1
	move 3,g_dint+2
	move 4,g_dint+3
	pushj 17,copy_arg_dint
	movem 1,-47(17)
	movem 2,-46(17)
	movem 3,-45(17)
	movem 4,-44(17)
	movei 4,g_dint
	hrli 4,-47(17)
	blt 4,g_dint+3
	move 1,g_qi
	move 2,g_qi+1
	pushj 17,copy_arg_qi
	movem 1,g_qi
	movem 2,g_qi+1
	movei 4,-1(17)
	hrli 4,g_half
	blt 4,(17)
	move 2,g_half+2
	move 3,g_half+3
	move 4,g_half+4
	move 1,[POINT 18,g_half,17]
	pushj 17,copy_arg_half
	move 1,g_bytes
	move 2,g_bytes+1
	pushj 17,copy_arg_bytes
	movem 1,-43(17)
	movem 2,-42(17)
	movei 4,g_bytes
	hrli 4,-43(17)
	blt 4,g_bytes+1
	move 1,g_32
	move 2,g_32+1
	move 3,g_32+2
	pushj 17,copy_arg_sc32
	movem 1,-41(17)
	movem 2,-40(17)
	movem 3,-37(17)
	movei 4,g_32
	hrli 4,-41(17)
	blt 4,g_32+2
	move 1,g_packed
	move 2,g_packed+1
	move 3,g_packed+2
	move 4,g_packed+3
	pushj 17,copy_arg_packed
	move 6,1
	move 7,2
	move 10,3
	move 11,4
	move 4,1
	lsh 4,-33
	dpb 4,[POINT 9,-36(17),8]
	ldb 4,[POINT 9,6,17]
	dpb 4,[POINT 9,-36(17),17]
	ldb 4,[POINT 9,6,26]
	dpb 4,[POINT 9,-36(17),26]
	ldb 4,[POINT 9,6,35]
	dpb 4,[POINT 9,-36(17),35]
	move 4,7
	lsh 4,-33
	dpb 4,[POINT 9,-35(17),8]
	ldb 4,[POINT 9,7,17]
	dpb 4,[POINT 9,-35(17),17]
	ldb 4,[POINT 9,7,26]
	dpb 4,[POINT 9,-35(17),26]
	ldb 4,[POINT 9,7,35]
	dpb 4,[POINT 9,-35(17),35]
	move 4,10
	lsh 4,-33
	dpb 4,[POINT 9,-34(17),8]
	ldb 4,[POINT 9,10,17]
	dpb 4,[POINT 9,-34(17),17]
	ldb 4,[POINT 9,10,26]
	dpb 4,[POINT 9,-34(17),26]
	ldb 4,[POINT 9,10,35]
	dpb 4,[POINT 9,-34(17),35]
	move 4,11
	lsh 4,-33
	dpb 4,[POINT 9,-33(17),8]
	ldb 4,[POINT 9,11,17]
	dpb 4,[POINT 9,-33(17),17]
	ldb 4,[POINT 9,11,26]
	dpb 4,[POINT 9,-33(17),26]
	ldb 4,[POINT 9,11,35]
	dpb 4,[POINT 9,-33(17),35]
	movei 2,-36(17)
	tlo 2,331100
	move 1,[POINT 9,g_packed,8]
	movei 3,20
	pushj 17,memcpy
	movei 4,-17(17)
	hrli 4,g_arrays
	blt 4,(17)
	move 2,g_arrays+20
	move 3,g_arrays+21
	move 4,g_arrays+22
	movei 1,g_arrays
	pushj 17,copy_arg_arrays
	movei 4,-32(17)
	hrli 4,g_nested
	blt 4,(17)
	move 2,g_nested+33
	move 3,g_nested+34
	move 4,g_nested+35
	movei 1,g_nested
	pushj 17,copy_arg_nested
	movei 4,-1(17)
	hrli 4,g_ptrs
	blt 4,(17)
	move 2,g_ptrs+2
	move 3,g_ptrs+3
	move 4,g_ptrs+4
	movei 1,g_ptrs
	pushj 17,copy_arg_ptrs
	movei 4,-20(17)
	hrli 4,g_union
	blt 4,(17)
	move 2,g_union+21
	move 3,g_union+22
	move 4,g_union+23
	movei 1,g_union
	pushj 17,copy_union_arg
	move 10,-55(17)
	move 11,-54(17)
	add 17,[-56,,-56]
	popj 17,

copy_global_to_pointer:
	movei 4,(1)
	hrli 4,g_large
	blt 4,23(1)
	popj 17,

copy_pointer_to_global:
	movei 4,g_large
	hrl 4,1
	blt 4,g_large+23
	popj 17,

copy_member_pair:
	move 6,(2)
	movem 6,(1)
	move 2,1(2)
	movem 2,1(1)
	popj 17,

copy_member_large:
	add 17,[24,,24]
	movei 4,-23(17)
	hrli 4,44(2)
	blt 4,(17)
	movei 6,11
	add 6,1
	movei 4,(6)
	hrli 4,-23(17)
	blt 4,34(1)
	add 17,[-24,,-24]
	popj 17,

copy_member_qi:
	move 6,2(2)
	movem 6,2(1)
	move 2,3(2)
	movem 2,3(1)
	popj 17,

copy_adjacent_large:
	movei 6,24
	add 6,1
	movei 4,(6)
	hrl 4,1
	blt 4,47(1)
	movei 6,50
	add 6,1
	movei 4,(6)
	hrli 4,24(1)
	blt 4,73(1)
	popj 17,

copy_adjacent_pair:
	move 6,(1)
	movem 6,2(1)
	move 6,1(1)
	movem 6,3(1)
	move 6,2(1)
	movem 6,4(1)
	move 6,3(1)
	movem 6,5(1)
	popj 17,

copy_from_volatile_pair:
	move 1,vg_pair
	move 2,vg_pair+1
	popj 17,

copy_to_volatile_pair:
	movem 1,vg_pair
	movem 2,vg_pair+1
	popj 17,

copy_from_volatile_large:
	add 17,[24,,24]
	movei 3,-23(17)
	hrli 3,vg_large
	blt 3,(17)
	movei 3,(1)
	hrli 3,-23(17)
	blt 3,23(1)
	add 17,[-24,,-24]
	popj 17,

copy_to_volatile_large:
	add 17,[4,,4]
	move 0,-4(17)
	movem 0,(17)
	movem 1,-4(17)
	movem 2,-3(17)
	movem 3,-2(17)
	movem 4,-1(17)
	movei 4,vg_large
	hrli 4,-24(17)
	blt 4,vg_large+23
	move 0,(17)
	movem 0,-4(17)
	add 17,[-4,,-4]
	popj 17,

copy_from_volatile_qi:
	move 1,vg_qi
	move 2,vg_qi+1
	popj 17,

copy_to_volatile_qi:
	movem 1,vg_qi
	movem 2,vg_qi+1
	popj 17,

copy_stack_small:
	move 2,1
	addi 2,1
	pushj 17,make_pair
	movem 1,g_pair
	movem 2,g_pair+1
	popj 17,

copy_stack_large:
	add 17,[74,,74]
	move 2,1
	movei 1,-73(17)
	pushj 17,make_large
	movei 4,-47(17)
	hrli 4,-73(17)
	blt 4,-24(17)
	movei 4,-23(17)
	hrli 4,-47(17)
	blt 4,(17)
	movei 4,g_large
	hrli 4,-23(17)
	blt 4,g_large+23
	add 17,[-74,,-74]
	popj 17,

copy_stack_nested:
	add 17,[74,,74]
	move 2,1
	movei 1,-73(17)
	pushj 17,make_nested
	movei 4,-35(17)
	hrli 4,-73(17)
	blt 4,(17)
	movei 4,g_nested
	hrli 4,-35(17)
	blt 4,g_nested+35
	add 17,[-74,,-74]
	popj 17,

copy_array_member:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	move 15,2
	move 2,3
	move 10,4
	andi 3,7
	add 3,1
	andi 4,7
	add 4,15
	move 4,(4)
	movem 4,(3)
	move 13,2
	andi 13,17
	move 14,1
	tlo 14,331100
	move 7,2
	andi 7,3
	move 4,7
	move 3,13
	ash 3,-2	; ashrsi3_pointer
	add 3,14
	jumpe 7,%L204
%L203:
	ibp 3
	sojn 4,%L203	; decrement_and_branch_until_zero
%L204:
	move 5,3
	addi 5,10
	move 1,10
	andi 1,17
	move 11,15
	tlo 11,331100
	move 6,10
	andi 6,3
	move 3,6
	move 4,1
	ash 4,-2	; ashrsi3_pointer
	add 4,11
	jumpe 6,%L207
%L206:
	ibp 4
	sojn 3,%L206	; decrement_and_branch_until_zero
%L207:
	addi 4,10
	ldb 4,4
	dpb 4,5
	move 3,13
	ash 3,-2	; ashrsi3_pointer
	add 3,14
	skipn 4,7
	jrst %L210
%L209:
	ibp 3
	sojn 4,%L209	; decrement_and_branch_until_zero
%L210:
	move 7,3
	addi 7,14
	move 4,1
	ash 4,-2	; ashrsi3_pointer
	add 4,11
	skipn 3,6
	jrst %L213
%L212:
	ibp 4
	sojn 3,%L212	; decrement_and_branch_until_zero
%L213:
	addi 4,14
	ldb 4,4
	dpb 4,7
	move 4,[125252525253]
	mul 4,2
	ashc 4,-44
	move 3,2
	ash 3,-43
	move 6,5
	sub 6,3
	move 3,6
	imuli 3,6
	sub 2,3
	move 3,2
	move 1,12
	tlo 1,222200
	move 4,2
	andi 4,1
	ash 3,-1	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L216
%L215:
	ibp 1
	sojn 4,%L215	; decrement_and_branch_until_zero
%L216:
	addi 1,20
	move 4,[125252525253]
	mul 4,10
	ashc 4,-44
	move 3,10
	ash 3,-43
	move 6,5
	sub 6,3
	move 3,6
	imuli 3,6
	sub 10,3
	move 3,10
	move 2,15
	tlo 2,222200
	move 6,10
	andi 6,1
	ash 3,-1	; ashrsi3_pointer
	add 2,3
	jumpe 6,%L219
%L218:
	ibp 2
	sojn 6,%L218	; decrement_and_branch_until_zero
%L219:
	addi 2,20
	ldb 4,2
	dpb 4,1	; movhi
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,

copy_ptr_struct:
	movei 4,(1)
	hrl 4,2
	blt 4,4(1)
	popj 17,

call_fn_from_copied_ptrs:
	add 17,[5,,5]
	movei 4,-4(17)
	hrl 4,1
	blt 4,(17)
	skipe 4,(17)
	jrst %L223
	move 1,2
%L221:
	add 17,[-5,,-5]
	popj 17,
%L223:
	move 1,2
	pushj 17,(4)
	jrst %L221

init_ptrs:
	move 6,[POINT 9,g_qi,8]
	movem 6,g_ptrs
	move 6,[POINT 9,g_qi,26]
	movem 6,g_ptrs+1
	movei 6,g_pair
	movem 6,g_ptrs+2
	move 6,[POINT 9,g_large,8]
	movem 6,g_ptrs+3
	movei 6,sc_fn
	movem 6,g_ptrs+4
	popj 17,

sizeof_structs:
	movei 1,744
	popj 17,

	.globl	use_struct_copy
use_struct_copy:
	add 17,[507,,507]
	movem 16,-506(17)
	movei 0,-505(17)
	hrli 0,10
	blt 0,-500(17)
	setzm -47(17)
	setzm -46(17)
	move 16,1
	move 15,2
	pushj 17,copy_globals
	move 1,16
	pushj 17,copy_stack_small
	move 1,16
	addi 1,1
	pushj 17,copy_stack_large
	move 1,16
	addi 1,2
	pushj 17,copy_stack_nested
	movei 1,-306(17)
	move 2,16
	pushj 17,make_large
	movei 4,-477(17)
	hrli 4,-306(17)
	blt 4,-454(17)
	movei 1,-262(17)
	movei 2,g_large
	pushj 17,copy_load_large
	movei 4,-453(17)
	hrli 4,-262(17)
	blt 4,-430(17)
	movei 4,-212(17)
	hrli 4,-477(17)
	blt 4,-167(17)
	movei 4,-44(17)
	hrli 4,-357(17)
	blt 4,-21(17)
	movem 15,-45(17)
	movei 4,-20(17)
	hrli 4,-212(17)
	blt 4,(17)
	move 2,-171(17)
	move 3,-170(17)
	move 4,-167(17)
	movei 1,-236(17)
	pushj 17,copy_cond_large
	movei 4,-427(17)
	hrli 4,-236(17)
	blt 4,-404(17)
	movei 13,-477(17)
	move 14,13
	addi 14,24
	move 2,13
	addi 2,50
	move 1,14
	pushj 17,copy_store_large
	move 1,13
	pushj 17,copy_adjacent_large
	move 2,16
	addi 2,3
	move 1,16
	pushj 17,make_pair
	movem 1,-403(17)
	movem 2,-402(17)
	movei 1,g_pair
	pushj 17,copy_load_pair
	movem 1,-401(17)
	movem 2,-400(17)
	movei 10,-403(17)
	move 1,10
	movei 2,0
	movei 3,1
	pushj 17,copy_index_pair
	movem 1,-377(17)
	movem 2,-376(17)
	move 1,10
	pushj 17,copy_adjacent_pair
	move 2,16
	addi 2,4
	movei 1,-375(17)
	pushj 17,make_nested
	movei 6,-375(17)
	movem 6,-50(17)
	movei 1,g_nested
	move 2,6
	pushj 17,copy_member_pair
	movei 1,g_nested
	move 2,-50(17)
	pushj 17,copy_member_large
	movei 1,g_nested
	move 2,-50(17)
	pushj 17,copy_member_qi
	movei 1,g_arrays
	move 2,1
	move 3,15
	aos 4,15
	pushj 17,copy_array_member
	pushj 17,init_ptrs
	movei 4,-337(17)
	hrli 4,g_ptrs
	blt 4,-333(17)
	movei 1,g_ptrs
	movei 2,-337(17)
	pushj 17,copy_ptr_struct
	movei 4,-212(17)
	hrlz 4,13
	blt 4,-167(17)
	movei 4,-332(17)
	hrli 4,-212(17)
	blt 4,-307(17)
	movei 1,g_union
	movei 2,-332(17)
	pushj 17,copy_union_store
	move 1,13
	pushj 17,copy_global_to_pointer
	move 1,14
	pushj 17,copy_pointer_to_global
	move 11,-403(17)
	move 12,-402(17)
	move 1,11
	move 2,12
	pushj 17,copy_to_volatile_pair
	movei 4,-212(17)
	hrlz 4,13
	blt 4,-167(17)
	movei 4,-17(17)
	hrli 4,-212(17)
	blt 4,(17)
	move 1,-172(17)
	move 2,-171(17)
	move 3,-170(17)
	move 4,-167(17)
	pushj 17,copy_to_volatile_large
	move 1,g_qi
	move 2,g_qi+1
	pushj 17,copy_to_volatile_qi
	pushj 17,copy_from_volatile_pair
	pushj 17,sum_pair
	move 12,1
	movei 1,-212(17)
	pushj 17,copy_from_volatile_large
	movei 4,-17(17)
	hrli 4,-212(17)
	blt 4,(17)
	move 1,-172(17)
	move 2,-171(17)
	move 3,-170(17)
	move 4,-167(17)
	pushj 17,sum_large
	add 12,1
	pushj 17,copy_from_volatile_qi
	lsh 1,33
	ash 1,-33
	add 12,1
	move 6,-403(17)
	movem 6,-47(17)
	move 6,-402(17)
	movem 6,-46(17)
	move 1,-47(17)
	move 2,-46(17)
	pushj 17,copy_arg_pair
	pushj 17,sum_pair
	add 12,1
	move 1,g_quad
	move 2,g_quad+1
	move 3,g_quad+2
	move 4,g_quad+3
	pushj 17,copy_arg_quad
	move 10,3
	move 11,4
	movem 1,-162(17)
	movem 2,-161(17)
	movem 3,-160(17)
	movem 4,-157(17)
	pushj 17,sum_quad
	add 12,1
	movei 4,-132(17)
	hrli 4,-237(17)
	blt 4,-107(17)
	movei 4,-20(17)
	hrli 4,-132(17)
	blt 4,(17)
	move 2,-111(17)
	move 3,-110(17)
	move 4,-107(17)
	movei 1,-156(17)
	pushj 17,copy_arg_large
	movei 4,-17(17)
	hrli 4,-156(17)
	blt 4,(17)
	move 1,-136(17)
	move 2,-135(17)
	move 3,-134(17)
	move 4,-133(17)
	pushj 17,sum_large
	add 12,1
	movei 4,-32(17)
	move 6,-50(17)
	hrlz 4,6
	blt 4,(17)
	move 2,-342(17)
	move 3,-341(17)
	move 4,-340(17)
	movei 1,-106(17)
	pushj 17,copy_arg_nested
	movei 4,-31(17)
	hrli 4,-106(17)
	blt 4,(17)
	move 1,-54(17)
	move 2,-53(17)
	move 3,-52(17)
	move 4,-51(17)
	pushj 17,sum_nested
	add 12,1
	movei 1,g_ptrs
	move 2,16
	pushj 17,call_fn_from_copied_ptrs
	add 12,1
	pushj 17,sizeof_structs
	add 12,1
	move 1,12
	move 16,-506(17)
	movei 0,10
	hrli 0,-505(17)
	blt 0,15
	add 17,[-507,,-507]
	popj 17,

	.bss
g_half:
	.space	20
g_bytes:
	.space	8
g_32:
	.space	12
g_packed:
	.space	16
g_arrays:
	.space	76
g_nested:
	.space	120
g_ptrs:
	.space	20
g_union:
	.space	80
vg_pair:
	.space	8
vg_large:
	.space	80
vg_qi:
	.space	8
