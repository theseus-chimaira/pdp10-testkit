
hrles_mem:
	move 3,1
	move 4,(1)
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,(3)
	popj 17,

hrles_mem_alt:
	move 3,1
	move 4,(1)
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,(3)
	popj 17,

hrles_mem_return_ac:
	move 3,1
	move 4,(1)
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,(3)
	popj 17,

hrles_global:
	move 4,hrles_ga
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,hrles_ga
	popj 17,

hrles_global_b:
	move 4,hrles_gb
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,hrles_gb
	popj 17,

hrles_array:
	move 3,1
	andi 2,17
	add 3,2
	move 4,(3)
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,(3)
	popj 17,

hrles_global_array:
	move 3,1
	andi 3,17
	move 4,hrles_buf(3)
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,hrles_buf(3)
	popj 17,

hrles_struct_a:
	move 3,1
	move 4,(1)
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,(3)
	popj 17,

hrles_struct_b:
	move 3,1
	move 4,1(1)
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,1(3)
	popj 17,

hrles_global_struct_a:
	move 4,hrles_gp
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,hrles_gp
	popj 17,

hrles_global_struct_b:
	move 4,hrles_gp+1
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,hrles_gp+1
	popj 17,

hrles_indirect:
	move 3,(1)
	move 4,(3)
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,(3)
	popj 17,

hrles_volatile:
	move 3,1
	move 4,(1)
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,(3)
	popj 17,

hrles_volatile_global:
	move 4,hrles_vga
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,hrles_vga
	popj 17,

hrles_add:
	move 3,1
	move 4,(1)
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,(3)
	add 1,2
	popj 17,

hrles_sub:
	move 3,1
	move 4,(1)
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,(3)
	sub 1,2
	popj 17,

hrles_xor:
	move 3,1
	move 4,(1)
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,(3)
	xor 1,2
	popj 17,

hrles_or:
	move 3,1
	move 4,(1)
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,(3)
	ior 1,2
	popj 17,

hrles_and:
	move 3,1
	move 4,(1)
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,(3)
	and 1,2
	popj 17,

hrles_call_add:
	push 17,10
	move 4,(1)
	hrlz 10,4
	trne 4,400000
	hllo 10,10
	movem 10,(1)
	pushj 17,f
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

hrles_call_before:
	push 17,10
	move 10,1
	pushj 17,f
	move 3,1
	move 4,(10)
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,(10)
	add 1,3
	pop 17,10
	popj 17,

hrles_if_result_zero:
	move 4,(1)
	hrlz 6,4
	trne 4,400000
	hllo 6,6
	movem 6,(1)
	move 1,2
	jumpe 6,%L45
	move 1,3
%L45:
	popj 17,

hrles_if_result_nonzero:
	move 4,(1)
	hrlz 6,4
	trne 4,400000
	hllo 6,6
	movem 6,(1)
	move 1,2
	jumpn 6,%L48
	move 1,3
%L48:
	popj 17,

hrles_if_result_negative:
	move 4,(1)
	hrlz 6,4
	trne 4,400000
	hllo 6,6
	movem 6,(1)
	move 1,2
	jumpl 6,%L51
	move 1,3
%L51:
	popj 17,

hrles_likely:
	move 4,(1)
	hrlz 3,4
	trne 4,400000
	hllo 3,3
	movem 3,(1)
	move 1,3
	jumpe 3,%L57
%L54:
	popj 17,
%L57:
	movei 1,0
	popj 17,

hrles_unlikely:
	move 4,(1)
	hrlz 3,4
	trne 4,400000
	hllo 3,3
	movem 3,(1)
	move 1,3
	jumpn 3,%L58
	movei 1,0
%L58:
	popj 17,

hrles_ext_bits:
	move 3,1
	move 4,(1)
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,(3)
	hrrz 1,1
	popj 17,

hrles_left_bits:
	move 3,1
	move 4,(1)
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,(3)
	hllz 1,1
	popj 17,

hrles_source_right_bits:
	move 2,1
	move 4,(1)
	hrrz 1,4
	hrlz 3,1
	trne 4,400000
	hllo 3,3
	movem 3,(2)
	popj 17,

hrles_source_right_sign:
	move 2,1
	move 4,(1)
	hrlz 3,4
	move 1,4
	andi 1,400000
	jumpe 1,%L68
	hllo 3,3
%L68:
	movem 3,(2)
	popj 17,

hrles_ext_is_ones:
	move 3,1
	move 4,(1)
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,(3)
	hrrz 1,1
	movei 6,777777
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

hrles_ext_is_zero:
	move 3,1
	move 4,(1)
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,(3)
	hrrz 1,1
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

