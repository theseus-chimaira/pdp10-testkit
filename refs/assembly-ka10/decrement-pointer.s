	.data
	.align	2
gp_char_:
	.long	arr_char_+29142024198
	.align	2
vgp_char_:
	.long	arr_char_+29142024199

dec_char__1:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_char__2:
	subi 1,1
	ibp 1
	ibp 1
	popj 17,

dec_char__3:
	subi 1,1
	ibp 1
	popj 17,

dec_char__4:
	subi 1,1
	popj 17,

dec_char__5:
	subi 1,2
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_char__6:
	subi 1,2
	ibp 1
	ibp 1
	popj 17,

dec_char__7:
	subi 1,2
	ibp 1
	popj 17,

dec_char__8:
	subi 1,2
	popj 17,

dec_char__9:
	subi 1,3
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_char__10:
	subi 1,3
	ibp 1
	ibp 1
	popj 17,

dec_char__11:
	subi 1,3
	ibp 1
	popj 17,

dec_char__12:
	subi 1,3
	popj 17,

dec_char__0:
	popj 17,

dec_char__dynamic:
	movn 2,2
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

subassign_char_:
	movn 2,2
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

predec_char_:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

postdec_char_:
	move 4,1
	push 17,0
	push 17,4
	push 17,0
	subi 4,1
	movem 4,(17)
	ibp 4
	came 4,-1(17)
	jrst .-3
	move 4,(17)
	pop 17,0
	pop 17,0
	pop 17,0
	move 3,4
	camn 1,4
	jrst %L30
%L27:
	move 1,3
	popj 17,
%L30:
	move 3,1
	jrst %L27

global_dec_char_:
	move 1,gp_char_
	subi 1,1
	ibp 1
	popj 17,

volatile_dec_char_:
	move 3,vgp_char_
	movn 1,1
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L35
%L34:
	ibp 3
	sojn 4,%L34	; decrement_and_branch_until_zero
%L35:
	movem 3,vgp_char_
	move 1,3
	popj 17,

array_end_dec_char_:
	move 1,[POINT 9,arr_char_+6,8]
	popj 17,

index_dec_char_:
	move 3,1
	andi 3,3
	move 6,1
	ash 6,-2	; ashrsi3_pointer
	add 6,[POINT 9,arr_char_,8]
	jumpe 3,%L42
%L41:
	ibp 6
	sojn 3,%L41	; decrement_and_branch_until_zero
%L42:
	movn 4,2
	move 3,4
	andi 3,3
	move 1,4
	ash 1,-2	; ashrsi3_pointer
	add 1,6
	jumpe 3,%L45
%L44:
	ibp 1
	sojn 3,%L44	; decrement_and_branch_until_zero
%L45:
	popj 17,

load_before_char_:
	subi 1,1
	ibp 1
	ibp 1
	ildb 1,1
	popj 17,

store_before_char_:
	subi 1,1
	ibp 1
	idpb 2,1
	popj 17,

diff_after_dec_char_:
	movn 2,2
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L51
%L50:
	ibp 3
	sojn 4,%L50	; decrement_and_branch_until_zero
%L51:
	move 6,1
	sub 6,3
	muli 6,10
	move 1,7
	ash 1,-1
	add 1,%BADL9(6)
	popj 17,

compare_after_dec_char_:
	movn 3,3
	move 4,3
	andi 4,3
	ash 3,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L57
%L56:
	ibp 1
	sojn 4,%L56	; decrement_and_branch_until_zero
%L57:
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_uchar_:
	.long	arr_uchar_+29142024198
	.align	2
vgp_uchar_:
	.long	arr_uchar_+29142024199

dec_uchar__1:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_uchar__2:
	subi 1,1
	ibp 1
	ibp 1
	popj 17,

dec_uchar__3:
	subi 1,1
	ibp 1
	popj 17,

dec_uchar__4:
	subi 1,1
	popj 17,

dec_uchar__5:
	subi 1,2
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_uchar__6:
	subi 1,2
	ibp 1
	ibp 1
	popj 17,

dec_uchar__7:
	subi 1,2
	ibp 1
	popj 17,

dec_uchar__8:
	subi 1,2
	popj 17,

dec_uchar__9:
	subi 1,3
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_uchar__10:
	subi 1,3
	ibp 1
	ibp 1
	popj 17,

dec_uchar__11:
	subi 1,3
	ibp 1
	popj 17,

dec_uchar__12:
	subi 1,3
	popj 17,

dec_uchar__0:
	popj 17,

dec_uchar__dynamic:
	movn 2,2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L76
%L75:
	ibp 1
	sojn 4,%L75	; decrement_and_branch_until_zero
%L76:
	popj 17,

subassign_uchar_:
	movn 2,2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L80
%L79:
	ibp 1
	sojn 4,%L79	; decrement_and_branch_until_zero
%L80:
	popj 17,

predec_uchar_:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

postdec_uchar_:
	move 4,1
	push 17,0
	push 17,4
	push 17,0
	subi 4,1
	movem 4,(17)
	ibp 4
	came 4,-1(17)
	jrst .-3
	move 4,(17)
	pop 17,0
	pop 17,0
	pop 17,0
	move 3,4
	camn 1,4
	jrst %L87
%L84:
	move 1,3
	popj 17,
%L87:
	move 3,1
	jrst %L84

global_dec_uchar_:
	move 1,gp_uchar_
	subi 1,1
	ibp 1
	popj 17,

volatile_dec_uchar_:
	move 3,vgp_uchar_
	movn 1,1
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L92
%L91:
	ibp 3
	sojn 4,%L91	; decrement_and_branch_until_zero
%L92:
	movem 3,vgp_uchar_
	move 1,3
	popj 17,

array_end_dec_uchar_:
	move 1,[POINT 9,arr_uchar_+6,8]
	popj 17,

index_dec_uchar_:
	move 3,1
	andi 3,3
	move 6,1
	ash 6,-2	; ashrsi3_pointer
	add 6,[POINT 9,arr_uchar_,8]
	jumpe 3,%L99
%L98:
	ibp 6
	sojn 3,%L98	; decrement_and_branch_until_zero
%L99:
	movn 4,2
	move 3,4
	andi 3,3
	move 1,4
	ash 1,-2	; ashrsi3_pointer
	add 1,6
	jumpe 3,%L102
%L101:
	ibp 1
	sojn 3,%L101	; decrement_and_branch_until_zero
%L102:
	popj 17,

load_before_uchar_:
	subi 1,1
	ibp 1
	ibp 1
	ildb 1,1
	popj 17,

store_before_uchar_:
	subi 1,1
	ibp 1
	idpb 2,1
	popj 17,

diff_after_dec_uchar_:
	movn 2,2
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L108
%L107:
	ibp 3
	sojn 4,%L107	; decrement_and_branch_until_zero
%L108:
	move 6,1
	sub 6,3
	muli 6,10
	move 1,7
	ash 1,-1
	add 1,%BADL9(6)
	popj 17,

compare_after_dec_uchar_:
	movn 3,3
	move 4,3
	andi 4,3
	ash 3,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L114
%L113:
	ibp 1
	sojn 4,%L113	; decrement_and_branch_until_zero
%L114:
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_char6:
	.long	arr_char6+32312918020
	.align	2
vgp_char6:
	.long	arr_char6+6543114244

dec_char6_1:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_char6_2:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_char6_3:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_char6_4:
	subi 1,1
	ibp 1
	ibp 1
	popj 17,

dec_char6_5:
	subi 1,1
	ibp 1
	popj 17,

dec_char6_6:
	subi 1,1
	popj 17,

dec_char6_7:
	subi 1,2
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_char6_8:
	subi 1,2
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_char6_9:
	subi 1,2
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_char6_10:
	subi 1,2
	ibp 1
	ibp 1
	popj 17,

dec_char6_11:
	subi 1,2
	ibp 1
	popj 17,

dec_char6_12:
	subi 1,2
	popj 17,

dec_char6_0:
	popj 17,

dec_char6_dynamic:
	movn 2,2
	jumple 2,%L133
%L132:
	ibp 1
	sojg 2,%L132	; decrement_and_branch_until_zero
%L133:
	jumpe 2,%L135
%L134:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L134
%L135:
	popj 17,

subassign_char6:
	movn 2,2
	jumple 2,%L139
%L138:
	ibp 1
	sojg 2,%L138	; decrement_and_branch_until_zero
%L139:
	jumpe 2,%L141
%L140:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L140
%L141:
	popj 17,

predec_char6:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

postdec_char6:
	move 4,1
	push 17,0
	push 17,4
	push 17,0
	subi 4,1
	movem 4,(17)
	ibp 4
	came 4,-1(17)
	jrst .-3
	move 4,(17)
	pop 17,0
	pop 17,0
	pop 17,0
	move 3,4
	camn 1,4
	jrst %L148
%L145:
	move 1,3
	popj 17,
%L148:
	move 3,1
	jrst %L145

global_dec_char6:
	move 1,gp_char6
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

volatile_dec_char6:
	move 4,vgp_char6
	movn 1,1
	jumple 1,%L153
%L152:
	ibp 4
	sojg 1,%L152	; decrement_and_branch_until_zero
%L153:
	jumpe 1,%L155
%L154:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L154
%L155:
	movem 4,vgp_char6
	move 1,4
	popj 17,

array_end_dec_char6:
	move 1,[POINT 6,arr_char6+4,5]
	popj 17,

index_dec_char6:
	move 4,[POINT 6,arr_char6,5]
	jumple 1,%L162
%L161:
	ibp 4
	sojg 1,%L161	; decrement_and_branch_until_zero
%L162:
	jumpe 1,%L164
%L163:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L163
%L164:
	move 1,4
	movn 2,2
	jumple 2,%L167
%L166:
	ibp 1
	sojg 2,%L166	; decrement_and_branch_until_zero
%L167:
	jumpe 2,%L169
%L168:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L168
%L169:
	popj 17,

load_before_char6:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ildb 1,1
	trne 1,40
	orcmi 1,77
	popj 17,

store_before_char6:
	lsh 2,36
	ash 2,-36
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	idpb 2,1
	popj 17,

diff_after_dec_char6:
	move 4,1
	movn 2,2
	jumple 2,%L175
%L174:
	ibp 4
	sojg 2,%L174	; decrement_and_branch_until_zero
%L175:
	jumpe 2,%L177
%L176:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 2,%L176
%L177:
	move 6,1
	sub 6,4
	muli 6,14
	move 1,7
	ash 1,-1
	add 1,%BADL6(6)
	popj 17,

compare_after_dec_char6:
	movn 3,3
	jumple 3,%L183
%L182:
	ibp 1
	sojg 3,%L182	; decrement_and_branch_until_zero
%L183:
	jumpe 3,%L185
%L184:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 3,%L184
%L185:
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_uchar6:
	.long	arr_uchar6+32312918020
	.align	2
vgp_uchar6:
	.long	arr_uchar6+6543114244

dec_uchar6_1:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_uchar6_2:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_uchar6_3:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_uchar6_4:
	subi 1,1
	ibp 1
	ibp 1
	popj 17,

dec_uchar6_5:
	subi 1,1
	ibp 1
	popj 17,

dec_uchar6_6:
	subi 1,1
	popj 17,

dec_uchar6_7:
	subi 1,2
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_uchar6_8:
	subi 1,2
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_uchar6_9:
	subi 1,2
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_uchar6_10:
	subi 1,2
	ibp 1
	ibp 1
	popj 17,

dec_uchar6_11:
	subi 1,2
	ibp 1
	popj 17,

dec_uchar6_12:
	subi 1,2
	popj 17,

dec_uchar6_0:
	popj 17,

dec_uchar6_dynamic:
	movn 2,2
	jumple 2,%L204
%L203:
	ibp 1
	sojg 2,%L203	; decrement_and_branch_until_zero
%L204:
	jumpe 2,%L206
%L205:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L205
%L206:
	popj 17,

subassign_uchar6:
	movn 2,2
	jumple 2,%L210
%L209:
	ibp 1
	sojg 2,%L209	; decrement_and_branch_until_zero
%L210:
	jumpe 2,%L212
%L211:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L211
%L212:
	popj 17,

predec_uchar6:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

postdec_uchar6:
	move 4,1
	push 17,0
	push 17,4
	push 17,0
	subi 4,1
	movem 4,(17)
	ibp 4
	came 4,-1(17)
	jrst .-3
	move 4,(17)
	pop 17,0
	pop 17,0
	pop 17,0
	move 3,4
	camn 1,4
	jrst %L219
%L216:
	move 1,3
	popj 17,
%L219:
	move 3,1
	jrst %L216

global_dec_uchar6:
	move 1,gp_uchar6
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

volatile_dec_uchar6:
	move 4,vgp_uchar6
	movn 1,1
	jumple 1,%L224
%L223:
	ibp 4
	sojg 1,%L223	; decrement_and_branch_until_zero
%L224:
	jumpe 1,%L226
%L225:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L225
%L226:
	movem 4,vgp_uchar6
	move 1,4
	popj 17,

array_end_dec_uchar6:
	move 1,[POINT 6,arr_uchar6+4,5]
	popj 17,

index_dec_uchar6:
	move 4,[POINT 6,arr_uchar6,5]
	jumple 1,%L233
%L232:
	ibp 4
	sojg 1,%L232	; decrement_and_branch_until_zero
%L233:
	jumpe 1,%L235
%L234:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L234
%L235:
	move 1,4
	movn 2,2
	jumple 2,%L238
%L237:
	ibp 1
	sojg 2,%L237	; decrement_and_branch_until_zero
%L238:
	jumpe 2,%L240
%L239:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L239
%L240:
	popj 17,

load_before_uchar6:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ildb 1,1
	popj 17,

store_before_uchar6:
	andi 2,77
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	idpb 2,1
	popj 17,

diff_after_dec_uchar6:
	move 4,1
	movn 2,2
	jumple 2,%L246
%L245:
	ibp 4
	sojg 2,%L245	; decrement_and_branch_until_zero
%L246:
	jumpe 2,%L248
%L247:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 2,%L247
%L248:
	move 6,1
	sub 6,4
	muli 6,14
	move 1,7
	ash 1,-1
	add 1,%BADL6(6)
	popj 17,

compare_after_dec_uchar6:
	movn 3,3
	jumple 3,%L254
%L253:
	ibp 1
	sojg 3,%L253	; decrement_and_branch_until_zero
%L254:
	jumpe 3,%L256
%L255:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 3,%L255
%L256:
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_char7:
	.long	arr_char7+1191182340
	.align	2
vgp_char7:
	.long	arr_char7+8707375109

dec_char7_1:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_char7_2:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_char7_3:
	subi 1,1
	ibp 1
	ibp 1
	popj 17,

dec_char7_4:
	subi 1,1
	ibp 1
	popj 17,

dec_char7_5:
	subi 1,1
	popj 17,

dec_char7_6:
	subi 1,2
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_char7_7:
	subi 1,2
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_char7_8:
	subi 1,2
	ibp 1
	ibp 1
	popj 17,

dec_char7_9:
	subi 1,2
	ibp 1
	popj 17,

dec_char7_10:
	subi 1,2
	popj 17,

dec_char7_11:
	subi 1,3
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_char7_12:
	subi 1,3
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_char7_0:
	popj 17,

dec_char7_dynamic:
	movn 2,2
	jumple 2,%L275
%L274:
	ibp 1
	sojg 2,%L274	; decrement_and_branch_until_zero
%L275:
	jumpe 2,%L277
%L276:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L276
%L277:
	popj 17,

subassign_char7:
	movn 2,2
	jumple 2,%L281
%L280:
	ibp 1
	sojg 2,%L280	; decrement_and_branch_until_zero
%L281:
	jumpe 2,%L283
%L282:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L282
%L283:
	popj 17,

predec_char7:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

