	.data
	.align	2
gp_char_:
	.long	arr_char_+29142024194
	.align	2
vgp_char_:
	.long	arr_char_+29142024195

inc_char__0:
	popj 17,

inc_char__1:
	ibp 1
	popj 17,

inc_char__2:
	ibp 1
	ibp 1
	popj 17,

inc_char__3:
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_char__4:
	addi 1,1
	popj 17,

inc_char__5:
	addi 1,1
	ibp 1
	popj 17,

inc_char__6:
	addi 1,1
	ibp 1
	ibp 1
	popj 17,

inc_char__7:
	addi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_char__8:
	addi 1,2
	popj 17,

inc_char__9:
	addi 1,2
	ibp 1
	popj 17,

inc_char__10:
	addi 1,2
	ibp 1
	ibp 1
	popj 17,

inc_char__11:
	addi 1,2
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_char__12:
	addi 1,3
	popj 17,

inc_char__dynamic:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L19
%L18:
	ibp 1
	sojn 4,%L18	; decrement_and_branch_until_zero
%L19:
	popj 17,

addassign_char_:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L23
%L22:
	ibp 1
	sojn 4,%L22	; decrement_and_branch_until_zero
%L23:
	popj 17,

preinc_char_:
	ibp 1
	popj 17,

postinc_char_:
	ibp 1
	popj 17,

global_inc_char_:
	move 1,gp_char_
	ibp 1
	ibp 1
	ibp 1
	popj 17,

volatile_inc_char_:
	move 3,vgp_char_
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L34
%L33:
	ibp 3
	sojn 4,%L33	; decrement_and_branch_until_zero
%L34:
	movem 3,vgp_char_
	move 1,3
	popj 17,

array_start_inc_char_:
	move 1,[POINT 9,arr_char_+3,35]
	popj 17,

index_inc_char_:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,arr_char_,8]
	jumpe 4,%L41
%L40:
	ibp 3
	sojn 4,%L40	; decrement_and_branch_until_zero
%L41:
	move 4,2
	andi 4,3
	move 1,2
	ash 1,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L44
%L43:
	ibp 1
	sojn 4,%L43	; decrement_and_branch_until_zero
%L44:
	popj 17,

load_after_char_:
	ildb 1,1
	popj 17,

store_after_char_:
	ibp 1
	idpb 2,1
	popj 17,

diff_after_inc_char_:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L50
%L49:
	ibp 3
	sojn 4,%L49	; decrement_and_branch_until_zero
%L50:
	move 6,3
	sub 6,1
	muli 6,10
	move 1,7
	ash 1,-1
	add 1,%BADL9(6)
	popj 17,

compare_after_inc_char_:
	move 4,3
	andi 4,3
	ash 3,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L56
%L55:
	ibp 1
	sojn 4,%L55	; decrement_and_branch_until_zero
%L56:
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_uchar_:
	.long	arr_uchar_+29142024194
	.align	2
vgp_uchar_:
	.long	arr_uchar_+29142024195

inc_uchar__0:
	popj 17,

inc_uchar__1:
	ibp 1
	popj 17,

inc_uchar__2:
	ibp 1
	ibp 1
	popj 17,

inc_uchar__3:
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_uchar__4:
	addi 1,1
	popj 17,

inc_uchar__5:
	addi 1,1
	ibp 1
	popj 17,

inc_uchar__6:
	addi 1,1
	ibp 1
	ibp 1
	popj 17,

inc_uchar__7:
	addi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_uchar__8:
	addi 1,2
	popj 17,

inc_uchar__9:
	addi 1,2
	ibp 1
	popj 17,

inc_uchar__10:
	addi 1,2
	ibp 1
	ibp 1
	popj 17,

inc_uchar__11:
	addi 1,2
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_uchar__12:
	addi 1,3
	popj 17,

inc_uchar__dynamic:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L75
%L74:
	ibp 1
	sojn 4,%L74	; decrement_and_branch_until_zero
%L75:
	popj 17,

addassign_uchar_:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L79
%L78:
	ibp 1
	sojn 4,%L78	; decrement_and_branch_until_zero
%L79:
	popj 17,

preinc_uchar_:
	ibp 1
	popj 17,

postinc_uchar_:
	ibp 1
	popj 17,

global_inc_uchar_:
	move 1,gp_uchar_
	ibp 1
	ibp 1
	ibp 1
	popj 17,

volatile_inc_uchar_:
	move 3,vgp_uchar_
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L90
%L89:
	ibp 3
	sojn 4,%L89	; decrement_and_branch_until_zero
%L90:
	movem 3,vgp_uchar_
	move 1,3
	popj 17,

array_start_inc_uchar_:
	move 1,[POINT 9,arr_uchar_+3,35]
	popj 17,

index_inc_uchar_:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,arr_uchar_,8]
	jumpe 4,%L97
%L96:
	ibp 3
	sojn 4,%L96	; decrement_and_branch_until_zero
%L97:
	move 4,2
	andi 4,3
	move 1,2
	ash 1,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L100
%L99:
	ibp 1
	sojn 4,%L99	; decrement_and_branch_until_zero
%L100:
	popj 17,

load_after_uchar_:
	ildb 1,1
	popj 17,

store_after_uchar_:
	ibp 1
	idpb 2,1
	popj 17,

diff_after_inc_uchar_:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L106
%L105:
	ibp 3
	sojn 4,%L105	; decrement_and_branch_until_zero
%L106:
	move 6,3
	sub 6,1
	muli 6,10
	move 1,7
	ash 1,-1
	add 1,%BADL9(6)
	popj 17,

compare_after_inc_uchar_:
	move 4,3
	andi 4,3
	ash 3,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L112
%L111:
	ibp 1
	sojn 4,%L111	; decrement_and_branch_until_zero
%L112:
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_char6:
	.long	arr_char6+19428016129
	.align	2
vgp_char6:
	.long	arr_char6+32312918018

inc_char6_0:
	popj 17,

inc_char6_1:
	ibp 1
	popj 17,

inc_char6_2:
	ibp 1
	ibp 1
	popj 17,

inc_char6_3:
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_char6_4:
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_char6_5:
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_char6_6:
	addi 1,1
	popj 17,

inc_char6_7:
	addi 1,1
	ibp 1
	popj 17,

inc_char6_8:
	addi 1,1
	ibp 1
	ibp 1
	popj 17,

inc_char6_9:
	addi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_char6_10:
	addi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_char6_11:
	addi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_char6_12:
	addi 1,2
	popj 17,

inc_char6_dynamic:
	jumple 2,%L131
%L130:
	ibp 1
	sojg 2,%L130	; decrement_and_branch_until_zero
%L131:
	jumpe 2,%L133
%L132:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L132
%L133:
	popj 17,

addassign_char6:
	jumple 2,%L137
%L136:
	ibp 1
	sojg 2,%L136	; decrement_and_branch_until_zero
%L137:
	jumpe 2,%L139
%L138:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L138
%L139:
	popj 17,

preinc_char6:
	ibp 1
	popj 17,

postinc_char6:
	ibp 1
	popj 17,

global_inc_char6:
	move 1,gp_char6
	ibp 1
	ibp 1
	ibp 1
	popj 17,

volatile_inc_char6:
	move 4,vgp_char6
	jumple 1,%L150
%L149:
	ibp 4
	sojg 1,%L149	; decrement_and_branch_until_zero
%L150:
	jumpe 1,%L152
%L151:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L151
%L152:
	movem 4,vgp_char6
	move 1,4
	popj 17,

array_start_inc_char6:
	move 1,[POINT 6,arr_char6+2,23]
	popj 17,

index_inc_char6:
	move 4,[POINT 6,arr_char6,5]
	jumple 1,%L159
%L158:
	ibp 4
	sojg 1,%L158	; decrement_and_branch_until_zero
%L159:
	jumpe 1,%L161
%L160:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L160
%L161:
	move 1,4
	skipg 4,2
	jrst %L164
%L163:
	ibp 1
	sojg 4,%L163	; decrement_and_branch_until_zero
%L164:
	jumpe 4,%L166
%L165:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L165
%L166:
	popj 17,

load_after_char6:
	ildb 1,1
	trne 1,40
	orcmi 1,77
	popj 17,

store_after_char6:
	lsh 2,36
	ash 2,-36
	ibp 1
	idpb 2,1
	popj 17,

diff_after_inc_char6:
	move 4,1
	jumple 2,%L172
%L171:
	ibp 4
	sojg 2,%L171	; decrement_and_branch_until_zero
%L172:
	jumpe 2,%L174
%L173:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 2,%L173
%L174:
	move 6,4
	sub 6,1
	muli 6,14
	move 1,7
	ash 1,-1
	add 1,%BADL6(6)
	popj 17,

compare_after_inc_char6:
	jumple 3,%L180
%L179:
	ibp 1
	sojg 3,%L179	; decrement_and_branch_until_zero
%L180:
	jumpe 3,%L182
%L181:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 3,%L181
%L182:
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_uchar6:
	.long	arr_uchar6+19428016129
	.align	2
vgp_uchar6:
	.long	arr_uchar6+32312918018

inc_uchar6_0:
	popj 17,

inc_uchar6_1:
	ibp 1
	popj 17,

inc_uchar6_2:
	ibp 1
	ibp 1
	popj 17,

inc_uchar6_3:
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_uchar6_4:
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_uchar6_5:
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_uchar6_6:
	addi 1,1
	popj 17,

inc_uchar6_7:
	addi 1,1
	ibp 1
	popj 17,

inc_uchar6_8:
	addi 1,1
	ibp 1
	ibp 1
	popj 17,

inc_uchar6_9:
	addi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_uchar6_10:
	addi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_uchar6_11:
	addi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_uchar6_12:
	addi 1,2
	popj 17,

inc_uchar6_dynamic:
	jumple 2,%L201
%L200:
	ibp 1
	sojg 2,%L200	; decrement_and_branch_until_zero
%L201:
	jumpe 2,%L203
%L202:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L202
%L203:
	popj 17,

addassign_uchar6:
	jumple 2,%L207
%L206:
	ibp 1
	sojg 2,%L206	; decrement_and_branch_until_zero
%L207:
	jumpe 2,%L209
%L208:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L208
%L209:
	popj 17,

preinc_uchar6:
	ibp 1
	popj 17,

postinc_uchar6:
	ibp 1
	popj 17,

global_inc_uchar6:
	move 1,gp_uchar6
	ibp 1
	ibp 1
	ibp 1
	popj 17,

volatile_inc_uchar6:
	move 4,vgp_uchar6
	jumple 1,%L220
%L219:
	ibp 4
	sojg 1,%L219	; decrement_and_branch_until_zero
%L220:
	jumpe 1,%L222
%L221:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L221
%L222:
	movem 4,vgp_uchar6
	move 1,4
	popj 17,

array_start_inc_uchar6:
	move 1,[POINT 6,arr_uchar6+2,23]
	popj 17,

index_inc_uchar6:
	move 4,[POINT 6,arr_uchar6,5]
	jumple 1,%L229
%L228:
	ibp 4
	sojg 1,%L228	; decrement_and_branch_until_zero
%L229:
	jumpe 1,%L231
%L230:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L230
%L231:
	move 1,4
	skipg 4,2
	jrst %L234
%L233:
	ibp 1
	sojg 4,%L233	; decrement_and_branch_until_zero
%L234:
	jumpe 4,%L236
%L235:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L235
%L236:
	popj 17,

load_after_uchar6:
	ildb 1,1
	popj 17,

store_after_uchar6:
	andi 2,77
	ibp 1
	idpb 2,1
	popj 17,

diff_after_inc_uchar6:
	move 4,1
	jumple 2,%L242
%L241:
	ibp 4
	sojg 2,%L241	; decrement_and_branch_until_zero
%L242:
	jumpe 2,%L244
%L243:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 2,%L243
%L244:
	move 6,4
	sub 6,1
	muli 6,14
	move 1,7
	ash 1,-1
	add 1,%BADL6(6)
	popj 17,

compare_after_inc_uchar6:
	jumple 3,%L250
%L249:
	ibp 1
	sojg 3,%L249	; decrement_and_branch_until_zero
%L250:
	jumpe 3,%L252
%L251:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 3,%L251
%L252:
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_char7:
	.long	arr_char7+8707375105
	.align	2
vgp_char7:
	.long	arr_char7+16223567874

inc_char7_0:
	popj 17,

inc_char7_1:
	ibp 1
	popj 17,

inc_char7_2:
	ibp 1
	ibp 1
	popj 17,

inc_char7_3:
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_char7_4:
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_char7_5:
	addi 1,1
	popj 17,

inc_char7_6:
	addi 1,1
	ibp 1
	popj 17,

inc_char7_7:
	addi 1,1
	ibp 1
	ibp 1
	popj 17,

inc_char7_8:
	addi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_char7_9:
	addi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_char7_10:
	addi 1,2
	popj 17,

inc_char7_11:
	addi 1,2
	ibp 1
	popj 17,

inc_char7_12:
	addi 1,2
	ibp 1
	ibp 1
	popj 17,

inc_char7_dynamic:
	jumple 2,%L271
%L270:
	ibp 1
	sojg 2,%L270	; decrement_and_branch_until_zero
%L271:
	jumpe 2,%L273
%L272:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L272
%L273:
	popj 17,

addassign_char7:
	jumple 2,%L277
%L276:
	ibp 1
	sojg 2,%L276	; decrement_and_branch_until_zero
%L277:
	jumpe 2,%L279
%L278:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L278
%L279:
	popj 17,

preinc_char7:
	ibp 1
	popj 17,

postinc_char7:
	ibp 1
	popj 17,

global_inc_char7:
	move 1,gp_char7
	ibp 1
	ibp 1
	ibp 1
	popj 17,

volatile_inc_char7:
	move 4,vgp_char7
	jumple 1,%L290
%L289:
	ibp 4
	sojg 1,%L289	; decrement_and_branch_until_zero
%L290:
	jumpe 1,%L292
%L291:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L291
%L292:
	movem 4,vgp_char7
	move 1,4
	popj 17,

array_start_inc_char7:
	move 1,[POINT 7,arr_char7+3,6]
	popj 17,

index_inc_char7:
	move 4,[POINT 7,arr_char7,6]
	jumple 1,%L299
%L298:
	ibp 4
	sojg 1,%L298	; decrement_and_branch_until_zero
%L299:
	jumpe 1,%L301
%L300:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L300
%L301:
	move 1,4
	skipg 4,2
	jrst %L304
%L303:
	ibp 1
	sojg 4,%L303	; decrement_and_branch_until_zero
%L304:
	jumpe 4,%L306
%L305:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L305
%L306:
	popj 17,

load_after_char7:
	ildb 1,1
	trne 1,100
	orcmi 1,177
	popj 17,

store_after_char7:
	lsh 2,35
	ash 2,-35
	ibp 1
	idpb 2,1
	popj 17,

