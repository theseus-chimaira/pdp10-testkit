	.data
	.align	2
gw:
	.word	1002000003
	.space	2
	.word	4000000
	.long	5
	.long	6
	.long	0
	.long	7
	.long	0
	.long	8
	.long	9
	.long	10

convertQintHint:
	jumpe 1,%L2
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L2:
	move 1,4
	popj 17,

convertQintSint:
	hrrz 1,1
	popj 17,

convertHintQint:
	jumpe 1,%L6
	move 4,1
	tlc 4,113300
%L6:
	move 1,4
	popj 17,

convertHintSint:
	hrrz 1,1
	popj 17,

convertSintQint:
	jumpe 1,%L10
	move 4,1
	tlo 4,331100
%L10:
	move 1,4
	popj 17,

convertSintHint:
	jumpe 1,%L12
	move 4,1
	tlo 4,222200
%L12:
	move 1,4
	popj 17,

convert_q_h:
	jumpe 1,%L14
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L14:
	move 1,4
	popj 17,

round_q_h:
	jumpe 1,%L17
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L17:
	jumpe 4,%L16
	move 3,4
	tlc 3,113300
%L16:
	move 1,3
	popj 17,

add_q_h:
	jumpe 1,%L19
	move 3,1
	tlc 3,3300
	tlz 3,110000
%L19:
	move 4,2
	andi 4,1
	move 1,2
	ash 1,-1	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L22
%L21:
	ibp 1
	sojn 4,%L21	; decrement_and_branch_until_zero
%L22:
	popj 17,

diff_q_h:
	jumpe 1,%L25
	move 6,1
	tlc 6,3300
	tlz 6,110000
%L25:
	jumpe 2,%L27
	move 3,2
	tlc 3,3300
	tlz 3,110000
%L27:
	move 4,6
	sub 4,3
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	ash 1,-1
	popj 17,

load_q_h:
	jumpe 1,%L29
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L29:
	ldb 1,4
	hrre 1,1
	popj 17,

store_q_h:
	hrrzi 2,(2)	; zero_extendhisi2
	jumpe 1,%L31
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L31:
	dpb 2,4	; movhi
	popj 17,

convert_q_s:
	hrrz 1,1
	popj 17,

round_q_s:
	hrrz 1,1
	jumpe 1,%L35
	move 4,1
	tlo 4,331100
%L35:
	move 1,4
	popj 17,

add_q_s:
	addi 2,(1)
	move 1,2
	popj 17,

diff_q_s:
	hrrz 1,1
	move 4,1
	subi 4,(2)
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	ash 1,-2
	popj 17,

load_q_s:
	hrrz 1,1
	move 1,(1)
	popj 17,

store_q_s:
	hrrz 1,1
	movem 2,(1)
	popj 17,

convert_q_w:
	hrrz 1,1
	popj 17,

round_q_w:
	hrrz 1,1
	jumpe 1,%L52
	move 4,1
	tlo 4,331100
%L52:
	move 1,4
	popj 17,

add_q_w:
	addi 2,(1)
	move 1,2
	popj 17,

diff_q_w:
	hrrz 1,1
	move 4,1
	subi 4,(2)
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	ash 1,-2
	popj 17,

load_q_w:
	hrrz 1,1
	move 1,(1)
	popj 17,

store_q_w:
	hrrz 1,1
	movem 2,(1)
	popj 17,

convert_uq_uh:
	jumpe 1,%L67
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L67:
	move 1,4
	popj 17,

round_uq_uh:
	jumpe 1,%L70
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L70:
	jumpe 4,%L69
	move 3,4
	tlc 3,113300
%L69:
	move 1,3
	popj 17,

add_uq_uh:
	jumpe 1,%L72
	move 3,1
	tlc 3,3300
	tlz 3,110000
%L72:
	move 4,2
	andi 4,1
	move 1,2
	ash 1,-1	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L75
%L74:
	ibp 1
	sojn 4,%L74	; decrement_and_branch_until_zero
%L75:
	popj 17,

diff_uq_uh:
	jumpe 1,%L78
	move 6,1
	tlc 6,3300
	tlz 6,110000
%L78:
	jumpe 2,%L80
	move 3,2
	tlc 3,3300
	tlz 3,110000
%L80:
	move 4,6
	sub 4,3
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	ash 1,-1
	popj 17,

load_uq_uh:
	jumpe 1,%L82
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L82:
	ldb 1,4
	popj 17,

store_uq_uh:
	hrrzi 2,(2)	; zero_extendhisi2
	jumpe 1,%L84
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L84:
	dpb 2,4	; movhi
	popj 17,

convert_uq_us:
	hrrz 1,1
	popj 17,

round_uq_us:
	hrrz 1,1
	jumpe 1,%L88
	move 4,1
	tlo 4,331100
%L88:
	move 1,4
	popj 17,

add_uq_us:
	addi 2,(1)
	move 1,2
	popj 17,

diff_uq_us:
	hrrz 1,1
	move 4,1
	subi 4,(2)
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	ash 1,-2
	popj 17,

load_uq_us:
	hrrz 1,1
	move 1,(1)
	popj 17,

store_uq_us:
	hrrz 1,1
	movem 2,(1)
	popj 17,

convert_h_q:
	jumpe 1,%L103
	move 4,1
	tlc 4,113300
%L103:
	move 1,4
	popj 17,

round_h_q:
	jumpe 1,%L106
	move 3,1
	tlc 3,113300
%L106:
	jumpe 3,%L105
	move 4,3
	tlc 4,3300
	tlz 4,110000
%L105:
	move 1,4
	popj 17,

add_h_q:
	jumpe 1,%L108
	move 3,1
	tlc 3,113300
%L108:
	move 4,2
	andi 4,3
	move 1,2
	ash 1,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L111
%L110:
	ibp 1
	sojn 4,%L110	; decrement_and_branch_until_zero
%L111:
	popj 17,

diff_h_q:
	jumpe 1,%L114
	move 6,1
	tlc 6,113300
%L114:
	jumpe 2,%L116
	move 3,2
	tlc 3,113300
%L116:
	move 4,6
	sub 4,3
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	ash 1,1	; ashlsi3_pointer
	popj 17,

load_h_q:
	jumpe 1,%L118
	move 4,1
	tlc 4,113300
%L118:
	ldb 1,4
	trne 1,400
	orcmi 1,777
	popj 17,

store_h_q:
	andi 2,777	; zero_extendqisi2
	jumpe 1,%L120
	move 4,1
	tlc 4,113300
%L120:
	dpb 2,4
	popj 17,

convert_h_s:
	hrrz 1,1
	popj 17,

round_h_s:
	hrrz 1,1
	jumpe 1,%L124
	move 4,1
	tlo 4,222200
%L124:
	move 1,4
	popj 17,

add_h_s:
	addi 2,(1)
	move 1,2
	popj 17,

diff_h_s:
	hrrz 1,1
	move 4,1
	subi 4,(2)
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	ash 1,-1
	popj 17,

load_h_s:
	hrrz 1,1
	move 1,(1)
	popj 17,

store_h_s:
	hrrz 1,1
	movem 2,(1)
	popj 17,

convert_h_w:
	hrrz 1,1
	popj 17,

round_h_w:
	hrrz 1,1
	jumpe 1,%L141
	move 4,1
	tlo 4,222200
%L141:
	move 1,4
	popj 17,

add_h_w:
	addi 2,(1)
	move 1,2
	popj 17,

diff_h_w:
	hrrz 1,1
	move 4,1
	subi 4,(2)
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	ash 1,-1
	popj 17,

load_h_w:
	hrrz 1,1
	move 1,(1)
	popj 17,

store_h_w:
	hrrz 1,1
	movem 2,(1)
	popj 17,

convert_uh_uq:
	jumpe 1,%L156
	move 4,1
	tlc 4,113300
%L156:
	move 1,4
	popj 17,

round_uh_uq:
	jumpe 1,%L159
	move 3,1
	tlc 3,113300
%L159:
	jumpe 3,%L158
	move 4,3
	tlc 4,3300
	tlz 4,110000
%L158:
	move 1,4
	popj 17,

