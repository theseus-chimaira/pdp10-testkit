
sum_loop_index:
	movei 3,0
	caml 3,2
	jrst %L9
	subi 2,1
%L10:
	move 4,(1)
	addi 1,1
	add 3,4
	sojge 2,%L10	; doloop_end
%L9:
	move 1,3
	popj 17,

sum_loop_index_sint:
	movei 3,0
	caml 3,2
	jrst %L19
	subi 2,1
%L20:
	move 4,(1)
	addi 1,1
	add 3,4
	sojge 2,%L20	; doloop_end
%L19:
	move 1,3
	popj 17,

sum_loop_index_offset:
	movei 6,0
	caml 6,2
	jrst %L29
	add 1,3
	subi 2,1
%L30:
	move 4,(1)
	addi 1,1
	add 6,4
	sojge 2,%L30	; doloop_end
%L29:
	move 1,6
	popj 17,

sum_loop_pointer:
	move 4,1
	add 2,1
	movei 3,0
	camn 1,2
	jrst %L38
	sub 2,1
	subi 2,1
%L39:
	add 3,(4)
	addi 4,1
	sojge 2,%L39	; doloop_end
%L38:
	move 1,3
	popj 17,

sum_loop_pointer_sint:
	move 4,1
	add 2,1
	movei 3,0
	camn 1,2
	jrst %L47
	sub 2,1
	subi 2,1
%L48:
	add 3,(4)
	addi 4,1
	sojge 2,%L48	; doloop_end
%L47:
	move 1,3
	popj 17,

sum_loop_pointer_preinc:
	move 4,1
	add 2,1
	movei 3,0
	camn 1,2
	jrst %L56
	sub 2,1
	subi 2,1
%L57:
	add 3,(4)
	addi 4,1
	sojge 2,%L57	; doloop_end
%L56:
	move 1,3
	popj 17,

sum_loop_pointer_for:
	move 4,1
	add 2,1
	movei 3,0
	camn 1,2
	jrst %L66
	sub 2,1
	subi 2,1
%L67:
	add 3,(4)
	addi 4,1
	sojge 2,%L67	; doloop_end
%L66:
	move 1,3
	popj 17,

sum_loop_pointer_less:
	move 4,1
	add 2,1
	movei 3,0
	caml 1,2
	jrst %L75
	sub 2,1
	subi 2,1
%L76:
	add 3,(4)
	addi 4,1
	sojge 2,%L76	; doloop_end
%L75:
	move 1,3
	popj 17,

sum_loop_pointer_guarded:
	movei 4,0
	jumple 2,%L77
	move 4,1
	add 4,2
	movei 3,0
	move 2,4
	sub 2,1
	camn 1,4
	jrst %L86
%L85:
	move 4,2
	subi 4,1
%L84:
	add 3,(1)
	addi 1,1
	sojge 4,%L84	; doloop_end
	move 4,3
%L77:
	move 1,4
	popj 17,
%L86:
	movei 2,1
	jrst %L85

sum_loop_index_guarded:
	move 4,1
	movei 1,0
	jumple 2,%L87
	movei 3,0
	caml 3,2
	jrst %L96
	move 1,4
	subi 2,1
%L97:
	move 4,(1)
	addi 1,1
	add 3,4
	sojge 2,%L97	; doloop_end
%L96:
	move 1,3
%L87:
	popj 17,

sum_loop_index_from_one:
	movei 3,0
	jumple 2,%L106
	subi 2,1
%L107:
	move 4,(1)
	addi 1,1
	add 3,4
	sojge 2,%L107	; doloop_end
%L106:
	move 1,3
	popj 17,

sum_loop_index_decrement_count:
	movei 3,0
	move 4,2
	subi 2,1
	jumple 4,%L114
%L112:
	add 3,(1)
	addi 1,1
	move 4,2
	subi 2,1
	jumpg 4,%L112
%L114:
	move 1,3
	popj 17,

sum_loop_index_countdown:
	movei 4,0
	jumple 2,%L122
%L120:
	add 4,(1)
	addi 1,1
	sojg 2,%L120	; decrement_and_branch_until_zero
%L122:
	move 1,4
	popj 17,

sum_loop_two_accumulators:
	movei 7,0
	setzb 6,3
	caml 7,2
	jrst %L131
	subi 2,1
%L132:
	move 4,(1)
	addi 1,1
	add 7,4
	add 6,3
	addi 3,1
	sojge 2,%L132	; doloop_end
%L131:
	add 7,6
	move 1,7
	popj 17,

sum_loop_with_seed:
	jumple 2,%L141
	subi 2,1
%L142:
	move 4,(1)
	addi 1,1
	add 3,4
	sojge 2,%L142	; doloop_end
