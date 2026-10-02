
trnn_clear:
	movei 4,0
	trne 1,123456
	move 4,1
	move 1,4
	popj 17,

trnn_select:
	trne 1,123456
	move 2,3
	move 1,2
	popj 17,

trnn_select_add:
	add 2,1
	trnn 1,123456
	jrst %L5
	move 2,3
	add 2,1
%L5:
	move 1,2
	popj 17,

trnn_call:
	trne 1,123456
	popj 17,
	jrst f

trnn_call_add:
	push 17,10
	move 10,1
	trnn 1,123456
	jrst %L12
%L11:
	move 1,10
	pop 17,10
	popj 17,
%L12:
	pushj 17,f
	add 10,1
	jrst %L11

trnn_likely:
	movei 4,0
	trne 1,123456
	jrst %L15
%L13:
	move 1,4
	popj 17,
%L15:
	move 4,1
	jrst %L13

trnn_unlikely:
	movei 4,0
	trne 1,123456
	move 4,1
	move 1,4
	popj 17,

trnn_one:
	movei 4,0
	trne 1,1
	move 4,1
	move 1,4
	popj 17,

trnn_lowbits:
	movei 4,0
	trne 1,7777
	move 4,1
	move 1,4
	popj 17,

trnn_highbit:
	movei 4,0
	trne 1,400000
	move 4,1
	move 1,4
	popj 17,

trnn_all_right:
	hrrz 4,1
	movei 3,0
	jumpe 4,%L24
	move 3,1
%L24:
	move 1,3
	popj 17,

trnn_alt1:
	movei 4,0
	trne 1,525252
	move 4,1
	move 1,4
	popj 17,

trnn_alt2:
	movei 4,0
	trne 1,252525
	move 4,1
	move 1,4
	popj 17,

trnn_sparse:
	movei 4,0
	trne 1,707070
	move 4,1
	move 1,4
	popj 17,

trnn_edge:
	movei 4,0
	trne 1,400001
	move 4,1
	move 1,4
	popj 17,

trnn_mem:
	move 1,(1)
	movei 4,0
	trne 1,123456
	move 4,1
	move 1,4
	popj 17,

trnn_mem_select:
	move 4,(1)
	andi 4,123456
	move 1,2
	jumpe 4,%L36
	move 1,3
%L36:
	popj 17,

trnn_mem_call:
	move 1,(1)
	trne 1,123456
	popj 17,
	jrst f

trnn_global:
	move 4,trnn_ga
	movei 1,0
	trne 4,123456
	move 1,4
	popj 17,

trnn_volatile_global:
	move 4,trnn_vga
	movei 1,0
	trne 4,123456
	move 1,4
	popj 17,

trnn_array:
	andi 2,17
	add 1,2
	move 1,(1)
	movei 4,0
	trne 1,123456
	move 4,1
	move 1,4
	popj 17,

trnn_global_array:
	andi 1,17
	move 4,trnn_buf(1)
	movei 1,0
	trne 4,123456
	move 1,4
	popj 17,

trnn_struct_a:
	move 1,(1)
	movei 4,0
	trne 1,123456
	move 4,1
	move 1,4
	popj 17,

trnn_struct_b:
	move 4,1(1)
	movei 1,0
	trne 4,525252
	move 1,4
	popj 17,

trnn_global_struct_a:
	move 4,trnn_gp
	movei 1,0
	trne 4,123456
	move 1,4
	popj 17,

trnn_global_struct_b:
	move 4,trnn_gp+1
	movei 1,0
	trne 4,525252
	move 1,4
	popj 17,

trnn_indirect:
	move 4,@(1)
	movei 1,0
	trne 4,123456
	move 1,4
	popj 17,

trnn_volatile:
	move 1,(1)
	movei 4,0
	trne 1,123456
	move 4,1
	move 1,4
	popj 17,

trnn_bool:
	andi 1,123456
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

trnn_bool_not:
	andi 1,123456
	skipe 1
	movei 1,1
	popj 17,

trnn_bool_one:
	andcai 1,1
	popj 17,

trnn_bool_highbit:
	lsh 1,-21
	andcai 1,1
	popj 17,

trnn_bool_all_right:
	hrrz 1,1
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

trnn_bool_mem:
	move 1,(1)
	andi 1,123456
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

trnn_bool_global:
	move 1,trnn_ga
	andi 1,123456
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

trnn_bool_volatile:
	move 1,(1)
	andi 1,123456
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

trnn_bool_add:
	andi 1,123456
	skipe 1
	tdza 1,1
	movei 1,1
	add 1,2
	popj 17,

trnn_bool_or:
	andi 1,123456
	skipe 1
	tdza 1,1
	movei 1,1
	ior 1,2
	popj 17,

trnn_bool_xor:
	andi 1,123456
	skipe 1
	tdza 1,1
	movei 1,1
	xor 1,2
	popj 17,

trnn_bool_mul:
	trne 1,123456
	movei 2,0
	move 1,2
	popj 17,

trnn_value_select:
	andi 1,123456
	jumpe 1,%L76
	move 2,3
	add 2,1
%L76:
	move 1,2
	popj 17,

trnn_value_call:
	trne 1,123456