add_uh_uq:
	jumpe 1,%L161
	move 3,1
	tlc 3,113300
%L161:
	move 4,2
	andi 4,3
	move 1,2
	ash 1,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L164
%L163:
	ibp 1
	sojn 4,%L163	; decrement_and_branch_until_zero
%L164:
	popj 17,

diff_uh_uq:
	jumpe 1,%L167
	move 6,1
	tlc 6,113300
%L167:
	jumpe 2,%L169
	move 3,2
	tlc 3,113300
%L169:
	move 4,6
	sub 4,3
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	ash 1,1	; ashlsi3_pointer
	popj 17,

load_uh_uq:
	jumpe 1,%L171
	move 4,1
	tlc 4,113300
%L171:
	ldb 1,4
	popj 17,

store_uh_uq:
	andi 2,777	; zero_extendqisi2
	jumpe 1,%L173
	move 4,1
	tlc 4,113300
%L173:
	dpb 2,4
	popj 17,

convert_uh_us:
	hrrz 1,1
	popj 17,

round_uh_us:
	hrrz 1,1
	jumpe 1,%L177
	move 4,1
	tlo 4,222200
%L177:
	move 1,4
	popj 17,

add_uh_us:
	addi 2,(1)
	move 1,2
	popj 17,

diff_uh_us:
	hrrz 1,1
	move 4,1
	subi 4,(2)
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	ash 1,-1
	popj 17,

load_uh_us:
	hrrz 1,1
	move 1,(1)
	popj 17,

store_uh_us:
	hrrz 1,1
	movem 2,(1)
	popj 17,

convert_s_q:
	jumpe 1,%L192
	move 4,1
	tlo 4,331100
%L192:
	move 1,4
	popj 17,

round_s_q:
	popj 17,

add_s_q:
	jumpe 1,%L196
	move 3,1
	tlo 3,331100
%L196:
	move 4,2
	andi 4,3
	move 1,2
	ash 1,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L199
%L198:
	ibp 1
	sojn 4,%L198	; decrement_and_branch_until_zero
%L199:
	popj 17,

diff_s_q:
	jumpe 1,%L202
	move 4,1
	tlo 4,331100
%L202:
	jumpe 2,%L204
	move 3,2
	tlo 3,331100
%L204:
	sub 4,3
	ash 4,2	; ashlsi3_pointer
	move 1,4
	popj 17,

load_s_q:
	jumpe 1,%L206
	move 4,1
	tlo 4,331100
%L206:
	ldb 1,4
	trne 1,400
	orcmi 1,777
	popj 17,

store_s_q:
	andi 2,777	; zero_extendqisi2
	jumpe 1,%L208
	move 4,1
	tlo 4,331100
%L208:
	dpb 2,4
	popj 17,

convert_s_h:
	jumpe 1,%L210
	move 4,1
	tlo 4,222200
%L210:
	move 1,4
	popj 17,

round_s_h:
	popj 17,

add_s_h:
	jumpe 1,%L214
	move 3,1
	tlo 3,222200
%L214:
	move 4,2
	andi 4,1
	move 1,2
	ash 1,-1	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L217
%L216:
	ibp 1
	sojn 4,%L216	; decrement_and_branch_until_zero
%L217:
	popj 17,

diff_s_h:
	jumpe 1,%L220
	move 4,1
	tlo 4,222200
%L220:
	jumpe 2,%L222
	move 3,2
	tlo 3,222200
%L222:
	sub 4,3
	ash 4,1
	move 1,4
	popj 17,

load_s_h:
	jumpe 1,%L224
	move 4,1
	tlo 4,222200
%L224:
	ldb 1,4
	hrre 1,1
	popj 17,

store_s_h:
	hrrzi 2,(2)	; zero_extendhisi2
	jumpe 1,%L226
	move 4,1
	tlo 4,222200
%L226:
	dpb 2,4	; movhi
	popj 17,

convert_s_d:
	popj 17,

round_s_d:
	popj 17,

add_s_d:
	lsh 2,1
	add 1,2
	popj 17,

diff_s_d:
	sub 1,2
	ash 1,-1
	popj 17,

load_s_d:
	move 4,(1)
	move 5,1(1)
	move 1,4
	move 2,5
	popj 17,

store_s_d:
	movem 2,(1)
	movem 3,1(1)
	popj 17,

convert_us_uq:
	jumpe 1,%L245
	move 4,1
	tlo 4,331100
%L245:
	move 1,4
	popj 17,

round_us_uq:
	popj 17,

add_us_uq:
	jumpe 1,%L249
	move 3,1
	tlo 3,331100
%L249:
	move 4,2
	andi 4,3
	move 1,2
	ash 1,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L252
%L251:
	ibp 1
	sojn 4,%L251	; decrement_and_branch_until_zero
%L252:
	popj 17,

diff_us_uq:
	jumpe 1,%L255
	move 4,1
	tlo 4,331100
%L255:
	jumpe 2,%L257
	move 3,2
	tlo 3,331100
%L257:
	sub 4,3
	ash 4,2	; ashlsi3_pointer
	move 1,4
	popj 17,

load_us_uq:
	jumpe 1,%L259
	move 4,1
	tlo 4,331100
%L259:
	ldb 1,4
	popj 17,

store_us_uq:
	andi 2,777	; zero_extendqisi2
	jumpe 1,%L261
	move 4,1
	tlo 4,331100
%L261:
	dpb 2,4
	popj 17,

convert_us_uh:
	jumpe 1,%L263
	move 4,1
	tlo 4,222200
%L263:
	move 1,4
	popj 17,

round_us_uh:
	popj 17,

add_us_uh:
	jumpe 1,%L267
	move 3,1
	tlo 3,222200
%L267:
	move 4,2
	andi 4,1
	move 1,2
	ash 1,-1	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L270
%L269:
	ibp 1
	sojn 4,%L269	; decrement_and_branch_until_zero
%L270:
	popj 17,

diff_us_uh:
	jumpe 1,%L273
	move 4,1
	tlo 4,222200
%L273:
	jumpe 2,%L275
	move 3,2
	tlo 3,222200
%L275:
	sub 4,3
	ash 4,1
	move 1,4
	popj 17,

load_us_uh:
	jumpe 1,%L277
	move 4,1
	tlo 4,222200
%L277:
	ldb 1,4
	popj 17,

store_us_uh:
	hrrzi 2,(2)	; zero_extendhisi2
	jumpe 1,%L279
	move 4,1
	tlo 4,222200
%L279:
	dpb 2,4	; movhi
	popj 17,

convert_d_s:
	popj 17,

round_d_s:
	popj 17,

add_d_s:
	add 1,2
	popj 17,

diff_d_s:
	sub 1,2
	popj 17,

load_d_s:
	move 1,(1)
	popj 17,

store_d_s:
	movem 2,(1)
	popj 17,

convert_ud_us:
	popj 17,

round_ud_us:
	popj 17,

add_ud_us:
	add 1,2
	popj 17,

diff_ud_us:
	sub 1,2
	popj 17,

load_ud_us:
	move 1,(1)
	popj 17,

store_ud_us:
	movem 2,(1)
	popj 17,

convert_char_uchar:
	popj 17,

round_char_uchar:
	popj 17,

add_char_uchar:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L323
%L322:
	ibp 1
	sojn 4,%L322	; decrement_and_branch_until_zero
%L323:
	popj 17,

diff_char_uchar:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

load_char_uchar:
	ldb 1,1
	popj 17,

store_char_uchar:
	dpb 2,1
	popj 17,

convert_uchar_char:
	popj 17,

round_uchar_char:
	popj 17,

add_uchar_char:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L342
%L341:
	ibp 1
	sojn 4,%L341	; decrement_and_branch_until_zero
%L342:
	popj 17,

diff_uchar_char:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

load_uchar_char:
	ldb 1,1
	popj 17,

store_uchar_char:
	dpb 2,1
	popj 17,

convert_char_schar:
	popj 17,

round_char_schar:
	popj 17,

add_char_schar:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L361
%L360:
	ibp 1
	sojn 4,%L360	; decrement_and_branch_until_zero
%L361:
	popj 17,

diff_char_schar:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

load_char_schar:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