%L141:
	move 1,3
	popj 17,

sum_loop_with_call_after:
	push 17,10
	movei 10,0
	caml 10,2
	jrst %L151
	subi 2,1
%L152:
	move 4,(1)
	addi 1,1
	add 10,4
	sojge 2,%L152	; doloop_end
%L151:
	move 1,10
	pushj 17,sink_int
	move 1,10
	pop 17,10
	popj 17,

sum_loop_pointer_with_call_after:
	push 17,10
	move 4,1
	add 2,1
	movei 10,0
	camn 1,2
	jrst %L160
	sub 2,1
	subi 2,1
%L161:
	add 10,(4)
	addi 4,1
	sojge 2,%L161	; doloop_end
%L160:
	move 1,10
	pushj 17,sink_int
	move 1,10
	pop 17,10
	popj 17,

copy_loop_index:
	jumple 3,%L171
	subi 3,1
%L172:
	move 6,(2)
	movem 6,(1)
	addi 2,1
	addi 1,1
	sojge 3,%L172	; doloop_end
%L171:
	popj 17,

copy_loop_pointer:
	move 4,2
	add 3,2
	camn 2,3
	popj 17,
	sub 3,2
	subi 3,1
%L181:
	move 6,(4)
	movem 6,(1)
	addi 4,1
	addi 1,1
	sojge 3,%L181	; doloop_end
	popj 17,

copy_loop_pointer_dest_end:
	move 4,1
	add 3,1
	camn 1,3
	popj 17,
	sub 3,1
	subi 3,1
%L190:
	move 6,(2)
	movem 6,(4)
	addi 2,1
	addi 4,1
	sojge 3,%L190	; doloop_end
	popj 17,

copy_loop_index_sint:
	jumple 3,%L200
	subi 3,1
%L201:
	move 6,(2)
	movem 6,(1)
	addi 2,1
	addi 1,1
	sojge 3,%L201	; doloop_end
%L200:
	popj 17,

copy_loop_index_sum:
	movei 4,0
	caml 4,3
	jrst %L212
	subi 3,1
%L213:
	move 6,(2)
	movem 6,(1)
	addi 2,1
	add 4,6
	addi 1,1
	sojge 3,%L213	; doloop_end
%L212:
	move 1,4
	popj 17,

copy_loop_pointer_sum:
	move 4,2
	add 3,2
	movei 6,0
	camn 2,3
	jrst %L221
	sub 3,2
	subi 3,1
%L222:
	move 7,(4)
	movem 7,(1)
	add 6,7
	addi 1,1
	addi 4,1
	sojge 3,%L222	; doloop_end
%L221:
	move 1,6
	popj 17,

fill_loop_index:
	jumple 2,%L231
	subi 2,1
%L232:
	movem 3,(1)
	addi 1,1
	sojge 2,%L232	; doloop_end
%L231:
	popj 17,

fill_loop_pointer:
	move 4,1
	add 2,1
	camn 1,2
	popj 17,
	sub 2,1
	subi 2,1
%L241:
	movem 3,(4)
	addi 4,1
	sojge 2,%L241	; doloop_end
	popj 17,

zero_loop_index:
	jumple 2,%L250
	subi 2,1
%L251:
	setzm (1)
	addi 1,1
	sojge 2,%L251	; doloop_end
%L250:
	popj 17,

zero_loop_pointer:
	move 4,1
	add 2,1
	camn 1,2
	popj 17,
	sub 2,1
	subi 2,1
%L260:
	setzm (4)
	addi 4,1
	sojge 2,%L260	; doloop_end
	popj 17,

update_loop_index:
	movei 6,0
	caml 6,2
	jrst %L271
	subi 2,1
%L272:
	move 4,3
	addb 4,(1)
	add 6,4
	addi 1,1
	sojge 2,%L272	; doloop_end
%L271:
	move 1,6
	popj 17,

update_loop_pointer:
	move 6,1
	add 2,1
	movei 7,0
	camn 1,2
	jrst %L280
	sub 2,1
	subi 2,1
%L281:
	move 4,3
	addb 4,(6)
	add 7,4
	addi 6,1
	sojge 2,%L281	; doloop_end
%L280:
	move 1,7
	popj 17,

and_loop_index:
	movei 6,0
	caml 6,2
	jrst %L290
	subi 2,1
%L291:
	move 4,(1)
	addi 1,1
	and 4,3
	add 6,4
	sojge 2,%L291	; doloop_end
%L290:
	move 1,6
	popj 17,

xor_loop_index:
	movei 6,0
	caml 6,2
	jrst %L300
	subi 2,1
