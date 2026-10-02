
hlles_mem:
	move 3,1
	move 4,(1)
	hllz 1,4
	jumpge 4,%L2
	hllo 1,1
%L2:
	movem 1,(3)
	popj 17,

hlles_mem_alt:
	move 3,1
	move 4,(1)
	hllz 1,4
	jumpge 4,%L4
	hllo 1,1
%L4:
	movem 1,(3)
	popj 17,

hlles_mem_return_ac:
	move 3,1
	move 4,(1)
	hllz 1,4
	jumpge 4,%L6
	hllo 1,1
%L6:
	movem 1,(3)
	popj 17,

hlles_global:
	move 4,hlles_ga
	hllz 1,4
	jumpge 4,%L8
	hllo 1,1
%L8:
	movem 1,hlles_ga
	popj 17,

hlles_global_b:
	move 4,hlles_gb
	hllz 1,4
	jumpge 4,%L10
	hllo 1,1
%L10:
	movem 1,hlles_gb
	popj 17,

hlles_array:
	move 3,1
	andi 2,17
	add 3,2
	move 4,(3)
	hllz 1,4
	jumpge 4,%L13
	hllo 1,1
%L13:
	movem 1,(3)
	popj 17,

hlles_global_array:
	move 3,1
	andi 3,17
	move 4,hlles_buf(3)
	hllz 1,4
	jumpge 4,%L16
	hllo 1,1
%L16:
	movem 1,hlles_buf(3)
	popj 17,

hlles_struct_a:
	move 3,1
	move 4,(1)
	hllz 1,4
	jumpge 4,%L18
	hllo 1,1
%L18:
	movem 1,(3)
	popj 17,

hlles_struct_b:
	move 3,1
	move 4,1(1)
	hllz 1,4
	jumpge 4,%L20
	hllo 1,1
%L20:
	movem 1,1(3)
	popj 17,

hlles_global_struct_a:
	move 4,hlles_gp
	hllz 1,4
	jumpge 4,%L22
	hllo 1,1
%L22:
	movem 1,hlles_gp
	popj 17,

hlles_global_struct_b:
	move 4,hlles_gp+1
	hllz 1,4
	jumpge 4,%L24
	hllo 1,1
%L24:
	movem 1,hlles_gp+1
	popj 17,

hlles_indirect:
	move 3,(1)
	move 4,(3)
	hllz 1,4
	jumpge 4,%L26
	hllo 1,1
%L26:
	movem 1,(3)
	popj 17,

hlles_volatile:
	move 3,1
	move 4,(1)
	hllz 1,4
	jumpge 4,%L28
	hllo 1,1
%L28:
	movem 1,(3)
	popj 17,

hlles_volatile_global:
	move 4,hlles_vga
	hllz 1,4
	jumpge 4,%L30
	hllo 1,1
%L30:
	movem 1,hlles_vga
	popj 17,

hlles_add:
	move 3,1
	move 4,(1)
	hllz 1,4
	jumpge 4,%L32
	hllo 1,1
%L32:
	movem 1,(3)
	add 1,2
	popj 17,

hlles_sub:
	move 3,1
	move 4,(1)
	hllz 1,4
	jumpge 4,%L34
	hllo 1,1
%L34:
	movem 1,(3)
	sub 1,2
	popj 17,

hlles_xor:
	move 3,1
	move 4,(1)
	hllz 1,4
	jumpge 4,%L36
	hllo 1,1
%L36:
	movem 1,(3)
	xor 1,2
	popj 17,

hlles_or:
	move 3,1
	move 4,(1)
	hllz 1,4
	jumpge 4,%L38
	hllo 1,1
%L38:
	movem 1,(3)
	ior 1,2
	popj 17,

hlles_and:
	move 3,1
	move 4,(1)
	hllz 1,4
	jumpge 4,%L40
	hllo 1,1
%L40:
	movem 1,(3)
	and 1,2
	popj 17,

hlles_call_add:
	push 17,10
	move 4,(1)
	hllz 10,4
	jumpge 4,%L42
	hllo 10,10
%L42:
	movem 10,(1)
	pushj 17,f
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

hlles_call_before:
	push 17,10
	move 10,1
	pushj 17,f
	move 3,1
	move 4,(10)
	hllz 1,4
	jumpge 4,%L44
	hllo 1,1
