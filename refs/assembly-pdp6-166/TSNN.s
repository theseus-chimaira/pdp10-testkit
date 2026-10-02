
tsnn_clear:
	hlre 4,2
	tlo 4,(2)
	movei 3,0
	tdne 1,4
	move 3,1
	move 1,3
	popj 17,

tsnn_select:
	move 6,4
	hlre 4,2
	tlo 4,(2)
	tdne 1,4
	move 3,6
	move 1,3
	popj 17,

tsnn_select_add:
	move 6,1
	move 1,3
	move 3,4
	hlre 4,2
	tlo 4,(2)
	add 1,6
	tdnn 6,4
	popj 17,
	move 1,3
	add 1,6
	popj 17,

tsnn_call:
	hlre 4,2
	tlo 4,(2)
	tdne 1,4
	popj 17,
	jrst f

tsnn_call_add:
	push 17,10
	move 10,1
	hlre 4,2
	tlo 4,(2)
	tdnn 1,4
	jrst %L12
%L11:
	move 1,10
	pop 17,10
	popj 17,
%L12:
	pushj 17,f
	add 10,1
	jrst %L11

tsnn_likely:
	hlre 4,2
	tlo 4,(2)
	movei 3,0
	tdne 1,4
	jrst %L15
%L13:
	move 1,3
	popj 17,
%L15:
	move 3,1
	jrst %L13

tsnn_unlikely:
	hlre 4,2
	tlo 4,(2)
	movei 3,0
	tdne 1,4
	move 3,1
	move 1,3
	popj 17,

tsnn_literal_a:
	movei 4,0
	tdne 1,[123456123456]
	move 4,1
	move 1,4
	popj 17,

tsnn_literal_b:
	movei 4,0
	tdne 1,[252525525252]
	move 4,1
	move 1,4
	popj 17,

tsnn_literal_sparse:
	movei 4,0
	tdne 1,[70707707070]
	move 4,1
	move 1,4
	popj 17,

tsnn_literal_left:
	movei 4,0
	trne 1,123456
	move 4,1
	move 1,4
	popj 17,

tsnn_literal_right:
	movei 4,0
	tlne 1,123456
	move 4,1
	move 1,4
	popj 17,

tsnn_literal_signbit:
	movei 4,0
	trne 1,400000
	move 4,1
	move 1,4
	popj 17,

tsnn_literal_all:
	movei 4,0
	jumpe 1,%L30
	move 4,1
%L30:
	move 1,4
	popj 17,

tsnn_mem:
	move 3,(2)
	hlre 4,3
	tlo 4,(3)
	movei 3,0
	tdne 1,4
	move 3,1
	move 1,3
	popj 17,

tsnn_mem_select:
	move 6,4
	move 2,(2)
	hlre 4,2
	tlo 4,(2)
	tdne 1,4
	move 3,6
	move 1,3
	popj 17,

tsnn_mem_call:
	move 3,(2)
	hlre 4,3
	tlo 4,(3)
	tdne 1,4
	popj 17,
	jrst f

tsnn_global:
	move 3,tsnn_ga
	hlre 4,3
	tlo 4,(3)
	movei 3,0
	tdne 1,4
	move 3,1
	move 1,3
	popj 17,

tsnn_global_global:
	move 4,tsnn_gb
	hlre 3,4
	tlo 3,(4)
	move 4,tsnn_ga
	movei 1,0
	tdne 4,3
	move 1,4
	popj 17,

tsnn_volatile_global:
	move 3,tsnn_vga
	hlre 4,3
	tlo 4,(3)
	movei 3,0
	tdne 1,4
	move 3,1
	move 1,3
	popj 17,

tsnn_array:
	move 6,1
	andi 3,17
	add 2,3
	move 3,(2)
	hlre 4,3
	tlo 4,(3)
	movei 1,0
	tdne 6,4
	move 1,6
	popj 17,

tsnn_global_array:
	move 6,1
	andi 2,17
	move 3,tsnn_buf(2)
	hlre 4,3
	tlo 4,(3)
	movei 1,0
	tdne 6,4
	move 1,6
	popj 17,

tsnn_array_array:
	andi 2,17
	add 2,1
	move 2,(2)
	andi 3,17
	add 1,3
	move 3,(1)
	hlre 4,3
	tlo 4,(3)
	movei 1,0
	tdne 2,4
	move 1,2
	popj 17,

tsnn_struct_a:
	move 3,(2)
	hlre 4,3
	tlo 4,(3)
	movei 3,0
	tdne 1,4
	move 3,1
	move 1,3
	popj 17,

