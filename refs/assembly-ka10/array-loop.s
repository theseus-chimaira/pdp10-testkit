
baz:
	setzb 2,bar+1
	movei 3,11
%L9:
	move 4,2
	lsh 4,1
	setzm bar+1(4)
	addi 2,1
	sojge 3,%L9	; doloop_end
	popj 17,

smf_zero_y_10:
	movei 2,0
	movei 3,11
%L18:
	move 4,2
	lsh 4,1
	setzm bar+1(4)
	addi 2,1
	sojge 3,%L18	; doloop_end
	popj 17,

smf_zero_x_10:
	movei 2,0
	movei 3,11
%L27:
	move 4,2
	lsh 4,1
	setzm bar(4)
	addi 2,1
	sojge 3,%L27	; doloop_end
	popj 17,

smf_zero_both_10:
	movei 2,0
	movei 3,11
%L36:
	move 4,2
	lsh 4,1
	setzm bar(4)
	setzm bar+1(4)
	addi 2,1
	sojge 3,%L36	; doloop_end
	popj 17,

smf_set_y_index_10:
	movei 3,0
	movei 2,11
%L45:
	move 4,3
	lsh 4,1
	movem 3,bar+1(4)
	addi 3,1
	sojge 2,%L45	; doloop_end
	popj 17,

smf_set_x_plus_y_10:
	movei 3,0
	movei 2,11
%L54:
	move 4,3
	lsh 4,1
	move 6,bar+1(4)
	add 6,3
	movem 6,bar(4)
	addi 3,1
	sojge 2,%L54	; doloop_end
	popj 17,

smf_sum_y_10:
	setzb 1,2
	movei 3,11
%L63:
	move 4,2
	lsh 4,1
	add 1,bar+1(4)
	addi 2,1
	sojge 3,%L63	; doloop_end
	popj 17,

smf_sum_xy_10:
	setzb 1,2
	movei 3,11
%L72:
	move 4,2
	lsh 4,1
	move 6,bar(4)
	add 6,bar+1(4)
	add 1,6
	addi 2,1
	sojge 3,%L72	; doloop_end
	popj 17,

smf_count_nonzero_y_10:
	setzb 1,2
	movei 3,11
%L82:
	move 4,2
	lsh 4,1
	skipe bar+1(4)
	addi 1,1
	addi 2,1
	sojge 3,%L82	; doloop_end
	popj 17,

smf_zero_y_reverse_10:
	movei 3,11
%L88:
	move 4,3
	lsh 4,1
	setzm bar+1(4)
	sojge 3,%L88	; decrement_and_branch_until_zero
	popj 17,

smf_sum_y_reverse_10:
	movei 1,0
	movei 3,11
%L96:
	move 4,3
	lsh 4,1
	add 1,bar+1(4)
	sojge 3,%L96	; decrement_and_branch_until_zero
	popj 17,

smf_zero_y_countdown_10:
	movei 3,12
%L103:
	sos 4,3
	lsh 4,1
	setzm bar+1(4)
	jumpg 3,%L103
	popj 17,

smf_sum_y_countdown_10:
	movei 3,12
	movei 1,0
%L110:
	sos 4,3
	lsh 4,1
	add 1,bar+1(4)
	jumpg 3,%L110
	popj 17,

smf_zero_y_n:
	movei 3,0
	caml 3,1
	popj 17,
	subi 1,1
%L121:
	move 4,3
	andi 4,37
	lsh 4,1
	setzm smf_big+1(4)
	addi 3,1
	sojge 1,%L121	; doloop_end
	popj 17,

smf_set_y_n:
	movei 3,0
	caml 3,1
	popj 17,
	subi 1,1
%L130:
	move 4,3
	andi 4,37
	lsh 4,1
	movem 2,smf_big+1(4)
	addi 3,1
	sojge 1,%L130	; doloop_end
	popj 17,

smf_sum_y_n:
	setzb 2,3
	caml 2,1
	jrst %L138
	subi 1,1
%L139:
	move 4,3
	andi 4,37
	lsh 4,1
	add 2,smf_big+1(4)
	addi 3,1
	sojge 1,%L139	; doloop_end
%L138:
	move 1,2
	popj 17,

smf_sum_x_y_n:
	setzb 2,3
	caml 2,1
	jrst %L147
	subi 1,1
%L148:
	move 4,3
	andi 4,37
	lsh 4,1
	move 6,smf_big(4)
	add 6,smf_big+1(4)
	add 2,6
	addi 3,1
	sojge 1,%L148	; doloop_end
%L147:
	move 1,2
	popj 17,

smf_zero_y_n_reverse:
	jumple 1,%L155
%L153:
	sos 4,1
	andi 4,37
	lsh 4,1
	setzm smf_big+1(4)
	jumpg 1,%L153
%L155:
	popj 17,

smf_find_first_y:
	move 6,1
	movei 3,0
	caml 3,1
	jrst %L164
%L162:
	move 4,3
	andi 4,37
	lsh 4,1
	move 1,3
	move 4,smf_big+1(4)
	camn 4,2
	popj 17,
	addi 3,1
	camge 3,6
	jrst %L162
%L164:
	seto 1,
	popj 17,

smf_volatile_zero_y_10:
	movei 2,0
	movei 3,11
%L173:
	move 4,2
	lsh 4,1
	setzm smf_vbig+1(4)
	addi 2,1
	sojge 3,%L173	; doloop_end
	popj 17,

smf_volatile_sum_y_10:
	setzb 1,2
	movei 3,11
%L182:
	move 4,2
	lsh 4,1
	move 4,smf_vbig+1(4)
	add 1,4
	addi 2,1
	sojge 3,%L182	; doloop_end
	popj 17,

smf_volatile_set_y_n:
	movei 3,0
	caml 3,1
	popj 17,
	subi 1,1
%L191:
	move 4,3
	andi 4,37
	lsh 4,1
	movem 2,smf_vbig+1(4)
	addi 3,1
	sojge 1,%L191	; doloop_end
	popj 17,

s_zero_32:
	movei 3,0
	movei 4,37
%L200:
	setzm s_arr(3)
	addi 3,1
	sojge 4,%L200	; doloop_end
	popj 17,

s_set_index_32:
	movei 4,0
	movei 3,37
%L209:
	movem 4,s_arr(4)
	addi 4,1
	sojge 3,%L209	; doloop_end
	popj 17,

s_set_value_32:
	movei 3,0
	movei 4,37
%L218:
	movem 1,s_arr(3)
	addi 3,1
	sojge 4,%L218	; doloop_end
	popj 17,

s_sum_32:
	setzb 1,3
	movei 4,37
%L227:
	add 1,s_arr(3)
	addi 3,1
	sojge 4,%L227	; doloop_end
	popj 17,

s_sum_n:
	setzb 2,3
	caml 2,1
	jrst %L235
	subi 1,1