diff_after_inc_char7:
	move 4,1
	jumple 2,%L312
%L311:
	ibp 4
	sojg 2,%L311	; decrement_and_branch_until_zero
%L312:
	jumpe 2,%L314
%L313:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 2,%L313
%L314:
	move 6,4
	sub 6,1
	muli 6,12
	move 1,7
	ash 1,-1
	add 1,%BADL7(6)
	popj 17,

compare_after_inc_char7:
	jumple 3,%L320
%L319:
	ibp 1
	sojg 3,%L319	; decrement_and_branch_until_zero
%L320:
	jumpe 3,%L322
%L321:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 3,%L321
%L322:
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_uchar7:
	.long	arr_uchar7+8707375105
	.align	2
vgp_uchar7:
	.long	arr_uchar7+16223567874

inc_uchar7_0:
	popj 17,

inc_uchar7_1:
	ibp 1
	popj 17,

inc_uchar7_2:
	ibp 1
	ibp 1
	popj 17,

inc_uchar7_3:
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_uchar7_4:
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_uchar7_5:
	addi 1,1
	popj 17,

inc_uchar7_6:
	addi 1,1
	ibp 1
	popj 17,

inc_uchar7_7:
	addi 1,1
	ibp 1
	ibp 1
	popj 17,

inc_uchar7_8:
	addi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_uchar7_9:
	addi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_uchar7_10:
	addi 1,2
	popj 17,

inc_uchar7_11:
	addi 1,2
	ibp 1
	popj 17,

inc_uchar7_12:
	addi 1,2
	ibp 1
	ibp 1
	popj 17,

inc_uchar7_dynamic:
	jumple 2,%L341
%L340:
	ibp 1
	sojg 2,%L340	; decrement_and_branch_until_zero
%L341:
	jumpe 2,%L343
%L342:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L342
%L343:
	popj 17,

addassign_uchar7:
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

preinc_uchar7:
	ibp 1
	popj 17,

postinc_uchar7:
	ibp 1
	popj 17,

global_inc_uchar7:
	move 1,gp_uchar7
	ibp 1
	ibp 1
	ibp 1
	popj 17,

volatile_inc_uchar7:
	move 4,vgp_uchar7
	jumple 1,%L360
%L359:
	ibp 4
	sojg 1,%L359	; decrement_and_branch_until_zero
%L360:
	jumpe 1,%L362
%L361:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L361
%L362:
	movem 4,vgp_uchar7
	move 1,4
	popj 17,

array_start_inc_uchar7:
	move 1,[POINT 7,arr_uchar7+3,6]
	popj 17,

index_inc_uchar7:
	move 4,[POINT 7,arr_uchar7,6]
	jumple 1,%L369
%L368:
	ibp 4
	sojg 1,%L368	; decrement_and_branch_until_zero
%L369:
	jumpe 1,%L371
%L370:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L370
%L371:
	move 1,4
	skipg 4,2
	jrst %L374
%L373:
	ibp 1
	sojg 4,%L373	; decrement_and_branch_until_zero
%L374:
	jumpe 4,%L376
%L375:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L375
%L376:
	popj 17,

load_after_uchar7:
	ildb 1,1
	popj 17,

store_after_uchar7:
	andi 2,177
	ibp 1
	idpb 2,1
	popj 17,

diff_after_inc_uchar7:
	move 4,1
	jumple 2,%L382
%L381:
	ibp 4
	sojg 2,%L381	; decrement_and_branch_until_zero
%L382:
	jumpe 2,%L384
%L383:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 2,%L383
%L384:
	move 6,4
	sub 6,1
	muli 6,12
	move 1,7
	ash 1,-1
	add 1,%BADL7(6)
	popj 17,

compare_after_inc_uchar7:
	jumple 3,%L390
%L389:
	ibp 1
	sojg 3,%L389	; decrement_and_branch_until_zero
%L390:
	jumpe 3,%L392
%L391:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 3,%L391
%L392:
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_char8:
	.long	arr_char8+30198988802
	.align	2
vgp_char8:
	.long	arr_char8+30198988803

inc_char8_0:
	popj 17,

inc_char8_1:
	ibp 1
	popj 17,

inc_char8_2:
	ibp 1
	ibp 1
	popj 17,

inc_char8_3:
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_char8_4:
	addi 1,1
	popj 17,

inc_char8_5:
	addi 1,1
	ibp 1
	popj 17,

inc_char8_6:
	addi 1,1
	ibp 1
	ibp 1
	popj 17,

inc_char8_7:
	addi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_char8_8:
	addi 1,2
	popj 17,

inc_char8_9:
	addi 1,2
	ibp 1
	popj 17,

inc_char8_10:
	addi 1,2
	ibp 1
	ibp 1
	popj 17,

inc_char8_11:
	addi 1,2
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_char8_12:
	addi 1,3
	popj 17,

inc_char8_dynamic:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L411
%L410:
	ibp 1
	sojn 4,%L410	; decrement_and_branch_until_zero
%L411:
	popj 17,

addassign_char8:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L415
%L414:
	ibp 1
	sojn 4,%L414	; decrement_and_branch_until_zero
%L415:
	popj 17,

preinc_char8:
	ibp 1
	popj 17,

postinc_char8:
	ibp 1
	popj 17,

global_inc_char8:
	move 1,gp_char8
	ibp 1
	ibp 1
	ibp 1
	popj 17,

volatile_inc_char8:
	move 3,vgp_char8
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L426
%L425:
	ibp 3
	sojn 4,%L425	; decrement_and_branch_until_zero
%L426:
	movem 3,vgp_char8
	move 1,3
	popj 17,

array_start_inc_char8:
	move 1,[POINT 8,arr_char8+3,31]
	popj 17,

index_inc_char8:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 8,arr_char8,7]
	jumpe 4,%L433
%L432:
	ibp 3
	sojn 4,%L432	; decrement_and_branch_until_zero
%L433:
	move 4,2
	andi 4,3
	move 1,2
	ash 1,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L436
%L435:
	ibp 1
	sojn 4,%L435	; decrement_and_branch_until_zero
%L436:
	popj 17,

load_after_char8:
	ildb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

store_after_char8:
	lsh 2,34
	ash 2,-34
	ibp 1
	idpb 2,1
	popj 17,

diff_after_inc_char8:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L442
%L441:
	ibp 3
	sojn 4,%L441	; decrement_and_branch_until_zero
%L442:
	move 6,3
	sub 6,1
	muli 6,10
	move 1,7
	ash 1,-1
	add 1,%BADL8(6)
	popj 17,

compare_after_inc_char8:
	move 4,3
	andi 4,3
	ash 3,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L448
%L447:
	ibp 1
	sojn 4,%L447	; decrement_and_branch_until_zero
%L448:
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_uchar8:
	.long	arr_uchar8+30198988802
	.align	2
vgp_uchar8:
	.long	arr_uchar8+30198988803

inc_uchar8_0:
	popj 17,

inc_uchar8_1:
	ibp 1
	popj 17,

inc_uchar8_2:
	ibp 1
	ibp 1
	popj 17,

inc_uchar8_3:
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_uchar8_4:
	addi 1,1
	popj 17,

inc_uchar8_5:
	addi 1,1
	ibp 1
	popj 17,

inc_uchar8_6:
	addi 1,1
	ibp 1
	ibp 1
	popj 17,

inc_uchar8_7:
	addi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_uchar8_8:
	addi 1,2
	popj 17,

inc_uchar8_9:
	addi 1,2
	ibp 1
	popj 17,

inc_uchar8_10:
	addi 1,2
	ibp 1
	ibp 1
	popj 17,

inc_uchar8_11:
	addi 1,2
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_uchar8_12:
	addi 1,3
	popj 17,

inc_uchar8_dynamic:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L467
%L466:
	ibp 1
	sojn 4,%L466	; decrement_and_branch_until_zero
%L467:
	popj 17,

addassign_uchar8:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L471
%L470:
	ibp 1
	sojn 4,%L470	; decrement_and_branch_until_zero
%L471:
	popj 17,

preinc_uchar8:
	ibp 1
	popj 17,

postinc_uchar8:
	ibp 1
	popj 17,

global_inc_uchar8:
	move 1,gp_uchar8
	ibp 1
	ibp 1
	ibp 1
	popj 17,

volatile_inc_uchar8:
	move 3,vgp_uchar8
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L482
%L481:
	ibp 3
	sojn 4,%L481	; decrement_and_branch_until_zero
%L482:
	movem 3,vgp_uchar8
	move 1,3
	popj 17,

array_start_inc_uchar8:
	move 1,[POINT 8,arr_uchar8+3,31]
	popj 17,

index_inc_uchar8:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 8,arr_uchar8,7]
	jumpe 4,%L489
%L488:
	ibp 3
	sojn 4,%L488	; decrement_and_branch_until_zero
%L489:
	move 4,2
	andi 4,3
	move 1,2
	ash 1,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L492
%L491:
	ibp 1
	sojn 4,%L491	; decrement_and_branch_until_zero
%L492:
	popj 17,

load_after_uchar8:
	ildb 1,1
	popj 17,

store_after_uchar8:
	andi 2,377
	ibp 1
	idpb 2,1
	popj 17,

diff_after_inc_uchar8:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L498
%L497:
	ibp 3
	sojn 4,%L497	; decrement_and_branch_until_zero
%L498:
	move 6,3
	sub 6,1
	muli 6,10
	move 1,7
	ash 1,-1
	add 1,%BADL8(6)
	popj 17,

compare_after_inc_uchar8:
	move 4,3
	andi 4,3
	ash 3,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L504
%L503:
	ibp 1
	sojn 4,%L503	; decrement_and_branch_until_zero
%L504:
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_char9:
	.long	arr_char9+29142024194
	.align	2
vgp_char9:
	.long	arr_char9+29142024195

inc_char9_0:
	popj 17,

inc_char9_1:
	ibp 1
	popj 17,

inc_char9_2:
	ibp 1
	ibp 1
	popj 17,

inc_char9_3:
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_char9_4:
	addi 1,1
	popj 17,

inc_char9_5:
	addi 1,1
	ibp 1
	popj 17,

inc_char9_6:
	addi 1,1
	ibp 1
	ibp 1
	popj 17,

inc_char9_7:
	addi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_char9_8:
	addi 1,2
	popj 17,

inc_char9_9:
	addi 1,2
	ibp 1
	popj 17,

inc_char9_10:
	addi 1,2
	ibp 1
	ibp 1
	popj 17,

inc_char9_11:
	addi 1,2
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_char9_12:
	addi 1,3
	popj 17,

inc_char9_dynamic:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L523
%L522:
	ibp 1
	sojn 4,%L522	; decrement_and_branch_until_zero
%L523:
	popj 17,

addassign_char9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L527
%L526:
	ibp 1
	sojn 4,%L526	; decrement_and_branch_until_zero
%L527:
	popj 17,

preinc_char9:
	ibp 1
	popj 17,

postinc_char9:
	ibp 1
	popj 17,

global_inc_char9:
	move 1,gp_char9
	ibp 1
	ibp 1
	ibp 1
	popj 17,

volatile_inc_char9:
	move 3,vgp_char9
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L538
%L537:
	ibp 3
	sojn 4,%L537	; decrement_and_branch_until_zero
%L538:
	movem 3,vgp_char9
	move 1,3
	popj 17,

array_start_inc_char9:
	move 1,[POINT 9,arr_char9+3,35]
	popj 17,

index_inc_char9:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,arr_char9,8]
	jumpe 4,%L545
%L544:
	ibp 3
	sojn 4,%L544	; decrement_and_branch_until_zero
%L545:
	move 4,2
	andi 4,3
	move 1,2
	ash 1,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L548
%L547:
	ibp 1
	sojn 4,%L547	; decrement_and_branch_until_zero
%L548:
	popj 17,

load_after_char9:
	ildb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

store_after_char9:
	ibp 1
	idpb 2,1
	popj 17,

diff_after_inc_char9:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L554
%L553:
	ibp 3
	sojn 4,%L553	; decrement_and_branch_until_zero
%L554:
	move 6,3
	sub 6,1
	muli 6,10
	move 1,7
	ash 1,-1
	add 1,%BADL9(6)
	popj 17,

compare_after_inc_char9:
	move 4,3
	andi 4,3
	ash 3,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L560
%L559:
	ibp 1
	sojn 4,%L559	; decrement_and_branch_until_zero
%L560:
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_uchar9:
	.long	arr_uchar9+29142024194
	.align	2
vgp_uchar9:
	.long	arr_uchar9+29142024195

inc_uchar9_0:
	popj 17,

inc_uchar9_1:
	ibp 1
	popj 17,

inc_uchar9_2:
	ibp 1
	ibp 1
	popj 17,

inc_uchar9_3:
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_uchar9_4:
	addi 1,1
	popj 17,

inc_uchar9_5:
	addi 1,1
	ibp 1
	popj 17,

inc_uchar9_6:
	addi 1,1
	ibp 1
	ibp 1
	popj 17,

inc_uchar9_7:
	addi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_uchar9_8:
	addi 1,2
	popj 17,

inc_uchar9_9:
	addi 1,2
	ibp 1
	popj 17,

inc_uchar9_10:
	addi 1,2
	ibp 1
	ibp 1
	popj 17,

inc_uchar9_11:
	addi 1,2
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_uchar9_12:
	addi 1,3
	popj 17,

inc_uchar9_dynamic:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L579
%L578:
	ibp 1
	sojn 4,%L578	; decrement_and_branch_until_zero
%L579:
	popj 17,

addassign_uchar9:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L583
%L582:
	ibp 1
	sojn 4,%L582	; decrement_and_branch_until_zero
%L583:
	popj 17,

preinc_uchar9:
	ibp 1
	popj 17,

postinc_uchar9:
	ibp 1
	popj 17,

global_inc_uchar9:
	move 1,gp_uchar9
	ibp 1
	ibp 1
	ibp 1
	popj 17,

volatile_inc_uchar9:
	move 3,vgp_uchar9
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L594
%L593:
	ibp 3
	sojn 4,%L593	; decrement_and_branch_until_zero
%L594:
	movem 3,vgp_uchar9
	move 1,3
	popj 17,

array_start_inc_uchar9:
	move 1,[POINT 9,arr_uchar9+3,35]
	popj 17,

index_inc_uchar9:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,arr_uchar9,8]
	jumpe 4,%L601
%L600:
	ibp 3
	sojn 4,%L600	; decrement_and_branch_until_zero
%L601:
	move 4,2
	andi 4,3
	move 1,2
	ash 1,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L604
%L603:
	ibp 1
	sojn 4,%L603	; decrement_and_branch_until_zero
%L604:
	popj 17,

load_after_uchar9:
	ildb 1,1
	popj 17,

store_after_uchar9:
	ibp 1
	idpb 2,1
	popj 17,

diff_after_inc_uchar9:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L610
%L609:
	ibp 3
	sojn 4,%L609	; decrement_and_branch_until_zero