postdec_char7:
	move 4,1
	push 17,0
	push 17,4
	push 17,0
	subi 4,1
	movem 4,(17)
	ibp 4
	came 4,-1(17)
	jrst .-3
	move 4,(17)
	pop 17,0
	pop 17,0
	pop 17,0
	move 3,4
	camn 1,4
	jrst %L290
%L287:
	move 1,3
	popj 17,
%L290:
	move 3,1
	jrst %L287

global_dec_char7:
	move 1,gp_char7
	subi 1,1
	ibp 1
	ibp 1
	popj 17,

volatile_dec_char7:
	move 4,vgp_char7
	movn 1,1
	jumple 1,%L295
%L294:
	ibp 4
	sojg 1,%L294	; decrement_and_branch_until_zero
%L295:
	jumpe 1,%L297
%L296:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L296
%L297:
	movem 4,vgp_char7
	move 1,4
	popj 17,

array_end_dec_char7:
	move 1,[POINT 7,arr_char7+4,34]
	popj 17,

index_dec_char7:
	move 4,[POINT 7,arr_char7,6]
	jumple 1,%L304
%L303:
	ibp 4
	sojg 1,%L303	; decrement_and_branch_until_zero
%L304:
	jumpe 1,%L306
%L305:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L305
%L306:
	move 1,4
	movn 2,2
	jumple 2,%L309
%L308:
	ibp 1
	sojg 2,%L308	; decrement_and_branch_until_zero
%L309:
	jumpe 2,%L311
%L310:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L310
%L311:
	popj 17,

load_before_char7:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ildb 1,1
	trne 1,100
	orcmi 1,177
	popj 17,

store_before_char7:
	lsh 2,35
	ash 2,-35
	subi 1,1
	ibp 1
	ibp 1
	idpb 2,1
	popj 17,

diff_after_dec_char7:
	move 4,1
	movn 2,2
	jumple 2,%L317
%L316:
	ibp 4
	sojg 2,%L316	; decrement_and_branch_until_zero
%L317:
	jumpe 2,%L319
%L318:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 2,%L318
%L319:
	move 6,1
	sub 6,4
	muli 6,12
	move 1,7
	ash 1,-1
	add 1,%BADL7(6)
	popj 17,

compare_after_dec_char7:
	movn 3,3
	jumple 3,%L325
%L324:
	ibp 1
	sojg 3,%L324	; decrement_and_branch_until_zero
%L325:
	jumpe 3,%L327
%L326:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 3,%L326
%L327:
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_uchar7:
	.long	arr_uchar7+1191182340
	.align	2
vgp_uchar7:
	.long	arr_uchar7+8707375109

dec_uchar7_1:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_uchar7_2:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_uchar7_3:
	subi 1,1
	ibp 1
	ibp 1
	popj 17,

dec_uchar7_4:
	subi 1,1
	ibp 1
	popj 17,

dec_uchar7_5:
	subi 1,1
	popj 17,

dec_uchar7_6:
	subi 1,2
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_uchar7_7:
	subi 1,2
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_uchar7_8:
	subi 1,2
	ibp 1
	ibp 1
	popj 17,

dec_uchar7_9:
	subi 1,2
	ibp 1
	popj 17,

dec_uchar7_10:
	subi 1,2
	popj 17,

dec_uchar7_11:
	subi 1,3
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_uchar7_12:
	subi 1,3
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_uchar7_0:
	popj 17,

dec_uchar7_dynamic:
	movn 2,2
	jumple 2,%L346
%L345:
	ibp 1
	sojg 2,%L345	; decrement_and_branch_until_zero
%L346:
	jumpe 2,%L348
%L347:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L347
%L348:
	popj 17,

subassign_uchar7:
	movn 2,2
	jumple 2,%L352
%L351:
	ibp 1
	sojg 2,%L351	; decrement_and_branch_until_zero
%L352:
	jumpe 2,%L354
%L353:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L353
%L354:
	popj 17,

predec_uchar7:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

postdec_uchar7:
	move 4,1
	push 17,0
	push 17,4
	push 17,0
	subi 4,1
	movem 4,(17)
	ibp 4
	came 4,-1(17)
	jrst .-3
	move 4,(17)
	pop 17,0
	pop 17,0
	pop 17,0
	move 3,4
	camn 1,4
	jrst %L361
%L358:
	move 1,3
	popj 17,
%L361:
	move 3,1
	jrst %L358

global_dec_uchar7:
	move 1,gp_uchar7
	subi 1,1
	ibp 1
	ibp 1
	popj 17,

volatile_dec_uchar7:
	move 4,vgp_uchar7
	movn 1,1
	jumple 1,%L366
%L365:
	ibp 4
	sojg 1,%L365	; decrement_and_branch_until_zero
%L366:
	jumpe 1,%L368
%L367:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L367
%L368:
	movem 4,vgp_uchar7
	move 1,4
	popj 17,

array_end_dec_uchar7:
	move 1,[POINT 7,arr_uchar7+4,34]
	popj 17,

index_dec_uchar7:
	move 4,[POINT 7,arr_uchar7,6]
	jumple 1,%L375
%L374:
	ibp 4
	sojg 1,%L374	; decrement_and_branch_until_zero
%L375:
	jumpe 1,%L377
%L376:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L376
%L377:
	move 1,4
	movn 2,2
	jumple 2,%L380
%L379:
	ibp 1
	sojg 2,%L379	; decrement_and_branch_until_zero
%L380:
	jumpe 2,%L382
%L381:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L381
%L382:
	popj 17,

load_before_uchar7:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ildb 1,1
	popj 17,

store_before_uchar7:
	andi 2,177
	subi 1,1
	ibp 1
	ibp 1
	idpb 2,1
	popj 17,

diff_after_dec_uchar7:
	move 4,1
	movn 2,2
	jumple 2,%L388
%L387:
	ibp 4
	sojg 2,%L387	; decrement_and_branch_until_zero
%L388:
	jumpe 2,%L390
%L389:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 2,%L389
%L390:
	move 6,1
	sub 6,4
	muli 6,12
	move 1,7
	ash 1,-1
	add 1,%BADL7(6)
	popj 17,

compare_after_dec_uchar7:
	movn 3,3
	jumple 3,%L396
%L395:
	ibp 1
	sojg 3,%L395	; decrement_and_branch_until_zero
%L396:
	jumpe 3,%L398
%L397:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 3,%L397
%L398:
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_char8:
	.long	arr_char8+30198988806
	.align	2
vgp_char8:
	.long	arr_char8+30198988807

dec_char8_1:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_char8_2:
	subi 1,1
	ibp 1
	ibp 1
	popj 17,

dec_char8_3:
	subi 1,1
	ibp 1
	popj 17,

dec_char8_4:
	subi 1,1
	popj 17,

dec_char8_5:
	subi 1,2
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_char8_6:
	subi 1,2
	ibp 1
	ibp 1
	popj 17,

dec_char8_7:
	subi 1,2
	ibp 1
	popj 17,

dec_char8_8:
	subi 1,2
	popj 17,

dec_char8_9:
	subi 1,3
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_char8_10:
	subi 1,3
	ibp 1
	ibp 1
	popj 17,

dec_char8_11:
	subi 1,3
	ibp 1
	popj 17,

dec_char8_12:
	subi 1,3
	popj 17,

dec_char8_0:
	popj 17,

dec_char8_dynamic:
	movn 2,2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L417
%L416:
	ibp 1
	sojn 4,%L416	; decrement_and_branch_until_zero
%L417:
	popj 17,

subassign_char8:
	movn 2,2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L421
%L420:
	ibp 1
	sojn 4,%L420	; decrement_and_branch_until_zero
%L421:
	popj 17,

predec_char8:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

postdec_char8:
	move 4,1
	push 17,0
	push 17,4
	push 17,0
	subi 4,1
	movem 4,(17)
	ibp 4
	came 4,-1(17)
	jrst .-3
	move 4,(17)
	pop 17,0
	pop 17,0
	pop 17,0
	move 3,4
	camn 1,4
	jrst %L428
%L425:
	move 1,3
	popj 17,
%L428:
	move 3,1
	jrst %L425

global_dec_char8:
	move 1,gp_char8
	subi 1,1
	ibp 1
	popj 17,

volatile_dec_char8:
	move 3,vgp_char8
	movn 1,1
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L433
%L432:
	ibp 3
	sojn 4,%L432	; decrement_and_branch_until_zero
%L433:
	movem 3,vgp_char8
	move 1,3
	popj 17,

array_end_dec_char8:
	move 1,[POINT 8,arr_char8+6,7]
	popj 17,

index_dec_char8:
	move 3,1
	andi 3,3
	move 6,1
	ash 6,-2	; ashrsi3_pointer
	add 6,[POINT 8,arr_char8,7]
	jumpe 3,%L440
%L439:
	ibp 6
	sojn 3,%L439	; decrement_and_branch_until_zero
%L440:
	movn 4,2
	move 3,4
	andi 3,3
	move 1,4
	ash 1,-2	; ashrsi3_pointer
	add 1,6
	jumpe 3,%L443
%L442:
	ibp 1
	sojn 3,%L442	; decrement_and_branch_until_zero
%L443:
	popj 17,

load_before_char8:
	subi 1,1
	ibp 1
	ibp 1
	ildb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

store_before_char8:
	lsh 2,34
	ash 2,-34
	subi 1,1
	ibp 1
	idpb 2,1
	popj 17,

diff_after_dec_char8:
	movn 2,2
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L449
%L448:
	ibp 3
	sojn 4,%L448	; decrement_and_branch_until_zero
%L449:
	move 6,1
	sub 6,3
	muli 6,10
	move 1,7
	ash 1,-1
	add 1,%BADL8(6)
	popj 17,

compare_after_dec_char8:
	movn 3,3
	move 4,3
	andi 4,3
	ash 3,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L455
%L454:
	ibp 1
	sojn 4,%L454	; decrement_and_branch_until_zero
%L455:
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_uchar8:
	.long	arr_uchar8+30198988806
	.align	2
vgp_uchar8:
	.long	arr_uchar8+30198988807

dec_uchar8_1:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_uchar8_2:
	subi 1,1
	ibp 1
	ibp 1
	popj 17,

dec_uchar8_3:
	subi 1,1
	ibp 1
	popj 17,

dec_uchar8_4:
	subi 1,1
	popj 17,

dec_uchar8_5:
	subi 1,2
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_uchar8_6:
	subi 1,2
	ibp 1
	ibp 1
	popj 17,

dec_uchar8_7:
	subi 1,2
	ibp 1
	popj 17,

dec_uchar8_8:
	subi 1,2
	popj 17,

dec_uchar8_9:
	subi 1,3
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_uchar8_10:
	subi 1,3
	ibp 1
	ibp 1
	popj 17,

dec_uchar8_11:
	subi 1,3
	ibp 1
	popj 17,

dec_uchar8_12:
	subi 1,3
	popj 17,

dec_uchar8_0:
	popj 17,

dec_uchar8_dynamic:
	movn 2,2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L474
%L473:
	ibp 1
	sojn 4,%L473	; decrement_and_branch_until_zero
%L474:
	popj 17,

subassign_uchar8:
	movn 2,2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L478
%L477:
	ibp 1
	sojn 4,%L477	; decrement_and_branch_until_zero
%L478:
	popj 17,

predec_uchar8:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

postdec_uchar8:
	move 4,1
	push 17,0
	push 17,4
	push 17,0
	subi 4,1
	movem 4,(17)
	ibp 4
	came 4,-1(17)
	jrst .-3
	move 4,(17)
	pop 17,0
	pop 17,0
	pop 17,0
	move 3,4
	camn 1,4
	jrst %L485
%L482:
	move 1,3
	popj 17,
%L485:
	move 3,1
	jrst %L482

global_dec_uchar8:
	move 1,gp_uchar8
	subi 1,1
	ibp 1
	popj 17,

volatile_dec_uchar8:
	move 3,vgp_uchar8
	movn 1,1
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L490
%L489:
	ibp 3
	sojn 4,%L489	; decrement_and_branch_until_zero
%L490:
	movem 3,vgp_uchar8
	move 1,3
	popj 17,

array_end_dec_uchar8:
	move 1,[POINT 8,arr_uchar8+6,7]
	popj 17,

index_dec_uchar8:
	move 3,1
	andi 3,3
	move 6,1
	ash 6,-2	; ashrsi3_pointer
	add 6,[POINT 8,arr_uchar8,7]
	jumpe 3,%L497
%L496:
	ibp 6
	sojn 3,%L496	; decrement_and_branch_until_zero
%L497:
	movn 4,2
	move 3,4
	andi 3,3
	move 1,4
	ash 1,-2	; ashrsi3_pointer
	add 1,6
	jumpe 3,%L500
%L499:
	ibp 1
	sojn 3,%L499	; decrement_and_branch_until_zero
%L500:
	popj 17,

load_before_uchar8:
	subi 1,1
	ibp 1
	ibp 1
	ildb 1,1
	popj 17,

store_before_uchar8:
	andi 2,377
	subi 1,1
	ibp 1
	idpb 2,1
	popj 17,

diff_after_dec_uchar8:
	movn 2,2
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L506
%L505:
	ibp 3
	sojn 4,%L505	; decrement_and_branch_until_zero
%L506:
	move 6,1
	sub 6,3
	muli 6,10
	move 1,7
	ash 1,-1
	add 1,%BADL8(6)
	popj 17,

compare_after_dec_uchar8:
	movn 3,3
	move 4,3
	andi 4,3
	ash 3,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L512
%L511:
	ibp 1
	sojn 4,%L511	; decrement_and_branch_until_zero
%L512:
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_char9:
	.long	arr_char9+29142024198
	.align	2
vgp_char9:
	.long	arr_char9+29142024199

dec_char9_1:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_char9_2:
	subi 1,1
	ibp 1
	ibp 1
	popj 17,

dec_char9_3:
	subi 1,1
	ibp 1
	popj 17,

dec_char9_4:
	subi 1,1
	popj 17,

dec_char9_5:
	subi 1,2
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_char9_6:
	subi 1,2
	ibp 1
	ibp 1
	popj 17,

dec_char9_7:
	subi 1,2
	ibp 1
	popj 17,

dec_char9_8:
	subi 1,2
	popj 17,

dec_char9_9:
	subi 1,3
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_char9_10:
	subi 1,3
	ibp 1
	ibp 1
	popj 17,

dec_char9_11:
	subi 1,3
	ibp 1
	popj 17,

dec_char9_12:
	subi 1,3
	popj 17,

dec_char9_0:
	popj 17,

dec_char9_dynamic:
	movn 2,2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L531
%L530:
	ibp 1
	sojn 4,%L530	; decrement_and_branch_until_zero
%L531:
	popj 17,

subassign_char9:
	movn 2,2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L535
%L534:
	ibp 1
	sojn 4,%L534	; decrement_and_branch_until_zero
%L535:
	popj 17,

predec_char9:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

postdec_char9:
	move 4,1
	push 17,0
	push 17,4
	push 17,0
	subi 4,1
	movem 4,(17)
	ibp 4
	came 4,-1(17)
	jrst .-3
	move 4,(17)
	pop 17,0
	pop 17,0
	pop 17,0
	move 3,4
	camn 1,4
	jrst %L542
%L539:
	move 1,3
	popj 17,
%L542:
	move 3,1
	jrst %L539

global_dec_char9:
	move 1,gp_char9
	subi 1,1
	ibp 1
	popj 17,

volatile_dec_char9:
	move 3,vgp_char9
	movn 1,1
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L547
%L546:
	ibp 3
	sojn 4,%L546	; decrement_and_branch_until_zero
%L547:
	movem 3,vgp_char9
	move 1,3
	popj 17,

array_end_dec_char9:
	move 1,[POINT 9,arr_char9+6,8]
	popj 17,

index_dec_char9:
	move 3,1
	andi 3,3
	move 6,1
	ash 6,-2	; ashrsi3_pointer
	add 6,[POINT 9,arr_char9,8]
	jumpe 3,%L554
