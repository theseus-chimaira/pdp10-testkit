
ret_char6_char7:
	popj 17,

add0_char6_char7:
	popj 17,

add1_char6_char7:
	ibp 1
	popj 17,

addi_char6_char7:
	jumple 2,%L11
%L10:
	ibp 1
	sojg 2,%L10	; decrement_and_branch_until_zero
%L11:
	jumpe 2,%L13
%L12:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L12
%L13:
	popj 17,

save_char6_char7:
	movem 1,v_6
	popj 17,

reload_char6_char7:
	push 17,10
	move 10,v_7
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_char6_char7:
	ldb 1,1
	popj 17,

load1_char6_char7:
	ildb 1,1
	popj 17,

load5_char6_char7:
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ildb 1,1
	popj 17,

loadi_char6_char7:
	jumple 2,%L28
%L27:
	ibp 1
	sojg 2,%L27	; decrement_and_branch_until_zero
%L28:
	jumpe 2,%L30
%L29:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L29
%L30:
	ldb 1,1
	popj 17,

store0_char6_char7:
	dpb 2,1
	popj 17,

store1_char6_char7:
	addi 2,1
	idpb 2,1
	popj 17,

storei_char6_char7:
	jumple 2,%L39
%L38:
	ibp 1
	sojg 2,%L38	; decrement_and_branch_until_zero
%L39:
	jumpe 2,%L41
%L40:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L40
%L41:
	dpb 3,1
	popj 17,

diff_char6_char7:
	move 4,1
	sub 4,2
	muli 4,14
	move 1,5
	ash 1,-1
	add 1,%BADL6(4)
	popj 17,

sum_char6_char7:
	ldb 3,1
	ildb 4,1
	add 3,4
	move 4,1
	ibp 4
	ildb 4,4
	add 3,4
	ibp 1
	ibp 1
	ildb 4,1
	add 3,4
	move 1,3
	popj 17,

ret_char6_char8:
	popj 17,

add0_char6_char8:
	popj 17,

add1_char6_char8:
	ibp 1
	popj 17,

addi_char6_char8:
	jumple 2,%L59
%L58:
	ibp 1
	sojg 2,%L58	; decrement_and_branch_until_zero
%L59:
	jumpe 2,%L61
%L60:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L60
%L61:
	popj 17,

save_char6_char8:
	movem 1,v_6
	popj 17,

reload_char6_char8:
	push 17,10
	move 10,v_8
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_char6_char8:
	ldb 1,1
	popj 17,

load1_char6_char8:
	ildb 1,1
	popj 17,

load5_char6_char8:
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ildb 1,1
	popj 17,

loadi_char6_char8:
	jumple 2,%L76
%L75:
	ibp 1
	sojg 2,%L75	; decrement_and_branch_until_zero
%L76:
	jumpe 2,%L78
%L77:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L77
%L78:
	ldb 1,1
	popj 17,

store0_char6_char8:
	dpb 2,1
	popj 17,

store1_char6_char8:
	addi 2,1
	idpb 2,1
	popj 17,

storei_char6_char8:
	jumple 2,%L87
%L86:
	ibp 1
	sojg 2,%L86	; decrement_and_branch_until_zero
%L87:
	jumpe 2,%L89
%L88:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L88
%L89:
	dpb 3,1
	popj 17,

diff_char6_char8:
	move 4,1
	sub 4,2
	muli 4,14
	move 1,5
	ash 1,-1
	add 1,%BADL6(4)
	popj 17,

sum_char6_char8:
	ldb 3,1
	ildb 4,1
	add 3,4
	move 4,1
	ibp 4
	ildb 4,4
	add 3,4
	ibp 1
	ibp 1
	ildb 4,1
	add 3,4
	move 1,3
	popj 17,

ret_char6_char9:
	popj 17,

add0_char6_char9:
	popj 17,

add1_char6_char9:
	ibp 1
	popj 17,

addi_char6_char9:
	jumple 2,%L107
%L106:
	ibp 1
	sojg 2,%L106	; decrement_and_branch_until_zero
%L107:
	jumpe 2,%L109
%L108:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L108
%L109:
	popj 17,

save_char6_char9:
	movem 1,v_6
	popj 17,

reload_char6_char9:
	push 17,10
	move 10,v_9
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_char6_char9:
	ldb 1,1
	popj 17,

load1_char6_char9:
	ildb 1,1
	popj 17,

load5_char6_char9:
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ildb 1,1
	popj 17,

loadi_char6_char9:
	jumple 2,%L124
%L123:
	ibp 1
	sojg 2,%L123	; decrement_and_branch_until_zero
%L124:
	jumpe 2,%L126
%L125:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L125
%L126:
	ldb 1,1
	popj 17,

store0_char6_char9:
	dpb 2,1
	popj 17,

store1_char6_char9:
	addi 2,1
	idpb 2,1
	popj 17,

storei_char6_char9:
	jumple 2,%L135
%L134:
	ibp 1
	sojg 2,%L134	; decrement_and_branch_until_zero
%L135:
	jumpe 2,%L137
%L136:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L136
%L137:
	dpb 3,1
	popj 17,

diff_char6_char9:
	move 4,1
	sub 4,2
	muli 4,14
	move 1,5
	ash 1,-1
	add 1,%BADL6(4)
	popj 17,

sum_char6_char9:
	ldb 3,1
	ildb 4,1
	add 3,4
	move 4,1
	ibp 4
	ildb 4,4
	add 3,4
	ibp 1
	ibp 1
	ildb 4,1
	add 3,4
	move 1,3
	popj 17,

ret_char6_char:
	popj 17,

add0_char6_char:
	popj 17,

add1_char6_char:
	ibp 1
	popj 17,

addi_char6_char:
	jumple 2,%L155
%L154:
	ibp 1
	sojg 2,%L154	; decrement_and_branch_until_zero
%L155:
	jumpe 2,%L157
%L156:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L156
%L157:
	popj 17,

save_char6_char:
	movem 1,v_6
	popj 17,

reload_char6_char:
	push 17,10
	move 10,v_c
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_char6_char:
	ldb 1,1
	popj 17,

load1_char6_char:
	ildb 1,1
	popj 17,

load5_char6_char:
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ildb 1,1
	popj 17,

loadi_char6_char:
	jumple 2,%L172
%L171:
	ibp 1
	sojg 2,%L171	; decrement_and_branch_until_zero
%L172:
	jumpe 2,%L174
%L173:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L173
%L174:
	ldb 1,1
	popj 17,

store0_char6_char:
	dpb 2,1
	popj 17,

store1_char6_char:
	addi 2,1
	idpb 2,1
	popj 17,

storei_char6_char:
	jumple 2,%L183
%L182:
	ibp 1
	sojg 2,%L182	; decrement_and_branch_until_zero
%L183:
	jumpe 2,%L185
%L184:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L184
%L185:
	dpb 3,1
	popj 17,

diff_char6_char:
	move 4,1
	sub 4,2
	muli 4,14
	move 1,5
	ash 1,-1
	add 1,%BADL6(4)
	popj 17,

sum_char6_char:
	ldb 3,1
	ildb 4,1
	add 3,4
	move 4,1
	ibp 4
	ildb 4,4
	add 3,4
	ibp 1
	ibp 1
	ildb 4,1
	add 3,4
	move 1,3
	popj 17,

ret_char7_char6:
	popj 17,

add0_char7_char6:
	popj 17,

add1_char7_char6:
	ibp 1
	popj 17,

addi_char7_char6:
	jumple 2,%L203
%L202:
	ibp 1
	sojg 2,%L202	; decrement_and_branch_until_zero
%L203:
	jumpe 2,%L205
%L204:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L204
%L205:
	popj 17,

save_char7_char6:
	movem 1,v_7
	popj 17,

reload_char7_char6:
	push 17,10
	move 10,v_6
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_char7_char6:
	ldb 1,1
	popj 17,

load1_char7_char6:
	ildb 1,1
	popj 17,

load5_char7_char6:
	addi 1,1
	ldb 1,1
	popj 17,

loadi_char7_char6:
	jumple 2,%L220
%L219:
	ibp 1
	sojg 2,%L219	; decrement_and_branch_until_zero
%L220:
	jumpe 2,%L222
%L221:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L221
%L222:
	ldb 1,1
	popj 17,

store0_char7_char6:
	dpb 2,1
	popj 17,

store1_char7_char6:
	addi 2,1
	idpb 2,1
	popj 17,

storei_char7_char6:
	jumple 2,%L231
%L230:
	ibp 1
	sojg 2,%L230	; decrement_and_branch_until_zero
%L231:
	jumpe 2,%L233
%L232:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L232
%L233:
	dpb 3,1
	popj 17,

diff_char7_char6:
	move 4,1
	sub 4,2
	muli 4,12
	move 1,5
	ash 1,-1
	add 1,%BADL7(4)
	popj 17,

sum_char7_char6:
	ldb 3,1
	ildb 4,1
	add 3,4
	move 4,1
	ibp 4
	ildb 4,4
	add 3,4
	ibp 1
	ibp 1
	ildb 4,1
	add 3,4
	move 1,3
	popj 17,

ret_char7_char8:
	popj 17,

add0_char7_char8:
	popj 17,

add1_char7_char8:
	ibp 1
	popj 17,

addi_char7_char8:
	jumple 2,%L251
%L250:
	ibp 1
	sojg 2,%L250	; decrement_and_branch_until_zero
%L251:
	jumpe 2,%L253
%L252:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L252
%L253:
	popj 17,

save_char7_char8:
	movem 1,v_7
	popj 17,

reload_char7_char8:
	push 17,10
	move 10,v_8
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_char7_char8:
	ldb 1,1
	popj 17,

load1_char7_char8:
	ildb 1,1
	popj 17,

load5_char7_char8:
	addi 1,1
	ldb 1,1
	popj 17,

loadi_char7_char8:
	jumple 2,%L268
%L267:
	ibp 1
	sojg 2,%L267	; decrement_and_branch_until_zero
%L268:
	jumpe 2,%L270
%L269:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L269
%L270:
	ldb 1,1
	popj 17,

store0_char7_char8:
	dpb 2,1
	popj 17,

store1_char7_char8:
	addi 2,1
	idpb 2,1
	popj 17,

storei_char7_char8:
	jumple 2,%L279
%L278:
	ibp 1
	sojg 2,%L278	; decrement_and_branch_until_zero
%L279:
	jumpe 2,%L281
%L280:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L280
%L281:
	dpb 3,1
	popj 17,

diff_char7_char8:
	move 4,1
	sub 4,2
	muli 4,12
	move 1,5
	ash 1,-1
	add 1,%BADL7(4)
	popj 17,

sum_char7_char8:
	ldb 3,1
	ildb 4,1
	add 3,4
	move 4,1
	ibp 4
	ildb 4,4
	add 3,4
	ibp 1
	ibp 1
	ildb 4,1
	add 3,4
	move 1,3
	popj 17,