%L610:
	move 6,3
	sub 6,1
	muli 6,10
	move 1,7
	ash 1,-1
	add 1,%BADL9(6)
	popj 17,

compare_after_inc_uchar9:
	move 4,3
	andi 4,3
	ash 3,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L616
%L615:
	ibp 1
	sojn 4,%L615	; decrement_and_branch_until_zero
%L616:
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_short16:
	.long	arr_short16+19629342724
	.align	2
vgp_short16:
	.long	arr_short16+19629342726

inc_short16_0:
	popj 17,

inc_short16_1:
	ibp 1
	popj 17,

inc_short16_2:
	addi 1,1
	popj 17,

inc_short16_3:
	addi 1,1
	ibp 1
	popj 17,

inc_short16_4:
	addi 1,2
	popj 17,

inc_short16_5:
	addi 1,2
	ibp 1
	popj 17,

inc_short16_6:
	addi 1,3
	popj 17,

inc_short16_7:
	addi 1,3
	ibp 1
	popj 17,

inc_short16_8:
	addi 1,4
	popj 17,

inc_short16_9:
	addi 1,4
	ibp 1
	popj 17,

inc_short16_10:
	addi 1,5
	popj 17,

inc_short16_11:
	addi 1,5
	ibp 1
	popj 17,

inc_short16_12:
	addi 1,6
	popj 17,

inc_short16_dynamic:
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L635
%L634:
	ibp 1
	sojn 4,%L634	; decrement_and_branch_until_zero
%L635:
	popj 17,

addassign_short16:
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L639
%L638:
	ibp 1
	sojn 4,%L638	; decrement_and_branch_until_zero
%L639:
	popj 17,

preinc_short16:
	ibp 1
	popj 17,

postinc_short16:
	move 2,1
	ibp 2
	move 4,2
	sub 4,1
	muli 4,4
	move 3,5
	ash 3,-1
	add 3,%BADLH(4)
	jumpn 3,%L643
	move 2,1
%L643:
	move 1,2
	popj 17,

global_inc_short16:
	move 1,gp_short16
	addi 1,1
	ibp 1
	popj 17,

volatile_inc_short16:
	move 3,vgp_short16
	move 4,1
	andi 4,1
	ash 1,-1	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L650
%L649:
	ibp 3
	sojn 4,%L649	; decrement_and_branch_until_zero
%L650:
	movem 3,vgp_short16
	move 1,3
	popj 17,

array_start_inc_short16:
	move 1,[POINT 18,arr_short16+7,35]
	popj 17,

index_inc_short16:
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,arr_short16,17]
	jumpe 4,%L657
%L656:
	ibp 3
	sojn 4,%L656	; decrement_and_branch_until_zero
%L657:
	move 4,2
	andi 4,1
	move 1,2
	ash 1,-1	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L660
%L659:
	ibp 1
	sojn 4,%L659	; decrement_and_branch_until_zero
%L660:
	popj 17,

load_after_short16:
	ibp 1
	ldb 1,1
	lsh 1,24
	ash 1,-24
	popj 17,

store_after_short16:
	lsh 2,24
	ash 2,-24
	addi 1,1
	dpb 2,1	; movhi
	popj 17,

diff_after_inc_short16:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L666
%L665:
	ibp 3
	sojn 4,%L665	; decrement_and_branch_until_zero
%L666:
	move 6,3
	sub 6,1
	muli 6,4
	move 1,7
	ash 1,-1
	add 1,%BADLH(6)
	popj 17,

compare_after_inc_short16:
	move 4,3
	andi 4,1
	ash 3,-1	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L672
%L671:
	ibp 1
	sojn 4,%L671	; decrement_and_branch_until_zero
%L672:
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_ushort16:
	.long	arr_ushort16+19629342724
	.align	2
vgp_ushort16:
	.long	arr_ushort16+19629342726

inc_ushort16_0:
	popj 17,

inc_ushort16_1:
	ibp 1
	popj 17,

inc_ushort16_2:
	addi 1,1
	popj 17,

inc_ushort16_3:
	addi 1,1
	ibp 1
	popj 17,

inc_ushort16_4:
	addi 1,2
	popj 17,

inc_ushort16_5:
	addi 1,2
	ibp 1
	popj 17,

inc_ushort16_6:
	addi 1,3
	popj 17,

inc_ushort16_7:
	addi 1,3
	ibp 1
	popj 17,

inc_ushort16_8:
	addi 1,4
	popj 17,

inc_ushort16_9:
	addi 1,4
	ibp 1
	popj 17,

inc_ushort16_10:
	addi 1,5
	popj 17,

inc_ushort16_11:
	addi 1,5
	ibp 1
	popj 17,

inc_ushort16_12:
	addi 1,6
	popj 17,

inc_ushort16_dynamic:
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L691
%L690:
	ibp 1
	sojn 4,%L690	; decrement_and_branch_until_zero
%L691:
	popj 17,

addassign_ushort16:
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L695
%L694:
	ibp 1
	sojn 4,%L694	; decrement_and_branch_until_zero
%L695:
	popj 17,

preinc_ushort16:
	ibp 1
	popj 17,

postinc_ushort16:
	move 2,1
	ibp 2
	move 4,2
	sub 4,1
	muli 4,4
	move 3,5
	ash 3,-1
	add 3,%BADLH(4)
	jumpn 3,%L699
	move 2,1
%L699:
	move 1,2
	popj 17,

global_inc_ushort16:
	move 1,gp_ushort16
	addi 1,1
	ibp 1
	popj 17,

volatile_inc_ushort16:
	move 3,vgp_ushort16
	move 4,1
	andi 4,1
	ash 1,-1	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L706
%L705:
	ibp 3
	sojn 4,%L705	; decrement_and_branch_until_zero
%L706:
	movem 3,vgp_ushort16
	move 1,3
	popj 17,

array_start_inc_ushort16:
	move 1,[POINT 18,arr_ushort16+7,35]
	popj 17,

index_inc_ushort16:
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,arr_ushort16,17]
	jumpe 4,%L713
%L712:
	ibp 3
	sojn 4,%L712	; decrement_and_branch_until_zero
%L713:
	move 4,2
	andi 4,1
	move 1,2
	ash 1,-1	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L716
%L715:
	ibp 1
	sojn 4,%L715	; decrement_and_branch_until_zero
%L716:
	popj 17,

load_after_ushort16:
	ibp 1
	ldb 1,1
	andi 1,177777
	popj 17,

store_after_ushort16:
	andi 2,177777
	addi 1,1
	dpb 2,1	; movhi
	popj 17,

diff_after_inc_ushort16:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L722
%L721:
	ibp 3
	sojn 4,%L721	; decrement_and_branch_until_zero
%L722:
	move 6,3
	sub 6,1
	muli 6,4
	move 1,7
	ash 1,-1
	add 1,%BADLH(6)
	popj 17,

compare_after_inc_ushort16:
	move 4,3
	andi 4,1
	ash 3,-1	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L728
%L727:
	ibp 1
	sojn 4,%L727	; decrement_and_branch_until_zero
%L728:
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_short18:
	.long	arr_short18+19629342724
	.align	2
vgp_short18:
	.long	arr_short18+19629342726

inc_short18_0:
	popj 17,

inc_short18_1:
	ibp 1
	popj 17,

inc_short18_2:
	addi 1,1
	popj 17,

inc_short18_3:
	addi 1,1
	ibp 1
	popj 17,

inc_short18_4:
	addi 1,2
	popj 17,

inc_short18_5:
	addi 1,2
	ibp 1
	popj 17,

inc_short18_6:
	addi 1,3
	popj 17,

inc_short18_7:
	addi 1,3
	ibp 1
	popj 17,

inc_short18_8:
	addi 1,4
	popj 17,

inc_short18_9:
	addi 1,4
	ibp 1
	popj 17,

inc_short18_10:
	addi 1,5
	popj 17,

inc_short18_11:
	addi 1,5
	ibp 1
	popj 17,

inc_short18_12:
	addi 1,6
	popj 17,

inc_short18_dynamic:
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L747
%L746:
	ibp 1
	sojn 4,%L746	; decrement_and_branch_until_zero
%L747:
	popj 17,

addassign_short18:
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L751
%L750:
	ibp 1
	sojn 4,%L750	; decrement_and_branch_until_zero
%L751:
	popj 17,

preinc_short18:
	ibp 1
	popj 17,

postinc_short18:
	move 2,1
	ibp 2
	move 4,2
	sub 4,1
	muli 4,4
	move 3,5
	ash 3,-1
	add 3,%BADLH(4)
	jumpn 3,%L755
	move 2,1
%L755:
	move 1,2
	popj 17,

global_inc_short18:
	move 1,gp_short18
	addi 1,1
	ibp 1
	popj 17,

volatile_inc_short18:
	move 3,vgp_short18
	move 4,1
	andi 4,1
	ash 1,-1	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L762
%L761:
	ibp 3
	sojn 4,%L761	; decrement_and_branch_until_zero
%L762:
	movem 3,vgp_short18
	move 1,3
	popj 17,

array_start_inc_short18:
	move 1,[POINT 18,arr_short18+7,35]
	popj 17,

index_inc_short18:
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,arr_short18,17]
	jumpe 4,%L769
%L768:
	ibp 3
	sojn 4,%L768	; decrement_and_branch_until_zero
%L769:
	move 4,2
	andi 4,1
	move 1,2
	ash 1,-1	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L772
%L771:
	ibp 1
	sojn 4,%L771	; decrement_and_branch_until_zero
%L772:
	popj 17,

load_after_short18:
	ibp 1
	ldb 1,1
	hrre 1,1
	popj 17,

store_after_short18:
	addi 1,1
	dpb 2,1	; movhi
	popj 17,

diff_after_inc_short18:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L778
%L777:
	ibp 3
	sojn 4,%L777	; decrement_and_branch_until_zero
%L778:
	move 6,3
	sub 6,1
	muli 6,4
	move 1,7
	ash 1,-1
	add 1,%BADLH(6)
	popj 17,

compare_after_inc_short18:
	move 4,3
	andi 4,1
	ash 3,-1	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L784
%L783:
	ibp 1
	sojn 4,%L783	; decrement_and_branch_until_zero
%L784:
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_ushort18:
	.long	arr_ushort18+19629342724
	.align	2
vgp_ushort18:
	.long	arr_ushort18+19629342726

inc_ushort18_0:
	popj 17,

inc_ushort18_1:
	ibp 1
	popj 17,

inc_ushort18_2:
	addi 1,1
	popj 17,

inc_ushort18_3:
	addi 1,1
	ibp 1
	popj 17,

inc_ushort18_4:
	addi 1,2
	popj 17,

inc_ushort18_5:
	addi 1,2
	ibp 1
	popj 17,

inc_ushort18_6:
	addi 1,3
	popj 17,

inc_ushort18_7:
	addi 1,3
	ibp 1
	popj 17,

inc_ushort18_8:
	addi 1,4
	popj 17,

inc_ushort18_9:
	addi 1,4
	ibp 1
	popj 17,

inc_ushort18_10:
	addi 1,5
	popj 17,

inc_ushort18_11:
	addi 1,5
	ibp 1
	popj 17,

inc_ushort18_12:
	addi 1,6
	popj 17,

inc_ushort18_dynamic:
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L803
%L802:
	ibp 1
	sojn 4,%L802	; decrement_and_branch_until_zero
%L803:
	popj 17,

addassign_ushort18:
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L807
%L806:
	ibp 1
	sojn 4,%L806	; decrement_and_branch_until_zero
%L807:
	popj 17,

preinc_ushort18:
	ibp 1
	popj 17,

postinc_ushort18:
	move 2,1
	ibp 2
	move 4,2
	sub 4,1
	muli 4,4
	move 3,5
	ash 3,-1
	add 3,%BADLH(4)
	jumpn 3,%L811
	move 2,1
%L811:
	move 1,2
	popj 17,

global_inc_ushort18:
	move 1,gp_ushort18
	addi 1,1
	ibp 1
	popj 17,

volatile_inc_ushort18:
	move 3,vgp_ushort18
	move 4,1
	andi 4,1
	ash 1,-1	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L818
%L817:
	ibp 3
	sojn 4,%L817	; decrement_and_branch_until_zero
%L818:
	movem 3,vgp_ushort18
	move 1,3
	popj 17,

array_start_inc_ushort18:
	move 1,[POINT 18,arr_ushort18+7,35]
	popj 17,

index_inc_ushort18:
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,arr_ushort18,17]
	jumpe 4,%L825
%L824:
	ibp 3
	sojn 4,%L824	; decrement_and_branch_until_zero
%L825:
	move 4,2
	andi 4,1
	move 1,2
	ash 1,-1	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L828
%L827:
	ibp 1
	sojn 4,%L827	; decrement_and_branch_until_zero
%L828:
	popj 17,

load_after_ushort18:
	ibp 1
	ldb 1,1
	popj 17,

store_after_ushort18:
	addi 1,1
	dpb 2,1	; movhi
	popj 17,

diff_after_inc_ushort18:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L834
%L833:
	ibp 3
	sojn 4,%L833	; decrement_and_branch_until_zero
%L834:
	move 6,3
	sub 6,1
	muli 6,4
	move 1,7
	ash 1,-1
	add 1,%BADLH(6)
	popj 17,

compare_after_inc_ushort18:
	move 4,3
	andi 4,1
	ash 3,-1	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L840
%L839:
	ibp 1
	sojn 4,%L839	; decrement_and_branch_until_zero
%L840:
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_Qint:
	.long	arr_Qint+29142024194
	.align	2
vgp_Qint:
	.long	arr_Qint+29142024195

inc_Qint_0:
	popj 17,

inc_Qint_1:
	ibp 1
	popj 17,

inc_Qint_2:
	ibp 1
	ibp 1
	popj 17,

inc_Qint_3:
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_Qint_4:
	addi 1,1
	popj 17,

inc_Qint_5:
	addi 1,1
	ibp 1
	popj 17,

inc_Qint_6:
	addi 1,1
	ibp 1
	ibp 1
	popj 17,

inc_Qint_7:
	addi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_Qint_8:
	addi 1,2
	popj 17,

inc_Qint_9:
	addi 1,2
	ibp 1
	popj 17,

inc_Qint_10:
	addi 1,2
	ibp 1
	ibp 1
	popj 17,

inc_Qint_11:
	addi 1,2
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_Qint_12:
	addi 1,3
	popj 17,

inc_Qint_dynamic:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L859
%L858:
	ibp 1
	sojn 4,%L858	; decrement_and_branch_until_zero
%L859:
	popj 17,

addassign_Qint:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L863
%L862:
	ibp 1
	sojn 4,%L862	; decrement_and_branch_until_zero
%L863:
	popj 17,

preinc_Qint:
	ibp 1
	popj 17,

postinc_Qint:
	ibp 1
	popj 17,

