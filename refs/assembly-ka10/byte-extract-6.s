	.data
	.align	2
s6p0:
	.long	s6+32312918016
	.align	2
s6p5:
	.long	s6+100663296
	.align	2
s6p6:
	.long	s6+32312918017
	.align	2
s6p11:
	.long	s6+100663297
	.align	2
s6p12:
	.long	s6+32312918018
	.align	2
u6p0:
	.long	u6+32312918016
	.align	2
u6p5:
	.long	u6+100663296
	.align	2
u6p6:
	.long	u6+32312918017
	.align	2
u6p11:
	.long	u6+100663297
	.align	2
u6p12:
	.long	u6+32312918018
	.align	2
b6cp0:
	.long	b6+32312918016
	.align	2
b6cp1:
	.long	b6+25870467072
	.align	2
b6cp2:
	.long	b6+19428016128
	.align	2
b6cp3:
	.long	b6+12985565184
	.align	2
b6cp4:
	.long	b6+6543114240
	.align	2
b6cp5:
	.long	b6+100663296
	.align	2
b6up0:
	.long	b6+32312918017
	.align	2
b6up1:
	.long	b6+25870467073
	.align	2
b6up2:
	.long	b6+19428016129
	.align	2
b6up3:
	.long	b6+12985565185
	.align	2
b6up4:
	.long	b6+6543114241
	.align	2
b6up5:
	.long	b6+100663297

load6_0:
	move 1,b6
	ash 1,-36
	popj 17,

loadu6_0:
	move 1,b6+1
	lsh 1,-36
	popj 17,

load6_1:
	move 1,b6
	lsh 1,6
	ash 1,-36
	popj 17,

loadu6_1:
	ldb 1,[POINT 6,b6+1,11]
	popj 17,

load6_2:
	move 1,b6
	lsh 1,14
	ash 1,-36
	popj 17,

loadu6_2:
	ldb 1,[POINT 6,b6+1,17]
	popj 17,

load6_3:
	move 1,b6
	lsh 1,22
	ash 1,-36
	popj 17,

loadu6_3:
	ldb 1,[POINT 6,b6+1,23]
	popj 17,

load6_4:
	move 1,b6
	lsh 1,30
	ash 1,-36
	popj 17,

loadu6_4:
	ldb 1,[POINT 6,b6+1,29]
	popj 17,

load6_5:
	move 1,b6
	lsh 1,36
	ash 1,-36
	popj 17,

loadu6_5:
	ldb 1,[POINT 6,b6+1,35]
	popj 17,

load_char6_index:
	move 4,[POINT 6,s6,5]
	jumple 1,%L25
%L24:
	ibp 4
	sojg 1,%L24	; decrement_and_branch_until_zero
%L25:
	jumpe 1,%L27
%L26:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L26
%L27:
	ldb 1,4
	trne 1,40
	orcmi 1,77
	popj 17,

load_uchar6_index:
	move 4,[POINT 6,u6,5]
	jumple 1,%L30
%L29:
	ibp 4
	sojg 1,%L29	; decrement_and_branch_until_zero
%L30:
	jumpe 1,%L32
%L31:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L31
%L32:
	ldb 1,4
	popj 17,

load_char6_const_cross:
	move 1,s6
	ash 1,-36
	move 4,s6
	lsh 4,36
	ash 4,-36
	add 1,4
	move 4,s6+1
	ash 4,-36
	add 1,4
	move 4,s6+1
	lsh 4,36
	ash 4,-36
	add 1,4
	move 4,s6+2
	ash 4,-36
	add 1,4
	popj 17,

store_char6_index:
	move 3,[POINT 6,s6,5]
	move 4,1
	jumple 1,%L36
%L35:
	ibp 3
	sojg 4,%L35	; decrement_and_branch_until_zero
%L36:
	jumpe 4,%L38
%L37:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L37
%L38:
	dpb 2,3
	move 3,[POINT 6,u6,5]
	skipg 4,1
	jrst %L40
%L39:
	ibp 3
	sojg 4,%L39	; decrement_and_branch_until_zero
%L40:
	jumpe 4,%L42
%L41:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L41
%L42:
	addi 2,1
	dpb 2,3
	popj 17,

copy_char6:
	push 17,10
	move 10,1
	setzb 1,5
	caml 1,3
	jrst %L65
	subi 3,1
%L66:
	move 6,10
	move 4,5
	jumple 5,%L50
%L49:
	ibp 6
	sojg 4,%L49	; decrement_and_branch_until_zero
%L50:
	jumpe 4,%L52
%L51:
	subi 6,1
	ibp 6
	ibp 6
	ibp 6
	ibp 6
	ibp 6
	aojl 4,%L51
%L52:
	move 4,2
	move 7,5
	jumple 5,%L55
%L54:
	ibp 4
	sojg 7,%L54	; decrement_and_branch_until_zero
%L55:
	jumpe 7,%L57
%L56:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 7,%L56
%L57:
	ldb 4,4
	dpb 4,6
	move 4,10
	move 6,5
	jumple 5,%L60
%L59:
	ibp 4
	sojg 6,%L59	; decrement_and_branch_until_zero
%L60:
	jumpe 6,%L62
%L61:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 6,%L61
%L62:
	ldb 4,4
	trne 4,40
	orcmi 4,77
	add 1,4
	addi 5,1
	sojge 3,%L66	; doloop_end
%L65:
	pop 17,10
	popj 17,

copy_uchar6:
	push 17,10
	move 10,1
	setzb 1,5
	caml 1,3
	jrst %L89
	subi 3,1
%L90:
	move 6,10
	move 4,5
	jumple 5,%L74
%L73:
	ibp 6
	sojg 4,%L73	; decrement_and_branch_until_zero
%L74:
	jumpe 4,%L76
%L75:
	subi 6,1
	ibp 6
	ibp 6
	ibp 6
	ibp 6
	ibp 6
	aojl 4,%L75
%L76:
	move 4,2
	move 7,5
	jumple 5,%L79
%L78:
	ibp 4
	sojg 7,%L78	; decrement_and_branch_until_zero
%L79:
	jumpe 7,%L81
%L80:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 7,%L80
%L81:
	ldb 4,4
	dpb 4,6
	move 4,10
	move 6,5
	jumple 5,%L84
%L83:
	ibp 4
	sojg 6,%L83	; decrement_and_branch_until_zero
%L84:
	jumpe 6,%L86
%L85:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 6,%L85
%L86:
	ldb 4,4
	add 1,4
	addi 5,1
	sojge 3,%L90	; doloop_end
%L89:
	pop 17,10
	popj 17,

