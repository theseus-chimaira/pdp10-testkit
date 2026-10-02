
hrres_mem:
	move 3,1
	move 4,(1)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,(3)
	popj 17,

hrres_mem_alt:
	move 2,1
	move 4,(1)
	hrrz 3,4
	hrro 1,3
	trnn 4,400000
	move 1,3
	movem 1,(2)
	popj 17,

hrres_mem_return_ac:
	move 3,1
	move 4,(1)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,(3)
	popj 17,

hrres_global:
	move 4,hrres_ga
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,hrres_ga
	popj 17,

hrres_global_b:
	move 4,hrres_gb
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,hrres_gb
	popj 17,

hrres_array:
	move 3,1
	andi 2,17
	add 3,2
	move 4,(3)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,(3)
	popj 17,

hrres_global_array:
	move 3,1
	andi 3,17
	move 4,hrres_buf(3)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,hrres_buf(3)
	popj 17,

hrres_struct_a:
	move 3,1
	move 4,(1)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,(3)
	popj 17,

hrres_struct_b:
	move 3,1
	move 4,1(1)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,1(3)
	popj 17,

hrres_global_struct_a:
	move 4,hrres_gp
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,hrres_gp
	popj 17,

hrres_global_struct_b:
	move 4,hrres_gp+1
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,hrres_gp+1
	popj 17,

hrres_indirect:
	move 3,(1)
	move 4,(3)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,(3)
	popj 17,

hrres_volatile:
	move 3,1
	move 4,(1)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,(3)
	popj 17,

hrres_volatile_global:
	move 4,hrres_vga
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,hrres_vga
	popj 17,

hrres_add:
	move 3,1
	move 4,(1)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,(3)
	add 1,2
	popj 17,

hrres_sub:
	move 3,1
	move 4,(1)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,(3)
	sub 1,2
	popj 17,

hrres_xor:
	move 3,1
	move 4,(1)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,(3)
	xor 1,2
	popj 17,

hrres_or:
	move 3,1
	move 4,(1)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,(3)
	ior 1,2
	popj 17,

hrres_and:
	move 3,1
	move 4,(1)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,(3)
	and 1,2
	popj 17,

hrres_call_add:
	push 17,10
	move 4,(1)
	hrrz 10,4
	trne 4,400000
	hrro 10,10
	movem 10,(1)
	pushj 17,f
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

hrres_call_before:
	push 17,10
	move 10,1
	pushj 17,f
	move 3,1
	move 4,(10)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,(10)
	add 1,3
	pop 17,10
	popj 17,

hrres_if_result_zero:
	move 4,(1)
	hrrz 6,4
	trne 4,400000
	hrro 6,6
	movem 6,(1)
	move 1,2
	jumpe 6,%L47
	move 1,3
%L47:
	popj 17,

hrres_if_result_nonzero:
	move 4,(1)
	hrrz 6,4
	trne 4,400000
	hrro 6,6
	movem 6,(1)
	move 1,2
	jumpn 6,%L50
	move 1,3
%L50:
	popj 17,

hrres_if_result_negative:
	move 4,(1)
	hrrz 6,4
	trne 4,400000
	hrro 6,6
	movem 6,(1)
	move 1,2
	jumpl 6,%L53
	move 1,3
%L53:
	popj 17,

hrres_likely:
	move 4,(1)
	hrrz 3,4
	trne 4,400000
	hrro 3,3
	movem 3,(1)
	move 1,3
	jumpe 3,%L59
%L56:
	popj 17,
%L59:
	movei 1,0
	popj 17,

hrres_unlikely:
	move 4,(1)
	hrrz 3,4
	trne 4,400000
	hrro 3,3
	movem 3,(1)
	move 1,3
	jumpn 3,%L60
	movei 1,0
%L60:
	popj 17,

hrres_ext_bits:
	move 3,1
	move 4,(1)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,(3)
	hllz 1,1
	popj 17,

hrres_right_bits:
	move 3,1
	move 4,(1)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,(3)
	hrrz 1,1
	popj 17,

hrres_source_right_sign:
	move 2,1
	move 4,(1)
	hrrz 3,4
	move 1,4
	andi 1,400000
	jumpe 1,%L68
	hrro 3,3
%L68:
	movem 3,(2)
	popj 17,

hrres_ext_is_ones:
	move 3,1
	move 4,(1)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,(3)
	hllz 1,1
	movsi 6,777777
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

hrres_ext_is_zero:
	move 3,1
	move 4,(1)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,(3)
	hllz 1,1
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

hrres_mix_after_extend:
	move 3,1
	move 4,(1)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,(3)
	add 1,2
	popj 17,