%L236:
	move 4,3
	andi 4,77
	add 2,s_arr(4)
	addi 3,1
	sojge 1,%L236	; doloop_end
%L235:
	move 1,2
	popj 17,

s_copy_32:
	movei 4,37
%L247:
	move 6,(2)
	movem 6,(1)
	addi 2,1
	addi 1,1
	sojge 4,%L247	; doloop_end
	popj 17,

s_add_arrays_32:
	move 6,3
	movei 7,37
%L259:
	move 3,(2)
	addi 2,1
	move 4,(6)
	addi 6,1
	add 3,4
	movem 3,(1)
	addi 1,1
	sojge 7,%L259	; doloop_end
	popj 17,

s_zero_even_32:
	movei 3,0
	movei 4,17
%L268:
	setzm s_arr(3)
	addi 3,2
	sojge 4,%L268	; doloop_end
	popj 17,

s_zero_stride3_30:
	movei 3,0
	movei 4,11
%L277:
	setzm s_arr(3)
	addi 3,3
	sojge 4,%L277	; doloop_end
	popj 17,

s_sum_reverse_32:
	movei 1,0
	movei 4,37
%L283:
	add 1,s_arr(4)
	sojge 4,%L283	; decrement_and_branch_until_zero
	popj 17,

us_zero_32:
	movei 3,0
	movei 4,37
%L294:
	setzm us_arr(3)
	addi 3,1
	sojge 4,%L294	; doloop_end
	popj 17,

us_set_index_32:
	movei 4,0
	movei 3,37
%L303:
	movem 4,us_arr(4)
	addi 4,1
	sojge 3,%L303	; doloop_end
	popj 17,

us_sum_32:
	setzb 1,3
	movei 4,37
%L312:
	add 1,us_arr(3)
	addi 3,1
	sojge 4,%L312	; doloop_end
	popj 17,

us_copy_32:
	movei 4,37
%L323:
	move 6,(2)
	movem 6,(1)
	addi 2,1
	addi 1,1
	sojge 4,%L323	; doloop_end
	popj 17,

q_zero_32:
	setzb 2,6
	movei 1,37
%L334:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,q_arr,8]
	jumpe 4,%L330
%L329:
	ibp 3
	sojn 4,%L329	; decrement_and_branch_until_zero
%L330:
	dpb 6,3
	addi 2,1
	sojge 1,%L334	; doloop_end
	popj 17,

q_set_index_32:
	movei 2,0
	movei 1,37
%L345:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,q_arr,8]
	jumpe 4,%L341
%L340:
	ibp 3
	sojn 4,%L340	; decrement_and_branch_until_zero
%L341:
	dpb 2,3
	addi 2,1
	sojge 1,%L345	; doloop_end
	popj 17,

q_set_value_32:
	andi 1,777	; zero_extendqisi2
	movei 2,0
	movei 6,37
%L356:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,q_arr,8]
	jumpe 4,%L352
%L351:
	ibp 3
	sojn 4,%L351	; decrement_and_branch_until_zero
%L352:
	dpb 1,3
	addi 2,1
	sojge 6,%L356	; doloop_end
	popj 17,

q_sum_32:
	setzb 1,2
	movei 6,37
%L367:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,q_arr,8]
	jumpe 4,%L363
%L362:
	ibp 3
	sojn 4,%L362	; decrement_and_branch_until_zero
%L363:
	ldb 4,3
	trne 4,400
	orcmi 4,777
	add 1,4
	addi 2,1
	sojge 6,%L367	; doloop_end
	popj 17,

q_sum_n:
	setzb 6,2
	caml 6,1
	jrst %L377
	subi 1,1
%L378:
	move 3,2
	andi 3,77
	move 4,2
	andi 4,3
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,q_arr,8]
	jumpe 4,%L374
%L373:
	ibp 3
	sojn 4,%L373	; decrement_and_branch_until_zero
%L374:
	ldb 4,3
	trne 4,400
	orcmi 4,777
	add 6,4
	addi 2,1
	sojge 1,%L378	; doloop_end
%L377:
	move 1,6
	popj 17,

q_copy_32:
	push 17,10
	move 10,1
	move 1,2
	movei 5,0
	movei 2,37
%L393:
	move 7,5
	andi 7,3
	move 3,7
	move 4,5
	ash 4,-2	; ashrsi3_pointer
	move 6,10
	add 6,4
	jumpe 7,%L386
%L385:
	ibp 6
	sojn 3,%L385	; decrement_and_branch_until_zero
%L386:
	add 4,1
	skipn 3,7
	jrst %L389
%L388:
	ibp 4
	sojn 3,%L388	; decrement_and_branch_until_zero
%L389:
	ldb 4,4
	dpb 4,6
	addi 5,1
	sojge 2,%L393	; doloop_end
	pop 17,10
	popj 17,

q_zero_even_32:
	setzb 2,6
	movei 1,17
%L404:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,q_arr,8]
	jumpe 4,%L400
%L399:
	ibp 3
	sojn 4,%L399	; decrement_and_branch_until_zero
%L400:
	dpb 6,3
	addi 2,2
	sojge 1,%L404	; doloop_end
	popj 17,

q_zero_stride3_30:
	setzb 2,6
	movei 1,11
%L415:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,q_arr,8]
	jumpe 4,%L411
%L410:
	ibp 3
	sojn 4,%L410	; decrement_and_branch_until_zero
%L411:
	dpb 6,3
	addi 2,3
	sojge 1,%L415	; doloop_end
	popj 17,

q_sum_reverse_32:
	movei 1,0
	movei 2,37
%L423:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,q_arr,8]
	jumpe 4,%L422
%L421:
	ibp 3
	sojn 4,%L421	; decrement_and_branch_until_zero
%L422:
	ldb 4,3
	trne 4,400
	orcmi 4,777
	add 1,4
	sojge 2,%L423	; decrement_and_branch_until_zero
	popj 17,

uq_zero_32:
	setzb 2,6
	movei 1,37
%L436:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,uq_arr,8]
	jumpe 4,%L432
%L431:
	ibp 3
	sojn 4,%L431	; decrement_and_branch_until_zero
%L432:
	dpb 6,3
	addi 2,1
	sojge 1,%L436	; doloop_end
	popj 17,

uq_set_index_32:
	movei 2,0
	movei 1,37
%L447:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,uq_arr,8]
	jumpe 4,%L443
%L442:
	ibp 3
	sojn 4,%L442	; decrement_and_branch_until_zero
%L443:
	dpb 2,3
	addi 2,1
	sojge 1,%L447	; doloop_end
	popj 17,

uq_sum_32:
	setzb 1,2
	movei 6,37
%L458:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,uq_arr,8]
	jumpe 4,%L454
