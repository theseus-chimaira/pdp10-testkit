
mul_reg_reg:
	move 4,1
	move 6,2
	move 2,4
	ash 4,-43
	move 1,4
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	popj 17,

mul_reg_mem:
	move 4,1
	move 3,2
	move 2,1
	ash 4,-43
	move 1,4
	move 6,(3)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	popj 17,

mul_mem_reg:
	move 6,2
	move 4,(1)
	move 2,4
	ash 4,-43
	move 1,4
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	popj 17,

mul_mem_mem:
	move 3,2
	move 4,(1)
	move 2,4
	ash 4,-43
	move 1,4
	move 6,(3)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	popj 17,

mul_global_a:
	move 4,1
	move 2,1
	ash 4,-43
	move 1,4
	move 6,mul_ga
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	popj 17,

mul_global_b:
	move 4,mul_ga
	move 2,4
	ash 4,-43
	move 1,4
	move 6,mul_gb
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	popj 17,

mul_array:
	move 6,1
	move 4,2
	move 2,3
	ash 3,-43
	move 1,3
	andi 4,17
	add 6,4
	move 6,(6)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	popj 17,

mul_global_array:
	move 3,1
	move 4,2
	ash 4,-43
	move 1,4
	andi 3,17
	move 6,mul_buf(3)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	popj 17,

mul_struct_a:
	move 3,1
	move 4,2
	ash 4,-43
	move 1,4
	move 6,(3)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	popj 17,

mul_struct_b:
	move 3,1
	move 4,2
	ash 4,-43
	move 1,4
	move 6,1(3)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	popj 17,

mul_global_struct_a:
	move 4,1
	move 2,1
	ash 4,-43
	move 1,4
	move 6,mul_gp
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	popj 17,

mul_global_struct_b:
	move 4,1
	move 2,1
	ash 4,-43
	move 1,4
	move 6,mul_gp+1
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	popj 17,

muli_one:
	move 4,1
	move 2,1
	ash 4,-43
	move 1,4
	popj 17,

muli_two:
	move 4,1
	move 2,1
	ash 4,-43
	move 1,4
	lshc 1,1
	popj 17,

muli_small:
	push 17,10
	move 7,1
	ash 1,-43
	move 6,1
	move 2,6
	move 3,7
	lshc 2,1
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
	lshc 4,6
	move 3,5
	sub 3,7
	move 1,3
	tlc 1,400000
	move 10,5
	tlc 10,400000
	camg 1,10
	tdza 1,1
	movei 1,1
	move 2,4
	sub 2,6
	sub 2,1
	lshc 2,4
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
	move 6,4
	move 7,5
	lshc 6,3
	move 2,7
	sub 2,5
	move 3,2
	tlc 3,400000
	move 10,7
	tlc 10,400000
	camg 3,10
	tdza 3,3
	movei 3,1
	move 1,6
	sub 1,4
	sub 1,3
	lshc 1,1
	pop 17,10
	popj 17,

muli_max18:
	push 17,10
	move 5,1
	ash 1,-43
	move 4,1
	move 6,4
	move 7,5
	lshc 6,22
	move 2,7
	sub 2,5
	move 3,2
	tlc 3,400000
	move 10,7
	tlc 10,400000
	camg 3,10
	tdza 3,3
	movei 3,1
	move 1,6
	sub 1,4
	sub 1,3
	pop 17,10
	popj 17,

mul_literal:
	move 5,1
	ash 1,-43
	move 4,1
	move 1,4
	move 2,5
	move 3,[0]
	move 4,[123456123456]
	pushj 17,__muldi3
	popj 17,

mul_literal_2:
	push 17,10
	move 5,1
	ash 1,-43
	move 4,1
	move 6,4
	move 7,5
	lshc 6,21
	move 2,7
	sub 2,5
	move 3,2
	tlc 3,400000
	move 10,7
	tlc 10,400000
	camg 3,10
	tdza 3,3
	movei 3,1
	move 1,6
	sub 1,4
	sub 1,3
	lshc 1,22
	pop 17,10
	popj 17,

mul_literal_neg:
	move 5,1
	ash 1,-43
	move 4,1
	move 1,4
	move 2,5
	seto 3,
	movni 4,42798
	pushj 17,__muldi3
	popj 17,

mul_commuted_literal:
	move 5,1
	ash 1,-43
	move 4,1
	move 1,4
	move 2,5
	move 3,[0]
	move 4,[123456123456]
	pushj 17,__muldi3
	popj 17,