hrres_source_live:
	move 3,1
	move 4,(1)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,(3)
	add 1,4
	add 1,2
	popj 17,

hrres_right_source_live:
	move 3,1
	move 4,(1)
	hrrz 1,4
	move 2,1
	trne 4,400000
	hrro 1,1
	movem 1,(3)
	add 1,2
	popj 17,

hrres_left_source_dead:
	move 3,1
	move 4,(1)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,(3)
	hllz 4,4
	add 1,4
	popj 17,

hrres_two_updates:
	move 3,1
	move 4,(1)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,(3)
	move 4,(2)
	hrrz 3,4
	trne 4,400000
	hrro 3,3
	movem 3,(2)
	add 1,3
	popj 17,

hrres_loop:
	move 3,1
	movei 1,0
	move 4,2
	subi 2,1
	jumple 4,%L91
%L89:
	move 4,(3)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,(3)
	move 4,2
	subi 2,1
	jumpg 4,%L89
%L91:
	popj 17,

hrres_loop_sum:
	move 6,1
	movei 1,0
	move 4,2
	subi 2,1
	jumple 4,%L99
%L97:
	move 4,(6)
	hrrz 3,4
	trne 4,400000
	hrro 3,3
	movem 3,(6)
	add 1,3
	move 4,2
	subi 2,1
	jumpg 4,%L97
%L99:
	popj 17,

hrres_loop_break:
	move 4,2
	subi 2,1
	jumple 4,%L108
%L106:
	move 4,(1)
	hrrz 3,4
	trne 4,400000
	hrro 3,3
	movem 3,(1)
	move 4,2
	jumpe 3,%L100
	subi 2,1
	jumpg 4,%L106
%L108:
	move 4,(1)
%L100:
	move 1,4
	popj 17,

hrres_store_then_load:
	move 3,1
	move 4,(1)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,(3)
	popj 17,

hrres_store_then_bool:
	move 3,1
	move 4,(1)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,(3)
	skipe 1
	movei 1,1
	popj 17,

hrres_store_then_add:
	move 3,1
	move 4,(1)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,(3)
	add 1,2
	popj 17,

uhrres_mem:
	move 3,1
	move 4,(1)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,(3)
	popj 17,

uhrres_global:
	move 4,hrres_uga
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,hrres_uga
	popj 17,

uhrres_array:
	move 3,1
	andi 2,17
	add 3,2
	move 4,(3)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,(3)
	popj 17,

uhrres_global_array:
	move 3,1
	andi 3,17
	move 4,hrres_ubuf(3)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,hrres_ubuf(3)
	popj 17,

uhrres_struct_a:
	move 3,1
	move 4,(1)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,(3)
	popj 17,

uhrres_global_struct_a:
	move 4,hrres_ugp
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,hrres_ugp
	popj 17,

uhrres_add:
	move 3,1
	move 4,(1)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,(3)
	add 1,2
	popj 17,

uhrres_bool:
	move 3,1
	move 4,(1)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,(3)
	skipe 1
	movei 1,1
	popj 17,

uhrres_right_bits:
	move 3,1
	move 4,(1)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,(3)
	hrrz 1,1
	popj 17,

uhrres_ext_bits:
	move 3,1
	move 4,(1)
	hrrz 1,4
	trne 4,400000
	hrro 1,1
	movem 1,(3)
	hllz 1,1
	popj 17,

hrres_sqi_temp:
	move 4,1
	lsh 2,33
	ash 2,-33
	movem 2,(1)
	hrrz 1,2
	jumpge 2,%L139
	hrro 1,1
%L139:
	movem 1,(4)
	popj 17,

hrres_uqi_temp:
	andi 2,777	; zero_extendqisi2
	hrrz 2,2
	movem 2,(1)
	move 1,2
	popj 17,

hrres_hi_temp:
	move 4,1
	hrre 2,2
	movem 2,(1)
	hrrz 1,2
	trne 2,400000
	hrro 1,1
	movem 1,(4)
	popj 17,

hrres_uhi_temp:
	move 4,1
	hrrzi 2,(2)	; zero_extendhisi2
	movem 2,(1)
	hrrz 1,2
	andi 2,400000
	jumpe 2,%L145
	hrro 1,1
%L145:
	movem 1,(4)
	popj 17,

	.bss
hrres_ga:
	.space	4
hrres_gb:
	.space	4
hrres_uga:
	.space	4
hrres_vga:
	.space	4
hrres_buf:
	.space	64
hrres_ubuf:
	.space	64
hrres_gp:
	.space	8
hrres_ugp:
	.space	8
