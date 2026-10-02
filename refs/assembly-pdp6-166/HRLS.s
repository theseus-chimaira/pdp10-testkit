
hrls_mem:
	move 4,1
	hrlz 1,(1)
	iori 1,(2)
	movem 1,(4)
	popj 17,

hrls_mem_alt:
	move 4,1
	hrlz 1,(1)
	iori 1,(2)
	movem 1,(4)
	popj 17,

hrls_mem_return_ac:
	hrl 2,(1)
	movem 2,(1)
	move 1,2
	popj 17,

hrls_global:
	move 4,1
	hrlz 1,hrls_ga
	iori 1,(4)
	movem 1,hrls_ga
	popj 17,

hrls_global_b:
	move 4,1
	hrlz 1,hrls_gb
	iori 1,(4)
	movem 1,hrls_gb
	popj 17,

hrls_array:
	move 4,1
	andi 2,17
	add 4,2
	hrlz 1,(4)
	iori 1,(3)
	movem 1,(4)
	popj 17,

hrls_global_array:
	andi 1,17
	hrlz 4,hrls_buf(1)
	iori 4,(2)
	movem 4,hrls_buf(1)
	move 1,4
	popj 17,

hrls_struct_a:
	move 4,1
	hrlz 1,(1)
	iori 1,(2)
	movem 1,(4)
	popj 17,

hrls_struct_b:
	move 4,1
	hrlz 1,1(1)
	iori 1,(2)
	movem 1,1(4)
	popj 17,

hrls_global_struct_a:
	move 4,1
	hrlz 1,hrls_gp
	iori 1,(4)
	movem 1,hrls_gp
	popj 17,

hrls_global_struct_b:
	move 4,1
	hrlz 1,hrls_gp+1
	iori 1,(4)
	movem 1,hrls_gp+1
	popj 17,

hrls_indirect:
	move 4,(1)
	hrlz 1,(4)
	iori 1,(2)
	movem 1,(4)
	popj 17,

hrls_volatile:
	move 4,(1)
	hrrz 2,2
	tlo 2,(4)
	movem 2,(1)
	move 1,2
	popj 17,

hrls_add:
	move 4,1
	hrlz 1,(1)
	iori 1,(2)
	movem 1,(4)
	add 1,3
	popj 17,

hrls_sub:
	move 4,1
	hrlz 1,(1)
	iori 1,(2)
	movem 1,(4)
	sub 1,3
	popj 17,

hrls_xor:
	move 4,1
	hrlz 1,(1)
	iori 1,(2)
	movem 1,(4)
	xor 1,3
	popj 17,

hrls_or:
	move 4,1
	hrlz 1,(1)
	iori 1,(2)
	movem 1,(4)
	ior 1,3
	popj 17,

hrls_and:
	move 4,1
	hrlz 1,(1)
	iori 1,(2)
	movem 1,(4)
	and 1,3
	popj 17,

hrls_call_add:
	push 17,10
	hrlz 10,(1)
	iori 10,(2)
	movem 10,(1)
	pushj 17,f
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

hrls_call_before:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	pushj 17,f
	move 4,1
	hrlz 1,(10)
	iori 1,(11)
	movem 1,(10)
	add 1,4
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

hrls_if_result_zero:
	move 6,4
	hrlz 4,(1)
	iori 4,(2)
	movem 4,(1)
	move 1,3
	jumpe 4,%L23
	move 1,6
%L23:
	popj 17,

hrls_if_result_nonzero:
	move 6,4
	hrlz 4,(1)
	iori 4,(2)
	movem 4,(1)
	move 1,3
	jumpn 4,%L25
	move 1,6
%L25:
	popj 17,

hrls_if_result_negative:
	move 6,4
	hrlz 4,(1)
	iori 4,(2)
	movem 4,(1)
	move 1,3
	jumpl 4,%L27
	move 1,6
%L27:
	popj 17,

hrls_likely:
	hrlz 4,(1)
	iori 4,(2)
	movem 4,(1)
	move 1,4
	jumpe 4,%L31
%L29:
	popj 17,
%L31:
	movei 1,0
	popj 17,

