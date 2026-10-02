
hllzs_mem:
	hllzs 4,(1)
	move 1,4
	popj 17,

hllzs_mem_alt:
	hllzs 4,(1)
	move 1,4
	popj 17,

hllzs_mem_return_ac:
	hllzs 4,(1)
	move 1,4
	popj 17,

hllzs_global:
	hllzs 1,hllzs_ga
	popj 17,

hllzs_global_b:
	hllzs 1,hllzs_gb
	popj 17,

hllzs_array:
	andi 2,17
	add 1,2
	hllzs 4,(1)
	move 1,4
	popj 17,

hllzs_global_array:
	andi 1,17
	hllzs 4,hllzs_buf(1)
	move 1,4
	popj 17,

hllzs_struct_a:
	hllzs 4,(1)
	move 1,4
	popj 17,

hllzs_struct_b:
	hllzs 4,1(1)
	move 1,4
	popj 17,

hllzs_global_struct_a:
	hllzs 1,hllzs_gp
	popj 17,

hllzs_global_struct_b:
	hllzs 1,hllzs_gp+1
	popj 17,

hllzs_indirect:
	hllzs 4,@(1)
	move 1,4
	popj 17,

hllzs_volatile:
	move 4,1
	move 1,(1)
	hllz 1,1
	movem 1,(4)
	popj 17,

hllzs_add:
	hllzs 4,(1)
	add 4,2
	move 1,4
	popj 17,

hllzs_sub:
	hllzs 4,(1)
	sub 4,2
	move 1,4
	popj 17,

hllzs_xor:
	hllzs 4,(1)
	xor 4,2
	move 1,4
	popj 17,

hllzs_or:
	hllzs 4,(1)
	ior 4,2
	move 1,4
	popj 17,

hllzs_and:
	hllzs 4,(1)
	and 4,2
	move 1,4
	popj 17,

hllzs_call_add:
	push 17,10
	hllzs 10,(1)
	pushj 17,f
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

hllzs_call_before:
	push 17,10
	move 10,1
	pushj 17,f
	move 4,1
	hllzs 1,(10)
	add 1,4
	pop 17,10
	popj 17,

hllzs_if_result_zero:
	hllzs 4,(1)
	move 1,2
	jumpe 4,%L23
	move 1,3
%L23:
	popj 17,

hllzs_if_result_nonzero:
	hllzs 4,(1)
	move 1,2
	jumpn 4,%L25
	move 1,3
%L25:
	popj 17,

hllzs_if_result_negative:
	hllzs 4,(1)
	move 1,2
	jumpl 4,%L27
	move 1,3
%L27:
	popj 17,

hllzs_likely:
	hllzs 4,(1)
	move 1,4
	jumpe 4,%L31
%L29:
	popj 17,
%L31:
	movei 1,0
	popj 17,

hllzs_unlikely:
	hllzs 4,(1)
	move 1,4
	jumpn 4,%L32
	movei 1,0
%L32:
	popj 17,

hllzs_source_live:
	move 3,1
	move 4,(1)
	hllz 1,4
	movem 1,(3)
	add 1,4
	add 1,2
	popj 17,

hllzs_left_source_live:
	hllzs 4,(1)
	lsh 4,1
	move 1,4
	popj 17,

hllzs_right_source_dead:
	move 3,(1)
	hllz 4,3
	movem 4,(1)
	iori 4,(3)
	move 1,4
	popj 17,

hllzs_two_updates:
	hllzs 3,(1)
	hllzs 4,(2)
	add 3,4
	move 1,3
	popj 17,

hllzs_loop:
	move 6,1
	movei 1,0
	move 4,2
	subi 2,1
	jumple 4,%L44
	move 3,(6)
%L42:
	hllzs 1,3
	move 4,2
	subi 2,1
	jumpg 4,%L42
	movem 1,(6)
%L44:
	popj 17,

hllzs_loop_sum:
	move 6,1
	movei 1,0
	move 4,2
	subi 2,1
	jumple 4,%L52
	move 3,(6)
%L50:
	hllz 3,3
	add 1,3
	move 4,2
	subi 2,1
	jumpg 4,%L50
	movem 3,(6)
%L52:
	popj 17,

hllzs_loop_break:
	move 4,2
	subi 2,1
	jumple 4,%L61
%L59:
	hllzs 4,(1)
	move 3,2
	jumpe 4,%L54
	subi 2,1
	jumpg 3,%L59
%L61:
	move 3,(1)
%L54:
	move 1,3
	popj 17,

hllzs_store_then_load:
	hllzs 4,(1)
	move 1,4
	popj 17,

hllzs_store_then_bool:
	hllzs 4,(1)
	skipe 4
	movei 4,1
	move 1,4
	popj 17,

hllzs_store_then_add:
	hllzs 4,(1)
	add 4,2
	move 1,4
	popj 17,

uhllzs_mem:
	hllzs 4,(1)
	move 1,4
	popj 17,

uhllzs_global:
	hllzs 1,hllzs_uga
	popj 17,

uhllzs_array:
	andi 2,17
	add 1,2
	hllzs 4,(1)
	move 1,4
	popj 17,

uhllzs_global_array:
	andi 1,17
	hllzs 4,hllzs_ubuf(1)
	move 1,4
	popj 17,

uhllzs_struct_a:
	hllzs 4,(1)
	move 1,4
	popj 17,

uhllzs_global_struct_a:
	hllzs 1,hllzs_ugp
	popj 17,

uhllzs_add:
	hllzs 4,(1)
	add 4,2
	move 1,4
	popj 17,

uhllzs_bool:
	hllzs 4,(1)
	skipe 4
	movei 4,1
	move 1,4
	popj 17,

hllzs_sqi_temp:
	lsh 2,33
	ash 2,-33
	hllz 2,2
	movem 2,(1)
	move 1,2
	popj 17,

hllzs_uqi_temp:
	setzb 1,(1)
	popj 17,

hllzs_hi_temp:
	hrre 2,2
	hllz 2,2
	movem 2,(1)
	move 1,2
	popj 17,

hllzs_uhi_temp:
	setzb 1,(1)
	popj 17,

	.bss
hllzs_ga:
	.space	4
hllzs_gb:
	.space	4
hllzs_uga:
	.space	4
hllzs_vga:
	.space	4
hllzs_buf:
	.space	64
hllzs_ubuf:
	.space	64
hllzs_gp:
	.space	8
hllzs_ugp:
	.space	8
