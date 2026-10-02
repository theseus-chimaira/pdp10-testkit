
tsne_clear:
	hlre 4,2
	tlo 4,(2)
	movei 3,0
	tdnn 1,4
	move 3,1
	move 1,3
	popj 17,

tsne_select:
	move 6,4
	hlre 4,2
	tlo 4,(2)
	tdnn 1,4
	move 3,6
	move 1,3
	popj 17,

tsne_select_add:
	move 6,1
	move 1,3
	move 3,4
	hlre 4,2
	tlo 4,(2)
	add 1,6
	tdne 6,4
	popj 17,
	move 1,3
	add 1,6
	popj 17,

tsne_call:
	hlre 4,2
	tlo 4,(2)
	tdnn 1,4
	popj 17,
	jrst f

tsne_call_add:
	push 17,10
	move 10,1
	hlre 4,2
	tlo 4,(2)
	tdne 1,4
	jrst %L12
%L11:
	move 1,10
	pop 17,10
	popj 17,
%L12:
	pushj 17,f
	add 10,1
	jrst %L11

tsne_likely:
	hlre 4,2
	tlo 4,(2)
	movei 3,0
	tdnn 1,4
	jrst %L15
%L13:
	move 1,3
	popj 17,
%L15:
	move 3,1
	jrst %L13

tsne_unlikely:
	hlre 4,2
	tlo 4,(2)
	movei 3,0
	tdnn 1,4
	move 3,1
	move 1,3
	popj 17,

tsne_literal_a:
	movei 4,0
	tdnn 1,[123456123456]
	move 4,1
	move 1,4
	popj 17,

tsne_literal_b:
	movei 4,0
	tdnn 1,[252525525252]
	move 4,1
	move 1,4
	popj 17,

tsne_literal_sparse:
	movei 4,0
	tdnn 1,[70707707070]
	move 4,1
	move 1,4
	popj 17,

tsne_literal_left:
	movei 4,0
	trnn 1,123456
	move 4,1
	move 1,4
	popj 17,

tsne_literal_right:
	movei 4,0
	tlnn 1,123456
	move 4,1
	move 1,4
	popj 17,

tsne_literal_signbit:
	movei 4,0
	trnn 1,400000
	move 4,1
	move 1,4
	popj 17,

tsne_literal_all:
	movei 1,0
	popj 17,

tsne_mem:
	move 3,(2)
	hlre 4,3
	tlo 4,(3)
	movei 3,0
	tdnn 1,4
	move 3,1
	move 1,3
	popj 17,

tsne_mem_select:
	move 6,4
	move 2,(2)
	hlre 4,2
	tlo 4,(2)
	tdnn 1,4
	move 3,6
	move 1,3
	popj 17,

tsne_mem_call:
	move 3,(2)
	hlre 4,3
	tlo 4,(3)
	tdnn 1,4
	popj 17,
	jrst f

tsne_global:
	move 3,tsne_ga
	hlre 4,3
	tlo 4,(3)
	movei 3,0
	tdnn 1,4
	move 3,1
	move 1,3
	popj 17,

tsne_global_global:
	move 4,tsne_gb
	hlre 3,4
	tlo 3,(4)
	move 4,tsne_ga
	movei 1,0
	tdnn 4,3
	move 1,4
	popj 17,

tsne_volatile_global:
	move 3,tsne_vga
	hlre 4,3
	tlo 4,(3)
	movei 3,0
	tdnn 1,4
	move 3,1
	move 1,3
	popj 17,

tsne_array:
	move 6,1
	andi 3,17
	add 2,3
	move 3,(2)
	hlre 4,3
	tlo 4,(3)
	movei 1,0
	tdnn 6,4
	move 1,6
	popj 17,

tsne_global_array:
	move 6,1
	andi 2,17
	move 3,tsne_buf(2)
	hlre 4,3
	tlo 4,(3)
	movei 1,0
	tdnn 6,4
	move 1,6
	popj 17,

tsne_array_array:
	andi 2,17
	add 2,1
	move 2,(2)
	andi 3,17
	add 1,3
	move 3,(1)
	hlre 4,3
	tlo 4,(3)
	movei 1,0
	tdnn 2,4
	move 1,2
	popj 17,

tsne_struct_a:
	move 3,(2)
	hlre 4,3
	tlo 4,(3)
	movei 3,0
	tdnn 1,4
	move 3,1
	move 1,3
	popj 17,

