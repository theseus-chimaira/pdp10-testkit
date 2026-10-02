
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
	setzb 2,1
	movei 3,37
%L332:
	move 4,[POINT 9,q_arr,8]
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 1,4
	addi 2,1
	sojge 3,%L332	; doloop_end
	popj 17,

q_set_index_32:
	movei 3,0
	movei 2,37
%L341:
	move 4,[POINT 9,q_arr,8]
	move 0,3
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 3,4
	addi 3,1
	sojge 2,%L341	; doloop_end
	popj 17,

q_set_value_32:
	andi 1,777	; zero_extendqisi2
	movei 2,0
	movei 3,37
%L350:
	move 4,[POINT 9,q_arr,8]
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 1,4
	addi 2,1
	sojge 3,%L350	; doloop_end
	popj 17,

q_sum_32:
	setzb 1,2
	move 6,[POINT 9,q_arr,8]
	movei 3,37
%L359:
	move 4,6
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	trne 4,400
	orcmi 4,777
	add 1,4
	addi 2,1
	sojge 3,%L359	; doloop_end
	popj 17,

q_sum_n:
	setzb 2,3
	caml 2,1
	jrst %L367
	move 6,[POINT 9,q_arr,8]
	subi 1,1
%L368:
	move 4,3
	andi 4,77
	move 7,6
	move 0,4
	jumple 0,.+3
	ibp 7
	sojg 0,.-1
	ldb 4,7
	trne 4,400
	orcmi 4,777
	add 2,4
	addi 3,1
	sojge 1,%L368	; doloop_end
%L367:
	move 1,2
	popj 17,

q_copy_32:
	push 17,10
	move 10,1
	move 1,2
	movei 5,0
	movei 2,37
%L383:
	move 7,5
	andi 7,3
	move 3,7
	move 4,5
	ash 4,-2	; ashrsi3_pointer
	move 6,10
	add 6,4
	jumpe 7,%L376
%L375:
	ibp 6
	sojn 3,%L375	; decrement_and_branch_until_zero
%L376:
	add 4,1
	skipn 3,7
	jrst %L379
%L378:
	ibp 4
	sojn 3,%L378	; decrement_and_branch_until_zero
%L379:
	ldb 4,4
	dpb 4,6
	addi 5,1
	sojge 2,%L383	; doloop_end
	pop 17,10
	popj 17,

q_zero_even_32:
	setzb 2,1
	movei 3,17
%L392:
	move 4,[POINT 9,q_arr,8]
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 1,4
	addi 2,2
	sojge 3,%L392	; doloop_end
	popj 17,

q_zero_stride3_30:
	setzb 2,1
	movei 3,11
%L401:
	move 4,[POINT 9,q_arr,8]
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 1,4
	addi 2,3
	sojge 3,%L401	; doloop_end
	popj 17,

q_sum_reverse_32:
	movei 1,0
	movei 3,37
	move 2,[POINT 9,q_arr,8]
%L407:
	move 4,2
	move 0,3
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	trne 4,400
	orcmi 4,777
	add 1,4
	sojge 3,%L407	; decrement_and_branch_until_zero
	popj 17,

uq_zero_32:
	setzb 2,1
	movei 3,37
%L418:
	move 4,[POINT 9,uq_arr,8]
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 1,4
	addi 2,1
	sojge 3,%L418	; doloop_end
	popj 17,

uq_set_index_32:
	movei 3,0
	movei 2,37
%L427:
	move 4,[POINT 9,uq_arr,8]
	move 0,3
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 3,4
	addi 3,1
	sojge 2,%L427	; doloop_end
	popj 17,

uq_sum_32:
	setzb 1,2
	move 6,[POINT 9,uq_arr,8]
	movei 3,37
%L436:
	move 4,6
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	add 1,4
	addi 2,1
	sojge 3,%L436	; doloop_end
	popj 17,

uq_copy_32:
	push 17,10
	move 10,1
	move 1,2
	movei 5,0
	movei 2,37
%L451:
	move 7,5
	andi 7,3
	move 3,7
	move 4,5
	ash 4,-2	; ashrsi3_pointer
	move 6,10
	add 6,4
	jumpe 7,%L444
%L443:
	ibp 6
	sojn 3,%L443	; decrement_and_branch_until_zero
%L444:
	add 4,1
	skipn 3,7
	jrst %L447
%L446:
	ibp 4
	sojn 3,%L446	; decrement_and_branch_until_zero
%L447:
	ldb 4,4
	dpb 4,6
	addi 5,1
	sojge 2,%L451	; doloop_end
	pop 17,10
	popj 17,

h_zero_32:
	setzb 2,1
	movei 3,37
%L460:
	move 4,[POINT 18,h_arr,17]
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 1,4	; movhi
	addi 2,1
	sojge 3,%L460	; doloop_end
	popj 17,

h_set_index_32:
	movei 3,0
	movei 2,37
