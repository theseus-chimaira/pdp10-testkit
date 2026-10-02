
jumpe_arg:
	movei 4,1
	jumpe 1,%L1
	seto 4,
%L1:
	move 1,4
	popj 17,

jumpn_arg:
	movei 4,1
	jumpn 1,%L3
	seto 4,
%L3:
	move 1,4
	popj 17,

jumpe_second_arg:
	jumpe 2,%L5
	move 1,2
%L5:
	popj 17,

jumpn_second_arg:
	jumpn 2,%L7
	movei 1,0
%L7:
	popj 17,

jumpe_return_zero:
	movei 4,0
	jumpe 1,%L9
	move 4,1
%L9:
	move 1,4
	popj 17,

jumpn_return_zero:
	move 4,1
	jumpn 1,%L11
	movei 4,0
%L11:
	move 1,4
	popj 17,

jumpe_after_local:
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

jumpn_after_local:
	skipe 1
	movei 1,1
	popj 17,

jumpl_arg:
	seto 4,
	jumpl 1,%L17
	movei 4,1
%L17:
	move 1,4
	popj 17,

jumpge_arg:
	movei 4,1
	jumpl 1,%L21
%L19:
	move 1,4
	popj 17,
%L21:
	seto 4,
	jrst %L19

jumpl_second_arg:
	jumpl 2,%L22
	move 1,2
%L22:
	popj 17,

jumpge_second_arg:
	jumpl 2,%L26
%L24:
	popj 17,
%L26:
	move 1,2
	popj 17,

jumpl_after_local:
	movm 1,1
	movn 1,1
	popj 17,

jumpge_after_local:
	movm 1,1
	popj 17,

jumple_arg:
	seto 4,
	jumple 1,%L31
	movei 4,1
%L31:
	move 1,4
	popj 17,

jumpg_arg:
	movei 4,1
	jumple 1,%L35
%L33:
	move 1,4
	popj 17,
%L35:
	seto 4,
	jrst %L33

jumple_second_arg:
	jumple 2,%L36
	move 1,2
%L36:
	popj 17,

jumpg_second_arg:
	jumple 2,%L40
%L38:
	popj 17,
%L40:
	move 1,2
	popj 17,

jumple_after_local:
	move 4,1
	subi 4,1
	jumple 1,%L41
	addi 4,2
%L41:
	move 1,4
	popj 17,

jumpg_after_local:
	move 4,1
	addi 4,1
	jumple 1,%L45
%L43:
	move 1,4
	popj 17,
%L45:
	subi 4,2
	jrst %L43

jump_if_truth:
	skipe 1
	movei 1,1
	popj 17,

jump_if_false:
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

jump_if_truth_return_arg:
	move 4,1
	jumpn 1,%L50
	seto 4,
%L50:
	move 1,4
	popj 17,

jump_if_false_return_arg:
	skipe 1
	movei 1,1
	movn 1,1
	popj 17,

jump_add_eq_zero:
	add 1,2
	movei 4,1
	jumpe 1,%L54
	seto 4,
%L54:
	move 1,4
	popj 17,

jump_add_ne_zero:
	add 1,2
	movei 4,1
	jumpn 1,%L56
	seto 4,
%L56:
	move 1,4
	popj 17,

jump_add_lt_zero:
	add 1,2
	seto 4,
	jumpl 1,%L58
	movei 4,1
%L58:
	move 1,4
	popj 17,

jump_add_ge_zero:
	add 1,2
	movei 4,1
	jumpl 1,%L62
%L60:
	move 1,4
	popj 17,
%L62:
	seto 4,
	jrst %L60

jump_sub_eq_zero:
	movei 4,1
	came 1,2
	seto 4,
	move 1,4
	popj 17,

jump_sub_ne_zero:
	movei 4,1
	camn 1,2
	seto 4,
	move 1,4
	popj 17,

jump_sub_le_zero:
	sub 1,2
	seto 4,
	jumple 1,%L67
	movei 4,1
%L67:
	move 1,4
	popj 17,

jump_sub_gt_zero:
	sub 1,2
	movei 4,1
	jumple 1,%L71
%L69:
	move 1,4
	popj 17,
%L71:
	seto 4,
	jrst %L69

jump_neg_lt_zero:
	movn 1,1
	seto 4,
	jumpl 1,%L72
	movei 4,1