hrles_source_live:
	move 3,1
	move 4,(1)
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,(3)
	add 1,4
	add 1,2
	popj 17,

hrles_right_source_live:
	move 2,1
	move 4,(1)
	hrrz 3,4
	hrlz 1,3
	trne 4,400000
	hllo 1,1
	movem 1,(2)
	add 1,3
	popj 17,

hrles_left_source_dead:
	move 3,1
	move 4,(1)
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,(3)
	hllz 4,4
	add 1,4
	popj 17,

hrles_two_updates:
	move 3,1
	move 4,(1)
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,(3)
	move 4,(2)
	hrlz 3,4
	trne 4,400000
	hllo 3,3
	movem 3,(2)
	add 1,3
	popj 17,

hrles_loop:
	move 3,1
	movei 1,0
	move 4,2
	subi 2,1
	jumple 4,%L89
%L87:
	move 4,(3)
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,(3)
	move 4,2
	subi 2,1
	jumpg 4,%L87
%L89:
	popj 17,

hrles_loop_sum:
	move 6,1
	movei 1,0
	move 4,2
	subi 2,1
	jumple 4,%L97
%L95:
	move 4,(6)
	hrlz 3,4
	trne 4,400000
	hllo 3,3
	movem 3,(6)
	add 1,3
	move 4,2
	subi 2,1
	jumpg 4,%L95
%L97:
	popj 17,

hrles_loop_break:
	move 4,2
	subi 2,1
	jumple 4,%L106
%L104:
	move 4,(1)
	hrlz 3,4
	trne 4,400000
	hllo 3,3
	movem 3,(1)
	move 4,2
	jumpe 3,%L98
	subi 2,1
	jumpg 4,%L104
%L106:
	move 4,(1)
%L98:
	move 1,4
	popj 17,

hrles_store_then_load:
	move 3,1
	move 4,(1)
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,(3)
	popj 17,

hrles_store_then_bool:
	move 3,1
	move 4,(1)
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,(3)
	skipe 1
	movei 1,1
	popj 17,

hrles_store_then_add:
	move 3,1
	move 4,(1)
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,(3)
	add 1,2
	popj 17,

uhrles_mem:
	move 3,1
	move 4,(1)
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,(3)
	popj 17,

uhrles_global:
	move 4,hrles_uga
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,hrles_uga
	popj 17,

uhrles_array:
	move 3,1
	andi 2,17
	add 3,2
	move 4,(3)
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,(3)
	popj 17,

uhrles_global_array:
	move 3,1
	andi 3,17
	move 4,hrles_ubuf(3)
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,hrles_ubuf(3)
	popj 17,

uhrles_struct_a:
	move 3,1
	move 4,(1)
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,(3)
	popj 17,

uhrles_global_struct_a:
	move 4,hrles_ugp
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,hrles_ugp
	popj 17,

uhrles_add:
	move 3,1
	move 4,(1)
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,(3)
	add 1,2
	popj 17,

uhrles_bool:
	move 3,1
	move 4,(1)
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,(3)
	skipe 1
	movei 1,1
	popj 17,

uhrles_ext_bits:
	move 3,1
	move 4,(1)
	hrlz 1,4
	trne 4,400000
	hllo 1,1
	movem 1,(3)
	hrrz 1,1
	popj 17,

uhrles_source_right_bits:
	move 2,1
	move 4,(1)
	hrrz 1,4
	hrlz 3,1
	trne 4,400000
	hllo 3,3
	movem 3,(2)
	popj 17,

hrles_sqi_temp:
	move 4,1
	lsh 2,33
	ash 2,-33
	movem 2,(1)
	hrlz 1,2
	jumpge 2,%L136
	hllo 1,1
%L136:
	movem 1,(4)
	popj 17,

hrles_uqi_temp:
	andi 2,777	; zero_extendqisi2
	hrlz 2,2
	movem 2,(1)
	move 1,2
	popj 17,

hrles_hi_temp:
	move 4,1
	hrre 2,2
	movem 2,(1)
	hrlz 1,2
	trne 2,400000
	hllo 1,1
	movem 1,(4)
	popj 17,

hrles_uhi_temp:
	move 4,1
	hrrzi 2,(2)	; zero_extendhisi2
	movem 2,(1)
	hrlz 1,2
	andi 2,400000
	jumpe 2,%L142
	hllo 1,1
%L142:
	movem 1,(4)
	popj 17,

	.bss
hrles_ga:
	.space	4
hrles_gb:
	.space	4
hrles_uga:
	.space	4
hrles_vga:
	.space	4
hrles_buf:
	.space	64
hrles_ubuf:
	.space	64
hrles_gp:
	.space	8
hrles_ugp:
	.space	8
