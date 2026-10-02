
cai_lt_2:
	caile 1,1
%L2:
	popj 17,
	movei 1,0
	popj 17,

cai_lt_2_inv:
	caile 1,1
	movei 1,0
	popj 17,

cai_lt_2_call:
	push 17,10
	move 10,1
	caig 1,1
	jrst %L8
%L7:
	move 1,10
	pop 17,10
	popj 17,
%L8:
	pushj 17,f
	add 10,1
	jrst %L7

cai_lt_2_loop:
	move 4,1
	caig 1,1
	jrst %L17
%L15:
	add 4,2
	move 1,4
	popj 17,
%L17:
	setca 1,
	addi 1,2
%L16:
	add 2,4
	addi 4,1
	sojge 1,%L16	; doloop_end
	jrst %L15

cai_lt_2_value:
	movei 6,1
	camle 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cai_eq_2:
	caie 1,2
%L21:
	popj 17,
	movei 1,0
	popj 17,

cai_eq_2_inv:
	caie 1,2
	movei 1,0
	popj 17,

cai_eq_2_call:
	caie 1,2
%L26:
	popj 17,
	pushj 17,f
	addi 1,2
	popj 17,

cai_eq_2_loop:
	cain 1,2
	jrst %L32
%L34:
	add 2,1
	move 1,2
	popj 17,
%L32:
	add 2,1
	addi 1,1
	cain 1,2
	jrst %L32
	jrst %L34

cai_eq_2_value:
	movei 6,2
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cai_le_2:
	caig 1,2
	movei 1,0
	popj 17,

cai_le_2_inv:
	caile 1,2
	movei 1,0
	popj 17,

cai_le_2_call:
	push 17,10
	move 10,1
	caig 1,2
	jrst %L43
%L42:
	move 1,10
	pop 17,10
	popj 17,
%L43:
	pushj 17,f
	add 10,1
	jrst %L42

cai_le_2_loop:
	move 4,1
	caile 1,2
	jrst %L50
	setca 1,
	addi 1,3
%L51:
	add 2,4
	addi 4,1
	sojge 1,%L51	; doloop_end
%L50:
	add 4,2
	move 1,4
	popj 17,

cai_le_2_value:
	movei 6,2
	camle 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cai_ge_2:
	caile 1,1
	movei 1,0
	popj 17,

cai_ge_2_inv:
	caile 1,1
%L57:
	popj 17,
	movei 1,0
	popj 17,

cai_ge_2_call:
	push 17,10
	move 10,1
	caile 1,1
	jrst %L61
%L60:
	move 1,10
	pop 17,10
	popj 17,
%L61:
	pushj 17,f
	add 10,1
	jrst %L60

cai_ge_2_loop:
	caig 1,1
	jrst %L68
%L66:
	add 2,1
	addi 1,1
	caile 1,1
	jrst %L66
%L68:
	add 2,1
	move 1,2
	popj 17,

cai_ge_2_value:
	movei 6,1
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cai_ne_2:
	caie 1,2
	movei 1,0
	popj 17,

cai_ne_2_inv:
	caie 1,2
%L74:
	popj 17,
	movei 1,0
	popj 17,

cai_ne_2_call:
	push 17,10
	move 10,1
	cain 1,2
	jrst %L77
	pushj 17,f
	add 10,1
%L77:
	move 1,10
	pop 17,10
	popj 17,

cai_ne_2_loop:
	move 4,1
	cain 1,2
	jrst %L84
	setca 1,
	addi 1,2
%L85:
	add 2,4
	addi 4,1
	sojge 1,%L85	; doloop_end
%L84:
	add 4,2
	move 1,4
	popj 17,

cai_ne_2_value:
	movei 6,2
	camn 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cai_gt_2:
	caile 1,2
	movei 1,0
	popj 17,

cai_gt_2_inv:
	caig 1,2
	movei 1,0
	popj 17,

cai_gt_2_call:
	push 17,10
	move 10,1
	caile 1,2
	jrst %L94
%L93:
	move 1,10
	pop 17,10
	popj 17,
%L94:
	pushj 17,f
	add 10,1
	jrst %L93

cai_gt_2_loop:
	caig 1,2
	jrst %L101
%L99:
	add 2,1
	addi 1,1
	caile 1,2
	jrst %L99