%L469:
	move 4,[POINT 18,h_arr,17]
	move 0,3
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 3,4	; movhi
	addi 3,1
	sojge 2,%L469	; doloop_end
	popj 17,

h_set_value_32:
	hrrzi 1,(1)	; zero_extendhisi2
	movei 2,0
	movei 3,37
%L478:
	move 4,[POINT 18,h_arr,17]
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 1,4	; movhi
	addi 2,1
	sojge 3,%L478	; doloop_end
	popj 17,

h_sum_32:
	setzb 1,2
	move 6,[POINT 18,h_arr,17]
	movei 3,37
%L487:
	move 4,6
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	hrre 4,4
	add 1,4
	addi 2,1
	sojge 3,%L487	; doloop_end
	popj 17,

h_sum_n:
	setzb 2,3
	caml 2,1
	jrst %L495
	move 6,[POINT 18,h_arr,17]
	subi 1,1
%L496:
	move 4,3
	andi 4,77
	move 7,6
	move 0,4
	jumple 0,.+3
	ibp 7
	sojg 0,.-1
	ldb 4,7
	hrre 4,4
	add 2,4
	addi 3,1
	sojge 1,%L496	; doloop_end
%L495:
	move 1,2
	popj 17,

h_copy_32:
	push 17,10
	move 10,1
	move 1,2
	movei 5,0
	movei 2,37
%L511:
	move 7,5
	andi 7,1
	move 3,7
	move 4,5
	ash 4,-1	; ashrsi3_pointer
	move 6,10
	add 6,4
	jumpe 7,%L504
%L503:
	ibp 6
	sojn 3,%L503	; decrement_and_branch_until_zero
%L504:
	add 4,1
	skipn 3,7
	jrst %L507
%L506:
	ibp 4
	sojn 3,%L506	; decrement_and_branch_until_zero
%L507:
	ldb 4,4
	dpb 4,6	; movhi
	addi 5,1
	sojge 2,%L511	; doloop_end
	pop 17,10
	popj 17,

h_zero_even_32:
	setzb 2,1
	movei 3,17
%L520:
	move 4,[POINT 18,h_arr,17]
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 1,4	; movhi
	addi 2,2
	sojge 3,%L520	; doloop_end
	popj 17,

h_sum_reverse_32:
	movei 1,0
	movei 3,37
	move 2,[POINT 18,h_arr,17]
%L526:
	move 4,2
	move 0,3
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	hrre 4,4
	add 1,4
	sojge 3,%L526	; decrement_and_branch_until_zero
	popj 17,

uh_zero_32:
	setzb 2,1
	movei 3,37
%L537:
	move 4,[POINT 18,uh_arr,17]
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 1,4	; movhi
	addi 2,1
	sojge 3,%L537	; doloop_end
	popj 17,

uh_set_index_32:
	movei 3,0
	movei 2,37
%L546:
	move 4,[POINT 18,uh_arr,17]
	move 0,3
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 3,4	; movhi
	addi 3,1
	sojge 2,%L546	; doloop_end
	popj 17,

uh_sum_32:
	setzb 1,2
	move 6,[POINT 18,uh_arr,17]
	movei 3,37
%L555:
	move 4,6
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	add 1,4
	addi 2,1
	sojge 3,%L555	; doloop_end
	popj 17,

uh_copy_32:
	push 17,10
	move 10,1
	move 1,2
	movei 5,0
	movei 2,37
%L570:
	move 7,5
	andi 7,1
	move 3,7
	move 4,5
	ash 4,-1	; ashrsi3_pointer
	move 6,10
	add 6,4
	jumpe 7,%L563
%L562:
	ibp 6
	sojn 3,%L562	; decrement_and_branch_until_zero
%L563:
	add 4,1
	skipn 3,7
	jrst %L566
%L565:
	ibp 4
	sojn 3,%L565	; decrement_and_branch_until_zero
%L566:
	ldb 4,4
	dpb 4,6	; movhi
	addi 5,1
	sojge 2,%L570	; doloop_end
	pop 17,10
	popj 17,

c_zero_32:
	setzb 2,1
	movei 3,37
%L579:
	move 4,[POINT 9,c_arr,8]
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 1,4
	addi 2,1
	sojge 3,%L579	; doloop_end
	popj 17,

c_set_index_32:
	movei 3,0
	movei 2,37
%L588:
	move 4,[POINT 9,c_arr,8]
	move 0,3
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 3,4
	addi 3,1
	sojge 2,%L588	; doloop_end
	popj 17,

c_sum_32:
	setzb 1,2
	move 6,[POINT 9,c_arr,8]
	movei 3,37
%L597:
	move 4,6
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	add 1,4
	addi 2,1
	sojge 3,%L597	; doloop_end
	popj 17,

c_copy_32:
	push 17,10
	move 10,1
	move 1,2
	movei 5,0
	movei 2,37
