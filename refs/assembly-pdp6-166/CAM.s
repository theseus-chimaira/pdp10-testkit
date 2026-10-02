
cam_mem_lt:
	camge 1,(2)
	movei 1,0
	popj 17,

cam_mem_rev_lt:
	move 2,(2)
	camge 2,1
	movei 1,0
	popj 17,

cam_mem_lt_inv:
	caml 1,(2)
	movei 1,0
	popj 17,

cam_value_lt:
	caml 1,(2)
	tdza 1,1
	movei 1,1
	popj 17,

cam_call_lt:
	push 17,10
	move 10,1
	camge 1,(2)
	jrst %L11
%L10:
	move 1,10
	pop 17,10
	popj 17,
%L11:
	pushj 17,f
	add 10,1
	jrst %L10

cam_loop_lt:
	move 4,1
	move 2,(2)
	caml 1,2
	jrst %L18
	sub 2,1
	subi 2,1
%L19:
	add 3,4
	addi 4,1
	sojge 2,%L19	; doloop_end
%L18:
	add 4,3
	move 1,4
	popj 17,

cam_mem_eq:
	came 1,(2)
%L21:
	popj 17,
	movei 1,0
	popj 17,

cam_mem_rev_eq:
	move 2,(2)
	came 2,1
%L24:
	popj 17,
	movei 1,0
	popj 17,

cam_mem_eq_inv:
	came 1,(2)
	movei 1,0
	popj 17,

cam_value_eq:
	came 1,(2)
	tdza 1,1
	movei 1,1
	popj 17,

cam_call_eq:
	push 17,10
	move 10,1
	camn 1,(2)
	jrst %L32
%L31:
	move 1,10
	pop 17,10
	popj 17,
%L32:
	pushj 17,f
	add 10,1
	jrst %L31

cam_loop_eq:
	move 2,(2)
	camn 1,2
	jrst %L37
%L39:
	add 3,1
	move 1,3
	popj 17,
%L37:
	add 3,1
	addi 1,1
	camn 1,2
	jrst %L37
	jrst %L39

cam_mem_le:
	camg 1,(2)
	movei 1,0
	popj 17,

cam_mem_rev_le:
	move 2,(2)
	camg 2,1
	movei 1,0
	popj 17,

cam_mem_le_inv:
	camle 1,(2)
	movei 1,0
	popj 17,

cam_value_le:
	camle 1,(2)
	tdza 1,1
	movei 1,1
	popj 17,

cam_call_le:
	push 17,10
	move 10,1
	camg 1,(2)
	jrst %L50
%L49:
	move 1,10
	pop 17,10
	popj 17,
%L50:
	pushj 17,f
	add 10,1
	jrst %L49

cam_loop_le:
	move 4,1
	move 2,(2)
	camle 1,2
	jrst %L57
	sub 2,1
%L58:
	add 3,4
	addi 4,1
	sojge 2,%L58	; doloop_end
%L57:
	add 4,3
	move 1,4
	popj 17,

cam_mem_ge:
	caml 1,(2)
	movei 1,0
	popj 17,

cam_mem_rev_ge:
	move 2,(2)
	caml 2,1
	movei 1,0
	popj 17,

cam_mem_ge_inv:
	camge 1,(2)
	movei 1,0
	popj 17,

cam_value_ge:
	camge 1,(2)
	tdza 1,1
	movei 1,1
	popj 17,

cam_call_ge:
	push 17,10
	move 10,1
	caml 1,(2)
	jrst %L69
%L68:
	move 1,10
	pop 17,10
	popj 17,
%L69:
	pushj 17,f
	add 10,1
	jrst %L68

cam_loop_ge:
	move 2,(2)
	camge 1,2
	jrst %L76
%L74:
	add 3,1
	addi 1,1
	caml 1,2
	jrst %L74
%L76:
	add 3,1
	move 1,3
	popj 17,

cam_mem_ne:
	came 1,(2)
	movei 1,0
	popj 17,

cam_mem_rev_ne:
	move 2,(2)
	came 2,1
	movei 1,0
	popj 17,

cam_mem_ne_inv:
	came 1,(2)
%L82:
	popj 17,
	movei 1,0
	popj 17,

cam_value_ne:
	camn 1,(2)
	tdza 1,1
	movei 1,1
	popj 17,

