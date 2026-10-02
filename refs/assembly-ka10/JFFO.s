
jffo_reg:
	setzb 4,5
	move 4,1
	jffo 4,%L2
	seto 1,
%L3:
	popj 17,
%L2:
	move 1,5
	popj 17,

jffo_mem:
	setzb 2,3
	move 4,(1)
	move 2,4
	jffo 2,%L5
	seto 1,
%L6:
	popj 17,
%L5:
	move 1,3
	popj 17,

jffo_volatile_mem:
	setzb 2,3
	move 4,(1)
	move 2,4
	jffo 2,%L8
	seto 1,
%L9:
	popj 17,
%L8:
	move 1,3
	popj 17,

jffo_zero:
	setzb 1,2
	movei 4,0
	move 1,4
	jffo 1,%L11
	seto 1,
%L12:
	popj 17,
%L11:
	move 1,2
	popj 17,

jffo_low_bit:
	setzb 4,5
	iori 1,1
	move 4,1
	jffo 4,%L14
	seto 1,
%L15:
	popj 17,
%L14:
	move 1,5
	popj 17,

jffo_sign_bit:
	setzb 4,5
	tlo 1,400000
	move 4,1
	jffo 4,%L17
	seto 1,
%L18:
	popj 17,
%L17:
	move 1,5
	popj 17,

jffo_low_9:
	setzb 4,5
	andi 1,777
	move 4,1
	jffo 4,%L20
	seto 1,
%L21:
	popj 17,
%L20:
	move 1,5
	popj 17,

jffo_low_18:
	setzb 4,5
	hrrz 1,1
	move 4,1
	jffo 4,%L23
	seto 1,
%L24:
	popj 17,
%L23:
	move 1,5
	popj 17,

jffo_high_18:
	setzb 4,5
	hllz 1,1
	move 4,1
	jffo 4,%L26
	seto 1,
%L27:
	popj 17,
%L26:
	move 1,5
	popj 17,

jffo_literal_small:
	setzb 1,2
	movei 4,123456
	move 1,4
	jffo 1,%L29
	seto 1,
%L30:
	popj 17,
%L29:
	move 1,2
	popj 17,

jffo_literal_big:
	setzb 1,2
	move 4,[123456123456]
	move 1,4
	jffo 1,%L32
	seto 1,
%L33:
	popj 17,
%L32:
	move 1,2
	popj 17,

jffo_literal_sparse:
	setzb 1,2
	move 4,[-252525525253]
	move 1,4
	jffo 1,%L35
	seto 1,
%L36:
	popj 17,
%L35:
	move 1,2
	popj 17,

jffo_or:
	setzb 4,5
	ior 1,2
	move 4,1
	jffo 4,%L38
	seto 1,
%L39:
	popj 17,
%L38:
	move 1,5
	popj 17,

jffo_and:
	setzb 4,5
	and 1,2
	move 4,1
	jffo 4,%L41
	seto 1,
%L42:
	popj 17,
%L41:
	move 1,5
	popj 17,

jffo_xor:
	setzb 4,5
	xor 1,2
	move 4,1
	jffo 4,%L44
	seto 1,
%L45:
	popj 17,
%L44:
	move 1,5
	popj 17,

jffo_complement:
	setzb 4,5
	setca 1,
	move 4,1
	jffo 4,%L47
	seto 1,
%L48:
	popj 17,
%L47:
	move 1,5
	popj 17,

jffo_shift_left:
	setzb 4,5
	andi 2,17
	lsh 1,(2)
	move 4,1
	jffo 4,%L50
	seto 1,
%L51:
	popj 17,
%L50:
	move 1,5
	popj 17,

jffo_shift_right:
	setzb 4,5
	andi 2,17
	movn 2,2
	lsh 1,(2)
	move 4,1
	jffo 4,%L53
	seto 1,
%L54:
	popj 17,
%L53:
	move 1,5
	popj 17,

