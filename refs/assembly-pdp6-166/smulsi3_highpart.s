
opaque_si:
	movem 1,smulhp_opaque
	move 1,smulhp_opaque
	popj 17,

mulm1:
	push 17,10
	move 4,1
	move 6,2
	move 10,3
	move 2,1
	ash 4,-43
	move 1,4
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	add 10,2
	move 1,10
	pop 17,10
	popj 17,

mulm2:
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

smulhp_reg:
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

smulhp_reg_commuted:
	move 6,1
	move 4,2
	ash 4,-43
	move 1,4
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_reg_opaque:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,2
	pushj 17,opaque_si
	move 10,1
	move 1,11
	pushj 17,opaque_si
	move 11,1
	move 2,10
	ash 10,-43
	move 1,10
	move 4,11
	ash 11,-43
	move 3,11
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

smulhp_local:
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

smulhp_reuse_left:
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

smulhp_reuse_right:
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

smulhp_zero:
	movei 1,0
	popj 17,

smulhp_one:
	ash 1,-43
	popj 17,

smulhp_minus_one:
	move 5,1
	ash 1,-43
	move 4,1
	setcm 1,4
	movn 2,5
	jumpe 2,[aoja 1,.+1]
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_small_positive:
	push 17,10
	move 7,1
	ash 1,-43
	move 6,1
	move 2,6
	move 3,7
	lshc 2,2
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
	lshc 4,2
	move 3,5
	add 3,7
	move 1,3
	tlc 1,400000
	move 10,5
	tlc 10,400000
	caml 1,10
	tdza 1,1
	movei 1,1
	move 2,4
	add 2,6
	add 2,1
	lshc 2,2
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
	move 1,4
	move 2,5
	lshc 1,-43
	move 1,2
	pop 17,10
	popj 17,

smulhp_small_negative:
	move 4,1
	move 2,1
	ash 4,-43
	move 1,4
	seto 3,
	movni 4,83
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_large_positive:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	ash 1,-43
	move 10,1
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
	move 1,4
	move 2,5
	lshc 1,1
	lshc 1,-43
	move 1,2
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

smulhp_large_negative:
	move 4,1
	move 2,1
	ash 4,-43
	move 1,4
	seto 3,
	movni 4,42798
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_const_left:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	ash 1,-43
	move 10,1
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
	move 1,4
	move 2,5
	lshc 1,1
	lshc 1,-43
	move 1,2
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

smulhp_const_negative_left:
	move 4,1
	move 2,1
	ash 4,-43
	move 1,4
	seto 3,
	movni 4,42798
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_mem_left:
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
	move 1,2
	popj 17,

smulhp_mem_right:
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

smulhp_mem_mem:
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
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_mem_loaded:
	move 4,(1)
	move 6,(2)
	move 2,4
	ash 4,-43
	move 1,4
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_global_left:
	move 6,1
	move 4,smulhp_ga
	move 2,4
	ash 4,-43
	move 1,4
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_global_right:
	move 4,1
	move 2,1
	ash 4,-43
	move 1,4
	move 6,smulhp_ga
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_global_global:
	move 4,smulhp_ga
	move 2,4
	ash 4,-43
	move 1,4
	move 6,smulhp_gb
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_volatile_left:
	move 6,1
	move 4,smulhp_vga
	move 2,4
	ash 4,-43
	move 1,4
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_volatile_right:
	move 4,1
	move 6,smulhp_vga
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