%L553:
	ibp 6
	sojn 3,%L553	; decrement_and_branch_until_zero
%L554:
	movn 4,2
	move 3,4
	andi 3,3
	move 1,4
	ash 1,-2	; ashrsi3_pointer
	add 1,6
	jumpe 3,%L557
%L556:
	ibp 1
	sojn 3,%L556	; decrement_and_branch_until_zero
%L557:
	popj 17,

load_before_char9:
	subi 1,1
	ibp 1
	ibp 1
	ildb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

store_before_char9:
	subi 1,1
	ibp 1
	idpb 2,1
	popj 17,

diff_after_dec_char9:
	movn 2,2
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L563
%L562:
	ibp 3
	sojn 4,%L562	; decrement_and_branch_until_zero
%L563:
	move 6,1
	sub 6,3
	muli 6,10
	move 1,7
	ash 1,-1
	add 1,%BADL9(6)
	popj 17,

compare_after_dec_char9:
	movn 3,3
	move 4,3
	andi 4,3
	ash 3,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L569
%L568:
	ibp 1
	sojn 4,%L568	; decrement_and_branch_until_zero
%L569:
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_uchar9:
	.long	arr_uchar9+29142024198
	.align	2
vgp_uchar9:
	.long	arr_uchar9+29142024199

dec_uchar9_1:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_uchar9_2:
	subi 1,1
	ibp 1
	ibp 1
	popj 17,

dec_uchar9_3:
	subi 1,1
	ibp 1
	popj 17,

dec_uchar9_4:
	subi 1,1
	popj 17,

dec_uchar9_5:
	subi 1,2
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_uchar9_6:
	subi 1,2
	ibp 1
	ibp 1
	popj 17,

dec_uchar9_7:
	subi 1,2
	ibp 1
	popj 17,

dec_uchar9_8:
	subi 1,2
	popj 17,

dec_uchar9_9:
	subi 1,3
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_uchar9_10:
	subi 1,3
	ibp 1
	ibp 1
	popj 17,

dec_uchar9_11:
	subi 1,3
	ibp 1
	popj 17,

dec_uchar9_12:
	subi 1,3
	popj 17,

dec_uchar9_0:
	popj 17,

dec_uchar9_dynamic:
	movn 2,2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L588
%L587:
	ibp 1
	sojn 4,%L587	; decrement_and_branch_until_zero
%L588:
	popj 17,

subassign_uchar9:
	movn 2,2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L592
%L591:
	ibp 1
	sojn 4,%L591	; decrement_and_branch_until_zero
%L592:
	popj 17,

predec_uchar9:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

postdec_uchar9:
	move 4,1
	push 17,0
	push 17,4
	push 17,0
	subi 4,1
	movem 4,(17)
	ibp 4
	came 4,-1(17)
	jrst .-3
	move 4,(17)
	pop 17,0
	pop 17,0
	pop 17,0
	move 3,4
	camn 1,4
	jrst %L599
%L596:
	move 1,3
	popj 17,
%L599:
	move 3,1
	jrst %L596

global_dec_uchar9:
	move 1,gp_uchar9
	subi 1,1
	ibp 1
	popj 17,

volatile_dec_uchar9:
	move 3,vgp_uchar9
	movn 1,1
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L604
%L603:
	ibp 3
	sojn 4,%L603	; decrement_and_branch_until_zero
%L604:
	movem 3,vgp_uchar9
	move 1,3
	popj 17,

array_end_dec_uchar9:
	move 1,[POINT 9,arr_uchar9+6,8]
	popj 17,

index_dec_uchar9:
	move 3,1
	andi 3,3
	move 6,1
	ash 6,-2	; ashrsi3_pointer
	add 6,[POINT 9,arr_uchar9,8]
	jumpe 3,%L611
%L610:
	ibp 6
	sojn 3,%L610	; decrement_and_branch_until_zero
%L611:
	movn 4,2
	move 3,4
	andi 3,3
	move 1,4
	ash 1,-2	; ashrsi3_pointer
	add 1,6
	jumpe 3,%L614
%L613:
	ibp 1
	sojn 3,%L613	; decrement_and_branch_until_zero
%L614:
	popj 17,

load_before_uchar9:
	subi 1,1
	ibp 1
	ibp 1
	ildb 1,1
	popj 17,

store_before_uchar9:
	subi 1,1
	ibp 1
	idpb 2,1
	popj 17,

diff_after_dec_uchar9:
	movn 2,2
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L620
%L619:
	ibp 3
	sojn 4,%L619	; decrement_and_branch_until_zero
%L620:
	move 6,1
	sub 6,3
	muli 6,10
	move 1,7
	ash 1,-1
	add 1,%BADL9(6)
	popj 17,

compare_after_dec_uchar9:
	movn 3,3
	move 4,3
	andi 4,3
	ash 3,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L626
%L625:
	ibp 1
	sojn 4,%L625	; decrement_and_branch_until_zero
%L626:
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_short16:
	.long	arr_short16+19629342732
	.align	2
vgp_short16:
	.long	arr_short16+19629342734

dec_short16_1:
	subi 1,1
	ibp 1
	popj 17,

dec_short16_2:
	subi 1,1
	popj 17,

dec_short16_3:
	subi 1,2
	ibp 1
	popj 17,

dec_short16_4:
	subi 1,2
	popj 17,

dec_short16_5:
	subi 1,3
	ibp 1
	popj 17,

dec_short16_6:
	subi 1,3
	popj 17,

dec_short16_7:
	subi 1,4
	ibp 1
	popj 17,

dec_short16_8:
	subi 1,4
	popj 17,

dec_short16_9:
	subi 1,5
	ibp 1
	popj 17,

dec_short16_10:
	subi 1,5
	popj 17,

dec_short16_11:
	subi 1,6
	ibp 1
	popj 17,

dec_short16_12:
	subi 1,6
	popj 17,

dec_short16_0:
	popj 17,

dec_short16_dynamic:
	movn 2,2
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L645
%L644:
	ibp 1
	sojn 4,%L644	; decrement_and_branch_until_zero
%L645:
	popj 17,

subassign_short16:
	movn 2,2
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L649
%L648:
	ibp 1
	sojn 4,%L648	; decrement_and_branch_until_zero
%L649:
	popj 17,

predec_short16:
	subi 1,1
	ibp 1
	popj 17,

postdec_short16:
	move 2,1
	push 17,0
	push 17,2
	push 17,0
	subi 2,1
	movem 2,(17)
	ibp 2
	came 2,-1(17)
	jrst .-3
	move 2,(17)
	pop 17,0
	pop 17,0
	pop 17,0
	move 4,1
	sub 4,2
	muli 4,4
	move 3,5
	ash 3,-1
	add 3,%BADLH(4)
	jumpn 3,%L653
	move 2,1
%L653:
	move 1,2
	popj 17,

global_dec_short16:
	move 1,gp_short16
	subi 1,2
	ibp 1
	popj 17,

volatile_dec_short16:
	move 3,vgp_short16
	movn 1,1
	move 4,1
	andi 4,1
	ash 1,-1	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L660
%L659:
	ibp 3
	sojn 4,%L659	; decrement_and_branch_until_zero
%L660:
	movem 3,vgp_short16
	move 1,3
	popj 17,

array_end_dec_short16:
	move 1,[POINT 18,arr_short16+14,17]
	popj 17,

index_dec_short16:
	move 3,1
	andi 3,1
	move 6,1
	ash 6,-1	; ashrsi3_pointer
	add 6,[POINT 18,arr_short16,17]
	jumpe 3,%L667
%L666:
	ibp 6
	sojn 3,%L666	; decrement_and_branch_until_zero
%L667:
	movn 4,2
	move 3,4
	andi 3,1
	move 1,4
	ash 1,-1	; ashrsi3_pointer
	add 1,6
	jumpe 3,%L670
%L669:
	ibp 1
	sojn 3,%L669	; decrement_and_branch_until_zero
%L670:
	popj 17,

load_before_short16:
	subi 1,1
	ibp 1
	ldb 1,1
	lsh 1,24
	ash 1,-24
	popj 17,

store_before_short16:
	lsh 2,24
	ash 2,-24
	subi 1,1
	dpb 2,1	; movhi
	popj 17,

diff_after_dec_short16:
	movn 2,2
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L676
%L675:
	ibp 3
	sojn 4,%L675	; decrement_and_branch_until_zero
%L676:
	move 6,1
	sub 6,3
	muli 6,4
	move 1,7
	ash 1,-1
	add 1,%BADLH(6)
	popj 17,

compare_after_dec_short16:
	movn 3,3
	move 4,3
	andi 4,1
	ash 3,-1	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L682
%L681:
	ibp 1
	sojn 4,%L681	; decrement_and_branch_until_zero
%L682:
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_ushort16:
	.long	arr_ushort16+19629342732
	.align	2
vgp_ushort16:
	.long	arr_ushort16+19629342734

dec_ushort16_1:
	subi 1,1
	ibp 1
	popj 17,

dec_ushort16_2:
	subi 1,1
	popj 17,

dec_ushort16_3:
	subi 1,2
	ibp 1
	popj 17,

dec_ushort16_4:
	subi 1,2
	popj 17,

dec_ushort16_5:
	subi 1,3
	ibp 1
	popj 17,

dec_ushort16_6:
	subi 1,3
	popj 17,

dec_ushort16_7:
	subi 1,4
	ibp 1
	popj 17,

dec_ushort16_8:
	subi 1,4
	popj 17,

dec_ushort16_9:
	subi 1,5
	ibp 1
	popj 17,

dec_ushort16_10:
	subi 1,5
	popj 17,

dec_ushort16_11:
	subi 1,6
	ibp 1
	popj 17,

dec_ushort16_12:
	subi 1,6
	popj 17,

dec_ushort16_0:
	popj 17,

dec_ushort16_dynamic:
	movn 2,2
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L701
%L700:
	ibp 1
	sojn 4,%L700	; decrement_and_branch_until_zero
%L701:
	popj 17,

subassign_ushort16:
	movn 2,2
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L705
%L704:
	ibp 1
	sojn 4,%L704	; decrement_and_branch_until_zero
%L705:
	popj 17,

predec_ushort16:
	subi 1,1
	ibp 1
	popj 17,

postdec_ushort16:
	move 2,1
	push 17,0
	push 17,2
	push 17,0
	subi 2,1
	movem 2,(17)
	ibp 2
	came 2,-1(17)
	jrst .-3
	move 2,(17)
	pop 17,0
	pop 17,0
	pop 17,0
	move 4,1
	sub 4,2
	muli 4,4
	move 3,5
	ash 3,-1
	add 3,%BADLH(4)
	jumpn 3,%L709
	move 2,1
%L709:
	move 1,2
	popj 17,

global_dec_ushort16:
	move 1,gp_ushort16
	subi 1,2
	ibp 1
	popj 17,

volatile_dec_ushort16:
	move 3,vgp_ushort16
	movn 1,1
	move 4,1
	andi 4,1
	ash 1,-1	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L716
%L715:
	ibp 3
	sojn 4,%L715	; decrement_and_branch_until_zero
%L716:
	movem 3,vgp_ushort16
	move 1,3
	popj 17,

array_end_dec_ushort16:
	move 1,[POINT 18,arr_ushort16+14,17]
	popj 17,

index_dec_ushort16:
	move 3,1
	andi 3,1
	move 6,1
	ash 6,-1	; ashrsi3_pointer
	add 6,[POINT 18,arr_ushort16,17]
	jumpe 3,%L723
%L722:
	ibp 6
	sojn 3,%L722	; decrement_and_branch_until_zero
%L723:
	movn 4,2
	move 3,4
	andi 3,1
	move 1,4
	ash 1,-1	; ashrsi3_pointer
	add 1,6
	jumpe 3,%L726
%L725:
	ibp 1
	sojn 3,%L725	; decrement_and_branch_until_zero
%L726:
	popj 17,

load_before_ushort16:
	subi 1,1
	ibp 1
	ldb 1,1
	andi 1,177777
	popj 17,

store_before_ushort16:
	andi 2,177777
	subi 1,1
	dpb 2,1	; movhi
	popj 17,

diff_after_dec_ushort16:
	movn 2,2
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L732
%L731:
	ibp 3
	sojn 4,%L731	; decrement_and_branch_until_zero
%L732:
	move 6,1
	sub 6,3
	muli 6,4
	move 1,7
	ash 1,-1
	add 1,%BADLH(6)
	popj 17,

compare_after_dec_ushort16:
	movn 3,3
	move 4,3
	andi 4,1
	ash 3,-1	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L738
%L737:
	ibp 1
	sojn 4,%L737	; decrement_and_branch_until_zero
%L738:
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_short18:
	.long	arr_short18+19629342732
	.align	2
vgp_short18:
	.long	arr_short18+19629342734

dec_short18_1:
	subi 1,1
	ibp 1
	popj 17,

dec_short18_2:
	subi 1,1
	popj 17,

dec_short18_3:
	subi 1,2
	ibp 1
	popj 17,

dec_short18_4:
	subi 1,2
	popj 17,

dec_short18_5:
	subi 1,3
	ibp 1
	popj 17,

dec_short18_6:
	subi 1,3
	popj 17,

dec_short18_7:
	subi 1,4
	ibp 1
	popj 17,

dec_short18_8:
	subi 1,4
	popj 17,

dec_short18_9:
	subi 1,5
	ibp 1
	popj 17,

dec_short18_10:
	subi 1,5
	popj 17,

dec_short18_11:
	subi 1,6
	ibp 1
	popj 17,

dec_short18_12:
	subi 1,6
	popj 17,

dec_short18_0:
	popj 17,

dec_short18_dynamic:
	movn 2,2
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L757
%L756:
	ibp 1
	sojn 4,%L756	; decrement_and_branch_until_zero
%L757:
	popj 17,

subassign_short18:
	movn 2,2
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L761
%L760:
	ibp 1
	sojn 4,%L760	; decrement_and_branch_until_zero
%L761:
	popj 17,

predec_short18:
	subi 1,1
	ibp 1
	popj 17,

postdec_short18:
	move 2,1
	push 17,0
	push 17,2
	push 17,0
	subi 2,1
	movem 2,(17)
	ibp 2
	came 2,-1(17)
	jrst .-3
	move 2,(17)
	pop 17,0
	pop 17,0
	pop 17,0
	move 4,1
	sub 4,2
	muli 4,4
	move 3,5
	ash 3,-1
	add 3,%BADLH(4)
	jumpn 3,%L765
	move 2,1
%L765:
	move 1,2
	popj 17,

global_dec_short18:
	move 1,gp_short18
	subi 1,2
	ibp 1
	popj 17,

volatile_dec_short18:
	move 3,vgp_short18
	movn 1,1
	move 4,1
	andi 4,1
	ash 1,-1	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L772
%L771:
	ibp 3
	sojn 4,%L771	; decrement_and_branch_until_zero
%L772:
	movem 3,vgp_short18
	move 1,3
	popj 17,

array_end_dec_short18:
	move 1,[POINT 18,arr_short18+14,17]
	popj 17,

index_dec_short18:
	move 3,1
	andi 3,1
	move 6,1
	ash 6,-1	; ashrsi3_pointer
	add 6,[POINT 18,arr_short18,17]
	jumpe 3,%L779
%L778:
	ibp 6
	sojn 3,%L778	; decrement_and_branch_until_zero
%L779:
	movn 4,2
	move 3,4
	andi 3,1
	move 1,4
	ash 1,-1	; ashrsi3_pointer
	add 1,6
	jumpe 3,%L782
%L781:
	ibp 1
	sojn 3,%L781	; decrement_and_branch_until_zero
%L782:
	popj 17,

load_before_short18:
	subi 1,1
	ibp 1
	ldb 1,1
	hrre 1,1
	popj 17,

store_before_short18:
	subi 1,1
	dpb 2,1	; movhi
	popj 17,

