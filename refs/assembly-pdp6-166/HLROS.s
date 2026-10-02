
hlros_mem:
	hlro 4,(1)
	movem 4,(1)
	move 1,4
	popj 17,

hlros_mem_alt:
	hlro 4,(1)
	movem 4,(1)
	move 1,4
	popj 17,

hlros_mem_return_ac:
	hlro 4,(1)
	movem 4,(1)
	move 1,4
	popj 17,

hlros_global:
	hlro 1,hlros_ga
	movem 1,hlros_ga
	popj 17,

hlros_global_b:
	hlro 1,hlros_gb
	movem 1,hlros_gb
	popj 17,

hlros_array:
	andi 2,17
	add 1,2
	hlro 4,(1)
	movem 4,(1)
	move 1,4
	popj 17,

hlros_global_array:
	andi 1,17
	hlro 4,hlros_buf(1)
	movem 4,hlros_buf(1)
	move 1,4
	popj 17,

hlros_struct_a:
	hlro 4,(1)
	movem 4,(1)
	move 1,4
	popj 17,

hlros_struct_b:
	hlro 4,1(1)
	movem 4,1(1)
	move 1,4
	popj 17,

hlros_global_struct_a:
	hlro 1,hlros_gp
	movem 1,hlros_gp
	popj 17,

hlros_global_struct_b:
	hlro 1,hlros_gp+1
	movem 1,hlros_gp+1
	popj 17,

hlros_indirect:
	move 4,(1)
	hlro 1,(4)
	movem 1,(4)
	popj 17,

hlros_volatile:
	move 4,1
	move 1,(1)
	hlro 1,1
	movem 1,(4)
	popj 17,

hlros_volatile_global:
	move 1,hlros_vga
	hlro 1,1
	movem 1,hlros_vga
	popj 17,

hlros_add:
	hlro 4,(1)
	movem 4,(1)
	add 4,2
	move 1,4
	popj 17,

hlros_sub:
	hlro 4,(1)
	movem 4,(1)
	sub 4,2
	move 1,4
	popj 17,

hlros_xor:
	hlro 4,(1)
	movem 4,(1)
	xor 4,2
	move 1,4
	popj 17,

hlros_or:
	hlro 4,(1)
	movem 4,(1)
	ior 4,2
	move 1,4
	popj 17,

hlros_and:
	hlro 4,(1)
	movem 4,(1)
	and 4,2
	move 1,4
	popj 17,

hlros_call_add:
	push 17,10
	hlro 10,(1)
	movem 10,(1)
	pushj 17,f
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

hlros_call_before:
	push 17,10
	move 10,1
	pushj 17,f
	move 4,1
	hlro 1,(10)
	movem 1,(10)
	add 1,4
	pop 17,10
	popj 17,

hlros_if_result_zero:
	hlro 4,(1)
	movem 4,(1)
	move 1,3
	popj 17,

hlros_if_result_nonzero:
	hlro 4,(1)
	movem 4,(1)
	move 1,2
	popj 17,

hlros_if_result_negative:
	hlro 4,(1)
	movem 4,(1)
	move 1,2
	popj 17,

hlros_likely:
	hlro 4,(1)
	movem 4,(1)
	move 1,4
	popj 17,

hlros_unlikely:
	hlro 4,(1)
	movem 4,(1)
	move 1,4
	popj 17,

hlros_left_is_ones:
	move 4,1
	hlro 1,(1)
	movem 1,(4)
	hllz 1,1
	popj 17,

hlros_right_bits:
	move 4,1
	hlro 1,(1)
	movem 1,(4)
	hrrz 1,1
	popj 17,

hlros_right_nonzero:
	move 4,1
	hlro 1,(1)
	movem 1,(4)
	hrrz 1,1
	skipe 1
	movei 1,1
	popj 17,

hlros_left_ones_bool:
	move 4,1
	hlro 1,(1)
	movem 1,(4)
	hllz 1,1
	movsi 6,777777
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

hlros_mix_after_ones:
	hlro 4,(1)
	movem 4,(1)
	add 4,2
	move 1,4
	popj 17,