smulhp_volatile_mem:
	move 4,(1)
	move 6,(2)
	move 2,4
	ash 4,-43
	move 1,4
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_array_left:
	move 6,3
	andi 2,17
	add 1,2
	move 4,(1)
	move 2,4
	ash 4,-43
	move 1,4
	move 4,3
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_array_right:
	move 4,1
	move 6,2
	move 2,1
	ash 4,-43
	move 1,4
	andi 3,17
	add 6,3
	move 6,(6)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_array_array:
	move 6,1
	andi 2,17
	add 2,1
	move 4,(2)
	move 2,4
	ash 4,-43
	move 1,4
	andi 3,17
	add 6,3
	move 6,(6)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_global_array_left:
	move 6,2
	andi 1,17
	move 4,smulhp_buf(1)
	move 2,4
	ash 4,-43
	move 1,4
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_global_array_right:
	move 4,1
	move 3,2
	move 2,1
	ash 4,-43
	move 1,4
	andi 3,17
	move 6,smulhp_buf(3)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_global_array_array:
	move 3,2
	andi 1,17
	move 4,smulhp_buf(1)
	move 2,4
	ash 4,-43
	move 1,4
	andi 3,17
	move 6,smulhp_buf(3)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_struct_a:
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
	move 1,2
	popj 17,

smulhp_struct_b:
	move 3,1
	move 4,2
	ash 4,-43
	move 1,4
	move 6,1(3)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_struct_ab:
	move 3,1
	move 4,(1)
	move 2,4
	ash 4,-43
	move 1,4
	move 6,1(3)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_global_struct_a:
	move 6,1
	move 4,smulhp_gp
	move 2,4
	ash 4,-43
	move 1,4
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_global_struct_b:
	move 4,1
	move 2,1
	ash 4,-43
	move 1,4
	move 6,smulhp_gp+1
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_global_struct_ab:
	move 4,smulhp_gp
	move 2,4
	ash 4,-43
	move 1,4
	move 6,smulhp_gp+1
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_three_ab:
	move 3,1
	move 4,(1)
	move 2,4
	ash 4,-43
	move 1,4
	move 6,1(3)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_three_bc:
	move 3,1
	move 4,1(1)
	move 2,4
	ash 4,-43
	move 1,4
	move 6,2(3)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_indirect_left:
	move 6,2
	move 4,@(1)
	move 2,4
	ash 4,-43
	move 1,4
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_indirect_right:
	move 4,1
	move 3,2
	move 2,1
	ash 4,-43
	move 1,4
	move 6,@(3)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_indexed_indirect:
	move 6,3
	andi 2,17
	add 2,(1)
	move 4,(2)
	move 2,4
	ash 4,-43
	move 1,4
	move 4,3
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_expr_add:
	move 4,1
	move 6,3
	add 4,2
	move 2,4
	ash 4,-43
	move 1,4
	move 4,3
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_expr_sub:
	move 4,1
	move 6,3
	sub 4,2
	move 2,4
	ash 4,-43
	move 1,4
	move 4,3
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_expr_xor:
	move 4,1
	move 6,3
	xor 4,2
	move 2,4
	ash 4,-43
	move 1,4
	move 4,3
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_expr_and:
	move 4,1
	move 6,3
	and 4,2
	move 2,4
	ash 4,-43
	move 1,4
	move 4,3
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_expr_or:
	move 4,1
	move 6,3
	ior 4,2
	move 2,4
	ash 4,-43
	move 1,4
	move 4,3
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_expr_neg:
	move 6,2
	movn 4,1
	move 2,4
	ash 4,-43
	move 1,4
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_expr_shift:
	move 4,1
	move 6,2
	ash 4,-3
	move 2,4
	ash 4,-43
	move 1,4
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_two_exprs:
	move 6,1
	move 7,3
	add 6,2
	sub 7,4
	move 2,6
	ash 6,-43
	move 1,6
	move 4,7
	ash 7,-43
	move 3,7
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_call_expr:
	push 17,10
	move 10,1
	pushj 17,f
	move 4,1
	move 2,1
	ash 4,-43
	move 1,4
	move 4,10
	ash 10,-43
	move 3,10
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	pop 17,10
	popj 17,

smulhp_store:
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
	lshc 1,-43
	movem 2,(10)
	pop 17,10
	popj 17,