%L44:
	movem 1,(10)
	add 1,3
	pop 17,10
	popj 17,

hlles_if_result_zero:
	move 4,(1)
	hllz 6,4
	jumpge 4,%L46
	hllo 6,6
%L46:
	movem 6,(1)
	move 1,2
	jumpe 6,%L45
	move 1,3
%L45:
	popj 17,

hlles_if_result_nonzero:
	move 4,(1)
	hllz 6,4
	jumpge 4,%L49
	hllo 6,6
%L49:
	movem 6,(1)
	move 1,2
	jumpn 6,%L48
	move 1,3
%L48:
	popj 17,

hlles_if_result_negative:
	move 4,(1)
	hllz 6,4
	jumpge 4,%L52
	hllo 6,6
%L52:
	movem 6,(1)
	move 1,2
	jumpl 6,%L51
	move 1,3
%L51:
	popj 17,

hlles_likely:
	move 4,(1)
	hllz 3,4
	jumpge 4,%L55
	hllo 3,3
%L55:
	movem 3,(1)
	move 1,3
	jumpe 3,%L57
%L54:
	popj 17,
%L57:
	movei 1,0
	popj 17,

hlles_unlikely:
	move 4,(1)
	hllz 3,4
	jumpge 4,%L59
	hllo 3,3
%L59:
	movem 3,(1)
	move 1,3
	jumpn 3,%L58
	movei 1,0
%L58:
	popj 17,

hlles_ext_bits:
	move 3,1
	move 4,(1)
	hllz 1,4
	jumpge 4,%L62
	hllo 1,1
%L62:
	movem 1,(3)
	hrrz 1,1
	popj 17,

hlles_left_bits:
	move 3,1
	move 4,(1)
	hllz 1,4
	jumpge 4,%L64
	hllo 1,1
%L64:
	movem 1,(3)
	hllz 1,1
	popj 17,

hlles_sign_bit:
	move 3,1
	move 4,(1)
	hllz 1,4
	jumpge 4,%L66
	hllo 1,1
%L66:
	movem 1,(3)
	and 1,[-400000000000]
	popj 17,

hlles_ext_is_ones:
	move 3,1
	move 4,(1)
	hllz 1,4
	jumpge 4,%L68
	hllo 1,1
%L68:
	movem 1,(3)
	hrrz 1,1
	movei 6,777777
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

hlles_ext_is_zero:
	move 3,1
	move 4,(1)
	hllz 1,4
	jumpge 4,%L70
	hllo 1,1
%L70:
	movem 1,(3)
	hrrz 1,1
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

hlles_source_live:
	move 3,1
	move 4,(1)
	hllz 1,4
	jumpge 4,%L72
	hllo 1,1
%L72:
	movem 1,(3)
	add 1,4
	add 1,2
	popj 17,

hlles_left_source_live:
	move 3,1
	move 4,(1)
	hllz 1,4
	move 2,1
	jumpge 4,%L74
	hllo 1,1
%L74:
	movem 1,(3)
	add 1,2
	popj 17,

hlles_right_source_live:
	move 3,1
	move 4,(1)
	hllz 1,4
	jumpge 4,%L76
	hllo 1,1
%L76:
	movem 1,(3)
	addi 1,(4)
	popj 17,

hlles_two_updates:
	move 3,1
	move 4,(1)
	hllz 1,4
	jumpge 4,%L78
	hllo 1,1
%L78:
	movem 1,(3)
	move 4,(2)
	hllz 3,4
	jumpge 4,%L79
	hllo 3,3
%L79:
	movem 3,(2)
	add 1,3
	popj 17,

hlles_loop:
	move 3,1
	movei 1,0
	move 4,2
	subi 2,1
	jumple 4,%L87
%L85:
	move 4,(3)
	hllz 1,4
	jumpge 4,%L84
	hllo 1,1
%L84:
	movem 1,(3)
	move 4,2
	subi 2,1
	jumpg 4,%L85
%L87:
	popj 17,

hlles_loop_sum:
	move 6,1
	movei 1,0
	move 4,2
	subi 2,1
	jumple 4,%L95
%L93:
	move 4,(6)
	hllz 3,4
	jumpge 4,%L92
	hllo 3,3
