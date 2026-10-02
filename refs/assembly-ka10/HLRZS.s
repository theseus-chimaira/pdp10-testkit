
hlrzs_mem:
	hlrzs 4,(1)
	move 1,4
	popj 17,

hlrzs_mem_alt:
	hlrzs 4,(1)
	move 1,4
	popj 17,

hlrzs_mem_return_ac:
	hlrzs 4,(1)
	move 1,4
	popj 17,

hlrzs_global:
	hlrzs 1,hlrzs_ga
	popj 17,

hlrzs_global_b:
	hlrzs 1,hlrzs_gb
	popj 17,

hlrzs_array:
	andi 2,17
	add 1,2
	hlrzs 4,(1)
	move 1,4
	popj 17,

hlrzs_global_array:
	andi 1,17
	hlrzs 4,hlrzs_buf(1)
	move 1,4
	popj 17,

hlrzs_struct_a:
	hlrzs 4,(1)
	move 1,4
	popj 17,

hlrzs_struct_b:
	hlrzs 4,1(1)
	move 1,4
	popj 17,

hlrzs_global_struct_a:
	hlrzs 1,hlrzs_gp
	popj 17,

hlrzs_global_struct_b:
	hlrzs 1,hlrzs_gp+1
	popj 17,

hlrzs_indirect:
	hlrzs 4,@(1)
	move 1,4
	popj 17,

hlrzs_volatile:
	move 4,1
	move 1,(1)
	hlrz 1,1
	movem 1,(4)
	popj 17,

hlrzs_volatile_global:
	move 1,hlrzs_vga
	hlrz 1,1
	movem 1,hlrzs_vga
	popj 17,

hlrzs_add:
	hlrzs 4,(1)
	add 4,2
	move 1,4
	popj 17,

hlrzs_sub:
	hlrzs 4,(1)
	sub 4,2
	move 1,4
	popj 17,

hlrzs_xor:
	hlrzs 4,(1)
	xor 4,2
	move 1,4
	popj 17,

hlrzs_or:
	hlrzs 4,(1)
	ior 4,2
	move 1,4
	popj 17,

hlrzs_and:
	hlrzs 4,(1)
	and 4,2
	move 1,4
	popj 17,

hlrzs_call_add:
	push 17,10
	hlrzs 10,(1)
	pushj 17,f
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

hlrzs_call_before:
	push 17,10
	move 10,1
	pushj 17,f
	move 4,1
	hlrzs 1,(10)
	add 1,4
	pop 17,10
	popj 17,

hlrzs_if_result_zero:
	hlrzs 4,(1)
	move 1,2
	jumpe 4,%L24
	move 1,3
%L24:
	popj 17,

hlrzs_if_result_nonzero:
	hlrzs 4,(1)
	move 1,2
	jumpn 4,%L26
	move 1,3
%L26:
	popj 17,

hlrzs_if_result_negative:
	hlrzs 4,(1)
	move 1,2
	jumpl 4,%L28
	move 1,3
%L28:
	popj 17,

hlrzs_likely:
	hlrzs 4,(1)
	move 1,4
	jumpe 4,%L32
%L30:
	popj 17,
%L32:
	movei 1,0
	popj 17,

hlrzs_unlikely:
	hlrzs 4,(1)
	move 1,4
	jumpn 4,%L33
	movei 1,0
%L33:
	popj 17,

hlrzs_left_is_zero:
	hlrzs 4,(1)
	hllz 4,4
	move 1,4
	popj 17,

hlrzs_right_bits:
	hlrzs 4,(1)
	hrrz 4,4
	move 1,4
	popj 17,

hlrzs_right_nonzero:
	hlrzs 4,(1)
	skipe 4
	movei 4,1
	move 1,4
	popj 17,

hlrzs_left_zero_bool:
	hlrzs 4,(1)
	movei 1,1
	popj 17,

hlrzs_mix_after_zero:
	hlrzs 4,(1)
	add 4,2
	move 1,4
	popj 17,

