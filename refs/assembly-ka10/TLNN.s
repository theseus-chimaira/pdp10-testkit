
tlnn_clear:
	movei 4,0
	tlne 1,123456
	move 4,1
	move 1,4
	popj 17,

tlnn_select:
	tlne 1,123456
	move 2,3
	move 1,2
	popj 17,

tlnn_select_add:
	add 2,1
	tlnn 1,123456
	jrst %L5
	move 2,3
	add 2,1
%L5:
	move 1,2
	popj 17,

tlnn_call:
	tlne 1,123456
	popj 17,
	jrst f

tlnn_call_add:
	push 17,10
	move 10,1
	tlnn 1,123456
	jrst %L12
%L11:
	move 1,10
	pop 17,10
	popj 17,
%L12:
	pushj 17,f
	add 10,1
	jrst %L11

tlnn_likely:
	movei 4,0
	tlne 1,123456
	jrst %L15
%L13:
	move 1,4
	popj 17,
%L15:
	move 4,1
	jrst %L13

tlnn_unlikely:
	movei 4,0
	tlne 1,123456
	move 4,1
	move 1,4
	popj 17,

tlnn_one:
	movei 4,0
	tlne 1,1
	move 4,1
	move 1,4
	popj 17,

tlnn_lowbits:
	movei 4,0
	tlne 1,7777
	move 4,1
	move 1,4
	popj 17,

tlnn_signbit:
	caile 1,0
	movei 1,0
	popj 17,

tlnn_all_left:
	movei 4,0
	tlne 1,777777
	move 4,1
	move 1,4
	popj 17,

tlnn_alt1:
	movei 4,0
	tlne 1,525252
	move 4,1
	move 1,4
	popj 17,

tlnn_alt2:
	movei 4,0
	tlne 1,252525
	move 4,1
	move 1,4
	popj 17,

tlnn_sparse:
	movei 4,0
	tlne 1,707070
	move 4,1
	move 1,4
	popj 17,

tlnn_edge:
	movei 4,0
	tlne 1,400001
	move 4,1
	move 1,4
	popj 17,

tlnn_mem:
	move 1,(1)
	movei 4,0
	tlne 1,123456
	move 4,1
	move 1,4
	popj 17,

tlnn_mem_select:
	move 4,(1)
	and 4,[123456000000]
	move 1,2
	jumpe 4,%L36
	move 1,3
%L36:
	popj 17,

tlnn_mem_call:
	move 1,(1)
	tlne 1,123456
	popj 17,
	jrst f

tlnn_global:
	move 4,tlnn_ga
	movei 1,0
	tlne 4,123456
	move 1,4
	popj 17,

tlnn_volatile_global:
	move 4,tlnn_vga
	movei 1,0
	tlne 4,123456
	move 1,4
	popj 17,

tlnn_array:
	andi 2,17
	add 1,2
	move 1,(1)
	movei 4,0
	tlne 1,123456
	move 4,1
	move 1,4
	popj 17,

tlnn_global_array:
	andi 1,17
	move 4,tlnn_buf(1)
	movei 1,0
	tlne 4,123456
	move 1,4
	popj 17,

tlnn_struct_a:
	move 1,(1)
	movei 4,0
	tlne 1,123456
	move 4,1
	move 1,4
	popj 17,

tlnn_struct_b:
	move 4,1(1)
	movei 1,0
	tlne 4,525252
	move 1,4
	popj 17,

tlnn_global_struct_a:
	move 4,tlnn_gp
	movei 1,0
	tlne 4,123456
	move 1,4
	popj 17,

tlnn_global_struct_b:
	move 4,tlnn_gp+1
	movei 1,0
	tlne 4,525252
	move 1,4
	popj 17,

tlnn_indirect:
	move 4,@(1)
	movei 1,0
	tlne 4,123456
	move 1,4
	popj 17,

tlnn_volatile:
	move 1,(1)
	movei 4,0
	tlne 1,123456
	move 4,1
	move 1,4
	popj 17,

tlnn_bool:
	and 1,[123456000000]
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

tlnn_bool_not:
	and 1,[123456000000]
	skipe 1
	movei 1,1
	popj 17,

tlnn_bool_one:
	hlrz 1,1
	andcai 1,1
	popj 17,

tlnn_bool_signbit:
	skipge 1
	tdza 1,1
	movei 1,1
	popj 17,

tlnn_bool_all_left:
	hllz 1,1
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

tlnn_bool_mem:
	move 1,(1)
	and 1,[123456000000]
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

tlnn_bool_global:
	move 1,tlnn_ga
	and 1,[123456000000]
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

tlnn_bool_volatile:
	move 1,(1)
	and 1,[123456000000]
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

tlnn_bool_add:
	and 1,[123456000000]
	skipe 1
	tdza 1,1
	movei 1,1
	add 1,2
	popj 17,

tlnn_bool_or:
	and 1,[123456000000]
	skipe 1
	tdza 1,1
	movei 1,1
	ior 1,2
	popj 17,

tlnn_bool_xor:
	and 1,[123456000000]
	skipe 1
	tdza 1,1
	movei 1,1
	xor 1,2
	popj 17,

tlnn_bool_mul:
	tlne 1,123456
	movei 2,0
	move 1,2
	popj 17,

tlnn_value_select:
	and 1,[123456000000]
	jumpe 1,%L76
	move 2,3
	add 2,1