use_byte6:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	pushj 17,store_char6_index
	dpb 10,[POINT 6,b6,5]
	move 6,10
	addi 6,1
	dpb 6,[POINT 6,b6,11]
	move 1,10
	addi 1,2
	dpb 1,[POINT 6,b6,17]
	move 2,10
	addi 2,3
	dpb 2,[POINT 6,b6,23]
	move 3,10
	addi 3,4
	dpb 3,[POINT 6,b6,29]
	move 4,10
	addi 4,5
	dpb 4,[POINT 6,b6,35]
	dpb 10,[POINT 6,b6+1,5]
	dpb 6,[POINT 6,b6+1,11]
	dpb 1,[POINT 6,b6+1,17]
	dpb 2,[POINT 6,b6+1,23]
	dpb 3,[POINT 6,b6+1,29]
	dpb 4,[POINT 6,b6+1,35]
	move 1,11
	pushj 17,load_char6_index
	move 10,1
	move 1,11
	pushj 17,load_uchar6_index
	add 10,1
	pushj 17,load_char6_const_cross
	add 10,1
	pushj 17,load6_0
	add 10,1
	pushj 17,load6_1
	add 10,1
	pushj 17,load6_2
	add 10,1
	pushj 17,load6_3
	add 10,1
	pushj 17,load6_4
	add 10,1
	pushj 17,load6_5
	add 10,1
	pushj 17,loadu6_0
	add 10,1
	pushj 17,loadu6_1
	add 10,1
	pushj 17,loadu6_2
	add 10,1
	pushj 17,loadu6_3
	add 10,1
	pushj 17,loadu6_4
	add 10,1
	pushj 17,loadu6_5
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

load_s6_0:
	move 1,s6
	ash 1,-36
	popj 17,

load_s6_1:
	move 1,s6
	lsh 1,6
	ash 1,-36
	popj 17,

load_s6_2:
	move 1,s6
	lsh 1,14
	ash 1,-36
	popj 17,

load_s6_3:
	move 1,s6
	lsh 1,22
	ash 1,-36
	popj 17,

load_s6_4:
	move 1,s6
	lsh 1,30
	ash 1,-36
	popj 17,

load_s6_5:
	move 1,s6
	lsh 1,36
	ash 1,-36
	popj 17,

load_s6_6:
	move 1,s6+1
	ash 1,-36
	popj 17,

load_s6_7:
	move 1,s6+1
	lsh 1,6
	ash 1,-36
	popj 17,

load_s6_8:
	move 1,s6+1
	lsh 1,14
	ash 1,-36
	popj 17,

load_s6_9:
	move 1,s6+1
	lsh 1,22
	ash 1,-36
	popj 17,

load_s6_10:
	move 1,s6+1
	lsh 1,30
	ash 1,-36
	popj 17,

load_s6_11:
	move 1,s6+1
	lsh 1,36
	ash 1,-36
	popj 17,

load_s6_12:
	move 1,s6+2
	ash 1,-36
	popj 17,

load_u6_0:
	move 1,u6
	lsh 1,-36
	popj 17,

load_u6_1:
	ldb 1,[POINT 6,u6,11]
	popj 17,

load_u6_2:
	ldb 1,[POINT 6,u6,17]
	popj 17,

load_u6_3:
	ldb 1,[POINT 6,u6,23]
	popj 17,

load_u6_4:
	ldb 1,[POINT 6,u6,29]
	popj 17,

load_u6_5:
	ldb 1,[POINT 6,u6,35]
	popj 17,

load_u6_6:
	move 1,u6+1
	lsh 1,-36
	popj 17,

load_u6_7:
	ldb 1,[POINT 6,u6+1,11]
	popj 17,

load_u6_8:
	ldb 1,[POINT 6,u6+1,17]
	popj 17,

load_u6_9:
	ldb 1,[POINT 6,u6+1,23]
	popj 17,

load_u6_10:
	ldb 1,[POINT 6,u6+1,29]
	popj 17,

load_u6_11:
	ldb 1,[POINT 6,u6+1,35]
	popj 17,

load_u6_12:
	move 1,u6+2
	lsh 1,-36
	popj 17,

store_s6_0:
	dpb 1,[POINT 6,s6,5]
	popj 17,

store_s6_1:
	dpb 1,[POINT 6,s6,11]
	popj 17,

store_s6_2:
	dpb 1,[POINT 6,s6,17]
	popj 17,

store_s6_3:
	dpb 1,[POINT 6,s6,23]
	popj 17,

store_s6_4:
	dpb 1,[POINT 6,s6,29]
	popj 17,

store_s6_5:
	dpb 1,[POINT 6,s6,35]
	popj 17,

store_s6_6:
	dpb 1,[POINT 6,s6+1,5]
	popj 17,

store_s6_7:
	dpb 1,[POINT 6,s6+1,11]
	popj 17,

store_s6_8:
	dpb 1,[POINT 6,s6+1,17]
	popj 17,

store_s6_9:
	dpb 1,[POINT 6,s6+1,23]
	popj 17,

store_s6_10:
	dpb 1,[POINT 6,s6+1,29]
	popj 17,

store_s6_11:
	dpb 1,[POINT 6,s6+1,35]
	popj 17,

store_s6_12:
	dpb 1,[POINT 6,s6+2,5]
	popj 17,

store_u6_0:
	dpb 1,[POINT 6,u6,5]
	popj 17,

store_u6_1:
	dpb 1,[POINT 6,u6,11]
	popj 17,

store_u6_2:
	dpb 1,[POINT 6,u6,17]
	popj 17,

store_u6_3:
	dpb 1,[POINT 6,u6,23]
	popj 17,

store_u6_4:
	dpb 1,[POINT 6,u6,29]
	popj 17,

store_u6_5:
	dpb 1,[POINT 6,u6,35]
	popj 17,

store_u6_6:
	dpb 1,[POINT 6,u6+1,5]
	popj 17,

store_u6_7:
	dpb 1,[POINT 6,u6+1,11]
	popj 17,

store_u6_8:
	dpb 1,[POINT 6,u6+1,17]
	popj 17,

store_u6_9:
	dpb 1,[POINT 6,u6+1,23]
	popj 17,

store_u6_10:
	dpb 1,[POINT 6,u6+1,29]
	popj 17,

store_u6_11:
	dpb 1,[POINT 6,u6+1,35]
	popj 17,

store_u6_12:
	dpb 1,[POINT 6,u6+2,5]
	popj 17,

store_s6_return:
	move 4,[POINT 6,s6,5]
	andi 1,17
	jumple 1,%L146
%L145:
	ibp 4
	sojg 1,%L145	; decrement_and_branch_until_zero
%L146:
	jumpe 1,%L148
%L147:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L147
%L148:
	dpb 2,4
	lsh 2,36
	ash 2,-36
	move 1,2
	popj 17,

store_u6_return:
	move 4,[POINT 6,u6,5]
	andi 1,17
	jumple 1,%L151
%L150:
	ibp 4
	sojg 1,%L150	; decrement_and_branch_until_zero
%L151:
	jumpe 1,%L153
%L152:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L152
%L153:
	dpb 2,4
	andi 2,77
	move 1,2
	popj 17,

store_s6_const_return:
	dpb 1,[POINT 6,s6,35]
	lsh 1,36
	ash 1,-36
	popj 17,

store_u6_const_return:
	dpb 1,[POINT 6,u6,35]
	andi 1,77
	popj 17,

load_s6_ptr_0:
	ldb 1,s6p0
	trne 1,40
	orcmi 1,77
	popj 17,

load_s6_ptr_5:
	ldb 1,s6p5
	trne 1,40
	orcmi 1,77
	popj 17,

load_s6_ptr_6:
	ldb 1,s6p6
	trne 1,40
	orcmi 1,77
	popj 17,

load_s6_ptr_11:
	ldb 1,s6p11
	trne 1,40
	orcmi 1,77
	popj 17,

load_s6_ptr_12:
	ldb 1,s6p12
	trne 1,40
	orcmi 1,77
	popj 17,

load_u6_ptr_0:
	ldb 1,u6p0
	popj 17,