ret_char7_char9:
	popj 17,

add0_char7_char9:
	popj 17,

add1_char7_char9:
	ibp 1
	popj 17,

addi_char7_char9:
	jumple 2,%L299
%L298:
	ibp 1
	sojg 2,%L298	; decrement_and_branch_until_zero
%L299:
	jumpe 2,%L301
%L300:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L300
%L301:
	popj 17,

save_char7_char9:
	movem 1,v_7
	popj 17,

reload_char7_char9:
	push 17,10
	move 10,v_9
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_char7_char9:
	ldb 1,1
	popj 17,

load1_char7_char9:
	ildb 1,1
	popj 17,

load5_char7_char9:
	addi 1,1
	ldb 1,1
	popj 17,

loadi_char7_char9:
	jumple 2,%L316
%L315:
	ibp 1
	sojg 2,%L315	; decrement_and_branch_until_zero
%L316:
	jumpe 2,%L318
%L317:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L317
%L318:
	ldb 1,1
	popj 17,

store0_char7_char9:
	dpb 2,1
	popj 17,

store1_char7_char9:
	addi 2,1
	idpb 2,1
	popj 17,

storei_char7_char9:
	jumple 2,%L327
%L326:
	ibp 1
	sojg 2,%L326	; decrement_and_branch_until_zero
%L327:
	jumpe 2,%L329
%L328:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L328
%L329:
	dpb 3,1
	popj 17,

diff_char7_char9:
	move 4,1
	sub 4,2
	muli 4,12
	move 1,5
	ash 1,-1
	add 1,%BADL7(4)
	popj 17,

sum_char7_char9:
	ldb 3,1
	ildb 4,1
	add 3,4
	move 4,1
	ibp 4
	ildb 4,4
	add 3,4
	ibp 1
	ibp 1
	ildb 4,1
	add 3,4
	move 1,3
	popj 17,

ret_char7_char:
	popj 17,

add0_char7_char:
	popj 17,

add1_char7_char:
	ibp 1
	popj 17,

addi_char7_char:
	jumple 2,%L347
%L346:
	ibp 1
	sojg 2,%L346	; decrement_and_branch_until_zero
%L347:
	jumpe 2,%L349
%L348:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L348
%L349:
	popj 17,

save_char7_char:
	movem 1,v_7
	popj 17,

reload_char7_char:
	push 17,10
	move 10,v_c
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_char7_char:
	ldb 1,1
	popj 17,

load1_char7_char:
	ildb 1,1
	popj 17,

load5_char7_char:
	addi 1,1
	ldb 1,1
	popj 17,

loadi_char7_char:
	jumple 2,%L364
%L363:
	ibp 1
	sojg 2,%L363	; decrement_and_branch_until_zero
%L364:
	jumpe 2,%L366
%L365:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L365
%L366:
	ldb 1,1
	popj 17,

store0_char7_char:
	dpb 2,1
	popj 17,

store1_char7_char:
	addi 2,1
	idpb 2,1
	popj 17,

storei_char7_char:
	jumple 2,%L375
%L374:
	ibp 1
	sojg 2,%L374	; decrement_and_branch_until_zero
%L375:
	jumpe 2,%L377
%L376:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L376
%L377:
	dpb 3,1
	popj 17,

diff_char7_char:
	move 4,1
	sub 4,2
	muli 4,12
	move 1,5
	ash 1,-1
	add 1,%BADL7(4)
	popj 17,

sum_char7_char:
	ldb 3,1
	ildb 4,1
	add 3,4
	move 4,1
	ibp 4
	ildb 4,4
	add 3,4
	ibp 1
	ibp 1
	ildb 4,1
	add 3,4
	move 1,3
	popj 17,

ret_char8_char6:
	popj 17,

add0_char8_char6:
	popj 17,

add1_char8_char6:
	ibp 1
	popj 17,

addi_char8_char6:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L395
%L394:
	ibp 1
	sojn 4,%L394	; decrement_and_branch_until_zero
%L395:
	popj 17,

save_char8_char6:
	movem 1,v_8
	popj 17,

reload_char8_char6:
	push 17,10
	move 10,v_6
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_char8_char6:
	ldb 1,1
	popj 17,

load1_char8_char6:
	ildb 1,1
	popj 17,

load5_char8_char6:
	addi 1,1
	ildb 1,1
	popj 17,

loadi_char8_char6:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L410
%L409:
	ibp 1
	sojn 4,%L409	; decrement_and_branch_until_zero
%L410:
	ldb 1,1
	popj 17,

store0_char8_char6:
	dpb 2,1
	popj 17,

store1_char8_char6:
	addi 2,1
	idpb 2,1
	popj 17,

storei_char8_char6:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L419
%L418:
	ibp 1
	sojn 4,%L418	; decrement_and_branch_until_zero
%L419:
	dpb 3,1
	popj 17,

diff_char8_char6:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL8(4)
	popj 17,

sum_char8_char6:
	move 2,1
	ldb 1,1
	move 4,2
	ildb 3,4
	add 1,3
	ibp 4
	ildb 4,4
	add 1,4
	addi 2,1
	ldb 4,2
	add 1,4
	popj 17,

ret_char8_char7:
	popj 17,

add0_char8_char7:
	popj 17,

add1_char8_char7:
	ibp 1
	popj 17,

addi_char8_char7:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L437
%L436:
	ibp 1
	sojn 4,%L436	; decrement_and_branch_until_zero
%L437:
	popj 17,

save_char8_char7:
	movem 1,v_8
	popj 17,

reload_char8_char7:
	push 17,10
	move 10,v_7
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_char8_char7:
	ldb 1,1
	popj 17,

load1_char8_char7:
	ildb 1,1
	popj 17,

load5_char8_char7:
	addi 1,1
	ildb 1,1
	popj 17,

loadi_char8_char7:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L452
%L451:
	ibp 1
	sojn 4,%L451	; decrement_and_branch_until_zero
%L452:
	ldb 1,1
	popj 17,

store0_char8_char7:
	dpb 2,1
	popj 17,

store1_char8_char7:
	addi 2,1
	idpb 2,1
	popj 17,

storei_char8_char7:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L461
%L460:
	ibp 1
	sojn 4,%L460	; decrement_and_branch_until_zero
%L461:
	dpb 3,1
	popj 17,

diff_char8_char7:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL8(4)
	popj 17,

sum_char8_char7:
	move 2,1
	ldb 1,1
	move 4,2
	ildb 3,4
	add 1,3
	ibp 4
	ildb 4,4
	add 1,4
	addi 2,1
	ldb 4,2
	add 1,4
	popj 17,

ret_char8_char9:
	popj 17,

add0_char8_char9:
	popj 17,

add1_char8_char9:
	ibp 1
	popj 17,

addi_char8_char9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L479
%L478:
	ibp 1
	sojn 4,%L478	; decrement_and_branch_until_zero
%L479:
	popj 17,

save_char8_char9:
	movem 1,v_8
	popj 17,

reload_char8_char9:
	push 17,10
	move 10,v_9
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_char8_char9:
	ldb 1,1
	popj 17,

load1_char8_char9:
	ildb 1,1
	popj 17,

load5_char8_char9:
	addi 1,1
	ildb 1,1
	popj 17,

loadi_char8_char9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L494
%L493:
	ibp 1
	sojn 4,%L493	; decrement_and_branch_until_zero
%L494:
	ldb 1,1
	popj 17,

store0_char8_char9:
	dpb 2,1
	popj 17,

store1_char8_char9:
	addi 2,1
	idpb 2,1
	popj 17,

storei_char8_char9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L503
%L502:
	ibp 1
	sojn 4,%L502	; decrement_and_branch_until_zero
%L503:
	dpb 3,1
	popj 17,

diff_char8_char9:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL8(4)
	popj 17,

sum_char8_char9:
	move 2,1
	ldb 1,1
	move 4,2
	ildb 3,4
	add 1,3
	ibp 4
	ildb 4,4
	add 1,4
	addi 2,1
	ldb 4,2
	add 1,4
	popj 17,

ret_char8_char:
	popj 17,

add0_char8_char:
	popj 17,

add1_char8_char:
	ibp 1
	popj 17,

addi_char8_char:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L521
%L520:
	ibp 1
	sojn 4,%L520	; decrement_and_branch_until_zero
%L521:
	popj 17,

save_char8_char:
	movem 1,v_8
	popj 17,

reload_char8_char:
	push 17,10
	move 10,v_c
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_char8_char:
	ldb 1,1
	popj 17,

load1_char8_char:
	ildb 1,1
	popj 17,

load5_char8_char:
	addi 1,1
	ildb 1,1
	popj 17,

loadi_char8_char:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L536
%L535:
	ibp 1
	sojn 4,%L535	; decrement_and_branch_until_zero
%L536:
	ldb 1,1
	popj 17,

store0_char8_char:
	dpb 2,1
	popj 17,

store1_char8_char:
	addi 2,1
	idpb 2,1
	popj 17,

storei_char8_char:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L545
%L544:
	ibp 1
	sojn 4,%L544	; decrement_and_branch_until_zero
%L545:
	dpb 3,1
	popj 17,

diff_char8_char:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL8(4)
	popj 17,

sum_char8_char:
	move 2,1
	ldb 1,1
	move 4,2
	ildb 3,4
	add 1,3
	ibp 4
	ildb 4,4
	add 1,4
	addi 2,1
	ldb 4,2
	add 1,4
	popj 17,

ret_char9_char6:
	popj 17,

add0_char9_char6:
	popj 17,

add1_char9_char6:
	ibp 1
	popj 17,

addi_char9_char6:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L563
%L562:
	ibp 1
	sojn 4,%L562	; decrement_and_branch_until_zero
%L563:
	popj 17,

save_char9_char6:
	movem 1,v_9
	popj 17,

reload_char9_char6:
	push 17,10
	move 10,v_6
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_char9_char6:
	ldb 1,1
	popj 17,

load1_char9_char6:
	ildb 1,1
	popj 17,

load5_char9_char6:
	addi 1,1
	ildb 1,1
	popj 17,

loadi_char9_char6:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L578
%L577:
	ibp 1
	sojn 4,%L577	; decrement_and_branch_until_zero
%L578:
	ldb 1,1
	popj 17,

store0_char9_char6:
	dpb 2,1
	popj 17,

store1_char9_char6:
	addi 2,1
	idpb 2,1
	popj 17,

storei_char9_char6:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L587
%L586:
	ibp 1
	sojn 4,%L586	; decrement_and_branch_until_zero
%L587:
	dpb 3,1
	popj 17,

diff_char9_char6:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

