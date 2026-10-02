	.data
	.align	2
ca_init:
	.word	1002003
	.word	4005006007
	.word	10000000000
	.align	2
uca_init:
	.word	1002003
	.word	177200377400
	.word	777000000000
	.align	2
qa_init:
	.word	1777177
	.word	200377400777
	.word	400000000000
	.align	2
uqa_init:
	.word	1177200
	.word	377400777123
	.word	456000000000
	.align	2
gcp:
	.long	ca+29142024192
	.align	2
gucp:
	.long	uca+29142024192
	.align	2
gqp:
	.long	qa+29142024192
	.align	2
guqp:
	.long	uqa+29142024192
	.align	2
gvcp:
	.long	vca+29142024192

load_char_index:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,ca,8]
	jumpe 4,%L8
%L7:
	ibp 3
	sojn 4,%L7	; decrement_and_branch_until_zero
%L8:
	ldb 1,3
	popj 17,

load_schar_index:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,sca,8]
	jumpe 4,%L11
%L10:
	ibp 3
	sojn 4,%L10	; decrement_and_branch_until_zero
%L11:
	ldb 1,3
	trne 1,400
	orcmi 1,777
	popj 17,

load_uchar_index:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,uca,8]
	jumpe 4,%L14
%L13:
	ibp 3
	sojn 4,%L13	; decrement_and_branch_until_zero
%L14:
	ldb 1,3
	popj 17,

load_qint_index:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,qa,8]
	jumpe 4,%L17
%L16:
	ibp 3
	sojn 4,%L16	; decrement_and_branch_until_zero
%L17:
	ldb 1,3
	trne 1,400
	orcmi 1,777
	popj 17,

load_sqint_index:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,sqa,8]
	jumpe 4,%L20
%L19:
	ibp 3
	sojn 4,%L19	; decrement_and_branch_until_zero
%L20:
	ldb 1,3
	trne 1,400
	orcmi 1,777
	popj 17,

load_uqint_index:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,uqa,8]
	jumpe 4,%L23
%L22:
	ibp 3
	sojn 4,%L22	; decrement_and_branch_until_zero
%L23:
	ldb 1,3
	popj 17,

load_char_ptr:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L27
%L26:
	ibp 1
	sojn 4,%L26	; decrement_and_branch_until_zero
%L27:
	ldb 1,1
	popj 17,

load_schar_ptr:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L31
%L30:
	ibp 1
	sojn 4,%L30	; decrement_and_branch_until_zero
%L31:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

load_uchar_ptr:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L35
%L34:
	ibp 1
	sojn 4,%L34	; decrement_and_branch_until_zero
%L35:
	ldb 1,1
	popj 17,

load_qint_ptr:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L39
%L38:
	ibp 1
	sojn 4,%L38	; decrement_and_branch_until_zero
%L39:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

load_uqint_ptr:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L43
%L42:
	ibp 1
	sojn 4,%L42	; decrement_and_branch_until_zero
%L43:
	ldb 1,1
	popj 17,

load_const_boundaries:
	move 1,ca
	lsh 1,-33
	move 4,ca
	andi 4,777
	add 1,4
	move 4,ca+1
	lsh 4,-33
	add 1,4
	move 4,ca+1
	andi 4,777
	add 1,4
	move 4,ca+2
	lsh 4,-33
	add 1,4
	move 4,ca+3
	andi 4,777
	add 1,4
	move 4,ca+4
	lsh 4,-33
	add 1,4
	move 4,uca
	lsh 4,-33
	add 1,4
	move 4,uca
	andi 4,777
	add 1,4
	move 4,uca+1
	lsh 4,-33
	add 1,4
	move 4,uca+1
	andi 4,777
	add 1,4
	move 4,uca+2
	lsh 4,-33
	add 1,4
	move 4,qa
	ash 4,-33
	add 1,4
	move 4,qa
	lsh 4,33
	ash 4,-33
	add 1,4
	move 4,qa+1
	ash 4,-33
	add 1,4
	move 4,qa+1
	lsh 4,33
	ash 4,-33
	add 1,4
	move 4,qa+2
	ash 4,-33
	add 1,4
	move 4,uqa
	lsh 4,-33
	add 1,4
	move 4,uqa
	andi 4,777
	add 1,4
	move 4,uqa+1
	lsh 4,-33
	add 1,4
	move 4,uqa+1
	andi 4,777
	add 1,4
	move 4,uqa+2
	lsh 4,-33
	add 1,4
	popj 17,

load_initialized_qi:
	move 5,1
	move 2,1
	move 6,1
	andi 6,3
	move 4,6
	ash 2,-2	; ashrsi3_pointer
	move 3,2
	add 3,[POINT 9,ca_init,8]
	jumpe 6,%L47
%L46:
	ibp 3
	sojn 4,%L46	; decrement_and_branch_until_zero
%L47:
	ldb 7,3
	move 4,6
	move 3,2
	add 3,[POINT 9,uca_init,8]
	jumpe 6,%L49
%L48:
	ibp 3
	sojn 4,%L48	; decrement_and_branch_until_zero
%L49:
	ldb 3,3
	add 7,3
	move 1,2
	add 1,[POINT 9,qa_init,8]
	skipn 4,6
	jrst %L51
%L50:
	ibp 1
	sojn 4,%L50	; decrement_and_branch_until_zero
%L51:
	ldb 3,1
	trne 3,400
	orcmi 3,777
	add 3,7
	move 1,5
	andi 1,3
	move 4,2
	add 4,[POINT 9,uqa_init,8]
	jumpe 1,%L53
%L52:
	ibp 4
	sojn 1,%L52	; decrement_and_branch_until_zero