jffo_add:
	setzb 4,5
	add 1,2
	move 4,1
	jffo 4,%L56
	seto 1,
%L57:
	popj 17,
%L56:
	move 1,5
	popj 17,

jffo_sub:
	setzb 4,5
	sub 1,2
	move 4,1
	jffo 4,%L59
	seto 1,
%L60:
	popj 17,
%L59:
	move 1,5
	popj 17,

jffo_isolated_lowbit:
	setzb 2,3
	movn 4,1
	and 1,4
	move 2,1
	jffo 2,%L62
	seto 1,
%L63:
	popj 17,
%L62:
	move 1,3
	popj 17,

jffo_qi_unsigned:
	setzb 4,5
	andi 1,777	; zero_extendqisi2
	move 4,1
	jffo 4,%L65
	seto 1,
%L66:
	popj 17,
%L65:
	move 1,5
	popj 17,

jffo_qi_signed:
	setzb 4,5
	lsh 1,33
	ash 1,-33
	move 4,1
	jffo 4,%L68
	seto 1,
%L69:
	popj 17,
%L68:
	move 1,5
	popj 17,

jffo_hi_unsigned:
	setzb 4,5
	hrrzi 1,(1)	; zero_extendhisi2
	move 4,1
	jffo 4,%L71
	seto 1,
%L72:
	popj 17,
%L71:
	move 1,5
	popj 17,

jffo_hi_signed:
	setzb 4,5
	hrre 1,1
	move 4,1
	jffo 4,%L74
	seto 1,
%L75:
	popj 17,
%L74:
	move 1,5
	popj 17,

jffo_array:
	setzb 6,7
	andi 2,7
	add 1,2
	move 4,(1)
	move 6,4
	jffo 6,%L78
	seto 1,
%L79:
	popj 17,
%L78:
	move 1,7
	popj 17,

jffo_struct:
	setzb 2,3
	move 4,1(1)
	move 2,4
	jffo 2,%L81
	seto 1,
%L82:
	popj 17,
%L81:
	move 1,3
	popj 17,

jffo_store:
	setzb 4,5
	move 3,1
	move 4,2
	jffo 4,%L84
	seto 1,
%L85:
	movem 1,(3)
	popj 17,
%L84:
	move 1,5
	jrst %L85

jffo_store_void:
	setzb 4,5
	move 4,2
	jffo 4,%L87
	seto 2,
%L88:
	movem 2,(1)
	popj 17,
%L87:
	move 2,5
	jrst %L88

jffo_branch_zero:
	setzb 4,5
	move 4,1
	jffo 4,%L90
	seto 1,
%L91:
	caige 1,0
	movei 1,0
	popj 17,
%L90:
	move 1,5
	jrst %L91

jffo_branch_nonzero:
	setzb 4,5
	move 4,1
	jffo 4,%L94
	seto 1,
%L95:
	move 4,1
	addi 4,1
	jumpl 1,%L97
%L93:
	move 1,4
	popj 17,
%L97:
	seto 4,
	jrst %L93
%L94:
	move 1,5
	jrst %L95

jffo_compare_low:
	setzb 4,5
	move 4,1
	jffo 4,%L99
	seto 4,
%L100:
	move 1,4
	caile 4,11
	movei 1,0
	popj 17,
%L99:
	move 4,5
	jrst %L100

jffo_compare_high:
	setzb 4,5
	move 4,1
	jffo 4,%L103
	seto 4,
%L104:
	move 1,4
	caig 4,22
	movei 1,0
	popj 17,
%L103:
	move 4,5
	jrst %L104

jffo_two_values:
	setzb 4,5
	setzb 6,7
	move 4,1
	jffo 4,%L107
	seto 1,
%L108:
	move 6,2
	jffo 6,%L109
	seto 4,
%L110:
	add 1,4
	popj 17,
%L109:
	move 4,7
	jrst %L110
%L107:
	move 1,5
	jrst %L108

jffo_call_pressure:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setzb 4,5
	move 10,1
	move 4,10
	jffo 4,%L112
	seto 11,