sum_char9_char6:
	move 4,1
	ildb 3,4
	ldb 6,1
	add 3,6
	ibp 4
	ildb 4,4
	add 3,4
	addi 1,1
	ldb 1,1
	add 3,1
	move 1,3
	popj 17,

ret_char9_char7:
	popj 17,

add0_char9_char7:
	popj 17,

add1_char9_char7:
	ibp 1
	popj 17,

addi_char9_char7:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L605
%L604:
	ibp 1
	sojn 4,%L604	; decrement_and_branch_until_zero
%L605:
	popj 17,

save_char9_char7:
	movem 1,v_9
	popj 17,

reload_char9_char7:
	push 17,10
	move 10,v_7
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_char9_char7:
	ldb 1,1
	popj 17,

load1_char9_char7:
	ildb 1,1
	popj 17,

load5_char9_char7:
	addi 1,1
	ildb 1,1
	popj 17,

loadi_char9_char7:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L620
%L619:
	ibp 1
	sojn 4,%L619	; decrement_and_branch_until_zero
%L620:
	ldb 1,1
	popj 17,

store0_char9_char7:
	dpb 2,1
	popj 17,

store1_char9_char7:
	addi 2,1
	idpb 2,1
	popj 17,

storei_char9_char7:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L629
%L628:
	ibp 1
	sojn 4,%L628	; decrement_and_branch_until_zero
%L629:
	dpb 3,1
	popj 17,

diff_char9_char7:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

sum_char9_char7:
	move 4,1
	ildb 3,4
	ldb 6,1
	add 3,6
	ibp 4
	ildb 4,4
	add 3,4
	addi 1,1
	ldb 1,1
	add 3,1
	move 1,3
	popj 17,

ret_char9_char8:
	popj 17,

add0_char9_char8:
	popj 17,

add1_char9_char8:
	ibp 1
	popj 17,

addi_char9_char8:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L647
%L646:
	ibp 1
	sojn 4,%L646	; decrement_and_branch_until_zero
%L647:
	popj 17,

save_char9_char8:
	movem 1,v_9
	popj 17,

reload_char9_char8:
	push 17,10
	move 10,v_8
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_char9_char8:
	ldb 1,1
	popj 17,

load1_char9_char8:
	ildb 1,1
	popj 17,

load5_char9_char8:
	addi 1,1
	ildb 1,1
	popj 17,

loadi_char9_char8:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L662
%L661:
	ibp 1
	sojn 4,%L661	; decrement_and_branch_until_zero
%L662:
	ldb 1,1
	popj 17,

store0_char9_char8:
	dpb 2,1
	popj 17,

store1_char9_char8:
	addi 2,1
	idpb 2,1
	popj 17,

storei_char9_char8:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L671
%L670:
	ibp 1
	sojn 4,%L670	; decrement_and_branch_until_zero
%L671:
	dpb 3,1
	popj 17,

diff_char9_char8:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

sum_char9_char8:
	move 4,1
	ildb 3,4
	ldb 6,1
	add 3,6
	ibp 4
	ildb 4,4
	add 3,4
	addi 1,1
	ldb 1,1
	add 3,1
	move 1,3
	popj 17,

ret_char9_char:
	popj 17,

add0_char9_char:
	popj 17,

add1_char9_char:
	ibp 1
	popj 17,

addi_char9_char:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L689
%L688:
	ibp 1
	sojn 4,%L688	; decrement_and_branch_until_zero
%L689:
	popj 17,

save_char9_char:
	movem 1,v_9
	popj 17,

reload_char9_char:
	push 17,10
	move 10,v_c
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_char9_char:
	ldb 1,1
	popj 17,

load1_char9_char:
	ildb 1,1
	popj 17,

load5_char9_char:
	addi 1,1
	ildb 1,1
	popj 17,

loadi_char9_char:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L704
%L703:
	ibp 1
	sojn 4,%L703	; decrement_and_branch_until_zero
%L704:
	ldb 1,1
	popj 17,

store0_char9_char:
	dpb 2,1
	popj 17,

store1_char9_char:
	addi 2,1
	idpb 2,1
	popj 17,

storei_char9_char:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L713
%L712:
	ibp 1
	sojn 4,%L712	; decrement_and_branch_until_zero
%L713:
	dpb 3,1
	popj 17,

diff_char9_char:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

sum_char9_char:
	move 4,1
	ildb 3,4
	ldb 6,1
	add 3,6
	ibp 4
	ildb 4,4
	add 3,4
	addi 1,1
	ldb 1,1
	add 3,1
	move 1,3
	popj 17,

ret_char_char6:
	popj 17,

add0_char_char6:
	popj 17,

add1_char_char6:
	ibp 1
	popj 17,

addi_char_char6:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L731
%L730:
	ibp 1
	sojn 4,%L730	; decrement_and_branch_until_zero
%L731:
	popj 17,

save_char_char6:
	movem 1,v_c
	popj 17,

reload_char_char6:
	push 17,10
	move 10,v_6
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_char_char6:
	ldb 1,1
	popj 17,

load1_char_char6:
	ildb 1,1
	popj 17,

load5_char_char6:
	addi 1,1
	ildb 1,1
	popj 17,

loadi_char_char6:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L746
%L745:
	ibp 1
	sojn 4,%L745	; decrement_and_branch_until_zero
%L746:
	ldb 1,1
	popj 17,

store0_char_char6:
	dpb 2,1
	popj 17,

store1_char_char6:
	addi 2,1
	idpb 2,1
	popj 17,

storei_char_char6:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L755
%L754:
	ibp 1
	sojn 4,%L754	; decrement_and_branch_until_zero
%L755:
	dpb 3,1
	popj 17,

diff_char_char6:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

sum_char_char6:
	move 4,1
	ildb 3,4
	ldb 6,1
	add 3,6
	ibp 4
	ildb 4,4
	add 3,4
	addi 1,1
	ldb 1,1
	add 3,1
	move 1,3
	popj 17,

ret_char_char7:
	popj 17,

add0_char_char7:
	popj 17,

add1_char_char7:
	ibp 1
	popj 17,

addi_char_char7:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L773
%L772:
	ibp 1
	sojn 4,%L772	; decrement_and_branch_until_zero
%L773:
	popj 17,

save_char_char7:
	movem 1,v_c
	popj 17,

reload_char_char7:
	push 17,10
	move 10,v_7
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_char_char7:
	ldb 1,1
	popj 17,

load1_char_char7:
	ildb 1,1
	popj 17,

load5_char_char7:
	addi 1,1
	ildb 1,1
	popj 17,

loadi_char_char7:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L788
%L787:
	ibp 1
	sojn 4,%L787	; decrement_and_branch_until_zero
%L788:
	ldb 1,1
	popj 17,

store0_char_char7:
	dpb 2,1
	popj 17,

store1_char_char7:
	addi 2,1
	idpb 2,1
	popj 17,

storei_char_char7:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L797
%L796:
	ibp 1
	sojn 4,%L796	; decrement_and_branch_until_zero
%L797:
	dpb 3,1
	popj 17,

diff_char_char7:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

sum_char_char7:
	move 4,1
	ildb 3,4
	ldb 6,1
	add 3,6
	ibp 4
	ildb 4,4
	add 3,4
	addi 1,1
	ldb 1,1
	add 3,1
	move 1,3
	popj 17,

ret_char_char8:
	popj 17,

add0_char_char8:
	popj 17,

add1_char_char8:
	ibp 1
	popj 17,

addi_char_char8:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L815
%L814:
	ibp 1
	sojn 4,%L814	; decrement_and_branch_until_zero
%L815:
	popj 17,

save_char_char8:
	movem 1,v_c
	popj 17,

reload_char_char8:
	push 17,10
	move 10,v_8
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_char_char8:
	ldb 1,1
	popj 17,

load1_char_char8:
	ildb 1,1
	popj 17,

load5_char_char8:
	addi 1,1
	ildb 1,1
	popj 17,

loadi_char_char8:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L830
%L829:
	ibp 1
	sojn 4,%L829	; decrement_and_branch_until_zero
%L830:
	ldb 1,1
	popj 17,

store0_char_char8:
	dpb 2,1
	popj 17,

store1_char_char8:
	addi 2,1
	idpb 2,1
	popj 17,

storei_char_char8:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L839
%L838:
	ibp 1
	sojn 4,%L838	; decrement_and_branch_until_zero
%L839:
	dpb 3,1
	popj 17,

diff_char_char8:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

sum_char_char8:
	move 4,1
	ildb 3,4
	ldb 6,1
	add 3,6
	ibp 4
	ildb 4,4
	add 3,4
	addi 1,1
	ldb 1,1
	add 3,1
	move 1,3
	popj 17,

ret_char_char9:
	popj 17,

add0_char_char9:
	popj 17,

add1_char_char9:
	ibp 1
	popj 17,

addi_char_char9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L857
%L856:
	ibp 1
	sojn 4,%L856	; decrement_and_branch_until_zero
%L857:
	popj 17,

save_char_char9:
	movem 1,v_c
	popj 17,

reload_char_char9:
	push 17,10
	move 10,v_9
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_char_char9:
	ldb 1,1
	popj 17,

load1_char_char9:
	ildb 1,1
	popj 17,

load5_char_char9:
	addi 1,1
	ildb 1,1
	popj 17,

loadi_char_char9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L872
%L871:
	ibp 1
	sojn 4,%L871	; decrement_and_branch_until_zero
%L872:
	ldb 1,1
	popj 17,

store0_char_char9:
	dpb 2,1
	popj 17,

store1_char_char9:
	addi 2,1
	idpb 2,1
	popj 17,

storei_char_char9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L881
%L880:
	ibp 1
	sojn 4,%L880	; decrement_and_branch_until_zero
%L881:
	dpb 3,1
	popj 17,

diff_char_char9:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

sum_char_char9:
	move 4,1
	ildb 3,4
	ldb 6,1
	add 3,6
	ibp 4
	ildb 4,4
	add 3,4
	addi 1,1
	ldb 1,1
	add 3,1
	move 1,3
	popj 17,

ret_uchar_char6:
	popj 17,

add0_uchar_char6:
	popj 17,

add1_uchar_char6:
	ibp 1
	popj 17,

addi_uchar_char6:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L899
%L898:
	ibp 1
	sojn 4,%L898	; decrement_and_branch_until_zero
%L899:
	popj 17,

save_uchar_char6:
	movem 1,v_uc
	popj 17,

reload_uchar_char6:
	push 17,10
	move 10,v_6
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_uchar_char6:
	ldb 1,1
	popj 17,

load1_uchar_char6:
	ildb 1,1
	popj 17,

load5_uchar_char6:
	addi 1,1
	ildb 1,1
	popj 17,

loadi_uchar_char6:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L914
%L913:
	ibp 1
	sojn 4,%L913	; decrement_and_branch_until_zero
%L914:
	ldb 1,1
	popj 17,

