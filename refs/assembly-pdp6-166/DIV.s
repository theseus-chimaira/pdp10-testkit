
div_reg:
	move 5,3
	ash 3,-43
	move 4,3
	move 3,4
	move 4,5
	pushj 17,__divdi3
	move 1,2
	popj 17,

div_mem:
	move 6,(3)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__divdi3
	move 1,2
	popj 17,

div_volatile_mem:
	move 6,(3)
	ash 6,-43
	move 4,(3)
	move 3,6
	pushj 17,__divdi3
	move 1,2
	popj 17,

divi_small:
	movei 3,0
	movei 4,123456
	pushj 17,__divdi3
	move 1,2
	popj 17,

divi_one:
	move 1,2
	popj 17,

divi_two:
	jumpge 1,.+4
	jfcl 17,.+1
	addi 2,1
	jcry0 [aoja 1,.+1]
	lshc 1,-1
	move 1,2
	popj 17,

divi_max18:
	movei 3,0
	movei 4,777777
	pushj 17,__divdi3
	move 1,2
	popj 17,

div_literal:
	move 3,[0]
	move 4,[123456123456]
	pushj 17,__divdi3
	move 1,2
	popj 17,

div_literal_2:
	move 3,[0]
	move 4,[377777000000]
	pushj 17,__divdi3
	move 1,2
	popj 17,

div_literal_neg:
	move 3,[777777777777]
	move 4,[777654321655]
	pushj 17,__divdi3
	move 1,2
	popj 17,

div_reg_from_mem:
	move 4,2
	ash 2,-43
	move 3,2
	move 6,(1)
	move 7,1(1)
	move 1,6
	move 2,7
	pushj 17,__divdi3
	move 1,2
	popj 17,

div_mem_mem:
	move 2,(2)
	move 4,2
	ash 2,-43
	move 3,2
	move 6,(1)
	move 7,1(1)
	move 1,6
	move 2,7
	pushj 17,__divdi3
	move 1,2
	popj 17,

div_store:
	push 17,10
	move 10,1
	move 1,2
	move 2,3
	move 6,4
	ash 6,-43
	move 3,6
	pushj 17,__divdi3
	movem 2,(10)
	move 1,2
	pop 17,10
	popj 17,

div_store_void:
	push 17,10
	move 10,1
	move 1,2
	move 2,3
	move 6,4
	ash 6,-43
	move 3,6
	pushj 17,__divdi3
	movem 2,(10)
	pop 17,10
	popj 17,

div_assign_local:
	push 17,10
	move 6,3
	move 10,4
	move 4,3
	ash 6,-43
	move 3,6
	pushj 17,__divdi3
	move 4,1
	move 5,2
	move 3,5
	ash 3,-43
	move 2,5
	move 1,3
	move 4,10
	ash 10,-43
	move 3,10
	pushj 17,__divdi3
	move 1,2
	pop 17,10
	popj 17,

div_with_add:
	push 17,10
	move 6,3
	move 10,4
	move 4,3
	ash 6,-43
	move 3,6
	pushj 17,__divdi3
	add 10,2
	move 1,10
	pop 17,10
	popj 17,

div_with_sub:
	push 17,10
	move 6,3
	move 10,4
	move 4,3
	ash 6,-43
	move 3,6
	pushj 17,__divdi3
	move 6,2
	sub 6,10
	move 1,6
	pop 17,10
	popj 17,

div_with_mul:
	push 17,10
	move 6,3
	move 10,4
	move 4,3
	ash 6,-43
	move 3,6
	pushj 17,__divdi3
	imul 10,2
	move 1,10
	pop 17,10
	popj 17,

div_quot_rem_sum:
	add 17,[5,,5]
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	move 13,1
	move 14,2
	move 11,3
	ash 3,-43
	move 10,3
	move 3,10
	move 4,11
	pushj 17,__divdi3
	move 12,2
	move 1,13
	move 2,14
	move 3,10
	move 4,11
	pushj 17,__moddi3
	add 12,2
	move 1,12
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-5,,-5]
	popj 17,

div_quot_rem_mem:
	add 17,[5,,5]
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	move 13,1
	move 14,2
	move 4,(3)
	move 11,4
	ash 4,-43
	move 10,4
	move 3,10
	move 4,11
	pushj 17,__divdi3
	move 12,2
	move 1,13
	move 2,14
	move 3,10
	move 4,11
	pushj 17,__moddi3
	add 12,2
	move 1,12
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-5,,-5]
	popj 17,

div_quot_rem_const:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 11,1
	move 12,2
	movei 3,0
	movei 4,123456
	pushj 17,__divdi3
	move 10,2
	move 1,11
	move 2,12
	movei 3,0
	movei 4,123456
	pushj 17,__moddi3
	add 10,2
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

div_quot_rem_literal:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 11,1
	move 12,2
	move 3,[0]
	move 4,[123456123456]
	pushj 17,__divdi3
	move 10,2
	move 1,11
	move 2,12
	move 3,[0]
	move 4,[123456123456]
	pushj 17,__moddi3
	add 10,2
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