load_u6_ptr_5:
	ldb 1,u6p5
	popj 17,

load_u6_ptr_6:
	ldb 1,u6p6
	popj 17,

load_u6_ptr_11:
	ldb 1,u6p11
	popj 17,

load_u6_ptr_12:
	ldb 1,u6p12
	popj 17,

store_s6_ptr_0:
	dpb 1,s6p0
	popj 17,

store_s6_ptr_5:
	dpb 1,s6p5
	popj 17,

store_s6_ptr_6:
	dpb 1,s6p6
	popj 17,

store_u6_ptr_0:
	dpb 1,u6p0
	popj 17,

store_u6_ptr_5:
	dpb 1,u6p5
	popj 17,

store_u6_ptr_6:
	dpb 1,u6p6
	popj 17,

load_b6p_c0:
	ldb 1,b6cp0
	trne 1,40
	orcmi 1,77
	popj 17,

load_b6p_c1:
	ldb 1,b6cp1
	trne 1,40
	orcmi 1,77
	popj 17,

load_b6p_c2:
	ldb 1,b6cp2
	trne 1,40
	orcmi 1,77
	popj 17,

load_b6p_c3:
	ldb 1,b6cp3
	trne 1,40
	orcmi 1,77
	popj 17,

load_b6p_c4:
	ldb 1,b6cp4
	trne 1,40
	orcmi 1,77
	popj 17,

load_b6p_c5:
	ldb 1,b6cp5
	trne 1,40
	orcmi 1,77
	popj 17,

load_b6p_u0:
	ldb 1,b6up0
	popj 17,

load_b6p_u1:
	ldb 1,b6up1
	popj 17,

load_b6p_u2:
	ldb 1,b6up2
	popj 17,

load_b6p_u3:
	ldb 1,b6up3
	popj 17,

load_b6p_u4:
	ldb 1,b6up4
	popj 17,

load_b6p_u5:
	ldb 1,b6up5
	popj 17,

store_b6p_c0:
	dpb 1,b6cp0
	popj 17,

store_b6p_c1:
	dpb 1,b6cp1
	popj 17,

store_b6p_c2:
	dpb 1,b6cp2
	popj 17,

store_b6p_c3:
	dpb 1,b6cp3
	popj 17,

store_b6p_c4:
	dpb 1,b6cp4
	popj 17,

store_b6p_c5:
	dpb 1,b6cp5
	popj 17,

store_b6p_u0:
	dpb 1,b6up0
	popj 17,

store_b6p_u1:
	dpb 1,b6up1
	popj 17,

store_b6p_u2:
	dpb 1,b6up2
	popj 17,

store_b6p_u3:
	dpb 1,b6up3
	popj 17,

store_b6p_u4:
	dpb 1,b6up4
	popj 17,

store_b6p_u5:
	dpb 1,b6up5
	popj 17,

load_char6_masked:
	move 4,[POINT 6,s6,5]
	andi 1,17
	jumple 1,%L198
%L197:
	ibp 4
	sojg 1,%L197	; decrement_and_branch_until_zero
%L198:
	jumpe 1,%L200
%L199:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L199
%L200:
	ldb 1,4
	trne 1,40
	orcmi 1,77
	popj 17,

load_uchar6_masked:
	move 4,[POINT 6,u6,5]
	andi 1,17
	jumple 1,%L203
%L202:
	ibp 4
	sojg 1,%L202	; decrement_and_branch_until_zero
%L203:
	jumpe 1,%L205
%L204:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L204
%L205:
	ldb 1,4
	popj 17,

load_char6_pointer:
	jumple 2,%L209
%L208:
	ibp 1
	sojg 2,%L208	; decrement_and_branch_until_zero
%L209:
	jumpe 2,%L211
%L210:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L210
%L211:
	ldb 1,1
	trne 1,40
	orcmi 1,77
	popj 17,

load_uchar6_pointer:
	jumple 2,%L215
%L214:
	ibp 1
	sojg 2,%L214	; decrement_and_branch_until_zero
%L215:
	jumpe 2,%L217
%L216:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L216
%L217:
	ldb 1,1
	popj 17,

store_char6_pointer:
	jumple 2,%L221
%L220:
	ibp 1
	sojg 2,%L220	; decrement_and_branch_until_zero
%L221:
	jumpe 2,%L223
%L222:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L222
%L223:
	dpb 3,1
	popj 17,

store_uchar6_pointer:
	jumple 2,%L227
%L226:
	ibp 1
	sojg 2,%L226	; decrement_and_branch_until_zero
%L227:
	jumpe 2,%L229
%L228:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L228
%L229:
	dpb 3,1
	popj 17,

load_char6_index_plus_1:
	addi 1,1
	move 4,[POINT 6,s6,5]
	andi 1,17
	jumple 1,%L232
%L231:
	ibp 4
	sojg 1,%L231	; decrement_and_branch_until_zero
%L232:
	jumpe 1,%L234
%L233:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L233
%L234:
	ldb 1,4
	trne 1,40
	orcmi 1,77
	popj 17,

load_char6_index_plus_5:
	addi 1,5
	move 4,[POINT 6,s6,5]
	andi 1,17
	jumple 1,%L237
%L236:
	ibp 4
	sojg 1,%L236	; decrement_and_branch_until_zero
%L237:
	jumpe 1,%L239
%L238:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L238
%L239:
	ldb 1,4
	trne 1,40
	orcmi 1,77
	popj 17,

load_char6_index_minus_1:
	subi 1,1
	move 4,[POINT 6,s6,5]
	andi 1,17
	jumple 1,%L242
%L241:
	ibp 4
	sojg 1,%L241	; decrement_and_branch_until_zero
%L242:
	jumpe 1,%L244
%L243:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L243
%L244:
	ldb 1,4
	trne 1,40
	orcmi 1,77
	popj 17,

load_uchar6_index_plus_1:
	addi 1,1
	move 4,[POINT 6,u6,5]
	andi 1,17
	jumple 1,%L247
%L246:
	ibp 4
	sojg 1,%L246	; decrement_and_branch_until_zero
%L247:
	jumpe 1,%L249
%L248:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L248
%L249:
	ldb 1,4
	popj 17,

load_uchar6_index_plus_5:
	addi 1,5
	move 4,[POINT 6,u6,5]
	andi 1,17
	jumple 1,%L252
%L251:
	ibp 4
	sojg 1,%L251	; decrement_and_branch_until_zero
%L252:
	jumpe 1,%L254
%L253:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L253
%L254:
	ldb 1,4
	popj 17,

load_uchar6_index_minus_1:
	subi 1,1
	move 4,[POINT 6,u6,5]
	andi 1,17
	jumple 1,%L257
%L256:
	ibp 4
	sojg 1,%L256	; decrement_and_branch_until_zero
%L257:
	jumpe 1,%L259
%L258:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L258
%L259:
	ldb 1,4
	popj 17,

store_char6_index_plus_1:
	addi 1,1
	move 4,[POINT 6,s6,5]
	andi 1,17
	jumple 1,%L262
%L261:
	ibp 4
	sojg 1,%L261	; decrement_and_branch_until_zero
%L262:
	jumpe 1,%L264
%L263:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L263
%L264:
	dpb 2,4
	popj 17,

store_char6_index_plus_5:
	addi 1,5
	move 4,[POINT 6,s6,5]
	andi 1,17
	jumple 1,%L267