diff_after_dec_short18:
	movn 2,2
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L788
%L787:
	ibp 3
	sojn 4,%L787	; decrement_and_branch_until_zero
%L788:
	move 6,1
	sub 6,3
	muli 6,4
	move 1,7
	ash 1,-1
	add 1,%BADLH(6)
	popj 17,

compare_after_dec_short18:
	movn 3,3
	move 4,3
	andi 4,1
	ash 3,-1	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L794
%L793:
	ibp 1
	sojn 4,%L793	; decrement_and_branch_until_zero
%L794:
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_ushort18:
	.long	arr_ushort18+19629342732
	.align	2
vgp_ushort18:
	.long	arr_ushort18+19629342734

dec_ushort18_1:
	subi 1,1
	ibp 1
	popj 17,

dec_ushort18_2:
	subi 1,1
	popj 17,

dec_ushort18_3:
	subi 1,2
	ibp 1
	popj 17,

dec_ushort18_4:
	subi 1,2
	popj 17,

dec_ushort18_5:
	subi 1,3
	ibp 1
	popj 17,

dec_ushort18_6:
	subi 1,3
	popj 17,

dec_ushort18_7:
	subi 1,4
	ibp 1
	popj 17,

dec_ushort18_8:
	subi 1,4
	popj 17,

dec_ushort18_9:
	subi 1,5
	ibp 1
	popj 17,

dec_ushort18_10:
	subi 1,5
	popj 17,

dec_ushort18_11:
	subi 1,6
	ibp 1
	popj 17,

dec_ushort18_12:
	subi 1,6
	popj 17,

dec_ushort18_0:
	popj 17,

dec_ushort18_dynamic:
	movn 2,2
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L813
%L812:
	ibp 1
	sojn 4,%L812	; decrement_and_branch_until_zero
%L813:
	popj 17,

subassign_ushort18:
	movn 2,2
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L817
%L816:
	ibp 1
	sojn 4,%L816	; decrement_and_branch_until_zero
%L817:
	popj 17,

predec_ushort18:
	subi 1,1
	ibp 1
	popj 17,

postdec_ushort18:
	move 2,1
	push 17,0
	push 17,2
	push 17,0
	subi 2,1
	movem 2,(17)
	ibp 2
	came 2,-1(17)
	jrst .-3
	move 2,(17)
	pop 17,0
	pop 17,0
	pop 17,0
	move 4,1
	sub 4,2
	muli 4,4
	move 3,5
	ash 3,-1
	add 3,%BADLH(4)
	jumpn 3,%L821
	move 2,1
%L821:
	move 1,2
	popj 17,

global_dec_ushort18:
	move 1,gp_ushort18
	subi 1,2
	ibp 1
	popj 17,

volatile_dec_ushort18:
	move 3,vgp_ushort18
	movn 1,1
	move 4,1
	andi 4,1
	ash 1,-1	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L828
%L827:
	ibp 3
	sojn 4,%L827	; decrement_and_branch_until_zero
%L828:
	movem 3,vgp_ushort18
	move 1,3
	popj 17,

array_end_dec_ushort18:
	move 1,[POINT 18,arr_ushort18+14,17]
	popj 17,

index_dec_ushort18:
	move 3,1
	andi 3,1
	move 6,1
	ash 6,-1	; ashrsi3_pointer
	add 6,[POINT 18,arr_ushort18,17]
	jumpe 3,%L835
%L834:
	ibp 6
	sojn 3,%L834	; decrement_and_branch_until_zero
%L835:
	movn 4,2
	move 3,4
	andi 3,1
	move 1,4
	ash 1,-1	; ashrsi3_pointer
	add 1,6
	jumpe 3,%L838
%L837:
	ibp 1
	sojn 3,%L837	; decrement_and_branch_until_zero
%L838:
	popj 17,

load_before_ushort18:
	subi 1,1
	ibp 1
	ldb 1,1
	popj 17,

store_before_ushort18:
	subi 1,1
	dpb 2,1	; movhi
	popj 17,

diff_after_dec_ushort18:
	movn 2,2
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L844
%L843:
	ibp 3
	sojn 4,%L843	; decrement_and_branch_until_zero
%L844:
	move 6,1
	sub 6,3
	muli 6,4
	move 1,7
	ash 1,-1
	add 1,%BADLH(6)
	popj 17,

compare_after_dec_ushort18:
	movn 3,3
	move 4,3
	andi 4,1
	ash 3,-1	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L850
%L849:
	ibp 1
	sojn 4,%L849	; decrement_and_branch_until_zero
%L850:
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_Qint:
	.long	arr_Qint+29142024198
	.align	2
vgp_Qint:
	.long	arr_Qint+29142024199

dec_Qint_1:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_Qint_2:
	subi 1,1
	ibp 1
	ibp 1
	popj 17,

dec_Qint_3:
	subi 1,1
	ibp 1
	popj 17,

dec_Qint_4:
	subi 1,1
	popj 17,

dec_Qint_5:
	subi 1,2
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_Qint_6:
	subi 1,2
	ibp 1
	ibp 1
	popj 17,

dec_Qint_7:
	subi 1,2
	ibp 1
	popj 17,

dec_Qint_8:
	subi 1,2
	popj 17,

dec_Qint_9:
	subi 1,3
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_Qint_10:
	subi 1,3
	ibp 1
	ibp 1
	popj 17,

dec_Qint_11:
	subi 1,3
	ibp 1
	popj 17,

dec_Qint_12:
	subi 1,3
	popj 17,

dec_Qint_0:
	popj 17,

dec_Qint_dynamic:
	movn 2,2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L869
%L868:
	ibp 1
	sojn 4,%L868	; decrement_and_branch_until_zero
%L869:
	popj 17,

subassign_Qint:
	movn 2,2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L873
%L872:
	ibp 1
	sojn 4,%L872	; decrement_and_branch_until_zero
%L873:
	popj 17,

predec_Qint:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

postdec_Qint:
	move 4,1
	push 17,0
	push 17,4
	push 17,0
	subi 4,1
	movem 4,(17)
	ibp 4
	came 4,-1(17)
	jrst .-3
	move 4,(17)
	pop 17,0
	pop 17,0
	pop 17,0
	move 3,4
	camn 1,4
	jrst %L880
%L877:
	move 1,3
	popj 17,
%L880:
	move 3,1
	jrst %L877

global_dec_Qint:
	move 1,gp_Qint
	subi 1,1
	ibp 1
	popj 17,

volatile_dec_Qint:
	move 3,vgp_Qint
	movn 1,1
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L885
%L884:
	ibp 3
	sojn 4,%L884	; decrement_and_branch_until_zero
%L885:
	movem 3,vgp_Qint
	move 1,3
	popj 17,

array_end_dec_Qint:
	move 1,[POINT 9,arr_Qint+6,8]
	popj 17,

index_dec_Qint:
	move 3,1
	andi 3,3
	move 6,1
	ash 6,-2	; ashrsi3_pointer
	add 6,[POINT 9,arr_Qint,8]
	jumpe 3,%L892
%L891:
	ibp 6
	sojn 3,%L891	; decrement_and_branch_until_zero
%L892:
	movn 4,2
	move 3,4
	andi 3,3
	move 1,4
	ash 1,-2	; ashrsi3_pointer
	add 1,6
	jumpe 3,%L895
%L894:
	ibp 1
	sojn 3,%L894	; decrement_and_branch_until_zero
%L895:
	popj 17,

load_before_Qint:
	subi 1,1
	ibp 1
	ibp 1
	ildb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

store_before_Qint:
	subi 1,1
	ibp 1
	idpb 2,1
	popj 17,

diff_after_dec_Qint:
	movn 2,2
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L901
%L900:
	ibp 3
	sojn 4,%L900	; decrement_and_branch_until_zero
%L901:
	move 6,1
	sub 6,3
	muli 6,10
	move 1,7
	ash 1,-1
	add 1,%BADL9(6)
	popj 17,

compare_after_dec_Qint:
	movn 3,3
	move 4,3
	andi 4,3
	ash 3,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L907
%L906:
	ibp 1
	sojn 4,%L906	; decrement_and_branch_until_zero
%L907:
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_uQint:
	.long	arr_uQint+29142024198
	.align	2
vgp_uQint:
	.long	arr_uQint+29142024199

dec_uQint_1:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_uQint_2:
	subi 1,1
	ibp 1
	ibp 1
	popj 17,

dec_uQint_3:
	subi 1,1
	ibp 1
	popj 17,

dec_uQint_4:
	subi 1,1
	popj 17,

dec_uQint_5:
	subi 1,2
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_uQint_6:
	subi 1,2
	ibp 1
	ibp 1
	popj 17,

dec_uQint_7:
	subi 1,2
	ibp 1
	popj 17,

dec_uQint_8:
	subi 1,2
	popj 17,

dec_uQint_9:
	subi 1,3
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_uQint_10:
	subi 1,3
	ibp 1
	ibp 1
	popj 17,

dec_uQint_11:
	subi 1,3
	ibp 1
	popj 17,

dec_uQint_12:
	subi 1,3
	popj 17,

dec_uQint_0:
	popj 17,

dec_uQint_dynamic:
	movn 2,2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L926
%L925:
	ibp 1
	sojn 4,%L925	; decrement_and_branch_until_zero
%L926:
	popj 17,

subassign_uQint:
	movn 2,2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L930
%L929:
	ibp 1
	sojn 4,%L929	; decrement_and_branch_until_zero
%L930:
	popj 17,

predec_uQint:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

postdec_uQint:
	move 4,1
	push 17,0
	push 17,4
	push 17,0
	subi 4,1
	movem 4,(17)
	ibp 4
	came 4,-1(17)
	jrst .-3
	move 4,(17)
	pop 17,0
	pop 17,0
	pop 17,0
	move 3,4
	camn 1,4
	jrst %L937
%L934:
	move 1,3
	popj 17,
%L937:
	move 3,1
	jrst %L934

global_dec_uQint:
	move 1,gp_uQint
	subi 1,1
	ibp 1
	popj 17,

volatile_dec_uQint:
	move 3,vgp_uQint
	movn 1,1
	move 4,1
	andi 4,3
	ash 1,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L942
%L941:
	ibp 3
	sojn 4,%L941	; decrement_and_branch_until_zero
%L942:
	movem 3,vgp_uQint
	move 1,3
	popj 17,

array_end_dec_uQint:
	move 1,[POINT 9,arr_uQint+6,8]
	popj 17,

index_dec_uQint:
	move 3,1
	andi 3,3
	move 6,1
	ash 6,-2	; ashrsi3_pointer
	add 6,[POINT 9,arr_uQint,8]
	jumpe 3,%L949
%L948:
	ibp 6
	sojn 3,%L948	; decrement_and_branch_until_zero
%L949:
	movn 4,2
	move 3,4
	andi 3,3
	move 1,4
	ash 1,-2	; ashrsi3_pointer
	add 1,6
	jumpe 3,%L952
%L951:
	ibp 1
	sojn 3,%L951	; decrement_and_branch_until_zero
%L952:
	popj 17,

load_before_uQint:
	subi 1,1
	ibp 1
	ibp 1
	ildb 1,1
	popj 17,

store_before_uQint:
	subi 1,1
	ibp 1
	idpb 2,1
	popj 17,

diff_after_dec_uQint:
	movn 2,2
	move 4,2
	andi 4,3
	move 3,2
	ash 3,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L958
%L957:
	ibp 3
	sojn 4,%L957	; decrement_and_branch_until_zero
%L958:
	move 6,1
	sub 6,3
	muli 6,10
	move 1,7
	ash 1,-1
	add 1,%BADL9(6)
	popj 17,

compare_after_dec_uQint:
	movn 3,3
	move 4,3
	andi 4,3
	ash 3,-2	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L964
%L963:
	ibp 1
	sojn 4,%L963	; decrement_and_branch_until_zero
%L964:
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_Hint:
	.long	arr_Hint+19629342732
	.align	2
vgp_Hint:
	.long	arr_Hint+19629342734

dec_Hint_1:
	subi 1,1
	ibp 1
	popj 17,

dec_Hint_2:
	subi 1,1
	popj 17,

dec_Hint_3:
	subi 1,2
	ibp 1
	popj 17,

dec_Hint_4:
	subi 1,2
	popj 17,

dec_Hint_5:
	subi 1,3
	ibp 1
	popj 17,

dec_Hint_6:
	subi 1,3
	popj 17,

dec_Hint_7:
	subi 1,4
	ibp 1
	popj 17,

dec_Hint_8:
	subi 1,4
	popj 17,

dec_Hint_9:
	subi 1,5
	ibp 1
	popj 17,

dec_Hint_10:
	subi 1,5
	popj 17,

dec_Hint_11:
	subi 1,6
	ibp 1
	popj 17,

dec_Hint_12:
	subi 1,6
	popj 17,

dec_Hint_0:
	popj 17,

dec_Hint_dynamic:
	movn 2,2
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L983
%L982:
	ibp 1
	sojn 4,%L982	; decrement_and_branch_until_zero
%L983:
	popj 17,

subassign_Hint:
	movn 2,2
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L987
%L986:
	ibp 1
	sojn 4,%L986	; decrement_and_branch_until_zero
%L987:
	popj 17,

predec_Hint:
	subi 1,1
	ibp 1
	popj 17,

postdec_Hint:
	move 2,1
	push 17,0
	push 17,2
	push 17,0
	subi 2,1
	movem 2,(17)
	ibp 2
	came 2,-1(17)
	jrst .-3
	move 2,(17)
	pop 17,0
	pop 17,0
	pop 17,0
	move 4,1
	sub 4,2
	muli 4,4
	move 3,5
	ash 3,-1
	add 3,%BADLH(4)
	jumpn 3,%L991
	move 2,1
%L991:
	move 1,2
	popj 17,

global_dec_Hint:
	move 1,gp_Hint
	subi 1,2
	ibp 1
	popj 17,

volatile_dec_Hint:
	move 3,vgp_Hint
	movn 1,1
	move 4,1
	andi 4,1
	ash 1,-1	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L998
%L997:
	ibp 3
	sojn 4,%L997	; decrement_and_branch_until_zero
%L998:
	movem 3,vgp_Hint
	move 1,3
	popj 17,

array_end_dec_Hint:
	move 1,[POINT 18,arr_Hint+14,17]
	popj 17,

index_dec_Hint:
	move 3,1
	andi 3,1
	move 6,1
	ash 6,-1	; ashrsi3_pointer
	add 6,[POINT 18,arr_Hint,17]
	jumpe 3,%L1005
%L1004:
	ibp 6
	sojn 3,%L1004	; decrement_and_branch_until_zero
%L1005:
	movn 4,2
	move 3,4
	andi 3,1
	move 1,4
	ash 1,-1	; ashrsi3_pointer
	add 1,6
	jumpe 3,%L1008
%L1007:
	ibp 1
	sojn 3,%L1007	; decrement_and_branch_until_zero
%L1008:
	popj 17,

load_before_Hint:
	subi 1,1
	ibp 1
	ldb 1,1
	hrre 1,1
	popj 17,

store_before_Hint:
	subi 1,1
	dpb 2,1	; movhi
	popj 17,

diff_after_dec_Hint:
	movn 2,2
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L1014
%L1013:
	ibp 3
	sojn 4,%L1013	; decrement_and_branch_until_zero
%L1014:
	move 6,1
	sub 6,3
	muli 6,4
	move 1,7
	ash 1,-1
	add 1,%BADLH(6)
	popj 17,

compare_after_dec_Hint:
	movn 3,3
	move 4,3
	andi 4,1
	ash 3,-1	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L1020
%L1019:
	ibp 1
	sojn 4,%L1019	; decrement_and_branch_until_zero
%L1020:
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_uHint:
	.long	arr_uHint+19629342732
	.align	2
vgp_uHint:
	.long	arr_uHint+19629342734

dec_uHint_1:
	subi 1,1
	ibp 1
	popj 17,

dec_uHint_2:
	subi 1,1
	popj 17,