%L301:
	move 4,(1)
	addi 1,1
	xor 4,3
	xor 6,4
	sojge 2,%L301	; doloop_end
%L300:
	move 1,6
	popj 17,

find_loop:
	movei 6,0
	caml 6,2
	jrst %L311
%L309:
	move 4,(1)
	addi 1,1
	move 7,6
	camn 4,3
	jrst %L302
	addi 6,1
	camge 6,2
	jrst %L309
%L311:
	seto 7,
%L302:
	move 1,7
	popj 17,

find_loop_pointer:
	move 4,1
	add 2,1
	camn 1,2
	jrst %L322
	sub 1,1
%L320:
	move 6,1
	move 7,(4)
	camn 7,3
	jrst %L312
	addi 1,1
	addi 4,1
	came 4,2
	jrst %L320
%L322:
	seto 6,
%L312:
	move 1,6
	popj 17,

find_loop_pointer_less:
	move 4,1
	add 2,1
	caml 1,2
	jrst %L333
	sub 1,1
%L331:
	move 6,1
	move 7,(4)
	camn 7,3
	jrst %L323
	addi 1,1
	addi 4,1
	camge 4,2
	jrst %L331
%L333:
	seto 6,
%L323:
	move 1,6
	popj 17,

find_nonzero_index:
	movei 3,0
	caml 3,2
	jrst %L343
%L341:
	move 4,(1)
	addi 1,1
	move 6,3
	jumpn 4,%L334
	addi 3,1
	camge 3,2
	jrst %L341
%L343:
	seto 6,
%L334:
	move 1,6
	popj 17,

find_nonzero_pointer:
	move 4,1
	add 2,1
	camn 1,2
	jrst %L354
	sub 1,1
%L352:
	move 3,1
	skipe (4)
	jrst %L344
	addi 1,1
	addi 4,1
	came 4,2
	jrst %L352
%L354:
	seto 3,
%L344:
	move 1,3
	popj 17,

count_equal_index:
	movei 6,0
	caml 6,2
	jrst %L364
	subi 2,1
%L365:
	move 4,(1)
	addi 1,1
	camn 4,3
	jrst %L366
%L358:
	sojge 2,%L365	; doloop_end
%L364:
	move 1,6
	popj 17,
%L366:
	aoja 6,%L358

count_equal_pointer:
	move 4,1
	add 2,1
	movei 6,0
	camn 1,2
	jrst %L375
	sub 2,1
	subi 2,1
%L376:
	move 7,(4)
	camn 7,3
	jrst %L377
%L372:
	addi 4,1
	sojge 2,%L376	; doloop_end
%L375:
	move 1,6
	popj 17,
%L377:
	aoja 6,%L372

compare_loop_index:
	move 5,3
	movei 6,0
	caml 6,3
	jrst %L388
%L386:
	move 3,(1)
	addi 1,1
	move 4,(2)
	addi 2,1
	move 7,6
	addi 7,1
	came 3,4
	jrst %L378
	move 6,7
	camge 7,5
	jrst %L386
%L388:
	movei 7,0
%L378:
	move 1,7
	popj 17,

compare_loop_pointer:
	move 4,1
	add 3,1
	camn 1,3
	jrst %L399
	sub 1,1
%L397:
	move 6,(4)
	came 6,(2)
	jrst %L400
	addi 1,1
	addi 4,1
	addi 2,1
	came 4,3
	jrst %L397
%L399:
	movei 1,0
%L389:
	popj 17,
%L400:
	aoja 1,%L389

checksum_loop_index:
	movei 6,123456
	movei 3,0
	caml 3,2
	jrst %L409
	subi 2,1
%L410:
	move 4,(1)
	addi 1,1
	add 6,4
	move 4,3
	addi 4,1
	xor 6,4
	move 3,4
	sojge 2,%L410	; doloop_end
%L409:
	move 1,6
	popj 17,

checksum_loop_pointer:
	move 3,1
	add 2,1
	movei 6,123456
	movei 4,0
	camn 1,2
	jrst %L418
	sub 2,1
	subi 2,1
%L419:
	add 6,(3)
	addi 4,1
	xor 6,4
	addi 3,1
	sojge 2,%L419	; doloop_end
%L418:
	move 1,6
	popj 17,

loop_with_continue:
	setzb 3,4
	caml 3,2
	jrst %L429
	subi 2,1
%L430:
	trnn 4,1
	add 3,(1)
	addi 1,1
	addi 4,1
	sojge 2,%L430	; doloop_end
%L429:
	move 1,3
	popj 17,

loop_with_break:
	setzb 6,3
	caml 6,2
	jrst %L433
%L439:
	move 4,(1)
	addi 1,1
	jumpe 4,%L433
	add 6,4
	addi 3,1
	camge 3,2
	jrst %L439