store_char_schar:
	dpb 2,1
	popj 17,

convert_char_char9:
	popj 17,

round_char_char9:
	popj 17,

add_char_char9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L380
%L379:
	ibp 1
	sojn 4,%L379	; decrement_and_branch_until_zero
%L380:
	popj 17,

diff_char_char9:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

load_char_char9:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

store_char_char9:
	dpb 2,1
	popj 17,

convert_char9_char:
	popj 17,

round_char9_char:
	popj 17,

add_char9_char:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L399
%L398:
	ibp 1
	sojn 4,%L398	; decrement_and_branch_until_zero
%L399:
	popj 17,

diff_char9_char:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

load_char9_char:
	ldb 1,1
	popj 17,

store_char9_char:
	dpb 2,1
	popj 17,

convert_uchar_uchar9:
	popj 17,

round_uchar_uchar9:
	popj 17,

add_uchar_uchar9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L418
%L417:
	ibp 1
	sojn 4,%L417	; decrement_and_branch_until_zero
%L418:
	popj 17,

diff_uchar_uchar9:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

load_uchar_uchar9:
	ldb 1,1
	popj 17,

store_uchar_uchar9:
	dpb 2,1
	popj 17,

convert_uchar9_uchar:
	popj 17,

round_uchar9_uchar:
	popj 17,

add_uchar9_uchar:
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

diff_uchar9_uchar:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

load_uchar9_uchar:
	ldb 1,1
	popj 17,

store_uchar9_uchar:
	dpb 2,1
	popj 17,

convert_char6_char7:
	popj 17,

round_char6_char7:
	popj 17,

add_char6_char7:
	jumple 2,%L456
%L455:
	ibp 1
	sojg 2,%L455	; decrement_and_branch_until_zero
%L456:
	jumpe 2,%L458
%L457:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L457
%L458:
	popj 17,

diff_char6_char7:
	move 4,1
	sub 4,2
	muli 4,14
	move 1,5
	ash 1,-1
	add 1,%BADL6(4)
	popj 17,

load_char6_char7:
	ldb 1,1
	trne 1,100
	orcmi 1,177
	popj 17,

store_char6_char7:
	lsh 2,35
	ash 2,-35
	dpb 2,1
	popj 17,

convert_char6_char8:
	popj 17,

round_char6_char8:
	popj 17,

add_char6_char8:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L477
%L476:
	ibp 1
	sojn 4,%L476	; decrement_and_branch_until_zero
%L477:
	popj 17,

diff_char6_char8:
	move 4,1
	sub 4,2
	muli 4,14
	move 1,5
	ash 1,-1
	add 1,%BADL6(4)
	popj 17,

load_char6_char8:
	ldb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

store_char6_char8:
	lsh 2,34
	ash 2,-34
	dpb 2,1
	popj 17,

convert_char6_char9:
	popj 17,

round_char6_char9:
	popj 17,

add_char6_char9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L496
%L495:
	ibp 1
	sojn 4,%L495	; decrement_and_branch_until_zero
%L496:
	popj 17,

diff_char6_char9:
	move 4,1
	sub 4,2
	muli 4,14
	move 1,5
	ash 1,-1
	add 1,%BADL6(4)
	popj 17,

load_char6_char9:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

store_char6_char9:
	dpb 2,1
	popj 17,

convert_char6_short18:
	jumpe 1,%L507
	move 4,1
	add 4,[-136400000000]
%L507:
	move 1,4
	popj 17,

round_char6_short18:
	jumpe 1,%L510
	move 4,1
	add 4,[-136400000000]
%L510:
	jumpe 4,%L509
	move 3,4
	add 3,[136400000000]
%L509:
	move 1,3
	popj 17,

add_char6_short18:
	jumpe 1,%L512
	move 3,1
	add 3,[-136400000000]
%L512:
	move 4,2
	andi 4,1
	move 1,2
	ash 1,-1	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L515
%L514:
	ibp 1
	sojn 4,%L514	; decrement_and_branch_until_zero
%L515:
	popj 17,

diff_char6_short18:
	jumpe 1,%L518
	move 6,1
	add 6,[-136400000000]
%L518:
	jumpe 2,%L520
	move 3,2
	add 3,[-136400000000]
%L520:
	move 4,6
	sub 4,3
	muli 4,14
	move 1,5
	ash 1,-1
	add 1,%BADL6(4)
	ash 1,-1
	popj 17,

load_char6_short18:
	jumpe 1,%L522
	move 4,1
	add 4,[-136400000000]
%L522:
	ldb 1,4
	hrre 1,1
	popj 17,

store_char6_short18:
	hrrzi 2,(2)	; zero_extendhisi2
	jumpe 1,%L524
	move 4,1
	add 4,[-136400000000]
%L524:
	dpb 2,4	; movhi
	popj 17,

convert_char6_int36:
	hrrz 1,1
	popj 17,

round_char6_int36:
	hrrz 1,1
	jumpe 1,%L528
	move 4,1
	tlo 4,360600
%L528:
	move 1,4
	popj 17,

add_char6_int36:
	addi 2,(1)
	move 1,2
	popj 17,

diff_char6_int36:
	hrrz 1,1
	move 4,1
	subi 4,(2)
	muli 4,14
	move 1,5
	ash 1,-1
	add 1,%BADL6(4)
	ash 1,-2
	popj 17,

load_char6_int36:
	hrrz 1,1
	move 1,(1)
	popj 17,

store_char6_int36:
	hrrz 1,1
	movem 2,(1)
	popj 17,

convert_char7_char6:
	popj 17,

round_char7_char6:
	popj 17,

add_char7_char6:
	jumple 2,%L551
%L550:
	ibp 1
	sojg 2,%L550	; decrement_and_branch_until_zero
%L551:
	jumpe 2,%L553
%L552:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L552
%L553:
	popj 17,

diff_char7_char6:
	move 4,1
	sub 4,2
	muli 4,12
	move 1,5
	ash 1,-1
	add 1,%BADL7(4)
	popj 17,

load_char7_char6:
	ldb 1,1
	trne 1,40
	orcmi 1,77
	popj 17,

store_char7_char6:
	lsh 2,36
	ash 2,-36
	dpb 2,1
	popj 17,

convert_char7_char8:
	popj 17,

round_char7_char8:
	popj 17,

add_char7_char8:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L572
%L571:
	ibp 1
	sojn 4,%L571	; decrement_and_branch_until_zero
%L572:
	popj 17,

diff_char7_char8:
	move 4,1
	sub 4,2
	muli 4,12
	move 1,5
	ash 1,-1
	add 1,%BADL7(4)
	popj 17,

load_char7_char8:
	ldb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

store_char7_char8:
	lsh 2,34
	ash 2,-34
	dpb 2,1
	popj 17,

convert_char7_char9:
	popj 17,

round_char7_char9:
	popj 17,

add_char7_char9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L591
%L590:
	ibp 1
	sojn 4,%L590	; decrement_and_branch_until_zero
%L591:
	popj 17,

diff_char7_char9:
	move 4,1
	sub 4,2
	muli 4,12
	move 1,5
	ash 1,-1
	add 1,%BADL7(4)
	popj 17,

load_char7_char9:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

store_char7_char9:
	dpb 2,1
	popj 17,

convert_char7_short18:
	jumpe 1,%L602
	move 4,1
	add 4,[-126500000000]
%L602:
	move 1,4
	popj 17,

round_char7_short18:
	jumpe 1,%L605
	move 4,1
	add 4,[-126500000000]
%L605:
	jumpe 4,%L604
	move 3,4
	add 3,[126500000000]
%L604:
	move 1,3
	popj 17,

add_char7_short18:
	jumpe 1,%L607
	move 3,1
	add 3,[-126500000000]
%L607:
	move 4,2
	andi 4,1
	move 1,2
	ash 1,-1	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L610
%L609:
	ibp 1
	sojn 4,%L609	; decrement_and_branch_until_zero
%L610:
	popj 17,

diff_char7_short18:
	jumpe 1,%L613
	move 6,1
	add 6,[-126500000000]
%L613:
	jumpe 2,%L615
	move 3,2
	add 3,[-126500000000]