%L101:
	add 2,1
	move 1,2
	popj 17,

cai_gt_2_value:
	movei 6,2
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cai_lt_0:
	caige 1,0
	movei 1,0
	popj 17,

cai_lt_0_inv:
	caile 1,0
	movei 1,0
	popj 17,

cai_lt_0_call:
	push 17,10
	move 10,1
	jumpl 1,%L110
%L109:
	move 1,10
	pop 17,10
	popj 17,
%L110:
	pushj 17,f
	add 10,1
	jrst %L109

cai_lt_0_loop:
	move 4,1
	jumpl 1,%L119
%L117:
	add 4,2
	move 1,4
	popj 17,
%L119:
	setca 1,
%L118:
	add 2,4
	addi 4,1
	sojge 1,%L118	; doloop_end
	jrst %L117

cai_lt_0_value:
	skipl 1
	tdza 1,1
	movei 1,1
	popj 17,

cai_eq_0:
	popj 17,

cai_eq_0_inv:
	jumpe 1,%L125
	movei 1,0
%L125:
	popj 17,

cai_eq_0_call:
	jumpe 1,%L128
%L127:
	popj 17,
%L128:
	pushj 17,f
	popj 17,

cai_eq_0_loop:
	jumpn 1,%L135
%L133:
	add 2,1
	aoje 1,%L133
%L135:
	add 2,1
	move 1,2
	popj 17,

cai_eq_0_value:
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

cai_le_0:
	caige 1,0
	movei 1,0
	popj 17,

cai_le_0_inv:
	caile 1,0
	movei 1,0
	popj 17,

cai_le_0_call:
	push 17,10
	move 10,1
	jumple 1,%L144
%L143:
	move 1,10
	pop 17,10
	popj 17,
%L144:
	pushj 17,f
	add 10,1
	jrst %L143

cai_le_0_loop:
	move 4,1
	jumple 1,%L153
%L151:
	add 4,2
	move 1,4
	popj 17,
%L153:
	movn 1,1
%L152:
	add 2,4
	addi 4,1
	sojge 1,%L152	; doloop_end
	jrst %L151

cai_le_0_value:
	skiple 1
	tdza 1,1
	movei 1,1
	popj 17,

cai_ge_0:
	caile 1,0
	movei 1,0
	popj 17,

cai_ge_0_inv:
	caige 1,0
	movei 1,0
	popj 17,

cai_ge_0_call:
	push 17,10
	move 10,1
	jumpl 1,%L161
	pushj 17,f
	add 10,1
%L161:
	move 1,10
	pop 17,10
	popj 17,

cai_ge_0_loop:
	jumpl 1,%L168
%L166:
	add 2,1
	aojge 1,%L166
%L168:
	add 2,1
	move 1,2
	popj 17,

cai_ge_0_value:
	skipge 1
	tdza 1,1
	movei 1,1
	popj 17,

cai_ne_0:
	jumpe 1,%L172
	movei 1,0
%L172:
	popj 17,

cai_ne_0_inv:
	popj 17,

cai_ne_0_call:
	push 17,10
	move 10,1
	jumpn 1,%L177
%L176:
	move 1,10
	pop 17,10
	popj 17,
%L177:
	pushj 17,f
	add 10,1
	jrst %L176

cai_ne_0_loop:
	move 4,1
	jumpe 1,%L184
	setca 1,
%L185:
	add 2,4
	addi 4,1
	sojge 1,%L185	; doloop_end
%L184:
	add 4,2
	move 1,4
	popj 17,

cai_ne_0_value:
	skipe 1
	movei 1,1
	popj 17,

cai_gt_0:
	caile 1,0
	movei 1,0
	popj 17,

cai_gt_0_inv:
	caige 1,0
	movei 1,0
	popj 17,

cai_gt_0_call:
	push 17,10
	move 10,1
	jumple 1,%L193
	pushj 17,f
	add 10,1
%L193:
	move 1,10
	pop 17,10
	popj 17,

cai_gt_0_loop:
	jumple 1,%L200
%L198:
	add 2,1
	aojg 1,%L198
%L200:
	add 2,1
	move 1,2
	popj 17,

cai_gt_0_value:
	skipg 1
	tdza 1,1
	movei 1,1
	popj 17,

cai_lt_1:
	caige 1,0
	movei 1,0
	popj 17,