dec_uHint_3:
	subi 1,2
	ibp 1
	popj 17,

dec_uHint_4:
	subi 1,2
	popj 17,

dec_uHint_5:
	subi 1,3
	ibp 1
	popj 17,

dec_uHint_6:
	subi 1,3
	popj 17,

dec_uHint_7:
	subi 1,4
	ibp 1
	popj 17,

dec_uHint_8:
	subi 1,4
	popj 17,

dec_uHint_9:
	subi 1,5
	ibp 1
	popj 17,

dec_uHint_10:
	subi 1,5
	popj 17,

dec_uHint_11:
	subi 1,6
	ibp 1
	popj 17,

dec_uHint_12:
	subi 1,6
	popj 17,

dec_uHint_0:
	popj 17,

dec_uHint_dynamic:
	movn 2,2
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1039
%L1038:
	ibp 1
	sojn 4,%L1038	; decrement_and_branch_until_zero
%L1039:
	popj 17,

subassign_uHint:
	movn 2,2
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1043
%L1042:
	ibp 1
	sojn 4,%L1042	; decrement_and_branch_until_zero
%L1043:
	popj 17,

predec_uHint:
	subi 1,1
	ibp 1
	popj 17,

postdec_uHint:
	move 2,1
	push 17,0
	push 17,2
	push 17,0
	subi 2,1
	movem 2,(17)
	ibp 2
	came 2,-1(17)
	jrst .-3
	move 2,(17)
	pop 17,0
	pop 17,0
	pop 17,0
	move 4,1
	sub 4,2
	muli 4,4
	move 3,5
	ash 3,-1
	add 3,%BADLH(4)
	jumpn 3,%L1047
	move 2,1
%L1047:
	move 1,2
	popj 17,

global_dec_uHint:
	move 1,gp_uHint
	subi 1,2
	ibp 1
	popj 17,

volatile_dec_uHint:
	move 3,vgp_uHint
	movn 1,1
	move 4,1
	andi 4,1
	ash 1,-1	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L1054
%L1053:
	ibp 3
	sojn 4,%L1053	; decrement_and_branch_until_zero
%L1054:
	movem 3,vgp_uHint
	move 1,3
	popj 17,

array_end_dec_uHint:
	move 1,[POINT 18,arr_uHint+14,17]
	popj 17,

index_dec_uHint:
	move 3,1
	andi 3,1
	move 6,1
	ash 6,-1	; ashrsi3_pointer
	add 6,[POINT 18,arr_uHint,17]
	jumpe 3,%L1061
%L1060:
	ibp 6
	sojn 3,%L1060	; decrement_and_branch_until_zero
%L1061:
	movn 4,2
	move 3,4
	andi 3,1
	move 1,4
	ash 1,-1	; ashrsi3_pointer
	add 1,6
	jumpe 3,%L1064
%L1063:
	ibp 1
	sojn 3,%L1063	; decrement_and_branch_until_zero
%L1064:
	popj 17,

load_before_uHint:
	subi 1,1
	ibp 1
	ldb 1,1
	popj 17,

store_before_uHint:
	subi 1,1
	dpb 2,1	; movhi
	popj 17,

diff_after_dec_uHint:
	movn 2,2
	move 4,2
	andi 4,1
	move 3,2
	ash 3,-1	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L1070
%L1069:
	ibp 3
	sojn 4,%L1069	; decrement_and_branch_until_zero
%L1070:
	move 6,1
	sub 6,3
	muli 6,4
	move 1,7
	ash 1,-1
	add 1,%BADLH(6)
	popj 17,

compare_after_dec_uHint:
	movn 3,3
	move 4,3
	andi 4,1
	ash 3,-1	; ashrsi3_pointer
	add 1,3
	jumpe 4,%L1076
%L1075:
	ibp 1
	sojn 4,%L1075	; decrement_and_branch_until_zero
%L1076:
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_Sint:
	.long	arr_Sint+24
	.align	2
vgp_Sint:
	.long	arr_Sint+28

dec_Sint_1:
	subi 1,1
	popj 17,

dec_Sint_2:
	subi 1,2
	popj 17,

dec_Sint_3:
	subi 1,3
	popj 17,

dec_Sint_4:
	subi 1,4
	popj 17,

dec_Sint_5:
	subi 1,5
	popj 17,

dec_Sint_6:
	subi 1,6
	popj 17,

dec_Sint_7:
	subi 1,7
	popj 17,

dec_Sint_8:
	subi 1,10
	popj 17,

dec_Sint_9:
	subi 1,11
	popj 17,

dec_Sint_10:
	subi 1,12
	popj 17,

dec_Sint_11:
	subi 1,13
	popj 17,

dec_Sint_12:
	subi 1,14
	popj 17,

dec_Sint_0:
	popj 17,

dec_Sint_dynamic:
	sub 1,2
	popj 17,

subassign_Sint:
	sub 1,2
	popj 17,

predec_Sint:
	subi 1,1
	popj 17,

postdec_Sint:
	move 3,1
	subi 3,1
	move 4,1
	sub 4,3
	jumpn 4,%L1099
	move 3,1
%L1099:
	move 1,3
	popj 17,

global_dec_Sint:
	move 1,gp_Sint
	subi 1,3
	popj 17,

volatile_dec_Sint:
	move 4,1
	move 1,vgp_Sint
	sub 1,4
	movem 1,vgp_Sint
	popj 17,

array_end_dec_Sint:
	movei 1,arr_Sint+30
	popj 17,

index_dec_Sint:
	xmovei 1,arr_Sint(1)
	sub 1,2
	popj 17,

load_before_Sint:
	move 1,-1(1)
	popj 17,

store_before_Sint:
	movem 2,-2(1)
	popj 17,

diff_after_dec_Sint:
	move 1,2
	popj 17,

compare_after_dec_Sint:
	sub 1,3
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_uSint:
	.long	arr_uSint+24
	.align	2
vgp_uSint:
	.long	arr_uSint+28

dec_uSint_1:
	subi 1,1
	popj 17,

dec_uSint_2:
	subi 1,2
	popj 17,

dec_uSint_3:
	subi 1,3
	popj 17,

dec_uSint_4:
	subi 1,4
	popj 17,

dec_uSint_5:
	subi 1,5
	popj 17,

dec_uSint_6:
	subi 1,6
	popj 17,

dec_uSint_7:
	subi 1,7
	popj 17,

dec_uSint_8:
	subi 1,10
	popj 17,

dec_uSint_9:
	subi 1,11
	popj 17,

dec_uSint_10:
	subi 1,12
	popj 17,

dec_uSint_11:
	subi 1,13
	popj 17,

dec_uSint_12:
	subi 1,14
	popj 17,

dec_uSint_0:
	popj 17,

dec_uSint_dynamic:
	sub 1,2
	popj 17,

subassign_uSint:
	sub 1,2
	popj 17,

predec_uSint:
	subi 1,1
	popj 17,

postdec_uSint:
	move 3,1
	subi 3,1
	move 4,1
	sub 4,3
	jumpn 4,%L1141
	move 3,1
%L1141:
	move 1,3
	popj 17,

global_dec_uSint:
	move 1,gp_uSint
	subi 1,3
	popj 17,

volatile_dec_uSint:
	move 4,1
	move 1,vgp_uSint
	sub 1,4
	movem 1,vgp_uSint
	popj 17,

array_end_dec_uSint:
	movei 1,arr_uSint+30
	popj 17,

index_dec_uSint:
	xmovei 1,arr_uSint(1)
	sub 1,2
	popj 17,

load_before_uSint:
	move 1,-1(1)
	popj 17,

store_before_uSint:
	movem 2,-2(1)
	popj 17,

diff_after_dec_uSint:
	move 1,2
	popj 17,

compare_after_dec_uSint:
	sub 1,3
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_Dint:
	.long	arr_Dint+48
	.align	2
vgp_Dint:
	.long	arr_Dint+56

dec_Dint_1:
	subi 1,2
	popj 17,

dec_Dint_2:
	subi 1,4
	popj 17,

dec_Dint_3:
	subi 1,6
	popj 17,

dec_Dint_4:
	subi 1,10
	popj 17,

dec_Dint_5:
	subi 1,12
	popj 17,

dec_Dint_6:
	subi 1,14
	popj 17,

dec_Dint_7:
	subi 1,16
	popj 17,

dec_Dint_8:
	subi 1,20
	popj 17,

dec_Dint_9:
	subi 1,22
	popj 17,

dec_Dint_10:
	subi 1,24
	popj 17,

dec_Dint_11:
	subi 1,26
	popj 17,

dec_Dint_12:
	subi 1,30
	popj 17,

dec_Dint_0:
	popj 17,

dec_Dint_dynamic:
	lsh 2,1
	sub 1,2
	popj 17,

subassign_Dint:
	lsh 2,1
	sub 1,2
	popj 17,

predec_Dint:
	subi 1,2
	popj 17,

postdec_Dint:
	move 3,1
	subi 3,2
	move 4,1
	sub 4,3
	ash 4,-1
	jumpn 4,%L1183
	move 3,1
%L1183:
	move 1,3
	popj 17,

global_dec_Dint:
	move 1,gp_Dint
	subi 1,6
	popj 17,

volatile_dec_Dint:
	move 4,1
	move 1,vgp_Dint
	lsh 4,1
	sub 1,4
	movem 1,vgp_Dint
	popj 17,

array_end_dec_Dint:
	movei 1,arr_Dint+60
	popj 17,

index_dec_Dint:
	lsh 1,1
	xmovei 1,arr_Dint(1)
	lsh 2,1
	sub 1,2
	popj 17,

load_before_Dint:
	move 4,-2(1)
	move 5,-1(1)
	move 1,4
	move 2,5
	popj 17,

store_before_Dint:
	movem 2,-4(1)
	movem 3,-3(1)
	popj 17,

diff_after_dec_Dint:
	lsh 2,1
	ash 2,-1
	move 1,2
	popj 17,

compare_after_dec_Dint:
	lsh 3,1
	sub 1,3
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_uDint:
	.long	arr_uDint+48
	.align	2
vgp_uDint:
	.long	arr_uDint+56

dec_uDint_1:
	subi 1,2
	popj 17,

dec_uDint_2:
	subi 1,4
	popj 17,

dec_uDint_3:
	subi 1,6
	popj 17,

dec_uDint_4:
	subi 1,10
	popj 17,

dec_uDint_5:
	subi 1,12
	popj 17,

dec_uDint_6:
	subi 1,14
	popj 17,

dec_uDint_7:
	subi 1,16
	popj 17,

dec_uDint_8:
	subi 1,20
	popj 17,

dec_uDint_9:
	subi 1,22
	popj 17,

dec_uDint_10:
	subi 1,24
	popj 17,

dec_uDint_11:
	subi 1,26
	popj 17,

dec_uDint_12:
	subi 1,30
	popj 17,

dec_uDint_0:
	popj 17,

dec_uDint_dynamic:
	lsh 2,1
	sub 1,2
	popj 17,

subassign_uDint:
	lsh 2,1
	sub 1,2
	popj 17,

predec_uDint:
	subi 1,2
	popj 17,

postdec_uDint:
	move 3,1
	subi 3,2
	move 4,1
	sub 4,3
	ash 4,-1
	jumpn 4,%L1225
	move 3,1
%L1225:
	move 1,3
	popj 17,

global_dec_uDint:
	move 1,gp_uDint
	subi 1,6
	popj 17,

volatile_dec_uDint:
	move 4,1
	move 1,vgp_uDint
	lsh 4,1
	sub 1,4
	movem 1,vgp_uDint
	popj 17,

array_end_dec_uDint:
	movei 1,arr_uDint+60
	popj 17,

index_dec_uDint:
	lsh 1,1
	xmovei 1,arr_uDint(1)
	lsh 2,1
	sub 1,2
	popj 17,

load_before_uDint:
	move 4,-2(1)
	move 5,-1(1)
	move 1,4
	move 2,5
	popj 17,

store_before_uDint:
	movem 2,-4(1)
	movem 3,-3(1)
	popj 17,

diff_after_dec_uDint:
	lsh 2,1
	ash 2,-1
	move 1,2
	popj 17,

compare_after_dec_uDint:
	lsh 3,1
	sub 1,3
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_Qint3:
	.long	arr_Qint3+29142024210
	.align	2
vgp_Qint3:
	.long	arr_Qint3+29142024213

dec_Qint3_1:
	subi 1,1
	ibp 1
	popj 17,

dec_Qint3_2:
	subi 1,2
	ibp 1
	ibp 1
	popj 17,

dec_Qint3_3:
	subi 1,3
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_Qint3_4:
	subi 1,3
	popj 17,

dec_Qint3_5:
	subi 1,4
	ibp 1
	popj 17,

dec_Qint3_6:
	subi 1,5
	ibp 1
	ibp 1
	popj 17,

dec_Qint3_7:
	subi 1,6
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_Qint3_8:
	subi 1,6
	popj 17,

dec_Qint3_9:
	subi 1,7
	ibp 1
	popj 17,

dec_Qint3_10:
	subi 1,10
	ibp 1
	ibp 1
	popj 17,

dec_Qint3_11:
	subi 1,11
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_Qint3_12:
	subi 1,11
	popj 17,

dec_Qint3_0:
	popj 17,

dec_Qint3_dynamic:
	move 4,2
	lsh 4,1
	add 4,2
	movn 4,4
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1263
%L1262:
	ibp 1
	sojn 3,%L1262	; decrement_and_branch_until_zero
%L1263:
	popj 17,

subassign_Qint3:
	move 4,2
	lsh 4,1
	add 4,2
	movn 4,4
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1267
%L1266:
	ibp 1
	sojn 3,%L1266	; decrement_and_branch_until_zero
%L1267:
	popj 17,

predec_Qint3:
	subi 1,1
	ibp 1
	popj 17,

postdec_Qint3:
	setzb 4,5
	move 2,1
	push 17,0
	movei 0,3
	push 17,0
	push 17,2
	push 17,0
	subi 2,1
	movem 2,(17)
	ibp 2
	came 2,-1(17)
	jrst .-3
	move 2,(17)
	pop 17,0
	pop 17,0
	sosle (17)
	jrst .-11
	pop 17,0
	pop 17,0
	move 6,1
	sub 6,2
	muli 6,10
	move 3,7
	ash 3,-1
	move 4,3
	add 4,%BADL9(6)
	idivi 4,3
	jumpn 4,%L1271
	move 2,1
%L1271:
	move 1,2
	popj 17,

global_dec_Qint3:
	move 1,gp_Qint3
	subi 1,3
	ibp 1
	ibp 1
	ibp 1
	popj 17,

volatile_dec_Qint3:
	move 2,vgp_Qint3
	move 4,1
	lsh 4,1
	add 4,1
	movn 4,4
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 2,4
	jumpe 3,%L1278
%L1277:
	ibp 2
	sojn 3,%L1277	; decrement_and_branch_until_zero
%L1278:
	movem 2,vgp_Qint3
	move 1,2
	popj 17,

array_end_dec_Qint3:
	move 1,[POINT 9,arr_Qint3+22,8]
	popj 17,

index_dec_Qint3:
	move 4,1
	lsh 4,1
	add 4,1
	move 3,4
	andi 3,3
	move 6,4
	ash 6,-2	; ashrsi3_pointer
	add 6,[POINT 9,arr_Qint3,8]
	jumpe 3,%L1285
%L1284:
	ibp 6
	sojn 3,%L1284	; decrement_and_branch_until_zero
%L1285:
	move 4,2
	lsh 4,1
	add 4,2
	movn 4,4
	move 3,4
	andi 3,3
	move 1,4
	ash 1,-2	; ashrsi3_pointer
	add 1,6
	jumpe 3,%L1288
%L1287:
	ibp 1
	sojn 3,%L1287	; decrement_and_branch_until_zero
%L1288:
	popj 17,

