
hllos_mem:
	hllos 4,(1)
	move 1,4
	popj 17,

hllos_mem_alt:
	hllos 4,(1)
	move 1,4
	popj 17,

hllos_mem_return_ac:
	hllos 4,(1)
	move 1,4
	popj 17,

hllos_global:
	hllos 1,hllos_ga
	popj 17,

hllos_global_b:
	hllos 1,hllos_gb
	popj 17,

hllos_array:
	andi 2,17
	add 1,2
	hllos 4,(1)
	move 1,4
	popj 17,

hllos_global_array:
	andi 1,17
	hllos 4,hllos_buf(1)
	move 1,4
	popj 17,

hllos_struct_a:
	hllos 4,(1)
	move 1,4
	popj 17,

hllos_struct_b:
	hllos 4,1(1)
	move 1,4
	popj 17,

hllos_global_struct_a:
	hllos 1,hllos_gp
	popj 17,

hllos_global_struct_b:
	hllos 1,hllos_gp+1
	popj 17,

hllos_indirect:
	hllos 4,@(1)
	move 1,4
	popj 17,

hllos_volatile:
	move 4,1
	move 1,(1)
	hllo 1,1
	movem 1,(4)
	popj 17,

hllos_add:
	hllos 4,(1)
	add 4,2
	move 1,4
	popj 17,

hllos_sub:
	hllos 4,(1)
	sub 4,2
	move 1,4
	popj 17,

hllos_xor:
	hllos 4,(1)
	xor 4,2
	move 1,4
	popj 17,

hllos_or:
	hllos 4,(1)
	ior 4,2
	move 1,4
	popj 17,

hllos_and:
	hllos 4,(1)
	and 4,2
	move 1,4
	popj 17,

hllos_call_add:
	push 17,10
	hllos 10,(1)
	pushj 17,f
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

hllos_call_before:
	push 17,10
	move 10,1
	pushj 17,f
	move 4,1
	hllos 1,(10)
	add 1,4
	pop 17,10
	popj 17,

hllos_if_result_zero:
	move 6,(1)
	hllom 6,(1)
	move 1,3
	popj 17,

hllos_if_result_nonzero:
	move 6,(1)
	hllom 6,(1)
	move 1,2
	popj 17,

hllos_if_result_negative:
	hllos 4,(1)
	move 1,2
	jumpl 4,%L27
	move 1,3
%L27:
	popj 17,

hllos_likely:
	hllos 4,(1)
	move 1,4
	popj 17,

hllos_unlikely:
	hllos 4,(1)
	move 1,4
	popj 17,

hllos_source_live:
	move 3,1
	move 4,(1)
	hllo 1,4
	movem 1,(3)
	add 1,4
	add 1,2
	popj 17,

hllos_left_source_live:
	hllz 3,(1)
	hllo 4,3
	movem 4,(1)
	add 4,3
	move 1,4
	popj 17,

hllos_right_source_live:
	move 3,(1)
	hllo 4,3
	movem 4,(1)
	addi 4,(3)
	move 1,4
	popj 17,

hllos_two_updates:
	hllos 3,(1)
	hllos 4,(2)
	add 3,4
	move 1,3
	popj 17,

hllos_loop:
	move 6,1
	movei 1,0
	move 4,2
	subi 2,1
	jumple 4,%L43
	move 3,(6)
%L41:
	hllos 1,3
	move 4,2
	subi 2,1
	jumpg 4,%L41
	movem 1,(6)
%L43:
	popj 17,

hllos_loop_sum:
	move 6,1
	movei 1,0
	move 4,2
	subi 2,1
	jumple 4,%L51
	move 3,(6)
%L49:
	hllo 3,3
	add 1,3
	move 4,2
	subi 2,1
	jumpg 4,%L49
	movem 3,(6)
%L51:
	popj 17,

hllos_loop_break:
	move 4,2
	subi 2,1
	jumple 4,%L60
	move 3,(1)
%L58:
	hllo 3,3
	move 4,2
	subi 2,1
	jumpg 4,%L58
	movem 3,(1)
%L60:
	move 1,(1)
	popj 17,

hllos_store_then_load:
	hllos 4,(1)
	move 1,4
	popj 17,

hllos_store_then_bool:
	move 6,(1)
	hllom 6,(1)
	movei 1,1
	popj 17,

hllos_store_then_add:
	hllos 4,(1)
	add 4,2
	move 1,4
	popj 17,

hllos_right_is_ones:
	hllos 4,(1)
	hrrz 4,4
	move 1,4
	popj 17,

hllos_left_after_ones:
	hllos 4,(1)
	hllz 4,4
	move 1,4
	popj 17,

hllos_mix_after_ones:
	hllos 4,(1)
	add 4,2
	move 1,4
	popj 17,

uhllos_mem:
	hllos 4,(1)
	move 1,4
	popj 17,

uhllos_global:
	hllos 1,hllos_uga
	popj 17,

uhllos_array:
	andi 2,17
	add 1,2
	hllos 4,(1)
	move 1,4
	popj 17,

uhllos_global_array:
	andi 1,17
	hllos 4,hllos_ubuf(1)
	move 1,4
	popj 17,

uhllos_struct_a:
	hllos 4,(1)
	move 1,4
	popj 17,

uhllos_global_struct_a:
	hllos 1,hllos_ugp
	popj 17,

uhllos_add:
	hllos 4,(1)
	add 4,2
	move 1,4
	popj 17,

uhllos_bool:
	move 6,(1)
	hllom 6,(1)
	movei 1,1
	popj 17,

uhllos_right_is_ones:
	hllos 4,(1)
	hrrz 4,4
	move 1,4
	popj 17,

hllos_sqi_temp:
	lsh 2,33
	ash 2,-33
	hllo 2,2
	movem 2,(1)
	move 1,2
	popj 17,

hllos_uqi_temp:
	move 4,1
	movei 1,777777
	movem 1,(4)
	popj 17,

hllos_hi_temp:
	hrre 2,2
	hllo 2,2
	movem 2,(1)
	move 1,2
	popj 17,

hllos_uhi_temp:
	move 4,1
	movei 1,777777
	movem 1,(4)
	popj 17,

	.bss
hllos_ga:
	.space	4
hllos_gb:
	.space	4
hllos_uga:
	.space	4
hllos_vga:
	.space	4
hllos_buf:
	.space	64
hllos_ubuf:
	.space	64
hllos_gp:
	.space	8
hllos_ugp:
	.space	8