cam_call_ne:
	push 17,10
	move 10,1
	camn 1,(2)
	jrst %L87
	pushj 17,f
	add 10,1
%L87:
	move 1,10
	pop 17,10
	popj 17,

cam_loop_ne:
	move 4,1
	move 2,(2)
	camn 1,2
	jrst %L94
	sub 2,1
	subi 2,1
%L95:
	add 3,4
	addi 4,1
	sojge 2,%L95	; doloop_end
%L94:
	add 4,3
	move 1,4
	popj 17,

cam_mem_gt:
	camle 1,(2)
	movei 1,0
	popj 17,

cam_mem_rev_gt:
	move 2,(2)
	camle 2,1
	movei 1,0
	popj 17,

cam_mem_gt_inv:
	camg 1,(2)
	movei 1,0
	popj 17,

cam_value_gt:
	camg 1,(2)
	tdza 1,1
	movei 1,1
	popj 17,

cam_call_gt:
	push 17,10
	move 10,1
	camle 1,(2)
	jrst %L106
%L105:
	move 1,10
	pop 17,10
	popj 17,
%L106:
	pushj 17,f
	add 10,1
	jrst %L105

cam_loop_gt:
	move 2,(2)
	camg 1,2
	jrst %L113
%L111:
	add 3,1
	addi 1,1
	camle 1,2
	jrst %L111
%L113:
	add 3,1
	move 1,3
	popj 17,

cam_lit_lt_big:
	camg 1,[123456123455]
	movei 1,0
	popj 17,

cam_lit_eq_big:
	came 1,[123456123456]
%L117:
	popj 17,
	movei 1,0
	popj 17,

cam_lit_le_big:
	camg 1,[123456123456]
	movei 1,0
	popj 17,

cam_lit_ge_big:
	camle 1,[123456123455]
	movei 1,0
	popj 17,

cam_lit_ne_big:
	came 1,[123456123456]
	movei 1,0
	popj 17,

cam_lit_gt_big:
	camle 1,[123456123456]
	movei 1,0
	popj 17,

cam_lit_lt_big_inv:
	camle 1,[123456123455]
	movei 1,0
	popj 17,

cam_lit_eq_big_inv:
	came 1,[123456123456]
	movei 1,0
	popj 17,

cam_lit_le_big_inv:
	camle 1,[123456123456]
	movei 1,0
	popj 17,

cam_lit_ge_big_inv:
	camg 1,[123456123455]
	movei 1,0
	popj 17,

cam_lit_ne_big_inv:
	came 1,[123456123456]
%L136:
	popj 17,
	movei 1,0
	popj 17,

cam_lit_gt_big_inv:
	camg 1,[123456123456]
	movei 1,0
	popj 17,

cam_lit_lt_sign:
	caile 1,0
	movei 1,0
	popj 17,

cam_lit_eq_sign:
	came 1,[-400000000000]
%L143:
	popj 17,
	movei 1,0
	popj 17,

cam_lit_le_sign:
	move 4,1
	tlc 4,400000
	jumple 4,%L147
%L146:
	popj 17,
%L147:
	movei 1,0
	popj 17,

cam_lit_ge_sign:
	caige 1,0
	movei 1,0
	popj 17,

cam_lit_ne_sign:
	came 1,[-400000000000]
	movei 1,0
	popj 17,

cam_lit_gt_sign:
	move 4,1
	tlc 4,400000
	jumple 4,%L153
	movei 1,0
%L153:
	popj 17,

cam_lit_lt_maxpos:
	camg 1,[377777777776]
	movei 1,0
	popj 17,

cam_lit_eq_maxpos:
	came 1,[377777777777]
%L157:
	popj 17,
	movei 1,0
	popj 17,

cam_lit_le_maxpos:
	movei 1,0
	popj 17,

cam_lit_ge_maxpos:
	camle 1,[377777777776]
	movei 1,0
	popj 17,

cam_lit_ne_maxpos:
	came 1,[377777777777]
	movei 1,0
	popj 17,

cam_lit_gt_maxpos:
	popj 17,

cam_chain:
	move 2,(2)
	movei 4,1
	camge 1,2
	jrst %L167
	move 3,(3)
	movei 4,2
	camn 1,3
	jrst %L167
	movei 4,3
	camg 1,[123456123456]
	jrst %L167
	movei 4,4
	caml 1,2
	jrst %L167
	movei 4,5
	camn 1,[377777777777]
	jrst %L174