%L433:
	move 1,6
	popj 17,

pointer_loop_with_continue:
	move 4,1
	add 2,1
	setzb 6,3
	camn 1,2
	jrst %L449
	sub 2,1
	subi 2,1
%L450:
	trnn 3,1
	add 6,(4)
	addi 4,1
	addi 3,1
	sojge 2,%L450	; doloop_end
%L449:
	move 1,6
	popj 17,

pointer_loop_with_break:
	add 2,1
	movei 3,0
	camn 1,2
	jrst %L454
%L457:
	skipn 4,(1)
	jrst %L454
	add 3,4
	addi 1,1
	came 1,2
	jrst %L457
%L454:
	move 1,3
	popj 17,

nested_small_loop:
	move 5,1
	setzb 1,7
	caml 1,2
	popj 17,
%L470:
	move 3,7
	movei 6,3
%L475:
	move 4,3
	andi 4,17
	add 4,5
	add 1,(4)
	addi 3,1
	sojge 6,%L475	; doloop_end
	addi 7,1
	camge 7,2
	jrst %L470
	popj 17,

copy_nested_rows:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 1,2
	jumple 3,%L490
	movei 2,0
	subi 3,1
%L494:
	jumple 4,%L492
	move 5,2
	add 5,10
	move 7,2
	add 7,1
	move 6,4
	subi 6,1
%L493:
	move 11,(7)
	movem 11,(5)
	addi 7,1
	addi 5,1
	sojge 6,%L493	; doloop_end
%L492:
	add 2,4
	sojge 3,%L494	; doloop_end
%L490:
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

sum_loop_stride2:
	movei 6,0
	caml 6,2
	jrst %L503
	move 4,2
	lsh 4,-1
	trne 2,1
	addi 4,1
	move 3,4
	subi 3,1
%L504:
	move 4,(1)
	addi 1,2
	add 6,4
	sojge 3,%L504	; doloop_end
%L503:
	move 1,6
	popj 17,

sum_loop_reverse_index:
	movei 3,0
	sojl 2,%L514	; decrement_and_branch_until_zero
	add 1,2
%L512:
	move 4,(1)
	subi 1,1
	add 3,4
	sojge 2,%L512	; decrement_and_branch_until_zero
%L514:
	move 1,3
	popj 17,

sum_loop_reverse_pointer:
	add 2,1
	movei 4,0
	camn 2,1
	jrst %L522
	move 6,2
	sub 6,1
	move 1,6
	subi 1,1
%L523:
	subi 2,1
	add 4,(2)
	sojge 1,%L523	; doloop_end
%L522:
	move 1,4
	popj 17,

sum_loop_scaled_index:
	movei 6,0
	caml 6,2
	jrst %L532
	subi 2,1
%L533:
	move 4,(1)
	add 1,3
	add 6,4
	sojge 2,%L533	; doloop_end
%L532:
	move 1,6
	popj 17,

copy_loop_stride2:
	movei 6,0
	caml 6,3
	jrst %L544
	move 4,3
	lsh 4,-1
	trne 3,1
	addi 4,1
	subi 4,1
%L545:
	move 7,(2)
	movem 7,(1)
	addi 2,2
	add 6,7
	addi 1,2
	sojge 4,%L545	; doloop_end
%L544:
	move 1,6
	popj 17,

sum_loop_volatile:
	movei 3,0
	caml 3,2
	jrst %L555
	subi 2,1
%L556:
	move 4,(1)
	add 3,4
	addi 1,1
	sojge 2,%L556	; doloop_end
%L555:
	move 1,3
	popj 17,

copy_loop_volatile:
	jumple 3,%L566
	subi 3,1
%L567:
	move 6,(2)
	movem 6,(1)
	addi 2,1
	addi 1,1
	sojge 3,%L567	; doloop_end
%L566:
	popj 17,

sum_loop_with_sink:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	movei 12,0
	caml 12,2
	jrst %L576
	move 11,1
	move 10,2
%L574:
	move 4,(11)
	addi 11,1
	add 12,4
	move 1,12
	pushj 17,sink_int
	sojn 10,%L574	; decrement_and_branch_until_zero
%L576:
	move 1,12
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

copy_loop_with_sink:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 11,1
	move 13,2
	move 12,3
	movei 10,0
	camge 10,3
	jrst %L584
%L586:
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,
%L584:
	move 4,11
	add 4,10
	move 3,13
	add 3,10
	move 3,(3)
	movem 3,(4)
	addi 10,1
	move 1,11
	move 2,10
	pushj 17,sink_words
	camge 10,12
	jrst %L584
	jrst %L586

