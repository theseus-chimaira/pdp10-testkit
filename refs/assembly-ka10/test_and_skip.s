
trne:
	trne 1,123456
	movei 1,0
	popj 17,

trnn:
	trnn 1,123456
	movei 1,0
	popj 17,

tlne:
	tlne 1,123456
	movei 1,0
	popj 17,

tlnn:
	tlnn 1,123456
	movei 1,0
	popj 17,

tdne1:
	tdne 1,[123456123456]
	movei 1,0
	popj 17,

tdnn1:
	tdnn 1,[123456123456]
	movei 1,0
	popj 17,

tdne2:
	tdne 1,(2)
	movei 1,0
	popj 17,

tdnn2:
	tdnn 1,(2)
	movei 1,0
	popj 17,

trne_select:
	trnn 1,123456
	move 2,3
	move 1,2
	popj 17,

trnn_select:
	trne 1,123456
	move 2,3
	move 1,2
	popj 17,

trne_call:
	trnn 1,123456
	popj 17,
	jrst f

trnn_call:
	trne 1,123456
	popj 17,
	jrst f

trne_one:
	movei 4,1
	trnn 1,1
	move 4,1
	move 1,4
	popj 17,

trnn_one:
	movei 4,1
	trne 1,1
	move 4,1
	move 1,4
	popj 17,

trne_highbit:
	movei 4,1
	trnn 1,400000
	move 4,1
	move 1,4
	popj 17,

trnn_highbit:
	movei 4,1
	trne 1,400000
	move 4,1
	move 1,4
	popj 17,

trne_all_right:
	hrrz 4,1
	movei 3,1
	jumpn 4,%L35
	move 3,1
%L35:
	move 1,3
	popj 17,

trnn_all_right:
	hrrz 4,1
	movei 3,1
	jumpe 4,%L37
	move 3,1
%L37:
	move 1,3
	popj 17,

trne_likely:
	movei 4,1
	trnn 1,123456
	jrst %L41
%L39:
	move 1,4
	popj 17,
%L41:
	move 4,1
	jrst %L39

trnn_unlikely:
	movei 4,1
	trne 1,123456
	move 4,1
	move 1,4
	popj 17,

tlne_select:
	tlnn 1,123456
	move 2,3
	move 1,2
	popj 17,

tlnn_select:
	tlne 1,123456
	move 2,3
	move 1,2
	popj 17,

tlne_call:
	tlnn 1,123456
	popj 17,
	jrst f

tlnn_call:
	tlne 1,123456
	popj 17,
	jrst f

tlne_one:
	movei 4,1
	tlnn 1,1
	move 4,1
	move 1,4
	popj 17,

tlnn_one:
	movei 4,1
	tlne 1,1
	move 4,1
	move 1,4
	popj 17,

tlne_signbit:
	movei 4,1
	jumpl 1,%L58
	move 4,1
%L58:
	move 1,4
	popj 17,

tlnn_signbit:
	movei 4,1
	jumpge 1,%L60
	move 4,1
%L60:
	move 1,4
	popj 17,

tlne_all_left:
	movei 4,1
	tlnn 1,777777
	move 4,1
	move 1,4
	popj 17,

tlnn_all_left:
	movei 4,1
	tlne 1,777777
	move 4,1
	move 1,4
	popj 17,

tlne_likely:
	movei 4,1
	tlnn 1,123456
	jrst %L68
%L66:
	move 1,4
	popj 17,
%L68:
	move 4,1
	jrst %L66

tlnn_unlikely:
	movei 4,1
	tlne 1,123456
	move 4,1
	move 1,4
	popj 17,

tdne_literal:
	movei 4,1
	tdnn 1,[123456123456]
	move 4,1
	move 1,4
	popj 17,

tdnn_literal:
	movei 4,1
	tdne 1,[123456123456]
	move 4,1
	move 1,4
	popj 17,

tdne_literal_left:
	movei 4,1
	tlnn 1,123456
	move 4,1
	move 1,4
	popj 17,

tdnn_literal_left:
	movei 4,1
	tlne 1,123456
	move 4,1
	move 1,4
	popj 17,

tdne_literal_right:
	movei 4,1
	trnn 1,123456
	move 4,1
	move 1,4
	popj 17,

tdnn_literal_right:
	movei 4,1
	trne 1,123456
	move 4,1
	move 1,4
	popj 17,

tdne_reg:
	tdnn 1,2
	move 3,4
	move 1,3
	popj 17,

tdnn_reg:
	tdne 1,2
	move 3,4
	move 1,3
	popj 17,