%L615:
	move 4,6
	sub 4,3
	muli 4,12
	move 1,5
	ash 1,-1
	add 1,%BADL7(4)
	ash 1,-1
	popj 17,

load_char7_short18:
	jumpe 1,%L617
	move 4,1
	add 4,[-126500000000]
%L617:
	ldb 1,4
	hrre 1,1
	popj 17,

store_char7_short18:
	hrrzi 2,(2)	; zero_extendhisi2
	jumpe 1,%L619
	move 4,1
	add 4,[-126500000000]
%L619:
	dpb 2,4	; movhi
	popj 17,

convert_char7_int36:
	hrrz 1,1
	popj 17,

round_char7_int36:
	hrrz 1,1
	jumpe 1,%L623
	move 4,1
	tlo 4,350700
%L623:
	move 1,4
	popj 17,

add_char7_int36:
	addi 2,(1)
	move 1,2
	popj 17,

diff_char7_int36:
	hrrz 1,1
	move 4,1
	subi 4,(2)
	muli 4,12
	move 1,5
	ash 1,-1
	add 1,%BADL7(4)
	ash 1,-2
	popj 17,

load_char7_int36:
	hrrz 1,1
	move 1,(1)
	popj 17,

store_char7_int36:
	hrrz 1,1
	movem 2,(1)
	popj 17,

convert_char8_char6:
	popj 17,

round_char8_char6:
	popj 17,

add_char8_char6:
	jumple 2,%L646
%L645:
	ibp 1
	sojg 2,%L645	; decrement_and_branch_until_zero
%L646:
	jumpe 2,%L648
%L647:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L647
%L648:
	popj 17,

diff_char8_char6:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL8(4)
	popj 17,

load_char8_char6:
	ldb 1,1
	trne 1,40
	orcmi 1,77
	popj 17,

store_char8_char6:
	lsh 2,36
	ash 2,-36
	dpb 2,1
	popj 17,

convert_char8_char7:
	popj 17,

round_char8_char7:
	popj 17,

add_char8_char7:
	jumple 2,%L667
%L666:
	ibp 1
	sojg 2,%L666	; decrement_and_branch_until_zero
%L667:
	jumpe 2,%L669
%L668:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L668
%L669:
	popj 17,

diff_char8_char7:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL8(4)
	popj 17,

load_char8_char7:
	ldb 1,1
	trne 1,100
	orcmi 1,177
	popj 17,

store_char8_char7:
	lsh 2,35
	ash 2,-35
	dpb 2,1
	popj 17,

convert_char8_char9:
	popj 17,

round_char8_char9:
	popj 17,

add_char8_char9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L688
%L687:
	ibp 1
	sojn 4,%L687	; decrement_and_branch_until_zero
%L688:
	popj 17,

diff_char8_char9:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL8(4)
	popj 17,

load_char8_char9:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

store_char8_char9:
	dpb 2,1
	popj 17,

convert_char8_short18:
	jumpe 1,%L699
	move 4,1
	tlz 4,141000
	tlo 4,2200
	tlne 4,200000
	tlo 4,20000
%L699:
	move 1,4
	popj 17,

round_char8_short18:
	jumpe 1,%L703
	move 4,1
	tlz 4,141000
	tlo 4,2200
	tlne 4,200000
	tlo 4,20000
%L703:
	jumpe 4,%L702
	move 3,4
	tlo 3,141000
	tlz 3,22200
%L702:
	move 1,3
	popj 17,

add_char8_short18:
	jumpe 1,%L706
	move 3,1
	tlz 3,141000
	tlo 3,2200
	tlne 3,200000
	tlo 3,20000
%L706:
	move 4,2
	andi 4,1
	move 1,2
	ash 1,-1	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L710
%L709:
	ibp 1
	sojn 4,%L709	; decrement_and_branch_until_zero
%L710:
	popj 17,

diff_char8_short18:
	jumpe 1,%L713
	move 6,1
	tlz 6,141000
	tlo 6,2200
	tlne 6,200000
	tlo 6,20000
%L713:
	jumpe 2,%L716
	move 3,2
	tlz 3,141000
	tlo 3,2200
	tlne 3,200000
	tlo 3,20000
%L716:
	move 4,6
	sub 4,3
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL8(4)
	ash 1,-1
	popj 17,

load_char8_short18:
	jumpe 1,%L719
	move 4,1
	tlz 4,141000
	tlo 4,2200
	tlne 4,200000
	tlo 4,20000
%L719:
	ldb 1,4
	hrre 1,1
	popj 17,

store_char8_short18:
	hrrzi 2,(2)	; zero_extendhisi2
	jumpe 1,%L722
	move 4,1
	tlz 4,141000
	tlo 4,2200
	tlne 4,200000
	tlo 4,20000
%L722:
	dpb 2,4	; movhi
	popj 17,

convert_char8_int36:
	hrrz 1,1
	popj 17,

round_char8_int36:
	hrrz 1,1
	jumpe 1,%L727
	move 4,1
	tlo 4,341000
%L727:
	move 1,4
	popj 17,

add_char8_int36:
	addi 2,(1)
	move 1,2
	popj 17,

diff_char8_int36:
	hrrz 1,1
	move 4,1
	subi 4,(2)
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL8(4)
	ash 1,-2
	popj 17,

load_char8_int36:
	hrrz 1,1
	move 1,(1)
	popj 17,

store_char8_int36:
	hrrz 1,1
	movem 2,(1)
	popj 17,

convert_char9_char6:
	popj 17,

round_char9_char6:
	popj 17,

add_char9_char6:
	jumple 2,%L750
%L749:
	ibp 1
	sojg 2,%L749	; decrement_and_branch_until_zero
%L750:
	jumpe 2,%L752
%L751:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L751
%L752:
	popj 17,

diff_char9_char6:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

load_char9_char6:
	ldb 1,1
	trne 1,40
	orcmi 1,77
	popj 17,

store_char9_char6:
	lsh 2,36
	ash 2,-36
	dpb 2,1
	popj 17,

convert_char9_char7:
	popj 17,

round_char9_char7:
	popj 17,

add_char9_char7:
	jumple 2,%L771
%L770:
	ibp 1
	sojg 2,%L770	; decrement_and_branch_until_zero
%L771:
	jumpe 2,%L773
%L772:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L772
%L773:
	popj 17,

diff_char9_char7:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

load_char9_char7:
	ldb 1,1
	trne 1,100
	orcmi 1,177
	popj 17,

store_char9_char7:
	lsh 2,35
	ash 2,-35
	dpb 2,1
	popj 17,

convert_char9_char8:
	popj 17,

round_char9_char8:
	popj 17,

add_char9_char8:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L792
%L791:
	ibp 1
	sojn 4,%L791	; decrement_and_branch_until_zero
%L792:
	popj 17,

diff_char9_char8:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

load_char9_char8:
	ldb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

store_char9_char8:
	lsh 2,34
	ash 2,-34
	dpb 2,1
	popj 17,

convert_char9_short18:
	jumpe 1,%L803
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L803:
	move 1,4
	popj 17,

round_char9_short18:
	jumpe 1,%L806
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L806:
	jumpe 4,%L805
	move 3,4
	tlc 3,113300
%L805:
	move 1,3
	popj 17,

add_char9_short18:
	jumpe 1,%L808
	move 3,1
	tlc 3,3300
	tlz 3,110000
%L808:
	move 4,2
	andi 4,1
	move 1,2
	ash 1,-1	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L811
%L810:
	ibp 1
	sojn 4,%L810	; decrement_and_branch_until_zero
%L811:
	popj 17,

diff_char9_short18:
	jumpe 1,%L814
	move 6,1
	tlc 6,3300
	tlz 6,110000
%L814:
	jumpe 2,%L816
	move 3,2
	tlc 3,3300
	tlz 3,110000
%L816:
	move 4,6
	sub 4,3
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	ash 1,-1
	popj 17,

load_char9_short18:
	jumpe 1,%L818
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L818:
	ldb 1,4
	hrre 1,1
	popj 17,

store_char9_short18:
	hrrzi 2,(2)	; zero_extendhisi2
	jumpe 1,%L820
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L820:
	dpb 2,4	; movhi
	popj 17,