%L76:
	move 1,2
	popj 17,

tlnn_value_call:
	tlne 1,123456
%L78:
	popj 17,
	pushj 17,f
	popj 17,

tlnn_value_mem:
	move 1,(1)
	move 4,1
	and 4,[123456000000]
	movei 3,0
	jumpe 4,%L81
	move 3,4
	add 3,1
%L81:
	move 1,3
	popj 17,

tlnn_source_live:
	move 4,1
	add 4,2
	tlne 1,123456
	move 4,2
	move 1,4
	popj 17,

tlnn_memory_source_live:
	move 4,(1)
	move 1,4
	add 1,2
	tlne 4,123456
	move 1,2
	popj 17,

tlnn_nested:
	tlne 1,123456
	jrst %L88
	skipe 2
	tdza 1,1
	movei 1,1
	addi 1,1
%L87:
	popj 17,
%L88:
	movei 1,3
	popj 17,

tlnn_else_if:
	movei 4,1
	tlnn 1,123456
	jrst %L90
	skipe 2
	tdza 4,4
	movei 4,1
	addi 4,2
%L90:
	move 1,4
	popj 17,

tlnn_loop_break:
	move 4,2
	subi 2,1
	jumple 4,%L101
%L99:
	move 4,2
	tlnn 1,123456
	jrst %L94
	addi 1,1
	subi 2,1
	jumpg 4,%L99
%L101:
	move 4,1
%L94:
	move 1,4
	popj 17,

tlnn_loop_count:
	movei 3,0
	move 4,2
	subi 2,1
	jumple 4,%L109
%L107:
	tlnn 1,123456
	addi 3,1
	addi 1,1
	move 4,2
	subi 2,1
	jumpg 4,%L107
%L109:
	move 1,3
	popj 17,

tlnn_loop_mask_change:
	move 4,2
	subi 2,1
	jumple 4,%L110
%L115:
	jumpge 1,%L110
	addi 1,100
	move 4,2
	subi 2,1
	jumpg 4,%L115
%L110:
	popj 17,

utlnn_clear:
	movei 4,0
	tlne 1,123456
	move 4,1
	move 1,4
	popj 17,

utlnn_select:
	tlne 1,123456
	move 2,3
	move 1,2
	popj 17,

utlnn_one:
	movei 4,0
	tlne 1,1
	move 4,1
	move 1,4
	popj 17,

utlnn_signbit:
	caile 1,0
	movei 1,0
	popj 17,

utlnn_all_left:
	movei 4,0
	tlne 1,777777
	move 4,1
	move 1,4
	popj 17,

utlnn_mem:
	move 1,(1)
	movei 4,0
	tlne 1,123456
	move 4,1
	move 1,4
	popj 17,

utlnn_global:
	move 4,tlnn_uga
	movei 1,0
	tlne 4,123456
	move 1,4
	popj 17,

utlnn_array:
	andi 2,17
	add 1,2
	move 1,(1)
	movei 4,0
	tlne 1,123456
	move 4,1
	move 1,4
	popj 17,

utlnn_global_array:
	andi 1,17
	move 4,tlnn_ubuf(1)
	movei 1,0
	tlne 4,123456
	move 1,4
	popj 17,

utlnn_struct_a:
	move 1,(1)
	movei 4,0
	tlne 1,123456
	move 4,1
	move 1,4
	popj 17,

utlnn_global_struct_a:
	move 4,tlnn_ugp
	movei 1,0
	tlne 4,123456
	move 1,4
	popj 17,

utlnn_bool:
	and 1,[123456000000]
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

utlnn_bool_mem:
	move 1,(1)
	and 1,[123456000000]
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

utlnn_bool_literal:
	and 1,[-252526000000]
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

utlnn_call_add:
	push 17,10
	move 10,1
	tlnn 1,123456
	jrst %L146
%L145:
	move 1,10
	pop 17,10
	popj 17,
%L146:
	pushj 17,f
	add 10,1
	jrst %L145

tlnn_sqi:
	lsh 1,33
	ash 1,-33
	movei 4,0
	tlne 1,123456
	move 4,1
	move 1,4
	popj 17,

tlnn_uqi:
	movei 1,0
	popj 17,

tlnn_hi:
	hrre 1,1
	movei 4,0
	tlne 1,123456
	move 4,1
	move 1,4
	popj 17,

tlnn_uhi:
	movei 1,0
	popj 17,

tlnn_sqi_bool:
	lsh 1,33
	ash 1,-33
	and 1,[123456000000]
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

tlnn_uqi_bool:
	movei 1,1
	popj 17,

tlnn_hi_bool:
	hrre 1,1
	and 1,[123456000000]
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

tlnn_uhi_bool:
	movei 1,1
	popj 17,

tlnn_sqi_signbit:
	lsh 1,33
	ash 1,-33
	caile 1,0
	movei 1,0
	popj 17,

tlnn_hi_all_left:
	hrre 1,1
	movei 4,0
	tlne 1,777777
	move 4,1
	move 1,4
	popj 17,

	.bss
tlnn_ga:
	.space	4
tlnn_uga:
	.space	4
tlnn_vga:
	.space	4
tlnn_buf:
	.space	64
tlnn_ubuf:
	.space	64
tlnn_gp:
	.space	8
tlnn_ugp:
	.space	8