tdne_mem:
	movei 4,1
	tdnn 1,(2)
	move 4,1
	move 1,4
	popj 17,

tdnn_mem:
	movei 4,1
	tdne 1,(2)
	move 4,1
	move 1,4
	popj 17,

tdne_mem_loaded:
	movei 4,1
	tdnn 1,(2)
	move 4,1
	move 1,4
	popj 17,

tdnn_mem_loaded:
	movei 4,1
	tdne 1,(2)
	move 4,1
	move 1,4
	popj 17,

tdne_global:
	movei 4,1
	tdnn 1,tskip_ga
	move 4,1
	move 1,4
	popj 17,

tdnn_global:
	movei 4,1
	tdne 1,tskip_ga
	move 4,1
	move 1,4
	popj 17,

tdne_global_global:
	move 4,tskip_ga
	movei 1,1
	tdnn 4,tskip_gb
	move 1,4
	popj 17,

tdnn_global_global:
	move 4,tskip_ga
	movei 1,1
	tdne 4,tskip_gb
	move 1,4
	popj 17,

tdne_volatile:
	move 4,tskip_vga
	movei 3,1
	tdnn 1,4
	move 3,1
	move 1,3
	popj 17,

tdnn_volatile:
	move 4,tskip_vga
	movei 3,1
	tdne 1,4
	move 3,1
	move 1,3
	popj 17,

tdne_array:
	andi 3,17
	add 2,3
	movei 4,1
	tdnn 1,(2)
	move 4,1
	move 1,4
	popj 17,

tdnn_array:
	andi 3,17
	add 2,3
	movei 4,1
	tdne 1,(2)
	move 4,1
	move 1,4
	popj 17,

tdne_global_array:
	andi 2,17
	movei 4,1
	tdnn 1,tskip_buf(2)
	move 4,1
	move 1,4
	popj 17,

tdnn_global_array:
	andi 2,17
	movei 4,1
	tdne 1,tskip_buf(2)
	move 4,1
	move 1,4
	popj 17,

tdne_struct_a:
	movei 4,1
	tdnn 1,(2)
	move 4,1
	move 1,4
	popj 17,

tdnn_struct_a:
	movei 4,1
	tdne 1,(2)
	move 4,1
	move 1,4
	popj 17,

tdne_struct_ab:
	move 4,(1)
	movei 3,1
	tdnn 4,1(1)
	move 3,4
	move 1,3
	popj 17,

tdnn_struct_ab:
	move 4,(1)
	movei 3,1
	tdne 4,1(1)
	move 3,4
	move 1,3
	popj 17,

tsne_reg:
	move 6,4
	hlre 4,2
	tlo 4,(2)
	tdnn 1,4
	move 3,6
	move 1,3
	popj 17,

tsnn_reg:
	move 6,4
	hlre 4,2
	tlo 4,(2)
	tdne 1,4
	move 3,6
	move 1,3
	popj 17,

tsne_literal:
	movei 4,1
	tdnn 1,[123456123456]
	move 4,1
	move 1,4
	popj 17,

tsnn_literal:
	movei 4,1
	tdne 1,[123456123456]
	move 4,1
	move 1,4
	popj 17,

tsne_mem:
	move 3,(2)
	hlre 4,3
	tlo 4,(3)
	movei 3,1
	tdnn 1,4
	move 3,1
	move 1,3
	popj 17,

tsnn_mem:
	move 3,(2)
	hlre 4,3
	tlo 4,(3)
	movei 3,1
	tdne 1,4
	move 3,1
	move 1,3
	popj 17,

tsne_mem_loaded:
	move 3,(2)
	hlre 4,3
	tlo 4,(3)
	movei 3,1
	tdnn 1,4
	move 3,1
	move 1,3
	popj 17,

tsnn_mem_loaded:
	move 3,(2)
	hlre 4,3
	tlo 4,(3)
	movei 3,1
	tdne 1,4
	move 3,1
	move 1,3
	popj 17,

tsne_global:
	move 3,tskip_ga
	hlre 4,3
	tlo 4,(3)
	movei 3,1
	tdnn 1,4
	move 3,1
	move 1,3
	popj 17,

tsnn_global:
	move 3,tskip_ga
	hlre 4,3
	tlo 4,(3)
	movei 3,1
	tdne 1,4
	move 3,1
	move 1,3
	popj 17,

tsne_global_global:
	move 4,tskip_gb
	hlre 3,4
	tlo 3,(4)
	move 4,tskip_ga
	movei 1,1
	tdnn 4,3
	move 1,4
	popj 17,