smulhp_store_return:
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
	lshc 1,-43
	movem 2,(10)
	move 1,2
	pop 17,10
	popj 17,

smulhp_store_return_mem:
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
	lshc 1,-43
	movem 2,(10)
	move 1,2
	pop 17,10
	popj 17,

smulhp_store_global:
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
	movem 2,smulhp_ga
	popj 17,

smulhp_store_global_return:
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
	movem 2,smulhp_ga
	move 1,2
	popj 17,

smulhp_store_array:
	push 17,10
	move 10,1
	move 6,4
	andi 2,17
	add 10,2
	move 2,3
	ash 3,-43
	move 1,3
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	movem 2,(10)
	pop 17,10
	popj 17,

smulhp_store_array_return:
	push 17,10
	move 10,1
	move 6,4
	andi 2,17
	add 10,2
	move 2,3
	ash 3,-43
	move 1,3
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	movem 2,(10)
	move 1,2
	pop 17,10
	popj 17,

smulhp_store_struct_a:
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
	lshc 1,-43
	movem 2,(10)
	pop 17,10
	popj 17,

smulhp_store_struct_b_return:
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
	lshc 1,-43
	movem 2,1(10)
	move 1,2
	pop 17,10
	popj 17,

smulhp_store_indirect:
	push 17,10
	move 4,2
	move 6,3
	move 10,(1)
	ash 4,-43
	move 1,4
	move 4,3
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	movem 2,(10)
	pop 17,10
	popj 17,

smulhp_volatile_store:
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
	lshc 1,-43
	movem 2,(10)
	pop 17,10
	popj 17,

smulhp_add:
	push 17,10
	move 4,1
	move 6,2
	move 10,3
	move 2,1
	ash 4,-43
	move 1,4
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	add 10,2
	move 1,10
	pop 17,10
	popj 17,

smulhp_sub:
	push 17,10
	move 4,1
	move 6,2
	move 10,3
	move 2,1
	ash 4,-43
	move 1,4
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	sub 1,10
	pop 17,10
	popj 17,

smulhp_xor:
	push 17,10
	move 4,1
	move 6,2
	move 10,3
	move 2,1
	ash 4,-43
	move 1,4
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	xor 10,2
	move 1,10
	pop 17,10
	popj 17,

smulhp_or:
	push 17,10
	move 4,1
	move 6,2
	move 10,3
	move 2,1
	ash 4,-43
	move 1,4
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	ior 10,2
	move 1,10
	pop 17,10
	popj 17,

smulhp_and:
	push 17,10
	move 4,1
	move 6,2
	move 10,3
	move 2,1
	ash 4,-43
	move 1,4
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	and 10,2
	move 1,10
	pop 17,10
	popj 17,

smulhp_mul_again:
	push 17,10
	move 4,1
	move 6,2
	move 10,3
	move 2,1
	ash 4,-43
	move 1,4
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	trne 1,1
	seto 1,
	move 4,10
	ash 10,-43
	move 3,10
	pushj 17,__muldi3
	move 1,2
	pop 17,10
	popj 17,

smulhp_sources_live:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 10,1
	move 11,2
	move 12,3
	move 4,1
	ash 4,-43
	move 2,1
	move 1,4
	move 6,11
	ash 6,-43
	move 4,11
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	add 10,2
	add 10,11
	add 10,12
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

smulhp_memory_sources_live:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,3
	move 10,(1)
	move 11,(2)
	move 4,10
	ash 4,-43
	move 2,10
	move 1,4
	move 6,11
	ash 6,-43
	move 4,11
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	add 10,2
	add 10,11
	add 10,12
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

smulhp_two_values:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 6,1
	move 7,2
	move 10,3
	move 12,4
	move 2,1
	ash 6,-43
	move 1,6
	move 4,7
	ash 7,-43
	move 3,7
	pushj 17,__muldi3
	lshc 1,-43
	move 11,2
	move 2,10
	ash 10,-43
	move 1,10
	move 4,12
	ash 12,-43
	move 3,12
	pushj 17,__muldi3
	lshc 1,-43
	add 11,2
	move 1,11
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