cai_lt_1_inv:
	caile 1,0
	movei 1,0
	popj 17,

cai_lt_1_call:
	push 17,10
	move 10,1
	jumple 1,%L209
%L208:
	move 1,10
	pop 17,10
	popj 17,
%L209:
	pushj 17,f
	add 10,1
	jrst %L208

cai_lt_1_loop:
	move 4,1
	jumple 1,%L218
%L216:
	add 4,2
	move 1,4
	popj 17,
%L218:
	movn 1,1
%L217:
	add 2,4
	addi 4,1
	sojge 1,%L217	; doloop_end
	jrst %L216

cai_lt_1_value:
	skiple 1
	tdza 1,1
	movei 1,1
	popj 17,

cai_eq_1:
	caie 1,1
%L222:
	popj 17,
	movei 1,0
	popj 17,

cai_eq_1_inv:
	caie 1,1
	movei 1,0
	popj 17,

cai_eq_1_call:
	caie 1,1
%L227:
	popj 17,
	pushj 17,f
	aoja 1,%L227

cai_eq_1_loop:
	cain 1,1
	jrst %L233
%L235:
	add 2,1
	move 1,2
	popj 17,
%L233:
	add 2,1
	addi 1,1
	cain 1,1
	jrst %L233
	jrst %L235

cai_eq_1_value:
	movei 6,1
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cai_le_1:
	caile 1,1
%L239:
	popj 17,
	movei 1,0
	popj 17,

cai_le_1_inv:
	caile 1,1
	movei 1,0
	popj 17,

cai_le_1_call:
	push 17,10
	move 10,1
	caig 1,1
	jrst %L245
%L244:
	move 1,10
	pop 17,10
	popj 17,
%L245:
	pushj 17,f
	add 10,1
	jrst %L244

cai_le_1_loop:
	move 4,1
	caig 1,1
	jrst %L254
%L252:
	add 4,2
	move 1,4
	popj 17,
%L254:
	setca 1,
	addi 1,2
%L253:
	add 2,4
	addi 4,1
	sojge 1,%L253	; doloop_end
	jrst %L252

cai_le_1_value:
	movei 6,1
	camle 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cai_ge_1:
	caile 1,0
	movei 1,0
	popj 17,

cai_ge_1_inv:
	caige 1,0
	movei 1,0
	popj 17,

cai_ge_1_call:
	push 17,10
	move 10,1
	jumple 1,%L262
	pushj 17,f
	add 10,1
%L262:
	move 1,10
	pop 17,10
	popj 17,

cai_ge_1_loop:
	jumple 1,%L269
%L267:
	add 2,1
	aojg 1,%L267
%L269:
	add 2,1
	move 1,2
	popj 17,

cai_ge_1_value:
	skipg 1
	tdza 1,1
	movei 1,1
	popj 17,

cai_ne_1:
	caie 1,1
	movei 1,0
	popj 17,

cai_ne_1_inv:
	caie 1,1
%L275:
	popj 17,
	movei 1,0
	popj 17,

cai_ne_1_call:
	push 17,10
	move 10,1
	cain 1,1
	jrst %L278
	pushj 17,f
	add 10,1
%L278:
	move 1,10
	pop 17,10
	popj 17,

cai_ne_1_loop:
	move 4,1
	cain 1,1
	jrst %L285
	movn 1,1
%L286:
	add 2,4
	addi 4,1
	sojge 1,%L286	; doloop_end
%L285:
	add 4,2
	move 1,4
	popj 17,

cai_ne_1_value:
	movei 6,1
	camn 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cai_gt_1:
	caile 1,1
	movei 1,0
	popj 17,

cai_gt_1_inv:
	caile 1,1
%L292:
	popj 17,
	movei 1,0
	popj 17,

cai_gt_1_call:
	push 17,10
	move 10,1
	caile 1,1
	jrst %L296
%L295:
	move 1,10
	pop 17,10
	popj 17,
%L296:
	pushj 17,f
	add 10,1
	jrst %L295

cai_gt_1_loop:
	caig 1,1
	jrst %L303
%L301:
	add 2,1
	addi 1,1
	caile 1,1
	jrst %L301
%L303:
	add 2,1
	move 1,2
	popj 17,