%L453:
	ibp 3
	sojn 4,%L453	; decrement_and_branch_until_zero
%L454:
	ldb 3,3
	add 1,3
	addi 2,1
	sojge 6,%L458	; doloop_end
	popj 17,

uq_copy_32:
	push 17,10
	move 10,1
	move 1,2
	movei 5,0
	movei 2,37
%L473:
	move 7,5
	andi 7,3
	move 3,7
	move 4,5
	ash 4,-2	; ashrsi3_pointer
	move 6,10
	add 6,4
	jumpe 7,%L466
%L465:
	ibp 6
	sojn 3,%L465	; decrement_and_branch_until_zero
%L466:
	add 4,1
	skipn 3,7
	jrst %L469
%L468:
	ibp 4
	sojn 3,%L468	; decrement_and_branch_until_zero
%L469:
	ldb 4,4
	dpb 4,6
	addi 5,1
	sojge 2,%L473	; doloop_end
	pop 17,10
	popj 17,

h_zero_32:
	setzb 2,6
	movei 1,37
%L484:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,h_arr,17]
	jumpe 4,%L480
%L479:
	ibp 3
	sojn 4,%L479	; decrement_and_branch_until_zero
%L480:
	dpb 6,3	; movhi
	addi 2,1
	sojge 1,%L484	; doloop_end
	popj 17,

h_set_index_32:
	movei 2,0
	movei 1,37
%L495:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,h_arr,17]
	jumpe 4,%L491
%L490:
	ibp 3
	sojn 4,%L490	; decrement_and_branch_until_zero
%L491:
	dpb 2,3	; movhi
	addi 2,1
	sojge 1,%L495	; doloop_end
	popj 17,

h_set_value_32:
	hrrzi 1,(1)	; zero_extendhisi2
	movei 2,0
	movei 6,37
%L506:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,h_arr,17]
	jumpe 4,%L502
%L501:
	ibp 3
	sojn 4,%L501	; decrement_and_branch_until_zero
%L502:
	dpb 1,3	; movhi
	addi 2,1
	sojge 6,%L506	; doloop_end
	popj 17,

h_sum_32:
	setzb 1,2
	movei 6,37
%L517:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,h_arr,17]
	jumpe 4,%L513
%L512:
	ibp 3
	sojn 4,%L512	; decrement_and_branch_until_zero
%L513:
	ldb 4,3
	hrre 4,4
	add 1,4
	addi 2,1
	sojge 6,%L517	; doloop_end
	popj 17,

h_sum_n:
	setzb 6,2
	caml 6,1
	jrst %L527
	subi 1,1
%L528:
	move 3,2
	andi 3,77
	move 4,2
	andi 4,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,h_arr,17]
	jumpe 4,%L524
%L523:
	ibp 3
	sojn 4,%L523	; decrement_and_branch_until_zero
%L524:
	ldb 4,3
	hrre 4,4
	add 6,4
	addi 2,1
	sojge 1,%L528	; doloop_end
%L527:
	move 1,6
	popj 17,

h_copy_32:
	push 17,10
	move 10,1
	move 1,2
	movei 5,0
	movei 2,37
%L543:
	move 7,5
	andi 7,1
	move 3,7
	move 4,5
	ash 4,-1	; ashrsi3_pointer
	move 6,10
	add 6,4
	jumpe 7,%L536
%L535:
	ibp 6
	sojn 3,%L535	; decrement_and_branch_until_zero
%L536:
	add 4,1
	skipn 3,7
	jrst %L539
%L538:
	ibp 4
	sojn 3,%L538	; decrement_and_branch_until_zero
%L539:
	ldb 4,4
	dpb 4,6	; movhi
	addi 5,1
	sojge 2,%L543	; doloop_end
	pop 17,10
	popj 17,

h_zero_even_32:
	setzb 2,6
	movei 1,17
%L554:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,h_arr,17]
	jumpe 4,%L550
%L549:
	ibp 3
	sojn 4,%L549	; decrement_and_branch_until_zero
%L550:
	dpb 6,3	; movhi
	addi 2,2
	sojge 1,%L554	; doloop_end
	popj 17,

h_sum_reverse_32:
	movei 1,0
	movei 2,37
%L562:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,h_arr,17]
	jumpe 4,%L561
%L560:
	ibp 3
	sojn 4,%L560	; decrement_and_branch_until_zero
%L561:
	ldb 4,3
	hrre 4,4
	add 1,4
	sojge 2,%L562	; decrement_and_branch_until_zero
	popj 17,

uh_zero_32:
	setzb 2,6
	movei 1,37
%L575:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,uh_arr,17]
	jumpe 4,%L571
%L570:
	ibp 3
	sojn 4,%L570	; decrement_and_branch_until_zero
%L571:
	dpb 6,3	; movhi
	addi 2,1
	sojge 1,%L575	; doloop_end
	popj 17,

uh_set_index_32:
	movei 2,0
	movei 1,37
%L586:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,uh_arr,17]
	jumpe 4,%L582
%L581:
	ibp 3
	sojn 4,%L581	; decrement_and_branch_until_zero
%L582:
	dpb 2,3	; movhi
	addi 2,1
	sojge 1,%L586	; doloop_end
	popj 17,

uh_sum_32:
	setzb 1,2
	movei 6,37
%L597:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,uh_arr,17]
	jumpe 4,%L593
%L592:
	ibp 3
	sojn 4,%L592	; decrement_and_branch_until_zero
%L593:
	ldb 3,3
	add 1,3
	addi 2,1
	sojge 6,%L597	; doloop_end
	popj 17,

uh_copy_32:
	push 17,10
	move 10,1
	move 1,2
	movei 5,0
	movei 2,37
%L612:
	move 7,5
	andi 7,1
	move 3,7
	move 4,5
	ash 4,-1	; ashrsi3_pointer
	move 6,10
	add 6,4
	jumpe 7,%L605
%L604:
	ibp 6
	sojn 3,%L604	; decrement_and_branch_until_zero
%L605:
	add 4,1
	skipn 3,7
	jrst %L608
%L607:
	ibp 4
	sojn 3,%L607	; decrement_and_branch_until_zero
%L608:
	ldb 4,4
	dpb 4,6	; movhi
	addi 5,1
	sojge 2,%L612	; doloop_end
	pop 17,10
	popj 17,

c_zero_32:
	setzb 2,6
	movei 1,37
%L623:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,c_arr,8]
	jumpe 4,%L619
%L618:
	ibp 3
	sojn 4,%L618	; decrement_and_branch_until_zero
%L619:
	dpb 6,3
	addi 2,1
	sojge 1,%L623	; doloop_end
	popj 17,

c_set_index_32:
	movei 2,0
	movei 1,37
%L634:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,c_arr,8]
	jumpe 4,%L630
%L629:
	ibp 3
	sojn 4,%L629	; decrement_and_branch_until_zero