mul_commuted_small:
	push 17,10
	move 7,1
	ash 1,-43
	move 6,1
	move 2,6
	move 3,7
	lshc 2,1
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
	lshc 4,6
	move 3,5
	sub 3,7
	move 1,3
	tlc 1,400000
	move 10,5
	tlc 10,400000
	camg 1,10
	tdza 1,1
	movei 1,1
	move 2,4
	sub 2,6
	sub 2,1
	lshc 2,4
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
	move 6,4
	move 7,5
	lshc 6,3
	move 2,7
	sub 2,5
	move 3,2
	tlc 3,400000
	move 10,7
	tlc 10,400000
	camg 3,10
	tdza 3,3
	movei 3,1
	move 1,6
	sub 1,4
	sub 1,3
	lshc 1,1
	pop 17,10
	popj 17,

mul_store_reg:
	push 17,10
	move 10,1
	move 4,2
	move 6,3
	ash 4,-43
	move 1,4
	move 4,3
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	movem 1,(10)
	movem 2,1(10)
	pop 17,10
	popj 17,

mul_store_mem:
	push 17,10
	move 10,1
	move 4,2
	ash 4,-43
	move 1,4
	move 6,(3)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	movem 1,(10)
	movem 2,1(10)
	pop 17,10
	popj 17,

mul_store_return:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	move 4,2
	move 6,3
	ash 4,-43
	move 1,4
	move 4,3
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	movem 1,(12)
	movem 2,1(12)
	move 10,(12)
	move 11,2
	move 1,10
	move 2,11
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

mul_low_reg:
	imul 1,2
	popj 17,

mul_low_mem:
	imul 1,(2)
	popj 17,

mul_high_reg:
	move 4,1
	move 6,2
	move 2,1
	ash 4,-43
	move 1,4
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

mul_high_mem:
	move 4,1
	move 3,2
	move 2,1
	ash 4,-43
	move 1,4
	move 6,(3)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

mul_high_literal:
	move 4,1
	move 2,1
	ash 4,-43
	move 1,4
	move 3,[0]
	move 4,[123456123456]
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

mulm_reg_mem:
	push 17,10
	move 4,1
	move 10,2
	move 2,1
	ash 4,-43
	move 1,4
	move 6,(10)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	movem 2,(10)
	pop 17,10
	popj 17,

mulm_mem_reg:
	push 17,10
	move 10,1
	move 6,2
	move 4,(1)
	move 2,4
	ash 4,-43
	move 1,4
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	movem 2,(10)
	pop 17,10
	popj 17,

mulm_global:
	move 4,1
	move 2,1
	ash 4,-43
	move 1,4
	move 6,mul_ga
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	movem 2,mul_ga
	popj 17,

mulm_global_2:
	move 6,1
	move 4,mul_gb
	move 2,4
	ash 4,-43
	move 1,4
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	movem 2,mul_gb
	popj 17,

mulm_array:
	push 17,10
	move 10,1
	andi 2,17
	add 10,2
	move 2,3
	ash 3,-43
	move 1,3
	move 6,(10)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	movem 2,(10)
	pop 17,10
	popj 17,

mulm_global_array:
	push 17,10
	move 10,1
	move 4,2
	andi 10,17
	ash 4,-43
	move 1,4
	move 6,mul_buf(10)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	movem 2,mul_buf(10)
	pop 17,10
	popj 17,

mulm_struct_a:
	push 17,10
	move 10,1
	move 4,2
	ash 4,-43
	move 1,4
	move 6,(10)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	movem 2,(10)
	pop 17,10
	popj 17,

mulm_struct_b:
	push 17,10
	move 10,1
	move 6,2
	move 4,1(1)
	move 2,4
	ash 4,-43
	move 1,4
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	movem 2,1(10)
	pop 17,10
	popj 17,

mulm_const_small:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	move 4,(1)
	move 11,4
	ash 4,-43
	move 10,4
	move 2,10
	move 3,11
	lshc 2,1
	move 5,3
	add 5,11
	move 1,5
	tlc 1,400000
	move 6,3
	tlc 6,400000
	caml 1,6
	tdza 1,1
	movei 1,1
	move 4,2
	add 4,10
	add 4,1
	lshc 4,6
	move 3,5
	sub 3,11
	move 1,3
	tlc 1,400000
	move 6,5
	tlc 6,400000
	camg 1,6
	tdza 1,1
	movei 1,1
	move 2,4
	sub 2,10
	sub 2,1
	lshc 2,4
	move 7,3
	add 7,11
	move 4,7
	tlc 4,400000
	move 1,3
	tlc 1,400000
	caml 4,1
	tdza 4,4
	movei 4,1
	move 6,2
	add 6,10
	add 6,4
	move 2,6
	move 3,7
	lshc 2,3
	move 5,3
	sub 5,7
	move 1,5
	tlc 1,400000
	move 10,3
	tlc 10,400000
	camg 1,10
	tdza 1,1
	movei 1,1
	move 4,2
	sub 4,6
	sub 4,1
	lshc 4,1
	lshc 4,-43
	movem 5,(12)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