convert_char9_int36:
	hrrz 1,1
	popj 17,

round_char9_int36:
	hrrz 1,1
	jumpe 1,%L824
	move 4,1
	tlo 4,331100
%L824:
	move 1,4
	popj 17,

add_char9_int36:
	addi 2,(1)
	move 1,2
	popj 17,

diff_char9_int36:
	hrrz 1,1
	move 4,1
	subi 4,(2)
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	ash 1,-2
	popj 17,

load_char9_int36:
	hrrz 1,1
	move 1,(1)
	popj 17,

store_char9_int36:
	hrrz 1,1
	movem 2,(1)
	popj 17,

convert_short18_char6:
	jumpe 1,%L839
	move 4,1
	add 4,[136400000000]
%L839:
	move 1,4
	popj 17,

round_short18_char6:
	jumpe 1,%L842
	move 4,1
	add 4,[136400000000]
%L842:
	jumpe 4,%L841
	move 3,4
	add 3,[-136400000000]
%L841:
	move 1,3
	popj 17,

add_short18_char6:
	jumpe 1,%L844
	move 4,1
	add 4,[136400000000]
%L844:
	move 1,4
	skipg 4,2
	jrst %L847
%L846:
	ibp 1
	sojg 4,%L846	; decrement_and_branch_until_zero
%L847:
	jumpe 4,%L849
%L848:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L848
%L849:
	popj 17,

diff_short18_char6:
	jumpe 1,%L852
	move 6,1
	add 6,[136400000000]
%L852:
	jumpe 2,%L854
	move 3,2
	add 3,[136400000000]
%L854:
	move 4,6
	sub 4,3
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	ash 1,1	; ashlsi3_pointer
	popj 17,

load_short18_char6:
	jumpe 1,%L856
	move 4,1
	add 4,[136400000000]
%L856:
	ldb 1,4
	trne 1,40
	orcmi 1,77
	popj 17,

store_short18_char6:
	lsh 2,36
	ash 2,-36
	jumpe 1,%L858
	move 4,1
	add 4,[136400000000]
%L858:
	dpb 2,4
	popj 17,

convert_short18_char7:
	jumpe 1,%L860
	move 4,1
	add 4,[126500000000]
%L860:
	move 1,4
	popj 17,

round_short18_char7:
	jumpe 1,%L863
	move 4,1
	add 4,[126500000000]
%L863:
	jumpe 4,%L862
	move 3,4
	add 3,[-126500000000]
%L862:
	move 1,3
	popj 17,

add_short18_char7:
	jumpe 1,%L865
	move 4,1
	add 4,[126500000000]
%L865:
	move 1,4
	skipg 4,2
	jrst %L868
%L867:
	ibp 1
	sojg 4,%L867	; decrement_and_branch_until_zero
%L868:
	jumpe 4,%L870
%L869:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L869
%L870:
	popj 17,

diff_short18_char7:
	jumpe 1,%L873
	move 6,1
	add 6,[126500000000]
%L873:
	jumpe 2,%L875
	move 3,2
	add 3,[126500000000]
%L875:
	move 4,6
	sub 4,3
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	ash 1,1	; ashlsi3_pointer
	popj 17,

load_short18_char7:
	jumpe 1,%L877
	move 4,1
	add 4,[126500000000]
%L877:
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

store_short18_char7:
	lsh 2,35
	ash 2,-35
	jumpe 1,%L879
	move 4,1
	add 4,[126500000000]
%L879:
	dpb 2,4
	popj 17,

convert_short18_char8:
	jumpe 1,%L881
	move 4,1
	tlo 4,141000
	tlz 4,22200
%L881:
	move 1,4
	popj 17,

round_short18_char8:
	jumpe 1,%L884
	move 4,1
	tlo 4,141000
	tlz 4,22200
%L884:
	jumpe 4,%L883
	move 3,4
	tlz 3,141000
	tlo 3,2200
	tlne 3,200000
	tlo 3,20000
%L883:
	move 1,3
	popj 17,

add_short18_char8:
	jumpe 1,%L887
	move 3,1
	tlo 3,141000
	tlz 3,22200
%L887:
	move 4,2
	andi 4,3
	move 1,2
	ash 1,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L890
%L889:
	ibp 1
	sojn 4,%L889	; decrement_and_branch_until_zero
%L890:
	popj 17,

diff_short18_char8:
	jumpe 1,%L893
	move 6,1
	tlo 6,141000
	tlz 6,22200
%L893:
	jumpe 2,%L895
	move 3,2
	tlo 3,141000
	tlz 3,22200
%L895:
	move 4,6
	sub 4,3
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	ash 1,1	; ashlsi3_pointer
	popj 17,

load_short18_char8:
	jumpe 1,%L897
	move 4,1
	tlo 4,141000
	tlz 4,22200
%L897:
	ldb 1,4
	trne 1,200
	orcmi 1,377
	popj 17,

store_short18_char8:
	lsh 2,34
	ash 2,-34
	jumpe 1,%L899
	move 4,1
	tlo 4,141000
	tlz 4,22200
%L899:
	dpb 2,4
	popj 17,

convert_short18_char9:
	jumpe 1,%L901
	move 4,1
	tlc 4,113300
%L901:
	move 1,4
	popj 17,

round_short18_char9:
	jumpe 1,%L904
	move 3,1
	tlc 3,113300
%L904:
	jumpe 3,%L903
	move 4,3
	tlc 4,3300
	tlz 4,110000
%L903:
	move 1,4
	popj 17,

add_short18_char9:
	jumpe 1,%L906
	move 3,1
	tlc 3,113300
%L906:
	move 4,2
	andi 4,3
	move 1,2
	ash 1,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L909
%L908:
	ibp 1
	sojn 4,%L908	; decrement_and_branch_until_zero
%L909:
	popj 17,

diff_short18_char9:
	jumpe 1,%L912
	move 6,1
	tlc 6,113300
%L912:
	jumpe 2,%L914
	move 3,2
	tlc 3,113300
%L914:
	move 4,6
	sub 4,3
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	ash 1,1	; ashlsi3_pointer
	popj 17,

load_short18_char9:
	jumpe 1,%L916
	move 4,1
	tlc 4,113300
%L916:
	ldb 1,4
	trne 1,400
	orcmi 1,777
	popj 17,

store_short18_char9:
	andi 2,777	; zero_extendqisi2
	jumpe 1,%L918
	move 4,1
	tlc 4,113300
%L918:
	dpb 2,4
	popj 17,

convert_short18_int36:
	hrrz 1,1
	popj 17,

round_short18_int36:
	hrrz 1,1
	jumpe 1,%L922
	move 4,1
	tlo 4,222200
%L922:
	move 1,4
	popj 17,

add_short18_int36:
	addi 2,(1)
	move 1,2
	popj 17,

diff_short18_int36:
	hrrz 1,1
	move 4,1
	subi 4,(2)
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	ash 1,-1
	popj 17,

load_short18_int36:
	hrrz 1,1
	move 1,(1)
	popj 17,

store_short18_int36:
	hrrz 1,1
	movem 2,(1)
	popj 17,

convert_int36_char6:
	jumpe 1,%L937
	move 4,1
	tlo 4,360600
%L937:
	move 1,4
	popj 17,

round_int36_char6:
	popj 17,

add_int36_char6:
	jumpe 1,%L941
	move 4,1
	tlo 4,360600
%L941:
	move 1,4
	skipg 4,2
	jrst %L944
%L943:
	ibp 1
	sojg 4,%L943	; decrement_and_branch_until_zero
%L944:
	jumpe 4,%L946
%L945:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L945
%L946:
	popj 17,

diff_int36_char6:
	jumpe 1,%L949
	move 4,1
	tlo 4,360600
%L949:
	jumpe 2,%L951
	move 3,2
	tlo 3,360600
%L951:
	sub 4,3
	ash 4,2	; ashlsi3_pointer
	move 1,4
	popj 17,

load_int36_char6:
	jumpe 1,%L953
	move 4,1
	tlo 4,360600
%L953:
	ldb 1,4
	trne 1,40
	orcmi 1,77
	popj 17,