%L53:
	ldb 4,4
	add 3,4
	move 4,ca_init
	lsh 4,-33
	add 3,4
	move 4,ca_init+1
	lsh 4,-33
	add 3,4
	move 4,ca_init+2
	lsh 4,-33
	add 3,4
	move 4,uca_init+1
	lsh 4,-33
	add 3,4
	move 4,uca_init+2
	lsh 4,-33
	add 3,4
	move 4,qa_init
	lsh 4,22
	ash 4,-33
	add 3,4
	move 4,qa_init+2
	ash 4,-33
	add 3,4
	ldb 4,[POINT 9,uqa_init+1,26]
	add 3,4
	move 1,3
	popj 17,

store_char_index:
	push 17,10
	move 10,1
	move 7,1
	move 6,1
	andi 6,3
	move 4,6
	ash 7,-2	; ashrsi3_pointer
	move 3,7
	add 3,[POINT 9,ca,8]
	jumpe 6,%L56
%L55:
	ibp 3
	sojn 4,%L55	; decrement_and_branch_until_zero
%L56:
	dpb 2,3
	move 4,6
	move 3,7
	add 3,[POINT 9,sca,8]
	jumpe 6,%L58
%L57:
	ibp 3
	sojn 4,%L57	; decrement_and_branch_until_zero
%L58:
	addi 2,1
	dpb 2,3
	subi 2,1
	move 4,6
	move 3,7
	add 3,[POINT 9,uca,8]
	jumpe 6,%L60
%L59:
	ibp 3
	sojn 4,%L59	; decrement_and_branch_until_zero
%L60:
	addi 2,2
	dpb 2,3
	subi 2,2
	move 4,6
	move 3,7
	add 3,[POINT 9,qa,8]
	jumpe 6,%L62
%L61:
	ibp 3
	sojn 4,%L61	; decrement_and_branch_until_zero
%L62:
	addi 2,3
	dpb 2,3
	subi 2,3
	move 4,6
	move 3,7
	add 3,[POINT 9,sqa,8]
	jumpe 6,%L64
%L63:
	ibp 3
	sojn 4,%L63	; decrement_and_branch_until_zero
%L64:
	addi 2,4
	dpb 2,3
	subi 2,4
	move 4,6
	move 3,7
	add 3,[POINT 9,uqa,8]
	jumpe 6,%L66
%L65:
	ibp 3
	sojn 4,%L65	; decrement_and_branch_until_zero
%L66:
	addi 2,5
	dpb 2,3
	move 4,6
	move 3,7
	add 3,[POINT 9,ca,8]
	jumpe 6,%L68
%L67:
	ibp 3
	sojn 4,%L67	; decrement_and_branch_until_zero
%L68:
	ldb 5,3
	move 4,6
	move 3,7
	add 3,[POINT 9,sca,8]
	jumpe 6,%L70
%L69:
	ibp 3
	sojn 4,%L69	; decrement_and_branch_until_zero
%L70:
	ldb 2,3
	trne 2,400
	orcmi 2,777
	add 2,5
	move 4,6
	move 3,7
	add 3,[POINT 9,uca,8]
	jumpe 6,%L72
%L71:
	ibp 3
	sojn 4,%L71	; decrement_and_branch_until_zero
%L72:
	ldb 5,3
	add 5,2
	move 4,6
	move 3,7
	add 3,[POINT 9,qa,8]
	jumpe 6,%L74
%L73:
	ibp 3
	sojn 4,%L73	; decrement_and_branch_until_zero
%L74:
	ldb 2,3
	trne 2,400
	orcmi 2,777
	add 2,5
	move 1,7
	add 1,[POINT 9,sqa,8]
	skipn 4,6
	jrst %L76
%L75:
	ibp 1
	sojn 4,%L75	; decrement_and_branch_until_zero
%L76:
	ldb 3,1
	trne 3,400
	orcmi 3,777
	add 3,2
	move 1,10
	andi 1,3
	move 4,7
	add 4,[POINT 9,uqa,8]
	jumpe 1,%L78
%L77:
	ibp 4
	sojn 1,%L77	; decrement_and_branch_until_zero
%L78:
	ldb 4,4
	add 3,4
	move 1,3
	pop 17,10
	popj 17,

store_char_ptr:
	push 17,10
	move 7,2
	move 5,2
	andi 5,3
	move 4,5
	ash 7,-2	; ashrsi3_pointer
	move 6,1
	add 6,7
	jumpe 5,%L82
%L81:
	ibp 6
	sojn 4,%L81	; decrement_and_branch_until_zero
%L82:
	dpb 3,6
	move 10,1
	ibp 10
	move 4,5
	move 6,10
	add 6,7
	jumpe 5,%L85
%L84:
	ibp 6
	sojn 4,%L84	; decrement_and_branch_until_zero
%L85:
	addi 3,1
	dpb 3,6
	add 1,7
	skipn 4,5
	jrst %L88
%L87:
	ibp 1
	sojn 4,%L87	; decrement_and_branch_until_zero
%L88:
	ldb 1,1
	andi 2,3
	move 4,10
	add 4,7
	jumpe 2,%L91
%L90:
	ibp 4
	sojn 2,%L90	; decrement_and_branch_until_zero
%L91:
	ldb 4,4
	add 1,4
	pop 17,10
	popj 17,

store_uchar_ptr:
	push 17,10
	move 7,2
	move 5,2
	andi 5,3
	move 4,5
	ash 7,-2	; ashrsi3_pointer
	move 6,1
	add 6,7
	jumpe 5,%L95
%L94:
	ibp 6
	sojn 4,%L94	; decrement_and_branch_until_zero
%L95:
	dpb 3,6
	move 10,1
	ibp 10
	move 4,5
	move 6,10
	add 6,7
	jumpe 5,%L98