global_inc_Qint:
	move 1,gp_Qint
	ibp 1
	ibp 1
	ibp 1
	popj 17,

volatile_inc_Qint:
	move 3,vgp_Qint
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L874
%L873:
	ibp 3
	sojn 4,%L873	; decrement_and_branch_until_zero
%L874:
	movem 3,vgp_Qint
	move 1,3
	popj 17,

array_start_inc_Qint:
	move 1,[POINT 9,arr_Qint+3,35]
	popj 17,

index_inc_Qint:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,arr_Qint,8]
	jumpe 4,%L881
%L880:
	ibp 3
	sojn 4,%L880	; decrement_and_branch_until_zero
%L881:
	move 4,2
	andi 4,3
	move 1,2
	ash 1,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L884
%L883:
	ibp 1
	sojn 4,%L883	; decrement_and_branch_until_zero
%L884:
	popj 17,

load_after_Qint:
	ildb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

store_after_Qint:
	ibp 1
	idpb 2,1
	popj 17,

diff_after_inc_Qint:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L890
%L889:
	ibp 3
	sojn 4,%L889	; decrement_and_branch_until_zero
%L890:
	move 6,3
	sub 6,1
	muli 6,10
	move 1,7
	ash 1,-1
	add 1,%BADL9(6)
	popj 17,

compare_after_inc_Qint:
	move 4,3
	andi 4,3
	ash 3,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L896
%L895:
	ibp 1
	sojn 4,%L895	; decrement_and_branch_until_zero
%L896:
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_uQint:
	.long	arr_uQint+29142024194
	.align	2
vgp_uQint:
	.long	arr_uQint+29142024195

inc_uQint_0:
	popj 17,

inc_uQint_1:
	ibp 1
	popj 17,

inc_uQint_2:
	ibp 1
	ibp 1
	popj 17,

inc_uQint_3:
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_uQint_4:
	addi 1,1
	popj 17,

inc_uQint_5:
	addi 1,1
	ibp 1
	popj 17,

inc_uQint_6:
	addi 1,1
	ibp 1
	ibp 1
	popj 17,

inc_uQint_7:
	addi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_uQint_8:
	addi 1,2
	popj 17,

inc_uQint_9:
	addi 1,2
	ibp 1
	popj 17,

inc_uQint_10:
	addi 1,2
	ibp 1
	ibp 1
	popj 17,

inc_uQint_11:
	addi 1,2
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_uQint_12:
	addi 1,3
	popj 17,

inc_uQint_dynamic:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L915
%L914:
	ibp 1
	sojn 4,%L914	; decrement_and_branch_until_zero
%L915:
	popj 17,

addassign_uQint:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L919
%L918:
	ibp 1
	sojn 4,%L918	; decrement_and_branch_until_zero
%L919:
	popj 17,

preinc_uQint:
	ibp 1
	popj 17,

postinc_uQint:
	ibp 1
	popj 17,

global_inc_uQint:
	move 1,gp_uQint
	ibp 1
	ibp 1
	ibp 1
	popj 17,

volatile_inc_uQint:
	move 3,vgp_uQint
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L930
%L929:
	ibp 3
	sojn 4,%L929	; decrement_and_branch_until_zero
%L930:
	movem 3,vgp_uQint
	move 1,3
	popj 17,

array_start_inc_uQint:
	move 1,[POINT 9,arr_uQint+3,35]
	popj 17,

index_inc_uQint:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,arr_uQint,8]
	jumpe 4,%L937
%L936:
	ibp 3
	sojn 4,%L936	; decrement_and_branch_until_zero
%L937:
	move 4,2
	andi 4,3
	move 1,2
	ash 1,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L940
%L939:
	ibp 1
	sojn 4,%L939	; decrement_and_branch_until_zero
%L940:
	popj 17,

load_after_uQint:
	ildb 1,1
	popj 17,

store_after_uQint:
	ibp 1
	idpb 2,1
	popj 17,

diff_after_inc_uQint:
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L946
%L945:
	ibp 3
	sojn 4,%L945	; decrement_and_branch_until_zero
%L946:
	move 6,3
	sub 6,1
	muli 6,10
	move 1,7
	ash 1,-1
	add 1,%BADL9(6)
	popj 17,

compare_after_inc_uQint:
	move 4,3
	andi 4,3
	ash 3,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L952
%L951:
	ibp 1
	sojn 4,%L951	; decrement_and_branch_until_zero
%L952:
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_Hint:
	.long	arr_Hint+19629342724
	.align	2
vgp_Hint:
	.long	arr_Hint+19629342726

inc_Hint_0:
	popj 17,

inc_Hint_1:
	ibp 1
	popj 17,

inc_Hint_2:
	addi 1,1
	popj 17,

inc_Hint_3:
	addi 1,1
	ibp 1
	popj 17,

inc_Hint_4:
	addi 1,2
	popj 17,

inc_Hint_5:
	addi 1,2
	ibp 1
	popj 17,

inc_Hint_6:
	addi 1,3
	popj 17,

inc_Hint_7:
	addi 1,3
	ibp 1
	popj 17,

inc_Hint_8:
	addi 1,4
	popj 17,

inc_Hint_9:
	addi 1,4
	ibp 1
	popj 17,

inc_Hint_10:
	addi 1,5
	popj 17,

inc_Hint_11:
	addi 1,5
	ibp 1
	popj 17,

inc_Hint_12:
	addi 1,6
	popj 17,

inc_Hint_dynamic:
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L971
%L970:
	ibp 1
	sojn 4,%L970	; decrement_and_branch_until_zero
%L971:
	popj 17,

addassign_Hint:
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L975
%L974:
	ibp 1
	sojn 4,%L974	; decrement_and_branch_until_zero
%L975:
	popj 17,

preinc_Hint:
	ibp 1
	popj 17,

postinc_Hint:
	move 2,1
	ibp 2
	move 4,2
	sub 4,1
	muli 4,4
	move 3,5
	ash 3,-1
	add 3,%BADLH(4)
	jumpn 3,%L979
	move 2,1
%L979:
	move 1,2
	popj 17,

global_inc_Hint:
	move 1,gp_Hint
	addi 1,1
	ibp 1
	popj 17,

volatile_inc_Hint:
	move 3,vgp_Hint
	move 4,1
	andi 4,1
	ash 1,-1	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L986
%L985:
	ibp 3
	sojn 4,%L985	; decrement_and_branch_until_zero
%L986:
	movem 3,vgp_Hint
	move 1,3
	popj 17,

array_start_inc_Hint:
	move 1,[POINT 18,arr_Hint+7,35]
	popj 17,

index_inc_Hint:
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,arr_Hint,17]
	jumpe 4,%L993
%L992:
	ibp 3
	sojn 4,%L992	; decrement_and_branch_until_zero
%L993:
	move 4,2
	andi 4,1
	move 1,2
	ash 1,-1	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L996
%L995:
	ibp 1
	sojn 4,%L995	; decrement_and_branch_until_zero
%L996:
	popj 17,

load_after_Hint:
	ibp 1
	ldb 1,1
	hrre 1,1
	popj 17,

store_after_Hint:
	addi 1,1
	dpb 2,1	; movhi
	popj 17,

diff_after_inc_Hint:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L1002
%L1001:
	ibp 3
	sojn 4,%L1001	; decrement_and_branch_until_zero
%L1002:
	move 6,3
	sub 6,1
	muli 6,4
	move 1,7
	ash 1,-1
	add 1,%BADLH(6)
	popj 17,

compare_after_inc_Hint:
	move 4,3
	andi 4,1
	ash 3,-1	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L1008
%L1007:
	ibp 1
	sojn 4,%L1007	; decrement_and_branch_until_zero
%L1008:
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_uHint:
	.long	arr_uHint+19629342724
	.align	2
vgp_uHint:
	.long	arr_uHint+19629342726

inc_uHint_0:
	popj 17,

inc_uHint_1:
	ibp 1
	popj 17,

inc_uHint_2:
	addi 1,1
	popj 17,

inc_uHint_3:
	addi 1,1
	ibp 1
	popj 17,

inc_uHint_4:
	addi 1,2
	popj 17,

inc_uHint_5:
	addi 1,2
	ibp 1
	popj 17,

inc_uHint_6:
	addi 1,3
	popj 17,

inc_uHint_7:
	addi 1,3
	ibp 1
	popj 17,

inc_uHint_8:
	addi 1,4
	popj 17,

inc_uHint_9:
	addi 1,4
	ibp 1
	popj 17,

inc_uHint_10:
	addi 1,5
	popj 17,

inc_uHint_11:
	addi 1,5
	ibp 1
	popj 17,

inc_uHint_12:
	addi 1,6
	popj 17,

inc_uHint_dynamic:
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1027
%L1026:
	ibp 1
	sojn 4,%L1026	; decrement_and_branch_until_zero
%L1027:
	popj 17,

addassign_uHint:
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1031
%L1030:
	ibp 1
	sojn 4,%L1030	; decrement_and_branch_until_zero
%L1031:
	popj 17,

preinc_uHint:
	ibp 1
	popj 17,

postinc_uHint:
	move 2,1
	ibp 2
	move 4,2
	sub 4,1
	muli 4,4
	move 3,5
	ash 3,-1
	add 3,%BADLH(4)
	jumpn 3,%L1035
	move 2,1
%L1035:
	move 1,2
	popj 17,

global_inc_uHint:
	move 1,gp_uHint
	addi 1,1
	ibp 1
	popj 17,

volatile_inc_uHint:
	move 3,vgp_uHint
	move 4,1
	andi 4,1
	ash 1,-1	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L1042
%L1041:
	ibp 3
	sojn 4,%L1041	; decrement_and_branch_until_zero
%L1042:
	movem 3,vgp_uHint
	move 1,3
	popj 17,

array_start_inc_uHint:
	move 1,[POINT 18,arr_uHint+7,35]
	popj 17,

index_inc_uHint:
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,arr_uHint,17]
	jumpe 4,%L1049
%L1048:
	ibp 3
	sojn 4,%L1048	; decrement_and_branch_until_zero
%L1049:
	move 4,2
	andi 4,1
	move 1,2
	ash 1,-1	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L1052
%L1051:
	ibp 1
	sojn 4,%L1051	; decrement_and_branch_until_zero
%L1052:
	popj 17,

load_after_uHint:
	ibp 1
	ldb 1,1
	popj 17,

store_after_uHint:
	addi 1,1
	dpb 2,1	; movhi
	popj 17,

diff_after_inc_uHint:
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L1058
%L1057:
	ibp 3
	sojn 4,%L1057	; decrement_and_branch_until_zero
%L1058:
	move 6,3
	sub 6,1
	muli 6,4
	move 1,7
	ash 1,-1
	add 1,%BADLH(6)
	popj 17,

compare_after_inc_uHint:
	move 4,3
	andi 4,1
	ash 3,-1	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L1064
%L1063:
	ibp 1
	sojn 4,%L1063	; decrement_and_branch_until_zero
%L1064:
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_Sint:
	.long	arr_Sint+8
	.align	2
vgp_Sint:
	.long	arr_Sint+12

inc_Sint_0:
	popj 17,

inc_Sint_1:
	addi 1,1
	popj 17,

inc_Sint_2:
	addi 1,2
	popj 17,

inc_Sint_3:
	addi 1,3
	popj 17,

inc_Sint_4:
	addi 1,4
	popj 17,

inc_Sint_5:
	addi 1,5
	popj 17,

inc_Sint_6:
	addi 1,6
	popj 17,

inc_Sint_7:
	addi 1,7
	popj 17,

inc_Sint_8:
	addi 1,10
	popj 17,

inc_Sint_9:
	addi 1,11
	popj 17,

inc_Sint_10:
	addi 1,12
	popj 17,

inc_Sint_11:
	addi 1,13
	popj 17,

inc_Sint_12:
	addi 1,14
	popj 17,

inc_Sint_dynamic:
	add 1,2
	popj 17,

addassign_Sint:
	add 1,2
	popj 17,

preinc_Sint:
	addi 1,1
	popj 17,

postinc_Sint:
	move 3,1
	aos 4,3
	sub 4,1
	jumpn 4,%L1087
	move 3,1
%L1087:
	move 1,3
	popj 17,

global_inc_Sint:
	move 1,gp_Sint
	addi 1,3
	popj 17,

volatile_inc_Sint:
	move 4,1
	move 1,vgp_Sint
	add 1,4
	movem 1,vgp_Sint
	popj 17,

array_start_inc_Sint:
	movei 1,arr_Sint+17
	popj 17,

index_inc_Sint:
	xmovei 1,arr_Sint(1)
	add 1,2
	popj 17,

load_after_Sint:
	move 1,1(1)
	popj 17,

store_after_Sint:
	movem 2,2(1)
	popj 17,

diff_after_inc_Sint:
	move 1,2
	popj 17,

compare_after_inc_Sint:
	add 1,3
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_uSint:
	.long	arr_uSint+8
	.align	2
vgp_uSint:
	.long	arr_uSint+12

inc_uSint_0:
	popj 17,

inc_uSint_1:
	addi 1,1
	popj 17,

inc_uSint_2:
	addi 1,2
	popj 17,

inc_uSint_3:
	addi 1,3
	popj 17,

inc_uSint_4:
	addi 1,4
	popj 17,

inc_uSint_5:
	addi 1,5
	popj 17,

inc_uSint_6:
	addi 1,6
	popj 17,

inc_uSint_7:
	addi 1,7
	popj 17,

inc_uSint_8:
	addi 1,10
	popj 17,

inc_uSint_9:
	addi 1,11
	popj 17,

inc_uSint_10:
	addi 1,12
	popj 17,

inc_uSint_11:
	addi 1,13
	popj 17,

inc_uSint_12:
	addi 1,14
	popj 17,

inc_uSint_dynamic:
	add 1,2
	popj 17,

addassign_uSint:
	add 1,2
	popj 17,

preinc_uSint:
	addi 1,1
	popj 17,

postinc_uSint:
	move 3,1
	aos 4,3
	sub 4,1
	jumpn 4,%L1129
	move 3,1
%L1129:
	move 1,3
	popj 17,

global_inc_uSint:
	move 1,gp_uSint
	addi 1,3
	popj 17,

volatile_inc_uSint:
	move 4,1
	move 1,vgp_uSint
	add 1,4
	movem 1,vgp_uSint
	popj 17,

array_start_inc_uSint:
	movei 1,arr_uSint+17
	popj 17,

index_inc_uSint:
	xmovei 1,arr_uSint(1)
	add 1,2
	popj 17,

load_after_uSint:
	move 1,1(1)
	popj 17,

store_after_uSint:
	movem 2,2(1)
	popj 17,

diff_after_inc_uSint:
	move 1,2
	popj 17,

compare_after_inc_uSint:
	add 1,3
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_Dint:
	.long	arr_Dint+16
	.align	2
vgp_Dint:
	.long	arr_Dint+24

inc_Dint_0:
	popj 17,