hlrzs_source_live:
	move 3,1
	move 4,(1)
	hlrz 1,4
	movem 1,(3)
	add 1,4
	add 1,2
	popj 17,

hlrzs_left_source_live:
	hllz 3,(1)
	hlrz 4,3
	movem 4,(1)
	add 4,3
	move 1,4
	popj 17,

hlrzs_right_source_dead:
	move 3,(1)
	hlrz 4,3
	movem 4,(1)
	addi 4,(3)
	move 1,4
	popj 17,

hlrzs_two_updates:
	hlrzs 3,(1)
	hlrzs 4,(2)
	add 3,4
	move 1,3
	popj 17,

hlrzs_loop:
	move 6,1
	movei 1,0
	move 4,2
	subi 2,1
	jumple 4,%L50
	move 3,(6)
%L48:
	hlrzs 1,3
	move 4,2
	subi 2,1
	jumpg 4,%L48
	movem 1,(6)
%L50:
	popj 17,

hlrzs_loop_sum:
	move 6,1
	movei 1,0
	move 4,2
	subi 2,1
	jumple 4,%L58
	move 3,(6)
%L56:
	hlrz 3,3
	add 1,3
	move 4,2
	subi 2,1
	jumpg 4,%L56
	movem 3,(6)
%L58:
	popj 17,

hlrzs_loop_break:
	move 4,2
	subi 2,1
	jumple 4,%L67
%L65:
	hlrzs 4,(1)
	move 3,2
	jumpe 4,%L60
	subi 2,1
	jumpg 3,%L65
%L67:
	move 3,(1)
%L60:
	move 1,3
	popj 17,

hlrzs_store_then_load:
	hlrzs 4,(1)
	move 1,4
	popj 17,

hlrzs_store_then_bool:
	hlrzs 4,(1)
	skipe 4
	movei 4,1
	move 1,4
	popj 17,

hlrzs_store_then_add:
	hlrzs 4,(1)
	add 4,2
	move 1,4
	popj 17,

uhlrzs_mem:
	hlrzs 4,(1)
	move 1,4
	popj 17,

uhlrzs_global:
	hlrzs 1,hlrzs_uga
	popj 17,

uhlrzs_array:
	andi 2,17
	add 1,2
	hlrzs 4,(1)
	move 1,4
	popj 17,

uhlrzs_global_array:
	andi 1,17
	hlrzs 4,hlrzs_ubuf(1)
	move 1,4
	popj 17,

uhlrzs_struct_a:
	hlrzs 4,(1)
	move 1,4
	popj 17,

uhlrzs_global_struct_a:
	hlrzs 1,hlrzs_ugp
	popj 17,

uhlrzs_add:
	hlrzs 4,(1)
	add 4,2
	move 1,4
	popj 17,

uhlrzs_bool:
	hlrzs 4,(1)
	skipe 4
	movei 4,1
	move 1,4
	popj 17,

uhlrzs_right_bits:
	hlrzs 4,(1)
	hrrz 4,4
	move 1,4
	popj 17,

hlrzs_sqi_temp:
	lsh 2,33
	ash 2,-33
	hrrz 2,2
	movem 2,(1)
	move 1,2
	popj 17,

hlrzs_uqi_temp:
	andi 2,777
	movem 2,(1)
	move 1,2
	popj 17,

hlrzs_hi_temp:
	hrrz 2,2
	movem 2,(1)
	move 1,2
	popj 17,

hlrzs_uhi_temp:
	hrrz 2,2
	movem 2,(1)
	move 1,2
	popj 17,

	.bss
hlrzs_ga:
	.space	4
hlrzs_gb:
	.space	4
hlrzs_uga:
	.space	4
hlrzs_vga:
	.space	4
hlrzs_buf:
	.space	64
hlrzs_ubuf:
	.space	64
hlrzs_gp:
	.space	8
hlrzs_ugp:
	.space	8
