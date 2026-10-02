
hlres_mem:
	move 3,1
	move 4,(1)
	hlrz 1,4
	jumpge 4,%L2
	hrro 1,1
%L2:
	movem 1,(3)
	popj 17,

hlres_mem_alt:
	move 3,1
	move 4,(1)
	hlrz 1,4
	jumpge 4,%L4
	hrro 1,1
%L4:
	movem 1,(3)
	popj 17,

hlres_mem_return_ac:
	move 3,1
	move 4,(1)
	hlrz 1,4
	jumpge 4,%L6
	hrro 1,1
%L6:
	movem 1,(3)
	popj 17,

hlres_global:
	move 4,hlres_ga
	hlrz 1,4
	jumpge 4,%L8
	hrro 1,1
%L8:
	movem 1,hlres_ga
	popj 17,

hlres_global_b:
	move 4,hlres_gb
	hlrz 1,4
	jumpge 4,%L10
	hrro 1,1
%L10:
	movem 1,hlres_gb
	popj 17,

hlres_array:
	move 3,1
	andi 2,17
	add 3,2
	move 4,(3)
	hlrz 1,4
	jumpge 4,%L13
	hrro 1,1
%L13:
	movem 1,(3)
	popj 17,

hlres_global_array:
	move 3,1
	andi 3,17
	move 4,hlres_buf(3)
	hlrz 1,4
	jumpge 4,%L17
	hrro 1,1
%L17:
	movem 1,hlres_buf(3)
	popj 17,

hlres_struct_a:
	move 3,1
	move 4,(1)
	hlrz 1,4
	jumpge 4,%L19
	hrro 1,1
%L19:
	movem 1,(3)
	popj 17,

hlres_struct_b:
	move 3,1
	move 4,1(1)
	hlrz 1,4
	jumpge 4,%L21
	hrro 1,1
%L21:
	movem 1,1(3)
	popj 17,

hlres_global_struct_a:
	move 4,hlres_gp
	hlrz 1,4
	jumpge 4,%L23
	hrro 1,1
%L23:
	movem 1,hlres_gp
	popj 17,

hlres_global_struct_b:
	move 4,hlres_gp+1
	hlrz 1,4
	jumpge 4,%L25
	hrro 1,1
%L25:
	movem 1,hlres_gp+1
	popj 17,

hlres_indirect:
	move 3,(1)
	move 4,(3)
	hlrz 1,4
	jumpge 4,%L27
	hrro 1,1
%L27:
	movem 1,(3)
	popj 17,

hlres_volatile:
	move 3,1
	move 4,(1)
	hlrz 1,4
	jumpge 4,%L29
	hrro 1,1
%L29:
	movem 1,(3)
	popj 17,

hlres_volatile_global:
	move 4,hlres_vga
	hlrz 1,4
	jumpge 4,%L31
	hrro 1,1
%L31:
	movem 1,hlres_vga
	popj 17,

hlres_add:
	move 3,1
	move 4,(1)
	hlrz 1,4
	jumpge 4,%L33
	hrro 1,1
%L33:
	movem 1,(3)
	add 1,2
	popj 17,

hlres_sub:
	move 3,1
	move 4,(1)
	hlrz 1,4
	jumpge 4,%L35
	hrro 1,1
%L35:
	movem 1,(3)
	sub 1,2
	popj 17,

hlres_xor:
	move 3,1
	move 4,(1)
	hlrz 1,4
	jumpge 4,%L37
	hrro 1,1
%L37:
	movem 1,(3)
	xor 1,2
	popj 17,

hlres_or:
	move 3,1
	move 4,(1)
	hlrz 1,4
	jumpge 4,%L39
	hrro 1,1
%L39:
	movem 1,(3)
	ior 1,2
	popj 17,

hlres_and:
	move 3,1
	move 4,(1)
	hlrz 1,4
	jumpge 4,%L41
	hrro 1,1
%L41:
	movem 1,(3)
	and 1,2
	popj 17,

hlres_call_add:
	push 17,10
	move 4,(1)
	hlrz 10,4
	jumpge 4,%L43
	hrro 10,10
%L43:
	movem 10,(1)
	pushj 17,f
	add 10,1
	move 1,10
	pop 17,10
	popj 17,

hlres_call_before:
	push 17,10
	move 10,1
	pushj 17,f
	move 3,1
	move 4,(10)
	hlrz 1,4
	jumpge 4,%L45
	hrro 1,1
%L45:
	movem 1,(10)
	add 1,3
	pop 17,10
	popj 17,

hlres_if_result_zero:
	move 4,(1)
	hlrz 6,4
	jumpge 4,%L47
	hrro 6,6