tsne_struct_b:
	move 3,1(2)
	hlre 4,3
	tlo 4,(3)
	movei 3,0
	tdnn 1,4
	move 3,1
	move 1,3
	popj 17,

tsne_global_struct_a:
	move 3,tsne_gp
	hlre 4,3
	tlo 4,(3)
	movei 3,0
	tdnn 1,4
	move 3,1
	move 1,3
	popj 17,

tsne_global_struct_b:
	move 3,tsne_gp+1
	hlre 4,3
	tlo 4,(3)
	movei 3,0
	tdnn 1,4
	move 3,1
	move 1,3
	popj 17,

tsne_struct_struct:
	move 4,1(1)
	hlre 3,4
	tlo 3,(4)
	move 1,(1)
	movei 4,0
	tdnn 1,3
	move 4,1
	move 1,4
	popj 17,

tsne_indirect:
	move 3,@(2)
	hlre 4,3
	tlo 4,(3)
	movei 3,0
	tdnn 1,4
	move 3,1
	move 1,3
	popj 17,

tsne_volatile:
	move 3,(2)
	hlre 4,3
	tlo 4,(3)
	movei 3,0
	tdnn 1,4
	move 3,1
	move 1,3
	popj 17,

tsne_volatile_volatile:
	move 1,(1)
	move 3,(2)
	hlre 4,3
	tlo 4,(3)
	movei 3,0
	tdnn 1,4
	move 3,1
	move 1,3
	popj 17,

tsne_bool:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	and 1,4
	skipe 1
	movei 1,1
	popj 17,

tsne_bool_not:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	and 1,4
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

tsne_bool_mem:
	move 3,1
	move 4,(2)
	hlre 1,4
	tlo 1,(4)
	and 1,3
	skipe 1
	movei 1,1
	popj 17,

tsne_bool_global:
	move 3,tsne_ga
	hlre 4,3
	tlo 4,(3)
	and 4,1
	skipe 4
	movei 4,1
	move 1,4
	popj 17,

tsne_bool_literal:
	and 1,[123456123456]
	skipe 1
	movei 1,1
	popj 17,

tsne_bool_add:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	and 1,4
	skipe 1
	movei 1,1
	add 1,3
	popj 17,

tsne_bool_or:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	and 1,4
	skipe 1
	movei 1,1
	ior 1,3
	popj 17,

tsne_bool_xor:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	and 1,4
	skipe 1
	movei 1,1
	xor 1,3
	popj 17,

tsne_value_select:
	move 6,4
	hlre 4,2
	tlo 4,(2)
	and 1,4
	add 3,1
	jumpn 1,%L78
	move 3,6
%L78:
	move 1,3
	popj 17,

tsne_value_call:
	push 17,10
	hlre 10,2
	tlo 10,(2)
	and 10,1
	jumpn 10,%L82
%L80:
	pop 17,10
	popj 17,
%L82:
	pushj 17,f
	add 1,10
	jrst %L80

tsne_value_mem:
	move 3,(2)
	hlre 4,3
	tlo 4,(3)
	movei 3,0
	tdnn 1,4
	move 3,1
	move 1,3
	popj 17,

tsne_sources_live:
	hlre 4,2
	tlo 4,(2)
	tdnn 1,4
	jrst %L86
	add 1,2
	add 1,3
%L85:
	popj 17,
%L86:
	move 1,3
	popj 17,

tsne_memory_sources_live:
	move 6,(1)
	move 1,(2)
	hlre 4,1
	tlo 4,(1)
	tdnn 6,4
	jrst %L88
	add 1,6
	add 1,3
%L87:
	popj 17,
%L88:
	move 1,3
	popj 17,

tsne_nested:
	hlre 4,2
	tlo 4,(2)
	tdnn 1,4
	jrst %L90
	skipe 3
	tdza 1,1
	movei 1,1
	addi 1,1
%L89:
	popj 17,
%L90:
	movei 1,3
	popj 17,

tsne_else_if:
	hlre 4,2
	tlo 4,(2)
	movei 2,1
	tdne 1,4
	jrst %L92
	skipe 3
	tdza 2,2
	movei 2,1
	addi 2,2
%L92:
	move 1,2
	popj 17,

tsne_loop_break:
	move 4,3
	subi 3,1
	jumple 4,%L103
	hlre 6,2
	tlo 6,(2)