cai_gt_1_value:
	movei 6,1
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cai_lt_777777:
	caig 1,777776
	movei 1,0
	popj 17,

cai_lt_777777_inv:
	caile 1,777776
	movei 1,0
	popj 17,

cai_lt_777777_call:
	push 17,10
	move 10,1
	caig 1,777776
	jrst %L312
%L311:
	move 1,10
	pop 17,10
	popj 17,
%L312:
	pushj 17,f
	add 10,1
	jrst %L311

cai_lt_777777_loop:
	move 4,1
	caile 1,777776
	jrst %L319
	setca 1,
	addi 1,777777
%L320:
	add 2,4
	addi 4,1
	sojge 1,%L320	; doloop_end
%L319:
	add 4,2
	move 1,4
	popj 17,

cai_lt_777777_value:
	movei 6,777776
	camle 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cai_eq_777777:
	caie 1,777777
%L324:
	popj 17,
	movei 1,0
	popj 17,

cai_eq_777777_inv:
	caie 1,777777
	movei 1,0
	popj 17,

cai_eq_777777_call:
	caie 1,777777
%L329:
	popj 17,
	pushj 17,f
	addi 1,777777
	popj 17,

cai_eq_777777_loop:
	cain 1,777777
	jrst %L335
%L337:
	add 2,1
	move 1,2
	popj 17,
%L335:
	add 2,1
	addi 1,1
	cain 1,777777
	jrst %L335
	jrst %L337

cai_eq_777777_value:
	movei 6,777777
	came 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cai_le_777777:
	caig 1,777777
	movei 1,0
	popj 17,

cai_le_777777_inv:
	caile 1,777777
	movei 1,0
	popj 17,

cai_le_777777_call:
	push 17,10
	move 10,1
	caig 1,777777
	jrst %L346
%L345:
	move 1,10
	pop 17,10
	popj 17,
%L346:
	pushj 17,f
	add 10,1
	jrst %L345

cai_le_777777_loop:
	move 4,1
	caile 1,777777
	jrst %L353
	setca 1,
	add 1,[1000000]
%L354:
	add 2,4
	addi 4,1
	sojge 1,%L354	; doloop_end
%L353:
	add 4,2
	move 1,4
	popj 17,

cai_le_777777_value:
	movei 6,777777
	camle 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cai_ge_777777:
	caile 1,777776
	movei 1,0
	popj 17,

cai_ge_777777_inv:
	caig 1,777776
	movei 1,0
	popj 17,

cai_ge_777777_call:
	push 17,10
	move 10,1
	caile 1,777776
	jrst %L363
%L362:
	move 1,10
	pop 17,10
	popj 17,
%L363:
	pushj 17,f
	add 10,1
	jrst %L362

cai_ge_777777_loop:
	caig 1,777776
	jrst %L370
%L368:
	add 2,1
	addi 1,1
	caile 1,777776
	jrst %L368
%L370:
	add 2,1
	move 1,2
	popj 17,

cai_ge_777777_value:
	movei 6,777776
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cai_ne_777777:
	caie 1,777777
	movei 1,0
	popj 17,

cai_ne_777777_inv:
	caie 1,777777
%L376:
	popj 17,
	movei 1,0
	popj 17,

cai_ne_777777_call:
	push 17,10
	move 10,1
	cain 1,777777
	jrst %L379
	pushj 17,f
	add 10,1
%L379:
	move 1,10
	pop 17,10
	popj 17,

cai_ne_777777_loop:
	move 4,1
	cain 1,777777
	jrst %L386
	setca 1,
	addi 1,777777
%L387:
	add 2,4
	addi 4,1
	sojge 1,%L387	; doloop_end
%L386:
	add 4,2
	move 1,4
	popj 17,

cai_ne_777777_value:
	movei 6,777777
	camn 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cai_gt_777777:
	caile 1,777777
	movei 1,0
	popj 17,

cai_gt_777777_inv:
	caig 1,777777
	movei 1,0
	popj 17,

cai_gt_777777_call:
	push 17,10
	move 10,1
	caile 1,777777
	jrst %L396
%L395:
	move 1,10
	pop 17,10
	popj 17,
%L396:
	pushj 17,f
	add 10,1
	jrst %L395

cai_gt_777777_loop:
	caig 1,777777
	jrst %L403
%L401:
	add 2,1
	addi 1,1
	caile 1,777777
	jrst %L401