%L47:
	movem 6,(1)
	move 1,2
	jumpe 6,%L46
	move 1,3
%L46:
	popj 17,

hlres_if_result_nonzero:
	move 4,(1)
	hlrz 6,4
	jumpge 4,%L50
	hrro 6,6
%L50:
	movem 6,(1)
	move 1,2
	jumpn 6,%L49
	move 1,3
%L49:
	popj 17,

hlres_if_result_negative:
	move 4,(1)
	hlrz 6,4
	jumpge 4,%L53
	hrro 6,6
%L53:
	movem 6,(1)
	move 1,2
	jumpl 6,%L52
	move 1,3
%L52:
	popj 17,

hlres_likely:
	move 4,(1)
	hlrz 3,4
	jumpge 4,%L56
	hrro 3,3
%L56:
	movem 3,(1)
	move 1,3
	jumpe 3,%L58
%L55:
	popj 17,
%L58:
	movei 1,0
	popj 17,

hlres_unlikely:
	move 4,(1)
	hlrz 3,4
	jumpge 4,%L60
	hrro 3,3
%L60:
	movem 3,(1)
	move 1,3
	jumpn 3,%L59
	movei 1,0
%L59:
	popj 17,

hlres_ext_bits:
	move 3,1
	move 4,(1)
	hlrz 1,4
	jumpge 4,%L63
	hrro 1,1
%L63:
	movem 1,(3)
	hllz 1,1
	popj 17,

hlres_right_bits:
	move 3,1
	move 4,(1)
	hlrz 1,4
	jumpge 4,%L65
	hrro 1,1
%L65:
	movem 1,(3)
	hrrz 1,1
	popj 17,

hlres_source_left_sign:
	move 2,1
	move 4,(1)
	hlrz 3,4
	move 1,4
	and 1,[-400000000000]
	jumpe 1,%L67
	hrro 3,3
%L67:
	movem 3,(2)
	popj 17,

hlres_source_left_bits:
	move 2,1
	move 4,(1)
	hllz 1,4
	hlrz 3,1
	jumpge 4,%L69
	hrro 3,3
%L69:
	movem 3,(2)
	popj 17,

hlres_ext_is_ones:
	move 3,1
	move 4,(1)
	hlrz 1,4
	jumpge 4,%L71
	hrro 1,1
%L71:
	movem 1,(3)
	hllz 1,1
	movsi 6,777777
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

hlres_ext_is_zero:
	move 3,1
	move 4,(1)
	hlrz 1,4
	jumpge 4,%L73
	hrro 1,1
%L73:
	movem 1,(3)
	hllz 1,1
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

hlres_mix_after_extend:
	move 3,1
	move 4,(1)
	hlrz 1,4
	jumpge 4,%L75
	hrro 1,1
%L75:
	movem 1,(3)
	add 1,2
	popj 17,

hlres_source_live:
	move 3,1
	move 4,(1)
	hlrz 1,4
	jumpge 4,%L77
	hrro 1,1
%L77:
	movem 1,(3)
	add 1,4
	add 1,2
	popj 17,

hlres_left_source_live:
	move 2,1
	move 4,(1)
	hllz 3,4
	hlrz 1,3
	jumpge 4,%L79
	hrro 1,1
%L79:
	movem 1,(2)
	add 1,3
	popj 17,

hlres_right_source_dead:
	move 3,1
	move 4,(1)
	hlrz 1,4
	jumpge 4,%L81
	hrro 1,1
%L81:
	movem 1,(3)
	addi 1,(4)
	popj 17,

hlres_two_updates:
	move 3,1
	move 4,(1)
	hlrz 1,4
	jumpge 4,%L83
	hrro 1,1
%L83:
	movem 1,(3)
	move 4,(2)
	hlrz 3,4
	jumpge 4,%L84
	hrro 3,3
%L84:
	movem 3,(2)
	add 1,3
	popj 17,

hlres_loop:
	move 3,1
	movei 1,0
	move 4,2
	subi 2,1
	jumple 4,%L92
%L90:
	move 4,(3)
	hlrz 1,4
	jumpge 4,%L89
	hrro 1,1
%L89:
	movem 1,(3)
	move 4,2
	subi 2,1
	jumpg 4,%L90
%L92:
	popj 17,

hlres_loop_sum:
	move 6,1
	movei 1,0
	move 4,2
	subi 2,1
	jumple 4,%L100
%L98:
	move 4,(6)
	hlrz 3,4
	jumpge 4,%L97
	hrro 3,3