store0_uchar_char6:
	dpb 2,1
	popj 17,

store1_uchar_char6:
	addi 2,1
	idpb 2,1
	popj 17,

storei_uchar_char6:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L923
%L922:
	ibp 1
	sojn 4,%L922	; decrement_and_branch_until_zero
%L923:
	dpb 3,1
	popj 17,

diff_uchar_char6:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

sum_uchar_char6:
	move 4,1
	ildb 3,4
	ldb 6,1
	add 3,6
	ibp 4
	ildb 4,4
	add 3,4
	addi 1,1
	ldb 1,1
	add 3,1
	move 1,3
	popj 17,

ret_uchar_char7:
	popj 17,

add0_uchar_char7:
	popj 17,

add1_uchar_char7:
	ibp 1
	popj 17,

addi_uchar_char7:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L941
%L940:
	ibp 1
	sojn 4,%L940	; decrement_and_branch_until_zero
%L941:
	popj 17,

save_uchar_char7:
	movem 1,v_uc
	popj 17,

reload_uchar_char7:
	push 17,10
	move 10,v_7
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_uchar_char7:
	ldb 1,1
	popj 17,

load1_uchar_char7:
	ildb 1,1
	popj 17,

load5_uchar_char7:
	addi 1,1
	ildb 1,1
	popj 17,

loadi_uchar_char7:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L956
%L955:
	ibp 1
	sojn 4,%L955	; decrement_and_branch_until_zero
%L956:
	ldb 1,1
	popj 17,

store0_uchar_char7:
	dpb 2,1
	popj 17,

store1_uchar_char7:
	addi 2,1
	idpb 2,1
	popj 17,

storei_uchar_char7:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L965
%L964:
	ibp 1
	sojn 4,%L964	; decrement_and_branch_until_zero
%L965:
	dpb 3,1
	popj 17,

diff_uchar_char7:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

sum_uchar_char7:
	move 4,1
	ildb 3,4
	ldb 6,1
	add 3,6
	ibp 4
	ildb 4,4
	add 3,4
	addi 1,1
	ldb 1,1
	add 3,1
	move 1,3
	popj 17,

ret_uchar_char8:
	popj 17,

add0_uchar_char8:
	popj 17,

add1_uchar_char8:
	ibp 1
	popj 17,

addi_uchar_char8:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L983
%L982:
	ibp 1
	sojn 4,%L982	; decrement_and_branch_until_zero
%L983:
	popj 17,

save_uchar_char8:
	movem 1,v_uc
	popj 17,

reload_uchar_char8:
	push 17,10
	move 10,v_8
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_uchar_char8:
	ldb 1,1
	popj 17,

load1_uchar_char8:
	ildb 1,1
	popj 17,

load5_uchar_char8:
	addi 1,1
	ildb 1,1
	popj 17,

loadi_uchar_char8:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L998
%L997:
	ibp 1
	sojn 4,%L997	; decrement_and_branch_until_zero
%L998:
	ldb 1,1
	popj 17,

store0_uchar_char8:
	dpb 2,1
	popj 17,

store1_uchar_char8:
	addi 2,1
	idpb 2,1
	popj 17,

storei_uchar_char8:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1007
%L1006:
	ibp 1
	sojn 4,%L1006	; decrement_and_branch_until_zero
%L1007:
	dpb 3,1
	popj 17,

diff_uchar_char8:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

sum_uchar_char8:
	move 4,1
	ildb 3,4
	ldb 6,1
	add 3,6
	ibp 4
	ildb 4,4
	add 3,4
	addi 1,1
	ldb 1,1
	add 3,1
	move 1,3
	popj 17,

ret_uchar_char9:
	popj 17,

add0_uchar_char9:
	popj 17,

add1_uchar_char9:
	ibp 1
	popj 17,

addi_uchar_char9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1025
%L1024:
	ibp 1
	sojn 4,%L1024	; decrement_and_branch_until_zero
%L1025:
	popj 17,

save_uchar_char9:
	movem 1,v_uc
	popj 17,

reload_uchar_char9:
	push 17,10
	move 10,v_9
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_uchar_char9:
	ldb 1,1
	popj 17,

load1_uchar_char9:
	ildb 1,1
	popj 17,

load5_uchar_char9:
	addi 1,1
	ildb 1,1
	popj 17,

loadi_uchar_char9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1040
%L1039:
	ibp 1
	sojn 4,%L1039	; decrement_and_branch_until_zero
%L1040:
	ldb 1,1
	popj 17,

store0_uchar_char9:
	dpb 2,1
	popj 17,

store1_uchar_char9:
	addi 2,1
	idpb 2,1
	popj 17,

storei_uchar_char9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1049
%L1048:
	ibp 1
	sojn 4,%L1048	; decrement_and_branch_until_zero
%L1049:
	dpb 3,1
	popj 17,

diff_uchar_char9:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

sum_uchar_char9:
	move 4,1
	ildb 3,4
	ldb 6,1
	add 3,6
	ibp 4
	ildb 4,4
	add 3,4
	addi 1,1
	ldb 1,1
	add 3,1
	move 1,3
	popj 17,

ret_char6_uchar:
	popj 17,

add0_char6_uchar:
	popj 17,

add1_char6_uchar:
	ibp 1
	popj 17,

addi_char6_uchar:
	jumple 2,%L1067
%L1066:
	ibp 1
	sojg 2,%L1066	; decrement_and_branch_until_zero
%L1067:
	jumpe 2,%L1069
%L1068:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L1068
%L1069:
	popj 17,

save_char6_uchar:
	movem 1,v_6
	popj 17,

reload_char6_uchar:
	push 17,10
	move 10,v_uc
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_char6_uchar:
	ldb 1,1
	popj 17,

load1_char6_uchar:
	ildb 1,1
	popj 17,

load5_char6_uchar:
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ildb 1,1
	popj 17,

loadi_char6_uchar:
	jumple 2,%L1084
%L1083:
	ibp 1
	sojg 2,%L1083	; decrement_and_branch_until_zero
%L1084:
	jumpe 2,%L1086
%L1085:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L1085
%L1086:
	ldb 1,1
	popj 17,

store0_char6_uchar:
	dpb 2,1
	popj 17,

store1_char6_uchar:
	addi 2,1
	idpb 2,1
	popj 17,

storei_char6_uchar:
	jumple 2,%L1095
%L1094:
	ibp 1
	sojg 2,%L1094	; decrement_and_branch_until_zero
%L1095:
	jumpe 2,%L1097
%L1096:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L1096
%L1097:
	dpb 3,1
	popj 17,

diff_char6_uchar:
	move 4,1
	sub 4,2
	muli 4,14
	move 1,5
	ash 1,-1
	add 1,%BADL6(4)
	popj 17,

sum_char6_uchar:
	ldb 3,1
	ildb 4,1
	add 3,4
	move 4,1
	ibp 4
	ildb 4,4
	add 3,4
	ibp 1
	ibp 1
	ildb 4,1
	add 3,4
	move 1,3
	popj 17,

ret_char7_uchar:
	popj 17,

add0_char7_uchar:
	popj 17,

add1_char7_uchar:
	ibp 1
	popj 17,

addi_char7_uchar:
	jumple 2,%L1115
%L1114:
	ibp 1
	sojg 2,%L1114	; decrement_and_branch_until_zero
%L1115:
	jumpe 2,%L1117
%L1116:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L1116
%L1117:
	popj 17,

save_char7_uchar:
	movem 1,v_7
	popj 17,

reload_char7_uchar:
	push 17,10
	move 10,v_uc
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_char7_uchar:
	ldb 1,1
	popj 17,

load1_char7_uchar:
	ildb 1,1
	popj 17,

load5_char7_uchar:
	addi 1,1
	ldb 1,1
	popj 17,

loadi_char7_uchar:
	jumple 2,%L1132
%L1131:
	ibp 1
	sojg 2,%L1131	; decrement_and_branch_until_zero
%L1132:
	jumpe 2,%L1134
%L1133:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L1133
%L1134:
	ldb 1,1
	popj 17,

store0_char7_uchar:
	dpb 2,1
	popj 17,

store1_char7_uchar:
	addi 2,1
	idpb 2,1
	popj 17,

storei_char7_uchar:
	jumple 2,%L1143
%L1142:
	ibp 1
	sojg 2,%L1142	; decrement_and_branch_until_zero
%L1143:
	jumpe 2,%L1145
%L1144:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L1144
%L1145:
	dpb 3,1
	popj 17,

diff_char7_uchar:
	move 4,1
	sub 4,2
	muli 4,12
	move 1,5
	ash 1,-1
	add 1,%BADL7(4)
	popj 17,

sum_char7_uchar:
	ldb 3,1
	ildb 4,1
	add 3,4
	move 4,1
	ibp 4
	ildb 4,4
	add 3,4
	ibp 1
	ibp 1
	ildb 4,1
	add 3,4
	move 1,3
	popj 17,

ret_char8_uchar:
	popj 17,

add0_char8_uchar:
	popj 17,

add1_char8_uchar:
	ibp 1
	popj 17,

addi_char8_uchar:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1163
%L1162:
	ibp 1
	sojn 4,%L1162	; decrement_and_branch_until_zero
%L1163:
	popj 17,

save_char8_uchar:
	movem 1,v_8
	popj 17,

reload_char8_uchar:
	push 17,10
	move 10,v_uc
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_char8_uchar:
	ldb 1,1
	popj 17,

load1_char8_uchar:
	ildb 1,1
	popj 17,

load5_char8_uchar:
	addi 1,1
	ildb 1,1
	popj 17,

loadi_char8_uchar:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1178
%L1177:
	ibp 1
	sojn 4,%L1177	; decrement_and_branch_until_zero
%L1178:
	ldb 1,1
	popj 17,

store0_char8_uchar:
	dpb 2,1
	popj 17,

store1_char8_uchar:
	addi 2,1
	idpb 2,1
	popj 17,

storei_char8_uchar:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1187
%L1186:
	ibp 1
	sojn 4,%L1186	; decrement_and_branch_until_zero
%L1187:
	dpb 3,1
	popj 17,

diff_char8_uchar:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL8(4)
	popj 17,

sum_char8_uchar:
	move 2,1
	ldb 1,1
	move 4,2
	ildb 3,4
	add 1,3
	ibp 4
	ildb 4,4
	add 1,4
	addi 2,1
	ldb 4,2
	add 1,4
	popj 17,

ret_char9_uchar:
	popj 17,

add0_char9_uchar:
	popj 17,

add1_char9_uchar:
	ibp 1
	popj 17,

addi_char9_uchar:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1205
%L1204:
	ibp 1
	sojn 4,%L1204	; decrement_and_branch_until_zero
%L1205:
	popj 17,

save_char9_uchar:
	movem 1,v_9
	popj 17,

