
skip_local_e:
	move 4,1
	skipn (2)
	jrst %L1
	move 4,(3)
	add 4,1
%L1:
	move 1,4
	popj 17,

skip_direct_e:
	move 4,1
	skipn (2)
	jrst %L5
	move 4,(3)
	add 4,1
%L5:
	move 1,4
	popj 17,

skip_unlikely_e:
	move 4,1
	skipn (2)
	jrst %L8
	move 4,(3)
	add 4,1
%L8:
	move 1,4
	popj 17,

skip_likely_e:
	move 4,1
	skipe (2)
	jrst %L12
%L11:
	move 1,4
	popj 17,
%L12:
	move 4,(3)
	add 4,1
	jrst %L11

skip_local_n:
	skipn 2,(2)
	jrst %L14
	add 1,2
%L13:
	popj 17,
%L14:
	add 1,(3)
	popj 17,

skip_direct_n:
	skipn 2,(2)
	jrst %L16
	add 1,2
%L17:
	popj 17,
%L16:
	add 1,(3)
	popj 17,

skip_unlikely_n:
	skipe 2,(2)
	jrst %L21
	add 1,(3)
%L20:
	popj 17,
%L21:
	add 1,2
	popj 17,

skip_likely_n:
	skipn 2,(2)
	jrst %L23
	add 1,2
%L24:
	popj 17,
%L23:
	add 1,(3)
	popj 17,

skip_local_ge:
	skipge 2,(2)
	jrst %L26
	add 1,2
%L25:
	popj 17,
%L26:
	add 1,(3)
	popj 17,

skip_direct_ge:
	skipge 2,(2)
	jrst %L28
	add 1,2
%L29:
	popj 17,
%L28:
	add 1,(3)
	popj 17,

skip_unlikely_ge:
	skipl 2,(2)
	jrst %L33
	add 1,(3)
%L32:
	popj 17,
%L33:
	add 1,2
	popj 17,

skip_likely_ge:
	skipge 2,(2)
	jrst %L35
	add 1,2
%L36:
	popj 17,
%L35:
	add 1,(3)
	popj 17,

skip_local_le:
	skipg 2,(2)
	jrst %L39
	add 1,(3)
%L37:
	popj 17,
%L39:
	add 1,2
	popj 17,

skip_direct_le:
	skipg 2,(2)
	jrst %L43
	add 1,(3)
%L42:
	popj 17,
%L43:
	add 1,2
	popj 17,

skip_unlikely_le:
	skipg 2,(2)
	jrst %L47
	add 1,(3)
%L46:
	popj 17,
%L47:
	add 1,2
	popj 17,

skip_likely_le:
	skiple 2,(2)
	jrst %L49
	add 1,2
%L50:
	popj 17,
%L49:
	add 1,(3)
	popj 17,

skip_local_g:
	skipg 2,(2)
	jrst %L52
	add 1,2
%L51:
	popj 17,
%L52:
	add 1,(3)
	popj 17,

skip_direct_g:
	skipg 2,(2)
	jrst %L54
	add 1,2
%L55:
	popj 17,
%L54:
	add 1,(3)
	popj 17,

skip_unlikely_g:
	skiple 2,(2)
	jrst %L59
	add 1,(3)
%L58:
	popj 17,
%L59:
	add 1,2
	popj 17,

skip_likely_g:
	skipg 2,(2)
	jrst %L61
	add 1,2
%L62:
	popj 17,
%L61:
	add 1,(3)
	popj 17,

skip_local_l:
	skipge 2,(2)
	jrst %L65
	add 1,(3)
%L63:
	popj 17,
%L65:
	add 1,2
	popj 17,

skip_direct_l:
	skipge 2,(2)
	jrst %L69
	add 1,(3)
%L68:
	popj 17,
%L69:
	add 1,2
	popj 17,

skip_unlikely_l:
	skipge 2,(2)
	jrst %L73
	add 1,(3)
%L72:
	popj 17,
%L73:
	add 1,2
	popj 17,

skip_likely_l:
	skipl 2,(2)
	jrst %L75
	add 1,2
%L76:
	popj 17,
%L75:
	add 1,(3)
	popj 17,

sskip_local_e:
	move 4,1
	skipn (2)
	jrst %L77
	move 4,(3)
	add 4,1
%L77:
	move 1,4
	popj 17,

sskip_local_n:
	skipn 2,(2)
	jrst %L80
	add 1,2
%L79:
	popj 17,
%L80:
	add 1,(3)
	popj 17,

sskip_local_ge:
	skipge 2,(2)
	jrst %L82
	add 1,2