%L97:
	movem 3,(6)
	add 1,3
	move 4,2
	subi 2,1
	jumpg 4,%L98
%L100:
	popj 17,

hlres_loop_break:
	move 4,2
	subi 2,1
	jumple 4,%L109
%L107:
	move 4,(1)
	hlrz 3,4
	jumpge 4,%L105
	hrro 3,3
%L105:
	movem 3,(1)
	move 4,2
	jumpe 3,%L101
	subi 2,1
	jumpg 4,%L107
%L109:
	move 4,(1)
%L101:
	move 1,4
	popj 17,

hlres_store_then_load:
	move 3,1
	move 4,(1)
	hlrz 1,4
	jumpge 4,%L111
	hrro 1,1
%L111:
	movem 1,(3)
	popj 17,

hlres_store_then_bool:
	move 3,1
	move 4,(1)
	hlrz 1,4
	jumpge 4,%L113
	hrro 1,1
%L113:
	movem 1,(3)
	skipe 1
	movei 1,1
	popj 17,

hlres_store_then_add:
	move 3,1
	move 4,(1)
	hlrz 1,4
	jumpge 4,%L115
	hrro 1,1
%L115:
	movem 1,(3)
	add 1,2
	popj 17,

uhlres_mem:
	move 3,1
	move 4,(1)
	hlrz 1,4
	jumpge 4,%L117
	hrro 1,1
%L117:
	movem 1,(3)
	popj 17,

uhlres_global:
	move 4,hlres_uga
	hlrz 1,4
	jumpge 4,%L119
	hrro 1,1
%L119:
	movem 1,hlres_uga
	popj 17,

uhlres_array:
	move 3,1
	andi 2,17
	add 3,2
	move 4,(3)
	hlrz 1,4
	jumpge 4,%L122
	hrro 1,1
%L122:
	movem 1,(3)
	popj 17,

uhlres_global_array:
	move 3,1
	andi 3,17
	move 4,hlres_ubuf(3)
	hlrz 1,4
	jumpge 4,%L126
	hrro 1,1
%L126:
	movem 1,hlres_ubuf(3)
	popj 17,

uhlres_struct_a:
	move 3,1
	move 4,(1)
	hlrz 1,4
	jumpge 4,%L128
	hrro 1,1
%L128:
	movem 1,(3)
	popj 17,

uhlres_global_struct_a:
	move 4,hlres_ugp
	hlrz 1,4
	jumpge 4,%L130
	hrro 1,1
%L130:
	movem 1,hlres_ugp
	popj 17,

uhlres_add:
	move 3,1
	move 4,(1)
	hlrz 1,4
	jumpge 4,%L132
	hrro 1,1
%L132:
	movem 1,(3)
	add 1,2
	popj 17,

uhlres_bool:
	move 3,1
	move 4,(1)
	hlrz 1,4
	jumpge 4,%L134
	hrro 1,1
%L134:
	movem 1,(3)
	skipe 1
	movei 1,1
	popj 17,

uhlres_right_bits:
	move 3,1
	move 4,(1)
	hlrz 1,4
	jumpge 4,%L136
	hrro 1,1
%L136:
	movem 1,(3)
	hrrz 1,1
	popj 17,

uhlres_ext_bits:
	move 3,1
	move 4,(1)
	hlrz 1,4
	jumpge 4,%L138
	hrro 1,1
%L138:
	movem 1,(3)
	hllz 1,1
	popj 17,

hlres_sqi_temp:
	move 4,1
	lsh 2,33
	ash 2,-33
	hrlz 2,2
	movem 2,(1)
	hlrz 1,2
	jumpge 2,%L140
	hrro 1,1
%L140:
	movem 1,(4)
	popj 17,

hlres_uqi_temp:
	andi 2,777	; zero_extendqisi2
	hrlz 2,2
	hlrz 2,2
	movem 2,(1)
	move 1,2
	popj 17,

hlres_hi_temp:
	move 4,1
	hrlz 2,2
	movem 2,(1)
	hlrz 1,2
	jumpge 2,%L144
	hrro 1,1
%L144:
	movem 1,(4)
	popj 17,

hlres_uhi_temp:
	move 4,1
	hrlz 2,2
	movem 2,(1)
	hlrz 1,2
	jumpge 2,%L146
	hrro 1,1
%L146:
	movem 1,(4)
	popj 17,

	.bss
hlres_ga:
	.space	4
hlres_gb:
	.space	4
hlres_uga:
	.space	4
hlres_vga:
	.space	4
hlres_buf:
	.space	64
hlres_ubuf:
	.space	64
hlres_gp:
	.space	8
hlres_ugp:
	.space	8