hlros_source_live:
	move 3,1
	move 4,(1)
	hlro 1,4
	movem 1,(3)
	add 1,4
	add 1,2
	popj 17,

hlros_left_source_live:
	hllz 3,(1)
	hlro 4,3
	movem 4,(1)
	add 4,3
	move 1,4
	popj 17,

hlros_right_source_dead:
	move 3,(1)
	hlro 4,3
	movem 4,(1)
	addi 4,(3)
	move 1,4
	popj 17,

hlros_two_updates:
	move 4,1
	hlro 1,(1)
	movem 1,(4)
	hlro 4,(2)
	movem 4,(2)
	add 1,4
	popj 17,

hlros_loop:
	move 6,1
	movei 1,0
	move 4,2
	subi 2,1
	jumple 4,%L49
	move 3,(6)
%L47:
	hlro 1,3
	move 3,1
	move 4,2
	subi 2,1
	jumpg 4,%L47
	movem 1,(6)
%L49:
	popj 17,

hlros_loop_sum:
	move 6,1
	movei 1,0
	move 4,2
	subi 2,1
	jumple 4,%L57
	move 3,(6)
%L55:
	hlro 3,3
	add 1,3
	move 4,2
	subi 2,1
	jumpg 4,%L55
	movem 3,(6)
%L57:
	popj 17,

hlros_loop_break:
	move 4,2
	subi 2,1
	jumple 4,%L66
	move 3,(1)
%L64:
	hlro 3,3
	move 4,2
	subi 2,1
	jumpg 4,%L64
	movem 3,(1)
%L66:
	move 1,(1)
	popj 17,

hlros_store_then_load:
	hlro 4,(1)
	movem 4,(1)
	move 1,4
	popj 17,

hlros_store_then_bool:
	hlro 4,(1)
	movem 4,(1)
	movei 1,1
	popj 17,

hlros_store_then_add:
	hlro 4,(1)
	movem 4,(1)
	add 4,2
	move 1,4
	popj 17,

uhlros_mem:
	hlro 4,(1)
	movem 4,(1)
	move 1,4
	popj 17,

uhlros_global:
	hlro 1,hlros_uga
	movem 1,hlros_uga
	popj 17,

uhlros_array:
	andi 2,17
	add 1,2
	hlro 4,(1)
	movem 4,(1)
	move 1,4
	popj 17,

uhlros_global_array:
	andi 1,17
	hlro 4,hlros_ubuf(1)
	movem 4,hlros_ubuf(1)
	move 1,4
	popj 17,

uhlros_struct_a:
	hlro 4,(1)
	movem 4,(1)
	move 1,4
	popj 17,

uhlros_global_struct_a:
	hlro 1,hlros_ugp
	movem 1,hlros_ugp
	popj 17,

uhlros_add:
	hlro 4,(1)
	movem 4,(1)
	add 4,2
	move 1,4
	popj 17,

uhlros_bool:
	hlro 4,(1)
	movem 4,(1)
	movei 1,1
	popj 17,

uhlros_right_bits:
	move 4,1
	hlro 1,(1)
	movem 1,(4)
	hrrz 1,1
	popj 17,

hlros_sqi_temp:
	lsh 2,33
	ash 2,-33
	hrro 2,2
	movem 2,(1)
	move 1,2
	popj 17,

hlros_uqi_temp:
	andi 2,777
	hrro 2,2
	movem 2,(1)
	move 1,2
	popj 17,

hlros_hi_temp:
	hrro 2,2
	movem 2,(1)
	move 1,2
	popj 17,

hlros_uhi_temp:
	hrro 2,2
	movem 2,(1)
	move 1,2
	popj 17,

	.bss
hlros_ga:
	.space	4
hlros_gb:
	.space	4
hlros_uga:
	.space	4
hlros_vga:
	.space	4
hlros_buf:
	.space	64
hlros_ubuf:
	.space	64
hlros_gp:
	.space	8
hlros_ugp:
	.space	8