store_int36_char6:
	lsh 2,36
	ash 2,-36
	jumpe 1,%L955
	move 4,1
	tlo 4,360600
%L955:
	dpb 2,4
	popj 17,

convert_int36_char7:
	jumpe 1,%L957
	move 4,1
	tlo 4,350700
%L957:
	move 1,4
	popj 17,

round_int36_char7:
	popj 17,

add_int36_char7:
	jumpe 1,%L961
	move 4,1
	tlo 4,350700
%L961:
	move 1,4
	skipg 4,2
	jrst %L964
%L963:
	ibp 1
	sojg 4,%L963	; decrement_and_branch_until_zero
%L964:
	jumpe 4,%L966
%L965:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L965
%L966:
	popj 17,

diff_int36_char7:
	jumpe 1,%L969
	move 4,1
	tlo 4,350700
%L969:
	jumpe 2,%L971
	move 3,2
	tlo 3,350700
%L971:
	sub 4,3
	ash 4,2	; ashlsi3_pointer
	move 1,4
	popj 17,

load_int36_char7:
	jumpe 1,%L973
	move 4,1
	tlo 4,350700
%L973:
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

store_int36_char7:
	lsh 2,35
	ash 2,-35
	jumpe 1,%L975
	move 4,1
	tlo 4,350700
%L975:
	dpb 2,4
	popj 17,

convert_int36_char8:
	jumpe 1,%L977
	move 4,1
	tlo 4,341000
%L977:
	move 1,4
	popj 17,

round_int36_char8:
	popj 17,

add_int36_char8:
	jumpe 1,%L981
	move 3,1
	tlo 3,341000
%L981:
	move 4,2
	andi 4,3
	move 1,2
	ash 1,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L984
%L983:
	ibp 1
	sojn 4,%L983	; decrement_and_branch_until_zero
%L984:
	popj 17,

diff_int36_char8:
	jumpe 1,%L987
	move 4,1
	tlo 4,341000
%L987:
	jumpe 2,%L989
	move 3,2
	tlo 3,341000
%L989:
	sub 4,3
	ash 4,2	; ashlsi3_pointer
	move 1,4
	popj 17,

load_int36_char8:
	jumpe 1,%L991
	move 4,1
	tlo 4,341000
%L991:
	ldb 1,4
	trne 1,200
	orcmi 1,377
	popj 17,

store_int36_char8:
	lsh 2,34
	ash 2,-34
	jumpe 1,%L993
	move 4,1
	tlo 4,341000
%L993:
	dpb 2,4
	popj 17,

convert_int36_char9:
	jumpe 1,%L995
	move 4,1
	tlo 4,331100
%L995:
	move 1,4
	popj 17,

round_int36_char9:
	popj 17,

add_int36_char9:
	jumpe 1,%L999
	move 3,1
	tlo 3,331100
%L999:
	move 4,2
	andi 4,3
	move 1,2
	ash 1,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L1002
%L1001:
	ibp 1
	sojn 4,%L1001	; decrement_and_branch_until_zero
%L1002:
	popj 17,

diff_int36_char9:
	jumpe 1,%L1005
	move 4,1
	tlo 4,331100
%L1005:
	jumpe 2,%L1007
	move 3,2
	tlo 3,331100
%L1007:
	sub 4,3
	ash 4,2	; ashlsi3_pointer
	move 1,4
	popj 17,

load_int36_char9:
	jumpe 1,%L1009
	move 4,1
	tlo 4,331100
%L1009:
	ldb 1,4
	trne 1,400
	orcmi 1,777
	popj 17,

store_int36_char9:
	andi 2,777	; zero_extendqisi2
	jumpe 1,%L1011
	move 4,1
	tlo 4,331100
%L1011:
	dpb 2,4
	popj 17,

convert_int36_short18:
	jumpe 1,%L1013
	move 4,1
	tlo 4,222200
%L1013:
	move 1,4
	popj 17,

round_int36_short18:
	popj 17,

add_int36_short18:
	jumpe 1,%L1017
	move 3,1
	tlo 3,222200
%L1017:
	move 4,2
	andi 4,1
	move 1,2
	ash 1,-1	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L1020
%L1019:
	ibp 1
	sojn 4,%L1019	; decrement_and_branch_until_zero
%L1020:
	popj 17,

diff_int36_short18:
	jumpe 1,%L1023
	move 4,1
	tlo 4,222200
%L1023:
	jumpe 2,%L1025
	move 3,2
	tlo 3,222200
%L1025:
	sub 4,3
	ash 4,1
	move 1,4
	popj 17,

load_int36_short18:
	jumpe 1,%L1027
	move 4,1
	tlo 4,222200
%L1027:
	ldb 1,4
	hrre 1,1
	popj 17,

store_int36_short18:
	hrrzi 2,(2)	; zero_extendhisi2
	jumpe 1,%L1029
	move 4,1
	tlo 4,222200
%L1029:
	dpb 2,4	; movhi
	popj 17,

convert_uchar6_uchar7:
	popj 17,

round_uchar6_uchar7:
	popj 17,

add_uchar6_uchar7:
	jumple 2,%L1039
%L1038:
	ibp 1
	sojg 2,%L1038	; decrement_and_branch_until_zero
%L1039:
	jumpe 2,%L1041
%L1040:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L1040
%L1041:
	popj 17,

diff_uchar6_uchar7:
	move 4,1
	sub 4,2
	muli 4,14
	move 1,5
	ash 1,-1
	add 1,%BADL6(4)
	popj 17,

load_uchar6_uchar7:
	ldb 1,1
	popj 17,

store_uchar6_uchar7:
	andi 2,177
	dpb 2,1
	popj 17,

convert_uchar6_uchar8:
	popj 17,

round_uchar6_uchar8:
	popj 17,

add_uchar6_uchar8:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1060
%L1059:
	ibp 1
	sojn 4,%L1059	; decrement_and_branch_until_zero
%L1060:
	popj 17,

diff_uchar6_uchar8:
	move 4,1
	sub 4,2
	muli 4,14
	move 1,5
	ash 1,-1
	add 1,%BADL6(4)
	popj 17,

load_uchar6_uchar8:
	ldb 1,1
	popj 17,

store_uchar6_uchar8:
	andi 2,377
	dpb 2,1
	popj 17,

convert_uchar6_uchar9:
	popj 17,

round_uchar6_uchar9:
	popj 17,

add_uchar6_uchar9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1079
%L1078:
	ibp 1
	sojn 4,%L1078	; decrement_and_branch_until_zero
%L1079:
	popj 17,

diff_uchar6_uchar9:
	move 4,1
	sub 4,2
	muli 4,14
	move 1,5
	ash 1,-1
	add 1,%BADL6(4)
	popj 17,

load_uchar6_uchar9:
	ldb 1,1
	popj 17,

store_uchar6_uchar9:
	dpb 2,1
	popj 17,

convert_uchar7_uchar6:
	popj 17,

round_uchar7_uchar6:
	popj 17,

add_uchar7_uchar6:
	jumple 2,%L1098
%L1097:
	ibp 1
	sojg 2,%L1097	; decrement_and_branch_until_zero
%L1098:
	jumpe 2,%L1100
%L1099:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L1099
%L1100:
	popj 17,

diff_uchar7_uchar6:
	move 4,1
	sub 4,2
	muli 4,12
	move 1,5
	ash 1,-1
	add 1,%BADL7(4)
	popj 17,

load_uchar7_uchar6:
	ldb 1,1
	popj 17,

store_uchar7_uchar6:
	andi 2,77
	dpb 2,1
	popj 17,

convert_uchar8_uchar6:
	popj 17,

round_uchar8_uchar6:
	popj 17,

add_uchar8_uchar6:
	jumple 2,%L1119
%L1118:
	ibp 1
	sojg 2,%L1118	; decrement_and_branch_until_zero
%L1119:
	jumpe 2,%L1121
%L1120:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L1120
%L1121:
	popj 17,

diff_uchar8_uchar6:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL8(4)
	popj 17,

load_uchar8_uchar6:
	ldb 1,1
	popj 17,