inc_Dint_1:
	addi 1,2
	popj 17,

inc_Dint_2:
	addi 1,4
	popj 17,

inc_Dint_3:
	addi 1,6
	popj 17,

inc_Dint_4:
	addi 1,10
	popj 17,

inc_Dint_5:
	addi 1,12
	popj 17,

inc_Dint_6:
	addi 1,14
	popj 17,

inc_Dint_7:
	addi 1,16
	popj 17,

inc_Dint_8:
	addi 1,20
	popj 17,

inc_Dint_9:
	addi 1,22
	popj 17,

inc_Dint_10:
	addi 1,24
	popj 17,

inc_Dint_11:
	addi 1,26
	popj 17,

inc_Dint_12:
	addi 1,30
	popj 17,

inc_Dint_dynamic:
	lsh 2,1
	add 1,2
	popj 17,

addassign_Dint:
	lsh 2,1
	add 1,2
	popj 17,

preinc_Dint:
	addi 1,2
	popj 17,

postinc_Dint:
	move 3,1
	addi 3,2
	move 4,3
	sub 4,1
	ash 4,-1
	jumpn 4,%L1171
	move 3,1
%L1171:
	move 1,3
	popj 17,

global_inc_Dint:
	move 1,gp_Dint
	addi 1,6
	popj 17,

volatile_inc_Dint:
	move 4,1
	move 1,vgp_Dint
	lsh 4,1
	add 1,4
	movem 1,vgp_Dint
	popj 17,

array_start_inc_Dint:
	movei 1,arr_Dint+36
	popj 17,

index_inc_Dint:
	lsh 1,1
	xmovei 1,arr_Dint(1)
	lsh 2,1
	add 1,2
	popj 17,

load_after_Dint:
	move 4,2(1)
	move 5,3(1)
	move 1,4
	move 2,5
	popj 17,

store_after_Dint:
	movem 2,4(1)
	movem 3,5(1)
	popj 17,

diff_after_inc_Dint:
	lsh 2,1
	ash 2,-1
	move 1,2
	popj 17,

compare_after_inc_Dint:
	lsh 3,1
	add 1,3
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_uDint:
	.long	arr_uDint+16
	.align	2
vgp_uDint:
	.long	arr_uDint+24

inc_uDint_0:
	popj 17,

inc_uDint_1:
	addi 1,2
	popj 17,

inc_uDint_2:
	addi 1,4
	popj 17,

inc_uDint_3:
	addi 1,6
	popj 17,

inc_uDint_4:
	addi 1,10
	popj 17,

inc_uDint_5:
	addi 1,12
	popj 17,

inc_uDint_6:
	addi 1,14
	popj 17,

inc_uDint_7:
	addi 1,16
	popj 17,

inc_uDint_8:
	addi 1,20
	popj 17,

inc_uDint_9:
	addi 1,22
	popj 17,

inc_uDint_10:
	addi 1,24
	popj 17,

inc_uDint_11:
	addi 1,26
	popj 17,

inc_uDint_12:
	addi 1,30
	popj 17,

inc_uDint_dynamic:
	lsh 2,1
	add 1,2
	popj 17,

addassign_uDint:
	lsh 2,1
	add 1,2
	popj 17,

preinc_uDint:
	addi 1,2
	popj 17,

postinc_uDint:
	move 3,1
	addi 3,2
	move 4,3
	sub 4,1
	ash 4,-1
	jumpn 4,%L1213
	move 3,1
%L1213:
	move 1,3
	popj 17,

global_inc_uDint:
	move 1,gp_uDint
	addi 1,6
	popj 17,

volatile_inc_uDint:
	move 4,1
	move 1,vgp_uDint
	lsh 4,1
	add 1,4
	movem 1,vgp_uDint
	popj 17,

array_start_inc_uDint:
	movei 1,arr_uDint+36
	popj 17,

index_inc_uDint:
	lsh 1,1
	xmovei 1,arr_uDint(1)
	lsh 2,1
	add 1,2
	popj 17,

load_after_uDint:
	move 4,2(1)
	move 5,3(1)
	move 1,4
	move 2,5
	popj 17,

store_after_uDint:
	movem 2,4(1)
	movem 3,5(1)
	popj 17,

diff_after_inc_uDint:
	lsh 2,1
	ash 2,-1
	move 1,2
	popj 17,

compare_after_inc_uDint:
	lsh 3,1
	add 1,3
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_Qint3:
	.long	arr_Qint3+29142024198
	.align	2
vgp_Qint3:
	.long	arr_Qint3+29142024201

inc_Qint3_0:
	popj 17,

inc_Qint3_1:
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_Qint3_2:
	addi 1,1
	ibp 1
	ibp 1
	popj 17,

inc_Qint3_3:
	addi 1,2
	ibp 1
	popj 17,

inc_Qint3_4:
	addi 1,3
	popj 17,

inc_Qint3_5:
	addi 1,3
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_Qint3_6:
	addi 1,4
	ibp 1
	ibp 1
	popj 17,

inc_Qint3_7:
	addi 1,5
	ibp 1
	popj 17,

inc_Qint3_8:
	addi 1,6
	popj 17,

inc_Qint3_9:
	addi 1,6
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_Qint3_10:
	addi 1,7
	ibp 1
	ibp 1
	popj 17,

inc_Qint3_11:
	addi 1,10
	ibp 1
	popj 17,

inc_Qint3_12:
	addi 1,11
	popj 17,

inc_Qint3_dynamic:
	move 4,2
	lsh 4,1
	add 4,2
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1251
%L1250:
	ibp 1
	sojn 3,%L1250	; decrement_and_branch_until_zero
%L1251:
	popj 17,

addassign_Qint3:
	move 4,2
	lsh 4,1
	add 4,2
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1255
%L1254:
	ibp 1
	sojn 3,%L1254	; decrement_and_branch_until_zero
%L1255:
	popj 17,

preinc_Qint3:
	ibp 1
	ibp 1
	ibp 1
	popj 17,

postinc_Qint3:
	setzb 4,5
	move 2,1
	push 17,0
	movei 0,3
	ibp 2
	sojg 0,.-1
	pop 17,0
	move 6,2
	sub 6,1
	muli 6,10
	move 3,7
	ash 3,-1
	move 4,3
	add 4,%BADL9(6)
	idivi 4,3
	jumpn 4,%L1259
	move 2,1
%L1259:
	move 1,2
	popj 17,

global_inc_Qint3:
	move 1,gp_Qint3
	addi 1,2
	ibp 1
	popj 17,

volatile_inc_Qint3:
	move 2,vgp_Qint3
	move 4,1
	lsh 4,1
	add 4,1
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 2,4
	jumpe 3,%L1266
%L1265:
	ibp 2
	sojn 3,%L1265	; decrement_and_branch_until_zero
%L1266:
	movem 2,vgp_Qint3
	move 1,2
	popj 17,

array_start_inc_Qint3:
	move 1,[POINT 9,arr_Qint3+13,17]
	popj 17,

index_inc_Qint3:
	move 4,1
	lsh 4,1
	add 4,1
	move 3,4
	andi 3,3
	move 6,4
	ash 6,-2	; ashrsi3_pointer
	add 6,[POINT 9,arr_Qint3,8]
	jumpe 3,%L1273
%L1272:
	ibp 6
	sojn 3,%L1272	; decrement_and_branch_until_zero
%L1273:
	move 4,2
	lsh 4,1
	add 4,2
	move 3,4
	andi 3,3
	move 1,4
	ash 1,-2	; ashrsi3_pointer
	add 1,6
	jumpe 3,%L1276
%L1275:
	ibp 1
	sojn 3,%L1275	; decrement_and_branch_until_zero
%L1276:
	popj 17,

load_after_Qint3:
	move 4,1
	ibp 4
	ibp 4
	ibp 4
	move 1,(4)
	lsh 1,-11
	and 1,[777000000]
	ldb 3,[POINT 9,(4),17]
	dpb 3,[POINT 9,1,26]
	ldb 4,[POINT 9,(4),26]
	dpb 4,[POINT 9,1,35]
	popj 17,

store_after_Qint3:
	add 17,[1,,1]
	lsh 2,11
	movem 2,(17)
	addi 1,1
	ibp 1
	ibp 1
	movei 2,(17)
	tlo 2,331100
	movei 3,3
	pushj 17,memcpy
	add 17,[-1,,-1]
	popj 17,

diff_after_inc_Qint3:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setzb 6,7
	move 4,2
	lsh 4,1
	add 4,2
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 4,1
	jumpe 3,%L1284
%L1283:
	ibp 4
	sojn 3,%L1283	; decrement_and_branch_until_zero
%L1284:
	move 10,4
	sub 10,1
	muli 10,10
	move 4,11
	ash 4,-1
	move 6,4
	add 6,%BADL9(10)
	idivi 6,3
	move 1,6
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

compare_after_inc_Qint3:
	move 4,3
	lsh 4,1
	add 4,3
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1290
%L1289:
	ibp 1
	sojn 3,%L1289	; decrement_and_branch_until_zero
%L1290:
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_uQint3:
	.long	arr_uQint3+29142024198
	.align	2
vgp_uQint3:
	.long	arr_uQint3+29142024201

inc_uQint3_0:
	popj 17,

inc_uQint3_1:
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_uQint3_2:
	addi 1,1
	ibp 1
	ibp 1
	popj 17,

inc_uQint3_3:
	addi 1,2
	ibp 1
	popj 17,

inc_uQint3_4:
	addi 1,3
	popj 17,

inc_uQint3_5:
	addi 1,3
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_uQint3_6:
	addi 1,4
	ibp 1
	ibp 1
	popj 17,

inc_uQint3_7:
	addi 1,5
	ibp 1
	popj 17,

inc_uQint3_8:
	addi 1,6
	popj 17,

inc_uQint3_9:
	addi 1,6
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_uQint3_10:
	addi 1,7
	ibp 1
	ibp 1
	popj 17,

inc_uQint3_11:
	addi 1,10
	ibp 1
	popj 17,

inc_uQint3_12:
	addi 1,11
	popj 17,

inc_uQint3_dynamic:
	move 4,2
	lsh 4,1
	add 4,2
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1309
%L1308:
	ibp 1
	sojn 3,%L1308	; decrement_and_branch_until_zero
%L1309:
	popj 17,

addassign_uQint3:
	move 4,2
	lsh 4,1
	add 4,2
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1313
%L1312:
	ibp 1
	sojn 3,%L1312	; decrement_and_branch_until_zero
%L1313:
	popj 17,

preinc_uQint3:
	ibp 1
	ibp 1
	ibp 1
	popj 17,

postinc_uQint3:
	setzb 4,5
	move 2,1
	push 17,0
	movei 0,3
	ibp 2
	sojg 0,.-1
	pop 17,0
	move 6,2
	sub 6,1
	muli 6,10
	move 3,7
	ash 3,-1
	move 4,3
	add 4,%BADL9(6)
	idivi 4,3
	jumpn 4,%L1317
	move 2,1
%L1317:
	move 1,2
	popj 17,

global_inc_uQint3:
	move 1,gp_uQint3
	addi 1,2
	ibp 1
	popj 17,

volatile_inc_uQint3:
	move 2,vgp_uQint3
	move 4,1
	lsh 4,1
	add 4,1
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 2,4
	jumpe 3,%L1324
%L1323:
	ibp 2
	sojn 3,%L1323	; decrement_and_branch_until_zero
%L1324:
	movem 2,vgp_uQint3
	move 1,2
	popj 17,

array_start_inc_uQint3:
	move 1,[POINT 9,arr_uQint3+13,17]
	popj 17,

index_inc_uQint3:
	move 4,1
	lsh 4,1
	add 4,1
	move 3,4
	andi 3,3
	move 6,4
	ash 6,-2	; ashrsi3_pointer
	add 6,[POINT 9,arr_uQint3,8]
	jumpe 3,%L1331
%L1330:
	ibp 6
	sojn 3,%L1330	; decrement_and_branch_until_zero
%L1331:
	move 4,2
	lsh 4,1
	add 4,2
	move 3,4
	andi 3,3
	move 1,4
	ash 1,-2	; ashrsi3_pointer
	add 1,6
	jumpe 3,%L1334
%L1333:
	ibp 1
	sojn 3,%L1333	; decrement_and_branch_until_zero
%L1334:
	popj 17,

load_after_uQint3:
	move 4,1
	ibp 4
	ibp 4
	ibp 4
	move 1,(4)
	lsh 1,-11
	and 1,[777000000]
	ldb 3,[POINT 9,(4),17]
	dpb 3,[POINT 9,1,26]
	ldb 4,[POINT 9,(4),26]
	dpb 4,[POINT 9,1,35]
	popj 17,

store_after_uQint3:
	add 17,[1,,1]
	lsh 2,11
	movem 2,(17)
	addi 1,1
	ibp 1
	ibp 1
	movei 2,(17)
	tlo 2,331100
	movei 3,3
	pushj 17,memcpy
	add 17,[-1,,-1]
	popj 17,

diff_after_inc_uQint3:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setzb 6,7
	move 4,2
	lsh 4,1
	add 4,2
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 4,1
	jumpe 3,%L1342
%L1341:
	ibp 4
	sojn 3,%L1341	; decrement_and_branch_until_zero
%L1342:
	move 10,4
	sub 10,1
	muli 10,10
	move 4,11
	ash 4,-1
	move 6,4
	add 6,%BADL9(10)
	idivi 6,3
	move 1,6
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

compare_after_inc_uQint3:
	move 4,3
	lsh 4,1
	add 4,3
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1348
%L1347:
	ibp 1
	sojn 3,%L1347	; decrement_and_branch_until_zero
%L1348:
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_Hint3:
	.long	arr_Hint3+19629342732
	.align	2
vgp_Hint3:
	.long	arr_Hint3+19629342738

inc_Hint3_0:
	popj 17,

inc_Hint3_1:
	addi 1,1
	ibp 1
	popj 17,

inc_Hint3_2:
	addi 1,3
	popj 17,

inc_Hint3_3:
	addi 1,4
	ibp 1
	popj 17,

inc_Hint3_4:
	addi 1,6
	popj 17,

inc_Hint3_5:
	addi 1,7
	ibp 1
	popj 17,

inc_Hint3_6:
	addi 1,11
	popj 17,

inc_Hint3_7:
	addi 1,12
	ibp 1
	popj 17,

inc_Hint3_8:
	addi 1,14
	popj 17,

inc_Hint3_9:
	addi 1,15
	ibp 1
	popj 17,

inc_Hint3_10:
	addi 1,17
	popj 17,

inc_Hint3_11:
	addi 1,20
	ibp 1
	popj 17,

inc_Hint3_12:
	addi 1,22
	popj 17,

inc_Hint3_dynamic:
	move 4,2
	lsh 4,1
	add 4,2
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1367
%L1366:
	ibp 1
	sojn 3,%L1366	; decrement_and_branch_until_zero
