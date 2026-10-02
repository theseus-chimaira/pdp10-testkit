
hlrs_mem:
	hllz 2,2
	hlrz 4,(1)
	ior 2,4
	movem 2,(1)
	move 1,2
	popj 17,

hlrs_mem_alt:
	hllz 2,2
	hlrz 4,(1)
	ior 2,4
	movem 2,(1)
	move 1,2
	popj 17,

hlrs_mem_return_ac:
	hlr 2,(1)
	movem 2,(1)
	move 1,2
	popj 17,

hlrs_global:
	hllz 1,1
	hlrz 4,hlrs_ga
	ior 1,4
	movem 1,hlrs_ga
	popj 17,

hlrs_global_b:
	hllz 1,1
	hlrz 4,hlrs_gb
	ior 1,4
	movem 1,hlrs_gb
	popj 17,

hlrs_array:
	hllz 3,3
	andi 2,17
	add 1,2
	hlrz 4,(1)
	ior 3,4
	movem 3,(1)
	move 1,3
	popj 17,

hlrs_global_array:
	hllz 2,2
	andi 1,17
	hlrz 4,hlrs_buf(1)
	ior 2,4
	movem 2,hlrs_buf(1)
	move 1,2
	popj 17,

hlrs_struct_a:
	hllz 2,2
	hlrz 4,(1)
	ior 2,4
	movem 2,(1)
	move 1,2
	popj 17,

hlrs_struct_b:
	hllz 2,2
	hlrz 4,1(1)
	ior 2,4
	movem 2,1(1)
	move 1,2
	popj 17,

hlrs_global_struct_a:
	hllz 1,1
	hlrz 4,hlrs_gp
	ior 1,4
	movem 1,hlrs_gp
	popj 17,

hlrs_global_struct_b:
	hllz 1,1
	hlrz 4,hlrs_gp+1
	ior 1,4
	movem 1,hlrs_gp+1
	popj 17,

hlrs_indirect:
	hllz 2,2
	move 3,(1)
	hlrz 4,(3)
	ior 2,4
	movem 2,(3)
	move 1,2
	popj 17,

hlrs_volatile:
	move 4,(1)
	hllz 2,2
	hlrz 4,4
	ior 2,4
	movem 2,(1)
	move 1,2
	popj 17,

hlrs_add:
	hllz 2,2
	hlrz 4,(1)
	ior 2,4
	movem 2,(1)
	add 2,3
	move 1,2
	popj 17,

hlrs_sub:
	hllz 2,2
	hlrz 4,(1)
	ior 2,4
	movem 2,(1)
	sub 2,3
	move 1,2
	popj 17,

hlrs_xor:
	hllz 2,2
	hlrz 4,(1)
	ior 2,4
	movem 2,(1)
	xor 2,3
	move 1,2
	popj 17,

hlrs_or:
	hllz 2,2
	hlrz 4,(1)
	ior 2,4
	movem 2,(1)
	ior 2,3
	move 1,2
	popj 17,

hlrs_and:
	hllz 2,2
	hlrz 4,(1)
	ior 2,4
	movem 2,(1)
	and 2,3
	move 1,2
	popj 17,

hlrs_call_add:
	push 17,10
	hllz 10,2
	hlrz 4,(1)
	ior 10,4
	movem 10,(1)
	pushj 17,f
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

hlrs_call_before:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	pushj 17,f
	hllz 10,10
	hlrz 4,(11)
	ior 10,4
	movem 10,(11)
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

hlrs_if_result_zero:
	move 6,4
	hllz 2,2
	hlrz 4,(1)
	ior 2,4
	movem 2,(1)
	move 1,3
	jumpe 2,%L23
	move 1,6
%L23:
	popj 17,

hlrs_if_result_nonzero:
	move 6,4
	hllz 2,2
	hlrz 4,(1)
	ior 2,4
	movem 2,(1)
	move 1,3
	jumpn 2,%L25
	move 1,6
%L25:
	popj 17,

hlrs_if_result_negative:
	move 6,4
	hllz 2,2
	hlrz 4,(1)
	ior 2,4
	movem 2,(1)
	move 1,3
	jumpl 2,%L27
	move 1,6
%L27:
	popj 17,

hlrs_likely:
	hllz 2,2
	hlrz 4,(1)
	ior 2,4
	movem 2,(1)
	move 1,2
	jumpe 2,%L31
%L29:
	popj 17,
%L31:
	movei 1,0
	popj 17,

hlrs_unlikely:
	hllz 2,2
	hlrz 4,(1)
	ior 2,4
	movem 2,(1)
	move 1,2
	jumpn 2,%L32
	movei 1,0
%L32:
	popj 17,

hlrs_sources_live:
	move 7,1
	move 6,(1)
	hllz 1,2
	hlrz 4,6
	ior 1,4
	movem 1,(7)
	add 1,6
	add 1,2
	add 1,3
	popj 17,

hlrs_left_source_live:
	move 4,1
	hllz 2,2
	hlrz 1,(1)
	ior 1,2
	movem 1,(4)
	add 1,2
	popj 17,

hlrs_e_left_source_live:
	hllz 2,2
	hllz 3,(1)
	hlrz 4,3
	ior 2,4
	movem 2,(1)
	add 2,3
	move 1,2
	popj 17,