%L612:
	move 7,5
	andi 7,3
	move 3,7
	move 4,5
	ash 4,-2	; ashrsi3_pointer
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
	dpb 4,6
	addi 5,1
	sojge 2,%L612	; doloop_end
	pop 17,10
	popj 17,

qpair_zero_y_32:
	setzb 3,2
	movei 4,37
%L621:
	dpb 2,[POINT 9,qpair_arr+pdp10.c:7954:TOOBIG:(3),17]
	addi 3,1
	sojge 4,%L621	; doloop_end
	popj 17,

qpair_zero_xy_32:
	setzb 3,1
	movei 2,37
%L630:
	move 4,3
	add 4,[POINT 9,qpair_arr,8]
	dpb 1,[POINT 9,(4),8]
	dpb 1,[POINT 9,qpair_arr+pdp10.c:7954:TOOBIG:(3),17]
	addi 3,1
	sojge 2,%L630	; doloop_end
	popj 17,

qpair_set_y_index_32:
	movei 4,0
	movei 3,37
%L639:
	dpb 4,[POINT 9,qpair_arr+pdp10.c:7954:TOOBIG:(4),17]
	addi 4,1
	sojge 3,%L639	; doloop_end
	popj 17,

qpair_sum_y_32:
	setzb 1,2
	movei 3,37
%L648:
	move 4,qpair_arr+pdp10.c:7954:TOOBIG:(2)
	lsh 4,11
	ash 4,-33
	add 1,4
	addi 2,1
	sojge 3,%L648	; doloop_end
	popj 17,

qpair_sum_xy_32:
	setzb 1,2
	movei 6,37
%L657:
	move 4,qpair_arr+pdp10.c:7954:TOOBIG:(2)
	ash 4,-33
	move 3,qpair_arr+pdp10.c:7954:TOOBIG:(2)
	lsh 3,11
	ash 3,-33
	add 4,3
	add 1,4
	addi 2,1
	sojge 6,%L657	; doloop_end
	popj 17,

qpair_copy_32:
	push 17,10
	move 10,1
	move 1,2
	movei 2,0
	movei 5,37
%L672:
	move 7,2
	lsh 7,2
	move 4,7
	andi 4,3
	move 6,7
	ash 6,-2	; ashrsi3_pointer
	add 6,10
	jumpe 4,%L665
%L664:
	ibp 6
	sojn 4,%L664	; decrement_and_branch_until_zero
%L665:
	movei 3,0
	move 4,7
	ash 4,-2	; ashrsi3_pointer
	add 4,1
	jumpe 3,%L668
%L667:
	ibp 4
	sojn 3,%L667	; decrement_and_branch_until_zero
%L668:
	move 4,(4)
	movem 4,(6)
	addi 2,1
	sojge 5,%L672	; doloop_end
	pop 17,10
	popj 17,

qpair_find_y:
	movei 3,0
	lsh 1,33
	ash 1,-33
%L679:
	move 4,qpair_arr+pdp10.c:7954:TOOBIG:(3)
	lsh 4,11
	ash 4,-33
	move 2,3
	camn 4,1
	jrst %L673
	addi 3,1
	caig 3,37
	jrst %L679
	seto 2,
%L673:
	move 1,2
	popj 17,

uqpair_zero_y_32:
	setzb 3,2
	movei 4,37
%L690:
	dpb 2,[POINT 9,uqpair_arr+pdp10.c:7954:TOOBIG:(3),17]
	addi 3,1
	sojge 4,%L690	; doloop_end
	popj 17,

uqpair_sum_y_32:
	setzb 1,2
	movei 3,37
%L699:
	ldb 4,[POINT 9,uqpair_arr+pdp10.c:7954:TOOBIG:(2),17]
	add 1,4
	addi 2,1
	sojge 3,%L699	; doloop_end
	popj 17,

hpair_zero_y_32:
	setzb 3,2
	movei 4,37
%L708:
	hrrm 2,hpair_arr+pdp10.c:7954:TOOBIG:(3)
	addi 3,1
	sojge 4,%L708	; doloop_end
	popj 17,

hpair_zero_xy_32:
	setzb 3,1
	movei 2,37
%L717:
	move 4,3
	add 4,[POINT 18,hpair_arr,17]
	hrrzs (4)
	hrrm 1,hpair_arr+pdp10.c:7954:TOOBIG:(3)
	addi 3,1
	sojge 2,%L717	; doloop_end
	popj 17,

hpair_set_y_index_32:
	movei 4,0
	movei 3,37
%L726:
	hrrm 4,hpair_arr+pdp10.c:7954:TOOBIG:(4)
	addi 4,1
	sojge 3,%L726	; doloop_end
	popj 17,

hpair_sum_y_32:
	setzb 1,2
	movei 3,37
%L735:
	hrre 4,hpair_arr+pdp10.c:7954:TOOBIG:(2)
	add 1,4
	addi 2,1
	sojge 3,%L735	; doloop_end
	popj 17,