%L72:
	move 1,4
	popj 17,

jump_neg_ge_zero:
	movn 1,1
	movei 4,1
	jumpl 1,%L76
%L74:
	move 1,4
	popj 17,
%L76:
	seto 4,
	jrst %L74

jump_and_eq_zero:
	movei 4,1
	tdne 1,2
	seto 4,
	move 1,4
	popj 17,

jump_and_ne_zero:
	movei 4,1
	tdnn 1,2
	seto 4,
	move 1,4
	popj 17,

jump_xor_eq_zero:
	movei 4,1
	came 1,2
	seto 4,
	move 1,4
	popj 17,

jump_xor_ne_zero:
	movei 4,1
	camn 1,2
	seto 4,
	move 1,4
	popj 17,

jump_or_gt_zero:
	ior 1,2
	movei 4,1
	jumple 1,%L87
%L85:
	move 1,4
	popj 17,
%L87:
	seto 4,
	jrst %L85

jump_shift_lt_zero:
	seto 4,
	tlnn 1,200000
	movei 4,1
	move 1,4
	popj 17,

jump_shift_eq_zero:
	lsh 1,1
	movei 4,1
	jumpe 1,%L90
	seto 4,
%L90:
	move 1,4
	popj 17,

jump_load_eq_zero:
	movei 4,1
	skipe (1)
	seto 4,
	move 1,4
	popj 17,

jump_load_ne_zero:
	movei 4,1
	skipn (1)
	seto 4,
	move 1,4
	popj 17,

jump_load_lt_zero:
	seto 4,
	skipl (1)
	movei 4,1
	move 1,4
	popj 17,

jump_load_ge_zero:
	movei 4,1
	skipge (1)
	jrst %L100
%L98:
	move 1,4
	popj 17,
%L100:
	seto 4,
	jrst %L98

jump_load_le_zero:
	seto 4,
	skiple (1)
	movei 4,1
	move 1,4
	popj 17,

jump_load_gt_zero:
	movei 4,1
	skipg (1)
	jrst %L105
%L103:
	move 1,4
	popj 17,
%L105:
	seto 4,
	jrst %L103

jump_load_after_call_eq_zero:
	push 17,10
	move 10,(1)
	pushj 17,clobber
	movei 1,1
	jumpe 10,%L106
	seto 1,
%L106:
	pop 17,10
	popj 17,

jump_load_after_call_lt_zero:
	push 17,10
	move 10,(1)
	pushj 17,clobber
	seto 1,
	jumpl 10,%L108
	movei 1,1
%L108:
	pop 17,10
	popj 17,

jump_global_eq_zero:
	movei 1,1
	skipe jump_ga
	seto 1,
	popj 17,

jump_global_ne_zero:
	movei 1,1
	skipn jump_ga
	seto 1,
	popj 17,

jump_global_lt_zero:
	seto 1,
	skipl jump_ga
	movei 1,1
	popj 17,

jump_global_ge_zero:
	movei 1,1
	skipl jump_ga
%L116:
	popj 17,
	seto 1,
	popj 17,

jump_volatile_global_eq_zero:
	move 4,jump_vga
	movei 1,1
	jumpe 4,%L119
	seto 1,
%L119:
	popj 17,

jump_volatile_global_lt_zero:
	move 4,jump_vga
	seto 1,
	jumpl 4,%L121
	movei 1,1
%L121:
	popj 17,

jump_array_eq_zero:
	andi 1,17
	movei 4,1
	skipe jump_buf(1)
	seto 4,
	move 1,4
	popj 17,

jump_array_gt_zero:
	andi 1,17
	movei 4,1
	skipg jump_buf(1)
	jrst %L127
%L125:
	move 1,4
	popj 17,
%L127:
	seto 4,
	jrst %L125

jump_struct_a_lt_zero:
	seto 4,
	skipl (1)
	movei 4,1
	move 1,4
	popj 17,

jump_struct_b_ne_zero:
	movei 4,1
	skipn 1(1)
	seto 4,
	move 1,4
	popj 17,

jump_global_struct_a_eq_zero:
	movei 1,1
	skipe jump_gp
	seto 1,
	popj 17,

jump_global_struct_b_gt_zero:
	movei 1,1
	skiple jump_gp+1
%L134:
	popj 17,
	seto 1,
	popj 17,

