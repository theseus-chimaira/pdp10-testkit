
tdnn_clear:
	movei 4,0
	tdne 1,2
	move 4,1
	move 1,4
	popj 17,

tdnn_select:
	tdne 1,2
	move 3,4
	move 1,3
	popj 17,

tdnn_select_add:
	move 6,1
	move 1,3
	add 1,6
	tdnn 6,2
	popj 17,
	move 1,4
	add 1,6
	popj 17,

tdnn_call:
	tdne 1,2
	popj 17,
	jrst f

tdnn_call_add:
	push 17,10
	move 10,1
	tdnn 1,2
	jrst %L12
%L11:
	move 1,10
	pop 17,10
	popj 17,
%L12:
	pushj 17,f
	add 10,1
	jrst %L11

tdnn_likely:
	movei 4,0
	tdne 1,2
	jrst %L15
%L13:
	move 1,4
	popj 17,
%L15:
	move 4,1
	jrst %L13

tdnn_unlikely:
	movei 4,0
	tdne 1,2
	move 4,1
	move 1,4
	popj 17,

tdnn_literal_a:
	movei 4,0
	tdne 1,[123456123456]
	move 4,1
	move 1,4
	popj 17,

tdnn_literal_b:
	movei 4,0
	tdne 1,[-252525525253]
	move 4,1
	move 1,4
	popj 17,

tdnn_literal_sparse:
	movei 4,0
	tdne 1,[-70707707071]
	move 4,1
	move 1,4
	popj 17,

tdnn_literal_left:
	movei 4,0
	tlne 1,123456
	move 4,1
	move 1,4
	popj 17,

tdnn_literal_right:
	movei 4,0
	trne 1,123456
	move 4,1
	move 1,4
	popj 17,

tdnn_literal_signbit:
	caile 1,0
	movei 1,0
	popj 17,

tdnn_literal_all:
	movei 4,0
	jumpe 1,%L30
	move 4,1
%L30:
	move 1,4
	popj 17,

tdnn_mem:
	movei 4,0
	tdne 1,(2)
	move 4,1
	move 1,4
	popj 17,

tdnn_mem_select:
	tdne 1,(2)
	move 3,4
	move 1,3
	popj 17,

tdnn_mem_call:
	tdne 1,(2)
	popj 17,
	jrst f

tdnn_global:
	movei 4,0
	tdne 1,tdnn_ga
	move 4,1
	move 1,4
	popj 17,

tdnn_global_global:
	move 4,tdnn_ga
	movei 1,0
	tdne 4,tdnn_gb
	move 1,4
	popj 17,

tdnn_volatile_global:
	move 4,tdnn_vga
	movei 3,0
	tdne 1,4
	move 3,1
	move 1,3
	popj 17,

tdnn_array:
	andi 3,17
	add 2,3
	movei 4,0
	tdne 1,(2)
	move 4,1
	move 1,4
	popj 17,

tdnn_global_array:
	andi 2,17
	movei 4,0
	tdne 1,tdnn_buf(2)
	move 4,1
	move 1,4
	popj 17,

tdnn_array_array:
	andi 2,17
	add 2,1
	move 2,(2)
	andi 3,17
	add 3,1
	movei 1,0
	tdne 2,(3)
	move 1,2
	popj 17,

tdnn_struct_a:
	movei 4,0
	tdne 1,(2)
	move 4,1
	move 1,4
	popj 17,

tdnn_struct_b:
	movei 4,0
	tdne 1,1(2)
	move 4,1
	move 1,4
	popj 17,

tdnn_global_struct_a:
	movei 4,0
	tdne 1,tdnn_gp
	move 4,1
	move 1,4
	popj 17,

tdnn_global_struct_b:
	movei 4,0
	tdne 1,tdnn_gp+1
	move 4,1
	move 1,4
	popj 17,

tdnn_struct_struct:
	move 4,(1)
	movei 3,0
	tdne 4,1(1)
	move 3,4
	move 1,3
	popj 17,