%L167:
	move 1,4
	popj 17,
%L174:
	movei 4,6
	camle 1,3
	jrst %L167
	hrloi 4,377777
	jrst %L167

cam_chain_inverted:
	move 2,(2)
	move 4,1
	addi 4,1
	camle 1,2
	move 1,4
	move 3,(3)
	came 1,3
	addi 1,2
	camle 1,[123456123456]
	addi 1,3
	camge 1,2
	addi 1,4
	camn 1,[377777777777]
	jrst %L182
%L180:
	move 4,1
	addi 4,6
	camge 1,3
	move 1,4
	popj 17,
%L182:
	move 1,[-377777777774]
	jrst %L180

cam_mem_mem:
	move 1,(1)
	camge 1,(2)
	movei 1,0
	popj 17,

cam_mem_mem_rev:
	move 1,(1)
	move 2,(2)
	camle 2,1
	movei 1,0
	popj 17,

cam_volatile_mem:
	move 4,(2)
	came 1,4
%L188:
	popj 17,
	movei 1,0
	popj 17,

cam_volatile_mem_ne:
	move 4,(2)
	came 1,4
	movei 1,0
	popj 17,

cam_volatile_mem_lt:
	move 4,(2)
	camge 1,4
	movei 1,0
	popj 17,

cam_volatile_mem_gt:
	move 4,(2)
	camle 1,4
	movei 1,0
	popj 17,

cam_qi_signed:
	lsh 1,33
	ash 1,-33
	caml 1,(2)
	tdza 1,1
	movei 1,1
	popj 17,

cam_qi_unsigned:
	andi 1,777	; zero_extendqisi2
	came 1,(2)
	tdza 1,1
	movei 1,1
	popj 17,

cam_hi_signed:
	hrre 1,1
	camge 1,(2)
	tdza 1,1
	movei 1,1
	popj 17,

cam_hi_unsigned:
	hrrzi 1,(1)	; zero_extendhisi2
	camn 1,(2)
	tdza 1,1
	movei 1,1
	popj 17,

cam_array_value:
	andi 3,7
	add 2,3
	camle 1,(2)
	move 1,(2)
	popj 17,

cam_array_value_rev:
	andi 3,7
	add 2,3
	camle 1,(2)
	move 1,(2)
	popj 17,

cam_struct_value:
	camge 1,1(2)
	move 1,1(2)
	popj 17,

cam_struct_value_eq:
	move 4,1
	camn 1,2(2)
	jrst %L216
%L214:
	move 1,4
	popj 17,
%L216:
	move 4,(2)
	jrst %L214

cam_call_pressure:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 11,1
	move 12,2
	move 13,3
	move 10,1
	add 10,(2)
	camge 1,(3)
	jrst %L220
%L218:
	came 11,[123456123456]
	pushj 17,clobber
	add 10,11
	add 10,(12)
	add 10,(13)
	move 1,10
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,
%L220:
	pushj 17,clobber
	jrst %L218

cam_two_compares:
	move 2,(2)
	caml 1,2
	jrst %L223
	move 3,(3)
	move 4,1
	camle 1,3
	jrst %L221
%L222:
	move 4,2
	add 4,3
%L221:
	move 1,4
	popj 17,
%L223:
	move 3,(3)
	jrst %L222

cam_or_compares:
	move 2,(2)
	camn 1,2
	jrst %L226
	move 4,(3)
	sub 2,4
	camn 1,4
	jrst %L226
%L224:
	move 1,2
	popj 17,
%L226:
	move 2,1
	jrst %L224

cam_nested:
	move 6,1
	move 4,(2)
	move 1,4
	camge 6,4
	popj 17,
	camge 6,(3)
	skipa 1,6
	move 1,(3)
	popj 17,

ucam_mem_eq:
	came 1,(2)
%L231:
	popj 17,
	movei 1,0
	popj 17,

ucam_mem_ne:
	came 1,(2)
	movei 1,0
	popj 17,

ucam_big_eq:
	move 6,[123456123456]
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

ucam_big_ne:
	move 6,[123456123456]
	camn 1,6
	tdza 1,1
	movei 1,1
	popj 17,

	.comm	p, 4