div_rem_only:
	move 5,3
	ash 3,-43
	move 4,3
	move 3,4
	move 4,5
	pushj 17,__moddi3
	move 1,2
	popj 17,

div_rem_mem_only:
	move 6,(3)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__moddi3
	move 1,2
	popj 17,

div_rem_const_only:
	movei 3,0
	movei 4,123456
	pushj 17,__moddi3
	move 1,2
	popj 17,

divm_mem:
	push 17,10
	move 10,3
	move 6,(3)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__divdi3
	movem 2,(10)
	move 1,2
	pop 17,10
	popj 17,

divm_mem_void:
	push 17,10
	move 10,3
	move 6,(3)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__divdi3
	movem 2,(10)
	pop 17,10
	popj 17,

divm_volatile_mem:
	push 17,10
	move 10,3
	move 6,(3)
	ash 6,-43
	move 4,(3)
	move 3,6
	pushj 17,__divdi3
	movem 2,(10)
	move 1,(10)
	pop 17,10
	popj 17,

divm_array:
	push 17,10
	move 10,3
	andi 4,7
	add 10,4
	move 6,(10)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__divdi3
	movem 2,(10)
	move 1,2
	pop 17,10
	popj 17,

divm_struct:
	push 17,10
	move 10,3
	move 6,1(3)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__divdi3
	movem 2,1(10)
	move 1,2
	pop 17,10
	popj 17,

div_array_divisor:
	andi 4,7
	add 3,4
	move 6,(3)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__divdi3
	move 1,2
	popj 17,

div_struct_divisor:
	move 6,2(3)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__divdi3
	move 1,2
	popj 17,

div_call_pressure:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,3
	move 6,3
	ash 6,-43
	move 4,3
	move 3,6
	pushj 17,__divdi3
	move 10,2
	pushj 17,clobber
	add 10,11
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

div_two_divs:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	move 13,2
	move 6,3
	move 10,4
	move 4,3
	ash 6,-43
	move 3,6
	pushj 17,__divdi3
	move 11,2
	move 4,10
	ash 10,-43
	move 3,10
	move 1,12
	move 2,13
	pushj 17,__divdi3
	add 11,2
	move 1,11
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

div_two_mem_divs:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 11,1
	move 12,2
	move 13,4
	move 6,(3)
	move 4,6
	ash 6,-43
	move 3,6
	pushj 17,__divdi3
	move 10,2
	move 2,(13)
	move 4,2
	ash 2,-43
	move 3,2
	move 1,11
	move 2,12
	pushj 17,__divdi3
	add 10,2
	move 1,10
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

div_nested:
	push 17,10
	move 6,3
	move 10,4
	move 4,3
	ash 6,-43
	move 3,6
	pushj 17,__divdi3
	move 4,1
	move 5,2
	move 3,5
	ash 3,-43
	move 2,5
	move 1,3
	move 4,10
	ash 10,-43
	move 3,10
	pushj 17,__divdi3
	move 1,2
	pop 17,10
	popj 17,

div_from_sint_widen:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,3
	move 7,1
	ash 1,-43
	move 6,1
	lshc 6,22
	move 5,2
	ash 2,-43
	move 4,2
	move 2,7
	add 2,5
	move 3,2
	tlc 3,400000
	move 10,7
	tlc 10,400000
	caml 3,10
	tdza 3,3
	movei 3,1
	move 1,6
	add 1,4
	add 1,3
	move 4,11
	ash 11,-43
	move 3,11
	pushj 17,__divdi3
	move 1,2
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

div_from_uint_widen:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,3
	move 5,1
	movei 4,0
	lshc 4,22
	move 7,2
	movei 6,0
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
	move 4,11
	ash 11,-43
	move 3,11
	pushj 17,__divdi3
	move 1,2
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

div_small_signed_inputs:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,3
	hrre 1,1
	move 7,1
	ash 1,-43
	move 6,1
	lshc 6,11
	lsh 2,33
	ash 2,-33
	move 5,2
	ash 2,-43
	move 4,2
	move 2,7
	add 2,5
	move 3,2
	tlc 3,400000
	move 10,7
	tlc 10,400000
	caml 3,10
	tdza 3,3
	movei 3,1
	move 1,6
	add 1,4
	add 1,3
	move 4,11
	ash 11,-43
	move 3,11
	pushj 17,__divdi3
	move 1,2
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

div_small_unsigned_inputs:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,3
	hrrz 7,1
	movei 6,0
	lshc 6,11
	move 5,2
	andi 5,777
	movei 4,0
	move 2,7
	add 2,5
	move 3,2
	tlc 3,400000
	move 10,7
	tlc 10,400000
	caml 3,10
	tdza 3,3
	movei 3,1
	move 1,6
	add 1,4
	add 1,3
	move 4,11
	ash 11,-43
	move 3,11
	pushj 17,__divdi3
	move 1,2
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