hpair_sum_xy_32:
	setzb 1,2
	movei 6,37
%L744:
	hlre 4,hpair_arr+pdp10.c:7954:TOOBIG:(2)
	hrre 3,hpair_arr+pdp10.c:7954:TOOBIG:(2)
	add 4,3
	add 1,4
	addi 2,1
	sojge 6,%L744	; doloop_end
	popj 17,

hpair_copy_32:
	push 17,10
	move 10,1
	move 1,2
	movei 2,0
	movei 5,37
%L759:
	move 7,2
	lsh 7,1
	move 4,7
	andi 4,1
	move 6,7
	ash 6,-1	; ashrsi3_pointer
	add 6,10
	jumpe 4,%L752
%L751:
	ibp 6
	sojn 4,%L751	; decrement_and_branch_until_zero
%L752:
	movei 3,0
	move 4,7
	ash 4,-1	; ashrsi3_pointer
	add 4,1
	jumpe 3,%L755
%L754:
	ibp 4
	sojn 3,%L754	; decrement_and_branch_until_zero
%L755:
	move 4,(4)
	movem 4,(6)
	addi 2,1
	sojge 5,%L759	; doloop_end
	pop 17,10
	popj 17,

uhpair_zero_y_32:
	setzb 3,2
	movei 4,37
%L768:
	hrrm 2,uhpair_arr+pdp10.c:7954:TOOBIG:(3)
	addi 3,1
	sojge 4,%L768	; doloop_end
	popj 17,

uhpair_sum_y_32:
	setzb 1,2
	movei 3,37
%L777:
	hrrz 4,uhpair_arr+pdp10.c:7954:TOOBIG:(2)
	add 1,4
	addi 2,1
	sojge 3,%L777	; doloop_end
	popj 17,

spair_zero_y_32:
	movei 2,0
	movei 3,37
%L786:
	move 4,2
	lsh 4,1
	setzm spair_arr+1(4)
	addi 2,1
	sojge 3,%L786	; doloop_end
	popj 17,

spair_zero_xy_32:
	movei 2,0
	movei 3,37
%L795:
	move 4,2
	lsh 4,1
	setzm spair_arr(4)
	setzm spair_arr+1(4)
	addi 2,1
	sojge 3,%L795	; doloop_end
	popj 17,

spair_set_y_index_32:
	movei 3,0
	movei 2,37
%L804:
	move 4,3
	lsh 4,1
	movem 3,spair_arr+1(4)
	addi 3,1
	sojge 2,%L804	; doloop_end
	popj 17,

spair_sum_y_32:
	setzb 1,2
	movei 3,37
%L813:
	move 4,2
	lsh 4,1
	add 1,spair_arr+1(4)
	addi 2,1
	sojge 3,%L813	; doloop_end
	popj 17,

spair_sum_xy_32:
	setzb 1,2
	movei 3,37
%L822:
	move 4,2
	lsh 4,1
	move 6,spair_arr(4)
	add 6,spair_arr+1(4)
	add 1,6
	addi 2,1
	sojge 3,%L822	; doloop_end
	popj 17,

spair_copy_32:
	movei 4,37
%L833:
	move 6,(2)
	movem 6,(1)
	move 6,1(2)
	movem 6,1(1)
	addi 2,2
	addi 1,2
	sojge 4,%L833	; doloop_end
	popj 17,

upair_zero_y_32:
	movei 2,0
	movei 3,37
%L842:
	move 4,2
	lsh 4,1
	setzm upair_arr+1(4)
	addi 2,1
	sojge 3,%L842	; doloop_end
	popj 17,

upair_sum_y_32:
	setzb 1,2
	movei 3,37
%L851:
	move 4,2
	lsh 4,1
	add 1,upair_arr+1(4)
	addi 2,1
	sojge 3,%L851	; doloop_end
	popj 17,

mixed_zero_all_32:
	movei 1,0
	movei 6,mixed_arr+1
	movei 3,0
	movei 2,37
%L860:
	xmovei 4,mixed_arr(3)
	dpb 1,[POINT 9,(4),8]
	hrrm 1,mixed_arr(3)
	setzm (6)
	addi 6,3
	addi 4,2
	dpb 1,[POINT 9,(4),8]
	addi 3,11
	sojge 2,%L860	; doloop_end
	popj 17,

mixed_set_index_32:
	movei 3,0
	movei 6,mixed_arr+1
	movei 2,0
	movei 1,37
%L869:
	xmovei 4,mixed_arr(2)
	dpb 3,[POINT 9,(4),8]
	hrrm 3,mixed_arr(2)
	movem 3,(6)
	addi 6,3
	addi 4,2
	dpb 3,[POINT 9,(4),8]
	addi 2,11
	addi 3,1
	sojge 1,%L869	; doloop_end
	popj 17,

mixed_sum_32:
	movei 1,0
	movei 7,mixed_arr+1
	movei 2,0
	movei 6,37