hrls_unlikely:
	hrlz 4,(1)
	iori 4,(2)
	movem 4,(1)
	move 1,4
	jumpn 4,%L32
	movei 1,0
%L32:
	popj 17,

hrls_sources_live:
	move 6,1
	move 4,(1)
	hrrz 1,2
	tlo 1,(4)
	movem 1,(6)
	add 1,4
	add 1,2
	add 1,3
	popj 17,

hrls_right_source_live:
	hrrz 4,(1)
	hrrz 2,2
	tlo 2,(4)
	movem 2,(1)
	add 2,4
	move 1,2
	popj 17,

hrls_ac_right_live:
	hrlz 4,(1)
	hrrz 2,2
	ior 4,2
	movem 4,(1)
	add 4,2
	move 1,4
	popj 17,

hrls_two_updates:
	move 4,1
	hrlz 1,(1)
	iori 1,(3)
	movem 1,(4)
	hrlz 4,(2)
	iori 4,(1)
	movem 4,(2)
	add 1,4
	popj 17,

hrls_loop:
	move 6,1
	move 1,2
	move 4,3
	subi 3,1
	jumple 4,%L44
	move 2,(6)
%L42:
	hrl 1,2
	move 2,1
	move 4,3
	subi 3,1
	jumpg 4,%L42
	movem 1,(6)
%L44:
	popj 17,

hrls_loop_sum:
	move 7,1
	movei 1,0
	move 4,3
	subi 3,1
	jumple 4,%L52
	move 6,(7)
%L50:
	hrrz 4,2
	tlo 4,(6)
	move 6,4
	move 2,4
	add 1,4
	move 4,3
	subi 3,1
	jumpg 4,%L50
	movem 6,(7)
%L52:
	popj 17,

hrls_loop_break:
	move 6,1
	move 4,3
	subi 3,1
	jumple 4,%L61
%L59:
	hrlz 4,(6)
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

uhrls_mem:
	move 4,1
	hrlz 1,(1)
	iori 1,(2)
	movem 1,(4)
	popj 17,

uhrls_global:
	move 4,1
	hrlz 1,hrls_uga
	iori 1,(4)
	movem 1,hrls_uga
	popj 17,

uhrls_array:
	move 4,1
	andi 2,17
	add 4,2
	hrlz 1,(4)
	iori 1,(3)
	movem 1,(4)
	popj 17,

uhrls_global_array:
	andi 1,17
	hrlz 4,hrls_ubuf(1)
	iori 4,(2)
	movem 4,hrls_ubuf(1)
	move 1,4
	popj 17,

uhrls_struct_a:
	move 4,1
	hrlz 1,(1)
	iori 1,(2)
	movem 1,(4)
	popj 17,

uhrls_global_struct_a:
	move 4,1
	hrlz 1,hrls_ugp
	iori 1,(4)
	movem 1,hrls_ugp
	popj 17,

uhrls_add:
	move 4,1
	hrlz 1,(1)
	iori 1,(2)
	movem 1,(4)
	add 1,3
	popj 17,

uhrls_bool:
	move 4,1
	hrlz 1,(1)
	iori 1,(2)
	movem 1,(4)
	skipe 1
	movei 1,1
	popj 17,

hrls_sqi_right:
	hrlz 4,(1)
	lsh 2,33
	ash 2,-33
	iori 4,(2)
	movem 4,(1)
	move 1,4
	popj 17,

hrls_uqi_right:
	andi 2,777	; zero_extendqisi2
	hrlz 4,(1)
	ior 4,2
	movem 4,(1)
	move 1,4
	popj 17,

hrls_hi_right:
	move 4,1
	hrlz 1,(1)
	iori 1,(2)
	movem 1,(4)
	popj 17,

hrls_uhi_right:
	move 4,1
	hrlz 1,(1)
	iori 1,(2)
	movem 1,(4)
	popj 17,

	.bss
hrls_ga:
	.space	4
hrls_gb:
	.space	4
hrls_uga:
	.space	4
hrls_vga:
	.space	4
hrls_buf:
	.space	64
hrls_ubuf:
	.space	64
hrls_gp:
	.space	8
hrls_ugp:
	.space	8