%L403:
	add 2,1
	move 1,2
	popj 17,

cai_gt_777777_value:
	movei 6,777777
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cai_chain:
	movei 4,1
	jumpl 1,%L406
	movei 4,2
	jumpe 1,%L406
	movei 4,3
	caig 1,1
	jrst %L406
	movei 4,4
	caile 1,777776
	jrst %L406
	movei 4,5
	cain 1,123456
	jrst %L413
%L406:
	move 1,4
	popj 17,
%L413:
	movei 4,123456
	jrst %L406

cai_chain_inverted:
	jumpl 1,%L421
	aoje 1,%L416
%L421:
	addi 1,2
%L416:
	caile 1,1
	addi 1,3
	caig 1,777776
	addi 1,4
	cain 1,123456
	jrst %L422
%L419:
	caig 1,123456
	addi 1,6
	popj 17,
%L422:
	movei 1,123463
	jrst %L419

cai_with_call_pressure:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 10,1
	move 11,2
	move 12,1
	add 12,2
	caig 1,123455
	jrst %L426
%L424:
	caile 11,777776
	jrst %L427
%L425:
	add 12,10
	add 12,11
	move 1,12
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,
%L427:
	pushj 17,clobber
	jrst %L425
%L426:
	pushj 17,clobber
	jrst %L424

cai_memory_loaded:
	move 1,(1)
	caie 1,123456
%L429:
	popj 17,
	movei 1,0
	popj 17,

cai_memory_loaded_inv:
	move 1,(1)
	caie 1,123456
	movei 1,0
	popj 17,

cai_volatile_loaded:
	move 1,(1)
	caig 1,123456
	movei 1,0
	popj 17,

cai_qi_signed:
	lsh 1,33
	ash 1,-33
	movei 6,1
	camle 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cai_qi_unsigned:
	ldb 1,[POINT 1,1,27]
	popj 17,

cai_hi_signed:
	hrre 1,1
	movei 6,123455
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cai_hi_unsigned:
	hrrzi 1,(1)	; zero_extendhisi2
	movei 6,777777
	camn 1,6
	tdza 1,1
	movei 1,1
	popj 17,

cai_reg_plus_const_lt:
	movei 4,1234(1)
	camge 4,2
	move 2,1
	move 1,2
	popj 17,

cai_reg_plus_const_eq:
	move 4,1
	caie 2,1234(1)
	move 4,2
	move 1,4
	popj 17,

cai_reg_plus_const_le:
	movei 4,1234(1)
	camle 4,2
	move 1,2
	popj 17,

cai_reg_plus_const_ge:
	movei 4,1234(1)
	camge 4,2
	move 1,2
	popj 17,

cai_reg_plus_const_ne:
	movei 4,1234(1)
	came 4,2
%L451:
	popj 17,
	move 1,4
	popj 17,

cai_reg_plus_const_gt:
	movei 4,1234(1)
	camle 4,2
	move 2,1
	move 1,2
	popj 17,

cai_const_plus_reg_lt:
	movei 4,1234(1)
	camge 2,4
	move 2,1
	move 1,2
	popj 17,

cai_const_plus_reg_eq:
	move 4,1
	caie 2,1234(1)
	move 4,2
	move 1,4
	popj 17,

cai_const_plus_reg_le:
	movei 4,1234(1)
	camle 2,4
	move 1,2
	popj 17,

cai_const_plus_reg_ge:
	movei 4,1234(1)
	camge 2,4
	move 1,2
	popj 17,

cai_const_plus_reg_ne:
	move 4,1
	cain 2,1234(1)
	jrst %L466
%L464:
	move 1,4
	popj 17,
%L466:
	move 4,2
	jrst %L464

cai_const_plus_reg_gt:
	movei 4,1234(1)
	camle 2,4
	move 2,1
	move 1,2
	popj 17,

cai_small_index:
	move 4,1
	add 4,2
	cain 2,1(1)
	jrst %L469
	move 4,1
	sub 4,2
%L469:
	move 1,4
	popj 17,

cai_large_index:
	movei 4,777777(1)
	move 3,1
	add 3,2
	camn 4,2
	jrst %L473
%L471:
	move 1,3
	popj 17,
%L473:
	move 3,1
	sub 3,4
	jrst %L471