%L878:
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
	sojge 6,%L878	; doloop_end
	popj 17,

mixed_find_s:
	move 6,1
	movei 2,0
	movei 3,mixed_arr+1
%L885:
	move 4,(3)
	addi 3,3
	move 1,2
	camn 4,6
	popj 17,
	addi 2,1
	caig 2,37
	jrst %L885
	seto 1,
	popj 17,

vq_zero_32:
	setzb 2,1
	movei 3,37
%L896:
	move 4,[POINT 9,vq_arr,8]
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 1,4
	addi 2,1
	sojge 3,%L896	; doloop_end
	popj 17,

vq_sum_32:
	setzb 1,2
	move 6,[POINT 9,vq_arr,8]
	movei 3,37
%L905:
	move 4,6
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	trne 4,400
	orcmi 4,777
	add 1,4
	addi 2,1
	sojge 3,%L905	; doloop_end
	popj 17,

vh_zero_32:
	setzb 2,1
	movei 3,37
%L914:
	move 4,[POINT 18,vh_arr,17]
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 1,4	; movhi
	addi 2,1
	sojge 3,%L914	; doloop_end
	popj 17,

vh_sum_32:
	setzb 1,2
	move 6,[POINT 18,vh_arr,17]
	movei 3,37
%L923:
	move 4,6
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	hrre 4,4
	add 1,4
	addi 2,1
	sojge 3,%L923	; doloop_end
	popj 17,

vs_zero_32:
	movei 3,0
	movei 4,37
%L932:
	setzm vs_arr(3)
	addi 3,1
	sojge 4,%L932	; doloop_end
	popj 17,

vs_sum_32:
	setzb 1,2
	movei 3,37
%L941:
	move 4,vs_arr(2)
	add 1,4
	addi 2,1
	sojge 3,%L941	; doloop_end
	popj 17,

vc_zero_32:
	setzb 2,1
	movei 3,37
%L950:
	move 4,[POINT 9,vc_arr,8]
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 1,4
	addi 2,1
	sojge 3,%L950	; doloop_end
	popj 17,

vc_sum_32:
	setzb 1,2
	move 6,[POINT 9,vc_arr,8]
	movei 3,37
%L959:
	move 4,6
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	add 1,4
	addi 2,1
	sojge 3,%L959	; doloop_end
	popj 17,

vqpair_zero_y_32:
	setzb 3,2
	movei 4,37
%L968:
	dpb 2,[POINT 9,vqpair_arr+pdp10.c:7954:TOOBIG:(3),17]
	addi 3,1
	sojge 4,%L968	; doloop_end
	popj 17,

vqpair_sum_y_32:
	setzb 1,2
	movei 3,37
%L977:
	ldb 4,[POINT 9,vqpair_arr+pdp10.c:7954:TOOBIG:(2),17]
	lsh 4,33
	ash 4,-33
	add 1,4
	addi 2,1
	sojge 3,%L977	; doloop_end
	popj 17,

vhpair_zero_y_32:
	setzb 3,2
	movei 4,37
%L986:
	hrrm 2,vhpair_arr+pdp10.c:7954:TOOBIG:(3)
	addi 3,1
	sojge 4,%L986	; doloop_end
	popj 17,

vhpair_sum_y_32:
	setzb 1,2
	movei 3,37
%L995:
	hrrz 4,vhpair_arr+pdp10.c:7954:TOOBIG:(2)
	hrre 4,4
	add 1,4
	addi 2,1
	sojge 3,%L995	; doloop_end
	popj 17,

vspair_zero_y_32:
	movei 2,0
	movei 3,37
%L1004:
	move 4,2
	lsh 4,1
	setzm vspair_arr+1(4)
	addi 2,1
	sojge 3,%L1004	; doloop_end
	popj 17,

vspair_sum_y_32:
	setzb 1,2
	movei 3,37
%L1013:
	move 4,2
	lsh 4,1
	move 4,vspair_arr+1(4)
	add 1,4
	addi 2,1
	sojge 3,%L1013	; doloop_end
	popj 17,

s_ptr_zero:
	jumple 2,%L1021
	subi 2,1
%L1022:
	setzm (1)
	addi 1,1
	sojge 2,%L1022	; doloop_end
%L1021:
	popj 17,

s_ptr_sum:
	movei 4,0
	caml 4,2
	jrst %L1030
	subi 2,1
%L1031:
	add 4,(1)
	addi 1,1
	sojge 2,%L1031	; doloop_end
%L1030:
	move 1,4
	popj 17,

q_ptr_zero:
	jumple 2,%L1039
	movei 4,0
	subi 2,1
%L1040:
	dpb 4,1
	ibp 1
	sojge 2,%L1040	; doloop_end
%L1039:
	popj 17,

q_ptr_sum:
	movei 3,0
	caml 3,2
	jrst %L1048
	subi 2,1
