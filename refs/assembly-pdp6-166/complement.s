	.data
	.align	2
gs1:
	.word	1
	.align	2
gs2:
	.word	777777777777

clobber:
	movem 1,vgs
	popj 17,

neg:
	movn 1,1
	popj 17,

not:
	setca 1,
	popj 17,

not2:
	setca 1,
	popj 17,

plain_complement:
	setca 1,
	popj 17,

plain_negative:
	movn 1,1
	popj 17,

complement_plus_one:
	movn 1,1
	popj 17,

negative_minus_one:
	setca 1,
	popj 17,

negative_parenthesized:
	setca 1,
	popj 17,

complement_of_sum:
	add 1,2
	setca 1,
	popj 17,

complement_of_difference:
	sub 1,2
	setca 1,
	popj 17,

complement_after_shift:
	andi 2,7
	lsh 1,(2)
	setca 1,
	popj 17,

complement_before_shift:
	setca 1,
	andi 2,7
	movn 2,2
	ash 1,(2)
	popj 17,

u_plain_complement:
	setca 1,
	popj 17,

u_complement_plus_one:
	movn 1,1
	popj 17,

u_negative_minus_one:
	setca 1,
	popj 17,

u_xor_all_ones:
	setca 1,
	popj 17,

mem_complement:
	setcm 1,(1)
	popj 17,

umem_complement:
	setcm 1,(1)
	popj 17,

volatile_mem_complement:
	move 1,vgs
	setca 1,
	popj 17,

volatile_umem_complement:
	move 1,vgu
	setca 1,
	popj 17,

store_complement:
	move 4,2
	setcab 4,(1)
	move 1,4
	popj 17,

store_negative:
	movn 2,2
	movem 2,(1)
	move 1,2
	popj 17,

store_complement_plus_one:
	movn 2,2
	movem 2,(1)
	move 1,2
	popj 17,

update_complement:
	setcmb (1),4
	move 1,4
	popj 17,

update_negative:
	movns 4,(1)
	move 1,4
	popj 17,

struct_complement:
	setcm 3,(1)
	movem 3,1(1)
	setcmb 2(1),4
	add 3,4
	move 1,3
	popj 17,

struct_negative_forms:
	move 4,1
	movn 1,1(1)
	movem 1,(4)
	move 3,1
	setcab 3,1(4)
	add 1,3
	popj 17,

q_complement:
	lsh 1,33
	ash 1,-33
	setca 1,
	popj 17,

uq_complement:
	orcbi 1,777
	popj 17,

h_complement:
	hrre 1,1
	setca 1,
	popj 17,

uh_complement:
	orcbi 1,777777
	popj 17,

q_mem_complement:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	setca 1,
	popj 17,

h_mem_complement:
	ldb 1,1
	hrre 1,1
	setca 1,
	popj 17,

subword_store_complement:
	move 4,1
	orcbi 2,777
	addi 4,3
	dpb 2,[POINT 9,(4),8]
	subi 4,3
	dpb 2,[POINT 9,3(4),17]
	orcbi 3,777777
	hrrm 3,3(4)
	hrlzm 3,4(4)
	move 1,3(4)
	ash 1,-33
	ldb 3,[POINT 9,3(4),17]
	add 1,3
	hrre 3,3(4)
	add 1,3
	hlrz 4,4(4)
	add 1,4
	popj 17,

complement_zero:
	seto 1,
	popj 17,

complement_one:
	hrroi 1,777776
	popj 17,

complement_minus_one:
	movei 1,0
	popj 17,

complement_unsigned_zero:
	seto 1,
	popj 17,

branch_on_complement_zero:
	movei 4,13
	came 1,[-1]
	movei 4,26
	move 1,4
	popj 17,

branch_on_complement_nonzero:
	movei 4,41
	camn 1,[-1]
	movei 4,54
	move 1,4
	popj 17,

branch_on_complement_sign:
	movei 4,67
	jumpge 1,%L45
	movei 4,102
%L45:
	move 1,4
	popj 17,

branch_on_complement_mask:
	andca 1,2
	movei 4,115
	jumpn 1,%L47
	movei 4,100
%L47:
	move 1,4
	popj 17,

select_complement:
	setca 2,
	jumpn 1,%L51
	setcm 2,3
%L51:
	move 1,2
	popj 17,

mixed_complement:
	move 6,1
	setca 1,
	movn 4,2
	movem 4,(3)
	add 1,4
	sub 1,6
	sub 1,2
	subi 1,2
	popj 17,