%L266:
	ibp 4
	sojg 1,%L266	; decrement_and_branch_until_zero
%L267:
	jumpe 1,%L269
%L268:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L268
%L269:
	dpb 2,4
	popj 17,

store_char6_index_minus_1:
	subi 1,1
	move 4,[POINT 6,s6,5]
	andi 1,17
	jumple 1,%L272
%L271:
	ibp 4
	sojg 1,%L271	; decrement_and_branch_until_zero
%L272:
	jumpe 1,%L274
%L273:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L273
%L274:
	dpb 2,4
	popj 17,

store_uchar6_index_plus_1:
	addi 1,1
	move 4,[POINT 6,u6,5]
	andi 1,17
	jumple 1,%L277
%L276:
	ibp 4
	sojg 1,%L276	; decrement_and_branch_until_zero
%L277:
	jumpe 1,%L279
%L278:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L278
%L279:
	dpb 2,4
	popj 17,

store_uchar6_index_plus_5:
	addi 1,5
	move 4,[POINT 6,u6,5]
	andi 1,17
	jumple 1,%L282
%L281:
	ibp 4
	sojg 1,%L281	; decrement_and_branch_until_zero
%L282:
	jumpe 1,%L284
%L283:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L283
%L284:
	dpb 2,4
	popj 17,

store_uchar6_index_minus_1:
	subi 1,1
	move 4,[POINT 6,u6,5]
	andi 1,17
	jumple 1,%L287
%L286:
	ibp 4
	sojg 1,%L286	; decrement_and_branch_until_zero
%L287:
	jumpe 1,%L289
%L288:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L288
%L289:
	dpb 2,4
	popj 17,

addr_s6_0:
	move 1,[POINT 6,s6,5]
	popj 17,

addr_s6_5:
	move 1,[POINT 6,s6,35]
	popj 17,

addr_s6_6:
	move 1,[POINT 6,s6+1,5]
	popj 17,

addr_s6_index:
	move 4,[POINT 6,s6,5]
	andi 1,17
	jumple 1,%L300
%L299:
	ibp 4
	sojg 1,%L299	; decrement_and_branch_until_zero
%L300:
	jumpe 1,%L302
%L301:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L301
%L302:
	move 1,4
	popj 17,

addr_u6_0:
	move 1,[POINT 6,u6,5]
	popj 17,

addr_u6_5:
	move 1,[POINT 6,u6,35]
	popj 17,

addr_u6_6:
	move 1,[POINT 6,u6+1,5]
	popj 17,

addr_u6_index:
	move 4,[POINT 6,u6,5]
	andi 1,17
	jumple 1,%L313
%L312:
	ibp 4
	sojg 1,%L312	; decrement_and_branch_until_zero
%L313:
	jumpe 1,%L315
%L314:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L314
%L315:
	move 1,4
	popj 17,

addr_b6_c0:
	move 1,[POINT 6,b6,5]
	popj 17,

addr_b6_c5:
	move 1,[POINT 6,b6,35]
	popj 17,

addr_b6_u0:
	move 1,[POINT 6,b6+1,5]
	popj 17,

addr_b6_u5:
	move 1,[POINT 6,b6+1,35]
	popj 17,

addr_load_s6:
	move 4,[POINT 6,s6,5]
	andi 1,17
	jumple 1,%L324
%L323:
	ibp 4
	sojg 1,%L323	; decrement_and_branch_until_zero
%L324:
	jumpe 1,%L326
%L325:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L325
%L326:
	ldb 1,4
	trne 1,40
	orcmi 1,77
	popj 17,

addr_load_u6:
	move 4,[POINT 6,u6,5]
	andi 1,17
	jumple 1,%L331
%L330:
	ibp 4
	sojg 1,%L330	; decrement_and_branch_until_zero
%L331:
	jumpe 1,%L333
%L332:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L332
%L333:
	ldb 1,4
	popj 17,

addr_store_s6:
	move 4,[POINT 6,s6,5]
	andi 1,17
	jumple 1,%L338
%L337:
	ibp 4
	sojg 1,%L337	; decrement_and_branch_until_zero
%L338:
	jumpe 1,%L340
%L339:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L339
%L340:
	dpb 2,4
	popj 17,

addr_store_u6:
	move 4,[POINT 6,u6,5]
	andi 1,17
	jumple 1,%L345
%L344:
	ibp 4
	sojg 1,%L344	; decrement_and_branch_until_zero
%L345:
	jumpe 1,%L347
%L346:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L346
%L347:
	dpb 2,4
	popj 17,

b6_load_c0:
	move 1,b6
	ash 1,-36
	popj 17,

b6_load_c1:
	move 1,b6
	lsh 1,6
	ash 1,-36
	popj 17,

b6_load_c2:
	move 1,b6
	lsh 1,14
	ash 1,-36
	popj 17,

b6_load_c3:
	move 1,b6
	lsh 1,22
	ash 1,-36
	popj 17,

b6_load_c4:
	move 1,b6
	lsh 1,30
	ash 1,-36
	popj 17,

b6_load_c5:
	move 1,b6
	lsh 1,36
	ash 1,-36
	popj 17,

b6_load_u0:
	move 1,b6+1
	lsh 1,-36
	popj 17,

b6_load_u1:
	ldb 1,[POINT 6,b6+1,11]
	popj 17,

b6_load_u2:
	ldb 1,[POINT 6,b6+1,17]
	popj 17,

b6_load_u3:
	ldb 1,[POINT 6,b6+1,23]
	popj 17,

b6_load_u4:
	ldb 1,[POINT 6,b6+1,29]
	popj 17,

b6_load_u5:
	ldb 1,[POINT 6,b6+1,35]
	popj 17,

b6_store_c0:
	dpb 1,[POINT 6,b6,5]
	popj 17,

b6_store_c1:
	dpb 1,[POINT 6,b6,11]
	popj 17,

b6_store_c2:
	dpb 1,[POINT 6,b6,17]
	popj 17,

b6_store_c3:
	dpb 1,[POINT 6,b6,23]
	popj 17,

b6_store_c4:
	dpb 1,[POINT 6,b6,29]
	popj 17,

b6_store_c5:
	dpb 1,[POINT 6,b6,35]
	popj 17,

b6_store_u0:
	dpb 1,[POINT 6,b6+1,5]
	popj 17,

b6_store_u1:
	dpb 1,[POINT 6,b6+1,11]
	popj 17,

b6_store_u2:
	dpb 1,[POINT 6,b6+1,17]
	popj 17,

b6_store_u3:
	dpb 1,[POINT 6,b6+1,23]
	popj 17,

b6_store_u4:
	dpb 1,[POINT 6,b6+1,29]
	popj 17,

b6_store_u5:
	dpb 1,[POINT 6,b6+1,35]
	popj 17,

b6_sum_signed:
	move 1,b6
	ash 1,-36
	move 4,b6
	lsh 4,6
	ash 4,-36
	add 1,4
	move 4,b6
	lsh 4,14
	ash 4,-36
	add 1,4
	move 4,b6
	lsh 4,22
	ash 4,-36
	add 1,4
	move 4,b6
	lsh 4,30
	ash 4,-36
	add 1,4
	move 4,b6
	lsh 4,36
	ash 4,-36
	add 1,4
	popj 17,