%L1367:
	popj 17,

addassign_Hint3:
	move 4,2
	lsh 4,1
	add 4,2
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1371
%L1370:
	ibp 1
	sojn 3,%L1370	; decrement_and_branch_until_zero
%L1371:
	popj 17,

preinc_Hint3:
	addi 1,1
	ibp 1
	popj 17,

postinc_Hint3:
	setzb 4,5
	move 2,1
	push 17,0
	movei 0,3
	ibp 2
	sojg 0,.-1
	pop 17,0
	move 6,2
	sub 6,1
	muli 6,4
	move 3,7
	ash 3,-1
	add 3,%BADLH(6)
	move 4,3
	idivi 4,3
	jumpn 4,%L1375
	move 2,1
%L1375:
	move 1,2
	popj 17,

global_inc_Hint3:
	move 1,gp_Hint3
	addi 1,4
	ibp 1
	popj 17,

volatile_inc_Hint3:
	move 2,vgp_Hint3
	move 4,1
	lsh 4,1
	add 4,1
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 2,4
	jumpe 3,%L1382
%L1381:
	ibp 2
	sojn 3,%L1381	; decrement_and_branch_until_zero
%L1382:
	movem 2,vgp_Hint3
	move 1,2
	popj 17,

array_start_inc_Hint3:
	move 1,[POINT 18,arr_Hint3+26,35]
	popj 17,

index_inc_Hint3:
	move 4,1
	lsh 4,1
	add 4,1
	move 3,4
	andi 3,1
	move 6,4
	ash 6,-1	; ashrsi3_pointer
	add 6,[POINT 18,arr_Hint3,17]
	jumpe 3,%L1389
%L1388:
	ibp 6
	sojn 3,%L1388	; decrement_and_branch_until_zero
%L1389:
	move 4,2
	lsh 4,1
	add 4,2
	move 3,4
	andi 3,1
	move 1,4
	ash 1,-1	; ashrsi3_pointer
	add 1,6
	jumpe 3,%L1392
%L1391:
	ibp 1
	sojn 3,%L1391	; decrement_and_branch_until_zero
%L1392:
	popj 17,

load_after_Hint3:
	addi 1,1
	ibp 1
	hlrz 2,(1)
	ldb 5,[POINT 9,(1),17]
	andi 2,777000
	ldb 4,[POINT 9,(1),26]
	lsh 4,33
	ldb 3,[POINT 9,(1),35]
	dpb 3,[POINT 9,4,17]
	move 3,1(1)
	lsh 3,-33
	dpb 3,[POINT 9,4,26]
	ldb 3,[POINT 9,1(1),17]
	dpb 3,[POINT 9,4,35]
	move 6,2
	ior 6,5
	move 7,4
	move 1,6
	move 2,7
	popj 17,

store_after_Hint3:
	addi 1,3
	movei 2,-2(17)
	tlc 2,113300
	movei 3,6
	pushj 17,memcpy
	popj 17,

diff_after_inc_Hint3:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setzb 6,7
	move 4,2
	lsh 4,1
	add 4,2
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 4,1
	jumpe 3,%L1400
%L1399:
	ibp 4
	sojn 3,%L1399	; decrement_and_branch_until_zero
%L1400:
	move 10,4
	sub 10,1
	muli 10,4
	move 4,11
	ash 4,-1
	add 4,%BADLH(10)
	move 6,4
	idivi 6,3
	move 1,6
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

compare_after_inc_Hint3:
	move 4,3
	lsh 4,1
	add 4,3
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1406
%L1405:
	ibp 1
	sojn 3,%L1405	; decrement_and_branch_until_zero
%L1406:
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_uHint3:
	.long	arr_uHint3+19629342732
	.align	2
vgp_uHint3:
	.long	arr_uHint3+19629342738

inc_uHint3_0:
	popj 17,

inc_uHint3_1:
	addi 1,1
	ibp 1
	popj 17,

inc_uHint3_2:
	addi 1,3
	popj 17,

inc_uHint3_3:
	addi 1,4
	ibp 1
	popj 17,

inc_uHint3_4:
	addi 1,6
	popj 17,

inc_uHint3_5:
	addi 1,7
	ibp 1
	popj 17,

inc_uHint3_6:
	addi 1,11
	popj 17,

inc_uHint3_7:
	addi 1,12
	ibp 1
	popj 17,

inc_uHint3_8:
	addi 1,14
	popj 17,

inc_uHint3_9:
	addi 1,15
	ibp 1
	popj 17,

inc_uHint3_10:
	addi 1,17
	popj 17,

inc_uHint3_11:
	addi 1,20
	ibp 1
	popj 17,

inc_uHint3_12:
	addi 1,22
	popj 17,

inc_uHint3_dynamic:
	move 4,2
	lsh 4,1
	add 4,2
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1425
%L1424:
	ibp 1
	sojn 3,%L1424	; decrement_and_branch_until_zero
%L1425:
	popj 17,

addassign_uHint3:
	move 4,2
	lsh 4,1
	add 4,2
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1429
%L1428:
	ibp 1
	sojn 3,%L1428	; decrement_and_branch_until_zero
%L1429:
	popj 17,

preinc_uHint3:
	addi 1,1
	ibp 1
	popj 17,

postinc_uHint3:
	setzb 4,5
	move 2,1
	push 17,0
	movei 0,3
	ibp 2
	sojg 0,.-1
	pop 17,0
	move 6,2
	sub 6,1
	muli 6,4
	move 3,7
	ash 3,-1
	add 3,%BADLH(6)
	move 4,3
	idivi 4,3
	jumpn 4,%L1433
	move 2,1
%L1433:
	move 1,2
	popj 17,

global_inc_uHint3:
	move 1,gp_uHint3
	addi 1,4
	ibp 1
	popj 17,

volatile_inc_uHint3:
	move 2,vgp_uHint3
	move 4,1
	lsh 4,1
	add 4,1
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 2,4
	jumpe 3,%L1440
%L1439:
	ibp 2
	sojn 3,%L1439	; decrement_and_branch_until_zero
%L1440:
	movem 2,vgp_uHint3
	move 1,2
	popj 17,

array_start_inc_uHint3:
	move 1,[POINT 18,arr_uHint3+26,35]
	popj 17,

index_inc_uHint3:
	move 4,1
	lsh 4,1
	add 4,1
	move 3,4
	andi 3,1
	move 6,4
	ash 6,-1	; ashrsi3_pointer
	add 6,[POINT 18,arr_uHint3,17]
	jumpe 3,%L1447
%L1446:
	ibp 6
	sojn 3,%L1446	; decrement_and_branch_until_zero
%L1447:
	move 4,2
	lsh 4,1
	add 4,2
	move 3,4
	andi 3,1
	move 1,4
	ash 1,-1	; ashrsi3_pointer
	add 1,6
	jumpe 3,%L1450
%L1449:
	ibp 1
	sojn 3,%L1449	; decrement_and_branch_until_zero
%L1450:
	popj 17,

load_after_uHint3:
	addi 1,1
	ibp 1
	hlrz 2,(1)
	ldb 5,[POINT 9,(1),17]
	andi 2,777000
	ldb 4,[POINT 9,(1),26]
	lsh 4,33
	ldb 3,[POINT 9,(1),35]
	dpb 3,[POINT 9,4,17]
	move 3,1(1)
	lsh 3,-33
	dpb 3,[POINT 9,4,26]
	ldb 3,[POINT 9,1(1),17]
	dpb 3,[POINT 9,4,35]
	move 6,2
	ior 6,5
	move 7,4
	move 1,6
	move 2,7
	popj 17,

store_after_uHint3:
	addi 1,3
	movei 2,-2(17)
	tlc 2,113300
	movei 3,6
	pushj 17,memcpy
	popj 17,

diff_after_inc_uHint3:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setzb 6,7
	move 4,2
	lsh 4,1
	add 4,2
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 4,1
	jumpe 3,%L1458
%L1457:
	ibp 4
	sojn 3,%L1457	; decrement_and_branch_until_zero
%L1458:
	move 10,4
	sub 10,1
	muli 10,4
	move 4,11
	ash 4,-1
	add 4,%BADLH(10)
	move 6,4
	idivi 6,3
	move 1,6
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

compare_after_inc_uHint3:
	move 4,3
	lsh 4,1
	add 4,3
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1464
%L1463:
	ibp 1
	sojn 3,%L1463	; decrement_and_branch_until_zero
%L1464:
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_Sint3:
	.long	arr_Sint3+24
	.align	2
vgp_Sint3:
	.long	arr_Sint3+36

inc_Sint3_0:
	popj 17,

inc_Sint3_1:
	addi 1,3
	popj 17,

inc_Sint3_2:
	addi 1,6
	popj 17,

inc_Sint3_3:
	addi 1,11
	popj 17,

inc_Sint3_4:
	addi 1,14
	popj 17,

inc_Sint3_5:
	addi 1,17
	popj 17,

inc_Sint3_6:
	addi 1,22
	popj 17,

inc_Sint3_7:
	addi 1,25
	popj 17,

inc_Sint3_8:
	addi 1,30
	popj 17,

inc_Sint3_9:
	addi 1,33
	popj 17,

inc_Sint3_10:
	addi 1,36
	popj 17,

inc_Sint3_11:
	addi 1,41
	popj 17,

inc_Sint3_12:
	addi 1,44
	popj 17,

inc_Sint3_dynamic:
	move 4,1
	move 1,2
	lsh 1,1
	add 1,2
	add 1,4
	popj 17,

addassign_Sint3:
	move 4,1
	move 1,2
	lsh 1,1
	add 1,2
	add 1,4
	popj 17,

preinc_Sint3:
	addi 1,3
	popj 17,

postinc_Sint3:
	setzb 4,5
	move 2,1
	addi 2,3
	move 3,2
	sub 3,1
	move 4,3
	idivi 4,3
	jumpn 4,%L1487
	move 2,1
%L1487:
	move 1,2
	popj 17,

global_inc_Sint3:
	move 1,gp_Sint3
	addi 1,11
	popj 17,

volatile_inc_Sint3:
	move 3,1
	move 1,vgp_Sint3
	move 4,3
	lsh 4,1
	add 4,3
	add 1,4
	movem 1,vgp_Sint3
	popj 17,

array_start_inc_Sint3:
	movei 1,arr_Sint3+55
	popj 17,

index_inc_Sint3:
	move 4,1
	lsh 1,1
	add 1,4
	xmovei 1,arr_Sint3(1)
	move 4,2
	lsh 4,1
	add 4,2
	add 1,4
	popj 17,

load_after_Sint3:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	movei 11,0
	move 5,3(1)
	move 12,4(1)
	move 13,5(1)
	move 10,13
	move 1,5
	move 2,12
	move 3,13
	move 4,11
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

store_after_Sint3:
	add 17,[3,,3]
	movem 2,-2(17)
	movem 3,-1(17)
	movem 4,(17)
	movei 6,6
	add 6,1
	movei 4,(6)
	hrli 4,-2(17)
	blt 4,10(1)
	add 17,[-3,,-3]
	popj 17,

diff_after_inc_Sint3:
	setzb 4,5
	move 3,2
	lsh 3,1
	add 3,2
	move 4,3
	idivi 4,3
	move 1,4
	popj 17,

compare_after_inc_Sint3:
	move 4,1
	move 1,3
	lsh 1,1
	add 1,3
	add 1,4
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_uSint3:
	.long	arr_uSint3+24
	.align	2
vgp_uSint3:
	.long	arr_uSint3+36

inc_uSint3_0:
	popj 17,

inc_uSint3_1:
	addi 1,3
	popj 17,

inc_uSint3_2:
	addi 1,6
	popj 17,

inc_uSint3_3:
	addi 1,11
	popj 17,

inc_uSint3_4:
	addi 1,14
	popj 17,

inc_uSint3_5:
	addi 1,17
	popj 17,

inc_uSint3_6:
	addi 1,22
	popj 17,

inc_uSint3_7:
	addi 1,25
	popj 17,

inc_uSint3_8:
	addi 1,30
	popj 17,

inc_uSint3_9:
	addi 1,33
	popj 17,

inc_uSint3_10:
	addi 1,36
	popj 17,

inc_uSint3_11:
	addi 1,41
	popj 17,

inc_uSint3_12:
	addi 1,44
	popj 17,

inc_uSint3_dynamic:
	move 4,1
	move 1,2
	lsh 1,1
	add 1,2
	add 1,4
	popj 17,

addassign_uSint3:
	move 4,1
	move 1,2
	lsh 1,1
	add 1,2
	add 1,4
	popj 17,

preinc_uSint3:
	addi 1,3
	popj 17,

postinc_uSint3:
	setzb 4,5
	move 2,1
	addi 2,3
	move 3,2
	sub 3,1
	move 4,3
	idivi 4,3
	jumpn 4,%L1529
	move 2,1
%L1529:
	move 1,2
	popj 17,

global_inc_uSint3:
	move 1,gp_uSint3
	addi 1,11
	popj 17,

volatile_inc_uSint3:
	move 3,1
	move 1,vgp_uSint3
	move 4,3
	lsh 4,1
	add 4,3
	add 1,4
	movem 1,vgp_uSint3
	popj 17,

array_start_inc_uSint3:
	movei 1,arr_uSint3+55
	popj 17,

index_inc_uSint3:
	move 4,1
	lsh 1,1
	add 1,4
	xmovei 1,arr_uSint3(1)
	move 4,2
	lsh 4,1
	add 4,2
	add 1,4
	popj 17,

load_after_uSint3:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	movei 11,0
	move 5,3(1)
	move 12,4(1)
	move 13,5(1)
	move 10,13
	move 1,5
	move 2,12
	move 3,13
	move 4,11
	movei 0,10
	hrli 0,-3(17)
	blt 0,13
	add 17,[-4,,-4]
	popj 17,

store_after_uSint3:
	add 17,[3,,3]
	movem 2,-2(17)
	movem 3,-1(17)
	movem 4,(17)
	movei 6,6
	add 6,1
	movei 4,(6)
	hrli 4,-2(17)
	blt 4,10(1)
	add 17,[-3,,-3]
	popj 17,

diff_after_inc_uSint3:
	setzb 4,5
	move 3,2
	lsh 3,1
	add 3,2
	move 4,3
	idivi 4,3
	move 1,4
	popj 17,

compare_after_inc_uSint3:
	move 4,1
	move 1,3
	lsh 1,1
	add 1,3
	add 1,4
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_char6_7:
	.long	arr_char6_7+6543114246
	.align	2
vgp_char6_7:
	.long	arr_char6_7+32312918026

inc_char6_7_0:
	popj 17,

inc_char6_7_1:
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_char6_7_2:
	addi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_char6_7_3:
	addi 1,2
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_char6_7_4:
	addi 1,3
	ibp 1
	ibp 1
	popj 17,

inc_char6_7_5:
	addi 1,4
	ibp 1
	popj 17,