%L81:
	popj 17,
%L82:
	add 1,(3)
	popj 17,

sskip_local_le:
	skipg 2,(2)
	jrst %L85
	add 1,(3)
%L83:
	popj 17,
%L85:
	add 1,2
	popj 17,

sskip_local_g:
	skipg 2,(2)
	jrst %L87
	add 1,2
%L86:
	popj 17,
%L87:
	add 1,(3)
	popj 17,

sskip_local_l:
	skipge 2,(2)
	jrst %L90
	add 1,(3)
%L88:
	popj 17,
%L90:
	add 1,2
	popj 17,

skip_e:
	move 4,1
	skipn (2)
	jrst %L93
	move 4,(3)
	add 4,1
%L93:
	move 1,4
	popj 17,

skip_n:
	skipe 2,(2)
	jrst %L97
	add 1,(3)
%L96:
	popj 17,
%L97:
	add 1,2
	popj 17,

skip_ge:
	skipl 2,(2)
	jrst %L101
	add 1,(3)
%L100:
	popj 17,
%L101:
	add 1,2
	popj 17,

skip_le:
	skipg 2,(2)
	jrst %L105
	add 1,(3)
%L104:
	popj 17,
%L105:
	add 1,2
	popj 17,

skip_g:
	skiple 2,(2)
	jrst %L109
	add 1,(3)
%L108:
	popj 17,
%L109:
	add 1,2
	popj 17,

skip_l:
	skipge 2,(2)
	jrst %L113
	add 1,(3)
%L112:
	popj 17,
%L113:
	add 1,2
	popj 17,

skip_e_plain:
	movei 4,0
	skipe (1)
	move 4,(2)
	move 1,4
	popj 17,

skip_n_plain:
	skipn 1,(1)
	move 1,(2)
	popj 17,

skip_ge_plain:
	skipl 1,(1)
%L118:
	popj 17,
	move 1,(2)
	popj 17,

skip_le_plain:
	skiple 1,(1)
	move 1,(2)
	popj 17,

skip_g_plain:
	skiple 1,(1)
%L123:
	popj 17,
	move 1,(2)
	popj 17,

skip_l_plain:
	skipl 1,(1)
	move 1,(2)
	popj 17,

skip_e_inverted:
	movei 4,0
	skipe (1)
	move 4,(2)
	move 1,4
	popj 17,

skip_n_inverted:
	skipn 1,(1)
	move 1,(2)
	popj 17,

skip_ge_inverted:
	skipl 1,(1)
%L132:
	popj 17,
	move 1,(2)
	popj 17,

skip_le_inverted:
	skiple 1,(1)
	move 1,(2)
	popj 17,

skip_g_inverted:
	skiple 1,(1)
%L137:
	popj 17,
	move 1,(2)
	popj 17,

skip_l_inverted:
	skipl 1,(1)
	move 1,(2)
	popj 17,

skip_e_goto:
	movei 4,0
	skipe (1)
	move 4,(2)
%L144:
	move 1,4
	popj 17,

skip_n_goto:
	skipn 1,(1)
	move 1,(2)
%L147:
	popj 17,

skip_ge_goto:
	skipl 1,(1)
%L150:
%L148:
	popj 17,
	move 1,(2)
	popj 17,

skip_le_goto:
	skiple 1,(1)
	move 1,(2)
%L154:
	popj 17,

skip_g_goto:
	skiple 1,(1)
%L157:
%L155:
	popj 17,
	move 1,(2)
	popj 17,

skip_l_goto:
	skipl 1,(1)
	move 1,(2)
%L161:
	popj 17,

skip_e_store:
	skipe (2)
	jrst %L163
	setzm (1)
%L164:
	move 1,(1)
	popj 17,
%L163:
	move 3,(3)
	movem 3,(1)
	jrst %L164

skip_n_store:
	skipn 2,(2)
	jrst %L166
	movem 2,(1)
%L167:
	move 1,(1)
	popj 17,
%L166:
	move 3,(3)
	movem 3,(1)
	jrst %L167

skip_ge_store:
	skipge 2,(2)
	jrst %L169
	movem 2,(1)
%L170:
	move 1,(1)
	popj 17,
%L169:
	move 3,(3)
	movem 3,(1)
	jrst %L170

skip_le_store:
	skipg 2,(2)
	jrst %L174
	move 3,(3)
	movem 3,(1)
%L173:
	move 1,(1)
	popj 17,
%L174:
	movem 2,(1)
	jrst %L173

skip_g_store:
	skipg 2,(2)
	jrst %L176
	movem 2,(1)
%L177:
	move 1,(1)
	popj 17,