store_uchar8_uchar6:
	andi 2,77
	dpb 2,1
	popj 17,

convert_uchar8_uchar9:
	popj 17,

round_uchar8_uchar9:
	popj 17,

add_uchar8_uchar9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1140
%L1139:
	ibp 1
	sojn 4,%L1139	; decrement_and_branch_until_zero
%L1140:
	popj 17,

diff_uchar8_uchar9:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL8(4)
	popj 17,

load_uchar8_uchar9:
	ldb 1,1
	popj 17,

store_uchar8_uchar9:
	dpb 2,1
	popj 17,

convert_uchar9_uchar6:
	popj 17,

round_uchar9_uchar6:
	popj 17,

add_uchar9_uchar6:
	jumple 2,%L1159
%L1158:
	ibp 1
	sojg 2,%L1158	; decrement_and_branch_until_zero
%L1159:
	jumpe 2,%L1161
%L1160:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L1160
%L1161:
	popj 17,

diff_uchar9_uchar6:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

load_uchar9_uchar6:
	ldb 1,1
	popj 17,

store_uchar9_uchar6:
	andi 2,77
	dpb 2,1
	popj 17,

convert_uchar9_uchar8:
	popj 17,

round_uchar9_uchar8:
	popj 17,

add_uchar9_uchar8:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1180
%L1179:
	ibp 1
	sojn 4,%L1179	; decrement_and_branch_until_zero
%L1180:
	popj 17,

diff_uchar9_uchar8:
	move 4,1
	sub 4,2
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	popj 17,

load_uchar9_uchar8:
	ldb 1,1
	popj 17,

store_uchar9_uchar8:
	andi 2,377
	dpb 2,1
	popj 17,

convert_ushort18_uchar9:
	jumpe 1,%L1191
	move 4,1
	tlc 4,113300
%L1191:
	move 1,4
	popj 17,

round_ushort18_uchar9:
	jumpe 1,%L1194
	move 3,1
	tlc 3,113300
%L1194:
	jumpe 3,%L1193
	move 4,3
	tlc 4,3300
	tlz 4,110000
%L1193:
	move 1,4
	popj 17,

add_ushort18_uchar9:
	jumpe 1,%L1196
	move 3,1
	tlc 3,113300
%L1196:
	move 4,2
	andi 4,3
	move 1,2
	ash 1,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L1199
%L1198:
	ibp 1
	sojn 4,%L1198	; decrement_and_branch_until_zero
%L1199:
	popj 17,

diff_ushort18_uchar9:
	jumpe 1,%L1202
	move 6,1
	tlc 6,113300
%L1202:
	jumpe 2,%L1204
	move 3,2
	tlc 3,113300
%L1204:
	move 4,6
	sub 4,3
	muli 4,4
	move 1,5
	ash 1,-1
	add 1,%BADLH(4)
	ash 1,1	; ashlsi3_pointer
	popj 17,

load_ushort18_uchar9:
	jumpe 1,%L1206
	move 4,1
	tlc 4,113300
%L1206:
	ldb 1,4
	popj 17,

store_ushort18_uchar9:
	andi 2,777	; zero_extendqisi2
	jumpe 1,%L1208
	move 4,1
	tlc 4,113300
%L1208:
	dpb 2,4
	popj 17,

convert_uchar9_ushort18:
	jumpe 1,%L1210
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L1210:
	move 1,4
	popj 17,

round_uchar9_ushort18:
	jumpe 1,%L1213
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L1213:
	jumpe 4,%L1212
	move 3,4
	tlc 3,113300
%L1212:
	move 1,3
	popj 17,

add_uchar9_ushort18:
	jumpe 1,%L1215
	move 3,1
	tlc 3,3300
	tlz 3,110000
%L1215:
	move 4,2
	andi 4,1
	move 1,2
	ash 1,-1	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L1218
%L1217:
	ibp 1
	sojn 4,%L1217	; decrement_and_branch_until_zero
%L1218:
	popj 17,

diff_uchar9_ushort18:
	jumpe 1,%L1221
	move 6,1
	tlc 6,3300
	tlz 6,110000
%L1221:
	jumpe 2,%L1223
	move 3,2
	tlc 3,3300
	tlz 3,110000
%L1223:
	move 4,6
	sub 4,3
	muli 4,10
	move 1,5
	ash 1,-1
	add 1,%BADL9(4)
	ash 1,-1
	popj 17,

load_uchar9_ushort18:
	jumpe 1,%L1225
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L1225:
	ldb 1,4
	popj 17,

store_uchar9_ushort18:
	hrrzi 2,(2)	; zero_extendhisi2
	jumpe 1,%L1227
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L1227:
	dpb 2,4	; movhi
	popj 17,

to_void_q:
	popj 17,

from_void_q:
	popj 17,

to_void_h:
	jumpe 1,%L1233
	move 4,1
	tlc 4,113300
%L1233:
	move 1,4
	popj 17,

from_void_h:
	jumpe 1,%L1235
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L1235:
	move 1,4
	popj 17,

to_void_s:
	jumpe 1,%L1237
	move 4,1
	tlo 4,331100
%L1237:
	move 1,4
	popj 17,

from_void_s:
	hrrz 1,1
	popj 17,

to_void_d:
	jumpe 1,%L1241
	move 4,1
	tlo 4,331100
%L1241:
	move 1,4
	popj 17,

from_void_d:
	hrrz 1,1
	popj 17,

to_void_c:
	popj 17,

from_void_c:
	popj 17,

to_void_c6:
	popj 17,

from_void_c6:
	popj 17,

to_void_c7:
	popj 17,

from_void_c7:
	popj 17,

to_void_c8:
	popj 17,

from_void_c8:
	popj 17,

to_void_c9:
	popj 17,

from_void_c9:
	popj 17,

to_void_s18:
	jumpe 1,%L1265
	move 4,1
	tlc 4,113300
%L1265:
	move 1,4
	popj 17,

from_void_s18:
	jumpe 1,%L1267
	move 4,1
	tlc 4,3300
	tlz 4,110000
%L1267:
	move 1,4
	popj 17,

to_void_w:
	jumpe 1,%L1269
	move 4,1
	tlo 4,331100
%L1269:
	move 1,4
	popj 17,

from_void_w:
	hrrz 1,1
	popj 17,

	.data
	.align	2
g_q_as_h:
	.long	gw+29142024192
	.align	2
g_h_as_s:
	.long	gw+301989888
	.align	2
g_s_as_q:
	.long	gw+2
	.align	2
g_s_as_d:
	.long	gw+2
	.align	2
g_c9_as_c6:
	.long	gb+29142024212
	.align	2
g_c6_as_c7:
	.long	gb+32312918020
	.align	2
g_c9_as_c8:
	.long	gb+29142024212
	.align	2
g_c8_as_c9:
	.long	gb+30198988814
	.align	2
g_c9_as_s18:
	.long	gb+29142024212
	.align	2
g_c6_as_w:
	.long	gb+32312918020
	.align	2
g_w_as_c9:
	.long	gw+8
	.align	2
g_c7_as_void:
	.long	gb+31255953416

use_word_pointer_conversions:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	move 1,[POINT 9,gw,8]
	pushj 17,convertQintHint
	pushj 17,convertHintSint
	pushj 17,convert_s_d
	jumpe 1,%L1279
	move 10,1
	tlo 10,331100
%L1279:
	movem 10,gvptr
	move 4,gvptr
	hrrz 11,4
	hrre 2,12	; extendhisi2
	move 1,11
	pushj 17,store_s_h
	move 1,[POINT 9,gw,8]
	pushj 17,load_q_h
	hrre 10,1	; extendhisi2
	move 1,11
	pushj 17,convertSintQint
	ldb 4,1
	trne 4,400
	orcmi 4,777
	add 10,4
	move 1,11
	pushj 17,round_s_d
	came 1,11
	tdza 1,1
	movei 1,1
	add 10,1
	move 1,11
	movei 2,gw+2
	pushj 17,diff_s_d
	add 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