inc_char6_7_6:
	addi 1,5
	popj 17,

inc_char6_7_7:
	addi 1,5
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_char6_7_8:
	addi 1,6
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_char6_7_9:
	addi 1,7
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_char6_7_10:
	addi 1,10
	ibp 1
	ibp 1
	popj 17,

inc_char6_7_11:
	addi 1,11
	ibp 1
	popj 17,

inc_char6_7_12:
	addi 1,12
	popj 17,

inc_char6_7_dynamic:
	move 4,2
	lsh 4,2
	add 4,2
	jumple 4,%L1567
%L1566:
	ibp 1
	sojg 4,%L1566	; decrement_and_branch_until_zero
%L1567:
	jumpe 4,%L1569
%L1568:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L1568
%L1569:
	popj 17,

addassign_char6_7:
	move 4,2
	lsh 4,2
	add 4,2
	jumple 4,%L1573
%L1572:
	ibp 1
	sojg 4,%L1572	; decrement_and_branch_until_zero
%L1573:
	jumpe 4,%L1575
%L1574:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L1574
%L1575:
	popj 17,

preinc_char6_7:
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

postinc_char6_7:
	setzb 4,5
	move 2,1
	push 17,0
	movei 0,5
	ibp 2
	sojg 0,.-1
	pop 17,0
	move 6,2
	sub 6,1
	muli 6,14
	move 3,7
	ash 3,-1
	move 4,3
	add 4,%BADL6(6)
	idivi 4,5
	jumpn 4,%L1579
	move 2,1
%L1579:
	move 1,2
	popj 17,

global_inc_char6_7:
	move 1,gp_char6_7
	addi 1,2
	ibp 1
	ibp 1
	ibp 1
	popj 17,

volatile_inc_char6_7:
	move 4,vgp_char6_7
	move 3,1
	lsh 3,2
	add 3,1
	jumple 3,%L1586
%L1585:
	ibp 4
	sojg 3,%L1585	; decrement_and_branch_until_zero
%L1586:
	jumpe 3,%L1588
%L1587:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 3,%L1587
%L1588:
	movem 4,vgp_char6_7
	move 1,4
	popj 17,

array_start_inc_char6_7:
	move 1,[POINT 6,arr_char6_7+14,23]
	popj 17,

index_inc_char6_7:
	move 4,1
	lsh 4,2
	move 3,[POINT 6,arr_char6_7,5]
	add 4,1
	jumple 4,%L1595
%L1594:
	ibp 3
	sojg 4,%L1594	; decrement_and_branch_until_zero
%L1595:
	jumpe 4,%L1597
%L1596:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L1596
%L1597:
	move 4,2
	lsh 4,2
	move 1,3
	add 4,2
	jumple 4,%L1600
%L1599:
	ibp 1
	sojg 4,%L1599	; decrement_and_branch_until_zero
%L1600:
	jumpe 4,%L1602
%L1601:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L1601
%L1602:
	popj 17,

load_after_char6_7:
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ldb 4,[POINT 9,(1),17]
	lsh 4,33
	ldb 3,[POINT 9,(1),26]
	dpb 3,[POINT 9,4,17]
	ldb 3,[POINT 9,(1),35]
	dpb 3,[POINT 9,4,26]
	move 3,1(1)
	lsh 3,-33
	dpb 3,[POINT 9,4,35]
	move 6,(1)
	lsh 6,-33
	move 7,4
	move 1,6
	move 2,7
	popj 17,

store_after_char6_7:
	addi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	movei 2,@[%EXIND(0,17,777776)]
	movei 3,5
	pushj 17,memcpy
	popj 17,

diff_after_inc_char6_7:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setzb 6,7
	move 3,2
	lsh 3,2
	move 4,1
	add 3,2
	jumple 3,%L1610
%L1609:
	ibp 4
	sojg 3,%L1609	; decrement_and_branch_until_zero
%L1610:
	jumpe 3,%L1612
%L1611:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 3,%L1611
%L1612:
	move 10,4
	sub 10,1
	muli 10,14
	move 4,11
	ash 4,-1
	move 6,4
	add 6,%BADL6(10)
	idivi 6,5
	move 1,6
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

compare_after_inc_char6_7:
	move 4,3
	lsh 4,2
	add 4,3
	jumple 4,%L1618
%L1617:
	ibp 1
	sojg 4,%L1617	; decrement_and_branch_until_zero
%L1618:
	jumpe 4,%L1620
%L1619:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L1619
%L1620:
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_char7_6:
	.long	arr_char7_6+31255953416
	.align	2
vgp_char7_6:
	.long	arr_char7_6+31255953420

inc_char7_6_0:
	popj 17,

inc_char7_6_1:
	addi 1,1
	popj 17,

inc_char7_6_2:
	addi 1,2
	popj 17,

inc_char7_6_3:
	addi 1,3
	popj 17,

inc_char7_6_4:
	addi 1,4
	popj 17,

inc_char7_6_5:
	addi 1,5
	popj 17,

inc_char7_6_6:
	addi 1,6
	popj 17,

inc_char7_6_7:
	addi 1,7
	popj 17,

inc_char7_6_8:
	addi 1,10
	popj 17,

inc_char7_6_9:
	addi 1,11
	popj 17,

inc_char7_6_10:
	addi 1,12
	popj 17,

inc_char7_6_11:
	addi 1,13
	popj 17,

inc_char7_6_12:
	addi 1,14
	popj 17,

inc_char7_6_dynamic:
	move 4,2
	lsh 4,2
	add 4,2
	jumple 4,%L1639
%L1638:
	ibp 1
	sojg 4,%L1638	; decrement_and_branch_until_zero
%L1639:
	jumpe 4,%L1641
%L1640:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L1640
%L1641:
	popj 17,

addassign_char7_6:
	move 4,2
	lsh 4,2
	add 4,2
	jumple 4,%L1645
%L1644:
	ibp 1
	sojg 4,%L1644	; decrement_and_branch_until_zero
%L1645:
	jumpe 4,%L1647
%L1646:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L1646
%L1647:
	popj 17,

preinc_char7_6:
	addi 1,1
	popj 17,

postinc_char7_6:
	setzb 4,5
	move 2,1
	push 17,0
	movei 0,5
	ibp 2
	sojg 0,.-1
	pop 17,0
	move 6,2
	sub 6,1
	muli 6,12
	move 3,7
	ash 3,-1
	move 4,3
	add 4,%BADL7(6)
	idivi 4,5
	jumpn 4,%L1651
	move 2,1
%L1651:
	move 1,2
	popj 17,

global_inc_char7_6:
	move 1,gp_char7_6
	addi 1,3
	popj 17,

volatile_inc_char7_6:
	move 4,vgp_char7_6
	move 3,1
	lsh 3,2
	add 3,1
	jumple 3,%L1658
%L1657:
	ibp 4
	sojg 3,%L1657	; decrement_and_branch_until_zero
%L1658:
	jumpe 3,%L1660
%L1659:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 3,%L1659
%L1660:
	movem 4,vgp_char7_6
	move 1,4
	popj 17,

array_start_inc_char7_6:
	move 1,[POINT 7,arr_char7_6+17,6]
	popj 17,

index_inc_char7_6:
	move 4,1
	lsh 4,2
	move 3,[POINT 7,arr_char7_6,6]
	add 4,1
	jumple 4,%L1667
%L1666:
	ibp 3
	sojg 4,%L1666	; decrement_and_branch_until_zero
%L1667:
	jumpe 4,%L1669
%L1668:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L1668
%L1669:
	move 4,2
	lsh 4,2
	move 1,3
	add 4,2
	jumple 4,%L1672
%L1671:
	ibp 1
	sojg 4,%L1671	; decrement_and_branch_until_zero
%L1672:
	jumpe 4,%L1674
%L1673:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L1673
%L1674:
	popj 17,

load_after_char7_6:
	ldb 4,[POINT 9,1(1),17]
	lsh 4,33
	ldb 3,[POINT 9,1(1),26]
	dpb 3,[POINT 9,4,17]
	ldb 3,[POINT 9,1(1),35]
	dpb 3,[POINT 9,4,26]
	move 3,2(1)
	lsh 3,-33
	dpb 3,[POINT 9,4,35]
	move 6,1(1)
	lsh 6,-33
	move 7,4
	move 1,6
	move 2,7
	popj 17,

store_after_char7_6:
	addi 1,2
	movei 2,@[%EXIND(0,17,777776)]
	movei 3,5
	pushj 17,memcpy
	popj 17,

diff_after_inc_char7_6:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setzb 6,7
	move 3,2
	lsh 3,2
	move 4,1
	add 3,2
	jumple 3,%L1682
%L1681:
	ibp 4
	sojg 3,%L1681	; decrement_and_branch_until_zero
%L1682:
	jumpe 3,%L1684
%L1683:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 3,%L1683
%L1684:
	move 10,4
	sub 10,1
	muli 10,12
	move 4,11
	ash 4,-1
	move 6,4
	add 6,%BADL7(10)
	idivi 6,5
	move 1,6
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

compare_after_inc_char7_6:
	move 4,3
	lsh 4,2
	add 4,3
	jumple 4,%L1690
%L1689:
	ibp 1
	sojg 4,%L1689	; decrement_and_branch_until_zero
%L1690:
	jumpe 4,%L1692
%L1691:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L1691
%L1692:
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_char8_5:
	.long	arr_char8_5+30198988810
	.align	2
vgp_char8_5:
	.long	arr_char8_5+30198988815

inc_char8_5_0:
	popj 17,

inc_char8_5_1:
	addi 1,1
	ibp 1
	popj 17,

inc_char8_5_2:
	addi 1,2
	ibp 1
	ibp 1
	popj 17,

inc_char8_5_3:
	addi 1,3
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_char8_5_4:
	addi 1,5
	popj 17,

inc_char8_5_5:
	addi 1,6
	ibp 1
	popj 17,

inc_char8_5_6:
	addi 1,7
	ibp 1
	ibp 1
	popj 17,

inc_char8_5_7:
	addi 1,10
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_char8_5_8:
	addi 1,12
	popj 17,

inc_char8_5_9:
	addi 1,13
	ibp 1
	popj 17,

inc_char8_5_10:
	addi 1,14
	ibp 1
	ibp 1
	popj 17,

inc_char8_5_11:
	addi 1,15
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_char8_5_12:
	addi 1,17
	popj 17,

inc_char8_5_dynamic:
	move 4,2
	lsh 4,2
	add 4,2
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1711
%L1710:
	ibp 1
	sojn 3,%L1710	; decrement_and_branch_until_zero
%L1711:
	popj 17,

addassign_char8_5:
	move 4,2
	lsh 4,2
	add 4,2
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1715
%L1714:
	ibp 1
	sojn 3,%L1714	; decrement_and_branch_until_zero
%L1715:
	popj 17,

preinc_char8_5:
	addi 1,1
	ibp 1
	popj 17,

postinc_char8_5:
	setzb 4,5
	move 2,1
	push 17,0
	movei 0,5
	ibp 2
	sojg 0,.-1
	pop 17,0
	move 6,2
	sub 6,1
	muli 6,10
	move 3,7
	ash 3,-1
	move 4,3
	add 4,%BADL8(6)
	idivi 4,5
	jumpn 4,%L1719
	move 2,1
%L1719:
	move 1,2
	popj 17,

global_inc_char8_5:
	move 1,gp_char8_5
	addi 1,3
	ibp 1
	ibp 1
	ibp 1
	popj 17,

volatile_inc_char8_5:
	move 2,vgp_char8_5
	move 4,1
	lsh 4,2
	add 4,1
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 2,4
	jumpe 3,%L1726
%L1725:
	ibp 2
	sojn 3,%L1725	; decrement_and_branch_until_zero
%L1726:
	movem 2,vgp_char8_5
	move 1,2
	popj 17,

array_start_inc_char8_5:
	move 1,[POINT 8,arr_char8_5+22,31]
	popj 17,

index_inc_char8_5:
	move 4,1
	lsh 4,2
	add 4,1
	move 3,4
	andi 3,3
	move 6,4
	ash 6,-2	; ashrsi3_pointer
	add 6,[POINT 8,arr_char8_5,7]
	jumpe 3,%L1733
%L1732:
	ibp 6
	sojn 3,%L1732	; decrement_and_branch_until_zero
%L1733:
	move 4,2
	lsh 4,2
	add 4,2
	move 3,4
	andi 3,3
	move 1,4
	ash 1,-2	; ashrsi3_pointer
	add 1,6
	jumpe 3,%L1736
%L1735:
	ibp 1
	sojn 3,%L1735	; decrement_and_branch_until_zero
%L1736:
	popj 17,

load_after_char8_5:
	addi 1,1
	ibp 1
	ldb 4,[POINT 9,(1),17]
	lsh 4,33
	ldb 3,[POINT 9,(1),26]
	dpb 3,[POINT 9,4,17]
	ldb 3,[POINT 9,(1),35]
	dpb 3,[POINT 9,4,26]
	move 3,1(1)
	lsh 3,-33
	dpb 3,[POINT 9,4,35]
	move 6,(1)
	lsh 6,-33
	move 7,4
	move 1,6
	move 2,7
	popj 17,

store_after_char8_5:
	addi 1,2
	ibp 1
	ibp 1
	movei 2,-2(17)
	tlc 2,40100
	tlne 2,100000
	tlo 2,10000
	tlne 2,200000
	tlo 2,20000
	movei 3,5
	pushj 17,memcpy
	popj 17,

diff_after_inc_char8_5:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setzb 6,7
	move 4,2
	lsh 4,2
	add 4,2
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 4,1
	jumpe 3,%L1746
%L1745:
	ibp 4
	sojn 3,%L1745	; decrement_and_branch_until_zero
%L1746:
	move 10,4
	sub 10,1
	muli 10,10
	move 4,11
	ash 4,-1
	move 6,4
	add 6,%BADL8(10)
	idivi 6,5
	move 1,6
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

compare_after_inc_char8_5:
	move 4,3
	lsh 4,2
	add 4,3
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1752
%L1751:
	ibp 1
	sojn 3,%L1751	; decrement_and_branch_until_zero
%L1752:
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_char9_5:
	.long	arr_char9_5+29142024202
	.align	2
vgp_char9_5:
	.long	arr_char9_5+29142024207

inc_char9_5_0:
	popj 17,

inc_char9_5_1:
	addi 1,1
	ibp 1
	popj 17,

inc_char9_5_2:
	addi 1,2
	ibp 1
	ibp 1
	popj 17,

inc_char9_5_3:
	addi 1,3
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_char9_5_4:
	addi 1,5
	popj 17,

inc_char9_5_5:
	addi 1,6
	ibp 1
	popj 17,

inc_char9_5_6:
	addi 1,7
	ibp 1
	ibp 1
	popj 17,

inc_char9_5_7:
	addi 1,10
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_char9_5_8:
	addi 1,12
	popj 17,