tdnn_indirect:
	movei 4,0
	tdne 1,@(2)
	move 4,1
	move 1,4
	popj 17,

tdnn_volatile:
	move 4,(2)
	movei 3,0
	tdne 1,4
	move 3,1
	move 1,3
	popj 17,

tdnn_volatile_volatile:
	move 1,(1)
	move 4,(2)
	movei 3,0
	tdne 1,4
	move 3,1
	move 1,3
	popj 17,

tdnn_bool:
	and 1,2
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

tdnn_bool_not:
	and 1,2
	skipe 1
	movei 1,1
	popj 17,

tdnn_bool_mem:
	and 1,(2)
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

tdnn_bool_global:
	and 1,tdnn_ga
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

tdnn_bool_literal:
	and 1,[123456123456]
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

tdnn_bool_left_literal:
	and 1,[123456000000]
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

tdnn_bool_right_literal:
	andi 1,123456
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

tdnn_bool_signbit:
	skipge 1
	tdza 1,1
	movei 1,1
	popj 17,

tdnn_bool_add:
	and 1,2
	skipe 1
	tdza 1,1
	movei 1,1
	add 1,3
	popj 17,

tdnn_bool_or:
	and 1,2
	skipe 1
	tdza 1,1
	movei 1,1
	ior 1,3
	popj 17,

tdnn_bool_xor:
	and 1,2
	skipe 1
	tdza 1,1
	movei 1,1
	xor 1,3
	popj 17,

tdnn_bool_mul:
	tdne 1,2
	movei 3,0
	move 1,3
	popj 17,

tdnn_value_select:
	and 1,2
	jumpe 1,%L84
	move 3,4
	add 3,1
%L84:
	move 1,3
	popj 17,

tdnn_value_call:
	tdne 1,2
%L86:
	popj 17,
	pushj 17,f
	popj 17,

tdnn_value_mem:
	move 4,1
	and 4,(2)
	movei 3,0
	jumpe 4,%L89
	move 3,4
	add 3,1
%L89:
	move 1,3
	popj 17,

tdnn_sources_live:
	tdne 1,2
	jrst %L92
	add 1,2
	add 1,3
%L91:
	popj 17,
%L92:
	move 1,3
	popj 17,

tdnn_memory_sources_live:
	move 4,(1)
	move 1,(2)
	tdne 4,1
	jrst %L94
	add 1,4
	add 1,3
%L93:
	popj 17,
%L94:
	move 1,3
	popj 17,

tdnn_nested:
	tdne 1,2
	jrst %L96
	skipe 3
	tdza 1,1
	movei 1,1
	addi 1,1
%L95:
	popj 17,
%L96:
	movei 1,3
	popj 17,

tdnn_else_if:
	movei 4,1
	tdnn 1,2
	jrst %L98
	skipe 3
	tdza 4,4
	movei 4,1
	addi 4,2
%L98:
	move 1,4
	popj 17,

tdnn_loop_break:
	move 4,3
	subi 3,1
	jumple 4,%L109
%L107:
	move 4,3
	tdnn 1,2
	jrst %L102
	addi 1,1
	subi 3,1
	jumpg 4,%L107
%L109:
	move 4,1
%L102:
	move 1,4
	popj 17,

tdnn_loop_count:
	movei 6,0
	move 4,3
	subi 3,1
	jumple 4,%L117
%L115:
	tdnn 1,2
	addi 6,1
	addi 1,1
	move 4,3
	subi 3,1
	jumpg 4,%L115
%L117:
	move 1,6
	popj 17,

tdnn_loop_memory:
	move 2,(2)
	move 4,3
	subi 3,1
	jumple 4,%L118
%L123:
	tdnn 1,2
	popj 17,
	addi 1,1
	move 4,3
	subi 3,1
	jumpg 4,%L123
%L118:
	popj 17,