%L113:
	pushj 17,clobber
	add 11,10
	move 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,
%L112:
	move 11,5
	jrst %L113

jffo_loop:
	setzb 6,7
	move 5,1
	setzb 1,3
	caml 1,2
	popj 17,
	subi 2,1
%L125:
	move 4,3
	andi 4,7
	add 4,5
	move 4,(4)
	move 6,4
	jffo 6,%L120
	seto 4,
%L121:
	add 1,4
	addi 3,1
	sojge 2,%L125	; doloop_end
	popj 17,
%L120:
	move 4,7
	jrst %L121

jffo_nested_expr:
	setzb 6,7
	movn 4,1
	and 4,1
	xor 2,3
	iori 4,(2)
	move 6,4
	jffo 6,%L127
	seto 1,
%L128:
	popj 17,
%L127:
	move 1,7
	popj 17,

jffo_jump_form_zero:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setzb 6,7
	setzb 10,11
	movei 4,0
	movei 2,0
	move 6,2
	jffo 6,%L130
	move 10,4
	movei 1,0
	jffo 10,.+2
	jrst %L129
%L130:
	movei 1,1
%L129:
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

jffo_jump_form_nonzero:
	setzb 2,3
	setzb 6,7
	iori 1,1
	movei 4,0
	move 2,4
	jffo 2,%L133
	move 6,1
	movei 1,0
	jffo 6,.+2
	jrst %L132
%L133:
	movei 1,1
%L132:
	popj 17,

jffo_jump_form_reg:
	setzb 2,3
	setzb 6,7
	movei 4,0
	move 2,4
	jffo 2,%L136
	move 6,1
	seto 1,
	jffo 6,.+2
	jrst %L135
%L136:
	movei 1,1
%L135:
	popj 17,

jffo_jump_form_mem:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setzb 6,7
	setzb 10,11
	move 4,(1)
	movei 2,0
	move 6,2
	jffo 6,%L139
	move 10,4
	seto 1,
	jffo 10,.+2
	jrst %L138
%L139:
	movei 1,1
%L138:
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

jffo_jump_form_dint:
	setzb 4,5
	setzb 6,7
	move 4,1
	jffo 4,%L142
	move 6,2
	seto 1,
	jffo 6,.+2
	jrst %L141
%L142:
	movei 1,1
%L141:
	popj 17,

jffo_jump_form_dint_mem:
	setzb 4,5
	setzb 6,7
	move 2,(1)
	move 3,1(1)
	move 4,2
	jffo 4,%L145
	move 6,3
	seto 1,
	jffo 6,.+2
	jrst %L144
%L145:
	movei 1,1
%L144:
	popj 17,

jffo_jump_form_two_labels:
	add 17,[14,,14]
	movei 0,-13(17)
	hrli 0,10
	blt 0,-6(17)
	setzb 10,11
	setzb 14,15
	setzm -5(17)
	setzm -4(17)
	setzm -3(17)
	setzm -2(17)
	setzb 12,13
	setzm -1(17)
	setzm (17)
	movei 4,0
	move 7,2
	movei 6,0
	move 10,4
	jffo 10,%L148
	move 14,1
	jffo 14,%L148
	movem 4,-5(17)
	move 4,-5(17)
	move 5,-4(17)
	jffo 4,%L150
	movem 2,-3(17)
	movei 1,0
	move 5,-3(17)
	move 6,-2(17)
	jffo 5,.+2
	jrst %L147
%L150:
	movei 1,2
%L147:
	movei 0,10
	hrli 0,-13(17)
	blt 0,15
	add 17,[-14,,-14]
	popj 17,
%L148:
	move 12,6
	jffo 12,%L152
	movem 7,-1(17)
	movei 1,1
	move 6,-1(17)
	move 7,(17)
	jffo 6,.+2
	jrst %L147
%L152:
	movei 1,3
	jrst %L147

	.comm	p, 4