inc_char9_5_9:
	addi 1,13
	ibp 1
	popj 17,

inc_char9_5_10:
	addi 1,14
	ibp 1
	ibp 1
	popj 17,

inc_char9_5_11:
	addi 1,15
	ibp 1
	ibp 1
	ibp 1
	popj 17,

inc_char9_5_12:
	addi 1,17
	popj 17,

inc_char9_5_dynamic:
	move 4,2
	lsh 4,2
	add 4,2
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1771
%L1770:
	ibp 1
	sojn 3,%L1770	; decrement_and_branch_until_zero
%L1771:
	popj 17,

addassign_char9_5:
	move 4,2
	lsh 4,2
	add 4,2
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1775
%L1774:
	ibp 1
	sojn 3,%L1774	; decrement_and_branch_until_zero
%L1775:
	popj 17,

preinc_char9_5:
	addi 1,1
	ibp 1
	popj 17,

postinc_char9_5:
	setzb 4,5
	move 2,1
	push 17,0
	movei 0,5
	ibp 2
	sojg 0,.-1
	pop 17,0
	move 6,2
	sub 6,1
	muli 6,10
	move 3,7
	ash 3,-1
	move 4,3
	add 4,%BADL9(6)
	idivi 4,5
	jumpn 4,%L1779
	move 2,1
%L1779:
	move 1,2
	popj 17,

global_inc_char9_5:
	move 1,gp_char9_5
	addi 1,3
	ibp 1
	ibp 1
	ibp 1
	popj 17,

volatile_inc_char9_5:
	move 2,vgp_char9_5
	move 4,1
	lsh 4,2
	add 4,1
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 2,4
	jumpe 3,%L1786
%L1785:
	ibp 2
	sojn 3,%L1785	; decrement_and_branch_until_zero
%L1786:
	movem 2,vgp_char9_5
	move 1,2
	popj 17,

array_start_inc_char9_5:
	move 1,[POINT 9,arr_char9_5+22,35]
	popj 17,

index_inc_char9_5:
	move 4,1
	lsh 4,2
	add 4,1
	move 3,4
	andi 3,3
	move 6,4
	ash 6,-2	; ashrsi3_pointer
	add 6,[POINT 9,arr_char9_5,8]
	jumpe 3,%L1793
%L1792:
	ibp 6
	sojn 3,%L1792	; decrement_and_branch_until_zero
%L1793:
	move 4,2
	lsh 4,2
	add 4,2
	move 3,4
	andi 3,3
	move 1,4
	ash 1,-2	; ashrsi3_pointer
	add 1,6
	jumpe 3,%L1796
%L1795:
	ibp 1
	sojn 3,%L1795	; decrement_and_branch_until_zero
%L1796:
	popj 17,

load_after_char9_5:
	addi 1,1
	ibp 1
	ldb 4,[POINT 9,(1),17]
	lsh 4,33
	ldb 3,[POINT 9,(1),26]
	dpb 3,[POINT 9,4,17]
	ldb 3,[POINT 9,(1),35]
	dpb 3,[POINT 9,4,26]
	move 3,1(1)
	lsh 3,-33
	dpb 3,[POINT 9,4,35]
	move 6,(1)
	lsh 6,-33
	move 7,4
	move 1,6
	move 2,7
	popj 17,

store_after_char9_5:
	addi 1,2
	ibp 1
	ibp 1
	movei 2,-1(17)
	ibp 2
	ibp 2
	movei 3,5
	pushj 17,memcpy
	popj 17,

diff_after_inc_char9_5:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setzb 6,7
	move 4,2
	lsh 4,2
	add 4,2
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 4,1
	jumpe 3,%L1804
%L1803:
	ibp 4
	sojn 3,%L1803	; decrement_and_branch_until_zero
%L1804:
	move 10,4
	sub 10,1
	muli 10,10
	move 4,11
	ash 4,-1
	move 6,4
	add 6,%BADL9(10)
	idivi 6,5
	move 1,6
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

compare_after_inc_char9_5:
	move 4,3
	lsh 4,2
	add 4,3
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1810
%L1809:
	ibp 1
	sojn 3,%L1809	; decrement_and_branch_until_zero
%L1810:
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_short18_3:
	.long	arr_short18_3+19629342732
	.align	2
vgp_short18_3:
	.long	arr_short18_3+19629342738

inc_short18_3_0:
	popj 17,

inc_short18_3_1:
	addi 1,1
	ibp 1
	popj 17,

inc_short18_3_2:
	addi 1,3
	popj 17,

inc_short18_3_3:
	addi 1,4
	ibp 1
	popj 17,

inc_short18_3_4:
	addi 1,6
	popj 17,

inc_short18_3_5:
	addi 1,7
	ibp 1
	popj 17,

inc_short18_3_6:
	addi 1,11
	popj 17,

inc_short18_3_7:
	addi 1,12
	ibp 1
	popj 17,

inc_short18_3_8:
	addi 1,14
	popj 17,

inc_short18_3_9:
	addi 1,15
	ibp 1
	popj 17,

inc_short18_3_10:
	addi 1,17
	popj 17,

inc_short18_3_11:
	addi 1,20
	ibp 1
	popj 17,

inc_short18_3_12:
	addi 1,22
	popj 17,

inc_short18_3_dynamic:
	move 4,2
	lsh 4,1
	add 4,2
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1829
%L1828:
	ibp 1
	sojn 3,%L1828	; decrement_and_branch_until_zero
%L1829:
	popj 17,

addassign_short18_3:
	move 4,2
	lsh 4,1
	add 4,2
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1833
%L1832:
	ibp 1
	sojn 3,%L1832	; decrement_and_branch_until_zero
%L1833:
	popj 17,

preinc_short18_3:
	addi 1,1
	ibp 1
	popj 17,

postinc_short18_3:
	setzb 4,5
	move 2,1
	push 17,0
	movei 0,3
	ibp 2
	sojg 0,.-1
	pop 17,0
	move 6,2
	sub 6,1
	muli 6,4
	move 3,7
	ash 3,-1
	add 3,%BADLH(6)
	move 4,3
	idivi 4,3
	jumpn 4,%L1837
	move 2,1
%L1837:
	move 1,2
	popj 17,

global_inc_short18_3:
	move 1,gp_short18_3
	addi 1,4
	ibp 1
	popj 17,

volatile_inc_short18_3:
	move 2,vgp_short18_3
	move 4,1
	lsh 4,1
	add 4,1
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 2,4
	jumpe 3,%L1844
%L1843:
	ibp 2
	sojn 3,%L1843	; decrement_and_branch_until_zero
%L1844:
	movem 2,vgp_short18_3
	move 1,2
	popj 17,

array_start_inc_short18_3:
	move 1,[POINT 18,arr_short18_3+26,35]
	popj 17,

index_inc_short18_3:
	move 4,1
	lsh 4,1
	add 4,1
	move 3,4
	andi 3,1
	move 6,4
	ash 6,-1	; ashrsi3_pointer
	add 6,[POINT 18,arr_short18_3,17]
	jumpe 3,%L1851
%L1850:
	ibp 6
	sojn 3,%L1850	; decrement_and_branch_until_zero
%L1851:
	move 4,2
	lsh 4,1
	add 4,2
	move 3,4
	andi 3,1
	move 1,4
	ash 1,-1	; ashrsi3_pointer
	add 1,6
	jumpe 3,%L1854
%L1853:
	ibp 1
	sojn 3,%L1853	; decrement_and_branch_until_zero
%L1854:
	popj 17,

load_after_short18_3:
	addi 1,1
	ibp 1
	hlrz 2,(1)
	ldb 5,[POINT 9,(1),17]
	andi 2,777000
	ldb 4,[POINT 9,(1),26]
	lsh 4,33
	ldb 3,[POINT 9,(1),35]
	dpb 3,[POINT 9,4,17]
	move 3,1(1)
	lsh 3,-33
	dpb 3,[POINT 9,4,26]
	ldb 3,[POINT 9,1(1),17]
	dpb 3,[POINT 9,4,35]
	move 6,2
	ior 6,5
	move 7,4
	move 1,6
	move 2,7
	popj 17,

store_after_short18_3:
	addi 1,3
	movei 2,-2(17)
	tlc 2,113300
	movei 3,6
	pushj 17,memcpy
	popj 17,

diff_after_inc_short18_3:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setzb 6,7
	move 4,2
	lsh 4,1
	add 4,2
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 4,1
	jumpe 3,%L1862
%L1861:
	ibp 4
	sojn 3,%L1861	; decrement_and_branch_until_zero
%L1862:
	move 10,4
	sub 10,1
	muli 10,4
	move 4,11
	ash 4,-1
	add 4,%BADLH(10)
	move 6,4
	idivi 6,3
	move 1,6
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

compare_after_inc_short18_3:
	move 4,3
	lsh 4,1
	add 4,3
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1868
%L1867:
	ibp 1
	sojn 3,%L1867	; decrement_and_branch_until_zero
%L1868:
	tlc 1,400000
	tlc 2,400000
	camg 1,2
	tdza 1,1
	movei 1,1
	popj 17,

char_bridge_inc:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1873
%L1872:
	ibp 1
	sojn 4,%L1872	; decrement_and_branch_until_zero
%L1873:
	popj 17,

void_bridge_inc:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1877
%L1876:
	ibp 1
	sojn 4,%L1876	; decrement_and_branch_until_zero
%L1877:
	popj 17,

cast_back_inc:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1883
%L1882:
	ibp 1
	sojn 4,%L1882	; decrement_and_branch_until_zero
%L1883:
	popj 17,

mixed_byte_word_control:
	push 17,10
	move 4,3
	andi 4,3
	move 6,3
	ash 6,-2	; ashrsi3_pointer
	add 6,1
	jumpe 4,%L1887
%L1886:
	ibp 6
	sojn 4,%L1886	; decrement_and_branch_until_zero
%L1887:
	move 7,6
	sub 7,1
	muli 7,10
	move 1,10
	ash 1,-1
	add 1,%BADL9(7)
	add 1,3
	pop 17,10
	popj 17,

cross_word_byte_increments:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 1,[POINT 6,arr_char6,5]
	movei 2,5
	pushj 17,diff_after_inc_char6
	move 10,1
	move 1,[POINT 6,arr_char6,5]
	movei 2,6
	pushj 17,diff_after_inc_char6
	add 10,1
	move 1,[POINT 6,arr_char6,5]
	movei 2,7
	pushj 17,diff_after_inc_char6
	add 10,1
	move 1,[POINT 7,arr_char7,6]
	movei 2,4
	pushj 17,diff_after_inc_char7
	add 10,1
	move 1,[POINT 7,arr_char7,6]
	movei 2,5
	pushj 17,diff_after_inc_char7
	add 10,1
	move 1,[POINT 7,arr_char7,6]
	movei 2,6
	pushj 17,diff_after_inc_char7
	add 10,1
	move 1,[POINT 8,arr_char8,7]
	movei 2,3
	pushj 17,diff_after_inc_char8
	add 10,1
	move 1,[POINT 8,arr_char8,7]
	movei 2,4
	pushj 17,diff_after_inc_char8
	add 10,1
	move 1,[POINT 8,arr_char8,7]
	movei 2,5
	pushj 17,diff_after_inc_char8
	add 10,1
	move 1,[POINT 9,arr_char9,8]
	movei 2,3
	pushj 17,diff_after_inc_char9
	add 10,1
	move 1,[POINT 9,arr_char9,8]
	movei 2,4
	pushj 17,diff_after_inc_char9
	add 10,1
	move 1,[POINT 9,arr_char9,8]
	movei 2,5
	pushj 17,diff_after_inc_char9
	add 10,1
	move 1,[POINT 18,arr_short18,17]
	movei 2,1
	pushj 17,diff_after_inc_short18
	add 10,1
	move 1,[POINT 18,arr_short18,17]
	movei 2,2
	pushj 17,diff_after_inc_short18
	add 10,1
	move 1,[POINT 18,arr_short18,17]
	movei 2,3
	pushj 17,diff_after_inc_short18
	add 10,1
	move 1,[POINT 9,arr_char9,8]
	move 2,11
	pushj 17,diff_after_inc_char9
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

use_increment_pointers:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 11,1
	move 12,2
	move 1,[POINT 9,arr_char9+1,8]
	move 2,11
	pushj 17,diff_after_inc_char9
	move 10,1
	move 1,[POINT 9,arr_uchar9+1,8]
	move 2,12
	pushj 17,diff_after_inc_uchar9
	add 10,1
	move 1,[POINT 6,arr_char6,29]
	movei 2,5
	pushj 17,diff_after_inc_char6
	add 10,1
	move 1,[POINT 7,arr_char7,34]
	movei 2,6
	pushj 17,diff_after_inc_char7
	add 10,1
	move 1,[POINT 8,arr_char8+1,7]
	movei 2,7
	pushj 17,diff_after_inc_char8
	add 10,1
	move 1,[POINT 18,arr_short18+2,17]
	movei 2,3
	pushj 17,diff_after_inc_short18
	add 10,1
	movei 1,arr_Sint+4
	movei 2,4
	pushj 17,diff_after_inc_Sint
	add 10,1
	move 1,[POINT 9,arr_char9+1,8]
	move 2,[POINT 9,arr_char9+2,26]
	move 3,11
	pushj 17,compare_after_inc_char9
	add 10,1
	movei 1,arr_Sint+4
	movei 2,arr_Sint+12
	move 3,12
	pushj 17,compare_after_inc_Sint
	add 10,1
	move 1,[POINT 9,arr_char9+1,8]
	movei 2,arr_Sint+4
	move 3,11
	pushj 17,mixed_byte_word_control
	add 10,1
	move 1,12
	pushj 17,cross_word_byte_increments
	add 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

	.bss
arr_char_:
	.space	48
arr_uchar_:
	.space	48
arr_char6:
	.space	48
arr_uchar6:
	.space	48
arr_char7:
	.space	48
arr_uchar7:
	.space	48
arr_char8:
	.space	48
arr_uchar8:
	.space	48
arr_char9:
	.space	48
arr_uchar9:
	.space	48
arr_short16:
	.space	96
arr_ushort16:
	.space	96
arr_short18:
	.space	96
arr_ushort18:
	.space	96
arr_Qint:
	.space	48
arr_uQint:
	.space	48
arr_Hint:
	.space	96
arr_uHint:
	.space	96
arr_Sint:
	.space	192
arr_uSint:
	.space	192
arr_Dint:
	.space	384
arr_uDint:
	.space	384
arr_Qint3:
	.space	144
arr_uQint3:
	.space	144
arr_Hint3:
	.space	288
arr_uHint3:
	.space	288
arr_Sint3:
	.space	576
arr_uSint3:
	.space	576
arr_char6_7:
	.space	240
arr_char7_6:
	.space	240
arr_char8_5:
	.space	240
arr_char9_5:
	.space	240
arr_short18_3:
	.space	288