b6_sum_unsigned:
	move 1,b6+1
	lsh 1,-36
	ldb 4,[POINT 6,b6+1,11]
	add 1,4
	ldb 4,[POINT 6,b6+1,17]
	add 1,4
	ldb 4,[POINT 6,b6+1,23]
	add 1,4
	ldb 4,[POINT 6,b6+1,29]
	add 1,4
	ldb 4,[POINT 6,b6+1,35]
	add 1,4
	popj 17,

b6_sum_mixed:
	move 1,b6
	ash 1,-36
	move 4,b6+1
	lsh 4,-36
	add 1,4
	move 4,b6
	lsh 4,36
	ash 4,-36
	add 1,4
	ldb 4,[POINT 6,b6+1,35]
	add 1,4
	popj 17,

arg6_c0:
	ash 1,-36
	popj 17,

arg6_c5:
	lsh 1,36
	ash 1,-36
	popj 17,

arg6_u0:
	move 1,2
	lsh 1,-36
	popj 17,

arg6_u5:
	ldb 1,[POINT 6,2,35]
	popj 17,

arg6_sum:
	move 3,1
	ash 3,-36
	move 4,1
	lsh 4,6
	ash 4,-36
	add 3,4
	move 4,1
	lsh 4,14
	ash 4,-36
	add 3,4
	move 4,1
	lsh 4,22
	ash 4,-36
	add 3,4
	move 4,1
	lsh 4,30
	ash 4,-36
	add 3,4
	move 4,1
	lsh 4,36
	ash 4,-36
	add 3,4
	move 4,2
	lsh 4,-36
	add 3,4
	ldb 4,[POINT 6,2,11]
	add 3,4
	ldb 4,[POINT 6,2,17]
	add 3,4
	ldb 4,[POINT 6,2,23]
	add 3,4
	ldb 4,[POINT 6,2,29]
	add 3,4
	ldb 4,[POINT 6,2,35]
	add 3,4
	move 1,3
	popj 17,

ptr6_c0:
	move 1,(1)
	ash 1,-36
	popj 17,

ptr6_c5:
	move 1,(1)
	lsh 1,36
	ash 1,-36
	popj 17,

ptr6_u0:
	move 1,1(1)
	lsh 1,-36
	popj 17,

ptr6_u5:
	ldb 1,[POINT 6,1(1),35]
	popj 17,

ptr6_store_c0:
	dpb 2,[POINT 6,(1),5]
	popj 17,

ptr6_store_c5:
	dpb 2,[POINT 6,(1),35]
	popj 17,

ptr6_store_u0:
	dpb 2,[POINT 6,1(1),5]
	popj 17,

ptr6_store_u5:
	dpb 2,[POINT 6,1(1),35]
	popj 17,

b6a_load_c0:
	andi 1,7
	lsh 1,2
	move 1,b6a(1)
	ash 1,-36
	popj 17,

b6a_load_c5:
	andi 1,7
	lsh 1,2
	move 1,b6a(1)
	lsh 1,36
	ash 1,-36
	popj 17,

b6a_load_u0:
	andi 1,7
	lsh 1,2
	move 1,b6a+1(1)
	lsh 1,-36
	popj 17,

b6a_load_u5:
	andi 1,7
	lsh 1,2
	move 1,b6a+1(1)
	andi 1,77
	popj 17,

b6a_store_c0:
	andi 1,7
	lsh 1,2
	dpb 2,[POINT 6,b6a(1),5]
	popj 17,

b6a_store_c5:
	andi 1,7
	lsh 1,2
	dpb 2,[POINT 6,b6a(1),35]
	popj 17,

b6a_store_u0:
	andi 1,7
	lsh 1,2
	add 1,[POINT 6,b6a,5]
	dpb 2,[POINT 6,1(1),5]
	popj 17,

b6a_store_u5:
	andi 1,7
	lsh 1,2
	add 1,[POINT 6,b6a,5]
	dpb 2,[POINT 6,1(1),35]
	popj 17,

mb6_load_c0:
	move 1,mb6+1
	ash 1,-36
	popj 17,

mb6_load_u0:
	ldb 1,[POINT 6,mb6+1,11]
	popj 17,

mb6_load_c1:
	move 1,mb6+1
	lsh 1,14
	ash 1,-36
	popj 17,

mb6_load_u1:
	ldb 1,[POINT 6,mb6+1,23]
	popj 17,

mb6_load_c2:
	move 1,mb6+3
	ash 1,-36
	popj 17,

mb6_load_u2:
	ldb 1,[POINT 6,mb6+3,11]
	popj 17,

mb6_sum:
	move 1,mb6+1
	ash 1,-36
	add 1,mb6
	ldb 4,[POINT 6,mb6+1,11]
	add 1,4
	move 4,mb6+1
	lsh 4,14
	ash 4,-36
	add 1,4
	ldb 4,[POINT 6,mb6+1,23]
	add 1,4
	add 1,mb6+2
	move 4,mb6+3
	ash 4,-36
	add 1,4
	ldb 4,[POINT 6,mb6+3,11]
	add 1,4
	popj 17,

mb6_store_all:
	dpb 1,[POINT 6,mb6+1,5]
	addi 1,1
	dpb 1,[POINT 6,mb6+1,11]
	addi 1,1
	dpb 1,[POINT 6,mb6+1,17]
	addi 1,1
	dpb 1,[POINT 6,mb6+1,23]
	addi 1,1
	dpb 1,[POINT 6,mb6+3,5]
	addi 1,1
	dpb 1,[POINT 6,mb6+3,11]
	popj 17,

vload_s6:
	move 4,[POINT 6,vs6,5]
	andi 1,17
	jumple 1,%L406
%L405:
	ibp 4
	sojg 1,%L405	; decrement_and_branch_until_zero
%L406:
	jumpe 1,%L408
%L407:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L407
%L408:
	ldb 1,4
	trne 1,40
	orcmi 1,77
	popj 17,

vload_u6:
	move 4,[POINT 6,vu6,5]
	andi 1,17
	jumple 1,%L411
%L410:
	ibp 4
	sojg 1,%L410	; decrement_and_branch_until_zero
%L411:
	jumpe 1,%L413
%L412:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L412
%L413:
	ldb 1,4
	popj 17,

vstore_s6:
	move 4,[POINT 6,vs6,5]
	andi 1,17
	jumple 1,%L416
%L415:
	ibp 4
	sojg 1,%L415	; decrement_and_branch_until_zero
%L416:
	jumpe 1,%L418
%L417:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L417
%L418:
	dpb 2,4
	popj 17,

vstore_u6:
	move 4,[POINT 6,vu6,5]
	andi 1,17
	jumple 1,%L421
%L420:
	ibp 4
	sojg 1,%L420	; decrement_and_branch_until_zero
%L421:
	jumpe 1,%L423
%L422:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L422
%L423:
	dpb 2,4
	popj 17,

vload_s6_5:
	ldb 1,[POINT 9,vs6,8]
	lsh 1,36
	ash 1,-36
	popj 17,

vload_u6_5:
	ldb 1,[POINT 6,vu6,35]
	popj 17,

vstore_s6_5:
	dpb 1,[POINT 6,vs6,35]
	popj 17,

vstore_u6_5:
	dpb 1,[POINT 6,vu6,35]
	popj 17,

extend_char6:
	ldb 1,1
	trne 1,40
	orcmi 1,77
	popj 17,