%L92:
	movem 3,(6)
	add 1,3
	move 4,2
	subi 2,1
	jumpg 4,%L93
%L95:
	popj 17,

hlles_loop_break:
	move 4,2
	subi 2,1
	jumple 4,%L104
%L102:
	move 4,(1)
	hllz 3,4
	jumpge 4,%L100
	hllo 3,3
%L100:
	movem 3,(1)
	move 4,2
	jumpe 3,%L96
	subi 2,1
	jumpg 4,%L102
%L104:
	move 4,(1)
%L96:
	move 1,4
	popj 17,

hlles_store_then_load:
	move 3,1
	move 4,(1)
	hllz 1,4
	jumpge 4,%L106
	hllo 1,1
%L106:
	movem 1,(3)
	popj 17,

hlles_store_then_bool:
	move 3,1
	move 4,(1)
	hllz 1,4
	jumpge 4,%L108
	hllo 1,1
%L108:
	movem 1,(3)
	skipe 1
	movei 1,1
	popj 17,

hlles_store_then_add:
	move 3,1
	move 4,(1)
	hllz 1,4
	jumpge 4,%L110
	hllo 1,1
%L110:
	movem 1,(3)
	add 1,2
	popj 17,

uhlles_mem:
	move 3,1
	move 4,(1)
	hllz 1,4
	jumpge 4,%L112
	hllo 1,1
%L112:
	movem 1,(3)
	popj 17,

uhlles_global:
	move 4,hlles_uga
	hllz 1,4
	jumpge 4,%L114
	hllo 1,1
%L114:
	movem 1,hlles_uga
	popj 17,

uhlles_array:
	move 3,1
	andi 2,17
	add 3,2
	move 4,(3)
	hllz 1,4
	jumpge 4,%L117
	hllo 1,1
%L117:
	movem 1,(3)
	popj 17,

uhlles_global_array:
	move 3,1
	andi 3,17
	move 4,hlles_ubuf(3)
	hllz 1,4
	jumpge 4,%L120
	hllo 1,1
%L120:
	movem 1,hlles_ubuf(3)
	popj 17,

uhlles_struct_a:
	move 3,1
	move 4,(1)
	hllz 1,4
	jumpge 4,%L122
	hllo 1,1
%L122:
	movem 1,(3)
	popj 17,

uhlles_global_struct_a:
	move 4,hlles_ugp
	hllz 1,4
	jumpge 4,%L124
	hllo 1,1
%L124:
	movem 1,hlles_ugp
	popj 17,

uhlles_add:
	move 3,1
	move 4,(1)
	hllz 1,4
	jumpge 4,%L126
	hllo 1,1
%L126:
	movem 1,(3)
	add 1,2
	popj 17,

uhlles_bool:
	move 3,1
	move 4,(1)
	hllz 1,4
	jumpge 4,%L128
	hllo 1,1
%L128:
	movem 1,(3)
	skipe 1
	movei 1,1
	popj 17,

uhlles_ext_bits:
	move 3,1
	move 4,(1)
	hllz 1,4
	jumpge 4,%L130
	hllo 1,1
%L130:
	movem 1,(3)
	hrrz 1,1
	popj 17,

hlles_sqi_temp:
	move 4,1
	lsh 2,33
	ash 2,-33
	movem 2,(1)
	hllz 1,2
	jumpge 2,%L132
	hllo 1,1
%L132:
	movem 1,(4)
	popj 17,

hlles_uqi_temp:
	andi 2,777	; zero_extendqisi2
	hllz 2,2
	movem 2,(1)
	move 1,2
	popj 17,

hlles_hi_temp:
	move 4,1
	hrre 2,2
	movem 2,(1)
	hllz 1,2
	jumpge 2,%L136
	hllo 1,1
%L136:
	movem 1,(4)
	popj 17,

hlles_uhi_temp:
	hrrzi 2,(2)	; zero_extendhisi2
	hllz 2,2
	movem 2,(1)
	move 1,2
	popj 17,

	.bss
hlles_ga:
	.space	4
hlles_gb:
	.space	4
hlles_uga:
	.space	4
hlles_vga:
	.space	4
hlles_buf:
	.space	64
hlles_ubuf:
	.space	64
hlles_gp:
	.space	8
hlles_ugp:
	.space	8