mulm_const_literal:
	push 17,10
	move 10,1
	move 4,(1)
	move 2,4
	ash 4,-43
	move 1,4
	move 3,[0]
	move 4,[123456123456]
	pushj 17,__muldi3
	lshc 1,-43
	movem 2,(10)
	pop 17,10
	popj 17,

mulb_reg_mem:
	push 17,10
	move 4,1
	move 10,2
	move 2,1
	ash 4,-43
	move 1,4
	move 6,(10)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	movem 2,(10)
	move 1,2
	pop 17,10
	popj 17,

mulb_mem_reg:
	push 17,10
	move 10,1
	move 6,2
	move 4,(1)
	move 2,4
	ash 4,-43
	move 1,4
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	movem 2,(10)
	move 1,2
	pop 17,10
	popj 17,

mulb_global:
	move 4,1
	move 2,1
	ash 4,-43
	move 1,4
	move 6,mul_ga
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	movem 2,mul_ga
	move 1,2
	popj 17,

mulb_global_2:
	move 6,1
	move 4,mul_gb
	move 2,4
	ash 4,-43
	move 1,4
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	movem 2,mul_gb
	move 1,2
	popj 17,

mulb_array:
	push 17,10
	move 10,1
	andi 2,17
	add 10,2
	move 2,3
	ash 3,-43
	move 1,3
	move 6,(10)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	movem 2,(10)
	move 1,2
	pop 17,10
	popj 17,

mulb_global_array:
	push 17,10
	move 10,1
	move 4,2
	andi 10,17
	ash 4,-43
	move 1,4
	move 6,mul_buf(10)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	movem 2,mul_buf(10)
	move 1,2
	pop 17,10
	popj 17,

mulb_struct_a:
	push 17,10
	move 10,1
	move 4,2
	ash 4,-43
	move 1,4
	move 6,(10)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	movem 2,(10)
	move 1,2
	pop 17,10
	popj 17,

mulb_struct_b:
	push 17,10
	move 10,1
	move 6,2
	move 4,1(1)
	move 2,4
	ash 4,-43
	move 1,4
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	movem 2,1(10)
	move 1,2
	pop 17,10
	popj 17,

mulb_self:
	push 17,10
	move 10,1
	move 4,(1)
	move 2,4
	ash 4,-43
	move 1,4
	move 3,1
	move 4,2
	pushj 17,__muldi3
	lshc 1,-43
	movem 2,(10)
	move 1,2
	pop 17,10
	popj 17,

umul_reg_reg:
	move 6,1
	move 3,2
	move 7,6
	movei 6,0
	move 4,3
	movei 3,0
	move 1,6
	move 2,7
	pushj 17,__muldi3
	popj 17,

umul_reg_mem:
	move 7,1
	movei 6,0
	move 4,(2)
	movei 3,0
	move 1,6
	move 2,7
	pushj 17,__muldi3
	popj 17,

umuli_small:
	push 17,10
	move 2,1
	movei 1,0
	move 6,1
	move 7,2
	lshc 6,1
	move 5,7
	add 5,2
	move 3,5
	tlc 3,400000
	move 10,7
	tlc 10,400000
	caml 3,10
	tdza 3,3
	movei 3,1
	move 4,6
	add 4,1
	add 4,3
	lshc 4,6
	move 7,5
	sub 7,2
	move 3,7
	tlc 3,400000
	move 10,5
	tlc 10,400000
	camg 3,10
	tdza 3,3
	movei 3,1
	move 6,4
	sub 6,1
	sub 6,3
	lshc 6,4
	move 5,7
	add 5,2
	move 3,5
	tlc 3,400000
	move 10,7
	tlc 10,400000
	caml 3,10
	tdza 3,3
	movei 3,1
	move 4,6
	add 4,1
	add 4,3
	move 6,4
	move 7,5
	lshc 6,3
	move 2,7
	sub 2,5
	move 3,2
	tlc 3,400000
	move 10,7
	tlc 10,400000
	camg 3,10
	tdza 3,3
	movei 3,1
	move 1,6
	sub 1,4
	sub 1,3
	lshc 1,1
	pop 17,10
	popj 17,

umul_literal:
	move 2,1
	movei 1,0
	move 3,[0]
	move 4,[123456123456]
	pushj 17,__muldi3
	popj 17,

umul_low:
	imul 1,2
	popj 17,

	.bss
mul_ga:
	.space	4
mul_gb:
	.space	4
mul_gc:
	.space	4
mul_buf:
	.space	64
mul_gp:
	.space	8