extend_uchar6:
	ldb 1,1
	popj 17,

extend_char6_array:
	move 4,[POINT 6,s6,5]
	andi 1,17
	jumple 1,%L432
%L431:
	ibp 4
	sojg 1,%L431	; decrement_and_branch_until_zero
%L432:
	jumpe 1,%L434
%L433:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L433
%L434:
	ldb 1,4
	trne 1,40
	orcmi 1,77
	popj 17,

extend_uchar6_array:
	move 4,[POINT 6,u6,5]
	andi 1,17
	jumple 1,%L437
%L436:
	ibp 4
	sojg 1,%L436	; decrement_and_branch_until_zero
%L437:
	jumpe 1,%L439
%L438:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L438
%L439:
	ldb 1,4
	popj 17,

trunc_store_char6:
	dpb 2,1
	popj 17,

trunc_store_uchar6:
	dpb 2,1
	popj 17,

trunc_store_char6_return:
	dpb 2,1
	lsh 2,36
	ash 2,-36
	move 1,2
	popj 17,

trunc_store_uchar6_return:
	dpb 2,1
	andi 2,77
	move 1,2
	popj 17,

char6_plus:
	move 4,[POINT 6,s6,5]
	andi 1,17
	jumple 1,%L446
%L445:
	ibp 4
	sojg 1,%L445	; decrement_and_branch_until_zero
%L446:
	jumpe 1,%L448
%L447:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L447
%L448:
	ldb 1,4
	trne 1,40
	orcmi 1,77
	add 1,2
	popj 17,

uchar6_plus:
	move 4,[POINT 6,u6,5]
	andi 1,17
	jumple 1,%L451
%L450:
	ibp 4
	sojg 1,%L450	; decrement_and_branch_until_zero
%L451:
	jumpe 1,%L453
%L452:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L452
%L453:
	ldb 1,4
	add 1,2
	popj 17,

char6_sub:
	move 4,[POINT 6,s6,5]
	andi 1,17
	jumple 1,%L456
%L455:
	ibp 4
	sojg 1,%L455	; decrement_and_branch_until_zero
%L456:
	jumpe 1,%L458
%L457:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L457
%L458:
	ldb 1,4
	trne 1,40
	orcmi 1,77
	sub 1,2
	popj 17,

uchar6_xor:
	move 4,[POINT 6,u6,5]
	andi 1,17
	jumple 1,%L461
%L460:
	ibp 4
	sojg 1,%L460	; decrement_and_branch_until_zero
%L461:
	jumpe 1,%L463
%L462:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L462
%L463:
	ldb 1,4
	xor 1,2
	popj 17,

char6_eq_zero:
	move 4,[POINT 6,s6,5]
	andi 1,17
	jumple 1,%L466
%L465:
	ibp 4
	sojg 1,%L465	; decrement_and_branch_until_zero
%L466:
	jumpe 1,%L468
%L467:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L467
%L468:
	ldb 4,4
	skipe 4
	tdza 1,1
	movei 1,1
	popj 17,

char6_lt_zero:
	move 4,[POINT 6,s6,5]
	andi 1,17
	jumple 1,%L471
%L470:
	ibp 4
	sojg 1,%L470	; decrement_and_branch_until_zero
%L471:
	jumpe 1,%L473
%L472:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L472
%L473:
	ldb 1,4
	trne 1,400
	orcmi 1,777
	lsh 1,-43
	popj 17,

uchar6_eq_zero:
	move 4,[POINT 6,u6,5]
	andi 1,17
	jumple 1,%L476
%L475:
	ibp 4
	sojg 1,%L475	; decrement_and_branch_until_zero
%L476:
	jumpe 1,%L478
%L477:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L477
%L478:
	ldb 4,4
	skipe 4
	tdza 1,1
	movei 1,1
	popj 17,

uchar6_gt_31:
	move 4,[POINT 6,u6,5]
	andi 1,17
	jumple 1,%L481
%L480:
	ibp 4
	sojg 1,%L480	; decrement_and_branch_until_zero
%L481:
	jumpe 1,%L483
%L482:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L482
%L483:
	ldb 1,4
	tlo 1,400000
	move 6,[-377777777741]
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

char6_range:
	move 4,[POINT 6,s6,5]
	andi 1,17
	jumple 1,%L486
%L485:
	ibp 4
	sojg 1,%L485	; decrement_and_branch_until_zero
%L486:
	jumpe 1,%L488
%L487:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L487
%L488:
	ldb 4,4
	trne 4,40
	orcmi 4,77
	seto 1,
	camge 4,[-20]
	popj 17,
	movei 6,17
	camg 4,6
	tdza 1,1
	movei 1,1
	popj 17,

uchar6_range:
	move 4,[POINT 6,u6,5]
	andi 1,17
	jumple 1,%L493
%L492:
	ibp 4
	sojg 1,%L492	; decrement_and_branch_until_zero
%L493:
	jumpe 1,%L495
%L494:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L494
%L495:
	ldb 4,4
	tlc 4,400000
	seto 1,
	camg 4,[-377777777761]
	popj 17,
	move 6,[-377777777721]
	camg 4,6
	tdza 1,1
	movei 1,1
	popj 17,

postinc_load_char6:
	ldb 1,1
	trne 1,40
	orcmi 1,77
	popj 17,

postinc_load_uchar6:
	ldb 1,1
	popj 17,

postinc_store_char6:
	dpb 2,1
	popj 17,

postinc_store_uchar6:
	dpb 2,1
	popj 17,

walk_sum_char6:
	movei 3,0
	caml 3,2
	jrst %L509
	subi 2,1
%L510:
	ldb 4,1
	trne 4,40
	orcmi 4,77
	add 3,4
	ibp 1
	sojge 2,%L510	; doloop_end
%L509:
	move 1,3
	popj 17,

walk_sum_uchar6:
	movei 3,0
	caml 3,2
	jrst %L518
	subi 2,1
%L519:
	ldb 4,1
	add 3,4
	ibp 1
	sojge 2,%L519	; doloop_end
%L518:
	move 1,3
	popj 17,

walk_zero_char6:
	jumple 2,%L527
	movei 4,0
	subi 2,1
%L528:
	dpb 4,1
	ibp 1
	sojge 2,%L528	; doloop_end
%L527:
	popj 17,

walk_zero_uchar6:
	jumple 2,%L536
	movei 4,0
	subi 2,1
%L537:
	dpb 4,1
	ibp 1
	sojge 2,%L537	; doloop_end
%L536:
	popj 17,

sum_char6_global:
	setzb 6,2
	caml 6,1
	jrst %L549
	subi 1,1
%L550:
	move 3,[POINT 6,s6,5]
	move 4,2
	andi 4,17
	jumple 4,%L544
%L543:
	ibp 3
	sojg 4,%L543	; decrement_and_branch_until_zero
%L544:
	jumpe 4,%L546
%L545:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L545
%L546:
	ldb 4,3
	trne 4,40
	orcmi 4,77
	add 6,4
	addi 2,1
	sojge 1,%L550	; doloop_end
%L549:
	move 1,6
	popj 17,

sum_uchar6_global:
	setzb 6,2
	caml 6,1
	jrst %L562
	subi 1,1
%L563:
	move 3,[POINT 6,u6,5]
	move 4,2
	andi 4,17
	jumple 4,%L557
