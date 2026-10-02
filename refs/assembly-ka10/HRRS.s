
hrrs_mem:
	hllz 2,2
	hrrz 4,(1)
	ior 2,4
	movem 2,(1)
	move 1,2
	popj 17,

hrrs_mem_alt:
	hllz 2,2
	hrrz 4,(1)
	ior 2,4
	movem 2,(1)
	move 1,2
	popj 17,

hrrs_mem_return_ac:
	hrr 2,(1)
	movem 2,(1)
	move 1,2
	popj 17,

hrrs_global:
	hllz 1,1
	hrrz 4,hrrs_ga
	ior 1,4
	movem 1,hrrs_ga
	popj 17,

hrrs_global_b:
	hllz 1,1
	hrrz 4,hrrs_gb
	ior 1,4
	movem 1,hrrs_gb
	popj 17,

hrrs_array:
	hllz 3,3
	andi 2,17
	add 1,2
	hrrz 4,(1)
	ior 3,4
	movem 3,(1)
	move 1,3
	popj 17,

hrrs_global_array:
	hllz 2,2
	andi 1,17
	hrrz 4,hrrs_buf(1)
	ior 2,4
	movem 2,hrrs_buf(1)
	move 1,2
	popj 17,

hrrs_struct_a:
	hllz 2,2
	hrrz 4,(1)
	ior 2,4
	movem 2,(1)
	move 1,2
	popj 17,

hrrs_struct_b:
	hllz 2,2
	hrrz 4,1(1)
	ior 2,4
	movem 2,1(1)
	move 1,2
	popj 17,

hrrs_global_struct_a:
	hllz 1,1
	hrrz 4,hrrs_gp
	ior 1,4
	movem 1,hrrs_gp
	popj 17,

hrrs_global_struct_b:
	hllz 1,1
	hrrz 4,hrrs_gp+1
	ior 1,4
	movem 1,hrrs_gp+1
	popj 17,

hrrs_indirect:
	hllz 2,2
	move 3,(1)
	hrrz 4,(3)
	ior 2,4
	movem 2,(3)
	move 1,2
	popj 17,

hrrs_volatile:
	move 4,(1)
	hllz 2,2
	iori 2,(4)
	movem 2,(1)
	move 1,2
	popj 17,

hrrs_add:
	hllz 2,2
	hrrz 4,(1)
	ior 2,4
	movem 2,(1)
	add 2,3
	move 1,2
	popj 17,

hrrs_sub:
	hllz 2,2
	hrrz 4,(1)
	ior 2,4
	movem 2,(1)
	sub 2,3
	move 1,2
	popj 17,

hrrs_xor:
	hllz 2,2
	hrrz 4,(1)
	ior 2,4
	movem 2,(1)
	xor 2,3
	move 1,2
	popj 17,

hrrs_or:
	hllz 2,2
	hrrz 4,(1)
	ior 2,4
	movem 2,(1)
	ior 2,3
	move 1,2
	popj 17,

hrrs_and:
	hllz 2,2
	hrrz 4,(1)
	ior 2,4
	movem 2,(1)
	and 2,3
	move 1,2
	popj 17,

hrrs_call_add:
	push 17,10
	hllz 10,2
	hrrz 4,(1)
	ior 10,4
	movem 10,(1)
	pushj 17,f
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

hrrs_call_before:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	pushj 17,f
	hllz 10,10
	hrrz 4,(11)
	ior 10,4
	movem 10,(11)
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

hrrs_if_result_zero:
	move 6,4
	hllz 2,2
	hrrz 4,(1)
	ior 2,4
	movem 2,(1)
	move 1,3
	jumpe 2,%L23
	move 1,6
%L23:
	popj 17,

hrrs_if_result_nonzero:
	move 6,4
	hllz 2,2
	hrrz 4,(1)
	ior 2,4
	movem 2,(1)
	move 1,3
	jumpn 2,%L25
	move 1,6
%L25:
	popj 17,

hrrs_if_result_negative:
	move 6,4
	hllz 2,2
	hrrz 4,(1)
	ior 2,4
	movem 2,(1)
	move 1,3
	jumpl 2,%L27
	move 1,6
%L27:
	popj 17,

hrrs_likely:
	hllz 2,2
	hrrz 4,(1)
	ior 2,4
	movem 2,(1)
	move 1,2
	jumpe 2,%L31
%L29:
	popj 17,
%L31:
	movei 1,0
	popj 17,

hrrs_unlikely:
	hllz 2,2
	hrrz 4,(1)
	ior 2,4
	movem 2,(1)
	move 1,2
	jumpn 2,%L32
	movei 1,0
%L32:
	popj 17,

hrrs_sources_live:
	move 6,1
	move 4,(1)
	hllz 1,2
	iori 1,(4)
	movem 1,(6)
	add 1,4
	add 1,2
	add 1,3
	popj 17,

hrrs_left_source_live:
	move 4,1
	hllz 2,2
	hrrz 1,(1)
	ior 1,2
	movem 1,(4)
	add 1,2
	popj 17,

hrrs_right_source_live:
	hllz 2,2
	hrrz 4,(1)
	ior 2,4
	movem 2,(1)
	add 2,4
	move 1,2
	popj 17,