ujump_eq_zero:
	movei 4,1
	jumpe 1,%L137
	seto 4,
%L137:
	move 1,4
	popj 17,

ujump_ne_zero:
	movei 4,1
	jumpn 1,%L139
	seto 4,
%L139:
	move 1,4
	popj 17,

ujump_truth:
	skipe 1
	movei 1,1
	popj 17,

ujump_false:
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

ujump_and_eq_zero:
	movei 4,1
	tdne 1,2
	seto 4,
	move 1,4
	popj 17,

ujump_xor_ne_zero:
	movei 4,1
	camn 1,2
	seto 4,
	move 1,4
	popj 17,

ujump_load_eq_zero:
	movei 4,1
	skipe (1)
	seto 4,
	move 1,4
	popj 17,

ujump_load_ne_zero:
	movei 4,1
	skipn (1)
	seto 4,
	move 1,4
	popj 17,

ujump_global_eq_zero:
	movei 1,1
	skipe ujump_ga
	seto 1,
	popj 17,

ujump_volatile_global_ne_zero:
	move 4,ujump_vga
	movei 1,1
	jumpn 4,%L155
	seto 1,
%L155:
	popj 17,

ujump_array_eq_zero:
	andi 1,17
	movei 4,1
	skipe ujump_buf(1)
	seto 4,
	move 1,4
	popj 17,

ujump_struct_a_ne_zero:
	movei 4,1
	skipn (1)
	seto 4,
	move 1,4
	popj 17,

jump_qi_eq_zero:
	lsh 1,33
	ash 1,-33
	movei 4,1
	jumpe 1,%L161
	seto 4,
%L161:
	move 1,4
	popj 17,

jump_qi_ne_zero:
	lsh 1,33
	ash 1,-33
	movei 4,1
	jumpn 1,%L163
	seto 4,
%L163:
	move 1,4
	popj 17,

jump_qi_lt_zero:
	seto 4,
	trnn 1,400
	movei 4,1
	move 1,4
	popj 17,

jump_qi_ge_zero:
	movei 4,1
	trne 1,400
	jrst %L169
%L167:
	move 1,4
	popj 17,
%L169:
	seto 4,
	jrst %L167

jump_qi_le_zero:
	lsh 1,33
	ash 1,-33
	seto 4,
	jumple 1,%L170
	movei 4,1
%L170:
	move 1,4
	popj 17,

jump_qi_gt_zero:
	lsh 1,33
	ash 1,-33
	movei 4,1
	jumple 1,%L174
%L172:
	move 1,4
	popj 17,
%L174:
	seto 4,
	jrst %L172

jump_uqi_eq_zero:
	andi 1,777	; zero_extendqisi2
	movei 4,1
	jumpe 1,%L175
	seto 4,
%L175:
	move 1,4
	popj 17,

jump_uqi_ne_zero:
	andi 1,777	; zero_extendqisi2
	movei 4,1
	jumpn 1,%L177
	seto 4,
%L177:
	move 1,4
	popj 17,

jump_hi_eq_zero:
	hrre 1,1
	movei 4,1
	jumpe 1,%L179
	seto 4,
%L179:
	move 1,4
	popj 17,

jump_hi_ne_zero:
	hrre 1,1
	movei 4,1
	jumpn 1,%L181
	seto 4,
%L181:
	move 1,4
	popj 17,

jump_hi_lt_zero:
	seto 4,
	trnn 1,400000
	movei 4,1
	move 1,4
	popj 17,

jump_hi_ge_zero:
	movei 4,1
	trne 1,400000
	jrst %L187
%L185:
	move 1,4
	popj 17,
%L187:
	seto 4,
	jrst %L185

jump_hi_le_zero:
	hrre 1,1
	seto 4,
	jumple 1,%L188
	movei 4,1
%L188:
	move 1,4
	popj 17,

jump_hi_gt_zero:
	hrre 1,1
	movei 4,1
	jumple 1,%L192
%L190:
	move 1,4
	popj 17,
%L192:
	seto 4,
	jrst %L190

jump_uhi_eq_zero:
	hrrzi 1,(1)	; zero_extendhisi2
	movei 4,1
	jumpe 1,%L193
	seto 4,
%L193:
	move 1,4
	popj 17,

jump_uhi_ne_zero:
	hrrzi 1,(1)	; zero_extendhisi2
	movei 4,1
	jumpn 1,%L195
	seto 4,