%L630:
	dpb 2,3
	addi 2,1
	sojge 1,%L634	; doloop_end
	popj 17,

c_sum_32:
	setzb 1,2
	movei 6,37
%L645:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,c_arr,8]
	jumpe 4,%L641
%L640:
	ibp 3
	sojn 4,%L640	; decrement_and_branch_until_zero
%L641:
	ldb 3,3
	add 1,3
	addi 2,1
	sojge 6,%L645	; doloop_end
	popj 17,

c_copy_32:
	push 17,10
	move 10,1
	move 1,2
	movei 5,0
	movei 2,37
%L660:
	move 7,5
	andi 7,3
	move 3,7
	move 4,5
	ash 4,-2	; ashrsi3_pointer
	move 6,10
	add 6,4
	jumpe 7,%L653
%L652:
	ibp 6
	sojn 3,%L652	; decrement_and_branch_until_zero
%L653:
	add 4,1
	skipn 3,7
	jrst %L656
%L655:
	ibp 4
	sojn 3,%L655	; decrement_and_branch_until_zero
%L656:
	ldb 4,4
	dpb 4,6
	addi 5,1
	sojge 2,%L660	; doloop_end
	pop 17,10
	popj 17,

qpair_zero_y_32:
	setzb 3,2
	movei 4,37
%L669:
	dpb 2,[POINT 9,qpair_arr(3),17]
	addi 3,1
	sojge 4,%L669	; doloop_end
	popj 17,

qpair_zero_xy_32:
	setzb 3,1
	movei 2,37
%L678:
	move 4,3
	add 4,[POINT 9,qpair_arr,8]
	dpb 1,[POINT 9,(4),8]
	dpb 1,[POINT 9,qpair_arr(3),17]
	addi 3,1
	sojge 2,%L678	; doloop_end
	popj 17,

qpair_set_y_index_32:
	movei 4,0
	movei 3,37
%L687:
	dpb 4,[POINT 9,qpair_arr(4),17]
	addi 4,1
	sojge 3,%L687	; doloop_end
	popj 17,

qpair_sum_y_32:
	setzb 1,2
	movei 3,37
%L696:
	move 4,qpair_arr(2)
	lsh 4,11
	ash 4,-33
	add 1,4
	addi 2,1
	sojge 3,%L696	; doloop_end
	popj 17,

qpair_sum_xy_32:
	setzb 1,2
	movei 6,37
%L705:
	move 4,qpair_arr(2)
	ash 4,-33
	move 3,qpair_arr(2)
	lsh 3,11
	ash 3,-33
	add 4,3
	add 1,4
	addi 2,1
	sojge 6,%L705	; doloop_end
	popj 17,

qpair_copy_32:
	push 17,10
	move 10,1
	move 1,2
	movei 2,0
	movei 5,37
%L720:
	move 7,2
	lsh 7,2
	move 4,7
	andi 4,3
	move 6,7
	ash 6,-2	; ashrsi3_pointer
	add 6,10
	jumpe 4,%L713
%L712:
	ibp 6
	sojn 4,%L712	; decrement_and_branch_until_zero
%L713:
	movei 3,0
	move 4,7
	ash 4,-2	; ashrsi3_pointer
	add 4,1
	jumpe 3,%L716
%L715:
	ibp 4
	sojn 3,%L715	; decrement_and_branch_until_zero
%L716:
	move 4,(4)
	movem 4,(6)
	addi 2,1
	sojge 5,%L720	; doloop_end
	pop 17,10
	popj 17,

qpair_find_y:
	movei 3,0
	lsh 1,33
	ash 1,-33
%L727:
	move 4,qpair_arr(3)
	lsh 4,11
	ash 4,-33
	move 2,3
	camn 4,1
	jrst %L721
	addi 3,1
	caig 3,37
	jrst %L727
	seto 2,
%L721:
	move 1,2
	popj 17,

uqpair_zero_y_32:
	setzb 3,2
	movei 4,37
%L738:
	dpb 2,[POINT 9,uqpair_arr(3),17]
	addi 3,1
	sojge 4,%L738	; doloop_end
	popj 17,

uqpair_sum_y_32:
	setzb 1,2
	movei 3,37
%L747:
	ldb 4,[POINT 9,uqpair_arr(2),17]
	add 1,4
	addi 2,1
	sojge 3,%L747	; doloop_end
	popj 17,

hpair_zero_y_32:
	setzb 3,2
	movei 4,37
%L756:
	hrrm 2,hpair_arr(3)
	addi 3,1
	sojge 4,%L756	; doloop_end
	popj 17,

hpair_zero_xy_32:
	setzb 3,1
	movei 2,37
%L765:
	move 4,3
	add 4,[POINT 18,hpair_arr,17]
	hrrzs (4)
	hrrm 1,hpair_arr(3)
	addi 3,1
	sojge 2,%L765	; doloop_end
	popj 17,

hpair_set_y_index_32:
	movei 4,0
	movei 3,37
%L774:
	hrrm 4,hpair_arr(4)
	addi 4,1
	sojge 3,%L774	; doloop_end
	popj 17,

hpair_sum_y_32:
	setzb 1,2
	movei 3,37
%L783:
	hrre 4,hpair_arr(2)
	add 1,4
	addi 2,1
	sojge 3,%L783	; doloop_end
	popj 17,

hpair_sum_xy_32:
	setzb 1,2
	movei 6,37
%L792:
	hlre 4,hpair_arr(2)
	hrre 3,hpair_arr(2)
	add 4,3
	add 1,4
	addi 2,1
	sojge 6,%L792	; doloop_end
	popj 17,

hpair_copy_32:
	push 17,10
	move 10,1
	move 1,2
	movei 2,0
	movei 5,37
%L807:
	move 7,2
	lsh 7,1
	move 4,7
	andi 4,1
	move 6,7
	ash 6,-1	; ashrsi3_pointer
	add 6,10
	jumpe 4,%L800
%L799:
	ibp 6
	sojn 4,%L799	; decrement_and_branch_until_zero
%L800:
	movei 3,0
	move 4,7
	ash 4,-1	; ashrsi3_pointer
	add 4,1
	jumpe 3,%L803
%L802:
	ibp 4
	sojn 3,%L802	; decrement_and_branch_until_zero
%L803:
	move 4,(4)
	movem 4,(6)
	addi 2,1
	sojge 5,%L807	; doloop_end
	pop 17,10
	popj 17,

uhpair_zero_y_32:
	setzb 3,2
	movei 4,37
%L816:
	hrrm 2,uhpair_arr(3)
	addi 3,1
	sojge 4,%L816	; doloop_end
	popj 17,

uhpair_sum_y_32:
	setzb 1,2
	movei 3,37