%L556:
	ibp 3
	sojg 4,%L556	; decrement_and_branch_until_zero
%L557:
	jumpe 4,%L559
%L558:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L558
%L559:
	ldb 4,3
	add 6,4
	addi 2,1
	sojge 1,%L563	; doloop_end
%L562:
	move 1,6
	popj 17,

zero_char6_global:
	movei 2,0
	caml 2,1
	popj 17,
	movei 6,0
	subi 1,1
%L576:
	move 3,[POINT 6,s6,5]
	move 4,2
	andi 4,17
	jumple 4,%L570
%L569:
	ibp 3
	sojg 4,%L569	; decrement_and_branch_until_zero
%L570:
	jumpe 4,%L572
%L571:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L571
%L572:
	dpb 6,3
	addi 2,1
	sojge 1,%L576	; doloop_end
	popj 17,

zero_uchar6_global:
	movei 2,0
	caml 2,1
	popj 17,
	movei 6,0
	subi 1,1
%L589:
	move 3,[POINT 6,u6,5]
	move 4,2
	andi 4,17
	jumple 4,%L583
%L582:
	ibp 3
	sojg 4,%L582	; decrement_and_branch_until_zero
%L583:
	jumpe 4,%L585
%L584:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L584
%L585:
	dpb 6,3
	addi 2,1
	sojge 1,%L589	; doloop_end
	popj 17,

set_char6_index_global:
	movei 2,0
	caml 2,1
	popj 17,
	subi 1,1
%L602:
	move 3,[POINT 6,s6,5]
	move 4,2
	andi 4,17
	jumple 4,%L596
%L595:
	ibp 3
	sojg 4,%L595	; decrement_and_branch_until_zero
%L596:
	jumpe 4,%L598
%L597:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L597
%L598:
	dpb 2,3
	addi 2,1
	sojge 1,%L602	; doloop_end
	popj 17,

set_uchar6_index_global:
	movei 2,0
	caml 2,1
	popj 17,
	subi 1,1
%L615:
	move 3,[POINT 6,u6,5]
	move 4,2
	andi 4,17
	jumple 4,%L609
%L608:
	ibp 3
	sojg 4,%L608	; decrement_and_branch_until_zero
%L609:
	jumpe 4,%L611
%L610:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L610
%L611:
	dpb 2,3
	addi 2,1
	sojge 1,%L615	; doloop_end
	popj 17,

copy_char6_global:
	setzb 5,7
	caml 5,1
	jrst %L635
	subi 1,1
%L636:
	move 6,7
	addi 6,22
	move 2,[POINT 6,s6,5]
	move 4,6
	andi 4,35
	jumple 4,%L622
%L621:
	ibp 2
	sojg 4,%L621	; decrement_and_branch_until_zero
%L622:
	jumpe 4,%L624
%L623:
	subi 2,1
	ibp 2
	ibp 2
	ibp 2
	ibp 2
	ibp 2
	aojl 4,%L623
%L624:
	move 4,[POINT 6,s6,5]
	move 3,7
	andi 3,17
	jumple 3,%L626
%L625:
	ibp 4
	sojg 3,%L625	; decrement_and_branch_until_zero
%L626:
	jumpe 3,%L628
%L627:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 3,%L627
%L628:
	ldb 4,4
	dpb 4,2
	move 3,[POINT 6,s6,5]
	move 4,6
	andi 4,35
	jumple 4,%L630
%L629:
	ibp 3
	sojg 4,%L629	; decrement_and_branch_until_zero
%L630:
	jumpe 4,%L632
%L631:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L631
%L632:
	ldb 4,3
	trne 4,40
	orcmi 4,77
	add 5,4
	addi 7,1
	sojge 1,%L636	; doloop_end
%L635:
	move 1,5
	popj 17,

copy_uchar6_global:
	setzb 5,7
	caml 5,1
	jrst %L656
	subi 1,1
%L657:
	move 6,7
	addi 6,22
	move 2,[POINT 6,u6,5]
	move 4,6
	andi 4,35
	jumple 4,%L643
%L642:
	ibp 2
	sojg 4,%L642	; decrement_and_branch_until_zero
%L643:
	jumpe 4,%L645
%L644:
	subi 2,1
	ibp 2
	ibp 2
	ibp 2
	ibp 2
	ibp 2
	aojl 4,%L644
%L645:
	move 4,[POINT 6,u6,5]
	move 3,7
	andi 3,17
	jumple 3,%L647
%L646:
	ibp 4
	sojg 3,%L646	; decrement_and_branch_until_zero
%L647:
	jumpe 3,%L649
%L648:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 3,%L648
%L649:
	ldb 4,4
	dpb 4,2
	move 3,[POINT 6,u6,5]
	move 4,6
	andi 4,35
	jumple 4,%L651
%L650:
	ibp 3
	sojg 4,%L650	; decrement_and_branch_until_zero
%L651:
	jumpe 4,%L653
%L652:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L652
%L653:
	ldb 4,3
	add 5,4
	addi 7,1
	sojge 1,%L657	; doloop_end
%L656:
	move 1,5
	popj 17,

sum_b6a_signed:
	setzb 6,2
	caml 6,1
	jrst %L665
	subi 1,1
%L666:
	move 4,2
	andi 4,7
	lsh 4,2
	move 3,b6a(4)
	ash 3,-36
	move 4,b6a(4)
	lsh 4,36
	ash 4,-36
	add 3,4
	add 6,3
	addi 2,1
	sojge 1,%L666	; doloop_end
%L665:
	move 1,6
	popj 17,

sum_b6a_unsigned:
	setzb 6,2
	caml 6,1
	jrst %L674
	subi 1,1
%L675:
	move 4,2
	andi 4,7
	lsh 4,2
	add 4,[POINT 6,b6a,5]
	move 3,1(4)
	lsh 3,-36
	ldb 4,[POINT 6,1(4),35]
	add 3,4
	add 6,3
	addi 2,1
	sojge 1,%L675	; doloop_end
%L674:
	move 1,6
	popj 17,

zero_b6a_signed:
	movei 2,0
	caml 2,1
	popj 17,
	movei 3,0
	subi 1,1
%L684:
	move 4,2
	andi 4,7
	lsh 4,2
	dpb 3,[POINT 6,b6a(4),5]
	dpb 3,[POINT 6,b6a(4),11]
	dpb 3,[POINT 6,b6a(4),17]
	dpb 3,[POINT 6,b6a(4),23]
	dpb 3,[POINT 6,b6a(4),29]
	dpb 3,[POINT 6,b6a(4),35]
	addi 2,1
	sojge 1,%L684	; doloop_end
	popj 17,

zero_b6a_unsigned:
	movei 2,0
	caml 2,1
	popj 17,
	movei 3,0
	subi 1,1
%L693:
	move 4,2
	andi 4,7
	lsh 4,2
	add 4,[POINT 6,b6a,5]
	dpb 3,[POINT 6,1(4),5]
	dpb 3,[POINT 6,1(4),11]
	dpb 3,[POINT 6,1(4),17]
	dpb 3,[POINT 6,1(4),23]
	dpb 3,[POINT 6,1(4),29]
	dpb 3,[POINT 6,1(4),35]
	addi 2,1
	sojge 1,%L693	; doloop_end
	popj 17,

copy_b6a:
	movei 4,0
	caml 4,1
	popj 17,