%L176:
	move 3,(3)
	movem 3,(1)
	jrst %L177

skip_l_store:
	skipge 2,(2)
	jrst %L181
	move 3,(3)
	movem 3,(1)
%L180:
	move 1,(1)
	popj 17,
%L181:
	movem 2,(1)
	jrst %L180

skip_e_global:
	movei 1,0
	skipe move_skip_g0
	move 1,move_skip_g1
	popj 17,

skip_n_global:
	skipn 1,move_skip_g0
	move 1,move_skip_g1
	popj 17,

skip_ge_global:
	skipl 1,move_skip_g0
%L186:
	popj 17,
	move 1,move_skip_g1
	popj 17,

skip_le_global:
	skiple 1,move_skip_g0
	move 1,move_skip_g1
	popj 17,

skip_g_global:
	skiple 1,move_skip_g0
%L191:
	popj 17,
	move 1,move_skip_g1
	popj 17,

skip_l_global:
	skipl 1,move_skip_g0
	move 1,move_skip_g1
	popj 17,

sskip_e_global:
	movei 1,0
	skipe move_skip_sg0
	move 1,move_skip_sg1
	popj 17,

sskip_l_global:
	skipl 1,move_skip_sg0
	move 1,move_skip_sg1
	popj 17,

skip_e_array:
	andi 1,17
	movei 4,0
	skipn move_skip_buf(1)
	jrst %L200
	addi 1,1
	andi 1,17
	move 4,move_skip_buf(1)
%L200:
	move 1,4
	popj 17,

skip_n_array:
	andi 1,17
	skipn 4,move_skip_buf(1)
	jrst %L203
	move 1,4
%L202:
	popj 17,
%L203:
	addi 1,1
	andi 1,17
	move 1,move_skip_buf(1)
	popj 17,

skip_ge_array:
	andi 1,17
	skipge 4,move_skip_buf(1)
	jrst %L205
	move 1,4
%L204:
	popj 17,
%L205:
	addi 1,1
	andi 1,17
	move 1,move_skip_buf(1)
	popj 17,

skip_le_array:
	andi 1,17
	skipg 4,move_skip_buf(1)
	jrst %L208
	addi 1,1
	andi 1,17
	move 1,move_skip_buf(1)
%L206:
	popj 17,
%L208:
	move 1,4
	popj 17,

skip_g_array:
	andi 1,17
	skipg 4,move_skip_buf(1)
	jrst %L210
	move 1,4
%L209:
	popj 17,
%L210:
	addi 1,1
	andi 1,17
	move 1,move_skip_buf(1)
	popj 17,

skip_l_array:
	andi 1,17
	skipge 4,move_skip_buf(1)
	jrst %L213
	addi 1,1
	andi 1,17
	move 1,move_skip_buf(1)
%L211:
	popj 17,
%L213:
	move 1,4
	popj 17,

sskip_l_array:
	andi 1,17
	skipge 4,move_skip_sbuf(1)
	jrst %L216
	addi 1,1
	andi 1,17
	move 1,move_skip_sbuf(1)
%L214:
	popj 17,
%L216:
	move 1,4
	popj 17,

skip_e_struct:
	movei 4,0
	skipe (1)
	move 4,1(1)
	move 1,4
	popj 17,

skip_n_struct:
	skipn 4,(1)
	jrst %L220
	move 1,4
%L219:
	popj 17,
%L220:
	move 1,1(1)
	popj 17,

skip_ge_struct:
	skipge 4,(1)
	jrst %L222
	move 1,4
%L221:
	popj 17,
%L222:
	move 1,1(1)
	popj 17,

skip_le_struct:
	skipg 4,(1)
	jrst %L225
	move 1,1(1)
%L223:
	popj 17,
%L225:
	move 1,4
	popj 17,

skip_g_struct:
	skipg 4,(1)
	jrst %L227
	move 1,4
%L226:
	popj 17,
%L227:
	move 1,1(1)
	popj 17,

skip_l_struct:
	skipge 4,(1)
	jrst %L230
	move 1,1(1)
%L228:
	popj 17,
%L230:
	move 1,4
	popj 17,

skip_e_global_struct:
	movei 1,0
	skipe move_skip_gp
	move 1,move_skip_gp+1
	popj 17,

skip_l_global_struct:
	skipl 1,move_skip_gp
	move 1,move_skip_gp+1
	popj 17,

sskip_l_global_struct:
	skipl 1,move_skip_sgp
	move 1,move_skip_sgp+1
	popj 17,

skip_e_volatile:
	move 4,(1)
	movei 1,0
	jumpe 4,%L237
	move 1,(2)