%L1049:
	ldb 4,1
	trne 4,400
	orcmi 4,777
	add 3,4
	ibp 1
	sojge 2,%L1049	; doloop_end
%L1048:
	move 1,3
	popj 17,

h_ptr_zero:
	jumple 2,%L1057
	movei 4,0
	subi 2,1
%L1058:
	dpb 4,1	; movhi
	ibp 1
	sojge 2,%L1058	; doloop_end
%L1057:
	popj 17,

h_ptr_sum:
	movei 3,0
	caml 3,2
	jrst %L1066
	subi 2,1
%L1067:
	ldb 4,1
	hrre 4,4
	add 3,4
	ibp 1
	sojge 2,%L1067	; doloop_end
%L1066:
	move 1,3
	popj 17,

c_ptr_zero:
	jumple 2,%L1075
	movei 4,0
	subi 2,1
%L1076:
	dpb 4,1
	ibp 1
	sojge 2,%L1076	; doloop_end
%L1075:
	popj 17,

c_ptr_sum:
	movei 4,0
	caml 4,2
	jrst %L1084
	subi 2,1
%L1085:
	ldb 6,1
	add 4,6
	ibp 1
	sojge 2,%L1085	; doloop_end
%L1084:
	move 1,4
	popj 17,

qpair_ptr_zero_y:
	jumple 2,%L1093
	movei 4,0
	subi 2,1
%L1094:
	dpb 4,[POINT 9,(1),17]
	addi 1,1
	sojge 2,%L1094	; doloop_end
%L1093:
	popj 17,

qpair_ptr_sum_y:
	movei 3,0
	caml 3,2
	jrst %L1102
	subi 2,1
%L1103:
	move 4,(1)
	lsh 4,11
	ash 4,-33
	add 3,4
	addi 1,1
	sojge 2,%L1103	; doloop_end
%L1102:
	move 1,3
	popj 17,

hpair_ptr_zero_y:
	jumple 2,%L1111
	movei 4,0
	subi 2,1
%L1112:
	hrrm 4,(1)
	addi 1,1
	sojge 2,%L1112	; doloop_end
%L1111:
	popj 17,

hpair_ptr_sum_y:
	movei 3,0
	caml 3,2
	jrst %L1120
	subi 2,1
%L1121:
	hrre 4,(1)
	add 3,4
	addi 1,1
	sojge 2,%L1121	; doloop_end
%L1120:
	move 1,3
	popj 17,

spair_ptr_zero_y:
	jumple 2,%L1129
	subi 2,1
%L1130:
	setzm 1(1)
	addi 1,2
	sojge 2,%L1130	; doloop_end
%L1129:
	popj 17,

s_zero_if_negative:
	movei 2,0
	caml 2,1
	popj 17,
	subi 1,1
%L1140:
	move 3,2
	andi 3,77
	move 4,s_arr(3)
	caige 4,0
	movei 4,0
	movem 4,s_arr(3)
	addi 2,1
	sojge 1,%L1140	; doloop_end
	popj 17,

q_zero_if_negative:
	movei 2,0
	caml 2,1
	popj 17,
	move 6,[POINT 9,q_arr,8]
	movei 7,0
	subi 1,1
%L1150:
	move 3,2
	andi 3,77
	move 4,6
	move 0,3
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	trne 4,400
	orcmi 4,777
	jumpl 4,%L1151
%L1144:
	addi 2,1
	sojge 1,%L1150	; doloop_end
	popj 17,
%L1151:
	move 4,[POINT 9,q_arr,8]
	move 0,3
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 7,4
	jrst %L1144

h_zero_if_negative:
	movei 2,0
	caml 2,1
	popj 17,
	move 6,[POINT 18,h_arr,17]
	movei 7,0
	subi 1,1
%L1161:
	move 3,2
	andi 3,77
	move 4,6
	move 0,3
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	hrre 4,4
	jumpl 4,%L1162
%L1155:
	addi 2,1
	sojge 1,%L1161	; doloop_end
	popj 17,
%L1162:
	move 4,[POINT 18,h_arr,17]
	move 0,3
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 7,4	; movhi
	jrst %L1155

s_count_positive:
	setzb 2,3
	caml 2,1
	jrst %L1171
	subi 1,1
%L1172:
	move 4,3
	andi 4,77
	skiple s_arr(4)
	addi 2,1
	addi 3,1
	sojge 1,%L1172	; doloop_end
%L1171:
	move 1,2
	popj 17,

q_count_positive:
	setzb 2,3
	caml 2,1
	jrst %L1181
	move 6,[POINT 9,q_arr,8]
	subi 1,1
%L1182:
	move 4,3
	andi 4,77
	move 7,6
	move 0,4
	jumple 0,.+3
	ibp 7
	sojg 0,.-1
	ldb 4,7
	trne 4,400
	orcmi 4,777
	jumple 4,%L1176
	addi 2,1
%L1176:
	addi 3,1
	sojge 1,%L1182	; doloop_end