hrrs_two_updates:
	hllz 3,3
	hrrz 4,(1)
	ior 3,4
	movem 3,(1)
	hllz 4,3
	hrrz 1,(2)
	ior 4,1
	movem 4,(2)
	add 3,4
	move 1,3
	popj 17,

hrrs_loop:
	move 6,1
	move 1,2
	move 4,3
	subi 3,1
	jumple 4,%L44
	move 2,(6)
%L42:
	hrr 1,2
	move 2,1
	move 4,3
	subi 3,1
	jumpg 4,%L42
	movem 1,(6)
%L44:
	popj 17,

hrrs_loop_sum:
	move 7,1
	movei 1,0
	move 4,3
	subi 3,1
	jumple 4,%L52
	move 6,(7)
%L50:
	hll 6,2
	move 2,6
	add 1,6
	move 4,3
	subi 3,1
	jumpg 4,%L50
	movem 6,(7)
%L52:
	popj 17,

hrrs_loop_break:
	move 7,1
	move 6,3
	subi 6,1
	jumple 3,%L61
%L59:
	hllz 3,2
	hrrz 4,(7)
	ior 3,4
	movem 3,(7)
	move 1,6
	jumpe 3,%L54
	addi 2,1
	subi 6,1
	jumpg 1,%L59
%L61:
	move 1,2
%L54:
	popj 17,

hrrs_store_then_load:
	hllz 2,2
	hrrz 4,(1)
	ior 2,4
	movem 2,(1)
	move 1,2
	popj 17,

hrrs_store_then_bool:
	hllz 2,2
	hrrz 4,(1)
	ior 2,4
	movem 2,(1)
	skipe 2
	movei 2,1
	move 1,2
	popj 17,

hrrs_store_then_add:
	hllz 2,2
	hrrz 4,(1)
	ior 2,4
	movem 2,(1)
	add 2,3
	move 1,2
	popj 17,

hrrs_left_after_update:
	hllz 2,2
	hrrz 4,(1)
	ior 2,4
	movem 2,(1)
	hllz 2,2
	move 1,2
	popj 17,

hrrs_right_after_update:
	hllz 2,2
	hrrz 4,(1)
	ior 2,4
	movem 2,(1)
	hrrz 2,2
	move 1,2
	popj 17,

hrrs_mix_after_update:
	hllz 2,2
	hrrz 4,(1)
	ior 2,4
	movem 2,(1)
	add 2,3
	move 1,2
	popj 17,

uhrrs_mem:
	hllz 2,2
	hrrz 4,(1)
	ior 2,4
	movem 2,(1)
	move 1,2
	popj 17,

uhrrs_global:
	hllz 1,1
	hrrz 4,hrrs_uga
	ior 1,4
	movem 1,hrrs_uga
	popj 17,

uhrrs_array:
	hllz 3,3
	andi 2,17
	add 1,2
	hrrz 4,(1)
	ior 3,4
	movem 3,(1)
	move 1,3
	popj 17,

uhrrs_global_array:
	hllz 2,2
	andi 1,17
	hrrz 4,hrrs_ubuf(1)
	ior 2,4
	movem 2,hrrs_ubuf(1)
	move 1,2
	popj 17,

uhrrs_struct_a:
	hllz 2,2
	hrrz 4,(1)
	ior 2,4
	movem 2,(1)
	move 1,2
	popj 17,

uhrrs_global_struct_a:
	hllz 1,1
	hrrz 4,hrrs_ugp
	ior 1,4
	movem 1,hrrs_ugp
	popj 17,

uhrrs_add:
	hllz 2,2
	hrrz 4,(1)
	ior 2,4
	movem 2,(1)
	add 2,3
	move 1,2
	popj 17,

uhrrs_bool:
	hllz 2,2
	hrrz 4,(1)
	ior 2,4
	movem 2,(1)
	skipe 2
	movei 2,1
	move 1,2
	popj 17,

uhrrs_right_after_update:
	hllz 2,2
	hrrz 4,(1)
	ior 2,4
	movem 2,(1)
	hrrz 2,2
	move 1,2
	popj 17,

hrrs_sqi_temp:
	lsh 2,33
	ash 2,-33
	hrrz 4,(1)
	tlo 4,(2)
	movem 4,(1)
	move 1,4
	popj 17,

hrrs_uqi_temp:
	andi 2,777	; zero_extendqisi2
	hrrz 4,(1)
	tlo 4,(2)
	movem 4,(1)
	move 1,4
	popj 17,

hrrs_hi_temp:
	move 4,1
	hrrz 1,(1)
	tlo 1,(2)
	movem 1,(4)
	popj 17,

hrrs_uhi_temp:
	move 4,1
	hrrz 1,(1)
	tlo 1,(2)
	movem 1,(4)
	popj 17,

	.bss
hrrs_ga:
	.space	4
hrrs_gb:
	.space	4
hrrs_uga:
	.space	4
hrrs_vga:
	.space	4
hrrs_buf:
	.space	64
hrrs_ubuf:
	.space	64
hrrs_gp:
	.space	8
hrrs_ugp:
	.space	8