load_before_Qint3:
	move 4,1
	subi 4,1
	ibp 4
	move 1,(4)
	lsh 1,-11
	and 1,[777000000]
	ldb 3,[POINT 9,(4),17]
	dpb 3,[POINT 9,1,26]
	ldb 4,[POINT 9,(4),26]
	dpb 4,[POINT 9,1,35]
	popj 17,

store_before_Qint3:
	add 17,[1,,1]
	lsh 2,11
	movem 2,(17)
	subi 1,2
	ibp 1
	ibp 1
	movei 2,(17)
	tlo 2,331100
	movei 3,3
	pushj 17,memcpy
	add 17,[-1,,-1]
	popj 17,

diff_after_dec_Qint3:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setzb 6,7
	move 4,2
	lsh 4,1
	add 4,2
	movn 4,4
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 4,1
	jumpe 3,%L1296
%L1295:
	ibp 4
	sojn 3,%L1295	; decrement_and_branch_until_zero
%L1296:
	move 10,1
	sub 10,4
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

compare_after_dec_Qint3:
	move 4,3
	lsh 4,1
	add 4,3
	movn 4,4
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1302
%L1301:
	ibp 1
	sojn 3,%L1301	; decrement_and_branch_until_zero
%L1302:
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_uQint3:
	.long	arr_uQint3+29142024210
	.align	2
vgp_uQint3:
	.long	arr_uQint3+29142024213

dec_uQint3_1:
	subi 1,1
	ibp 1
	popj 17,

dec_uQint3_2:
	subi 1,2
	ibp 1
	ibp 1
	popj 17,

dec_uQint3_3:
	subi 1,3
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_uQint3_4:
	subi 1,3
	popj 17,

dec_uQint3_5:
	subi 1,4
	ibp 1
	popj 17,

dec_uQint3_6:
	subi 1,5
	ibp 1
	ibp 1
	popj 17,

dec_uQint3_7:
	subi 1,6
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_uQint3_8:
	subi 1,6
	popj 17,

dec_uQint3_9:
	subi 1,7
	ibp 1
	popj 17,

dec_uQint3_10:
	subi 1,10
	ibp 1
	ibp 1
	popj 17,

dec_uQint3_11:
	subi 1,11
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_uQint3_12:
	subi 1,11
	popj 17,

dec_uQint3_0:
	popj 17,

dec_uQint3_dynamic:
	move 4,2
	lsh 4,1
	add 4,2
	movn 4,4
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1321
%L1320:
	ibp 1
	sojn 3,%L1320	; decrement_and_branch_until_zero
%L1321:
	popj 17,

subassign_uQint3:
	move 4,2
	lsh 4,1
	add 4,2
	movn 4,4
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1325
%L1324:
	ibp 1
	sojn 3,%L1324	; decrement_and_branch_until_zero
%L1325:
	popj 17,

predec_uQint3:
	subi 1,1
	ibp 1
	popj 17,

postdec_uQint3:
	setzb 4,5
	move 2,1
	push 17,0
	movei 0,3
	push 17,0
	push 17,2
	push 17,0
	subi 2,1
	movem 2,(17)
	ibp 2
	came 2,-1(17)
	jrst .-3
	move 2,(17)
	pop 17,0
	pop 17,0
	sosle (17)
	jrst .-11
	pop 17,0
	pop 17,0
	move 6,1
	sub 6,2
	muli 6,10
	move 3,7
	ash 3,-1
	move 4,3
	add 4,%BADL9(6)
	idivi 4,3
	jumpn 4,%L1329
	move 2,1
%L1329:
	move 1,2
	popj 17,

global_dec_uQint3:
	move 1,gp_uQint3
	subi 1,3
	ibp 1
	ibp 1
	ibp 1
	popj 17,

volatile_dec_uQint3:
	move 2,vgp_uQint3
	move 4,1
	lsh 4,1
	add 4,1
	movn 4,4
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 2,4
	jumpe 3,%L1336
%L1335:
	ibp 2
	sojn 3,%L1335	; decrement_and_branch_until_zero
%L1336:
	movem 2,vgp_uQint3
	move 1,2
	popj 17,

array_end_dec_uQint3:
	move 1,[POINT 9,arr_uQint3+22,8]
	popj 17,

index_dec_uQint3:
	move 4,1
	lsh 4,1
	add 4,1
	move 3,4
	andi 3,3
	move 6,4
	ash 6,-2	; ashrsi3_pointer
	add 6,[POINT 9,arr_uQint3,8]
	jumpe 3,%L1343
%L1342:
	ibp 6
	sojn 3,%L1342	; decrement_and_branch_until_zero
%L1343:
	move 4,2
	lsh 4,1
	add 4,2
	movn 4,4
	move 3,4
	andi 3,3
	move 1,4
	ash 1,-2	; ashrsi3_pointer
	add 1,6
	jumpe 3,%L1346
%L1345:
	ibp 1
	sojn 3,%L1345	; decrement_and_branch_until_zero
%L1346:
	popj 17,

load_before_uQint3:
	move 4,1
	subi 4,1
	ibp 4
	move 1,(4)
	lsh 1,-11
	and 1,[777000000]
	ldb 3,[POINT 9,(4),17]
	dpb 3,[POINT 9,1,26]
	ldb 4,[POINT 9,(4),26]
	dpb 4,[POINT 9,1,35]
	popj 17,

store_before_uQint3:
	add 17,[1,,1]
	lsh 2,11
	movem 2,(17)
	subi 1,2
	ibp 1
	ibp 1
	movei 2,(17)
	tlo 2,331100
	movei 3,3
	pushj 17,memcpy
	add 17,[-1,,-1]
	popj 17,

diff_after_dec_uQint3:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setzb 6,7
	move 4,2
	lsh 4,1
	add 4,2
	movn 4,4
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 4,1
	jumpe 3,%L1354
%L1353:
	ibp 4
	sojn 3,%L1353	; decrement_and_branch_until_zero
%L1354:
	move 10,1
	sub 10,4
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

compare_after_dec_uQint3:
	move 4,3
	lsh 4,1
	add 4,3
	movn 4,4
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1360
%L1359:
	ibp 1
	sojn 3,%L1359	; decrement_and_branch_until_zero
%L1360:
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_Hint3:
	.long	arr_Hint3+19629342756
	.align	2
vgp_Hint3:
	.long	arr_Hint3+19629342762

dec_Hint3_1:
	subi 1,2
	ibp 1
	popj 17,

dec_Hint3_2:
	subi 1,3
	popj 17,

dec_Hint3_3:
	subi 1,5
	ibp 1
	popj 17,

dec_Hint3_4:
	subi 1,6
	popj 17,

dec_Hint3_5:
	subi 1,10
	ibp 1
	popj 17,

dec_Hint3_6:
	subi 1,11
	popj 17,

dec_Hint3_7:
	subi 1,13
	ibp 1
	popj 17,

dec_Hint3_8:
	subi 1,14
	popj 17,

dec_Hint3_9:
	subi 1,16
	ibp 1
	popj 17,

dec_Hint3_10:
	subi 1,17
	popj 17,

dec_Hint3_11:
	subi 1,21
	ibp 1
	popj 17,

dec_Hint3_12:
	subi 1,22
	popj 17,

dec_Hint3_0:
	popj 17,

dec_Hint3_dynamic:
	move 4,2
	lsh 4,1
	add 4,2
	movn 4,4
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1379
%L1378:
	ibp 1
	sojn 3,%L1378	; decrement_and_branch_until_zero
%L1379:
	popj 17,

subassign_Hint3:
	move 4,2
	lsh 4,1
	add 4,2
	movn 4,4
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1383
%L1382:
	ibp 1
	sojn 3,%L1382	; decrement_and_branch_until_zero
%L1383:
	popj 17,

predec_Hint3:
	subi 1,2
	ibp 1
	popj 17,

postdec_Hint3:
	setzb 4,5
	move 2,1
	push 17,0
	movei 0,3
	push 17,0
	push 17,2
	push 17,0
	subi 2,1
	movem 2,(17)
	ibp 2
	came 2,-1(17)
	jrst .-3
	move 2,(17)
	pop 17,0
	pop 17,0
	sosle (17)
	jrst .-11
	pop 17,0
	pop 17,0
	move 6,1
	sub 6,2
	muli 6,4
	move 3,7
	ash 3,-1
	add 3,%BADLH(6)
	move 4,3
	idivi 4,3
	jumpn 4,%L1387
	move 2,1
%L1387:
	move 1,2
	popj 17,

global_dec_Hint3:
	move 1,gp_Hint3
	subi 1,5
	ibp 1
	popj 17,

volatile_dec_Hint3:
	move 2,vgp_Hint3
	move 4,1
	lsh 4,1
	add 4,1
	movn 4,4
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 2,4
	jumpe 3,%L1394
%L1393:
	ibp 2
	sojn 3,%L1393	; decrement_and_branch_until_zero
%L1394:
	movem 2,vgp_Hint3
	move 1,2
	popj 17,

array_end_dec_Hint3:
	move 1,[POINT 18,arr_Hint3+44,17]
	popj 17,

index_dec_Hint3:
	move 4,1
	lsh 4,1
	add 4,1
	move 3,4
	andi 3,1
	move 6,4
	ash 6,-1	; ashrsi3_pointer
	add 6,[POINT 18,arr_Hint3,17]
	jumpe 3,%L1401
%L1400:
	ibp 6
	sojn 3,%L1400	; decrement_and_branch_until_zero
%L1401:
	move 4,2
	lsh 4,1
	add 4,2
	movn 4,4
	move 3,4
	andi 3,1
	move 1,4
	ash 1,-1	; ashrsi3_pointer
	add 1,6
	jumpe 3,%L1404
%L1403:
	ibp 1
	sojn 3,%L1403	; decrement_and_branch_until_zero
%L1404:
	popj 17,

load_before_Hint3:
	subi 1,2
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

store_before_Hint3:
	subi 1,3
	movei 2,-2(17)
	tlc 2,113300
	movei 3,6
	pushj 17,memcpy
	popj 17,

diff_after_dec_Hint3:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setzb 6,7
	move 4,2
	lsh 4,1
	add 4,2
	movn 4,4
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 4,1
	jumpe 3,%L1412
%L1411:
	ibp 4
	sojn 3,%L1411	; decrement_and_branch_until_zero
%L1412:
	move 10,1
	sub 10,4
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

compare_after_dec_Hint3:
	move 4,3
	lsh 4,1
	add 4,3
	movn 4,4
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1418
%L1417:
	ibp 1
	sojn 3,%L1417	; decrement_and_branch_until_zero
%L1418:
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_uHint3:
	.long	arr_uHint3+19629342756
	.align	2
vgp_uHint3:
	.long	arr_uHint3+19629342762

dec_uHint3_1:
	subi 1,2
	ibp 1
	popj 17,

dec_uHint3_2:
	subi 1,3
	popj 17,

dec_uHint3_3:
	subi 1,5
	ibp 1
	popj 17,

dec_uHint3_4:
	subi 1,6
	popj 17,

dec_uHint3_5:
	subi 1,10
	ibp 1
	popj 17,

dec_uHint3_6:
	subi 1,11
	popj 17,

dec_uHint3_7:
	subi 1,13
	ibp 1
	popj 17,

dec_uHint3_8:
	subi 1,14
	popj 17,

dec_uHint3_9:
	subi 1,16
	ibp 1
	popj 17,

dec_uHint3_10:
	subi 1,17
	popj 17,

dec_uHint3_11:
	subi 1,21
	ibp 1
	popj 17,

dec_uHint3_12:
	subi 1,22
	popj 17,

dec_uHint3_0:
	popj 17,

dec_uHint3_dynamic:
	move 4,2
	lsh 4,1
	add 4,2
	movn 4,4
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1437
%L1436:
	ibp 1
	sojn 3,%L1436	; decrement_and_branch_until_zero
%L1437:
	popj 17,

subassign_uHint3:
	move 4,2
	lsh 4,1
	add 4,2
	movn 4,4
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1441
%L1440:
	ibp 1
	sojn 3,%L1440	; decrement_and_branch_until_zero
%L1441:
	popj 17,

predec_uHint3:
	subi 1,2
	ibp 1
	popj 17,

postdec_uHint3:
	setzb 4,5
	move 2,1
	push 17,0
	movei 0,3
	push 17,0
	push 17,2
	push 17,0
	subi 2,1
	movem 2,(17)
	ibp 2
	came 2,-1(17)
	jrst .-3
	move 2,(17)
	pop 17,0
	pop 17,0
	sosle (17)
	jrst .-11
	pop 17,0
	pop 17,0
	move 6,1
	sub 6,2
	muli 6,4
	move 3,7
	ash 3,-1
	add 3,%BADLH(6)
	move 4,3
	idivi 4,3
	jumpn 4,%L1445
	move 2,1
%L1445:
	move 1,2
	popj 17,

global_dec_uHint3:
	move 1,gp_uHint3
	subi 1,5
	ibp 1
	popj 17,

volatile_dec_uHint3:
	move 2,vgp_uHint3
	move 4,1
	lsh 4,1
	add 4,1
	movn 4,4
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 2,4
	jumpe 3,%L1452
%L1451:
	ibp 2
	sojn 3,%L1451	; decrement_and_branch_until_zero
%L1452:
	movem 2,vgp_uHint3
	move 1,2
	popj 17,

array_end_dec_uHint3:
	move 1,[POINT 18,arr_uHint3+44,17]
	popj 17,

index_dec_uHint3:
	move 4,1
	lsh 4,1
	add 4,1
	move 3,4
	andi 3,1
	move 6,4
	ash 6,-1	; ashrsi3_pointer
	add 6,[POINT 18,arr_uHint3,17]
	jumpe 3,%L1459
%L1458:
	ibp 6
	sojn 3,%L1458	; decrement_and_branch_until_zero
%L1459:
	move 4,2
	lsh 4,1
	add 4,2
	movn 4,4
	move 3,4
	andi 3,1
	move 1,4
	ash 1,-1	; ashrsi3_pointer
	add 1,6
	jumpe 3,%L1462
%L1461:
	ibp 1
	sojn 3,%L1461	; decrement_and_branch_until_zero
%L1462:
	popj 17,

load_before_uHint3:
	subi 1,2
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

store_before_uHint3:
	subi 1,3
	movei 2,-2(17)
	tlc 2,113300
	movei 3,6
	pushj 17,memcpy
	popj 17,

diff_after_dec_uHint3:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setzb 6,7
	move 4,2
	lsh 4,1
	add 4,2
	movn 4,4
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 4,1
	jumpe 3,%L1470
%L1469:
	ibp 4
	sojn 3,%L1469	; decrement_and_branch_until_zero
%L1470:
	move 10,1
	sub 10,4
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

compare_after_dec_uHint3:
	move 4,3
	lsh 4,1
	add 4,3
	movn 4,4
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1476
%L1475:
	ibp 1
	sojn 3,%L1475	; decrement_and_branch_until_zero
%L1476:
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_Sint3:
	.long	arr_Sint3+72
	.align	2
vgp_Sint3:
	.long	arr_Sint3+84

dec_Sint3_1:
	subi 1,3
	popj 17,

dec_Sint3_2:
	subi 1,6
	popj 17,

dec_Sint3_3:
	subi 1,11
	popj 17,

dec_Sint3_4:
	subi 1,14
	popj 17,

dec_Sint3_5:
	subi 1,17
	popj 17,

dec_Sint3_6:
	subi 1,22
	popj 17,

dec_Sint3_7:
	subi 1,25
	popj 17,

dec_Sint3_8:
	subi 1,30
	popj 17,

dec_Sint3_9:
	subi 1,33
	popj 17,

dec_Sint3_10:
	subi 1,36
	popj 17,

dec_Sint3_11:
	subi 1,41
	popj 17,

dec_Sint3_12:
	subi 1,44
	popj 17,

dec_Sint3_0:
	popj 17,