tsnn_global_global:
	move 4,tskip_gb
	hlre 3,4
	tlo 3,(4)
	move 4,tskip_ga
	movei 1,1
	tdne 4,3
	move 1,4
	popj 17,

tsne_volatile:
	move 3,tskip_vga
	hlre 4,3
	tlo 4,(3)
	movei 3,1
	tdnn 1,4
	move 3,1
	move 1,3
	popj 17,

tsnn_volatile:
	move 3,tskip_vga
	hlre 4,3
	tlo 4,(3)
	movei 3,1
	tdne 1,4
	move 3,1
	move 1,3
	popj 17,

tsne_array:
	move 6,1
	andi 3,17
	add 2,3
	move 3,(2)
	hlre 4,3
	tlo 4,(3)
	movei 1,1
	tdnn 6,4
	move 1,6
	popj 17,

tsnn_array:
	move 6,1
	andi 3,17
	add 2,3
	move 3,(2)
	hlre 4,3
	tlo 4,(3)
	movei 1,1
	tdne 6,4
	move 1,6
	popj 17,

tsne_global_array:
	move 6,1
	andi 2,17
	move 3,tskip_buf(2)
	hlre 4,3
	tlo 4,(3)
	movei 1,1
	tdnn 6,4
	move 1,6
	popj 17,

tsnn_global_array:
	move 6,1
	andi 2,17
	move 3,tskip_buf(2)
	hlre 4,3
	tlo 4,(3)
	movei 1,1
	tdne 6,4
	move 1,6
	popj 17,

tsne_struct_a:
	move 3,(2)
	hlre 4,3
	tlo 4,(3)
	movei 3,1
	tdnn 1,4
	move 3,1
	move 1,3
	popj 17,

tsnn_struct_a:
	move 3,(2)
	hlre 4,3
	tlo 4,(3)
	movei 3,1
	tdne 1,4
	move 3,1
	move 1,3
	popj 17,

tsne_struct_ab:
	move 4,1(1)
	hlre 3,4
	tlo 3,(4)
	move 1,(1)
	movei 4,1
	tdnn 1,3
	move 4,1
	move 1,4
	popj 17,

tsnn_struct_ab:
	move 4,1(1)
	hlre 3,4
	tlo 3,(4)
	move 1,(1)
	movei 4,1
	tdne 1,3
	move 4,1
	move 1,4
	popj 17,

trne_bool:
	andi 1,123456
	skipe 1
	movei 1,1
	popj 17,

trnn_bool:
	andi 1,123456
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

tlne_bool:
	and 1,[123456000000]
	skipe 1
	movei 1,1
	popj 17,

tlnn_bool:
	and 1,[123456000000]
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

tdne_bool:
	and 1,2
	skipe 1
	movei 1,1
	popj 17,

tdnn_bool:
	and 1,2
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

tsne_bool:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	and 1,4
	skipe 1
	movei 1,1
	popj 17,

tsnn_bool:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	and 1,4
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

tdne_bool_mem:
	and 1,(2)
	skipe 1
	movei 1,1
	popj 17,

tdnn_bool_mem:
	and 1,(2)
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

tsne_bool_mem:
	move 3,1
	move 4,(2)
	hlre 1,4
	tlo 1,(4)
	and 1,3
	skipe 1
	movei 1,1
	popj 17,

tsnn_bool_mem:
	move 3,1
	move 4,(2)
	hlre 1,4
	tlo 1,(4)
	and 1,3
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

trne_value_live:
	move 3,1
	move 4,1
	andi 4,123456
	move 1,4
	add 1,2
	jumpn 4,%L185
	move 1,3
	add 1,2
%L185:
	popj 17,

trnn_value_live:
	move 4,1
	andi 4,123456
	add 1,2
	jumpe 4,%L187
	move 1,4
	add 1,2
%L187:
	popj 17,

tlne_value_live:
	move 3,1
	move 4,1
	and 4,[123456000000]
	move 1,4
	add 1,2
	jumpn 4,%L189
	move 1,3
	add 1,2
%L189:
	popj 17,

tlnn_value_live:
	move 4,1
	and 4,[123456000000]
	add 1,2
	jumpe 4,%L191
	move 1,4
	add 1,2
%L191:
	popj 17,

tdne_value_live:
	move 6,1
	move 4,1
	and 4,2
	move 1,4
	add 1,3
	jumpn 4,%L193
	move 1,6
	add 1,2
	add 1,3
%L193:
	popj 17,

tdnn_value_live:
	move 4,1
	and 1,2
	jumpn 1,%L196
	move 1,4
	add 1,2
%L196:
	add 1,3
	popj 17,