%L97:
	ibp 6
	sojn 4,%L97	; decrement_and_branch_until_zero
%L98:
	addi 3,1
	dpb 3,6
	add 1,7
	skipn 4,5
	jrst %L101
%L100:
	ibp 1
	sojn 4,%L100	; decrement_and_branch_until_zero
%L101:
	ldb 1,1
	andi 2,3
	move 4,10
	add 4,7
	jumpe 2,%L104
%L103:
	ibp 4
	sojn 2,%L103	; decrement_and_branch_until_zero
%L104:
	ldb 4,4
	add 1,4
	pop 17,10
	popj 17,

store_qint_ptr:
	push 17,10
	move 7,2
	move 5,2
	andi 5,3
	move 4,5
	ash 7,-2	; ashrsi3_pointer
	move 6,1
	add 6,7
	jumpe 5,%L108
%L107:
	ibp 6
	sojn 4,%L107	; decrement_and_branch_until_zero
%L108:
	dpb 3,6
	move 10,1
	ibp 10
	move 4,5
	move 6,10
	add 6,7
	jumpe 5,%L111
%L110:
	ibp 6
	sojn 4,%L110	; decrement_and_branch_until_zero
%L111:
	addi 3,1
	dpb 3,6
	add 1,7
	skipn 4,5
	jrst %L114
%L113:
	ibp 1
	sojn 4,%L113	; decrement_and_branch_until_zero
%L114:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	andi 2,3
	move 4,10
	add 4,7
	jumpe 2,%L117
%L116:
	ibp 4
	sojn 2,%L116	; decrement_and_branch_until_zero
%L117:
	ldb 4,4
	trne 4,400
	orcmi 4,777
	add 1,4
	pop 17,10
	popj 17,

store_uqint_ptr:
	push 17,10
	move 7,2
	move 5,2
	andi 5,3
	move 4,5
	ash 7,-2	; ashrsi3_pointer
	move 6,1
	add 6,7
	jumpe 5,%L121
%L120:
	ibp 6
	sojn 4,%L120	; decrement_and_branch_until_zero
%L121:
	dpb 3,6
	move 10,1
	ibp 10
	move 4,5
	move 6,10
	add 6,7
	jumpe 5,%L124
%L123:
	ibp 6
	sojn 4,%L123	; decrement_and_branch_until_zero
%L124:
	addi 3,1
	dpb 3,6
	add 1,7
	skipn 4,5
	jrst %L127
%L126:
	ibp 1
	sojn 4,%L126	; decrement_and_branch_until_zero
%L127:
	ldb 1,1
	andi 2,3
	move 4,10
	add 4,7
	jumpe 2,%L130
%L129:
	ibp 4
	sojn 2,%L129	; decrement_and_branch_until_zero
%L130:
	ldb 4,4
	add 1,4
	pop 17,10
	popj 17,

post_store_result:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,ca,8]
	jumpe 4,%L133
%L132:
	ibp 3
	sojn 4,%L132	; decrement_and_branch_until_zero
%L133:
	dpb 2,3
	move 7,2
	andi 7,777
	move 4,1
	aos 3,4
	andi 3,3
	move 6,4
	ash 6,-2	; ashrsi3_pointer
	add 6,[POINT 9,uca,8]
	jumpe 3,%L135
%L134:
	ibp 6
	sojn 3,%L134	; decrement_and_branch_until_zero
%L135:
	move 4,2
	addi 4,1
	dpb 4,6
	andi 4,777
	add 7,4
	move 4,1
	addi 4,2
	move 3,4
	andi 3,3
	move 6,4
	ash 6,-2	; ashrsi3_pointer
	add 6,[POINT 9,qa,8]
	jumpe 3,%L137
%L136:
	ibp 6
	sojn 3,%L136	; decrement_and_branch_until_zero
%L137:
	move 4,2
	addi 4,2
	dpb 4,6
	lsh 4,33
	ash 4,-33
	add 7,4
	move 4,1
	addi 4,3
	move 3,4
	andi 3,3
	move 1,4
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,uqa,8]
	jumpe 3,%L139
%L138:
	ibp 1
	sojn 3,%L138	; decrement_and_branch_until_zero
%L139:
	move 4,2
	addi 4,3
	dpb 4,1
	andi 4,777
	add 7,4
	move 1,7
	popj 17,

copy_char_ptr:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 11,1
	move 12,2
	setzb 10,1
	caml 10,3
	jrst %L156
	move 2,3
	subi 2,1
%L157:
	move 5,1
	andi 5,3
	move 4,5
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	move 7,11
	add 7,3
	jumpe 5,%L147
%L146:
	ibp 7
	sojn 4,%L146	; decrement_and_branch_until_zero
%L147:
	move 6,5
	move 4,12
	add 4,3
	jumpe 5,%L150
%L149:
	ibp 4
	sojn 6,%L149	; decrement_and_branch_until_zero
%L150:
	ldb 4,4
	dpb 4,7
	move 6,11
	add 6,3
	skipn 4,5
	jrst %L153
%L152:
	ibp 6
	sojn 4,%L152	; decrement_and_branch_until_zero
%L153:
	ldb 6,6
	add 10,6
	addi 1,1
	sojge 2,%L157	; doloop_end
%L156:
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

copy_uchar_ptr:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 11,1
	move 12,2
	setzb 10,1
	caml 10,3
	jrst %L174
	move 2,3
	subi 2,1
%L175:
	move 5,1
	andi 5,3
	move 4,5
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	move 7,11
	add 7,3
	jumpe 5,%L165
%L164:
	ibp 7
	sojn 4,%L164	; decrement_and_branch_until_zero
%L165:
	move 6,5
	move 4,12
	add 4,3
	jumpe 5,%L168