%L1181:
	move 1,2
	popj 17,

h_count_positive:
	setzb 2,3
	caml 2,1
	jrst %L1191
	move 6,[POINT 18,h_arr,17]
	subi 1,1
%L1192:
	move 4,3
	andi 4,77
	move 7,6
	move 0,4
	jumple 0,.+3
	ibp 7
	sojg 0,.-1
	ldb 4,7
	hrre 4,4
	jumple 4,%L1186
	addi 2,1
%L1186:
	addi 3,1
	sojge 1,%L1192	; doloop_end
%L1191:
	move 1,2
	popj 17,

s_do_zero_10:
	movei 3,0
	movei 4,11
%L1198:
	setzm s_arr(3)
	addi 3,1
	sojge 4,%L1198	; doloop_end
	popj 17,

s_do_sum_10:
	setzb 3,1
	movei 4,11
%L1204:
	add 1,s_arr(3)
	addi 3,1
	sojge 4,%L1204	; doloop_end
	popj 17,

q_do_zero_10:
	setzb 2,1
	movei 3,11
%L1210:
	move 4,[POINT 9,q_arr,8]
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 1,4
	addi 2,1
	sojge 3,%L1210	; doloop_end
	popj 17,

q_do_sum_10:
	setzb 2,1
	move 6,[POINT 9,q_arr,8]
	movei 3,11
%L1216:
	move 4,6
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	trne 4,400
	orcmi 4,777
	add 1,4
	addi 2,1
	sojge 3,%L1216	; doloop_end
	popj 17,

h_do_zero_10:
	setzb 2,1
	movei 3,11
%L1222:
	move 4,[POINT 18,h_arr,17]
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 1,4	; movhi
	addi 2,1
	sojge 3,%L1222	; doloop_end
	popj 17,

h_do_sum_10:
	setzb 2,1
	move 6,[POINT 18,h_arr,17]
	movei 3,11
%L1228:
	move 4,6
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	hrre 4,4
	add 1,4
	addi 2,1
	sojge 3,%L1228	; doloop_end
	popj 17,

s_zero_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	movei 3,0
	caml 3,10
	jrst %L1236
	move 1,10
	subi 1,1
%L1237:
	move 4,3
	andi 4,77
	setzm s_arr(4)
	addi 3,1
	sojge 1,%L1237	; doloop_end
%L1236:
	pop 17,10
	popj 17,

s_sum_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	setzb 2,3
	caml 2,10
	jrst %L1245
	move 1,10
	subi 1,1
%L1246:
	move 4,3
	andi 4,77
	add 2,s_arr(4)
	addi 3,1
	sojge 1,%L1246	; doloop_end
%L1245:
	move 1,2
	pop 17,10
	popj 17,

q_zero_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	movei 3,0
	caml 3,10
	jrst %L1254
	movei 2,0
	move 1,10
	subi 1,1
%L1255:
	move 4,3
	andi 4,77
	move 6,[POINT 9,q_arr,8]
	move 0,4
	jumple 0,.+3
	ibp 6
	sojg 0,.-1
	dpb 2,6
	addi 3,1
	sojge 1,%L1255	; doloop_end
%L1254:
	pop 17,10
	popj 17,

q_sum_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	setzb 2,3
	caml 2,10
	jrst %L1263
	move 6,[POINT 9,q_arr,8]
	move 1,10
	subi 1,1
%L1264:
	move 4,3
	andi 4,77
	move 7,6
	move 0,4
	jumple 0,.+3
	ibp 7
	sojg 0,.-1
	ldb 4,7
	trne 4,400
	orcmi 4,777
	add 2,4
	addi 3,1
	sojge 1,%L1264	; doloop_end
%L1263:
	move 1,2
	pop 17,10
	popj 17,

h_zero_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	movei 3,0
	caml 3,10
	jrst %L1272
	movei 2,0
	move 1,10
	subi 1,1
%L1273:
	move 4,3
	andi 4,77
	move 6,[POINT 18,h_arr,17]
	move 0,4
	jumple 0,.+3
	ibp 6
	sojg 0,.-1
	dpb 2,6	; movhi
	addi 3,1
	sojge 1,%L1273	; doloop_end
%L1272:
	pop 17,10
	popj 17,

h_sum_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	setzb 2,3
	caml 2,10
	jrst %L1281
	move 6,[POINT 18,h_arr,17]
	move 1,10
	subi 1,1
%L1282:
	move 4,3
	andi 4,77
	move 7,6
	move 0,4
	jumple 0,.+3
	ibp 7
	sojg 0,.-1
	ldb 4,7
	hrre 4,4
	add 2,4
	addi 3,1
	sojge 1,%L1282	; doloop_end
%L1281:
	move 1,2
	pop 17,10
	popj 17,

loop_with_call_each_time:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	movei 11,0
	caml 11,1
	jrst %L1290
	move 10,1