dec_Sint3_dynamic:
	move 4,2
	lsh 4,1
	add 4,2
	sub 1,4
	popj 17,

subassign_Sint3:
	move 4,2
	lsh 4,1
	add 4,2
	sub 1,4
	popj 17,

predec_Sint3:
	subi 1,3
	popj 17,

postdec_Sint3:
	setzb 4,5
	move 2,1
	subi 2,3
	move 3,1
	sub 3,2
	move 4,3
	idivi 4,3
	jumpn 4,%L1499
	move 2,1
%L1499:
	move 1,2
	popj 17,

global_dec_Sint3:
	move 1,gp_Sint3
	subi 1,11
	popj 17,

volatile_dec_Sint3:
	move 3,1
	move 1,vgp_Sint3
	move 4,3
	lsh 4,1
	add 4,3
	sub 1,4
	movem 1,vgp_Sint3
	popj 17,

array_end_dec_Sint3:
	movei 1,arr_Sint3+110
	popj 17,

index_dec_Sint3:
	move 4,1
	lsh 1,1
	add 1,4
	xmovei 1,arr_Sint3(1)
	move 4,2
	lsh 4,1
	add 4,2
	sub 1,4
	popj 17,

load_before_Sint3:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	movei 11,0
	move 5,-3(1)
	move 12,-2(1)
	move 13,-1(1)
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

store_before_Sint3:
	add 17,[3,,3]
	movem 2,-2(17)
	movem 3,-1(17)
	movem 4,(17)
	hrroi 6,777772
	add 6,1
	movei 4,(6)
	hrli 4,-2(17)
	blt 4,-4(1)
	add 17,[-3,,-3]
	popj 17,

diff_after_dec_Sint3:
	setzb 4,5
	move 3,2
	lsh 3,1
	add 3,2
	move 4,3
	idivi 4,3
	move 1,4
	popj 17,

compare_after_dec_Sint3:
	move 4,3
	lsh 4,1
	add 4,3
	sub 1,4
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_uSint3:
	.long	arr_uSint3+72
	.align	2
vgp_uSint3:
	.long	arr_uSint3+84

dec_uSint3_1:
	subi 1,3
	popj 17,

dec_uSint3_2:
	subi 1,6
	popj 17,

dec_uSint3_3:
	subi 1,11
	popj 17,

dec_uSint3_4:
	subi 1,14
	popj 17,

dec_uSint3_5:
	subi 1,17
	popj 17,

dec_uSint3_6:
	subi 1,22
	popj 17,

dec_uSint3_7:
	subi 1,25
	popj 17,

dec_uSint3_8:
	subi 1,30
	popj 17,

dec_uSint3_9:
	subi 1,33
	popj 17,

dec_uSint3_10:
	subi 1,36
	popj 17,

dec_uSint3_11:
	subi 1,41
	popj 17,

dec_uSint3_12:
	subi 1,44
	popj 17,

dec_uSint3_0:
	popj 17,

dec_uSint3_dynamic:
	move 4,2
	lsh 4,1
	add 4,2
	sub 1,4
	popj 17,

subassign_uSint3:
	move 4,2
	lsh 4,1
	add 4,2
	sub 1,4
	popj 17,

predec_uSint3:
	subi 1,3
	popj 17,

postdec_uSint3:
	setzb 4,5
	move 2,1
	subi 2,3
	move 3,1
	sub 3,2
	move 4,3
	idivi 4,3
	jumpn 4,%L1541
	move 2,1
%L1541:
	move 1,2
	popj 17,

global_dec_uSint3:
	move 1,gp_uSint3
	subi 1,11
	popj 17,

volatile_dec_uSint3:
	move 3,1
	move 1,vgp_uSint3
	move 4,3
	lsh 4,1
	add 4,3
	sub 1,4
	movem 1,vgp_uSint3
	popj 17,

array_end_dec_uSint3:
	movei 1,arr_uSint3+110
	popj 17,

index_dec_uSint3:
	move 4,1
	lsh 1,1
	add 1,4
	xmovei 1,arr_uSint3(1)
	move 4,2
	lsh 4,1
	add 4,2
	sub 1,4
	popj 17,

load_before_uSint3:
	add 17,[4,,4]
	movei 0,-3(17)
	hrli 0,10
	blt 0,(17)
	movei 11,0
	move 5,-3(1)
	move 12,-2(1)
	move 13,-1(1)
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

store_before_uSint3:
	add 17,[3,,3]
	movem 2,-2(17)
	movem 3,-1(17)
	movem 4,(17)
	hrroi 6,777772
	add 6,1
	movei 4,(6)
	hrli 4,-2(17)
	blt 4,-4(1)
	add 17,[-3,,-3]
	popj 17,

diff_after_dec_uSint3:
	setzb 4,5
	move 3,2
	lsh 3,1
	add 3,2
	move 4,3
	idivi 4,3
	move 1,4
	popj 17,

compare_after_dec_uSint3:
	move 4,3
	lsh 4,1
	add 4,3
	sub 1,4
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_char6_7:
	.long	arr_char6_7+32312918036
	.align	2
vgp_char6_7:
	.long	arr_char6_7+19428016151

dec_char6_7_1:
	subi 1,1
	ibp 1
	popj 17,

dec_char6_7_2:
	subi 1,2
	ibp 1
	ibp 1
	popj 17,

dec_char6_7_3:
	subi 1,3
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_char6_7_4:
	subi 1,4
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_char6_7_5:
	subi 1,5
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_char6_7_6:
	subi 1,5
	popj 17,

dec_char6_7_7:
	subi 1,6
	ibp 1
	popj 17,

dec_char6_7_8:
	subi 1,7
	ibp 1
	ibp 1
	popj 17,

dec_char6_7_9:
	subi 1,10
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_char6_7_10:
	subi 1,11
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_char6_7_11:
	subi 1,12
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_char6_7_12:
	subi 1,12
	popj 17,

dec_char6_7_0:
	popj 17,

dec_char6_7_dynamic:
	move 4,2
	lsh 4,2
	add 4,2
	movn 4,4
	jumple 4,%L1579
%L1578:
	ibp 1
	sojg 4,%L1578	; decrement_and_branch_until_zero
%L1579:
	jumpe 4,%L1581
%L1580:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L1580
%L1581:
	popj 17,

subassign_char6_7:
	move 4,2
	lsh 4,2
	add 4,2
	movn 4,4
	jumple 4,%L1585
%L1584:
	ibp 1
	sojg 4,%L1584	; decrement_and_branch_until_zero
%L1585:
	jumpe 4,%L1587
%L1586:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L1586
%L1587:
	popj 17,

predec_char6_7:
	subi 1,1
	ibp 1
	popj 17,

postdec_char6_7:
	setzb 4,5
	move 2,1
	push 17,0
	movei 0,5
	push 17,0
	push 17,2
	push 17,0
	subi 2,1
	movem 2,(17)
	ibp 2
	came 2,-1(17)
	jrst .-3
	move 2,(17)
	pop 17,0
	pop 17,0
	sosle (17)
	jrst .-11
	pop 17,0
	pop 17,0
	move 6,1
	sub 6,2
	muli 6,14
	move 3,7
	ash 3,-1
	move 4,3
	add 4,%BADL6(6)
	idivi 4,5
	jumpn 4,%L1591
	move 2,1
%L1591:
	move 1,2
	popj 17,

global_dec_char6_7:
	move 1,gp_char6_7
	subi 1,3
	ibp 1
	ibp 1
	ibp 1
	popj 17,

volatile_dec_char6_7:
	move 3,vgp_char6_7
	move 4,1
	lsh 4,2
	add 4,1
	movn 4,4
	jumple 4,%L1598
%L1597:
	ibp 3
	sojg 4,%L1597	; decrement_and_branch_until_zero
%L1598:
	jumpe 4,%L1600
%L1599:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L1599
%L1600:
	movem 3,vgp_char6_7
	move 1,3
	popj 17,

array_end_dec_char6_7:
	move 1,[POINT 6,arr_char6_7+24,5]
	popj 17,

index_dec_char6_7:
	move 4,1
	lsh 4,2
	move 3,[POINT 6,arr_char6_7,5]
	add 4,1
	jumple 4,%L1607
%L1606:
	ibp 3
	sojg 4,%L1606	; decrement_and_branch_until_zero
%L1607:
	jumpe 4,%L1609
%L1608:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L1608
%L1609:
	move 4,2
	lsh 4,2
	add 4,2
	move 1,3
	movn 4,4
	jumple 4,%L1612
%L1611:
	ibp 1
	sojg 4,%L1611	; decrement_and_branch_until_zero
%L1612:
	jumpe 4,%L1614
%L1613:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L1613
%L1614:
	popj 17,

load_before_char6_7:
	subi 1,1
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

store_before_char6_7:
	subi 1,2
	ibp 1
	ibp 1
	movei 2,@[%EXIND(0,17,777776)]
	movei 3,5
	pushj 17,memcpy
	popj 17,

diff_after_dec_char6_7:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setzb 6,7
	move 4,2
	lsh 4,2
	add 4,2
	move 3,1
	movn 4,4
	jumple 4,%L1622
%L1621:
	ibp 3
	sojg 4,%L1621	; decrement_and_branch_until_zero
%L1622:
	jumpe 4,%L1624
%L1623:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L1623
%L1624:
	move 10,1
	sub 10,3
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

compare_after_dec_char6_7:
	move 4,3
	lsh 4,2
	add 4,3
	movn 4,4
	jumple 4,%L1630
%L1629:
	ibp 1
	sojg 4,%L1629	; decrement_and_branch_until_zero
%L1630:
	jumpe 4,%L1632
%L1631:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L1631
%L1632:
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_char7_6:
	.long	arr_char7_6+31255953432
	.align	2
vgp_char7_6:
	.long	arr_char7_6+31255953436

dec_char7_6_1:
	subi 1,1
	popj 17,

dec_char7_6_2:
	subi 1,2
	popj 17,

dec_char7_6_3:
	subi 1,3
	popj 17,

dec_char7_6_4:
	subi 1,4
	popj 17,

dec_char7_6_5:
	subi 1,5
	popj 17,

dec_char7_6_6:
	subi 1,6
	popj 17,

dec_char7_6_7:
	subi 1,7
	popj 17,

dec_char7_6_8:
	subi 1,10
	popj 17,

dec_char7_6_9:
	subi 1,11
	popj 17,

dec_char7_6_10:
	subi 1,12
	popj 17,

dec_char7_6_11:
	subi 1,13
	popj 17,

dec_char7_6_12:
	subi 1,14
	popj 17,

dec_char7_6_0:
	popj 17,

dec_char7_6_dynamic:
	move 4,2
	lsh 4,2
	add 4,2
	movn 4,4
	jumple 4,%L1651
%L1650:
	ibp 1
	sojg 4,%L1650	; decrement_and_branch_until_zero
%L1651:
	jumpe 4,%L1653
%L1652:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L1652
%L1653:
	popj 17,

subassign_char7_6:
	move 4,2
	lsh 4,2
	add 4,2
	movn 4,4
	jumple 4,%L1657
%L1656:
	ibp 1
	sojg 4,%L1656	; decrement_and_branch_until_zero
%L1657:
	jumpe 4,%L1659
%L1658:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L1658
%L1659:
	popj 17,

predec_char7_6:
	subi 1,1
	popj 17,

postdec_char7_6:
	setzb 4,5
	move 2,1
	push 17,0
	movei 0,5
	push 17,0
	push 17,2
	push 17,0
	subi 2,1
	movem 2,(17)
	ibp 2
	came 2,-1(17)
	jrst .-3
	move 2,(17)
	pop 17,0
	pop 17,0
	sosle (17)
	jrst .-11
	pop 17,0
	pop 17,0
	move 6,1
	sub 6,2
	muli 6,12
	move 3,7
	ash 3,-1
	move 4,3
	add 4,%BADL7(6)
	idivi 4,5
	jumpn 4,%L1663
	move 2,1
%L1663:
	move 1,2
	popj 17,

global_dec_char7_6:
	move 1,gp_char7_6
	subi 1,3
	popj 17,

volatile_dec_char7_6:
	move 3,vgp_char7_6
	move 4,1
	lsh 4,2
	add 4,1
	movn 4,4
	jumple 4,%L1670
%L1669:
	ibp 3
	sojg 4,%L1669	; decrement_and_branch_until_zero
%L1670:
	jumpe 4,%L1672
%L1671:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L1671
%L1672:
	movem 3,vgp_char7_6
	move 1,3
	popj 17,

array_end_dec_char7_6:
	move 1,[POINT 7,arr_char7_6+30,6]
	popj 17,

index_dec_char7_6:
	move 4,1
	lsh 4,2
	move 3,[POINT 7,arr_char7_6,6]
	add 4,1
	jumple 4,%L1679
%L1678:
	ibp 3
	sojg 4,%L1678	; decrement_and_branch_until_zero
%L1679:
	jumpe 4,%L1681
%L1680:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L1680
%L1681:
	move 4,2
	lsh 4,2
	add 4,2
	move 1,3
	movn 4,4
	jumple 4,%L1684
%L1683:
	ibp 1
	sojg 4,%L1683	; decrement_and_branch_until_zero
%L1684:
	jumpe 4,%L1686
%L1685:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L1685
%L1686:
	popj 17,

load_before_char7_6:
	ldb 4,[POINT 9,-1(1),17]
	lsh 4,33
	ldb 3,[POINT 9,-1(1),26]
	dpb 3,[POINT 9,4,17]
	ldb 3,[POINT 9,-1(1),35]
	dpb 3,[POINT 9,4,26]
	move 3,(1)
	lsh 3,-33
	dpb 3,[POINT 9,4,35]
	move 6,-1(1)
	lsh 6,-33
	move 7,4
	move 1,6
	move 2,7
	popj 17,

store_before_char7_6:
	subi 1,2
	movei 2,@[%EXIND(0,17,777776)]
	movei 3,5
	pushj 17,memcpy
	popj 17,

diff_after_dec_char7_6:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setzb 6,7
	move 4,2
	lsh 4,2
	add 4,2
	move 3,1
	movn 4,4
	jumple 4,%L1694
%L1693:
	ibp 3
	sojg 4,%L1693	; decrement_and_branch_until_zero
%L1694:
	jumpe 4,%L1696
%L1695:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L1695
%L1696:
	move 10,1
	sub 10,3
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

compare_after_dec_char7_6:
	move 4,3
	lsh 4,2
	add 4,3
	movn 4,4
	jumple 4,%L1702
%L1701:
	ibp 1
	sojg 4,%L1701	; decrement_and_branch_until_zero
%L1702:
	jumpe 4,%L1704
%L1703:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 4,%L1703
%L1704:
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_char8_5:
	.long	arr_char8_5+30198988830
	.align	2
vgp_char8_5:
	.long	arr_char8_5+30198988835

dec_char8_5_1:
	subi 1,2
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_char8_5_2:
	subi 1,3
	ibp 1
	ibp 1
	popj 17,

dec_char8_5_3:
	subi 1,4
	ibp 1
	popj 17,

dec_char8_5_4:
	subi 1,5
	popj 17,

dec_char8_5_5:
	subi 1,7
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_char8_5_6:
	subi 1,10
	ibp 1
	ibp 1
	popj 17,

dec_char8_5_7:
	subi 1,11
	ibp 1
	popj 17,

dec_char8_5_8:
	subi 1,12
	popj 17,

dec_char8_5_9:
	subi 1,14
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_char8_5_10:
	subi 1,15
	ibp 1
	ibp 1
	popj 17,

dec_char8_5_11:
	subi 1,16
	ibp 1
	popj 17,

dec_char8_5_12:
	subi 1,17
	popj 17,

dec_char8_5_0:
	popj 17,

dec_char8_5_dynamic:
	move 4,2
	lsh 4,2
	add 4,2
	movn 4,4
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1723
%L1722:
	ibp 1
	sojn 3,%L1722	; decrement_and_branch_until_zero