%L167:
	ibp 4
	sojn 6,%L167	; decrement_and_branch_until_zero
%L168:
	ldb 4,4
	dpb 4,7
	move 6,11
	add 6,3
	skipn 4,5
	jrst %L171
%L170:
	ibp 6
	sojn 4,%L170	; decrement_and_branch_until_zero
%L171:
	ldb 6,6
	add 10,6
	addi 1,1
	sojge 2,%L175	; doloop_end
%L174:
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

copy_qint_ptr:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 11,1
	move 12,2
	setzb 10,1
	caml 10,3
	jrst %L192
	move 2,3
	subi 2,1
%L193:
	move 5,1
	andi 5,3
	move 4,5
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	move 7,11
	add 7,3
	jumpe 5,%L183
%L182:
	ibp 7
	sojn 4,%L182	; decrement_and_branch_until_zero
%L183:
	move 6,5
	move 4,12
	add 4,3
	jumpe 5,%L186
%L185:
	ibp 4
	sojn 6,%L185	; decrement_and_branch_until_zero
%L186:
	ldb 4,4
	dpb 4,7
	move 6,11
	add 6,3
	skipn 4,5
	jrst %L189
%L188:
	ibp 6
	sojn 4,%L188	; decrement_and_branch_until_zero
%L189:
	ldb 4,6
	trne 4,400
	orcmi 4,777
	add 10,4
	addi 1,1
	sojge 2,%L193	; doloop_end
%L192:
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

copy_uqint_ptr:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 11,1
	move 12,2
	setzb 10,1
	caml 10,3
	jrst %L210
	move 2,3
	subi 2,1
%L211:
	move 5,1
	andi 5,3
	move 4,5
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	move 7,11
	add 7,3
	jumpe 5,%L201
%L200:
	ibp 7
	sojn 4,%L200	; decrement_and_branch_until_zero
%L201:
	move 6,5
	move 4,12
	add 4,3
	jumpe 5,%L204
%L203:
	ibp 4
	sojn 6,%L203	; decrement_and_branch_until_zero
%L204:
	ldb 4,4
	dpb 4,7
	move 6,11
	add 6,3
	skipn 4,5
	jrst %L207
%L206:
	ibp 6
	sojn 4,%L206	; decrement_and_branch_until_zero
%L207:
	ldb 6,6
	add 10,6
	addi 1,1
	sojge 2,%L211	; doloop_end
%L210:
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

walk_char_ptr:
	movei 4,0
	caml 4,2
	jrst %L219
	subi 2,1
%L220:
	ldb 6,1
	add 4,6
	ibp 1
	sojge 2,%L220	; doloop_end
%L219:
	move 1,4
	popj 17,

walk_uchar_ptr:
	movei 4,0
	caml 4,2
	jrst %L228
	subi 2,1
%L229:
	ldb 6,1
	add 4,6
	ibp 1
	sojge 2,%L229	; doloop_end
%L228:
	move 1,4
	popj 17,

walk_qint_ptr:
	movei 3,0
	caml 3,2
	jrst %L237
	subi 2,1
%L238:
	ldb 4,1
	trne 4,400
	orcmi 4,777
	add 3,4
	ibp 1
	sojge 2,%L238	; doloop_end
%L237:
	move 1,3
	popj 17,

preinc_char_ptr:
	ildb 4,1
	ildb 1,1
	add 4,1
	move 1,4
	popj 17,

postinc_char_ptr:
	ldb 4,1
	ildb 1,1
	add 4,1
	move 1,4
	popj 17,

load_struct_qi:
	move 3,1
	move 1,(1)
	lsh 1,-33
	move 4,(3)
	lsh 4,11
	ash 4,-33
	add 1,4
	ldb 4,[POINT 9,(3),26]
	add 1,4
	move 4,(3)
	lsh 4,33
	ash 4,-33
	add 1,4
	move 4,1(3)
	ash 4,-33
	add 1,4
	ldb 4,[POINT 9,1(3),17]
	add 1,4
	popj 17,

store_struct_qi:
	dpb 2,[POINT 9,(1),8]
	addi 2,1
	dpb 2,[POINT 9,(1),17]
	addi 2,1
	dpb 2,[POINT 9,(1),26]
	addi 2,1
	dpb 2,[POINT 9,(1),35]
	addi 2,1
	idpb 2,[POINT 9,(1),8]
	subi 1,1
	addi 2,1
	dpb 2,[POINT 9,1(1),17]
	popj 17,

load_struct_array_qi:
	lsh 1,2
	move 2,1
	add 2,[POINT 9,qpa,8]
	move 3,qpa(1)
	lsh 3,-33
	move 4,qpa(1)
	lsh 4,11
	ash 4,-33
	add 3,4
	ldb 4,[POINT 9,qpa(1),26]
	add 3,4
	move 4,qpa(1)
	lsh 4,33
	ash 4,-33
	add 3,4
	move 4,1(2)
	ash 4,-33
	add 3,4
	ldb 4,[POINT 9,1(2),17]
	add 3,4
	move 1,3
	popj 17,

store_struct_array_qi:
	move 4,1
	lsh 4,2
	move 3,4
	add 3,[POINT 9,qpa,8]
	dpb 2,[POINT 9,(3),8]
	addi 2,1
	dpb 2,[POINT 9,qpa(4),17]
	addi 2,1
	dpb 2,[POINT 9,qpa(4),26]
	addi 2,1
	dpb 2,[POINT 9,qpa(4),35]
	addi 2,1
	idpb 2,[POINT 9,(3),8]
	subi 3,1
	addi 2,1
	dpb 2,[POINT 9,1(3),17]
	jrst load_struct_array_qi