%L78:
	popj 17,
	pushj 17,f
	popj 17,

trnn_value_mem:
	move 1,(1)
	move 4,1
	andi 4,123456
	movei 3,0
	jumpe 4,%L81
	move 3,4
	add 3,1
%L81:
	move 1,3
	popj 17,

trnn_source_live:
	move 4,1
	add 4,2
	trne 1,123456
	move 4,2
	move 1,4
	popj 17,

trnn_memory_source_live:
	move 4,(1)
	move 1,4
	add 1,2
	trne 4,123456
	move 1,2
	popj 17,

trnn_nested:
	trne 1,123456
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

trnn_else_if:
	movei 4,1
	trnn 1,123456
	jrst %L90
	skipe 2
	tdza 4,4
	movei 4,1
	addi 4,2
%L90:
	move 1,4
	popj 17,

trnn_loop_break:
	move 4,2
	subi 2,1
	jumple 4,%L101
%L99:
	move 4,2
	trnn 1,123456
	jrst %L94
	addi 1,1
	subi 2,1
	jumpg 4,%L99
%L101:
	move 4,1
%L94:
	move 1,4
	popj 17,

trnn_loop_count:
	movei 3,0
	move 4,2
	subi 2,1
	jumple 4,%L109
%L107:
	trnn 1,123456
	addi 3,1
	addi 1,1
	move 4,2
	subi 2,1
	jumpg 4,%L107
%L109:
	move 1,3
	popj 17,

trnn_loop_mask_change:
	move 4,2
	subi 2,1
	jumple 4,%L110
%L115:
	trnn 1,400000
	popj 17,
	addi 1,100
	move 4,2
	subi 2,1
	jumpg 4,%L115
%L110:
	popj 17,

utrnn_clear:
	movei 4,0
	trne 1,123456
	move 4,1
	move 1,4
	popj 17,

utrnn_select:
	trne 1,123456
	move 2,3
	move 1,2
	popj 17,

utrnn_one:
	movei 4,0
	trne 1,1
	move 4,1
	move 1,4
	popj 17,

utrnn_highbit:
	movei 4,0
	trne 1,400000
	move 4,1
	move 1,4
	popj 17,

utrnn_all_right:
	hrrz 4,1
	movei 3,0
	jumpe 4,%L126
	move 3,1
%L126:
	move 1,3
	popj 17,

utrnn_mem:
	move 1,(1)
	movei 4,0
	trne 1,123456
	move 4,1
	move 1,4
	popj 17,

utrnn_global:
	move 4,trnn_uga
	movei 1,0
	trne 4,123456
	move 1,4
	popj 17,

utrnn_array:
	andi 2,17
	add 1,2
	move 1,(1)
	movei 4,0
	trne 1,123456
	move 4,1
	move 1,4
	popj 17,

utrnn_global_array:
	andi 1,17
	move 4,trnn_ubuf(1)
	movei 1,0
	trne 4,123456
	move 1,4
	popj 17,

utrnn_struct_a:
	move 1,(1)
	movei 4,0
	trne 1,123456
	move 4,1
	move 1,4
	popj 17,

utrnn_global_struct_a:
	move 4,trnn_ugp
	movei 1,0
	trne 4,123456
	move 1,4
	popj 17,

utrnn_bool:
	andi 1,123456
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

utrnn_bool_mem:
	move 1,(1)
	andi 1,123456
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

utrnn_bool_literal:
	andi 1,525252
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

utrnn_call_add:
	push 17,10
	move 10,1
	trnn 1,123456
	jrst %L146
%L145:
	move 1,10
	pop 17,10
	popj 17,
%L146:
	pushj 17,f
	add 10,1
	jrst %L145

trnn_sqi:
	lsh 1,33
	ash 1,-33
	movei 4,0
	trne 1,123456
	move 4,1
	move 1,4
	popj 17,

trnn_uqi:
	andi 1,777	; zero_extendqisi2
	movei 4,0
	trne 1,456
	move 4,1
	move 1,4
	popj 17,

trnn_hi:
	hrrzi 1,(1)	; zero_extendhisi2
	movei 4,0
	trne 1,123456
	hrre 4,1	; extendhisi2
	move 1,4
	popj 17,

trnn_uhi:
	hrrzi 1,(1)	; zero_extendhisi2
	movei 4,0
	trne 1,123456
	move 4,1
	move 1,4
	popj 17,

trnn_sqi_bool:
	lsh 1,33
	ash 1,-33
	andi 1,123456
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

trnn_uqi_bool:
	andi 1,456
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

trnn_hi_bool:
	andi 1,123456
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

trnn_uhi_bool:
	andi 1,123456
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

trnn_sqi_highbit:
	lsh 1,33
	ash 1,-33
	caile 1,0
	movei 1,0
	popj 17,

trnn_hi_all_right:
	hrre 1,1
	hrrz 4,1
	movei 3,0
	jumpe 4,%L161
	move 3,1
%L161:
	move 1,3
	popj 17,

	.bss
trnn_ga:
	.space	4
trnn_uga:
	.space	4
trnn_vga:
	.space	4
trnn_buf:
	.space	64
trnn_ubuf:
	.space	64
trnn_gp:
	.space	8
trnn_ugp:
	.space	8
