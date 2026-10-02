
hrlzs_mem:
	hrlzs 4,(1)
	move 1,4
	popj 17,

hrlzs_mem_alt:
	hrlzs 4,(1)
	move 1,4
	popj 17,

hrlzs_mem_return_ac:
	hrlzs 4,(1)
	move 1,4
	popj 17,

hrlzs_global:
	hrlzs 1,hrlzs_ga
	popj 17,

hrlzs_global_b:
	hrlzs 1,hrlzs_gb
	popj 17,

hrlzs_array:
	andi 2,17
	add 1,2
	hrlzs 4,(1)
	move 1,4
	popj 17,

hrlzs_global_array:
	andi 1,17
	hrlzs 4,hrlzs_buf(1)
	move 1,4
	popj 17,

hrlzs_struct_a:
	hrlzs 4,(1)
	move 1,4
	popj 17,

hrlzs_struct_b:
	hrlzs 4,1(1)
	move 1,4
	popj 17,

hrlzs_global_struct_a:
	hrlzs 1,hrlzs_gp
	popj 17,

hrlzs_global_struct_b:
	hrlzs 1,hrlzs_gp+1
	popj 17,

hrlzs_indirect:
	hrlzs 4,@(1)
	move 1,4
	popj 17,

hrlzs_volatile:
	move 4,1
	move 1,(1)
	hrlz 1,1
	movem 1,(4)
	popj 17,

hrlzs_add:
	hrlzs 4,(1)
	add 4,2
	move 1,4
	popj 17,

hrlzs_sub:
	hrlzs 4,(1)
	sub 4,2
	move 1,4
	popj 17,

hrlzs_xor:
	hrlzs 4,(1)
	xor 4,2
	move 1,4
	popj 17,

hrlzs_or:
	hrlzs 4,(1)
	ior 4,2
	move 1,4
	popj 17,

hrlzs_and:
	hrlzs 4,(1)
	and 4,2
	move 1,4
	popj 17,

hrlzs_call_add:
	push 17,10
	hrlzs 10,(1)
	pushj 17,f
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

hrlzs_call_before:
	push 17,10
	move 10,1
	pushj 17,f
	move 4,1
	hrlzs 1,(10)
	add 1,4
	pop 17,10
	popj 17,

hrlzs_if_result_zero:
	hrlzs 4,(1)
	move 1,2
	jumpe 4,%L23
	move 1,3
%L23:
	popj 17,

hrlzs_if_result_nonzero:
	hrlzs 4,(1)
	move 1,2
	jumpn 4,%L25
	move 1,3
%L25:
	popj 17,

hrlzs_if_result_negative:
	hrlzs 4,(1)
	move 1,2
	jumpl 4,%L27
	move 1,3
%L27:
	popj 17,

hrlzs_likely:
	hrlzs 4,(1)
	move 1,4
	jumpe 4,%L31
%L29:
	popj 17,
%L31:
	movei 1,0
	popj 17,

hrlzs_unlikely:
	hrlzs 4,(1)
	move 1,4
	jumpn 4,%L32
	movei 1,0
%L32:
	popj 17,

hrlzs_source_live:
	move 3,1
	move 4,(1)
	hrlz 1,4
	movem 1,(3)
	add 1,4
	add 1,2
	popj 17,

hrlzs_right_source_live:
	hrrz 3,(1)
	hrlz 4,3
	movem 4,(1)
	add 4,3
	move 1,4
	popj 17,

hrlzs_left_source_dead:
	move 4,(1)
	hrlz 3,4
	movem 3,(1)
	hllz 4,4
	add 3,4
	move 1,3
	popj 17,

hrlzs_two_updates:
	hrlzs 3,(1)
	hrlzs 4,(2)
	add 3,4
	move 1,3
	popj 17,

hrlzs_loop:
	move 6,1
	movei 1,0
	move 4,2
	subi 2,1
	jumple 4,%L44
	move 3,(6)
%L42:
	hrlzs 1,3
	move 4,2
	subi 2,1
	jumpg 4,%L42
	movem 1,(6)
%L44:
	popj 17,

hrlzs_loop_sum:
	move 6,1
	movei 1,0
	move 4,2
	subi 2,1
	jumple 4,%L52
	move 3,(6)
%L50:
	hrlz 3,3
	add 1,3
	move 4,2
	subi 2,1
	jumpg 4,%L50
	movem 3,(6)
%L52:
	popj 17,

hrlzs_loop_break:
	move 4,2
	subi 2,1
	jumple 4,%L61
%L59:
	hrlzs 4,(1)
	move 3,2
	jumpe 4,%L54
	subi 2,1
	jumpg 3,%L59
%L61:
	move 3,(1)
%L54:
	move 1,3
	popj 17,

hrlzs_store_then_load:
	hrlzs 4,(1)
	move 1,4
	popj 17,

hrlzs_store_then_bool:
	hrlzs 4,(1)
	skipe 4
	movei 4,1
	move 1,4
	popj 17,

hrlzs_store_then_add:
	hrlzs 4,(1)
	add 4,2
	move 1,4
	popj 17,

uhrlzs_mem:
	hrlzs 4,(1)
	move 1,4
	popj 17,

uhrlzs_global:
	hrlzs 1,hrlzs_uga
	popj 17,

uhrlzs_array:
	andi 2,17
	add 1,2
	hrlzs 4,(1)
	move 1,4
	popj 17,

uhrlzs_global_array:
	andi 1,17
	hrlzs 4,hrlzs_ubuf(1)
	move 1,4
	popj 17,

uhrlzs_struct_a:
	hrlzs 4,(1)
	move 1,4
	popj 17,

uhrlzs_global_struct_a:
	hrlzs 1,hrlzs_ugp
	popj 17,

uhrlzs_add:
	hrlzs 4,(1)
	add 4,2
	move 1,4
	popj 17,

uhrlzs_bool:
	hrlzs 4,(1)
	skipe 4
	movei 4,1
	move 1,4
	popj 17,

hrlzs_sqi_temp:
	lsh 2,33
	ash 2,-33
	hrlz 2,2
	movem 2,(1)
	move 1,2
	popj 17,

hrlzs_uqi_temp:
	andi 2,777
	hrlz 2,2
	movem 2,(1)
	move 1,2
	popj 17,

hrlzs_hi_temp:
	hrlz 2,2
	movem 2,(1)
	move 1,2
	popj 17,

hrlzs_uhi_temp:
	hrlz 2,2
	movem 2,(1)
	move 1,2
	popj 17,

	.bss
hrlzs_ga:
	.space	4
hrlzs_gb:
	.space	4
hrlzs_uga:
	.space	4
hrlzs_vga:
	.space	4
hrlzs_buf:
	.space	64
hrlzs_ubuf:
	.space	64
hrlzs_gp:
	.space	8
hrlzs_ugp:
	.space	8