load_packed_qi:
	move 1,(1)
	lsh 1,2
	popj 17,

store_packed_qi:
	dpb 2,1
	addi 2,1
	dpb 2,1
	addi 2,1
	dpb 2,1
	addi 2,1
	dpb 2,1
	popj 17,

use_union_qi:
	dpb 1,[POINT 9,qu,8]
	move 3,qu
	lsh 3,-33
	addi 1,1
	dpb 1,[POINT 9,qu,8]
	move 4,qu
	lsh 4,-33
	add 3,4
	addi 1,1
	dpb 1,[POINT 9,qu,8]
	move 4,qu
	ash 4,-33
	add 3,4
	addi 1,1
	dpb 1,[POINT 9,qu,8]
	move 4,qu
	lsh 4,-33
	add 3,4
	add 3,qu
	move 1,3
	popj 17,

load_volatile_qi:
	move 1,vc
	hrre 4,vsc
	add 1,4
	move 4,vuc
	add 1,4
	hrre 4,vq
	add 1,4
	hrre 4,vsq
	add 1,4
	move 4,vuq
	add 1,4
	popj 17,

load_volatile_array_qi:
	move 2,1
	move 6,1
	andi 6,3
	move 3,6
	ash 2,-2	; ashrsi3_pointer
	move 4,2
	add 4,[POINT 9,vca,8]
	jumpe 6,%L251
%L250:
	ibp 4
	sojn 3,%L250	; decrement_and_branch_until_zero
%L251:
	ldb 4,4
	move 7,4
	move 3,6
	move 4,2
	add 4,[POINT 9,vuca,8]
	jumpe 6,%L253
%L252:
	ibp 4
	sojn 3,%L252	; decrement_and_branch_until_zero
%L253:
	ldb 4,4
	add 7,4
	move 4,2
	add 4,[POINT 9,vqa,8]
	skipn 3,6
	jrst %L255
%L254:
	ibp 4
	sojn 3,%L254	; decrement_and_branch_until_zero
%L255:
	ldb 4,4
	move 3,4
	trne 3,400
	orcmi 3,777
	add 3,7
	andi 1,3
	move 4,2
	add 4,[POINT 9,vuqa,8]
	jumpe 1,%L257
%L256:
	ibp 4
	sojn 1,%L256	; decrement_and_branch_until_zero
%L257:
	ldb 4,4
	add 3,4
	move 1,3
	popj 17,

store_volatile_qi:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	movem 2,vc
	addi 2,1
	movem 2,vsc
	addi 2,1
	movem 2,vuc
	addi 2,1
	movem 2,vq
	addi 2,1
	movem 2,vsq
	addi 2,1
	movem 2,vuq
	subi 2,5
	andi 1,3
	move 4,1
	move 6,11
	ash 6,-2	; ashrsi3_pointer
	move 3,6
	add 3,[POINT 9,vca,8]
	jumpe 1,%L260
%L259:
	ibp 3
	sojn 4,%L259	; decrement_and_branch_until_zero
%L260:
	addi 2,6
	dpb 2,3
	subi 2,6
	move 4,1
	move 3,6
	add 3,[POINT 9,vuca,8]
	jumpe 1,%L262
%L261:
	ibp 3
	sojn 4,%L261	; decrement_and_branch_until_zero
%L262:
	addi 2,7
	dpb 2,3
	subi 2,7
	move 4,1
	move 3,6
	add 3,[POINT 9,vqa,8]
	jumpe 1,%L264
%L263:
	ibp 3
	sojn 4,%L263	; decrement_and_branch_until_zero
%L264:
	addi 2,10
	dpb 2,3
	subi 2,10
	move 3,6
	add 3,[POINT 9,vuqa,8]
	skipn 4,1
	jrst %L266
%L265:
	ibp 3
	sojn 4,%L265	; decrement_and_branch_until_zero
%L266:
	addi 2,11
	dpb 2,3
	pushj 17,load_volatile_qi
	move 10,1
	move 1,11
	pushj 17,load_volatile_array_qi
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

stack_qi:
	add 17,[32,,32]
	movem 16,-31(17)
	movei 0,-30(17)
	hrli 0,10
	blt 0,-23(17)
	movei 11,0
	movei 6,-22(17)
	tlo 6,331100
	movem 6,(17)
	movei 15,-14(17)
	movei 16,-11(17)
	movei 14,-6(17)
	movei 13,-3(17)
	move 10,1
	movei 12,10
%L293:
	move 2,11
	andi 2,3
	move 4,2
	move 7,11
	ash 7,-2	; ashrsi3_pointer
	move 3,(17)
	add 3,7
	jumpe 2,%L274
%L273:
	ibp 3
	sojn 4,%L273	; decrement_and_branch_until_zero
%L274:
	move 6,1
	dpb 1,3
	movei 3,-17(17)
	tlo 3,331100
	move 4,2
	add 3,7
	jumpe 2,%L277
%L276:
	ibp 3
	sojn 4,%L276	; decrement_and_branch_until_zero
%L277:
	move 5,10
	dpb 10,3
	move 3,15
	tlo 3,331100
	move 4,2
	add 3,7
	jumpe 2,%L280
%L279:
	ibp 3
	sojn 4,%L279	; decrement_and_branch_until_zero
%L280:
	addi 6,1
	dpb 6,3
	subi 6,1
	move 3,16
	tlo 3,331100
	move 4,2
	add 3,7
	jumpe 2,%L283
%L282:
	ibp 3
	sojn 4,%L282	; decrement_and_branch_until_zero
%L283:
	addi 6,2
	dpb 6,3
	subi 6,2
	move 3,14
	tlo 3,331100
	move 4,2
	add 3,7
	jumpe 2,%L286
%L285:
	ibp 3
	sojn 4,%L285	; decrement_and_branch_until_zero