%L195:
	move 1,4
	popj 17,

jump_far_eq_zero:
	jumpn 1,%L198
	pushj 17,clobber
	jrst f
%L198:
	pushj 17,clobber
	pushj 17,f
	movn 1,1
	popj 17,

jump_far_ne_zero:
	jumpe 1,%L200
	pushj 17,clobber
	jrst f
%L200:
	pushj 17,clobber
	pushj 17,f
	movn 1,1
	popj 17,

jump_far_lt_zero:
	push 17,10
	move 10,1
	jumpl 1,%L203
	pushj 17,clobber
	pushj 17,f
	add 1,10
%L201:
	pop 17,10
	popj 17,
%L203:
	pushj 17,clobber
	pushj 17,f
	sub 10,1
	move 1,10
	jrst %L201

jump_far_ge_zero:
	push 17,10
	move 10,1
	jumpl 1,%L205
	pushj 17,clobber
	pushj 17,f
	add 1,10
%L204:
	pop 17,10
	popj 17,
%L205:
	pushj 17,clobber
	pushj 17,f
	sub 10,1
	move 1,10
	jrst %L204

jump_far_le_zero:
	push 17,10
	move 10,1
	jumple 1,%L208
	pushj 17,clobber
	pushj 17,f
	add 1,10
%L206:
	pop 17,10
	popj 17,
%L208:
	pushj 17,clobber
	pushj 17,f
	sub 10,1
	move 1,10
	jrst %L206

jump_far_gt_zero:
	push 17,10
	move 10,1
	jumple 1,%L210
	pushj 17,clobber
	pushj 17,f
	add 1,10
%L209:
	pop 17,10
	popj 17,
%L210:
	pushj 17,clobber
	pushj 17,f
	sub 10,1
	move 1,10
	jrst %L209

jump_eq_zero_fallthrough:
	move 4,1
	jumpn 1,%L211
	movei 4,0
%L211:
	move 1,4
	popj 17,

jump_ne_zero_fallthrough:
	movei 4,0
	jumpe 1,%L213
	move 4,1
%L213:
	move 1,4
	popj 17,

jump_lt_zero_fallthrough:
	movm 1,1
	popj 17,

jump_ge_zero_fallthrough:
	movm 1,1
	popj 17,

jump_le_zero_fallthrough:
	movm 1,1
	popj 17,

jump_gt_zero_fallthrough:
	movm 1,1
	popj 17,

jump_classify_signed:
	seto 4,
	jumpl 1,%L223
	skipe 4,1
	movei 4,1
%L223:
	move 1,4
	popj 17,

jump_classify_signed_reverse:
	movei 4,1
	jumple 1,%L229
%L226:
	move 1,4
	popj 17,
%L229:
	skipe 4,1
	movei 4,1
	movn 4,4
	jrst %L226

jump_classify_nonzero:
	movei 4,0
	jumpe 1,%L230
	seto 4,
	jumpl 1,%L230
	movei 4,1
%L230:
	move 1,4
	popj 17,

jump_nested:
	movei 4,0
	jumpe 1,%L233
	move 4,1
	jumpe 2,%L233
	movm 4,2
%L233:
	move 1,4
	popj 17,

jump_chain_and:
	jumpe 1,%L238
	movei 1,1
	jumpn 2,%L237
%L238:
	movei 1,0
%L237:
	popj 17,

jump_chain_or:
	movei 4,1
	jumpn 1,%L240
	skipe 4,2
	movei 4,1
%L240:
	move 1,4
	popj 17,

jump_loop_countdown:
	movei 3,0
	jumpe 1,%L249
	move 4,1
	subi 4,1
%L250:
	add 3,1
	subi 1,1
	sojge 4,%L250	; doloop_end
%L249:
	move 1,3
	popj 17,

jump_loop_positive:
	movei 4,0
	jumple 1,%L257
%L255:
	add 4,1
	sojg 1,%L255	; decrement_and_branch_until_zero
%L257:
	move 1,4
	popj 17,

jump_loop_nonnegative:
	movei 4,0
	jumpl 1,%L264
%L262:
	add 4,1
	sojge 1,%L262	; decrement_and_branch_until_zero
%L264:
	move 1,4
	popj 17,

jump_loop_until_negative:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	movei 11,0
	jumpl 1,%L271