%L1723:
	popj 17,

subassign_char8_5:
	move 4,2
	lsh 4,2
	add 4,2
	movn 4,4
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1727
%L1726:
	ibp 1
	sojn 3,%L1726	; decrement_and_branch_until_zero
%L1727:
	popj 17,

predec_char8_5:
	subi 1,2
	ibp 1
	ibp 1
	ibp 1
	popj 17,

postdec_char8_5:
	setzb 4,5
	move 2,1
	push 17,0
	movei 0,5
	push 17,0
	push 17,2
	push 17,0
	subi 2,1
	movem 2,(17)
	ibp 2
	came 2,-1(17)
	jrst .-3
	move 2,(17)
	pop 17,0
	pop 17,0
	sosle (17)
	jrst .-11
	pop 17,0
	pop 17,0
	move 6,1
	sub 6,2
	muli 6,10
	move 3,7
	ash 3,-1
	move 4,3
	add 4,%BADL8(6)
	idivi 4,5
	jumpn 4,%L1731
	move 2,1
%L1731:
	move 1,2
	popj 17,

global_dec_char8_5:
	move 1,gp_char8_5
	subi 1,4
	ibp 1
	popj 17,

volatile_dec_char8_5:
	move 2,vgp_char8_5
	move 4,1
	lsh 4,2
	add 4,1
	movn 4,4
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 2,4
	jumpe 3,%L1738
%L1737:
	ibp 2
	sojn 3,%L1737	; decrement_and_branch_until_zero
%L1738:
	movem 2,vgp_char8_5
	move 1,2
	popj 17,

array_end_dec_char8_5:
	move 1,[POINT 8,arr_char8_5+36,7]
	popj 17,

index_dec_char8_5:
	move 4,1
	lsh 4,2
	add 4,1
	move 3,4
	andi 3,3
	move 6,4
	ash 6,-2	; ashrsi3_pointer
	add 6,[POINT 8,arr_char8_5,7]
	jumpe 3,%L1745
%L1744:
	ibp 6
	sojn 3,%L1744	; decrement_and_branch_until_zero
%L1745:
	move 4,2
	lsh 4,2
	add 4,2
	movn 4,4
	move 3,4
	andi 3,3
	move 1,4
	ash 1,-2	; ashrsi3_pointer
	add 1,6
	jumpe 3,%L1748
%L1747:
	ibp 1
	sojn 3,%L1747	; decrement_and_branch_until_zero
%L1748:
	popj 17,

load_before_char8_5:
	subi 1,2
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

store_before_char8_5:
	subi 1,3
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

diff_after_dec_char8_5:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setzb 6,7
	move 4,2
	lsh 4,2
	add 4,2
	movn 4,4
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 4,1
	jumpe 3,%L1758
%L1757:
	ibp 4
	sojn 3,%L1757	; decrement_and_branch_until_zero
%L1758:
	move 10,1
	sub 10,4
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

compare_after_dec_char8_5:
	move 4,3
	lsh 4,2
	add 4,3
	movn 4,4
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1764
%L1763:
	ibp 1
	sojn 3,%L1763	; decrement_and_branch_until_zero
%L1764:
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_char9_5:
	.long	arr_char9_5+29142024222
	.align	2
vgp_char9_5:
	.long	arr_char9_5+29142024227

dec_char9_5_1:
	subi 1,2
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_char9_5_2:
	subi 1,3
	ibp 1
	ibp 1
	popj 17,

dec_char9_5_3:
	subi 1,4
	ibp 1
	popj 17,

dec_char9_5_4:
	subi 1,5
	popj 17,

dec_char9_5_5:
	subi 1,7
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_char9_5_6:
	subi 1,10
	ibp 1
	ibp 1
	popj 17,

dec_char9_5_7:
	subi 1,11
	ibp 1
	popj 17,

dec_char9_5_8:
	subi 1,12
	popj 17,

dec_char9_5_9:
	subi 1,14
	ibp 1
	ibp 1
	ibp 1
	popj 17,

dec_char9_5_10:
	subi 1,15
	ibp 1
	ibp 1
	popj 17,

dec_char9_5_11:
	subi 1,16
	ibp 1
	popj 17,

dec_char9_5_12:
	subi 1,17
	popj 17,

dec_char9_5_0:
	popj 17,

dec_char9_5_dynamic:
	move 4,2
	lsh 4,2
	add 4,2
	movn 4,4
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1783
%L1782:
	ibp 1
	sojn 3,%L1782	; decrement_and_branch_until_zero
%L1783:
	popj 17,

subassign_char9_5:
	move 4,2
	lsh 4,2
	add 4,2
	movn 4,4
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1787
%L1786:
	ibp 1
	sojn 3,%L1786	; decrement_and_branch_until_zero
%L1787:
	popj 17,

predec_char9_5:
	subi 1,2
	ibp 1
	ibp 1
	ibp 1
	popj 17,

postdec_char9_5:
	setzb 4,5
	move 2,1
	push 17,0
	movei 0,5
	push 17,0
	push 17,2
	push 17,0
	subi 2,1
	movem 2,(17)
	ibp 2
	came 2,-1(17)
	jrst .-3
	move 2,(17)
	pop 17,0
	pop 17,0
	sosle (17)
	jrst .-11
	pop 17,0
	pop 17,0
	move 6,1
	sub 6,2
	muli 6,10
	move 3,7
	ash 3,-1
	move 4,3
	add 4,%BADL9(6)
	idivi 4,5
	jumpn 4,%L1791
	move 2,1
%L1791:
	move 1,2
	popj 17,

global_dec_char9_5:
	move 1,gp_char9_5
	subi 1,4
	ibp 1
	popj 17,

volatile_dec_char9_5:
	move 2,vgp_char9_5
	move 4,1
	lsh 4,2
	add 4,1
	movn 4,4
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 2,4
	jumpe 3,%L1798
%L1797:
	ibp 2
	sojn 3,%L1797	; decrement_and_branch_until_zero
%L1798:
	movem 2,vgp_char9_5
	move 1,2
	popj 17,

array_end_dec_char9_5:
	move 1,[POINT 9,arr_char9_5+36,8]
	popj 17,

index_dec_char9_5:
	move 4,1
	lsh 4,2
	add 4,1
	move 3,4
	andi 3,3
	move 6,4
	ash 6,-2	; ashrsi3_pointer
	add 6,[POINT 9,arr_char9_5,8]
	jumpe 3,%L1805
%L1804:
	ibp 6
	sojn 3,%L1804	; decrement_and_branch_until_zero
%L1805:
	move 4,2
	lsh 4,2
	add 4,2
	movn 4,4
	move 3,4
	andi 3,3
	move 1,4
	ash 1,-2	; ashrsi3_pointer
	add 1,6
	jumpe 3,%L1808
%L1807:
	ibp 1
	sojn 3,%L1807	; decrement_and_branch_until_zero
%L1808:
	popj 17,

load_before_char9_5:
	subi 1,2
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

store_before_char9_5:
	subi 1,3
	ibp 1
	ibp 1
	movei 2,-1(17)
	ibp 2
	ibp 2
	movei 3,5
	pushj 17,memcpy
	popj 17,

diff_after_dec_char9_5:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setzb 6,7
	move 4,2
	lsh 4,2
	add 4,2
	movn 4,4
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 4,1
	jumpe 3,%L1816
%L1815:
	ibp 4
	sojn 3,%L1815	; decrement_and_branch_until_zero
%L1816:
	move 10,1
	sub 10,4
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

compare_after_dec_char9_5:
	move 4,3
	lsh 4,2
	add 4,3
	movn 4,4
	move 3,4
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1822
%L1821:
	ibp 1
	sojn 3,%L1821	; decrement_and_branch_until_zero
%L1822:
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

	.data
	.align	2
gp_short18_3:
	.long	arr_short18_3+19629342756
	.align	2
vgp_short18_3:
	.long	arr_short18_3+19629342762

dec_short18_3_1:
	subi 1,2
	ibp 1
	popj 17,

dec_short18_3_2:
	subi 1,3
	popj 17,

dec_short18_3_3:
	subi 1,5
	ibp 1
	popj 17,

dec_short18_3_4:
	subi 1,6
	popj 17,

dec_short18_3_5:
	subi 1,10
	ibp 1
	popj 17,

dec_short18_3_6:
	subi 1,11
	popj 17,

dec_short18_3_7:
	subi 1,13
	ibp 1
	popj 17,

dec_short18_3_8:
	subi 1,14
	popj 17,

dec_short18_3_9:
	subi 1,16
	ibp 1
	popj 17,

dec_short18_3_10:
	subi 1,17
	popj 17,

dec_short18_3_11:
	subi 1,21
	ibp 1
	popj 17,

dec_short18_3_12:
	subi 1,22
	popj 17,

dec_short18_3_0:
	popj 17,

dec_short18_3_dynamic:
	move 4,2
	lsh 4,1
	add 4,2
	movn 4,4
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1841
%L1840:
	ibp 1
	sojn 3,%L1840	; decrement_and_branch_until_zero
%L1841:
	popj 17,

subassign_short18_3:
	move 4,2
	lsh 4,1
	add 4,2
	movn 4,4
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1845
%L1844:
	ibp 1
	sojn 3,%L1844	; decrement_and_branch_until_zero
%L1845:
	popj 17,

predec_short18_3:
	subi 1,2
	ibp 1
	popj 17,

postdec_short18_3:
	setzb 4,5
	move 2,1
	push 17,0
	movei 0,3
	push 17,0
	push 17,2
	push 17,0
	subi 2,1
	movem 2,(17)
	ibp 2
	came 2,-1(17)
	jrst .-3
	move 2,(17)
	pop 17,0
	pop 17,0
	sosle (17)
	jrst .-11
	pop 17,0
	pop 17,0
	move 6,1
	sub 6,2
	muli 6,4
	move 3,7
	ash 3,-1
	add 3,%BADLH(6)
	move 4,3
	idivi 4,3
	jumpn 4,%L1849
	move 2,1
%L1849:
	move 1,2
	popj 17,

global_dec_short18_3:
	move 1,gp_short18_3
	subi 1,5
	ibp 1
	popj 17,

volatile_dec_short18_3:
	move 2,vgp_short18_3
	move 4,1
	lsh 4,1
	add 4,1
	movn 4,4
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 2,4
	jumpe 3,%L1856
%L1855:
	ibp 2
	sojn 3,%L1855	; decrement_and_branch_until_zero
%L1856:
	movem 2,vgp_short18_3
	move 1,2
	popj 17,

array_end_dec_short18_3:
	move 1,[POINT 18,arr_short18_3+44,17]
	popj 17,

index_dec_short18_3:
	move 4,1
	lsh 4,1
	add 4,1
	move 3,4
	andi 3,1
	move 6,4
	ash 6,-1	; ashrsi3_pointer
	add 6,[POINT 18,arr_short18_3,17]
	jumpe 3,%L1863
%L1862:
	ibp 6
	sojn 3,%L1862	; decrement_and_branch_until_zero
%L1863:
	move 4,2
	lsh 4,1
	add 4,2
	movn 4,4
	move 3,4
	andi 3,1
	move 1,4
	ash 1,-1	; ashrsi3_pointer
	add 1,6
	jumpe 3,%L1866
%L1865:
	ibp 1
	sojn 3,%L1865	; decrement_and_branch_until_zero
%L1866:
	popj 17,

load_before_short18_3:
	subi 1,2
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

store_before_short18_3:
	subi 1,3
	movei 2,-2(17)
	tlc 2,113300
	movei 3,6
	pushj 17,memcpy
	popj 17,

diff_after_dec_short18_3:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	setzb 6,7
	move 4,2
	lsh 4,1
	add 4,2
	movn 4,4
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 4,1
	jumpe 3,%L1874
%L1873:
	ibp 4
	sojn 3,%L1873	; decrement_and_branch_until_zero
%L1874:
	move 10,1
	sub 10,4
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

compare_after_dec_short18_3:
	move 4,3
	lsh 4,1
	add 4,3
	movn 4,4
	move 3,4
	andi 3,1
	ash 4,-1	; ashrsi3_pointer
	add 1,4
	jumpe 3,%L1880
%L1879:
	ibp 1
	sojn 3,%L1879	; decrement_and_branch_until_zero
%L1880:
	tlc 1,400000
	tlc 2,400000
	caml 1,2
	tdza 1,1
	movei 1,1
	popj 17,

char_bridge_dec:
	movn 2,2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1885
%L1884:
	ibp 1
	sojn 4,%L1884	; decrement_and_branch_until_zero
%L1885:
	popj 17,

void_bridge_dec:
	movn 2,2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L1889
%L1888:
	ibp 1
	sojn 4,%L1888	; decrement_and_branch_until_zero
%L1889:
	popj 17,

mixed_byte_word_control:
	push 17,10
	movn 4,3
	move 6,4
	andi 6,3
	ash 4,-2	; ashrsi3_pointer
	add 4,1
	jumpe 6,%L1894
%L1893:
	ibp 4
	sojn 6,%L1893	; decrement_and_branch_until_zero
%L1894:
	move 7,1
	sub 7,4
	muli 7,10
	move 1,10
	ash 1,-1
	add 1,%BADL9(7)
	add 1,3
	pop 17,10
	popj 17,

use_decrement_pointers:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 11,1
	move 12,2
	move 1,[POINT 9,arr_char9+5,8]
	move 2,11
	pushj 17,diff_after_dec_char9
	move 10,1
	move 1,[POINT 9,arr_uchar9+5,8]
	move 2,12
	pushj 17,diff_after_dec_uchar9
	add 10,1
	move 1,[POINT 6,arr_char6+3,17]
	movei 2,5
	pushj 17,diff_after_dec_char6
	add 10,1
	move 1,[POINT 7,arr_char7+4,6]
	movei 2,6
	pushj 17,diff_after_dec_char7
	add 10,1
	move 1,[POINT 8,arr_char8+5,7]
	movei 2,7
	pushj 17,diff_after_dec_char8
	add 10,1
	move 1,[POINT 18,arr_short18+12,17]
	movei 2,3
	pushj 17,diff_after_dec_short18
	add 10,1
	movei 1,arr_Sint+24
	movei 2,4
	pushj 17,diff_after_dec_Sint
	add 10,1
	move 1,[POINT 9,arr_char9+5,8]
	move 2,[POINT 9,arr_char9+2,26]
	move 3,11
	pushj 17,compare_after_dec_char9
	add 10,1
	movei 1,arr_Sint+24
	movei 2,arr_Sint+12
	move 3,12
	pushj 17,compare_after_dec_Sint
	add 10,1
	move 1,[POINT 9,arr_char9+5,8]
	movei 2,arr_Sint+24
	move 3,11
	pushj 17,mixed_byte_word_control
	add 10,1
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

	.bss
arr_char_:
	.space	40
arr_uchar_:
	.space	40
arr_char6:
	.space	40
arr_uchar6:
	.space	40
arr_char7:
	.space	40
arr_uchar7:
	.space	40
arr_char8:
	.space	40
arr_uchar8:
	.space	40
arr_char9:
	.space	40
arr_uchar9:
	.space	40
arr_short16:
	.space	80
arr_ushort16:
	.space	80
arr_short18:
	.space	80
arr_ushort18:
	.space	80
arr_Qint:
	.space	40
arr_uQint:
	.space	40
arr_Hint:
	.space	80
arr_uHint:
	.space	80
arr_Sint:
	.space	160
arr_uSint:
	.space	160
arr_Dint:
	.space	320
arr_uDint:
	.space	320
arr_Qint3:
	.space	120
arr_uQint3:
	.space	120
arr_Hint3:
	.space	240
arr_uHint3:
	.space	240
arr_Sint3:
	.space	480
arr_uSint3:
	.space	480
arr_char6_7:
	.space	200
arr_char7_6:
	.space	200
arr_char8_5:
	.space	200
arr_char9_5:
	.space	200
arr_short18_3:
	.space	240