%L703:
	move 6,4
	aos 2,6
	andi 2,7
	lsh 2,1
	add 2,[POINT 6,b6a,5]
	andi 4,7
	move 3,[POINT 6,b6a,5]
	lsh 4,1
	jumple 4,%L700
%L699:
	ibp 3
	sojg 4,%L699	; decrement_and_branch_until_zero
%L700:
	jumpe 4,%L702
%L701:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L701
%L702:
	move 7,(3)
	movem 7,(2)
	move 3,1(3)
	movem 3,1(2)
	move 4,6
	camge 6,1
	jrst %L703
	popj 17,

load_char6_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 4,[POINT 6,s6,5]
	andi 10,17
	jumple 10,%L708
%L707:
	ibp 4
	sojg 10,%L707	; decrement_and_branch_until_zero
%L708:
	jumpe 10,%L710
%L709:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 10,%L709
%L710:
	ldb 1,4
	trne 1,40
	orcmi 1,77
	pop 17,10
	popj 17,

load_uchar6_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 4,[POINT 6,u6,5]
	andi 10,17
	jumple 10,%L713
%L712:
	ibp 4
	sojg 10,%L712	; decrement_and_branch_until_zero
%L713:
	jumpe 10,%L715
%L714:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 10,%L714
%L715:
	ldb 1,4
	pop 17,10
	popj 17,

store_char6_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	pushj 17,clobber
	move 4,[POINT 6,s6,5]
	andi 10,17
	jumple 10,%L718
%L717:
	ibp 4
	sojg 10,%L717	; decrement_and_branch_until_zero
%L718:
	jumpe 10,%L720
%L719:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 10,%L719
%L720:
	dpb 11,4
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

store_uchar6_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	pushj 17,clobber
	move 4,[POINT 6,u6,5]
	andi 10,17
	jumple 10,%L723
%L722:
	ibp 4
	sojg 10,%L722	; decrement_and_branch_until_zero
%L723:
	jumpe 10,%L725
%L724:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 10,%L724
%L725:
	dpb 11,4
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

load_char6_call_index:
	pushj 17,f
	move 4,[POINT 6,s6,5]
	andi 1,17
	jumple 1,%L728
%L727:
	ibp 4
	sojg 1,%L727	; decrement_and_branch_until_zero
%L728:
	jumpe 1,%L730
%L729:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L729
%L730:
	ldb 1,4
	trne 1,40
	orcmi 1,77
	popj 17,

load_uchar6_call_index:
	pushj 17,f
	move 4,[POINT 6,u6,5]
	andi 1,17
	jumple 1,%L733
%L732:
	ibp 4
	sojg 1,%L732	; decrement_and_branch_until_zero
%L733:
	jumpe 1,%L735
%L734:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L734
%L735:
	ldb 1,4
	popj 17,

store_char6_call_index:
	push 17,10
	move 10,1
	pushj 17,f
	move 4,[POINT 6,s6,5]
	andi 1,17
	jumple 1,%L738
%L737:
	ibp 4
	sojg 1,%L737	; decrement_and_branch_until_zero
%L738:
	jumpe 1,%L740
%L739:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L739
%L740:
	dpb 10,4
	pop 17,10
	popj 17,

store_uchar6_call_index:
	push 17,10
	move 10,1
	pushj 17,f
	move 4,[POINT 6,u6,5]
	andi 1,17
	jumple 1,%L743
%L742:
	ibp 4
	sojg 1,%L742	; decrement_and_branch_until_zero
%L743:
	jumpe 1,%L745
%L744:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L744
%L745:
	dpb 10,4
	pop 17,10
	popj 17,

add_char6_pointer:
	jumple 2,%L749
%L748:
	ibp 1
	sojg 2,%L748	; decrement_and_branch_until_zero
%L749:
	jumpe 2,%L751
%L750:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L750
%L751:
	popj 17,

add_uchar6_pointer:
	jumple 2,%L755
%L754:
	ibp 1
	sojg 2,%L754	; decrement_and_branch_until_zero
%L755:
	jumpe 2,%L757
%L756:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L756
%L757:
	popj 17,

sub_char6_pointer:
	movn 2,2
	jumple 2,%L761
%L760:
	ibp 1
	sojg 2,%L760	; decrement_and_branch_until_zero
%L761:
	jumpe 2,%L763
%L762:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L762
%L763:
	popj 17,

sub_uchar6_pointer:
	movn 2,2
	jumple 2,%L767
%L766:
	ibp 1
	sojg 2,%L766	; decrement_and_branch_until_zero
%L767:
	jumpe 2,%L769
%L768:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L768
%L769:
	popj 17,

add_char6_pointer_const_1:
	ibp 1
	popj 17,

add_char6_pointer_const_5:
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

add_char6_pointer_const_6:
	addi 1,1
	popj 17,

add_char6_pointer_const_7:
	addi 1,1
	ibp 1
	popj 17,

add_uchar6_pointer_const_1:
	ibp 1
	popj 17,

add_uchar6_pointer_const_5:
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

add_uchar6_pointer_const_6:
	addi 1,1
	popj 17,

add_uchar6_pointer_const_7:
	addi 1,1
	ibp 1
	popj 17,

use_byte6_more:
	add 17,[7,,7]
	movem 16,-6(17)
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	move 11,2
	pushj 17,store_char6_index
	move 10,11
	addi 10,1
	move 1,12
	move 2,10
	pushj 17,store_char6_index_plus_1
	move 13,11
	addi 13,5
	move 1,12
	move 2,13
	pushj 17,store_uchar6_index_plus_5
	move 1,11
	pushj 17,b6_store_c0
	move 1,10
	pushj 17,b6_store_c1
	move 16,11
	addi 16,2
	move 1,16
	pushj 17,b6_store_c2
	move 15,11
	addi 15,3
	move 1,15
	pushj 17,b6_store_c3
	move 14,11
	addi 14,4
	move 1,14
	pushj 17,b6_store_c4
	move 1,13
	pushj 17,b6_store_c5
	move 1,11
	pushj 17,b6_store_u0
	move 1,10
	pushj 17,b6_store_u1
	move 1,16
	pushj 17,b6_store_u2
	move 1,15
	pushj 17,b6_store_u3
	move 1,14
	pushj 17,b6_store_u4
	move 1,13
	pushj 17,b6_store_u5
	move 1,12
	pushj 17,load_char6_masked
	move 10,1
	move 1,12
	pushj 17,load_uchar6_masked
	add 10,1
	pushj 17,load_char6_const_cross
	add 10,1
	pushj 17,b6_sum_signed
	add 10,1
	pushj 17,b6_sum_unsigned
	add 10,1
	move 1,12
	move 2,11
	pushj 17,char6_plus
	add 10,1
	move 1,12
	move 2,11
	pushj 17,uchar6_plus
	add 10,1
	move 1,12
	pushj 17,char6_range
	add 10,1
	move 1,12
	pushj 17,uchar6_range
	add 10,1
	move 1,10
	move 16,-6(17)
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-7,,-7]
	popj 17,

	.bss
s6:
	.space	36
u6:
	.space	36
vs6:
	.space	36
vu6:
	.space	36
b6:
	.space	8
sb6:
	.space	4
ub6:
	.space	4
mb6:
	.space	16
b6a:
	.space	64
sb6a:
	.space	32
ub6a:
	.space	32
mb6a:
	.space	128