%L269:
	add 11,10
	pushj 17,f
	sub 10,1
	jumpge 10,%L269
%L271:
	move 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

jump_do_until_zero:
	move 3,1
	movei 2,0
	move 4,1
	jumpn 1,%L278
	movei 4,1
%L278:
	subi 4,1
%L277:
	add 2,3
	subi 3,1
	sojge 4,%L277	; doloop_end
	move 1,2
	popj 17,

jump_for_countdown:
	movei 4,0
	jumple 1,%L286
%L284:
	add 4,1
	sojg 1,%L284	; decrement_and_branch_until_zero
%L286:
	move 1,4
	popj 17,

jump_store_if_zero:
	jumpn 2,%L287
	setzm (1)
%L287:
	popj 17,

jump_store_if_nonzero:
	jumpe 2,%L289
	movem 2,(1)
%L289:
	popj 17,

jump_store_if_negative:
	jumpl 2,%L293
%L291:
	popj 17,
%L293:
	movem 2,(1)
	popj 17,

jump_store_if_positive:
	jumple 2,%L294
	movem 2,(1)
%L294:
	popj 17,

jump_store_select:
	jumpn 2,%L297
	movei 6,1
	movem 6,(1)
%L298:
	move 1,(1)
	popj 17,
%L297:
	setom (1)
	jrst %L298

jump_store_select_sign:
	jumpl 2,%L304
	skipg 2
	tdza 4,4
	movei 4,1
	movem 4,(1)
%L301:
	move 1,(1)
	popj 17,
%L304:
	setom (1)
	jrst %L301

jump_call_eq_zero:
	pushj 17,f
	movei 4,1
	jumpe 1,%L305
	seto 4,
%L305:
	move 1,4
	popj 17,

jump_call_ne_zero:
	pushj 17,f
	movei 4,1
	jumpn 1,%L307
	seto 4,
%L307:
	move 1,4
	popj 17,

jump_call_lt_zero:
	pushj 17,f
	seto 4,
	jumpl 1,%L309
	movei 4,1
%L309:
	move 1,4
	popj 17,

jump_call_gt_zero:
	pushj 17,f
	movei 4,1
	jumple 1,%L313
%L311:
	move 1,4
	popj 17,
%L313:
	seto 4,
	jrst %L311

ujump_call_eq_zero:
	pushj 17,uf
	movei 4,1
	jumpe 1,%L314
	seto 4,
%L314:
	move 1,4
	popj 17,

ujump_call_ne_zero:
	pushj 17,uf
	movei 4,1
	jumpn 1,%L316
	seto 4,
%L316:
	move 1,4
	popj 17,

jumpa_candidate_goto:
%L320:
%L319:
	move 4,1
	addi 4,1
	cain 1,12345
	jrst %L322
%L318:
	move 1,4
	popj 17,
%L322:
	movei 4,12345
	jrst %L318

jumpa_candidate_loop_once:
	addi 1,1
	popj 17,

jumpa_candidate_switch:
	move 4,2
	addi 4,1
	jumpn 1,%L327
%L329:
%L330:
	subi 4,2
%L327:
	move 1,4
	popj 17,

	.globl	JUMP
JUMP:
	movei 6,1
	jumpe 1,%L344
	movei 6,2
	jumpl 1,%L346
%L334:
	jumple 1,%L344
%L345:
	addi 6,5
	jumple 1,%L337
	addi 6,6
%L337:
	move 4,1
	add 4,2
	jumpn 4,%L338
	addi 6,7
%L338:
	came 1,2
	addi 6,10
	move 4,1
	xor 4,2
	jumpl 4,%L347
%L340:
	jumpe 3,%L341
	skipe 4,(3)
	add 6,4
%L341:
	move 1,6
	popj 17,
%L347:
	subi 6,11
	jrst %L340
%L344:
	subi 6,4
	jumpge 1,%L345
	jrst %L337
%L346:
	seto 6,
	jrst %L334

	.bss
jump_ga:
	.space	4
jump_gb:
	.space	4
jump_vga:
	.space	4
jump_buf:
	.space	64
ujump_ga:
	.space	4
ujump_gb:
	.space	4
ujump_vga:
	.space	4
ujump_buf:
	.space	64
jump_gp:
	.space	8
ujump_gp:
	.space	8