%L825:
	hrrz 4,uhpair_arr(2)
	add 1,4
	addi 2,1
	sojge 3,%L825	; doloop_end
	popj 17,

spair_zero_y_32:
	movei 2,0
	movei 3,37
%L834:
	move 4,2
	lsh 4,1
	setzm spair_arr+1(4)
	addi 2,1
	sojge 3,%L834	; doloop_end
	popj 17,

spair_zero_xy_32:
	movei 2,0
	movei 3,37
%L843:
	move 4,2
	lsh 4,1
	setzm spair_arr(4)
	setzm spair_arr+1(4)
	addi 2,1
	sojge 3,%L843	; doloop_end
	popj 17,

spair_set_y_index_32:
	movei 3,0
	movei 2,37
%L852:
	move 4,3
	lsh 4,1
	movem 3,spair_arr+1(4)
	addi 3,1
	sojge 2,%L852	; doloop_end
	popj 17,

spair_sum_y_32:
	setzb 1,2
	movei 3,37
%L861:
	move 4,2
	lsh 4,1
	add 1,spair_arr+1(4)
	addi 2,1
	sojge 3,%L861	; doloop_end
	popj 17,

spair_sum_xy_32:
	setzb 1,2
	movei 3,37
%L870:
	move 4,2
	lsh 4,1
	move 6,spair_arr(4)
	add 6,spair_arr+1(4)
	add 1,6
	addi 2,1
	sojge 3,%L870	; doloop_end
	popj 17,

spair_copy_32:
	movei 4,37
%L881:
	move 6,(2)
	movem 6,(1)
	move 6,1(2)
	movem 6,1(1)
	addi 2,2
	addi 1,2
	sojge 4,%L881	; doloop_end
	popj 17,

upair_zero_y_32:
	movei 2,0
	movei 3,37
%L890:
	move 4,2
	lsh 4,1
	setzm upair_arr+1(4)
	addi 2,1
	sojge 3,%L890	; doloop_end
	popj 17,

upair_sum_y_32:
	setzb 1,2
	movei 3,37
%L899:
	move 4,2
	lsh 4,1
	add 1,upair_arr+1(4)
	addi 2,1
	sojge 3,%L899	; doloop_end
	popj 17,

mixed_zero_all_32:
	movei 1,0
	movei 6,mixed_arr+1
	movei 3,0
	movei 2,37
%L908:
	xmovei 4,mixed_arr(3)
	dpb 1,[POINT 9,(4),8]
	hrrm 1,mixed_arr(3)
	setzm (6)
	addi 6,3
	addi 4,2
	dpb 1,[POINT 9,(4),8]
	addi 3,11
	sojge 2,%L908	; doloop_end
	popj 17,

mixed_set_index_32:
	movei 3,0
	movei 6,mixed_arr+1
	movei 2,0
	movei 1,37
%L917:
	xmovei 4,mixed_arr(2)
	dpb 3,[POINT 9,(4),8]
	hrrm 3,mixed_arr(2)
	movem 3,(6)
	addi 6,3
	addi 4,2
	dpb 3,[POINT 9,(4),8]
	addi 2,11
	addi 3,1
	sojge 1,%L917	; doloop_end
	popj 17,

mixed_sum_32:
	movei 1,0
	movei 7,mixed_arr+1
	movei 2,0
	movei 6,37
%L926:
	move 3,mixed_arr(2)
	ash 3,-33
	hrre 4,mixed_arr(2)
	add 3,4
	move 4,(7)
	addi 7,3
	add 3,4
	move 4,mixed_arr+2(2)
	lsh 4,-33
	add 3,4
	add 1,3
	addi 2,11
	sojge 6,%L926	; doloop_end
	popj 17,

mixed_find_s:
	move 6,1
	movei 2,0
	movei 3,mixed_arr+1
%L933:
	move 4,(3)
	addi 3,3
	move 1,2
	camn 4,6
	popj 17,
	addi 2,1
	caig 2,37
	jrst %L933
	seto 1,
	popj 17,

vq_zero_32:
	setzb 2,6
	movei 1,37
%L946:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,vq_arr,8]
	jumpe 4,%L942
%L941:
	ibp 3
	sojn 4,%L941	; decrement_and_branch_until_zero
%L942:
	dpb 6,3
	addi 2,1
	sojge 1,%L946	; doloop_end
	popj 17,

vq_sum_32:
	setzb 1,2
	movei 6,37
%L957:
	move 3,2
	andi 3,3
	move 4,2
	ash 4,-2	; ashrsi3_pointer
	add 4,[POINT 9,vq_arr,8]
	jumpe 3,%L953
%L952:
	ibp 4
	sojn 3,%L952	; decrement_and_branch_until_zero
%L953:
	ldb 4,4
	trne 4,400
	orcmi 4,777
	add 1,4
	addi 2,1
	sojge 6,%L957	; doloop_end
	popj 17,

vh_zero_32:
	setzb 2,6
	movei 1,37
%L968:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,vh_arr,17]
	jumpe 4,%L964
%L963:
	ibp 3
	sojn 4,%L963	; decrement_and_branch_until_zero
%L964:
	dpb 6,3	; movhi
	addi 2,1
	sojge 1,%L968	; doloop_end
	popj 17,

vh_sum_32:
	setzb 1,2
	movei 6,37
%L979:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,vh_arr,17]
	jumpe 4,%L975
%L974:
	ibp 3
	sojn 4,%L974	; decrement_and_branch_until_zero
%L975:
	ldb 4,3
	hrre 4,4
	add 1,4
	addi 2,1
	sojge 6,%L979	; doloop_end
	popj 17,

vs_zero_32:
	movei 3,0
	movei 4,37
%L988:
	setzm vs_arr(3)
	addi 3,1
	sojge 4,%L988	; doloop_end
	popj 17,

vs_sum_32:
	setzb 1,2
	movei 3,37
%L997:
	move 4,vs_arr(2)
	add 1,4
	addi 2,1
	sojge 3,%L997	; doloop_end
	popj 17,

vc_zero_32:
	setzb 2,6
	movei 1,37
%L1008:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,vc_arr,8]
	jumpe 4,%L1004
%L1003:
	ibp 3
	sojn 4,%L1003	; decrement_and_branch_until_zero
%L1004:
	dpb 6,3
	addi 2,1
	sojge 1,%L1008	; doloop_end
	popj 17,

vc_sum_32:
	setzb 1,2
	movei 6,37
%L1019:
	move 3,2
	andi 3,3
	move 4,2
	ash 4,-2	; ashrsi3_pointer
	add 4,[POINT 9,vc_arr,8]
	jumpe 3,%L1015
%L1014:
	ibp 4
	sojn 3,%L1014	; decrement_and_branch_until_zero
%L1015:
	ldb 4,4
	add 1,4
	addi 2,1
	sojge 6,%L1019	; doloop_end
	popj 17,