tsne_value_live:
	move 6,1
	hlre 4,2
	tlo 4,(2)
	and 4,1
	move 1,4
	add 1,3
	jumpn 4,%L197
	move 1,6
	add 1,2
	add 1,3
%L197:
	popj 17,

tsnn_value_live:
	move 4,1
	hlre 1,2
	tlo 1,(2)
	and 1,4
	jumpn 1,%L200
	move 1,4
	add 1,2
%L200:
	add 1,3
	popj 17,

tdne_nested:
	tdnn 1,2
	jrst %L202
	skipe 3
	tdza 1,1
	movei 1,1
	addi 1,1
%L201:
	popj 17,
%L202:
	movei 1,3
	popj 17,

tdnn_nested:
	tdne 1,2
	jrst %L205
	skipe 3
	tdza 1,1
	movei 1,1
	addi 1,1
%L204:
	popj 17,
%L205:
	movei 1,3
	popj 17,

tsne_nested:
	hlre 4,2
	tlo 4,(2)
	tdnn 1,4
	jrst %L208
	skipe 3
	tdza 1,1
	movei 1,1
	addi 1,1
%L207:
	popj 17,
%L208:
	movei 1,3
	popj 17,

tsnn_nested:
	hlre 4,2
	tlo 4,(2)
	tdne 1,4
	jrst %L211
	skipe 3
	tdza 1,1
	movei 1,1
	addi 1,1
%L210:
	popj 17,
%L211:
	movei 1,3
	popj 17,

tdne_else_if:
	movei 4,1
	tdne 1,2
	jrst %L213
	skipe 3
	tdza 4,4
	movei 4,1
	addi 4,2
%L213:
	move 1,4
	popj 17,

tdnn_else_if:
	movei 4,1
	tdnn 1,2
	jrst %L217
	skipe 3
	tdza 4,4
	movei 4,1
	addi 4,2
%L217:
	move 1,4
	popj 17,

tsne_else_if:
	hlre 4,2
	tlo 4,(2)
	movei 2,1
	tdne 1,4
	jrst %L221
	skipe 3
	tdza 2,2
	movei 2,1
	addi 2,2
%L221:
	move 1,2
	popj 17,

tsnn_else_if:
	hlre 4,2
	tlo 4,(2)
	movei 2,1
	tdnn 1,4
	jrst %L225
	skipe 3
	tdza 2,2
	movei 2,1
	addi 2,2
%L225:
	move 1,2
	popj 17,

trne_loop:
	move 4,2
	subi 2,1
	jumple 4,%L236
%L234:
	move 4,2
	trne 1,123456
	jrst %L229
	addi 1,1
	subi 2,1
	jumpg 4,%L234
%L236:
	move 4,1
%L229:
	move 1,4
	popj 17,

trnn_loop:
	move 4,2
	subi 2,1
	jumple 4,%L244
%L242:
	move 4,2
	trnn 1,123456
	jrst %L237
	addi 1,1
	subi 2,1
	jumpg 4,%L242
%L244:
	move 4,1
%L237:
	move 1,4
	popj 17,

tlne_loop:
	move 4,2
	subi 2,1
	jumple 4,%L252
%L250:
	move 4,2
	tlne 1,123456
	jrst %L245
	addi 1,1
	subi 2,1
	jumpg 4,%L250
%L252:
	move 4,1
%L245:
	move 1,4
	popj 17,

tlnn_loop:
	move 4,2
	subi 2,1
	jumple 4,%L260
%L258:
	move 4,2
	tlnn 1,123456
	jrst %L253
	addi 1,1
	subi 2,1
	jumpg 4,%L258
%L260:
	move 4,1
%L253:
	move 1,4
	popj 17,

tdne_loop:
	move 4,3
	subi 3,1
	jumple 4,%L268
%L266:
	move 4,3
	tdne 1,2
	jrst %L261
	addi 1,1
	subi 3,1
	jumpg 4,%L266
%L268:
	move 4,1
%L261:
	move 1,4
	popj 17,

tdnn_loop:
	move 4,3
	subi 3,1
	jumple 4,%L276
%L274:
	move 4,3
	tdnn 1,2
	jrst %L269
	addi 1,1
	subi 3,1
	jumpg 4,%L274
%L276:
	move 4,1
%L269:
	move 1,4
	popj 17,

tsne_loop:
	move 4,3
	subi 3,1
	jumple 4,%L284
	hlre 6,2
	tlo 6,(2)
%L282:
	move 4,3
	tdne 1,6
	jrst %L277
	addi 1,1
	subi 3,1
	jumpg 4,%L282