%L286:
	subi 5,2
	dpb 5,3
	move 3,13
	tlo 3,331100
	add 3,7
	skipn 4,2
	jrst %L289
%L288:
	ibp 3
	sojn 4,%L288	; decrement_and_branch_until_zero
%L289:
	addi 6,3
	dpb 6,3
	subi 10,1
	addi 1,1
	addi 11,1
	sojge 12,%L293	; doloop_end
	move 1,-22(17)
	lsh 1,-33
	move 4,-22(17)
	andi 4,777
	add 1,4
	move 4,-21(17)
	lsh 4,-33
	add 1,4
	move 4,-20(17)
	lsh 4,-33
	add 1,4
	move 4,-17(17)
	ash 4,-33
	move 3,-17(17)
	lsh 3,33
	ash 3,-33
	add 4,3
	move 3,-16(17)
	ash 3,-33
	add 4,3
	move 3,-15(17)
	ash 3,-33
	add 4,3
	add 1,4
	move 4,-14(17)
	lsh 4,-33
	move 3,-14(17)
	andi 3,777
	add 4,3
	move 3,-13(17)
	lsh 3,-33
	add 4,3
	move 3,-12(17)
	lsh 3,-33
	add 4,3
	add 1,4
	move 4,-11(17)
	ash 4,-33
	move 3,-11(17)
	lsh 3,33
	ash 3,-33
	add 4,3
	move 3,-10(17)
	ash 3,-33
	add 4,3
	move 3,-7(17)
	ash 3,-33
	add 4,3
	add 1,4
	move 4,-6(17)
	ash 4,-33
	move 3,-6(17)
	lsh 3,33
	ash 3,-33
	add 4,3
	move 3,-5(17)
	ash 3,-33
	add 4,3
	move 3,-4(17)
	ash 3,-33
	add 4,3
	add 1,4
	move 4,-3(17)
	lsh 4,-33
	move 3,-3(17)
	andi 3,777
	add 4,3
	move 3,-2(17)
	lsh 3,-33
	add 4,3
	move 3,-1(17)
	lsh 3,-33
	add 4,3
	add 1,4
	move 16,-31(17)
	movei 0,10
	hrli 0,-30(17)
	blt 0,15
	add 17,[-32,,-32]
	popj 17,

pointer_roundtrip_qi:
	move 3,1
	andi 3,3
	move 6,1
	ash 6,-2	; ashrsi3_pointer
	add 6,[POINT 9,ca,8]
	jumpe 3,%L298
%L297:
	ibp 6
	sojn 3,%L297	; decrement_and_branch_until_zero
%L298:
	move 4,2
	addi 4,3
	move 3,4
	dpb 4,6
	andi 4,777	; zero_extendqisi2
	move 1,4
	lsh 1,1
	lsh 3,33
	ash 3,-33
	add 1,3
	add 1,4
	move 4,6
	andi 4,3
	ash 6,-2	; ashrsi3_pointer
	add 1,6
	jumpe 4,%L306
%L305:
	ibp 1
	sojn 4,%L305	; decrement_and_branch_until_zero
%L306:
	move 6,[POINT 9,ca,8]
	sub 1,6
	popj 17,

reload_global_ptrs:
	add 17,[7,,7]
	movem 16,-6(17)
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 16,1
	move 10,2
	move 11,gcp
	move 12,gucp
	move 13,gqp
	move 14,guqp
	move 15,gvcp
	pushj 17,clobber
	move 4,16
	move 6,16
	andi 6,3
	move 3,6
	ash 4,-2	; ashrsi3_pointer
	move 2,11
	add 2,4
	jumpe 6,%L312
%L311:
	ibp 2
	sojn 3,%L311	; decrement_and_branch_until_zero
%L312:
	dpb 10,2
	move 3,6
	move 2,12
	add 2,4
	jumpe 6,%L315
%L314:
	ibp 2
	sojn 3,%L314	; decrement_and_branch_until_zero
%L315:
	addi 10,1
	dpb 10,2
	subi 10,1
	move 3,6
	move 2,13
	add 2,4
	jumpe 6,%L318
%L317:
	ibp 2
	sojn 3,%L317	; decrement_and_branch_until_zero
%L318:
	addi 10,2
	dpb 10,2
	subi 10,2
	move 3,6
	move 2,14
	add 2,4
	jumpe 6,%L321
%L320:
	ibp 2
	sojn 3,%L320	; decrement_and_branch_until_zero
%L321:
	addi 10,3
	dpb 10,2
	subi 10,3
	move 3,6
	move 2,15
	add 2,4
	jumpe 6,%L324
%L323:
	ibp 2
	sojn 3,%L323	; decrement_and_branch_until_zero
%L324:
	addi 10,4
	dpb 10,2
	move 3,6
	move 2,11
	add 2,4
	jumpe 6,%L327
%L326:
	ibp 2
	sojn 3,%L326	; decrement_and_branch_until_zero
%L327:
	ldb 1,2
	move 3,6
	move 2,12
	add 2,4
	jumpe 6,%L330
%L329:
	ibp 2
	sojn 3,%L329	; decrement_and_branch_until_zero
%L330:
	ldb 2,2
	add 1,2
	move 3,6
	move 2,13
	add 2,4
	jumpe 6,%L333
%L332:
	ibp 2
	sojn 3,%L332	; decrement_and_branch_until_zero
%L333:
	ldb 2,2
	trne 2,400
	orcmi 2,777
	add 2,1
	move 1,14
	add 1,4
	skipn 3,6
	jrst %L336
%L335:
	ibp 1
	sojn 3,%L335	; decrement_and_branch_until_zero