utdnn_clear:
	movei 4,0
	tdne 1,2
	move 4,1
	move 1,4
	popj 17,

utdnn_select:
	tdne 1,2
	move 3,4
	move 1,3
	popj 17,

utdnn_mem:
	movei 4,0
	tdne 1,(2)
	move 4,1
	move 1,4
	popj 17,

utdnn_global:
	movei 4,0
	tdne 1,tdnn_uga
	move 4,1
	move 1,4
	popj 17,

utdnn_array:
	andi 3,17
	add 2,3
	movei 4,0
	tdne 1,(2)
	move 4,1
	move 1,4
	popj 17,

utdnn_global_array:
	andi 2,17
	movei 4,0
	tdne 1,tdnn_ubuf(2)
	move 4,1
	move 1,4
	popj 17,

utdnn_struct_a:
	movei 4,0
	tdne 1,(2)
	move 4,1
	move 1,4
	popj 17,

utdnn_global_struct_a:
	movei 4,0
	tdne 1,tdnn_ugp
	move 4,1
	move 1,4
	popj 17,

utdnn_bool:
	and 1,2
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

utdnn_bool_mem:
	and 1,(2)
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

utdnn_bool_literal:
	and 1,[123456123456]
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

utdnn_call_add:
	push 17,10
	move 10,1
	tdnn 1,2
	jrst %L148
%L147:
	move 1,10
	pop 17,10
	popj 17,
%L148:
	pushj 17,f
	add 10,1
	jrst %L147

tdnn_sqi:
	lsh 1,33
	ash 1,-33
	movei 4,0
	tdne 1,2
	move 4,1
	move 1,4
	popj 17,

tdnn_uqi:
	andi 1,777	; zero_extendqisi2
	movei 4,0
	tdne 1,2
	move 4,1
	move 1,4
	popj 17,

tdnn_hi:
	hrre 1,1
	movei 4,0
	tdne 1,2
	move 4,1
	move 1,4
	popj 17,

tdnn_uhi:
	hrrzi 1,(1)	; zero_extendhisi2
	movei 4,0
	tdne 1,2
	move 4,1
	move 1,4
	popj 17,

tdnn_sqi_sqi:
	andi 1,777	; zero_extendqisi2
	movei 4,0
	tdnn 2,1
	jrst %L157
	move 4,1
	lsh 4,33
	ash 4,-33
%L157:
	move 1,4
	popj 17,

tdnn_uqi_uqi:
	andi 1,777	; zero_extendqisi2
	andi 2,777	; zero_extendqisi2
	movei 4,0
	tdne 1,2
	move 4,1
	move 1,4
	popj 17,

tdnn_hi_hi:
	hrrzi 1,(1)	; zero_extendhisi2
	move 4,1
	andi 4,(2)
	movei 3,0
	jumpe 4,%L161
	hrre 3,1	; extendhisi2
%L161:
	move 1,3
	popj 17,

tdnn_uhi_uhi:
	hrrzi 1,(1)	; zero_extendhisi2
	move 4,1
	andi 4,(2)
	movei 3,0
	jumpe 4,%L163
	move 3,1
%L163:
	move 1,3
	popj 17,

tdnn_sqi_bool:
	lsh 1,33
	ash 1,-33
	and 1,2
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

tdnn_uqi_bool:
	andi 1,777	; zero_extendqisi2
	and 1,2
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

tdnn_hi_bool:
	hrre 1,1
	and 1,2
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

tdnn_uhi_bool:
	andi 2,(1)
	skipe 2
	tdza 2,2
	movei 2,1
	move 1,2
	popj 17,

	.bss
tdnn_ga:
	.space	4
tdnn_gb:
	.space	4
tdnn_uga:
	.space	4
tdnn_vga:
	.space	4
tdnn_buf:
	.space	64
tdnn_ubuf:
	.space	64
tdnn_gp:
	.space	8
tdnn_ugp:
	.space	8
