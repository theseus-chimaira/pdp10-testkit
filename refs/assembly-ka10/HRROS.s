
hrros_mem:
	hrros 4,(1)
	move 1,4
	popj 17,

hrros_mem_alt:
	hrros 4,(1)
	move 1,4
	popj 17,

hrros_mem_return_ac:
	hrros 4,(1)
	move 1,4
	popj 17,

hrros_global:
	hrros 1,hrros_ga
	popj 17,

hrros_global_b:
	hrros 1,hrros_gb
	popj 17,

hrros_array:
	andi 2,17
	add 1,2
	hrros 4,(1)
	move 1,4
	popj 17,

hrros_global_array:
	andi 1,17
	hrros 4,hrros_buf(1)
	move 1,4
	popj 17,

hrros_struct_a:
	hrros 4,(1)
	move 1,4
	popj 17,

hrros_struct_b:
	hrros 4,1(1)
	move 1,4
	popj 17,

hrros_global_struct_a:
	hrros 1,hrros_gp
	popj 17,

hrros_global_struct_b:
	hrros 1,hrros_gp+1
	popj 17,

hrros_indirect:
	hrros 4,@(1)
	move 1,4
	popj 17,

hrros_volatile:
	move 4,1
	move 1,(1)
	hrro 1,1
	movem 1,(4)
	popj 17,

hrros_volatile_global:
	move 1,hrros_vga
	hrro 1,1
	movem 1,hrros_vga
	popj 17,

hrros_add:
	hrros 4,(1)
	add 4,2
	move 1,4
	popj 17,

hrros_sub:
	hrros 4,(1)
	sub 4,2
	move 1,4
	popj 17,

hrros_xor:
	hrros 4,(1)
	xor 4,2
	move 1,4
	popj 17,

hrros_or:
	hrros 4,(1)
	ior 4,2
	move 1,4
	popj 17,

hrros_and:
	hrros 4,(1)
	and 4,2
	move 1,4
	popj 17,

hrros_call_add:
	push 17,10
	hrros 10,(1)
	pushj 17,f
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

hrros_call_before:
	push 17,10
	move 10,1
	pushj 17,f
	move 4,1
	hrros 1,(10)
	add 1,4
	pop 17,10
	popj 17,

hrros_if_result_zero:
	move 6,(1)
	hrrom 6,(1)
	move 1,3
	popj 17,

hrros_if_result_nonzero:
	move 6,(1)
	hrrom 6,(1)
	move 1,2
	popj 17,

hrros_if_result_negative:
	move 6,(1)
	hrrom 6,(1)
	move 1,2
	popj 17,

hrros_likely:
	hrros 4,(1)
	move 1,4
	popj 17,

hrros_unlikely:
	hrros 4,(1)
	move 1,4
	popj 17,

hrros_left_is_ones:
	hrros 4,(1)
	hllz 4,4
	move 1,4
	popj 17,

hrros_right_bits:
	hrros 4,(1)
	hrrz 4,4
	move 1,4
	popj 17,

hrros_right_nonzero:
	hrros 4,(1)
	hrrz 4,4
	skipe 4
	movei 4,1
	move 1,4
	popj 17,

hrros_left_ones_bool:
	hrros 4,(1)
	hllz 4,4
	movsi 6,777777
	came 4,6
	tdza 4,4
	movei 4,1
	move 1,4
	popj 17,

hrros_mix_after_ones:
	hrros 4,(1)
	add 4,2
	move 1,4
	popj 17,

hrros_source_live:
	move 3,1
	move 4,(1)
	hrro 1,4
	movem 1,(3)
	add 1,4
	add 1,2
	popj 17,

hrros_right_source_live:
	hrrz 3,(1)
	hrro 4,3
	movem 4,(1)
	add 4,3
	move 1,4
	popj 17,

hrros_left_source_dead:
	move 4,(1)
	hrro 3,4
	movem 3,(1)
	hllz 4,4
	add 3,4
	move 1,3
	popj 17,

hrros_two_updates:
	hrros 3,(1)
	hrros 4,(2)
	add 3,4
	move 1,3
	popj 17,

hrros_loop:
	move 6,1
	movei 1,0
	move 4,2
	subi 2,1
	jumple 4,%L49
	move 3,(6)
%L47:
	hrros 1,3
	move 4,2
	subi 2,1
	jumpg 4,%L47
	movem 1,(6)
%L49:
	popj 17,

hrros_loop_sum:
	move 6,1
	movei 1,0
	move 4,2
	subi 2,1
	jumple 4,%L57
	move 3,(6)
%L55:
	hrro 3,3
	add 1,3
	move 4,2
	subi 2,1
	jumpg 4,%L55
	movem 3,(6)
%L57:
	popj 17,

hrros_loop_break:
	move 4,2
	subi 2,1
	jumple 4,%L66
	move 3,(1)
%L64:
	hrro 3,3
	move 4,2
	subi 2,1
	jumpg 4,%L64
	movem 3,(1)
%L66:
	move 1,(1)
	popj 17,

hrros_store_then_load:
	hrros 4,(1)
	move 1,4
	popj 17,

hrros_store_then_bool:
	move 6,(1)
	hrrom 6,(1)
	movei 1,1
	popj 17,

hrros_store_then_add:
	hrros 4,(1)
	add 4,2
	move 1,4
	popj 17,

uhrros_mem:
	hrros 4,(1)
	move 1,4
	popj 17,

uhrros_global:
	hrros 1,hrros_uga
	popj 17,

uhrros_array:
	andi 2,17
	add 1,2
	hrros 4,(1)
	move 1,4
	popj 17,

uhrros_global_array:
	andi 1,17
	hrros 4,hrros_ubuf(1)
	move 1,4
	popj 17,

uhrros_struct_a:
	hrros 4,(1)
	move 1,4
	popj 17,

uhrros_global_struct_a:
	hrros 1,hrros_ugp
	popj 17,

uhrros_add:
	hrros 4,(1)
	add 4,2
	move 1,4
	popj 17,

uhrros_bool:
	move 6,(1)
	hrrom 6,(1)
	movei 1,1
	popj 17,

uhrros_right_bits:
	hrros 4,(1)
	hrrz 4,4
	move 1,4
	popj 17,

hrros_sqi_temp:
	lsh 2,33
	ash 2,-33
	hrro 2,2
	movem 2,(1)
	move 1,2
	popj 17,

hrros_uqi_temp:
	andi 2,777
	hrro 2,2
	movem 2,(1)
	move 1,2
	popj 17,

hrros_hi_temp:
	hrro 2,2
	movem 2,(1)
	move 1,2
	popj 17,

hrros_uhi_temp:
	hrro 2,2
	movem 2,(1)
	move 1,2
	popj 17,

	.bss
hrros_ga:
	.space	4
hrros_gb:
	.space	4
hrros_uga:
	.space	4
hrros_vga:
	.space	4
hrros_buf:
	.space	64
hrros_ubuf:
	.space	64
hrros_gp:
	.space	8
hrros_ugp:
	.space	8
