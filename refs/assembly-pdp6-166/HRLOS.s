
hrlos_mem:
	hrlo 4,(1)
	movem 4,(1)
	move 1,4
	popj 17,

hrlos_mem_alt:
	hrlo 4,(1)
	movem 4,(1)
	move 1,4
	popj 17,

hrlos_mem_return_ac:
	hrlo 4,(1)
	movem 4,(1)
	move 1,4
	popj 17,

hrlos_global:
	hrlo 1,hrlos_ga
	movem 1,hrlos_ga
	popj 17,

hrlos_global_b:
	hrlo 1,hrlos_gb
	movem 1,hrlos_gb
	popj 17,

hrlos_array:
	andi 2,17
	add 1,2
	hrlo 4,(1)
	movem 4,(1)
	move 1,4
	popj 17,

hrlos_global_array:
	andi 1,17
	hrlo 4,hrlos_buf(1)
	movem 4,hrlos_buf(1)
	move 1,4
	popj 17,

hrlos_struct_a:
	hrlo 4,(1)
	movem 4,(1)
	move 1,4
	popj 17,

hrlos_struct_b:
	hrlo 4,1(1)
	movem 4,1(1)
	move 1,4
	popj 17,

hrlos_global_struct_a:
	hrlo 1,hrlos_gp
	movem 1,hrlos_gp
	popj 17,

hrlos_global_struct_b:
	hrlo 1,hrlos_gp+1
	movem 1,hrlos_gp+1
	popj 17,

hrlos_indirect:
	move 4,(1)
	hrlo 1,(4)
	movem 1,(4)
	popj 17,

hrlos_volatile:
	move 4,1
	move 1,(1)
	hrlo 1,1
	movem 1,(4)
	popj 17,

hrlos_add:
	hrlo 4,(1)
	movem 4,(1)
	add 4,2
	move 1,4
	popj 17,

hrlos_sub:
	hrlo 4,(1)
	movem 4,(1)
	sub 4,2
	move 1,4
	popj 17,

hrlos_xor:
	hrlo 4,(1)
	movem 4,(1)
	xor 4,2
	move 1,4
	popj 17,

hrlos_or:
	hrlo 4,(1)
	movem 4,(1)
	ior 4,2
	move 1,4
	popj 17,

hrlos_and:
	hrlo 4,(1)
	movem 4,(1)
	and 4,2
	move 1,4
	popj 17,

hrlos_call_add:
	push 17,10
	hrlo 10,(1)
	movem 10,(1)
	pushj 17,f
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

hrlos_call_before:
	push 17,10
	move 10,1
	pushj 17,f
	move 4,1
	hrlo 1,(10)
	movem 1,(10)
	add 1,4
	pop 17,10
	popj 17,

hrlos_if_result_zero:
	hrlo 4,(1)
	movem 4,(1)
	move 1,3
	popj 17,

hrlos_if_result_nonzero:
	hrlo 4,(1)
	movem 4,(1)
	move 1,2
	popj 17,

hrlos_if_result_negative:
	hrlo 4,(1)
	movem 4,(1)
	move 1,2
	jumpl 4,%L27
	move 1,3
%L27:
	popj 17,

hrlos_likely:
	hrlo 4,(1)
	movem 4,(1)
	move 1,4
	popj 17,

hrlos_unlikely:
	hrlo 4,(1)
	movem 4,(1)
	move 1,4
	popj 17,

hrlos_source_live:
	move 3,1
	move 4,(1)
	hrlo 1,4
	movem 1,(3)
	add 1,4
	add 1,2
	popj 17,

hrlos_right_source_live:
	hrrz 3,(1)
	hrlo 4,3
	movem 4,(1)
	add 4,3
	move 1,4
	popj 17,

hrlos_left_source_dead:
	move 4,(1)
	hrlo 3,4
	movem 3,(1)
	hllz 4,4
	add 3,4
	move 1,3
	popj 17,

