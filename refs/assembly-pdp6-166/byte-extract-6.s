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
	.long	b6+32312918016
	.align	2
b6cp2:
	.long	b6+25870467072
	.align	2
b6cp3:
	.long	b6+19428016128
	.align	2
b6cp4:
	.long	b6+19428016128
	.align	2
b6cp5:
	.long	b6+12985565184
	.align	2
b6up0:
	.long	b6+6543114240
	.align	2
b6up1:
	.long	b6+6543114240
	.align	2
b6up2:
	.long	b6+100663296
	.align	2
b6up3:
	.long	b6+32312918017
	.align	2
b6up4:
	.long	b6+32312918017
	.align	2
b6up5:
	.long	b6+25870467073

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
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,40
	orcmi 1,77
	popj 17,

load_uchar6_index:
	move 4,[POINT 6,u6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
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
	move 4,[POINT 6,s6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	move 4,[POINT 6,u6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	addi 2,1
	dpb 2,4
	popj 17,

copy_char6:
	push 17,10
	move 10,1
	setzb 1,5
	caml 1,3
	jrst %L71
	subi 3,1
%L72:
	move 6,10
	move 4,5
	jumple 5,%L56
%L55:
	ibp 6
	sojg 4,%L55	; decrement_and_branch_until_zero
%L56:
	jumpe 4,%L58
%L57:
	subi 6,1
	ibp 6
	ibp 6
	ibp 6
	ibp 6
	ibp 6
	aojl 4,%L57
%L58:
	move 4,2
	move 7,5
	jumple 5,%L61
%L60:
	ibp 4
	sojg 7,%L60	; decrement_and_branch_until_zero
%L61:
	jumpe 7,%L63
%L62:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 7,%L62
%L63:
	ldb 4,4
	dpb 4,6
	move 4,10
	move 6,5
	jumple 5,%L66
%L65:
	ibp 4
	sojg 6,%L65	; decrement_and_branch_until_zero
%L66:
	jumpe 6,%L68
%L67:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 6,%L67
%L68:
	ldb 4,4
	trne 4,40
	orcmi 4,77
	add 1,4
	addi 5,1
	sojge 3,%L72	; doloop_end
%L71:
	pop 17,10
	popj 17,

copy_uchar6:
	push 17,10
	move 10,1
	setzb 1,5
	caml 1,3
	jrst %L95
	subi 3,1
%L96:
	move 6,10
	move 4,5
	jumple 5,%L80
%L79:
	ibp 6
	sojg 4,%L79	; decrement_and_branch_until_zero
%L80:
	jumpe 4,%L82
%L81:
	subi 6,1
	ibp 6
	ibp 6
	ibp 6
	ibp 6
	ibp 6
	aojl 4,%L81
%L82:
	move 4,2
	move 7,5
	jumple 5,%L85
%L84:
	ibp 4
	sojg 7,%L84	; decrement_and_branch_until_zero
%L85:
	jumpe 7,%L87
%L86:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 7,%L86
%L87:
	ldb 4,4
	dpb 4,6
	move 4,10
	move 6,5
	jumple 5,%L90
%L89:
	ibp 4
	sojg 6,%L89	; decrement_and_branch_until_zero
%L90:
	jumpe 6,%L92
%L91:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 6,%L91
%L92:
	ldb 4,4
	add 1,4
	addi 5,1
	sojge 3,%L96	; doloop_end
%L95:
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
	andi 1,17
	move 4,[POINT 6,s6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	lsh 2,36
	ash 2,-36
	move 1,2
	popj 17,

store_u6_return:
	andi 1,17
	move 4,[POINT 6,u6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
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
	andi 1,17
	move 4,[POINT 6,s6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,40
	orcmi 1,77
	popj 17,

load_uchar6_masked:
	andi 1,17
	move 4,[POINT 6,u6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	popj 17,

load_char6_pointer:
	jumple 2,%L199
%L198:
	ibp 1
	sojg 2,%L198	; decrement_and_branch_until_zero
%L199:
	jumpe 2,%L201
%L200:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L200
%L201:
	ldb 1,1
	trne 1,40
	orcmi 1,77
	popj 17,

load_uchar6_pointer:
	jumple 2,%L205
%L204:
	ibp 1
	sojg 2,%L204	; decrement_and_branch_until_zero
%L205:
	jumpe 2,%L207
%L206:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L206
%L207:
	ldb 1,1
	popj 17,

store_char6_pointer:
	jumple 2,%L211
%L210:
	ibp 1
	sojg 2,%L210	; decrement_and_branch_until_zero
%L211:
	jumpe 2,%L213
%L212:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L212
%L213:
	dpb 3,1
	popj 17,

store_uchar6_pointer:
	jumple 2,%L217
%L216:
	ibp 1
	sojg 2,%L216	; decrement_and_branch_until_zero
%L217:
	jumpe 2,%L219
%L218:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L218
%L219:
	dpb 3,1
	popj 17,

load_char6_index_plus_1:
	addi 1,1
	andi 1,17
	move 4,[POINT 6,s6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,40
	orcmi 1,77
	popj 17,

load_char6_index_plus_5:
	addi 1,5
	andi 1,17
	move 4,[POINT 6,s6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,40
	orcmi 1,77
	popj 17,

load_char6_index_minus_1:
	subi 1,1
	andi 1,17
	move 4,[POINT 6,s6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,40
	orcmi 1,77
	popj 17,

load_uchar6_index_plus_1:
	addi 1,1
	andi 1,17
	move 4,[POINT 6,u6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	popj 17,

load_uchar6_index_plus_5:
	addi 1,5
	andi 1,17
	move 4,[POINT 6,u6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	popj 17,

load_uchar6_index_minus_1:
	subi 1,1
	andi 1,17
	move 4,[POINT 6,u6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	popj 17,

store_char6_index_plus_1:
	addi 1,1
	andi 1,17
	move 4,[POINT 6,s6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

store_char6_index_plus_5:
	addi 1,5
	andi 1,17
	move 4,[POINT 6,s6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

store_char6_index_minus_1:
	subi 1,1
	andi 1,17
	move 4,[POINT 6,s6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

store_uchar6_index_plus_1:
	addi 1,1
	andi 1,17
	move 4,[POINT 6,u6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

store_uchar6_index_plus_5:
	addi 1,5
	andi 1,17
	move 4,[POINT 6,u6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

store_uchar6_index_minus_1:
	subi 1,1
	andi 1,17
	move 4,[POINT 6,u6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
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
	jumple 1,%L255
%L254:
	ibp 4
	sojg 1,%L254	; decrement_and_branch_until_zero
%L255:
	jumpe 1,%L257
%L256:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L256
%L257:
	move 1,4
	popj 17,

addr_b6_c0:
	move 1,[POINT 6,b6,5]
	popj 17,

addr_b6_c5:
	move 1,[POINT 6,b6,23]
	popj 17,

addr_b6_u0:
	move 1,[POINT 6,b6,29]
	popj 17,

addr_b6_u5:
	move 1,[POINT 6,b6+1,11]
	popj 17,

addr_load_s6:
	move 4,[POINT 6,s6,5]
	andi 1,17
	jumple 1,%L274
%L273:
	ibp 4
	sojg 1,%L273	; decrement_and_branch_until_zero
%L274:
	jumpe 1,%L276
%L275:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L275
%L276:
	ldb 1,4
	trne 1,40
	orcmi 1,77
	popj 17,

addr_load_u6:
	move 4,[POINT 6,u6,5]
	andi 1,17
	jumple 1,%L281
%L280:
	ibp 4
	sojg 1,%L280	; decrement_and_branch_until_zero
%L281:
	jumpe 1,%L283
%L282:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L282
%L283:
	ldb 1,4
	popj 17,

addr_store_s6:
	move 4,[POINT 6,s6,5]
	andi 1,17
	jumple 1,%L288
%L287:
	ibp 4
	sojg 1,%L287	; decrement_and_branch_until_zero
%L288:
	jumpe 1,%L290
%L289:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L289
%L290:
	dpb 2,4
	popj 17,

addr_store_u6:
	move 4,[POINT 6,u6,5]
	andi 1,17
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
	ibp 4
	aojl 1,%L296
%L297:
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
	move 1,b6a+pdp10.c:7954:TOOBIG:(1)
	ash 1,-36
	popj 17,

b6a_load_c5:
	andi 1,7
	lsh 1,2
	move 1,b6a+pdp10.c:7954:TOOBIG:(1)
	lsh 1,36
	ash 1,-36
	popj 17,

b6a_load_u0:
	andi 1,7
	lsh 1,2
	move 1,b6a+pdp10.c:7954:TOOBIG:1(1)
	lsh 1,-36
	popj 17,

b6a_load_u5:
	andi 1,7
	lsh 1,2
	move 1,b6a+pdp10.c:7954:TOOBIG:1(1)
	andi 1,77
	popj 17,

b6a_store_c0:
	andi 1,7
	lsh 1,2
	dpb 2,[POINT 6,b6a+pdp10.c:7954:TOOBIG:(1),5]
	popj 17,

b6a_store_c5:
	andi 1,7
	lsh 1,2
	dpb 2,[POINT 6,b6a+pdp10.c:7954:TOOBIG:(1),35]
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
	andi 1,17
	move 4,[POINT 6,vs6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,40
	orcmi 1,77
	popj 17,

vload_u6:
	andi 1,17
	move 4,[POINT 6,vu6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	popj 17,

vstore_s6:
	andi 1,17
	move 4,[POINT 6,vs6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

vstore_u6:
	andi 1,17
	move 4,[POINT 6,vu6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
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
	andi 1,17
	move 4,[POINT 6,s6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,40
	orcmi 1,77
	popj 17,

extend_uchar6_array:
	andi 1,17
	move 4,[POINT 6,u6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
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
	andi 1,17
	move 4,[POINT 6,s6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,40
	orcmi 1,77
	add 1,2
	popj 17,

uchar6_plus:
	andi 1,17
	move 4,[POINT 6,u6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	add 1,2
	popj 17,

char6_sub:
	andi 1,17
	move 4,[POINT 6,s6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,40
	orcmi 1,77
	sub 1,2
	popj 17,

uchar6_xor:
	andi 1,17
	move 4,[POINT 6,u6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	xor 1,2
	popj 17,

char6_eq_zero:
	andi 1,17
	move 4,[POINT 6,s6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	skipe 4
	tdza 1,1
	movei 1,1
	popj 17,

char6_lt_zero:
	andi 1,17
	move 4,[POINT 6,s6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,400
	orcmi 1,777
	lsh 1,-43
	popj 17,

uchar6_eq_zero:
	andi 1,17
	move 4,[POINT 6,u6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	skipe 4
	tdza 1,1
	movei 1,1
	popj 17,

uchar6_gt_31:
	andi 1,17
	move 4,[POINT 6,u6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	tlo 1,400000
	move 6,[-377777777741]
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

char6_range:
	andi 1,17
	move 4,[POINT 6,s6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
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
	andi 1,17
	move 4,[POINT 6,u6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
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
	jrst %L395
	subi 2,1
%L396:
	ldb 4,1
	trne 4,40
	orcmi 4,77
	add 3,4
	ibp 1
	sojge 2,%L396	; doloop_end
%L395:
	move 1,3
	popj 17,

walk_sum_uchar6:
	movei 3,0
	caml 3,2
	jrst %L404
	subi 2,1
%L405:
	ldb 4,1
	add 3,4
	ibp 1
	sojge 2,%L405	; doloop_end
%L404:
	move 1,3
	popj 17,

walk_zero_char6:
	jumple 2,%L413
	movei 4,0
	subi 2,1
%L414:
	dpb 4,1
	ibp 1
	sojge 2,%L414	; doloop_end
%L413:
	popj 17,

walk_zero_uchar6:
	jumple 2,%L422
	movei 4,0
	subi 2,1
%L423:
	dpb 4,1
	ibp 1
	sojge 2,%L423	; doloop_end
%L422:
	popj 17,

sum_char6_global:
	setzb 2,3
	caml 2,1
	jrst %L431
	move 6,[POINT 6,s6,5]
	subi 1,1
%L432:
	move 4,3
	andi 4,17
	move 7,6
	move 0,4
	jumple 0,.+3
	ibp 7
	sojg 0,.-1
	ldb 4,7
	trne 4,40
	orcmi 4,77
	add 2,4
	addi 3,1
	sojge 1,%L432	; doloop_end
%L431:
	move 1,2
	popj 17,

sum_uchar6_global:
	setzb 2,3
	caml 2,1
	jrst %L440
	move 6,[POINT 6,u6,5]
	subi 1,1
%L441:
	move 4,3
	andi 4,17
	move 7,6
	move 0,4
	jumple 0,.+3
	ibp 7
	sojg 0,.-1
	ldb 4,7
	add 2,4
	addi 3,1
	sojge 1,%L441	; doloop_end
%L440:
	move 1,2
	popj 17,

zero_char6_global:
	movei 3,0
	caml 3,1
	popj 17,
	movei 2,0
	subi 1,1
%L450:
	move 4,3
	andi 4,17
	move 6,[POINT 6,s6,5]
	move 0,4
	jumple 0,.+3
	ibp 6
	sojg 0,.-1
	dpb 2,6
	addi 3,1
	sojge 1,%L450	; doloop_end
	popj 17,

zero_uchar6_global:
	movei 3,0
	caml 3,1
	popj 17,
	movei 2,0
	subi 1,1
%L459:
	move 4,3
	andi 4,17
	move 6,[POINT 6,u6,5]
	move 0,4
	jumple 0,.+3
	ibp 6
	sojg 0,.-1
	dpb 2,6
	addi 3,1
	sojge 1,%L459	; doloop_end
	popj 17,

set_char6_index_global:
	movei 3,0
	caml 3,1
	popj 17,
	subi 1,1
%L468:
	move 4,3
	andi 4,17
	move 6,[POINT 6,s6,5]
	move 0,4
	jumple 0,.+3
	ibp 6
	sojg 0,.-1
	dpb 3,6
	addi 3,1
	sojge 1,%L468	; doloop_end
	popj 17,

set_uchar6_index_global:
	movei 3,0
	caml 3,1
	popj 17,
	subi 1,1
%L477:
	move 4,3
	andi 4,17
	move 6,[POINT 6,u6,5]
	move 0,4
	jumple 0,.+3
	ibp 6
	sojg 0,.-1
	dpb 3,6
	addi 3,1
	sojge 1,%L477	; doloop_end
	popj 17,

copy_char6_global:
	push 17,10
	setzb 7,6
	caml 7,1
	jrst %L485
	move 5,[POINT 6,s6,5]
	subi 1,1
%L486:
	addi 6,22
	move 2,6
	andi 2,35
	subi 6,22
	move 3,[POINT 6,s6,5]
	move 0,2
	jumple 0,.+3
	ibp 3
	sojg 0,.-1
	move 4,6
	andi 4,17
	move 10,5
	move 0,4
	jumple 0,.+3
	ibp 10
	sojg 0,.-1
	ldb 4,10
	dpb 4,3
	move 4,5
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	trne 4,40
	orcmi 4,77
	add 7,4
	addi 6,1
	sojge 1,%L486	; doloop_end
%L485:
	move 1,7
	pop 17,10
	popj 17,

copy_uchar6_global:
	push 17,10
	setzb 7,6
	caml 7,1
	jrst %L494
	move 5,[POINT 6,u6,5]
	subi 1,1
%L495:
	addi 6,22
	move 2,6
	andi 2,35
	subi 6,22
	move 3,[POINT 6,u6,5]
	move 0,2
	jumple 0,.+3
	ibp 3
	sojg 0,.-1
	move 4,6
	andi 4,17
	move 10,5
	move 0,4
	jumple 0,.+3
	ibp 10
	sojg 0,.-1
	ldb 4,10
	dpb 4,3
	move 4,5
	move 0,2
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	add 7,4
	addi 6,1
	sojge 1,%L495	; doloop_end
%L494:
	move 1,7
	pop 17,10
	popj 17,

sum_b6a_signed:
	setzb 6,2
	caml 6,1
	jrst %L503
	subi 1,1
%L504:
	move 4,2
	andi 4,7
	lsh 4,2
	move 3,b6a+pdp10.c:7954:TOOBIG:(4)
	ash 3,-36
	move 4,b6a+pdp10.c:7954:TOOBIG:(4)
	lsh 4,36
	ash 4,-36
	add 3,4
	add 6,3
	addi 2,1
	sojge 1,%L504	; doloop_end
%L503:
	move 1,6
	popj 17,

sum_b6a_unsigned:
	setzb 6,2
	caml 6,1
	jrst %L512
	subi 1,1
%L513:
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
	sojge 1,%L513	; doloop_end
%L512:
	move 1,6
	popj 17,

zero_b6a_signed:
	movei 2,0
	caml 2,1
	popj 17,
	movei 3,0
	subi 1,1
%L522:
	move 4,2
	andi 4,7
	lsh 4,2
	dpb 3,[POINT 6,b6a+pdp10.c:7954:TOOBIG:(4),5]
	dpb 3,[POINT 6,b6a+pdp10.c:7954:TOOBIG:(4),11]
	dpb 3,[POINT 6,b6a+pdp10.c:7954:TOOBIG:(4),17]
	dpb 3,[POINT 6,b6a+pdp10.c:7954:TOOBIG:(4),23]
	dpb 3,[POINT 6,b6a+pdp10.c:7954:TOOBIG:(4),29]
	dpb 3,[POINT 6,b6a+pdp10.c:7954:TOOBIG:(4),35]
	addi 2,1
	sojge 1,%L522	; doloop_end
	popj 17,

zero_b6a_unsigned:
	movei 2,0
	caml 2,1
	popj 17,
	movei 3,0
	subi 1,1
%L531:
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
	sojge 1,%L531	; doloop_end
	popj 17,

copy_b6a:
	movei 4,0
	caml 4,1
	popj 17,
	move 6,[POINT 6,b6a,5]
	subi 1,1
%L540:
	move 2,4
	aos 3,2
	andi 3,7
	lsh 3,1
	andi 4,7
	lsh 4,1
	move 7,6
	move 0,4
	jumple 0,.+3
	ibp 7
	sojg 0,.-1
	move 4,7
	move 7,(7)
	movem 7,b6a+pdp10.c:7954:TOOBIG:(3)
	move 4,1(4)
	movem 4,b6a+pdp10.c:7954:TOOBIG:1(3)
	move 4,2
	sojge 1,%L540	; doloop_end
	popj 17,

load_char6_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	andi 10,17
	move 4,[POINT 6,s6,5]
	move 0,10
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,40
	orcmi 1,77
	pop 17,10
	popj 17,

load_uchar6_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	andi 10,17
	move 4,[POINT 6,u6,5]
	move 0,10
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
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
	andi 10,17
	move 4,[POINT 6,s6,5]
	move 0,10
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
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
	andi 10,17
	move 4,[POINT 6,u6,5]
	move 0,10
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 11,4
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

load_char6_call_index:
	pushj 17,f
	andi 1,17
	move 4,[POINT 6,s6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,40
	orcmi 1,77
	popj 17,

load_uchar6_call_index:
	pushj 17,f
	andi 1,17
	move 4,[POINT 6,u6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	popj 17,

store_char6_call_index:
	push 17,10
	move 10,1
	pushj 17,f
	andi 1,17
	move 4,[POINT 6,s6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 10,4
	pop 17,10
	popj 17,

store_uchar6_call_index:
	push 17,10
	move 10,1
	pushj 17,f
	andi 1,17
	move 4,[POINT 6,u6,5]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 10,4
	pop 17,10
	popj 17,

add_char6_pointer:
	jumple 2,%L552
%L551:
	ibp 1
	sojg 2,%L551	; decrement_and_branch_until_zero
%L552:
	jumpe 2,%L554
%L553:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L553
%L554:
	popj 17,

add_uchar6_pointer:
	jumple 2,%L558
%L557:
	ibp 1
	sojg 2,%L557	; decrement_and_branch_until_zero
%L558:
	jumpe 2,%L560
%L559:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L559
%L560:
	popj 17,

sub_char6_pointer:
	movn 2,2
	jumple 2,%L564
%L563:
	ibp 1
	sojg 2,%L563	; decrement_and_branch_until_zero
%L564:
	jumpe 2,%L566
%L565:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L565
%L566:
	popj 17,

sub_uchar6_pointer:
	movn 2,2
	jumple 2,%L570
%L569:
	ibp 1
	sojg 2,%L569	; decrement_and_branch_until_zero
%L570:
	jumpe 2,%L572
%L571:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L571
%L572:
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