vqpair_zero_y_32:
	setzb 3,2
	movei 4,37
%L1028:
	dpb 2,[POINT 9,vqpair_arr(3),17]
	addi 3,1
	sojge 4,%L1028	; doloop_end
	popj 17,

vqpair_sum_y_32:
	setzb 1,2
	movei 3,37
%L1037:
	ldb 4,[POINT 9,vqpair_arr(2),17]
	lsh 4,33
	ash 4,-33
	add 1,4
	addi 2,1
	sojge 3,%L1037	; doloop_end
	popj 17,

vhpair_zero_y_32:
	setzb 3,2
	movei 4,37
%L1046:
	hrrm 2,vhpair_arr(3)
	addi 3,1
	sojge 4,%L1046	; doloop_end
	popj 17,

vhpair_sum_y_32:
	setzb 1,2
	movei 3,37
%L1055:
	hrrz 4,vhpair_arr(2)
	hrre 4,4
	add 1,4
	addi 2,1
	sojge 3,%L1055	; doloop_end
	popj 17,

vspair_zero_y_32:
	movei 2,0
	movei 3,37
%L1064:
	move 4,2
	lsh 4,1
	setzm vspair_arr+1(4)
	addi 2,1
	sojge 3,%L1064	; doloop_end
	popj 17,

vspair_sum_y_32:
	setzb 1,2
	movei 3,37
%L1073:
	move 4,2
	lsh 4,1
	move 4,vspair_arr+1(4)
	add 1,4
	addi 2,1
	sojge 3,%L1073	; doloop_end
	popj 17,

s_ptr_zero:
	jumple 2,%L1081
	subi 2,1
%L1082:
	setzm (1)
	addi 1,1
	sojge 2,%L1082	; doloop_end
%L1081:
	popj 17,

s_ptr_sum:
	movei 4,0
	caml 4,2
	jrst %L1090
	subi 2,1
%L1091:
	add 4,(1)
	addi 1,1
	sojge 2,%L1091	; doloop_end
%L1090:
	move 1,4
	popj 17,

q_ptr_zero:
	jumple 2,%L1099
	movei 4,0
	subi 2,1
%L1100:
	dpb 4,1
	ibp 1
	sojge 2,%L1100	; doloop_end
%L1099:
	popj 17,

q_ptr_sum:
	movei 3,0
	caml 3,2
	jrst %L1108
	subi 2,1
%L1109:
	ldb 4,1
	trne 4,400
	orcmi 4,777
	add 3,4
	ibp 1
	sojge 2,%L1109	; doloop_end
%L1108:
	move 1,3
	popj 17,

h_ptr_zero:
	jumple 2,%L1117
	movei 4,0
	subi 2,1
%L1118:
	dpb 4,1	; movhi
	ibp 1
	sojge 2,%L1118	; doloop_end
%L1117:
	popj 17,

h_ptr_sum:
	movei 3,0
	caml 3,2
	jrst %L1126
	subi 2,1
%L1127:
	ldb 4,1
	hrre 4,4
	add 3,4
	ibp 1
	sojge 2,%L1127	; doloop_end
%L1126:
	move 1,3
	popj 17,

c_ptr_zero:
	jumple 2,%L1135
	movei 4,0
	subi 2,1
%L1136:
	dpb 4,1
	ibp 1
	sojge 2,%L1136	; doloop_end
%L1135:
	popj 17,

c_ptr_sum:
	movei 4,0
	caml 4,2
	jrst %L1144
	subi 2,1
%L1145:
	ldb 6,1
	add 4,6
	ibp 1
	sojge 2,%L1145	; doloop_end
%L1144:
	move 1,4
	popj 17,

qpair_ptr_zero_y:
	jumple 2,%L1153
	movei 4,0
	subi 2,1
%L1154:
	dpb 4,[POINT 9,(1),17]
	addi 1,1
	sojge 2,%L1154	; doloop_end
%L1153:
	popj 17,

qpair_ptr_sum_y:
	movei 3,0
	caml 3,2
	jrst %L1162
	subi 2,1
%L1163:
	move 4,(1)
	lsh 4,11
	ash 4,-33
	add 3,4
	addi 1,1
	sojge 2,%L1163	; doloop_end
%L1162:
	move 1,3
	popj 17,

hpair_ptr_zero_y:
	jumple 2,%L1171
	movei 4,0
	subi 2,1
%L1172:
	hrrm 4,(1)
	addi 1,1
	sojge 2,%L1172	; doloop_end
%L1171:
	popj 17,

hpair_ptr_sum_y:
	movei 3,0
	caml 3,2
	jrst %L1180
	subi 2,1
%L1181:
	hrre 4,(1)
	add 3,4
	addi 1,1
	sojge 2,%L1181	; doloop_end
%L1180:
	move 1,3
	popj 17,

spair_ptr_zero_y:
	jumple 2,%L1189
	subi 2,1
%L1190:
	setzm 1(1)
	addi 1,2
	sojge 2,%L1190	; doloop_end
%L1189:
	popj 17,

s_zero_if_negative:
	movei 2,0
	caml 2,1
	popj 17,
	subi 1,1
%L1200:
	move 3,2
	andi 3,77
	move 4,s_arr(3)
	caige 4,0
	movei 4,0
	movem 4,s_arr(3)
	addi 2,1
	sojge 1,%L1200	; doloop_end
	popj 17,

q_zero_if_negative:
	movei 7,0
	caml 7,1
	popj 17,
	movei 5,0
	subi 1,1
%L1214:
	move 6,7
	andi 6,77
	move 2,7
	andi 2,3
	move 4,2
	move 3,6
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,q_arr,8]
	jumpe 2,%L1208
%L1207:
	ibp 3
	sojn 4,%L1207	; decrement_and_branch_until_zero
%L1208:
	ldb 4,3
	trne 4,400
	orcmi 4,777
	jumpl 4,%L1215
%L1204:
	addi 7,1
	sojge 1,%L1214	; doloop_end
	popj 17,
%L1215:
	move 3,6
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,q_arr,8]
	skipn 4,2
	jrst %L1210
%L1209:
	ibp 3
	sojn 4,%L1209	; decrement_and_branch_until_zero
%L1210:
	dpb 5,3
	jrst %L1204

h_zero_if_negative:
	movei 7,0
	caml 7,1
	popj 17,
	movei 5,0
	subi 1,1
%L1229:
	move 6,7
	andi 6,77
	move 2,7
	andi 2,1
	move 4,2
	move 3,6
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,h_arr,17]
	jumpe 2,%L1223
%L1222:
	ibp 3
	sojn 4,%L1222	; decrement_and_branch_until_zero
%L1223:
	ldb 4,3
	hrre 4,4
	jumpl 4,%L1230
%L1219:
	addi 7,1
	sojge 1,%L1229	; doloop_end
	popj 17,