force_globals:
	move 4,1
	setcab 4,gs0
	addi 1,1
	movem 1,gs1
	setcam 1,gs2
	movem 4,gu0
	movem 4,gq
	movem 4,guq
	movem 4,gh
	movem 4,guh
	movei 1,gw
	pushj 17,clobber
	move 1,gs0
	add 1,gs1
	add 1,gs2
	add 1,gu0
	hrre 4,gq
	add 1,4
	ldb 6,[POINT 18,guq,35]
	add 1,6
	hrre 4,gh
	add 1,4
	hlrz 6,guh
	add 1,6
	popj 17,

use_complement_all:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	move 11,2
	move 14,3
	pushj 17,neg
	move 10,1
	move 1,11
	pushj 17,not
	add 10,1
	move 15,12
	add 15,11
	move 1,15
	pushj 17,not2
	add 10,1
	move 1,12
	pushj 17,plain_complement
	add 10,1
	move 1,11
	pushj 17,plain_negative
	add 10,1
	move 1,12
	pushj 17,complement_plus_one
	add 10,1
	move 1,11
	pushj 17,negative_minus_one
	add 10,1
	move 1,12
	pushj 17,negative_parenthesized
	add 10,1
	move 1,12
	move 2,11
	pushj 17,complement_of_sum
	add 10,1
	move 1,12
	move 2,11
	pushj 17,complement_of_difference
	add 10,1
	move 1,12
	move 2,14
	pushj 17,complement_after_shift
	add 10,1
	move 1,11
	move 2,14
	pushj 17,complement_before_shift
	add 10,1
	move 1,12
	pushj 17,u_plain_complement
	add 10,1
	move 1,11
	pushj 17,u_complement_plus_one
	add 10,1
	move 1,12
	pushj 17,u_negative_minus_one
	add 10,1
	move 1,11
	pushj 17,u_xor_all_ones
	add 10,1
	movei 1,gs0
	pushj 17,mem_complement
	add 10,1
	movei 1,gu0
	pushj 17,umem_complement
	add 10,1
	pushj 17,volatile_mem_complement
	add 10,1
	pushj 17,volatile_umem_complement
	add 10,1
	movei 1,gs0
	move 2,12
	pushj 17,store_complement
	add 10,1
	movei 1,gs1
	move 2,11
	pushj 17,store_negative
	add 10,1
	movei 1,gs2
	move 2,15
	pushj 17,store_complement_plus_one
	add 10,1
	movei 1,gs0
	pushj 17,update_complement
	add 10,1
	movei 1,gs1
	pushj 17,update_negative
	add 10,1
	movei 1,gw
	pushj 17,struct_complement
	add 10,1
	movei 1,gw
	pushj 17,struct_negative_forms
	add 10,1
	move 13,12
	lsh 13,33
	ash 13,-33
	move 1,13
	pushj 17,q_complement
	add 10,1
	move 1,11
	andi 1,777	; zero_extendqisi2
	pushj 17,uq_complement
	add 10,1
	hrre 1,12	; extendhisi2
	pushj 17,h_complement
	add 10,1
	move 1,11
	hrrzi 1,(1)	; zero_extendhisi2
	pushj 17,uh_complement
	add 10,1
	move 1,[POINT 18,gq,35]
	pushj 17,q_mem_complement
	add 10,1
	move 1,[POINT 18,gh,35]
	pushj 17,h_mem_complement
	add 10,1
	hrre 3,11	; extendhisi2
	movei 1,gw
	move 2,13
	pushj 17,subword_store_complement
	add 10,1
	pushj 17,complement_zero
	add 10,1
	pushj 17,complement_one
	add 10,1
	pushj 17,complement_minus_one
	add 10,1
	pushj 17,complement_unsigned_zero
	add 10,1
	move 1,12
	pushj 17,branch_on_complement_zero
	add 10,1
	move 1,11
	pushj 17,branch_on_complement_nonzero
	add 10,1
	move 1,15
	pushj 17,branch_on_complement_sign
	add 10,1
	move 1,12
	move 2,11
	pushj 17,branch_on_complement_mask
	add 10,1
	andi 14,1
	move 1,14
	move 2,12
	move 3,11
	pushj 17,select_complement
	add 10,1
	move 1,12
	move 2,11
	movei 3,gs0
	pushj 17,mixed_complement
	add 10,1
	move 1,10
	pushj 17,force_globals
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,

	.bss
gs0:
	.space	4
gu0:
	.space	4
vgs:
	.space	4
vgu:
	.space	4
gq:
	.space	4
guq:
	.space	4
gh:
	.space	4
guh:
	.space	4
gw:
	.space	20