use_byte_pointer_conversions:
	add 17,[13,,13]
	movem 16,-12(17)
	movei 0,-11(17)
	hrli 0,10
	blt 0,-4(17)
	setzm -3(17)
	setzm -2(17)
	setzm -1(17)
	setzm (17)
	move 16,2
	move 4,[POINT 18,gb,17]
	andi 1,3
	jumple 1,%L1288
%L1287:
	ibp 4
	sojg 1,%L1287	; decrement_and_branch_until_zero
%L1288:
	jumpe 1,%L1290
%L1289:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L1289
%L1290:
	addi 4,4
	movei 11,(4)
	tlo 11,2200
	move 1,11
	pushj 17,convert_char6_char7
	move 15,1
	pushj 17,convert_char7_char8
	move 10,1
	pushj 17,convert_char8_char9
	move 12,1
	pushj 17,convert_char9_short18
	move 13,1
	pushj 17,convert_short18_int36
	move 14,1
	movem 11,gc6ptr
	movem 15,gc7ptr
	movem 10,gc8ptr
	movem 12,gc9ptr
	movem 13,gs18ptr
	movem 1,gwptr
	move 10,16
	lsh 10,33
	ash 10,-33
	move 1,11
	move 2,10
	pushj 17,store_char6_char9
	move 2,16
	lsh 2,36
	ash 2,-36
	move 1,12
	pushj 17,store_char9_char6
	move 1,13
	move 2,10
	pushj 17,store_short18_char9
	movem 16,(14)
	move 1,gc6ptr
	pushj 17,load_char6_char9
	move 10,1
	lsh 10,33
	ash 10,-33
	move 1,gc9ptr
	pushj 17,load_char9_char6
	lsh 1,36
	ash 1,-36
	add 10,1
	move 1,gs18ptr
	pushj 17,load_short18_char9
	lsh 1,33
	ash 1,-33
	add 10,1
	move 1,11
	movei 2,1
	pushj 17,add_char6_char7
	sub 1,15
	movem 1,-3(17)
	move 6,1
	muli 6,12
	move 4,7
	ash 4,-1
	add 4,%BADL7(6)
	add 10,4
	move 1,12
	movei 2,1
	pushj 17,add_char9_short18
	sub 1,13
	movem 1,-1(17)
	move 6,1
	muli 6,4
	move 4,7
	ash 4,-1
	add 4,%BADLH(6)
	add 10,4
	move 1,[POINT 8,gb+17,11]
	move 2,[POINT 8,gb+16,15]
	pushj 17,diff_char8_char9
	add 10,1
	move 1,10
	move 16,-12(17)
	movei 0,10
	hrli 0,-11(17)
	blt 0,15
	add 17,[-13,,-13]
	popj 17,

use_unsigned_byte_pointer_conversions:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,2
	move 4,[POINT 18,gb,17]
	andi 1,3
	jumple 1,%L1303
%L1302:
	ibp 4
	sojg 1,%L1302	; decrement_and_branch_until_zero
%L1303:
	jumpe 1,%L1305
%L1304:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L1304
%L1305:
	addi 4,6
	movei 10,(4)
	tlo 10,2200
	move 1,10
	pushj 17,convert_uchar6_uchar8
	pushj 17,convert_uchar8_uchar9
	move 11,1
	move 2,12
	andi 2,777	; zero_extendqisi2
	move 1,10
	pushj 17,store_uchar6_uchar9
	move 2,12
	hrrzi 2,(2)	; zero_extendhisi2
	move 1,11
	pushj 17,store_uchar9_ushort18
	move 1,10
	pushj 17,load_uchar6_uchar9
	move 10,1
	andi 10,777	; zero_extendqisi2
	move 1,11
	pushj 17,load_uchar9_ushort18
	add 10,1
	move 1,11
	pushj 17,round_uchar9_ushort18
	came 1,11
	tdza 1,1
	movei 1,1
	add 10,1
	move 1,[POINT 8,gb+22,27]
	move 2,[POINT 8,gb+21,23]
	pushj 17,diff_uchar8_uchar9
	add 10,1
	aos 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

use_void_bridge:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 10,1
	andi 10,3
	move 4,10
	move 3,10
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 18,gb,17]
	jumpe 10,%L1314
%L1313:
	ibp 3
	sojn 4,%L1313	; decrement_and_branch_until_zero
%L1314:
	addi 3,22
	movei 4,(3)
	hrrz 11,4
	tlo 11,2200
	move 1,11
	pushj 17,to_void_c9
	pushj 17,from_void_c9
	movem 1,gc9ptr
	movei 1,gw+10
	pushj 17,to_void_w
	pushj 17,from_void_w
	move 12,1
	move 3,[POINT 18,gb,17]
	move 4,10
	jumple 10,%L1328
%L1327:
	ibp 3
	sojg 4,%L1327	; decrement_and_branch_until_zero
%L1328:
	jumpe 4,%L1330
%L1329:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L1329
%L1330:
	addi 3,10
	movei 1,(3)
	tlo 1,2200
	pushj 17,to_void_c7
	movem 1,gvptr
	move 1,gvptr
	pushj 17,from_void_c7
	movem 1,gc7ptr
	move 4,gc9ptr
	came 4,11
	tdza 1,1
	movei 1,1
	movei 6,gw+10
	came 12,6
	tdza 4,4
	movei 4,1
	add 1,4
	move 3,[POINT 18,gb,17]
	skipn 4,10
	jrst %L1335
%L1334:
	ibp 3
	sojg 4,%L1334	; decrement_and_branch_until_zero
%L1335:
	jumpe 4,%L1337
%L1336:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L1336
%L1337:
	addi 3,10
	movei 3,(3)
	tlo 3,2200
	move 4,gc7ptr
	came 4,3
	tdza 4,4
	movei 4,1
	add 1,4
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

use_global_pointer_conversions:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	ldb 10,g_q_as_h
	hrre 10,10
	move 4,g_h_as_s
	add 10,(4)
	ldb 4,g_s_as_q
	trne 4,400
	orcmi 4,777
	add 10,4
	move 6,g_s_as_d
	movei 7,gw+2
	came 6,7
	tdza 4,4
	movei 4,1
	add 10,4
	move 6,g_c9_as_c6
	move 7,[POINT 9,gb+24,8]
	came 6,7
	tdza 4,4
	movei 4,1
	add 10,4
	move 6,g_c6_as_c7
	move 7,[POINT 6,gb+4,5]
	came 6,7
	tdza 4,4
	movei 4,1
	add 10,4
	move 6,g_c9_as_c8
	move 7,[POINT 9,gb+24,8]
	came 6,7
	tdza 4,4
	movei 4,1
	add 10,4
	move 6,g_c8_as_c9
	move 7,[POINT 8,gb+16,7]
	came 6,7
	tdza 4,4
	movei 4,1
	add 10,4
	move 6,g_c9_as_s18
	move 7,[POINT 9,gb+24,8]
	came 6,7
	tdza 4,4
	movei 4,1
	add 10,4
	move 6,g_c6_as_w
	move 7,[POINT 6,gb+4,5]
	came 6,7
	tdza 4,4
	movei 4,1
	add 10,4
	move 6,g_w_as_c9
	movei 7,gw+10
	came 6,7
	tdza 4,4
	movei 4,1
	add 10,4
	move 1,g_c7_as_void
	pushj 17,from_void_c7
	move 6,[POINT 7,gb+10,6]
	came 1,6
	tdza 1,1
	movei 1,1
	add 10,1
	add 10,11
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.globl	use_pointer_conversion
use_pointer_conversion:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 11,1
	move 12,2
	pushj 17,use_word_pointer_conversions
	move 10,1
	move 1,11
	move 2,12
	pushj 17,use_byte_pointer_conversions
	add 10,1
	move 1,11
	move 2,12
	pushj 17,use_unsigned_byte_pointer_conversions
	add 10,1
	move 1,11
	pushj 17,use_void_bridge
	add 10,1
	move 1,11
	pushj 17,use_global_pointer_conversions
	add 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

	.bss
gb:
	.space	160
gvptr:
	.space	4
gcptr:
	.space	4
gc6ptr:
	.space	4
gc7ptr:
	.space	4
gc8ptr:
	.space	4
gc9ptr:
	.space	4
gs18ptr:
	.space	4
gwptr:
	.space	4