%L237:
	popj 17,

skip_n_volatile:
	move 4,(1)
	move 1,4
	jumpn 4,%L239
	move 1,(2)
%L239:
	popj 17,

skip_l_volatile:
	move 4,(1)
	move 1,4
	jumpl 4,%L241
	move 1,(2)
%L241:
	popj 17,

skip_g_volatile:
	move 4,(1)
	move 1,4
	jumple 4,%L245
%L243:
	popj 17,
%L245:
	move 1,(2)
	popj 17,

skip_e_then_add:
	move 4,3
	skipn (1)
	jrst %L246
	move 4,(2)
	add 4,3
%L246:
	move 1,4
	popj 17,

skip_n_then_sub:
	skipn 1,(1)
	move 1,(2)
	sub 1,3
	popj 17,

skip_l_then_neg:
	skipge 1,(1)
	jrst %L253
	movn 1,(2)
%L251:
	popj 17,
%L253:
	movn 1,1
	popj 17,

skip_g_then_inc:
	skipg 1,(1)
	jrst %L257
%L256:
	addi 1,1
	popj 17,
%L257:
	move 1,(2)
	jrst %L256

skip_e_call_pressure:
	push 17,10
	movei 10,0
	skipe (1)
	move 10,(2)
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,

skip_n_call_pressure:
	push 17,10
	skipn 1,(1)
	jrst %L262
	move 10,1
%L263:
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,
%L262:
	move 10,(2)
	jrst %L263

skip_l_call_pressure:
	push 17,10
	skipge 1,(1)
	jrst %L267
	move 10,(2)
%L266:
	pushj 17,clobber
	move 1,10
	pop 17,10
	popj 17,
%L267:
	move 10,1
	jrst %L266

skip_loop_count_zero:
	move 6,1
	setzb 1,3
	caml 1,2
	popj 17,
	subi 2,1
%L279:
	move 4,3
	andi 4,17
	add 4,6
	skipe (4)
	addi 1,1
	addi 3,1
	sojge 2,%L279	; doloop_end
	popj 17,

skip_loop_count_nonzero:
	move 6,1
	setzb 1,3
	caml 1,2
	popj 17,
	subi 2,1
%L291:
	move 4,3
	andi 4,17
	add 4,6
	skipn 4,(4)
	jrst %L286
	add 1,4
%L283:
	addi 3,1
	sojge 2,%L291	; doloop_end
	popj 17,
%L286:
	aoja 1,%L283

skip_loop_count_negative:
	move 6,1
	setzb 1,3
	caml 1,2
	popj 17,
	subi 2,1
%L303:
	move 4,3
	andi 4,17
	add 4,6
	skipge 4,(4)
	jrst %L304
	addi 1,1
%L295:
	addi 3,1
	sojge 2,%L303	; doloop_end
	popj 17,
%L304:
	add 1,4
	jrst %L295

skip_loop_store:
	movei 5,0
	caml 5,3
	jrst %L318
	move 7,3
	subi 7,1
%L319:
	move 6,5
	andi 6,17
	move 4,2
	add 4,6
	skipe (4)
	jrst %L311
	add 6,1
	setzm (6)
%L308:
	addi 5,1
	sojge 7,%L319	; doloop_end
%L318:
	subi 3,1
	andi 3,17
	add 1,3
	move 1,(1)
	popj 17,
%L311:
	add 6,1
	setom (6)
	jrst %L308

skip_qi_e:
	movei 4,0
	ldb 1,1
	jumpe 1,%L320
	ldb 4,2
	trne 4,400
	orcmi 4,777
%L320:
	move 1,4
	popj 17,

skip_qi_l:
	ldb 4,1
	trne 4,400
	orcmi 4,777
	move 1,4
	jumpl 4,%L322
	ldb 1,2
	trne 1,400
	orcmi 1,777
%L322:
	popj 17,

skip_hi_e:
	movei 4,0
	ldb 1,1
	jumpe 1,%L324
	ldb 4,2
	hrre 4,4
%L324:
	move 1,4
	popj 17,

skip_hi_l:
	ldb 4,1
	hrre 4,4
	move 1,4
	jumpl 4,%L326
	ldb 1,2
	hrre 1,1
%L326:
	popj 17,

	.bss
move_skip_g0:
	.space	4
move_skip_g1:
	.space	4
move_skip_sg0:
	.space	4
move_skip_sg1:
	.space	4
move_skip_buf:
	.space	64
move_skip_sbuf:
	.space	64
move_skip_gp:
	.space	8
move_skip_sgp:
	.space	8