reload_char9_uchar:
	push 17,10
	move 10,v_uc
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_char9_uchar:
	ldb 1,1
	popj 17,

load1_char9_uchar:
	ildb 1,1
	popj 17,

load5_char9_uchar:
	addi 1,1
	ildb 1,1
	popj 17,

loadi_char9_uchar:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1220
%L1219:
	ibp 1
	sojn 4,%L1219	; decrement_and_branch_until_zero
%L1220:
	ldb 1,1
	popj 17,

store0_char9_uchar:
	dpb 2,1
	popj 17,

store1_char9_uchar:
	addi 2,1
	idpb 2,1
	popj 17,

storei_char9_uchar:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1229
%L1228:
	ibp 1
	sojn 4,%L1228	; decrement_and_branch_until_zero
%L1229:
	dpb 3,1
	popj 17,

diff_char9_uchar:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

sum_char9_uchar:
	move 4,1
	ildb 3,4
	ldb 6,1
	add 3,6
	ibp 4
	ildb 4,4
	add 3,4
	addi 1,1
	ldb 1,1
	add 3,1
	move 1,3
	popj 17,

ret_schar6_schar7:
	popj 17,

add0_schar6_schar7:
	popj 17,

add1_schar6_schar7:
	ibp 1
	popj 17,

addi_schar6_schar7:
	jumple 2,%L1247
%L1246:
	ibp 1
	sojg 2,%L1246	; decrement_and_branch_until_zero
%L1247:
	jumpe 2,%L1249
%L1248:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L1248
%L1249:
	popj 17,

save_schar6_schar7:
	movem 1,v_s6
	popj 17,

reload_schar6_schar7:
	push 17,10
	move 10,v_s7
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_schar6_schar7:
	ldb 1,1
	trne 1,40
	orcmi 1,77
	popj 17,

load1_schar6_schar7:
	ildb 1,1
	trne 1,40
	orcmi 1,77
	popj 17,

load5_schar6_schar7:
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ildb 1,1
	trne 1,40
	orcmi 1,77
	popj 17,

loadi_schar6_schar7:
	jumple 2,%L1264
%L1263:
	ibp 1
	sojg 2,%L1263	; decrement_and_branch_until_zero
%L1264:
	jumpe 2,%L1266
%L1265:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L1265
%L1266:
	ldb 1,1
	trne 1,40
	orcmi 1,77
	popj 17,

store0_schar6_schar7:
	dpb 2,1
	popj 17,

store1_schar6_schar7:
	addi 2,1
	idpb 2,1
	popj 17,

storei_schar6_schar7:
	jumple 2,%L1275
%L1274:
	ibp 1
	sojg 2,%L1274	; decrement_and_branch_until_zero
%L1275:
	jumpe 2,%L1277
%L1276:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L1276
%L1277:
	dpb 3,1
	popj 17,

diff_schar6_schar7:
	move 4,1
	sub 4,2
	muli 4,14
	move 1,5
	ash 1,-1
	add 1,%BADL6(4)
	popj 17,

sum_schar6_schar7:
	ldb 3,1
	trne 3,40
	orcmi 3,77
	ildb 4,1
	trne 4,40
	orcmi 4,77
	add 3,4
	move 4,1
	ibp 4
	ildb 4,4
	trne 4,40
	orcmi 4,77
	add 3,4
	ibp 1
	ibp 1
	ildb 4,1
	trne 4,40
	orcmi 4,77
	add 3,4
	move 1,3
	popj 17,

ret_schar7_schar6:
	popj 17,

add0_schar7_schar6:
	popj 17,

add1_schar7_schar6:
	ibp 1
	popj 17,

addi_schar7_schar6:
	jumple 2,%L1295
%L1294:
	ibp 1
	sojg 2,%L1294	; decrement_and_branch_until_zero
%L1295:
	jumpe 2,%L1297
%L1296:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L1296
%L1297:
	popj 17,

save_schar7_schar6:
	movem 1,v_s7
	popj 17,

reload_schar7_schar6:
	push 17,10
	move 10,v_s6
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_schar7_schar6:
	ldb 1,1
	trne 1,100
	orcmi 1,177
	popj 17,

load1_schar7_schar6:
	ildb 1,1
	trne 1,100
	orcmi 1,177
	popj 17,

load5_schar7_schar6:
	addi 1,1
	ldb 1,1
	trne 1,100
	orcmi 1,177
	popj 17,

loadi_schar7_schar6:
	jumple 2,%L1312
%L1311:
	ibp 1
	sojg 2,%L1311	; decrement_and_branch_until_zero
%L1312:
	jumpe 2,%L1314
%L1313:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L1313
%L1314:
	ldb 1,1
	trne 1,100
	orcmi 1,177
	popj 17,

store0_schar7_schar6:
	dpb 2,1
	popj 17,

store1_schar7_schar6:
	addi 2,1
	idpb 2,1
	popj 17,

storei_schar7_schar6:
	jumple 2,%L1323
%L1322:
	ibp 1
	sojg 2,%L1322	; decrement_and_branch_until_zero
%L1323:
	jumpe 2,%L1325
%L1324:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L1324
%L1325:
	dpb 3,1
	popj 17,

diff_schar7_schar6:
	move 4,1
	sub 4,2
	muli 4,12
	move 1,5
	ash 1,-1
	add 1,%BADL7(4)
	popj 17,

sum_schar7_schar6:
	ldb 3,1
	trne 3,100
	orcmi 3,177
	ildb 4,1
	trne 4,100
	orcmi 4,177
	add 3,4
	move 4,1
	ibp 4
	ildb 4,4
	trne 4,100
	orcmi 4,177
	add 3,4
	ibp 1
	ibp 1
	ildb 4,1
	trne 4,100
	orcmi 4,177
	add 3,4
	move 1,3
	popj 17,

ret_schar8_schar9:
	popj 17,

add0_schar8_schar9:
	popj 17,

add1_schar8_schar9:
	ibp 1
	popj 17,

addi_schar8_schar9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1343
%L1342:
	ibp 1
	sojn 4,%L1342	; decrement_and_branch_until_zero
%L1343:
	popj 17,

save_schar8_schar9:
	movem 1,v_s8
	popj 17,

reload_schar8_schar9:
	push 17,10
	move 10,v_s9
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_schar8_schar9:
	ldb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

load1_schar8_schar9:
	ildb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

load5_schar8_schar9:
	addi 1,1
	ildb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

loadi_schar8_schar9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1358
%L1357:
	ibp 1
	sojn 4,%L1357	; decrement_and_branch_until_zero
%L1358:
	ldb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

store0_schar8_schar9:
	dpb 2,1
	popj 17,

store1_schar8_schar9:
	addi 2,1
	idpb 2,1
	popj 17,

storei_schar8_schar9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1367
%L1366:
	ibp 1
	sojn 4,%L1366	; decrement_and_branch_until_zero
%L1367:
	dpb 3,1
	popj 17,

diff_schar8_schar9:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL8(4)
	popj 17,

sum_schar8_schar9:
	move 2,1
	ldb 1,1
	trne 1,200
	orcmi 1,377
	move 4,2
	ildb 3,4
	trne 3,200
	orcmi 3,377
	add 1,3
	ibp 4
	ildb 4,4
	trne 4,200
	orcmi 4,377
	add 1,4
	addi 2,1
	ldb 4,2
	trne 4,200
	orcmi 4,377
	add 1,4
	popj 17,

ret_schar9_schar8:
	popj 17,

add0_schar9_schar8:
	popj 17,

add1_schar9_schar8:
	ibp 1
	popj 17,

addi_schar9_schar8:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1385
%L1384:
	ibp 1
	sojn 4,%L1384	; decrement_and_branch_until_zero
%L1385:
	popj 17,

save_schar9_schar8:
	movem 1,v_s9
	popj 17,

reload_schar9_schar8:
	push 17,10
	move 10,v_s8
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_schar9_schar8:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

load1_schar9_schar8:
	ildb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

load5_schar9_schar8:
	addi 1,1
	ildb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

loadi_schar9_schar8:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1400
%L1399:
	ibp 1
	sojn 4,%L1399	; decrement_and_branch_until_zero
%L1400:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

store0_schar9_schar8:
	dpb 2,1
	popj 17,

store1_schar9_schar8:
	addi 2,1
	idpb 2,1
	popj 17,

storei_schar9_schar8:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1409
%L1408:
	ibp 1
	sojn 4,%L1408	; decrement_and_branch_until_zero
%L1409:
	dpb 3,1
	popj 17,

diff_schar9_schar8:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

sum_schar9_schar8:
	move 2,1
	ldb 1,1
	trne 1,400
	orcmi 1,777
	move 4,2
	ildb 3,4
	trne 3,400
	orcmi 3,777
	add 1,3
	ibp 4
	ildb 4,4
	trne 4,400
	orcmi 4,777
	add 1,4
	addi 2,1
	ldb 4,2
	trne 4,400
	orcmi 4,777
	add 1,4
	popj 17,

ret_schar6_char:
	popj 17,

add0_schar6_char:
	popj 17,

add1_schar6_char:
	ibp 1
	popj 17,

addi_schar6_char:
	jumple 2,%L1427
%L1426:
	ibp 1
	sojg 2,%L1426	; decrement_and_branch_until_zero
%L1427:
	jumpe 2,%L1429
%L1428:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L1428
%L1429:
	popj 17,

save_schar6_char:
	movem 1,v_s6
	popj 17,

reload_schar6_char:
	push 17,10
	move 10,v_c
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_schar6_char:
	ldb 1,1
	trne 1,40
	orcmi 1,77
	popj 17,

load1_schar6_char:
	ildb 1,1
	trne 1,40
	orcmi 1,77
	popj 17,

load5_schar6_char:
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ildb 1,1
	trne 1,40
	orcmi 1,77
	popj 17,

loadi_schar6_char:
	jumple 2,%L1444
%L1443:
	ibp 1
	sojg 2,%L1443	; decrement_and_branch_until_zero
%L1444:
	jumpe 2,%L1446
%L1445:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L1445
%L1446:
	ldb 1,1
	trne 1,40
	orcmi 1,77
	popj 17,

store0_schar6_char:
	dpb 2,1
	popj 17,

store1_schar6_char:
	addi 2,1
	idpb 2,1
	popj 17,

storei_schar6_char:
	jumple 2,%L1455
%L1454:
	ibp 1
	sojg 2,%L1454	; decrement_and_branch_until_zero
%L1455:
	jumpe 2,%L1457
%L1456:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L1456
%L1457:
	dpb 3,1
	popj 17,

diff_schar6_char:
	move 4,1
	sub 4,2
	muli 4,14
	move 1,5
	ash 1,-1
	add 1,%BADL6(4)
	popj 17,