tsnn_struct_b:
	move 3,1(2)
	hlre 4,3
	tlo 4,(3)
	movei 3,0
	tdne 1,4
	move 3,1
	move 1,3
	popj 17,

tsnn_global_struct_a:
	move 3,tsnn_gp
	hlre 4,3
	tlo 4,(3)
	movei 3,0
	tdne 1,4
	move 3,1
	move 1,3
	popj 17,

tsnn_global_struct_b:
	move 3,tsnn_gp+1
	hlre 4,3
	tlo 4,(3)
	movei 3,0
	tdne 1,4
	move 3,1
	move 1,3
	popj 17,

tsnn_struct_struct:
	move 4,1(1)
	hlre 3,4
	tlo 3,(4)
	move 1,(1)
	movei 4,0
	tdne 1,3
	move 4,1
	move 1,4
	popj 17,

tsnn_indirect:
	move 3,@(2)
	hlre 4,3
	tlo 4,(3)
	movei 3,0
	tdne 1,4
	move 3,1
	move 1,3
	popj 17,

tsnn_volatile:
	move 3,(2)
	hlre 4,3
	tlo 4,(3)
	movei 3,0
	tdne 1,4
	move 3,1
	move 1,3
	popj 17,

tsnn_volatile_volatile:
	move 1,(1)
	move 3,(2)
	hlre 4,3
	tlo 4,(3)
	movei 3,0
	tdne 1,4
	move 3,1
	move 1,3
	popj 17,

tsnn_bool:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	and 1,4
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

tsnn_bool_not:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	and 1,4
	skipe 1
	movei 1,1
	popj 17,

tsnn_bool_mem:
	move 3,1
	move 4,(2)
	hlre 1,4
	tlo 1,(4)
	and 1,3
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

tsnn_bool_global:
	move 3,tsnn_ga
	hlre 4,3
	tlo 4,(3)
	and 4,1
	skipe 4
	tdza 4,4
	movei 4,1
	move 1,4
	popj 17,

tsnn_bool_literal:
	and 1,[123456123456]
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

tsnn_bool_left_literal:
	andi 1,123456
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

tsnn_bool_right_literal:
	and 1,[123456000000]
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

tsnn_bool_signbit:
	lsh 1,-21
	andcai 1,1
	popj 17,

tsnn_bool_add:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	and 1,4
	skipe 1
	tdza 1,1
	movei 1,1
	add 1,3
	popj 17,

tsnn_bool_or:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	and 1,4
	skipe 1
	tdza 1,1
	movei 1,1
	ior 1,3
	popj 17,

tsnn_bool_xor:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	and 1,4
	skipe 1
	tdza 1,1
	movei 1,1
	xor 1,3
	popj 17,

tsnn_bool_mul:
	hlre 4,2
	tlo 4,(2)
	tdne 1,4
	movei 3,0
	move 1,3
	popj 17,

tsnn_value_select:
	move 6,4
	hlre 4,2
	tlo 4,(2)
	and 1,4
	jumpe 1,%L84
	move 3,6
	add 3,1
%L84:
	move 1,3
	popj 17,

tsnn_value_call:
	hlre 4,2
	tlo 4,(2)
	tdne 1,4
%L86:
	popj 17,
	pushj 17,f
	popj 17,

tsnn_value_mem:
	move 6,1
	move 4,(2)
	hlre 3,4
	tlo 3,(4)
	and 3,1
	movei 1,0
	jumpe 3,%L89
	move 1,3
	add 1,6
%L89:
	popj 17,

tsnn_sources_live:
	hlre 4,2
	tlo 4,(2)
	tdne 1,4
	jrst %L92
	add 1,2
	add 1,3
%L91:
	popj 17,
%L92:
	move 1,3
	popj 17,

tsnn_memory_sources_live:
	move 6,(1)
	move 1,(2)
	hlre 4,1
	tlo 4,(1)
	tdne 6,4
	jrst %L94
	add 1,6
	add 1,3
%L93:
	popj 17,
%L94:
	move 1,3
	popj 17,

tsnn_nested:
	hlre 4,2
	tlo 4,(2)
	tdne 1,4
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

tsnn_else_if:
	hlre 4,2
	tlo 4,(2)
	movei 2,1
	tdnn 1,4
	jrst %L98
	skipe 3
	tdza 2,2
	movei 2,1
	addi 2,2
%L98:
	move 1,2
	popj 17,

tsnn_loop_break:
	move 4,3
	subi 3,1
	jumple 4,%L109
	hlre 6,2
	tlo 6,(2)
%L107:
	move 4,3
	tdnn 1,6
	jrst %L102
	addi 1,1
	subi 3,1
	jumpg 4,%L107
%L109:
	move 4,1
%L102:
	move 1,4
	popj 17,