%L101:
	move 4,3
	tdne 1,6
	jrst %L96
	addi 1,1
	subi 3,1
	jumpg 4,%L101
%L103:
	move 4,1
%L96:
	move 1,4
	popj 17,

tsne_loop_count:
	movei 7,0
	move 4,3
	subi 3,1
	jumple 4,%L111
	hlre 6,2
	tlo 6,(2)
%L109:
	tdne 1,6
	addi 7,1
	addi 1,1
	move 4,3
	subi 3,1
	jumpg 4,%L109
%L111:
	move 1,7
	popj 17,

utsne_clear:
	movs 2,2
	movei 4,0
	tdnn 1,2
	move 4,1
	move 1,4
	popj 17,

utsne_select:
	movs 2,2
	tdnn 1,2
	move 3,4
	move 1,3
	popj 17,

utsne_mem:
	movs 4,(2)
	movei 3,0
	tdnn 1,4
	move 3,1
	move 1,3
	popj 17,

utsne_global:
	movs 4,tsne_uga
	movei 3,0
	tdnn 1,4
	move 3,1
	move 1,3
	popj 17,

utsne_array:
	move 6,1
	andi 3,17
	add 2,3
	movs 4,(2)
	movei 1,0
	tdnn 6,4
	move 1,6
	popj 17,

utsne_global_array:
	andi 2,17
	movs 4,tsne_ubuf(2)
	movei 3,0
	tdnn 1,4
	move 3,1
	move 1,3
	popj 17,

utsne_struct_a:
	movs 4,(2)
	movei 3,0
	tdnn 1,4
	move 3,1
	move 1,3
	popj 17,

utsne_global_struct_a:
	movs 4,tsne_ugp
	movei 3,0
	tdnn 1,4
	move 3,1
	move 1,3
	popj 17,

utsne_bool:
	movs 2,2
	and 2,1
	skipe 2
	movei 2,1
	move 1,2
	popj 17,

utsne_bool_mem:
	move 4,1
	movs 1,(2)
	and 1,4
	skipe 1
	movei 1,1
	popj 17,

utsne_bool_literal:
	and 1,[123456123456]
	skipe 1
	movei 1,1
	popj 17,

utsne_call_add:
	push 17,10
	move 10,1
	movs 2,2
	tdne 1,2
	jrst %L134
%L133:
	move 1,10
	pop 17,10
	popj 17,
%L134:
	pushj 17,f
	add 10,1
	jrst %L133

tsne_sqi:
	lsh 1,33
	ash 1,-33
	hlre 4,2
	tlo 4,(2)
	movei 3,0
	tdnn 1,4
	move 3,1
	move 1,3
	popj 17,

tsne_uqi:
	andi 1,777	; zero_extendqisi2
	hlre 4,2
	tlo 4,(2)
	movei 3,0
	tdnn 1,4
	move 3,1
	move 1,3
	popj 17,

tsne_hi:
	hrre 1,1
	hlre 4,2
	tlo 4,(2)
	movei 3,0
	tdnn 1,4
	move 3,1
	move 1,3
	popj 17,

tsne_uhi:
	hrrzi 1,(1)	; zero_extendhisi2
	hlre 4,2
	tlo 4,(2)
	movei 3,0
	tdnn 1,4
	move 3,1
	move 1,3
	popj 17,

tsne_sqi_sqi:
	lsh 1,33
	ash 1,-33
	lsh 2,33
	ash 2,-33
	hlre 4,2
	tlo 4,(2)
	movei 3,0
	tdnn 1,4
	move 3,1
	move 1,3
	popj 17,

tsne_uqi_uqi:
	andi 1,777	; zero_extendqisi2
	popj 17,

tsne_hi_hi:
	hrre 1,1
	move 4,2
	lsh 4,22
	ash 4,-43
	tlo 4,(2)
	movei 3,0
	tdnn 1,4
	move 3,1
	move 1,3
	popj 17,

tsne_uhi_uhi:
	hrrzi 1,(1)	; zero_extendhisi2
	popj 17,

	.bss
tsne_ga:
	.space	4
tsne_gb:
	.space	4
tsne_uga:
	.space	4
tsne_vga:
	.space	4
tsne_buf:
	.space	64
tsne_ubuf:
	.space	64
tsne_gp:
	.space	8
tsne_ugp:
	.space	8