%L1230:
	move 3,6
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,h_arr,17]
	skipn 4,2
	jrst %L1225
%L1224:
	ibp 3
	sojn 4,%L1224	; decrement_and_branch_until_zero
%L1225:
	dpb 5,3	; movhi
	jrst %L1219

s_count_positive:
	setzb 2,3
	caml 2,1
	jrst %L1239
	subi 1,1
%L1240:
	move 4,3
	andi 4,77
	skiple s_arr(4)
	addi 2,1
	addi 3,1
	sojge 1,%L1240	; doloop_end
%L1239:
	move 1,2
	popj 17,

q_count_positive:
	setzb 6,2
	caml 6,1
	jrst %L1251
	subi 1,1
%L1252:
	move 3,2
	andi 3,77
	move 4,2
	andi 4,3
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,q_arr,8]
	jumpe 4,%L1248
%L1247:
	ibp 3
	sojn 4,%L1247	; decrement_and_branch_until_zero
%L1248:
	ldb 4,3
	trne 4,400
	orcmi 4,777
	jumple 4,%L1244
	addi 6,1
%L1244:
	addi 2,1
	sojge 1,%L1252	; doloop_end
%L1251:
	move 1,6
	popj 17,

h_count_positive:
	setzb 6,2
	caml 6,1
	jrst %L1263
	subi 1,1
%L1264:
	move 3,2
	andi 3,77
	move 4,2
	andi 4,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,h_arr,17]
	jumpe 4,%L1260
%L1259:
	ibp 3
	sojn 4,%L1259	; decrement_and_branch_until_zero
%L1260:
	ldb 4,3
	hrre 4,4
	jumple 4,%L1256
	addi 6,1
%L1256:
	addi 2,1
	sojge 1,%L1264	; doloop_end
%L1263:
	move 1,6
	popj 17,

s_do_zero_10:
	movei 3,0
	movei 4,11
%L1270:
	setzm s_arr(3)
	addi 3,1
	sojge 4,%L1270	; doloop_end
	popj 17,

s_do_sum_10:
	setzb 3,1
	movei 4,11
%L1276:
	add 1,s_arr(3)
	addi 3,1
	sojge 4,%L1276	; doloop_end
	popj 17,

q_do_zero_10:
	setzb 2,6
	movei 1,11
%L1284:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,q_arr,8]
	jumpe 4,%L1282
%L1281:
	ibp 3
	sojn 4,%L1281	; decrement_and_branch_until_zero
%L1282:
	dpb 6,3
	addi 2,1
	sojge 1,%L1284	; doloop_end
	popj 17,

q_do_sum_10:
	setzb 2,1
	movei 6,11
%L1292:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,q_arr,8]
	jumpe 4,%L1290
%L1289:
	ibp 3
	sojn 4,%L1289	; decrement_and_branch_until_zero
%L1290:
	ldb 4,3
	trne 4,400
	orcmi 4,777
	add 1,4
	addi 2,1
	sojge 6,%L1292	; doloop_end
	popj 17,

h_do_zero_10:
	setzb 2,6
	movei 1,11
%L1300:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,h_arr,17]
	jumpe 4,%L1298
%L1297:
	ibp 3
	sojn 4,%L1297	; decrement_and_branch_until_zero
%L1298:
	dpb 6,3	; movhi
	addi 2,1
	sojge 1,%L1300	; doloop_end
	popj 17,

h_do_sum_10:
	setzb 2,1
	movei 6,11
%L1308:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,h_arr,17]
	jumpe 4,%L1306
%L1305:
	ibp 3
	sojn 4,%L1305	; decrement_and_branch_until_zero
%L1306:
	ldb 4,3
	hrre 4,4
	add 1,4
	addi 2,1
	sojge 6,%L1308	; doloop_end
	popj 17,

s_zero_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	movei 3,0
	caml 3,10
	jrst %L1316
	move 1,10
	subi 1,1
%L1317:
	move 4,3
	andi 4,77
	setzm s_arr(4)
	addi 3,1
	sojge 1,%L1317	; doloop_end
%L1316:
	pop 17,10
	popj 17,

s_sum_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	setzb 2,3
	caml 2,10
	jrst %L1325
	move 1,10
	subi 1,1
%L1326:
	move 4,3
	andi 4,77
	add 2,s_arr(4)
	addi 3,1
	sojge 1,%L1326	; doloop_end
%L1325:
	move 1,2
	pop 17,10
	popj 17,

q_zero_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	movei 2,0
	caml 2,10
	jrst %L1336
	movei 6,0
	move 1,10
	subi 1,1
%L1337:
	move 3,2
	andi 3,77
	move 4,2
	andi 4,3
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,q_arr,8]
	jumpe 4,%L1333
%L1332:
	ibp 3
	sojn 4,%L1332	; decrement_and_branch_until_zero
%L1333:
	dpb 6,3
	addi 2,1
	sojge 1,%L1337	; doloop_end
%L1336:
	pop 17,10
	popj 17,

q_sum_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	setzb 6,2
	caml 6,10
	jrst %L1347
	move 1,10
	subi 1,1
%L1348:
	move 3,2
	andi 3,77
	move 4,2
	andi 4,3
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,q_arr,8]
	jumpe 4,%L1344
%L1343:
	ibp 3
	sojn 4,%L1343	; decrement_and_branch_until_zero
%L1344:
	ldb 4,3
	trne 4,400
	orcmi 4,777
	add 6,4
	addi 2,1
	sojge 1,%L1348	; doloop_end
%L1347:
	move 1,6
	pop 17,10
	popj 17,

h_zero_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	movei 2,0
	caml 2,10
	jrst %L1358
	movei 6,0
	move 1,10
	subi 1,1
%L1359:
	move 3,2
	andi 3,77
	move 4,2
	andi 4,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,h_arr,17]
	jumpe 4,%L1355
%L1354:
	ibp 3
	sojn 4,%L1354	; decrement_and_branch_until_zero
%L1355:
	dpb 6,3	; movhi
	addi 2,1
	sojge 1,%L1359	; doloop_end
%L1358:
	pop 17,10
	popj 17,

h_sum_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	setzb 6,2
	caml 6,10
	jrst %L1369
	move 1,10
	subi 1,1
%L1370:
	move 3,2
	andi 3,77
	move 4,2
	andi 4,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,h_arr,17]
	jumpe 4,%L1366
%L1365:
	ibp 3
	sojn 4,%L1365	; decrement_and_branch_until_zero
%L1366:
	ldb 4,3
	hrre 4,4
	add 6,4
	addi 2,1
	sojge 1,%L1370	; doloop_end
%L1369:
	move 1,6
	pop 17,10
	popj 17,

loop_with_call_each_time:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	movei 11,0
	caml 11,1
	jrst %L1378
	move 10,1