tsnn_loop_count:
	movei 7,0
	move 4,3
	subi 3,1
	jumple 4,%L117
	hlre 6,2
	tlo 6,(2)
%L115:
	tdnn 1,6
	addi 7,1
	addi 1,1
	move 4,3
	subi 3,1
	jumpg 4,%L115
%L117:
	move 1,7
	popj 17,

tsnn_loop_memory:
	move 2,(2)
	move 4,3
	subi 3,1
	jumple 4,%L118
	hlre 6,2
	tlo 6,(2)
%L123:
	tdnn 1,6
	popj 17,
	addi 1,1
	move 4,3
	subi 3,1
	jumpg 4,%L123
%L118:
	popj 17,

utsnn_clear:
	movs 2,2
	movei 4,0
	tdne 1,2
	move 4,1
	move 1,4
	popj 17,

utsnn_select:
	movs 2,2
	tdne 1,2
	move 3,4
	move 1,3
	popj 17,

utsnn_mem:
	movs 4,(2)
	movei 3,0
	tdne 1,4
	move 3,1
	move 1,3
	popj 17,

utsnn_global:
	movs 4,tsnn_uga
	movei 3,0
	tdne 1,4
	move 3,1
	move 1,3
	popj 17,

utsnn_array:
	move 6,1
	andi 3,17
	add 2,3
	movs 4,(2)
	movei 1,0
	tdne 6,4
	move 1,6
	popj 17,

utsnn_global_array:
	andi 2,17
	movs 4,tsnn_ubuf(2)
	movei 3,0
	tdne 1,4
	move 3,1
	move 1,3
	popj 17,

utsnn_struct_a:
	movs 4,(2)
	movei 3,0
	tdne 1,4
	move 3,1
	move 1,3
	popj 17,

utsnn_global_struct_a:
	movs 4,tsnn_ugp
	movei 3,0
	tdne 1,4
	move 3,1
	move 1,3
	popj 17,

utsnn_bool:
	movs 2,2
	and 2,1
	skipe 2
	tdza 2,2
	movei 2,1
	move 1,2
	popj 17,

utsnn_bool_mem:
	move 4,1
	movs 1,(2)
	and 1,4
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

utsnn_bool_literal:
	and 1,[123456123456]
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

utsnn_call_add:
	push 17,10
	move 10,1
	movs 2,2
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

tsnn_sqi:
	lsh 1,33
	ash 1,-33
	hlre 4,2
	tlo 4,(2)
	movei 3,0
	tdne 1,4
	move 3,1
	move 1,3
	popj 17,

tsnn_uqi:
	andi 1,777	; zero_extendqisi2
	hlre 4,2
	tlo 4,(2)
	movei 3,0
	tdne 1,4
	move 3,1
	move 1,3
	popj 17,

tsnn_hi:
	hrre 1,1
	hlre 4,2
	tlo 4,(2)
	movei 3,0
	tdne 1,4
	move 3,1
	move 1,3
	popj 17,

tsnn_uhi:
	hrrzi 1,(1)	; zero_extendhisi2
	hlre 4,2
	tlo 4,(2)
	movei 3,0
	tdne 1,4
	move 3,1
	move 1,3
	popj 17,

tsnn_sqi_sqi:
	lsh 1,33
	ash 1,-33
	lsh 2,33
	ash 2,-33
	hlre 4,2
	tlo 4,(2)
	movei 3,0
	tdne 1,4
	move 3,1
	move 1,3
	popj 17,

tsnn_uqi_uqi:
	movei 1,0
	popj 17,

tsnn_hi_hi:
	hrre 1,1
	move 4,2
	lsh 4,22
	ash 4,-43
	tlo 4,(2)
	movei 3,0
	tdne 1,4
	move 3,1
	move 1,3
	popj 17,

tsnn_uhi_uhi:
	movei 1,0
	popj 17,

tsnn_sqi_bool:
	lsh 1,33
	ash 1,-33
	hlre 4,2
	tlo 4,(2)
	and 1,4
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

tsnn_uqi_bool:
	andi 1,777	; zero_extendqisi2
	hlre 4,2
	tlo 4,(2)
	and 1,4
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

tsnn_hi_bool:
	hrre 1,1
	hlre 4,2
	tlo 4,(2)
	and 1,4
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

tsnn_uhi_bool:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	andi 1,(4)
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

	.bss
tsnn_ga:
	.space	4
tsnn_gb:
	.space	4
tsnn_uga:
	.space	4
tsnn_vga:
	.space	4
tsnn_buf:
	.space	64
tsnn_ubuf:
	.space	64
tsnn_gp:
	.space	8
tsnn_ugp:
	.space	8