sum_schar6_char:
	ldb 3,1
	trne 3,40
	orcmi 3,77
	ildb 4,1
	trne 4,40
	orcmi 4,77
	add 3,4
	move 4,1
	ibp 4
	ildb 4,4
	trne 4,40
	orcmi 4,77
	add 3,4
	ibp 1
	ibp 1
	ildb 4,1
	trne 4,40
	orcmi 4,77
	add 3,4
	move 1,3
	popj 17,

ret_char_schar6:
	popj 17,

add0_char_schar6:
	popj 17,

add1_char_schar6:
	ibp 1
	popj 17,

addi_char_schar6:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1475
%L1474:
	ibp 1
	sojn 4,%L1474	; decrement_and_branch_until_zero
%L1475:
	popj 17,

save_char_schar6:
	movem 1,v_c
	popj 17,

reload_char_schar6:
	push 17,10
	move 10,v_s6
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_char_schar6:
	ldb 1,1
	popj 17,

load1_char_schar6:
	ildb 1,1
	popj 17,

load5_char_schar6:
	addi 1,1
	ildb 1,1
	popj 17,

loadi_char_schar6:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1490
%L1489:
	ibp 1
	sojn 4,%L1489	; decrement_and_branch_until_zero
%L1490:
	ldb 1,1
	popj 17,

store0_char_schar6:
	dpb 2,1
	popj 17,

store1_char_schar6:
	addi 2,1
	idpb 2,1
	popj 17,

storei_char_schar6:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1499
%L1498:
	ibp 1
	sojn 4,%L1498	; decrement_and_branch_until_zero
%L1499:
	dpb 3,1
	popj 17,

diff_char_schar6:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

sum_char_schar6:
	move 4,1
	ildb 3,4
	ldb 6,1
	add 3,6
	ibp 4
	ildb 4,4
	add 3,4
	addi 1,1
	ldb 1,1
	add 3,1
	move 1,3
	popj 17,

ret_schar9_char:
	popj 17,

add0_schar9_char:
	popj 17,

add1_schar9_char:
	ibp 1
	popj 17,

addi_schar9_char:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1517
%L1516:
	ibp 1
	sojn 4,%L1516	; decrement_and_branch_until_zero
%L1517:
	popj 17,

save_schar9_char:
	movem 1,v_s9
	popj 17,

reload_schar9_char:
	push 17,10
	move 10,v_c
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_schar9_char:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

load1_schar9_char:
	ildb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

load5_schar9_char:
	addi 1,1
	ildb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

loadi_schar9_char:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1532
%L1531:
	ibp 1
	sojn 4,%L1531	; decrement_and_branch_until_zero
%L1532:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

store0_schar9_char:
	dpb 2,1
	popj 17,

store1_schar9_char:
	addi 2,1
	idpb 2,1
	popj 17,

storei_schar9_char:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1541
%L1540:
	ibp 1
	sojn 4,%L1540	; decrement_and_branch_until_zero
%L1541:
	dpb 3,1
	popj 17,

diff_schar9_char:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

sum_schar9_char:
	move 2,1
	ldb 1,1
	trne 1,400
	orcmi 1,777
	move 4,2
	ildb 3,4
	trne 3,400
	orcmi 3,777
	add 1,3
	ibp 4
	ildb 4,4
	trne 4,400
	orcmi 4,777
	add 1,4
	addi 2,1
	ldb 4,2
	trne 4,400
	orcmi 4,777
	add 1,4
	popj 17,

ret_char_schar9:
	popj 17,

add0_char_schar9:
	popj 17,

add1_char_schar9:
	ibp 1
	popj 17,

addi_char_schar9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1559
%L1558:
	ibp 1
	sojn 4,%L1558	; decrement_and_branch_until_zero
%L1559:
	popj 17,

save_char_schar9:
	movem 1,v_c
	popj 17,

reload_char_schar9:
	push 17,10
	move 10,v_s9
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_char_schar9:
	ldb 1,1
	popj 17,

load1_char_schar9:
	ildb 1,1
	popj 17,

load5_char_schar9:
	addi 1,1
	ildb 1,1
	popj 17,

loadi_char_schar9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1574
%L1573:
	ibp 1
	sojn 4,%L1573	; decrement_and_branch_until_zero
%L1574:
	ldb 1,1
	popj 17,

store0_char_schar9:
	dpb 2,1
	popj 17,

store1_char_schar9:
	addi 2,1
	idpb 2,1
	popj 17,

storei_char_schar9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1583
%L1582:
	ibp 1
	sojn 4,%L1582	; decrement_and_branch_until_zero
%L1583:
	dpb 3,1
	popj 17,

diff_char_schar9:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

sum_char_schar9:
	move 4,1
	ildb 3,4
	ldb 6,1
	add 3,6
	ibp 4
	ildb 4,4
	add 3,4
	addi 1,1
	ldb 1,1
	add 3,1
	move 1,3
	popj 17,

ret_uchar6_uchar7:
	popj 17,

add0_uchar6_uchar7:
	popj 17,

add1_uchar6_uchar7:
	ibp 1
	popj 17,

addi_uchar6_uchar7:
	jumple 2,%L1601
%L1600:
	ibp 1
	sojg 2,%L1600	; decrement_and_branch_until_zero
%L1601:
	jumpe 2,%L1603
%L1602:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L1602
%L1603:
	popj 17,

save_uchar6_uchar7:
	movem 1,v_u6
	popj 17,

reload_uchar6_uchar7:
	push 17,10
	move 10,v_u7
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_uchar6_uchar7:
	ldb 1,1
	popj 17,

load1_uchar6_uchar7:
	ildb 1,1
	popj 17,

load5_uchar6_uchar7:
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ildb 1,1
	popj 17,

loadi_uchar6_uchar7:
	jumple 2,%L1618
%L1617:
	ibp 1
	sojg 2,%L1617	; decrement_and_branch_until_zero
%L1618:
	jumpe 2,%L1620
%L1619:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L1619
%L1620:
	ldb 1,1
	popj 17,

store0_uchar6_uchar7:
	dpb 2,1
	popj 17,

store1_uchar6_uchar7:
	addi 2,1
	idpb 2,1
	popj 17,

storei_uchar6_uchar7:
	jumple 2,%L1629
%L1628:
	ibp 1
	sojg 2,%L1628	; decrement_and_branch_until_zero
%L1629:
	jumpe 2,%L1631
%L1630:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L1630
%L1631:
	dpb 3,1
	popj 17,

diff_uchar6_uchar7:
	move 4,1
	sub 4,2
	muli 4,14
	move 1,5
	ash 1,-1
	add 1,%BADL6(4)
	popj 17,

sum_uchar6_uchar7:
	ldb 3,1
	ildb 4,1
	add 3,4
	move 4,1
	ibp 4
	ildb 4,4
	add 3,4
	ibp 1
	ibp 1
	ildb 4,1
	add 3,4
	move 1,3
	popj 17,

ret_uchar7_uchar6:
	popj 17,

add0_uchar7_uchar6:
	popj 17,

add1_uchar7_uchar6:
	ibp 1
	popj 17,

addi_uchar7_uchar6:
	jumple 2,%L1649
%L1648:
	ibp 1
	sojg 2,%L1648	; decrement_and_branch_until_zero
%L1649:
	jumpe 2,%L1651
%L1650:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L1650
%L1651:
	popj 17,

save_uchar7_uchar6:
	movem 1,v_u7
	popj 17,

reload_uchar7_uchar6:
	push 17,10
	move 10,v_u6
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_uchar7_uchar6:
	ldb 1,1
	popj 17,

load1_uchar7_uchar6:
	ildb 1,1
	popj 17,

load5_uchar7_uchar6:
	addi 1,1
	ldb 1,1
	popj 17,

loadi_uchar7_uchar6:
	jumple 2,%L1666
%L1665:
	ibp 1
	sojg 2,%L1665	; decrement_and_branch_until_zero
%L1666:
	jumpe 2,%L1668
%L1667:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L1667
%L1668:
	ldb 1,1
	popj 17,

store0_uchar7_uchar6:
	dpb 2,1
	popj 17,

store1_uchar7_uchar6:
	addi 2,1
	idpb 2,1
	popj 17,

storei_uchar7_uchar6:
	jumple 2,%L1677
%L1676:
	ibp 1
	sojg 2,%L1676	; decrement_and_branch_until_zero
%L1677:
	jumpe 2,%L1679
%L1678:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L1678
%L1679:
	dpb 3,1
	popj 17,

diff_uchar7_uchar6:
	move 4,1
	sub 4,2
	muli 4,12
	move 1,5
	ash 1,-1
	add 1,%BADL7(4)
	popj 17,

sum_uchar7_uchar6:
	ldb 3,1
	ildb 4,1
	add 3,4
	move 4,1
	ibp 4
	ildb 4,4
	add 3,4
	ibp 1
	ibp 1
	ildb 4,1
	add 3,4
	move 1,3
	popj 17,

ret_uchar8_uchar9:
	popj 17,

add0_uchar8_uchar9:
	popj 17,

add1_uchar8_uchar9:
	ibp 1
	popj 17,

addi_uchar8_uchar9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1697
%L1696:
	ibp 1
	sojn 4,%L1696	; decrement_and_branch_until_zero
%L1697:
	popj 17,

save_uchar8_uchar9:
	movem 1,v_u8
	popj 17,

reload_uchar8_uchar9:
	push 17,10
	move 10,v_u9
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_uchar8_uchar9:
	ldb 1,1
	popj 17,

load1_uchar8_uchar9:
	ildb 1,1
	popj 17,

load5_uchar8_uchar9:
	addi 1,1
	ildb 1,1
	popj 17,

loadi_uchar8_uchar9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1712
%L1711:
	ibp 1
	sojn 4,%L1711	; decrement_and_branch_until_zero
%L1712:
	ldb 1,1
	popj 17,

store0_uchar8_uchar9:
	dpb 2,1
	popj 17,

store1_uchar8_uchar9:
	addi 2,1
	idpb 2,1
	popj 17,

storei_uchar8_uchar9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1721
%L1720:
	ibp 1
	sojn 4,%L1720	; decrement_and_branch_until_zero
%L1721:
	dpb 3,1
	popj 17,

diff_uchar8_uchar9:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL8(4)
	popj 17,

sum_uchar8_uchar9:
	move 2,1
	ldb 1,1
	move 4,2
	ildb 3,4
	add 1,3
	ibp 4
	ildb 4,4
	add 1,4
	addi 2,1
	ldb 4,2
	add 1,4
	popj 17,

ret_uchar9_uchar8:
	popj 17,

add0_uchar9_uchar8:
	popj 17,

add1_uchar9_uchar8:
	ibp 1
	popj 17,

addi_uchar9_uchar8:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1739
%L1738:
	ibp 1
	sojn 4,%L1738	; decrement_and_branch_until_zero
%L1739:
	popj 17,