%L336:
	ldb 3,1
	add 3,2
	move 1,16
	andi 1,3
	add 4,15
	jumpe 1,%L339
%L338:
	ibp 4
	sojn 1,%L338	; decrement_and_branch_until_zero
%L339:
	ldb 4,4
	add 3,4
	move 1,3
	move 16,-6(17)
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-7,,-7]
	popj 17,

compare_qi_values:
	move 7,1
	move 6,1
	andi 6,3
	move 4,6
	ash 7,-2	; ashrsi3_pointer
	move 3,7
	add 3,[POINT 9,ca,8]
	jumpe 6,%L342
%L341:
	ibp 3
	sojn 4,%L341	; decrement_and_branch_until_zero
%L342:
	dpb 2,3
	move 4,6
	move 3,7
	add 3,[POINT 9,sca,8]
	jumpe 6,%L344
%L343:
	ibp 3
	sojn 4,%L343	; decrement_and_branch_until_zero
%L344:
	dpb 2,3
	move 4,6
	move 3,7
	add 3,[POINT 9,uca,8]
	jumpe 6,%L346
%L345:
	ibp 3
	sojn 4,%L345	; decrement_and_branch_until_zero
%L346:
	dpb 2,3
	move 4,6
	move 3,7
	add 3,[POINT 9,qa,8]
	jumpe 6,%L348
%L347:
	ibp 3
	sojn 4,%L347	; decrement_and_branch_until_zero
%L348:
	dpb 2,3
	move 4,6
	move 3,7
	add 3,[POINT 9,uqa,8]
	jumpe 6,%L350
%L349:
	ibp 3
	sojn 4,%L349	; decrement_and_branch_until_zero
%L350:
	dpb 2,3
	movei 5,0
	move 4,6
	move 3,7
	add 3,[POINT 9,sca,8]
	jumpe 6,%L353
%L352:
	ibp 3
	sojn 4,%L352	; decrement_and_branch_until_zero
%L353:
	ldb 4,3
	trne 4,400
	orcmi 4,777
	jumpl 4,%L363
%L351:
	move 4,6
	move 3,7
	add 3,[POINT 9,uca,8]
	jumpe 6,%L356
%L355:
	ibp 3
	sojn 4,%L355	; decrement_and_branch_until_zero
%L356:
	ldb 4,3
	tlo 4,400000
	camle 4,[-377777777601]
	addi 5,2
	move 3,7
	add 3,[POINT 9,qa,8]
	skipn 4,6
	jrst %L359
%L358:
	ibp 3
	sojn 4,%L358	; decrement_and_branch_until_zero
%L359:
	ldb 3,3
	trne 3,400
	orcmi 3,777
	move 4,2
	lsh 4,33
	ash 4,-33
	camn 3,4
	jrst %L364
%L357:
	andi 1,3
	move 4,7
	add 4,[POINT 9,uqa,8]
	jumpe 1,%L362
%L361:
	ibp 4
	sojn 1,%L361	; decrement_and_branch_until_zero
%L362:
	ldb 4,4
	jumpe 4,%L360
	addi 5,10
%L360:
	move 1,5
	popj 17,
%L364:
	addi 5,4
	jrst %L357
%L363:
	seto 5,
	jrst %L351

scalar_globals_qi:
	movem 1,gc
	move 4,1
	addi 4,1
	movem 4,gsc
	move 7,1
	addi 7,2
	movem 7,guc
	move 3,1
	addi 3,3
	movem 3,gq
	move 2,1
	addi 2,4
	movem 2,gsq
	move 6,1
	addi 6,5
	movem 6,guq
	andi 1,777
	lsh 4,33
	ash 4,-33
	add 4,1
	andi 7,777
	add 7,4
	lsh 3,33
	ash 3,-33
	add 3,7
	lsh 2,33
	ash 2,-33
	add 2,3
	andi 6,777
	add 6,2
	move 1,6
	popj 17,

call_qi_values:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	move 11,1
	move 10,1
	andi 10,3
	move 4,10
	ash 11,-2	; ashrsi3_pointer
	move 3,11
	add 3,[POINT 9,ca,8]
	jumpe 10,%L370
%L369:
	ibp 3
	sojn 4,%L369	; decrement_and_branch_until_zero
%L370:
	ldb 1,3
	pushj 17,use_int
	move 4,10
	move 3,11
	add 3,[POINT 9,uca,8]
	jumpe 10,%L374
%L373:
	ibp 3
	sojn 4,%L373	; decrement_and_branch_until_zero
%L374:
	ldb 1,3
	pushj 17,use_uint
	move 4,10
	move 3,11
	add 3,[POINT 9,qa,8]
	jumpe 10,%L378
%L377:
	ibp 3
	sojn 4,%L377	; decrement_and_branch_until_zero
%L378:
	ldb 1,3
	trne 1,400
	orcmi 1,777
	pushj 17,use_int
	move 4,10
	move 3,11
	add 3,[POINT 9,uqa,8]
	jumpe 10,%L382
%L381:
	ibp 3
	sojn 4,%L381	; decrement_and_branch_until_zero
%L382:
	ldb 1,3
	pushj 17,use_uint
	move 4,10
	move 3,11
	add 3,[POINT 9,ca,8]
	jumpe 10,%L384
%L383:
	ibp 3
	sojn 4,%L383	; decrement_and_branch_until_zero
%L384:
	ldb 2,3
	move 4,10
	move 3,11
	add 3,[POINT 9,uca,8]
	jumpe 10,%L386
%L385:
	ibp 3
	sojn 4,%L385	; decrement_and_branch_until_zero
%L386:
	ldb 3,3
	add 2,3
	move 1,11
	add 1,[POINT 9,qa,8]
	skipn 4,10
	jrst %L388