%L1376:
	pushj 17,f
	add 11,1
	sojn 10,%L1376	; decrement_and_branch_until_zero
%L1378:
	move 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

loop_store_call_each_time:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	movei 11,0
	camge 11,1
	jrst %L1384
%L1386:
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,
%L1384:
	move 10,11
	andi 10,77
	pushj 17,f
	movem 1,s_arr(10)
	addi 11,1
	camge 11,12
	jrst %L1384
	jrst %L1386

q_loop_store_call_each_time:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	movei 11,0
	caml 11,1
	jrst %L1396
%L1394:
	move 10,11
	andi 10,77
	move 4,11
	andi 4,3
	ash 10,-2	; ashrsi3_pointer
	add 10,[POINT 9,q_arr,8]
	jumpe 4,%L1393
%L1392:
	ibp 10
	sojn 4,%L1392	; decrement_and_branch_until_zero
%L1393:
	pushj 17,f
	dpb 1,10
	addi 11,1
	camge 11,12
	jrst %L1394
%L1396:
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

h_loop_store_call_each_time:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	movei 11,0
	caml 11,1
	jrst %L1406
%L1404:
	move 10,11
	andi 10,77
	move 4,11
	andi 4,1
	ash 10,-1	; ashrsi3_pointer
	add 10,[POINT 18,h_arr,17]
	jumpe 4,%L1403
%L1402:
	ibp 10
	sojn 4,%L1402	; decrement_and_branch_until_zero
%L1403:
	pushj 17,f
	dpb 1,10	; movhi
	addi 11,1
	camge 11,12
	jrst %L1404
%L1406:
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

q_to_s_copy_32:
	movei 2,0
	movei 1,37
%L1417:
	xmovei 6,s_arr(2)
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,q_arr,8]
	jumpe 4,%L1413
%L1412:
	ibp 3
	sojn 4,%L1412	; decrement_and_branch_until_zero
%L1413:
	ldb 4,3
	trne 4,400
	orcmi 4,777
	movem 4,(6)
	addi 2,1
	sojge 1,%L1417	; doloop_end
	popj 17,

h_to_s_copy_32:
	movei 2,0
	movei 1,37
%L1428:
	xmovei 6,s_arr(2)
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,h_arr,17]
	jumpe 4,%L1424
%L1423:
	ibp 3
	sojn 4,%L1423	; decrement_and_branch_until_zero
%L1424:
	ldb 3,3
	hrrem 3,(6)
	addi 2,1
	sojge 1,%L1428	; doloop_end
	popj 17,

s_to_q_copy_32:
	movei 2,0
	movei 1,37
%L1439:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,q_arr,8]
	jumpe 4,%L1435
%L1434:
	ibp 3
	sojn 4,%L1434	; decrement_and_branch_until_zero
%L1435:
	move 6,s_arr(2)
	dpb 6,3
	addi 2,1
	sojge 1,%L1439	; doloop_end
	popj 17,

s_to_h_copy_32:
	movei 2,0
	movei 1,37
%L1450:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,h_arr,17]
	jumpe 4,%L1446
%L1445:
	ibp 3
	sojn 4,%L1445	; decrement_and_branch_until_zero
%L1446:
	hrrz 4,s_arr(2)
	dpb 4,3	; movhi
	addi 2,1
	sojge 1,%L1450	; doloop_end
	popj 17,

c_to_s_copy_32:
	movei 2,0
	movei 1,37
%L1461:
	xmovei 6,s_arr(2)
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,c_arr,8]
	jumpe 4,%L1457
%L1456:
	ibp 3
	sojn 4,%L1456	; decrement_and_branch_until_zero
%L1457:
	ldb 4,3
	movem 4,(6)
	addi 2,1
	sojge 1,%L1461	; doloop_end
	popj 17,

s_to_c_copy_32:
	movei 2,0
	movei 1,37
%L1472:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,c_arr,8]
	jumpe 4,%L1468
%L1467:
	ibp 3
	sojn 4,%L1467	; decrement_and_branch_until_zero
%L1468:
	move 6,s_arr(2)
	dpb 6,3
	addi 2,1
	sojge 1,%L1472	; doloop_end
	popj 17,

s_nested_zero:
	movei 1,0
%L1483:
	move 3,1
	lsh 3,3
	movei 2,7
%L1488:
	move 4,3
	andi 4,77
	setzm s_arr(4)
	addi 3,1
	sojge 2,%L1488	; doloop_end
	addi 1,1
	caig 1,3
	jrst %L1483
	popj 17,

s_nested_sum:
	setzb 1,6
%L1499:
	move 3,6
	lsh 3,3
	movei 2,7
%L1504:
	move 4,3
	andi 4,77
	add 1,s_arr(4)
	addi 3,1
	sojge 2,%L1504	; doloop_end
	addi 6,1
	caig 6,3
	jrst %L1499
	popj 17,

q_nested_zero:
	setzb 7,6
%L1517:
	move 2,7
	lsh 2,3
	movei 1,7
%L1522:
	move 3,2
	andi 3,77
	move 4,2
	andi 4,3
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,q_arr,8]
	jumpe 4,%L1515
%L1514:
	ibp 3
	sojn 4,%L1514	; decrement_and_branch_until_zero
%L1515:
	dpb 6,3
	addi 2,1
	sojge 1,%L1522	; doloop_end
	addi 7,1
	caig 7,3
	jrst %L1517
	popj 17,

q_nested_sum:
	setzb 1,7
%L1535:
	move 2,7
	lsh 2,3
	movei 6,7
%L1540:
	move 3,2
	andi 3,77
	move 4,2
	andi 4,3
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,q_arr,8]
	jumpe 4,%L1533
%L1532:
	ibp 3
	sojn 4,%L1532	; decrement_and_branch_until_zero
%L1533:
	ldb 4,3
	trne 4,400
	orcmi 4,777
	add 1,4
	addi 2,1
	sojge 6,%L1540	; doloop_end
	addi 7,1
	caig 7,3
	jrst %L1535
	popj 17,

	.comm	bar, 80
	.bss
smf_big:
	.space	256
smf_vbig:
	.space	256
qpair_arr:
	.space	128
uqpair_arr:
	.space	128
hpair_arr:
	.space	128
uhpair_arr:
	.space	128
spair_arr:
	.space	256
upair_arr:
	.space	256
mixed_arr:
	.space	384
vqpair_arr:
	.space	128
vhpair_arr:
	.space	128
vspair_arr:
	.space	256
q_arr:
	.space	64
uq_arr:
	.space	64
h_arr:
	.space	128
uh_arr:
	.space	128
s_arr:
	.space	256
us_arr:
	.space	256
c_arr:
	.space	64
vq_arr:
	.space	64
vh_arr:
	.space	128
vs_arr:
	.space	256
vc_arr:
	.space	64