smulhp_two_mems:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 6,2
	move 11,3
	move 12,4
	move 4,(1)
	move 2,4
	ash 4,-43
	move 1,4
	move 6,(6)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 10,2
	move 4,(11)
	move 2,4
	ash 4,-43
	move 1,4
	move 6,(12)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	add 10,2
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

smulhp_branch_zero:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 6,1
	move 7,2
	move 10,3
	move 11,4
	move 2,1
	ash 6,-43
	move 1,6
	move 4,7
	ash 7,-43
	move 3,7
	pushj 17,__muldi3
	lshc 1,-43
	move 3,10
	jumpe 2,%L158
	move 3,11
%L158:
	move 1,3
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

smulhp_branch_nonzero:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 6,1
	move 7,2
	move 10,3
	move 11,4
	move 2,1
	ash 6,-43
	move 1,6
	move 4,7
	ash 7,-43
	move 3,7
	pushj 17,__muldi3
	lshc 1,-43
	move 3,10
	jumpn 2,%L161
	move 3,11
%L161:
	move 1,3
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

smulhp_branch_negative:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 6,1
	move 7,2
	move 11,3
	move 10,4
	move 2,1
	ash 6,-43
	move 1,6
	move 4,7
	ash 7,-43
	move 3,7
	pushj 17,__muldi3
	lshc 1,-43
	move 3,11
	jumpl 2,%L164
	move 3,10
%L164:
	move 1,3
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

smulhp_branch_positive:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 6,1
	move 7,2
	move 10,3
	move 11,4
	move 2,1
	ash 6,-43
	move 1,6
	move 4,7
	ash 7,-43
	move 3,7
	pushj 17,__muldi3
	lshc 1,-43
	move 3,10
	jumple 2,%L170
%L167:
	move 1,3
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,
%L170:
	move 3,11
	jrst %L167

smulhp_likely:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	move 4,1
	ash 4,-43
	move 2,1
	move 1,4
	move 6,10
	ash 6,-43
	move 4,10
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 4,2
	jumpe 2,%L174
%L171:
	move 1,4
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,
%L174:
	move 4,11
	add 4,10
	jrst %L171

smulhp_unlikely:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	move 4,1
	ash 4,-43
	move 2,1
	move 1,4
	move 6,10
	ash 6,-43
	move 4,10
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 4,2
	jumpn 2,%L175
	move 4,11
	add 4,10
%L175:
	move 1,4
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

smulhp_call_pressure_reg:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 6,2
	move 4,1
	ash 4,-43
	move 2,1
	move 1,4
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 10,2
	pushj 17,clobber
	add 10,11
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

smulhp_call_pressure_mem:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
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
	lshc 1,-43
	move 10,2
	pushj 17,clobber
	add 10,(11)
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

smulhp_store_call_pressure:
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
	lshc 1,-43
	movem 2,(10)
	pushj 17,clobber
	move 1,(10)
	pop 17,10
	popj 17,

smulhp_loop_sum:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 15,1
	move 13,2
	move 14,3
	setzb 11,10
	caml 11,2
	jrst %L193
	move 12,3
	ash 12,-43
%L191:
	move 4,10
	andi 4,17
	add 4,15
	move 4,(4)
	move 2,4
	ash 4,-43
	move 1,4
	move 4,14
	move 3,12
	pushj 17,__muldi3
	lshc 1,-43
	add 11,2
	addi 10,1
	camge 10,13
	jrst %L191
%L193:
	move 1,11
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,

smulhp_loop_store:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 15,1
	move 12,2
	move 13,3
	movei 11,0
	caml 11,2
	jrst %L204
	move 14,3
	ash 14,-43