hrlos_two_updates:
	move 4,1
	hrlo 1,(1)
	movem 1,(4)
	hrlo 4,(2)
	movem 4,(2)
	add 1,4
	popj 17,

hrlos_loop:
	move 6,1
	movei 1,0
	move 4,2
	subi 2,1
	jumple 4,%L43
	move 3,(6)
%L41:
	hrlo 1,3
	move 3,1
	move 4,2
	subi 2,1
	jumpg 4,%L41
	movem 1,(6)
%L43:
	popj 17,

hrlos_loop_sum:
	move 6,1
	movei 1,0
	move 4,2
	subi 2,1
	jumple 4,%L51
	move 3,(6)
%L49:
	hrlo 3,3
	add 1,3
	move 4,2
	subi 2,1
	jumpg 4,%L49
	movem 3,(6)
%L51:
	popj 17,

hrlos_loop_break:
	move 4,2
	subi 2,1
	jumple 4,%L60
	move 3,(1)
%L58:
	hrlo 3,3
	move 4,2
	subi 2,1
	jumpg 4,%L58
	movem 3,(1)
%L60:
	move 1,(1)
	popj 17,

hrlos_store_then_load:
	hrlo 4,(1)
	movem 4,(1)
	move 1,4
	popj 17,

hrlos_store_then_bool:
	hrlo 4,(1)
	movem 4,(1)
	movei 1,1
	popj 17,

hrlos_store_then_add:
	hrlo 4,(1)
	movem 4,(1)
	add 4,2
	move 1,4
	popj 17,

hrlos_right_is_ones:
	move 4,1
	hrlo 1,(1)
	movem 1,(4)
	hrrz 1,1
	popj 17,

hrlos_left_from_right:
	move 4,1
	hrlo 1,(1)
	movem 1,(4)
	hllz 1,1
	popj 17,

hrlos_mix_after_ones:
	hrlo 4,(1)
	movem 4,(1)
	add 4,2
	move 1,4
	popj 17,

uhrlos_mem:
	hrlo 4,(1)
	movem 4,(1)
	move 1,4
	popj 17,

uhrlos_global:
	hrlo 1,hrlos_uga
	movem 1,hrlos_uga
	popj 17,

uhrlos_array:
	andi 2,17
	add 1,2
	hrlo 4,(1)
	movem 4,(1)
	move 1,4
	popj 17,

uhrlos_global_array:
	andi 1,17
	hrlo 4,hrlos_ubuf(1)
	movem 4,hrlos_ubuf(1)
	move 1,4
	popj 17,

uhrlos_struct_a:
	hrlo 4,(1)
	movem 4,(1)
	move 1,4
	popj 17,

uhrlos_global_struct_a:
	hrlo 1,hrlos_ugp
	movem 1,hrlos_ugp
	popj 17,

uhrlos_add:
	hrlo 4,(1)
	movem 4,(1)
	add 4,2
	move 1,4
	popj 17,

uhrlos_bool:
	hrlo 4,(1)
	movem 4,(1)
	movei 1,1
	popj 17,

uhrlos_right_is_ones:
	move 4,1
	hrlo 1,(1)
	movem 1,(4)
	hrrz 1,1
	popj 17,

hrlos_sqi_temp:
	lsh 2,33
	ash 2,-33
	hrlo 2,2
	movem 2,(1)
	move 1,2
	popj 17,

hrlos_uqi_temp:
	andi 2,777
	hrlo 2,2
	movem 2,(1)
	move 1,2
	popj 17,

hrlos_hi_temp:
	hrlo 2,2
	movem 2,(1)
	move 1,2
	popj 17,

hrlos_uhi_temp:
	hrlo 2,2
	movem 2,(1)
	move 1,2
	popj 17,

	.bss
hrlos_ga:
	.space	4
hrlos_gb:
	.space	4
hrlos_uga:
	.space	4
hrlos_vga:
	.space	4
hrlos_buf:
	.space	64
hrlos_ubuf:
	.space	64
hrlos_gp:
	.space	8
hrlos_ugp:
	.space	8
