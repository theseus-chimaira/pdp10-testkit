
hlls_mem:
	move 4,1
	hllz 1,(1)
	iori 1,(2)
	movem 1,(4)
	popj 17,

hlls_mem_alt:
	move 4,1
	hllz 1,(1)
	iori 1,(2)
	movem 1,(4)
	popj 17,

hlls_mem_return_ac:
	hll 2,(1)
	movem 2,(1)
	move 1,2
	popj 17,

hlls_global:
	move 4,1
	hllz 1,hlls_ga
	iori 1,(4)
	movem 1,hlls_ga
	popj 17,

hlls_global_b:
	move 4,1
	hllz 1,hlls_gb
	iori 1,(4)
	movem 1,hlls_gb
	popj 17,

hlls_array:
	move 4,1
	andi 2,17
	add 4,2
	hllz 1,(4)
	iori 1,(3)
	movem 1,(4)
	popj 17,

hlls_global_array:
	andi 1,17
	hllz 4,hlls_buf(1)
	iori 4,(2)
	movem 4,hlls_buf(1)
	move 1,4
	popj 17,

hlls_struct_a:
	move 4,1
	hllz 1,(1)
	iori 1,(2)
	movem 1,(4)
	popj 17,

hlls_struct_b:
	move 4,1
	hllz 1,1(1)
	iori 1,(2)
	movem 1,1(4)
	popj 17,

hlls_global_struct_a:
	move 4,1
	hllz 1,hlls_gp
	iori 1,(4)
	movem 1,hlls_gp
	popj 17,

hlls_global_struct_b:
	move 4,1
	hllz 1,hlls_gp+1
	iori 1,(4)
	movem 1,hlls_gp+1
	popj 17,

hlls_indirect:
	move 4,(1)
	hllz 1,(4)
	iori 1,(2)
	movem 1,(4)
	popj 17,

hlls_volatile:
	move 4,1
	move 1,(1)
	hllz 1,1
	iori 1,(2)
	movem 1,(4)
	popj 17,

hlls_add:
	move 4,1
	hllz 1,(1)
	iori 1,(2)
	movem 1,(4)
	add 1,3
	popj 17,

hlls_sub:
	move 4,1
	hllz 1,(1)
	iori 1,(2)
	movem 1,(4)
	sub 1,3
	popj 17,

hlls_xor:
	move 4,1
	hllz 1,(1)
	iori 1,(2)
	movem 1,(4)
	xor 1,3
	popj 17,

hlls_or:
	move 4,1
	hllz 1,(1)
	iori 1,(2)
	movem 1,(4)
	ior 1,3
	popj 17,

hlls_and:
	move 4,1
	hllz 1,(1)
	iori 1,(2)
	movem 1,(4)
	and 1,3
	popj 17,

hlls_call_add:
	push 17,10
	hllz 10,(1)
	iori 10,(2)
	movem 10,(1)
	pushj 17,f
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

hlls_call_before:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	pushj 17,f
	move 4,1
	hllz 1,(10)
	iori 1,(11)
	movem 1,(10)
	add 1,4
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

hlls_if_result_zero:
	move 6,4
	hllz 4,(1)
	iori 4,(2)
	movem 4,(1)
	move 1,3
	jumpe 4,%L23
	move 1,6
%L23:
	popj 17,

hlls_if_result_nonzero:
	move 6,4
	hllz 4,(1)
	iori 4,(2)
	movem 4,(1)
	move 1,3
	jumpn 4,%L25
	move 1,6
%L25:
	popj 17,

hlls_if_result_negative:
	move 6,4
	hllz 4,(1)
	iori 4,(2)
	movem 4,(1)
	move 1,3
	jumpl 4,%L27
	move 1,6
%L27:
	popj 17,

hlls_likely:
	hllz 4,(1)
	iori 4,(2)
	movem 4,(1)
	move 1,4
	jumpe 4,%L31
%L29:
	popj 17,
%L31:
	movei 1,0
	popj 17,

hlls_unlikely:
	hllz 4,(1)
	iori 4,(2)
	movem 4,(1)
	move 1,4
	jumpn 4,%L32
	movei 1,0