%L202:
	move 10,11
	andi 10,17
	add 10,15
	move 4,(10)
	move 2,4
	ash 4,-43
	move 1,4
	move 4,13
	move 3,14
	pushj 17,__muldi3
	lshc 1,-43
	movem 2,(10)
	addi 11,1
	camge 11,12
	jrst %L202
%L204:
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,

smulhp_loop_store_sum:
	add 17,[7,,7]
	movem 16,-6(17)
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 16,1
	move 14,2
	move 15,3
	setzb 12,11
	caml 12,2
	jrst %L216
	move 13,3
	ash 13,-43
%L214:
	move 10,11
	andi 10,17
	add 10,16
	move 4,(10)
	move 2,4
	ash 4,-43
	move 1,4
	move 4,15
	move 3,13
	pushj 17,__muldi3
	lshc 1,-43
	movem 2,(10)
	add 12,2
	addi 11,1
	camge 11,14
	jrst %L214
%L216:
	move 1,12
	move 16,-6(17)
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-7,,-7]
	popj 17,

smulhp_qi:
	move 4,1
	lsh 4,33
	ash 4,-33
	move 6,2
	lsh 6,33
	ash 6,-33
	move 2,4
	ash 4,-43
	move 1,4
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_hi:
	hrre 4,1
	hrre 6,2
	move 2,4
	ash 4,-43
	move 1,4
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_qi_si:
	move 6,2
	move 4,1
	lsh 4,33
	ash 4,-33
	move 2,4
	ash 4,-43
	move 1,4
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_hi_si:
	move 6,2
	hrre 4,1
	move 2,4
	ash 4,-43
	move 1,4
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_qi_mem:
	move 6,2
	ldb 4,1
	trne 4,400
	orcmi 4,777
	move 2,4
	ash 4,-43
	move 1,4
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_hi_mem:
	move 6,2
	ldb 4,1
	hrre 4,4
	move 2,4
	ash 4,-43
	move 1,4
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__muldi3
	lshc 1,-43
	move 1,2
	popj 17,

smulhp_both_regaa:
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

smulhp_both_regab:
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

smulhp_both_regba:
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

smulhp_both_regbb:
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

smulhp_both_memaa:
	push 17,10
	move 6,1
	move 10,2
	move 4,(2)
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

smulhp_both_memab:
	push 17,10
	move 6,1
	move 10,2
	move 4,(2)
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

smulhp_both_memba:
	push 17,10
	move 6,1
	move 10,2
	move 4,(2)
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

smulhp_both_membb:
	push 17,10
	move 6,1
	move 10,2
	move 4,(2)
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

	.globl	smulsi3_highpart_smoke
smulsi3_highpart_smoke:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	move 13,2
	move 11,3
	pushj 17,smulhp_reg
	move 10,1
	move 1,13
	move 2,11
	move 3,12
	pushj 17,smulhp_add
	add 10,1
	move 1,12
	move 2,11
	move 3,13
	pushj 17,smulhp_expr_sub
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

	.globl	shpmem
shpmem:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 11,1
	move 13,2
	move 12,3
	pushj 17,smulhp_mem_mem
	move 10,1
	move 1,11
	move 2,10
	move 3,12
	pushj 17,smulhp_store_return
	add 10,1
	move 1,11
	move 2,13
	move 3,12
	pushj 17,smulhp_memory_sources_live
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

	.globl	shpctl
shpctl:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,2
	move 11,3
	pushj 17,smulhp_loop_sum
	move 10,1
	move 2,11
	move 3,12
	move 4,11
	pushj 17,smulhp_branch_nonzero
	add 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

	.bss
smulhp_ga:
	.space	4
smulhp_gb:
	.space	4
smulhp_gc:
	.space	4
smulhp_vga:
	.space	4
smulhp_opaque:
	.space	4
smulhp_buf:
	.space	64
smulhp_gp:
	.space	8
smulhp_gt:
	.space	12