hlrs_right_result_live:
	hllz 2,2
	hlrz 4,(1)
	ior 2,4
	movem 2,(1)
	addi 2,(2)
	move 1,2
	popj 17,

hlrs_two_updates:
	hllz 3,3
	hlrz 4,(1)
	ior 3,4
	movem 3,(1)
	hllz 4,3
	hlrz 1,(2)
	ior 4,1
	movem 4,(2)
	add 3,4
	move 1,3
	popj 17,

hlrs_loop:
	move 6,1
	move 1,2
	move 4,3
	subi 3,1
	jumple 4,%L45
	move 2,(6)
%L43:
	hlr 1,2
	move 2,1
	move 4,3
	subi 3,1
	jumpg 4,%L43
	movem 1,(6)
%L45:
	popj 17,

hlrs_loop_sum:
	move 7,1
	movei 1,0
	move 4,3
	subi 3,1
	jumple 4,%L53
	move 6,(7)
%L51:
	hllz 4,2
	hlrz 6,6
	ior 6,4
	move 2,6
	add 1,6
	move 4,3
	subi 3,1
	jumpg 4,%L51
	movem 6,(7)
%L53:
	popj 17,

hlrs_loop_break:
	move 7,1
	move 6,3
	subi 6,1
	jumple 3,%L62
%L60:
	hllz 3,2
	hlrz 4,(7)
	ior 3,4
	movem 3,(7)
	move 1,6
	jumpe 3,%L55
	addi 2,1
	subi 6,1
	jumpg 1,%L60
%L62:
	move 1,2
%L55:
	popj 17,

hlrs_store_then_load:
	hllz 2,2
	hlrz 4,(1)
	ior 2,4
	movem 2,(1)
	move 1,2
	popj 17,

hlrs_store_then_bool:
	hllz 2,2
	hlrz 4,(1)
	ior 2,4
	movem 2,(1)
	skipe 2
	movei 2,1
	move 1,2
	popj 17,

hlrs_store_then_add:
	hllz 2,2
	hlrz 4,(1)
	ior 2,4
	movem 2,(1)
	add 2,3
	move 1,2
	popj 17,

hlrs_left_after_update:
	hllz 2,2
	hlrz 4,(1)
	ior 2,4
	movem 2,(1)
	hllz 2,2
	move 1,2
	popj 17,

hlrs_right_after_update:
	hllz 2,2
	hlrz 4,(1)
	ior 2,4
	movem 2,(1)
	hrrz 2,2
	move 1,2
	popj 17,

hlrs_mix_after_update:
	hllz 2,2
	hlrz 4,(1)
	ior 2,4
	movem 2,(1)
	add 2,3
	move 1,2
	popj 17,

uhlrs_mem:
	hllz 2,2
	hlrz 4,(1)
	ior 2,4
	movem 2,(1)
	move 1,2
	popj 17,

uhlrs_global:
	hllz 1,1
	hlrz 4,hlrs_uga
	ior 1,4
	movem 1,hlrs_uga
	popj 17,

uhlrs_array:
	hllz 3,3
	andi 2,17
	add 1,2
	hlrz 4,(1)
	ior 3,4
	movem 3,(1)
	move 1,3
	popj 17,

uhlrs_global_array:
	hllz 2,2
	andi 1,17
	hlrz 4,hlrs_ubuf(1)
	ior 2,4
	movem 2,hlrs_ubuf(1)
	move 1,2
	popj 17,

uhlrs_struct_a:
	hllz 2,2
	hlrz 4,(1)
	ior 2,4
	movem 2,(1)
	move 1,2
	popj 17,

uhlrs_global_struct_a:
	hllz 1,1
	hlrz 4,hlrs_ugp
	ior 1,4
	movem 1,hlrs_ugp
	popj 17,

uhlrs_add:
	hllz 2,2
	hlrz 4,(1)
	ior 2,4
	movem 2,(1)
	add 2,3
	move 1,2
	popj 17,

uhlrs_bool:
	hllz 2,2
	hlrz 4,(1)
	ior 2,4
	movem 2,(1)
	skipe 2
	movei 2,1
	move 1,2
	popj 17,

uhlrs_right_after_update:
	hllz 2,2
	hlrz 4,(1)
	ior 2,4
	movem 2,(1)
	hrrz 2,2
	move 1,2
	popj 17,

hlrs_sqi_temp:
	lsh 2,33
	ash 2,-33
	hlrz 4,(1)
	tlo 4,(2)
	movem 4,(1)
	move 1,4
	popj 17,

hlrs_uqi_temp:
	andi 2,777	; zero_extendqisi2
	hlrz 4,(1)
	tlo 4,(2)
	movem 4,(1)
	move 1,4
	popj 17,

hlrs_hi_temp:
	move 4,1
	hlrz 1,(1)
	tlo 1,(2)
	movem 1,(4)
	popj 17,

hlrs_uhi_temp:
	move 4,1
	hlrz 1,(1)
	tlo 1,(2)
	movem 1,(4)
	popj 17,

	.bss
hlrs_ga:
	.space	4
hlrs_gb:
	.space	4
hlrs_uga:
	.space	4
hlrs_vga:
	.space	4
hlrs_buf:
	.space	64
hlrs_ubuf:
	.space	64
hlrs_gp:
	.space	8
hlrs_ugp:
	.space	8