save_uchar9_uchar8:
	movem 1,v_u9
	popj 17,

reload_uchar9_uchar8:
	push 17,10
	move 10,v_u8
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_uchar9_uchar8:
	ldb 1,1
	popj 17,

load1_uchar9_uchar8:
	ildb 1,1
	popj 17,

load5_uchar9_uchar8:
	addi 1,1
	ildb 1,1
	popj 17,

loadi_uchar9_uchar8:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1754
%L1753:
	ibp 1
	sojn 4,%L1753	; decrement_and_branch_until_zero
%L1754:
	ldb 1,1
	popj 17,

store0_uchar9_uchar8:
	dpb 2,1
	popj 17,

store1_uchar9_uchar8:
	addi 2,1
	idpb 2,1
	popj 17,

storei_uchar9_uchar8:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1763
%L1762:
	ibp 1
	sojn 4,%L1762	; decrement_and_branch_until_zero
%L1763:
	dpb 3,1
	popj 17,

diff_uchar9_uchar8:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

sum_uchar9_uchar8:
	move 4,1
	ildb 3,4
	ldb 6,1
	add 3,6
	ibp 4
	ildb 4,4
	add 3,4
	addi 1,1
	ldb 1,1
	add 3,1
	move 1,3
	popj 17,

ret_uchar6_char:
	popj 17,

add0_uchar6_char:
	popj 17,

add1_uchar6_char:
	ibp 1
	popj 17,

addi_uchar6_char:
	jumple 2,%L1781
%L1780:
	ibp 1
	sojg 2,%L1780	; decrement_and_branch_until_zero
%L1781:
	jumpe 2,%L1783
%L1782:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L1782
%L1783:
	popj 17,

save_uchar6_char:
	movem 1,v_u6
	popj 17,

reload_uchar6_char:
	push 17,10
	move 10,v_c
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_uchar6_char:
	ldb 1,1
	popj 17,

load1_uchar6_char:
	ildb 1,1
	popj 17,

load5_uchar6_char:
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ildb 1,1
	popj 17,

loadi_uchar6_char:
	jumple 2,%L1798
%L1797:
	ibp 1
	sojg 2,%L1797	; decrement_and_branch_until_zero
%L1798:
	jumpe 2,%L1800
%L1799:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L1799
%L1800:
	ldb 1,1
	popj 17,

store0_uchar6_char:
	dpb 2,1
	popj 17,

store1_uchar6_char:
	addi 2,1
	idpb 2,1
	popj 17,

storei_uchar6_char:
	jumple 2,%L1809
%L1808:
	ibp 1
	sojg 2,%L1808	; decrement_and_branch_until_zero
%L1809:
	jumpe 2,%L1811
%L1810:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L1810
%L1811:
	dpb 3,1
	popj 17,

diff_uchar6_char:
	move 4,1
	sub 4,2
	muli 4,14
	move 1,5
	ash 1,-1
	add 1,%BADL6(4)
	popj 17,

sum_uchar6_char:
	ldb 3,1
	ildb 4,1
	add 3,4
	move 4,1
	ibp 4
	ildb 4,4
	add 3,4
	ibp 1
	ibp 1
	ildb 4,1
	add 3,4
	move 1,3
	popj 17,

ret_char_uchar6:
	popj 17,

add0_char_uchar6:
	popj 17,

add1_char_uchar6:
	ibp 1
	popj 17,

addi_char_uchar6:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1829
%L1828:
	ibp 1
	sojn 4,%L1828	; decrement_and_branch_until_zero
%L1829:
	popj 17,

save_char_uchar6:
	movem 1,v_c
	popj 17,

reload_char_uchar6:
	push 17,10
	move 10,v_u6
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_char_uchar6:
	ldb 1,1
	popj 17,

load1_char_uchar6:
	ildb 1,1
	popj 17,

load5_char_uchar6:
	addi 1,1
	ildb 1,1
	popj 17,

loadi_char_uchar6:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1844
%L1843:
	ibp 1
	sojn 4,%L1843	; decrement_and_branch_until_zero
%L1844:
	ldb 1,1
	popj 17,

store0_char_uchar6:
	dpb 2,1
	popj 17,

store1_char_uchar6:
	addi 2,1
	idpb 2,1
	popj 17,

storei_char_uchar6:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1853
%L1852:
	ibp 1
	sojn 4,%L1852	; decrement_and_branch_until_zero
%L1853:
	dpb 3,1
	popj 17,

diff_char_uchar6:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

sum_char_uchar6:
	move 4,1
	ildb 3,4
	ldb 6,1
	add 3,6
	ibp 4
	ildb 4,4
	add 3,4
	addi 1,1
	ldb 1,1
	add 3,1
	move 1,3
	popj 17,

ret_uchar9_char:
	popj 17,

add0_uchar9_char:
	popj 17,

add1_uchar9_char:
	ibp 1
	popj 17,

addi_uchar9_char:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1871
%L1870:
	ibp 1
	sojn 4,%L1870	; decrement_and_branch_until_zero
%L1871:
	popj 17,

save_uchar9_char:
	movem 1,v_u9
	popj 17,

reload_uchar9_char:
	push 17,10
	move 10,v_c
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_uchar9_char:
	ldb 1,1
	popj 17,

load1_uchar9_char:
	ildb 1,1
	popj 17,

load5_uchar9_char:
	addi 1,1
	ildb 1,1
	popj 17,

loadi_uchar9_char:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1886
%L1885:
	ibp 1
	sojn 4,%L1885	; decrement_and_branch_until_zero
%L1886:
	ldb 1,1
	popj 17,

store0_uchar9_char:
	dpb 2,1
	popj 17,

store1_uchar9_char:
	addi 2,1
	idpb 2,1
	popj 17,

storei_uchar9_char:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1895
%L1894:
	ibp 1
	sojn 4,%L1894	; decrement_and_branch_until_zero
%L1895:
	dpb 3,1
	popj 17,

diff_uchar9_char:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

sum_uchar9_char:
	move 4,1
	ildb 3,4
	ldb 6,1
	add 3,6
	ibp 4
	ildb 4,4
	add 3,4
	addi 1,1
	ldb 1,1
	add 3,1
	move 1,3
	popj 17,

ret_char_uchar9:
	popj 17,

add0_char_uchar9:
	popj 17,

add1_char_uchar9:
	ibp 1
	popj 17,

addi_char_uchar9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1913
%L1912:
	ibp 1
	sojn 4,%L1912	; decrement_and_branch_until_zero
%L1913:
	popj 17,

save_char_uchar9:
	movem 1,v_c
	popj 17,

reload_char_uchar9:
	push 17,10
	move 10,v_u9
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

load0_char_uchar9:
	ldb 1,1
	popj 17,

load1_char_uchar9:
	ildb 1,1
	popj 17,

load5_char_uchar9:
	addi 1,1
	ildb 1,1
	popj 17,

loadi_char_uchar9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1928
%L1927:
	ibp 1
	sojn 4,%L1927	; decrement_and_branch_until_zero
%L1928:
	ldb 1,1
	popj 17,

store0_char_uchar9:
	dpb 2,1
	popj 17,

store1_char_uchar9:
	addi 2,1
	idpb 2,1
	popj 17,

storei_char_uchar9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1937
%L1936:
	ibp 1
	sojn 4,%L1936	; decrement_and_branch_until_zero
%L1937:
	dpb 3,1
	popj 17,

diff_char_uchar9:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

sum_char_uchar9:
	move 4,1
	ildb 3,4
	ldb 6,1
	add 3,6
	ibp 4
	ildb 4,4
	add 3,4
	addi 1,1
	ldb 1,1
	add 3,1
	move 1,3
	popj 17,

to_void_char6:
	popj 17,

from_void_char6:
	popj 17,

save_void_char6:
	movem 1,v_void
	popj 17,

reload_void_char6:
	push 17,10
	move 10,v_void
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

reload_typed_char6:
	push 17,10
	move 10,v_6
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

to_void_char7:
	popj 17,

from_void_char7:
	popj 17,

save_void_char7:
	movem 1,v_void
	popj 17,

reload_void_char7:
	push 17,10
	move 10,v_void
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

reload_typed_char7:
	push 17,10
	move 10,v_7
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

to_void_char8:
	popj 17,

from_void_char8:
	popj 17,

save_void_char8:
	movem 1,v_void
	popj 17,

reload_void_char8:
	push 17,10
	move 10,v_void
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

reload_typed_char8:
	push 17,10
	move 10,v_8
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

to_void_char9:
	popj 17,

from_void_char9:
	popj 17,

save_void_char9:
	movem 1,v_void
	popj 17,

reload_void_char9:
	push 17,10
	move 10,v_void
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

reload_typed_char9:
	push 17,10
	move 10,v_9
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

to_void_char_plain:
	popj 17,

from_void_char_plain:
	popj 17,

save_void_char_plain:
	movem 1,v_void
	popj 17,

reload_void_char_plain:
	push 17,10
	move 10,v_void
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

reload_typed_char_plain:
	push 17,10
	move 10,v_c
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

to_void_uchar_plain:
	popj 17,

from_void_uchar_plain:
	popj 17,

save_void_uchar_plain:
	movem 1,v_void
	popj 17,

reload_void_uchar_plain:
	push 17,10
	move 10,v_void
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

reload_typed_uchar_plain:
	push 17,10
	move 10,v_uc
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

to_void_schar6:
	popj 17,

from_void_schar6:
	popj 17,

save_void_schar6:
	movem 1,v_void
	popj 17,

reload_void_schar6:
	push 17,10
	move 10,v_void
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

reload_typed_schar6:
	push 17,10
	move 10,v_s6
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

to_void_schar9:
	popj 17,

from_void_schar9:
	popj 17,

save_void_schar9:
	movem 1,v_void
	popj 17,

reload_void_schar9:
	push 17,10
	move 10,v_void
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

reload_typed_schar9:
	push 17,10
	move 10,v_s9
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

to_word_char6:
	hrrz 1,1
	popj 17,

from_word_char6:
	jumpe 1,%L2036
	move 4,1
	tlo 4,360600
%L2036:
	move 1,4
	popj 17,

load_word_as_char6:
	jumpe 1,%L2038
	move 4,1
	tlo 4,360600
%L2038:
	ildb 1,4
	popj 17,

store_word_as_char6:
	jumpe 1,%L2040
	move 4,1
	tlo 4,360600
%L2040:
	ibp 4
	idpb 2,4
	popj 17,

word_reload_char6:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,v_w
	pushj 17,clobber
	jumpe 10,%L2042
	move 11,10
	tlo 11,360600
%L2042:
	move 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

byte_reload_word_char6:
	push 17,10
	move 10,v_6
	pushj 17,clobber
	hrrz 10,10
	move 1,10
	pop 17,10
	popj 17,