%L387:
	ibp 1
	sojn 4,%L387	; decrement_and_branch_until_zero
%L388:
	ldb 3,1
	trne 3,400
	orcmi 3,777
	add 3,2
	move 1,12
	andi 1,3
	move 4,11
	add 4,[POINT 9,uqa,8]
	jumpe 1,%L390
%L389:
	ibp 4
	sojn 1,%L389	; decrement_and_branch_until_zero
%L390:
	ldb 4,4
	add 3,4
	move 1,3
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

	.globl	use_qimem_extract
use_qimem_extract:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	move 13,2
	move 11,2
	andi 11,7
	movei 1,3
	move 2,12
	pushj 17,store_char_index
	move 1,[POINT 9,qp,8]
	move 2,12
	pushj 17,store_struct_qi
	move 1,[POINT 9,qpk,8]
	move 2,12
	pushj 17,store_packed_qi
	move 1,11
	pushj 17,load_char_index
	move 10,1
	move 1,11
	pushj 17,load_schar_index
	add 10,1
	move 1,11
	pushj 17,load_uchar_index
	add 10,1
	move 1,11
	pushj 17,load_qint_index
	add 10,1
	move 1,11
	pushj 17,load_sqint_index
	add 10,1
	move 1,11
	pushj 17,load_uqint_index
	add 10,1
	move 1,[POINT 9,ca,8]
	move 2,11
	pushj 17,load_char_ptr
	add 10,1
	move 1,[POINT 9,sca,8]
	move 2,11
	pushj 17,load_schar_ptr
	add 10,1
	move 1,[POINT 9,uca,8]
	move 2,11
	pushj 17,load_uchar_ptr
	add 10,1
	move 1,[POINT 9,qa,8]
	move 2,11
	pushj 17,load_qint_ptr
	add 10,1
	move 1,[POINT 9,uqa,8]
	move 2,11
	pushj 17,load_uqint_ptr
	add 10,1
	pushj 17,load_const_boundaries
	add 10,1
	move 1,11
	pushj 17,load_initialized_qi
	add 10,1
	move 1,11
	move 2,12
	pushj 17,store_char_index
	add 10,1
	move 1,[POINT 9,ca,8]
	move 2,11
	move 3,12
	pushj 17,store_char_ptr
	add 10,1
	move 1,[POINT 9,uca,8]
	move 2,11
	move 3,12
	pushj 17,store_uchar_ptr
	add 10,1
	move 1,[POINT 9,qa,8]
	move 2,11
	move 3,12
	pushj 17,store_qint_ptr
	add 10,1
	move 1,[POINT 9,uqa,8]
	move 2,11
	move 3,12
	pushj 17,store_uqint_ptr
	add 10,1
	move 1,11
	move 2,12
	pushj 17,post_store_result
	add 10,1
	move 1,[POINT 9,ca,8]
	move 2,[POINT 9,ca_init,8]
	movei 3,11
	pushj 17,copy_char_ptr
	add 10,1
	move 1,[POINT 9,uca,8]
	move 2,[POINT 9,uca_init,8]
	movei 3,11
	pushj 17,copy_uchar_ptr
	add 10,1
	move 1,[POINT 9,qa,8]
	move 2,[POINT 9,qa_init,8]
	movei 3,11
	pushj 17,copy_qint_ptr
	add 10,1
	move 1,[POINT 9,uqa,8]
	move 2,[POINT 9,uqa_init,8]
	movei 3,11
	pushj 17,copy_uqint_ptr
	add 10,1
	move 1,[POINT 9,ca,8]
	movei 2,11
	pushj 17,walk_char_ptr
	add 10,1
	move 1,[POINT 9,uca,8]
	movei 2,11
	pushj 17,walk_uchar_ptr
	add 10,1
	move 1,[POINT 9,qa,8]
	movei 2,11
	pushj 17,walk_qint_ptr
	add 10,1
	move 1,[POINT 9,ca,8]
	pushj 17,preinc_char_ptr
	add 10,1
	move 1,[POINT 9,ca,8]
	pushj 17,postinc_char_ptr
	add 10,1
	move 1,[POINT 9,qp,8]
	pushj 17,load_struct_qi
	add 10,1
	andi 13,3
	move 1,13
	move 2,12
	pushj 17,store_struct_array_qi
	add 10,1
	move 1,[POINT 9,qpk,8]
	pushj 17,load_packed_qi
	add 10,1
	move 1,12
	pushj 17,use_union_qi
	add 10,1
	move 1,11
	move 2,12
	pushj 17,store_volatile_qi
	add 10,1
	move 1,12
	pushj 17,stack_qi
	add 10,1
	move 1,11
	move 2,12
	pushj 17,pointer_roundtrip_qi
	add 10,1
	move 1,11
	move 2,12
	pushj 17,reload_global_ptrs
	add 10,1
	move 1,11
	move 2,12
	pushj 17,compare_qi_values
	add 10,1
	move 1,12
	pushj 17,scalar_globals_qi
	add 10,1
	move 1,11
	pushj 17,call_qi_values
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

	.bss
ca:
	.space	20
sca:
	.space	20
uca:
	.space	20
qa:
	.space	20
sqa:
	.space	20
uqa:
	.space	20
gc:
	.space	4
gsc:
	.space	4
guc:
	.space	4
gq:
	.space	4
gsq:
	.space	4
guq:
	.space	4
vc:
	.space	4
vsc:
	.space	4
vuc:
	.space	4
vq:
	.space	4
vsq:
	.space	4
vuq:
	.space	4
vca:
	.space	12
vuca:
	.space	12
vqa:
	.space	12
vuqa:
	.space	12
qp:
	.space	8
qpa:
	.space	40
qpk:
	.space	4
qu:
	.space	4