%L284:
	move 4,1
%L277:
	move 1,4
	popj 17,

tsnn_loop:
	move 4,3
	subi 3,1
	jumple 4,%L292
	hlre 6,2
	tlo 6,(2)
%L290:
	move 4,3
	tdnn 1,6
	jrst %L285
	addi 1,1
	subi 3,1
	jumpg 4,%L290
%L292:
	move 4,1
%L285:
	move 1,4
	popj 17,

tdne_loop_memory:
	move 2,(2)
	move 4,3
	subi 3,1
	jumple 4,%L300
%L298:
	move 4,3
	tdne 1,2
	jrst %L293
	addi 1,1
	subi 3,1
	jumpg 4,%L298
%L300:
	move 4,1
%L293:
	move 1,4
	popj 17,

tdnn_loop_memory:
	move 2,(2)
	move 4,3
	subi 3,1
	jumple 4,%L308
%L306:
	move 4,3
	tdnn 1,2
	jrst %L301
	addi 1,1
	subi 3,1
	jumpg 4,%L306
%L308:
	move 4,1
%L301:
	move 1,4
	popj 17,

tsne_loop_memory:
	move 2,(2)
	move 4,3
	subi 3,1
	jumple 4,%L316
	hlre 6,2
	tlo 6,(2)
%L314:
	move 4,3
	tdne 1,6
	jrst %L309
	addi 1,1
	subi 3,1
	jumpg 4,%L314
%L316:
	move 4,1
%L309:
	move 1,4
	popj 17,

tsnn_loop_memory:
	move 2,(2)
	move 4,3
	subi 3,1
	jumple 4,%L324
	hlre 6,2
	tlo 6,(2)
%L322:
	move 4,3
	tdnn 1,6
	jrst %L317
	addi 1,1
	subi 3,1
	jumpg 4,%L322
%L324:
	move 4,1
%L317:
	move 1,4
	popj 17,

tdne_call_pressure:
	push 17,10
	tdne 1,2
	jrst %L328
%L326:
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,
%L328:
	pushj 17,f
	jrst %L326

tdnn_call_pressure:
	push 17,10
	tdnn 1,2
	jrst %L332
%L330:
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,
%L332:
	pushj 17,f
	jrst %L330

tsne_call_pressure:
	push 17,10
	hlre 4,2
	tlo 4,(2)
	tdne 1,4
	jrst %L336
%L334:
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,
%L336:
	pushj 17,f
	jrst %L334

tsnn_call_pressure:
	push 17,10
	hlre 4,2
	tlo 4,(2)
	tdnn 1,4
	jrst %L340
%L338:
	move 10,1
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,
%L340:
	pushj 17,f
	jrst %L338

	.globl	test_and_skip_right_left_smoke
test_and_skip_right_left_smoke:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	pushj 17,trne
	move 10,1
	move 1,11
	pushj 17,trnn
	add 10,1
	move 1,11
	pushj 17,tlne
	add 10,1
	move 1,11
	pushj 17,tlnn
	add 10,1
	move 1,11
	movei 2,3
	pushj 17,trne_loop
	add 10,1
	move 1,11
	movei 2,3
	pushj 17,tlnn_loop
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.globl	tskdir
tskdir:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 11,1
	move 13,2
	move 12,3
	movei 3,1
	movei 4,2
	pushj 17,tdne_reg
	move 10,1
	move 1,11
	move 2,13
	movei 3,3
	movei 4,4
	pushj 17,tdnn_reg
	add 10,1
	move 1,11
	move 2,12
	pushj 17,tdne2
	add 10,1
	move 1,11
	move 2,12
	pushj 17,tdnn2
	add 10,1
	move 1,11
	move 2,12
	movei 3,3
	pushj 17,tdne_loop_memory
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

	.globl	tskswp
tskswp:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 11,1
	move 13,2
	move 12,3
	movei 3,1
	movei 4,2
	pushj 17,tsne_reg
	move 10,1
	move 1,11
	move 2,13
	movei 3,3
	movei 4,4
	pushj 17,tsnn_reg
	add 10,1
	move 1,11
	move 2,12
	pushj 17,tsne_mem
	add 10,1
	move 1,11
	move 2,12
	pushj 17,tsnn_mem
	add 10,1
	move 1,11
	move 2,12
	movei 3,3
	pushj 17,tsnn_loop_memory
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

	.bss
tskip_ga:
	.space	4
tskip_gb:
	.space	4
tskip_vga:
	.space	4
tskip_buf:
	.space	64
tskip_gp:
	.space	8
tskip_gt:
	.space	12