to_word_char7:
	hrrz 1,1
	popj 17,

from_word_char7:
	jumpe 1,%L2048
	move 4,1
	tlo 4,350700
%L2048:
	move 1,4
	popj 17,

load_word_as_char7:
	jumpe 1,%L2050
	move 4,1
	tlo 4,350700
%L2050:
	ildb 1,4
	popj 17,

store_word_as_char7:
	jumpe 1,%L2052
	move 4,1
	tlo 4,350700
%L2052:
	ibp 4
	idpb 2,4
	popj 17,

word_reload_char7:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,v_w
	pushj 17,clobber
	jumpe 10,%L2054
	move 11,10
	tlo 11,350700
%L2054:
	move 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

byte_reload_word_char7:
	push 17,10
	move 10,v_7
	pushj 17,clobber
	hrrz 10,10
	move 1,10
	pop 17,10
	popj 17,

to_word_char8:
	hrrz 1,1
	popj 17,

from_word_char8:
	jumpe 1,%L2060
	move 4,1
	tlo 4,341000
%L2060:
	move 1,4
	popj 17,

load_word_as_char8:
	jumpe 1,%L2062
	move 4,1
	tlo 4,341000
%L2062:
	ildb 1,4
	popj 17,

store_word_as_char8:
	jumpe 1,%L2064
	move 4,1
	tlo 4,341000
%L2064:
	ibp 4
	idpb 2,4
	popj 17,

word_reload_char8:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,v_w
	pushj 17,clobber
	jumpe 10,%L2066
	move 11,10
	tlo 11,341000
%L2066:
	move 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

byte_reload_word_char8:
	push 17,10
	move 10,v_8
	pushj 17,clobber
	hrrz 10,10
	move 1,10
	pop 17,10
	popj 17,

to_word_char9:
	hrrz 1,1
	popj 17,

from_word_char9:
	jumpe 1,%L2072
	move 4,1
	tlo 4,331100
%L2072:
	move 1,4
	popj 17,

load_word_as_char9:
	jumpe 1,%L2074
	move 4,1
	tlo 4,331100
%L2074:
	ildb 1,4
	popj 17,

store_word_as_char9:
	jumpe 1,%L2076
	move 4,1
	tlo 4,331100
%L2076:
	ibp 4
	idpb 2,4
	popj 17,

word_reload_char9:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,v_w
	pushj 17,clobber
	jumpe 10,%L2078
	move 11,10
	tlo 11,331100
%L2078:
	move 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

byte_reload_word_char9:
	push 17,10
	move 10,v_9
	pushj 17,clobber
	hrrz 10,10
	move 1,10
	pop 17,10
	popj 17,

to_word_char_plain:
	hrrz 1,1
	popj 17,

from_word_char_plain:
	jumpe 1,%L2084
	move 4,1
	tlo 4,331100
%L2084:
	move 1,4
	popj 17,

load_word_as_char_plain:
	jumpe 1,%L2086
	move 4,1
	tlo 4,331100
%L2086:
	ildb 1,4
	popj 17,

store_word_as_char_plain:
	jumpe 1,%L2088
	move 4,1
	tlo 4,331100
%L2088:
	ibp 4
	idpb 2,4
	popj 17,

word_reload_char_plain:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,v_w
	pushj 17,clobber
	jumpe 10,%L2090
	move 11,10
	tlo 11,331100
%L2090:
	move 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

byte_reload_word_char_plain:
	push 17,10
	move 10,v_c
	pushj 17,clobber
	hrrz 10,10
	move 1,10
	pop 17,10
	popj 17,

to_word_uchar_plain:
	hrrz 1,1
	popj 17,

from_word_uchar_plain:
	jumpe 1,%L2096
	move 4,1
	tlo 4,331100
%L2096:
	move 1,4
	popj 17,

load_word_as_uchar_plain:
	jumpe 1,%L2098
	move 4,1
	tlo 4,331100
%L2098:
	ildb 1,4
	popj 17,

store_word_as_uchar_plain:
	jumpe 1,%L2100
	move 4,1
	tlo 4,331100
%L2100:
	ibp 4
	idpb 2,4
	popj 17,

word_reload_uchar_plain:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,v_w
	pushj 17,clobber
	jumpe 10,%L2102
	move 11,10
	tlo 11,331100
%L2102:
	move 1,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

byte_reload_word_uchar_plain:
	push 17,10
	move 10,v_uc
	pushj 17,clobber
	hrrz 10,10
	move 1,10
	pop 17,10
	popj 17,

use_charp_conversions:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	move 6,[POINT 6,g6,5]
	movem 6,v_6
	move 6,[POINT 7,g7,6]
	movem 6,v_7
	move 6,[POINT 8,g8,7]
	movem 6,v_8
	move 6,[POINT 9,g9,8]
	movem 6,v_9
	move 6,[POINT 6,ug6,5]
	movem 6,v_u6
	move 6,[POINT 7,ug7,6]
	movem 6,v_u7
	move 6,[POINT 8,ug8,7]
	movem 6,v_u8
	move 6,[POINT 9,ug9,8]
	movem 6,v_u9
	move 6,[POINT 6,sg6,5]
	movem 6,v_s6
	move 6,[POINT 7,sg7,6]
	movem 6,v_s7
	move 6,[POINT 8,sg8,7]
	movem 6,v_s8
	move 6,[POINT 9,sg9,8]
	movem 6,v_s9
	move 6,[POINT 9,gc,8]
	movem 6,v_c
	move 6,[POINT 9,guc,8]
	movem 6,v_uc
	movei 6,gw
	movem 6,v_w
	move 6,[POINT 9,gc,8]
	movem 6,v_void
	move 1,[POINT 7,g7,6]
	move 2,11
	move 3,10
	pushj 17,storei_char6_char7
	addi 10,1
	move 1,[POINT 6,g6,5]
	move 2,11
	move 3,10
	pushj 17,storei_char7_char6
	addi 10,1
	move 1,[POINT 9,g9,8]
	move 2,11
	move 3,10
	pushj 17,storei_char8_char9
	addi 10,1
	move 1,[POINT 8,g8,7]
	move 2,11
	move 3,10
	pushj 17,storei_char9_char8
	addi 10,1
	move 1,[POINT 9,g9,8]
	move 2,11
	move 3,10
	pushj 17,storei_char_char9
	addi 10,1
	move 1,[POINT 9,gc,8]
	move 2,11
	move 3,10
	pushj 17,storei_char9_char
	addi 10,1
	move 1,[POINT 8,g8,7]
	move 2,11
	move 3,10
	pushj 17,storei_uchar_char8
	addi 10,1
	move 1,[POINT 9,guc,8]
	move 2,11
	move 3,10
	pushj 17,storei_char8_uchar
	addi 10,1
	move 1,[POINT 7,sg7,6]
	move 2,11
	move 3,10
	pushj 17,storei_schar6_schar7
	addi 10,1
	move 1,[POINT 8,sg8,7]
	move 2,11
	move 3,10
	pushj 17,storei_schar9_schar8
	pushj 17,clobber
	move 1,[POINT 7,g7,6]
	pushj 17,load0_char6_char7
	move 10,1
	move 1,[POINT 6,g6,5]
	pushj 17,load1_char7_char6
	add 10,1
	move 1,[POINT 9,g9,8]
	pushj 17,load5_char8_char9
	add 10,1
	move 1,[POINT 8,g8,7]
	move 2,11
	pushj 17,loadi_char9_char8
	add 10,1
	move 1,[POINT 6,g6,5]
	pushj 17,sum_char_char6
	add 10,1
	move 1,[POINT 9,gc,8]
	pushj 17,sum_char6_char
	add 10,1
	move 1,[POINT 9,g9+4,17]
	move 2,[POINT 9,g9,26]
	pushj 17,diff_char6_char9
	add 10,1
	move 1,[POINT 6,g6+2,35]
	move 2,[POINT 6,g6,17]
	pushj 17,diff_char9_char6
	add 10,1
	move 1,[POINT 9,g9+4,17]
	move 2,[POINT 9,g9,26]
	pushj 17,diff_char_char9
	add 10,1
	move 1,[POINT 9,gc+4,17]
	move 2,[POINT 9,gc,26]
	pushj 17,diff_char9_char
	add 10,1
	move 1,[POINT 7,g7,6]
	pushj 17,ret_char6_char7
	move 6,[POINT 6,g6,5]
	came 1,6
	tdza 1,1
	movei 1,1
	add 10,1
	move 1,6
	pushj 17,add1_char7_char6
	move 6,[POINT 7,g7,6]
	camn 1,6
	tdza 1,1
	movei 1,1
	add 10,1
	move 1,[POINT 9,g9,8]
	move 2,11
	pushj 17,addi_char8_char9
	move 6,[POINT 8,g8,7]
	camn 1,6
	tdza 1,1
	movei 1,1
	add 10,1
	pushj 17,reload_char9_char8
	move 6,[POINT 9,g9,8]
	camn 1,6
	tdza 1,1
	movei 1,1
	add 10,1
	move 1,[POINT 7,g7,6]
	pushj 17,to_void_char7
	pushj 17,from_void_char6
	move 6,[POINT 6,g6,5]
	camn 1,6
	tdza 1,1
	movei 1,1
	add 10,1
	move 1,[POINT 9,gc,8]
	pushj 17,to_void_char_plain
	pushj 17,from_void_char9
	move 6,[POINT 9,g9,8]
	camn 1,6
	tdza 1,1
	movei 1,1
	add 10,1
	move 1,6
	pushj 17,to_word_char9
	pushj 17,from_word_char8
	move 6,[POINT 8,g8,7]
	camn 1,6
	tdza 1,1
	movei 1,1
	add 10,1
	pushj 17,byte_reload_word_char6
	movei 6,gw
	camn 1,6
	tdza 1,1
	movei 1,1
	add 10,1
	move 1,6
	pushj 17,load_word_as_char7
	add 10,1
	movei 1,gw
	pushj 17,load_word_as_uchar_plain
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
sg6:
	.space	48
sg7:
	.space	48
sg8:
	.space	48
sg9:
	.space	48
g6:
	.space	48
g7:
	.space	48
g8:
	.space	48
g9:
	.space	48
ug6:
	.space	48
ug7:
	.space	48
ug8:
	.space	48
ug9:
	.space	48
gc:
	.space	48
guc:
	.space	48
gw:
	.space	64
v_s6:
	.space	4
v_s7:
	.space	4
v_s8:
	.space	4
v_s9:
	.space	4
v_6:
	.space	4
v_7:
	.space	4
v_8:
	.space	4
v_9:
	.space	4
v_u6:
	.space	4
v_u7:
	.space	4
v_u8:
	.space	4
v_u9:
	.space	4
v_c:
	.space	4
v_uc:
	.space	4
v_w:
	.space	4
v_void:
	.space	4