%L1288:
	pushj 17,f
	add 11,1
	sojn 10,%L1288	; decrement_and_branch_until_zero
%L1290:
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
	jrst %L1296
%L1298:
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,
%L1296:
	move 10,11
	andi 10,77
	pushj 17,f
	movem 1,s_arr(10)
	addi 11,1
	camge 11,12
	jrst %L1296
	jrst %L1298

q_loop_store_call_each_time:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	movei 11,0
	camge 11,1
	jrst %L1304
%L1306:
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,
%L1304:
	move 4,11
	andi 4,77
	move 10,[POINT 9,q_arr,8]
	move 0,4
	jumple 0,.+3
	ibp 10
	sojg 0,.-1
	pushj 17,f
	dpb 1,10
	addi 11,1
	camge 11,12
	jrst %L1304
	jrst %L1306

h_loop_store_call_each_time:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	movei 11,0
	camge 11,1
	jrst %L1312
%L1314:
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,
%L1312:
	move 4,11
	andi 4,77
	move 10,[POINT 18,h_arr,17]
	move 0,4
	jumple 0,.+3
	ibp 10
	sojg 0,.-1
	pushj 17,f
	dpb 1,10	; movhi
	addi 11,1
	camge 11,12
	jrst %L1312
	jrst %L1314

q_to_s_copy_32:
	movei 3,0
	move 1,[POINT 9,q_arr,8]
	movei 2,37
%L1323:
	move 4,1
	move 0,3
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	trne 4,400
	orcmi 4,777
	movem 4,s_arr(3)
	addi 3,1
	sojge 2,%L1323	; doloop_end
	popj 17,

h_to_s_copy_32:
	movei 2,0
	move 1,[POINT 18,h_arr,17]
	movei 3,37
%L1332:
	move 4,1
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	hrrem 4,s_arr(2)
	addi 2,1
	sojge 3,%L1332	; doloop_end
	popj 17,

s_to_q_copy_32:
	movei 3,0
	movei 2,37
%L1341:
	move 4,[POINT 9,q_arr,8]
	move 0,3
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	move 6,s_arr(3)
	dpb 6,4
	addi 3,1
	sojge 2,%L1341	; doloop_end
	popj 17,

s_to_h_copy_32:
	movei 2,0
	movei 1,37
%L1350:
	move 3,[POINT 18,h_arr,17]
	move 0,2
	jumple 0,.+3
	ibp 3
	sojg 0,.-1
	hrrz 4,s_arr(2)
	dpb 4,3	; movhi
	addi 2,1
	sojge 1,%L1350	; doloop_end
	popj 17,

c_to_s_copy_32:
	movei 3,0
	move 1,[POINT 9,c_arr,8]
	movei 2,37
%L1359:
	move 4,1
	move 0,3
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	movem 4,s_arr(3)
	addi 3,1
	sojge 2,%L1359	; doloop_end
	popj 17,

s_to_c_copy_32:
	movei 3,0
	movei 2,37
%L1368:
	move 4,[POINT 9,c_arr,8]
	move 0,3
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	move 6,s_arr(3)
	dpb 6,4
	addi 3,1
	sojge 2,%L1368	; doloop_end
	popj 17,

s_nested_zero:
	movei 1,0
%L1379:
	move 3,1
	lsh 3,3
	movei 2,7
%L1384:
	move 4,3
	andi 4,77
	setzm s_arr(4)
	addi 3,1
	sojge 2,%L1384	; doloop_end
	addi 1,1
	caig 1,3
	jrst %L1379
	popj 17,

s_nested_sum:
	setzb 1,6
%L1395:
	move 3,6
	lsh 3,3
	movei 2,7
%L1400:
	move 4,3
	andi 4,77
	add 1,s_arr(4)
	addi 3,1
	sojge 2,%L1400	; doloop_end
	addi 6,1
	caig 6,3
	jrst %L1395
	popj 17,

q_nested_zero:
	setzb 6,1
%L1411:
	move 3,6
	lsh 3,3
	movei 2,7
%L1416:
	move 4,3
	andi 4,77
	move 7,[POINT 9,q_arr,8]
	move 0,4
	jumple 0,.+3
	ibp 7
	sojg 0,.-1
	dpb 1,7
	addi 3,1
	sojge 2,%L1416	; doloop_end
	addi 6,1
	caig 6,3
	jrst %L1411
	popj 17,

q_nested_sum:
	setzb 1,7
	move 6,[POINT 9,q_arr,8]
%L1427:
	move 3,7
	lsh 3,3
	movei 2,7
%L1432:
	move 4,3
	andi 4,77
	move 5,6
	move 0,4
	jumple 0,.+3
	ibp 5
	sojg 0,.-1
	ldb 4,5
	trne 4,400
	orcmi 4,777
	add 1,4
	addi 3,1
	sojge 2,%L1432	; doloop_end
	addi 7,1
	caig 7,3
	jrst %L1427
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