%L32:
	popj 17,

hlls_sources_live:
	move 6,1
	move 4,(1)
	hllz 1,4
	iori 1,(2)
	movem 1,(6)
	add 1,4
	add 1,2
	add 1,3
	popj 17,

hlls_right_source_live:
	hllz 4,(1)
	hrrz 2,2
	ior 4,2
	movem 4,(1)
	add 4,2
	move 1,4
	popj 17,

hlls_left_source_live:
	move 3,1
	hllz 4,(1)
	move 1,4
	iori 1,(2)
	movem 1,(3)
	add 1,4
	popj 17,

hlls_two_updates:
	move 4,1
	hllz 1,(1)
	iori 1,(3)
	movem 1,(4)
	hllz 4,(2)
	iori 4,(1)
	movem 4,(2)
	add 1,4
	popj 17,

hlls_loop:
	move 6,1
	move 1,2
	move 4,3
	subi 3,1
	jumple 4,%L44
	move 2,(6)
%L42:
	hll 1,2
	move 2,1
	move 4,3
	subi 3,1
	jumpg 4,%L42
	movem 1,(6)
%L44:
	popj 17,

hlls_loop_sum:
	move 7,1
	movei 1,0
	move 4,3
	subi 3,1
	jumple 4,%L52
	move 6,(7)
%L50:
	hrr 6,2
	move 2,6
	add 1,6
	move 4,3
	subi 3,1
	jumpg 4,%L50
	movem 6,(7)
%L52:
	popj 17,

hlls_loop_break:
	move 6,1
	move 4,3
	subi 3,1
	jumple 4,%L61
%L59:
	hllz 4,(6)
	iori 4,(2)
	movem 4,(6)
	move 1,3
	jumpe 4,%L54
	addi 2,1
	subi 3,1
	jumpg 1,%L59
%L61:
	move 1,2
%L54:
	popj 17,

uhlls_mem:
	move 4,1
	hllz 1,(1)
	iori 1,(2)
	movem 1,(4)
	popj 17,

uhlls_global:
	move 4,1
	hllz 1,hlls_uga
	iori 1,(4)
	movem 1,hlls_uga
	popj 17,

uhlls_array:
	move 4,1
	andi 2,17
	add 4,2
	hllz 1,(4)
	iori 1,(3)
	movem 1,(4)
	popj 17,

uhlls_global_array:
	andi 1,17
	hllz 4,hlls_ubuf(1)
	iori 4,(2)
	movem 4,hlls_ubuf(1)
	move 1,4
	popj 17,

uhlls_struct_a:
	move 4,1
	hllz 1,(1)
	iori 1,(2)
	movem 1,(4)
	popj 17,

uhlls_global_struct_a:
	move 4,1
	hllz 1,hlls_ugp
	iori 1,(4)
	movem 1,hlls_ugp
	popj 17,

uhlls_add:
	move 4,1
	hllz 1,(1)
	iori 1,(2)
	movem 1,(4)
	add 1,3
	popj 17,

uhlls_bool:
	move 4,1
	hllz 1,(1)
	iori 1,(2)
	movem 1,(4)
	skipe 1
	movei 1,1
	popj 17,

hlls_sqi_right:
	hllz 4,(1)
	lsh 2,33
	ash 2,-33
	iori 4,(2)
	movem 4,(1)
	move 1,4
	popj 17,

hlls_uqi_right:
	andi 2,777	; zero_extendqisi2
	hllz 4,(1)
	ior 4,2
	movem 4,(1)
	move 1,4
	popj 17,

hlls_hi_right:
	move 4,1
	hllz 1,(1)
	iori 1,(2)
	movem 1,(4)
	popj 17,

hlls_uhi_right:
	move 4,1
	hllz 1,(1)
	iori 1,(2)
	movem 1,(4)
	popj 17,

	.bss
hlls_ga:
	.space	4
hlls_gb:
	.space	4
hlls_uga:
	.space	4
hlls_vga:
	.space	4
hlls_buf:
	.space	64
hlls_ubuf:
	.space	64
hlls_gp:
	.space	8
hlls_ugp:
	.space	8
