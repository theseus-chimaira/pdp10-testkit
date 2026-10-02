
load7_0:
	move 1,b7
	ash 1,-35
	popj 17,

loadu7_0:
	move 1,b7+1
	lsh 1,-35
	popj 17,

load7_1:
	move 1,b7
	lsh 1,7
	ash 1,-35
	popj 17,

loadu7_1:
	ldb 1,[POINT 7,b7+1,13]
	popj 17,

load7_2:
	move 1,b7
	lsh 1,16
	ash 1,-35
	popj 17,

loadu7_2:
	ldb 1,[POINT 7,b7+1,20]
	popj 17,

load7_3:
	move 1,b7
	lsh 1,25
	ash 1,-35
	popj 17,

loadu7_3:
	ldb 1,[POINT 7,b7+1,27]
	popj 17,

load7_4:
	move 1,b7
	lsh 1,34
	ash 1,-35
	popj 17,

loadu7_4:
	ldb 1,[POINT 7,b7+1,34]
	popj 17,

load_char7_index:
	move 4,[POINT 7,s7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

load_uchar7_index:
	move 4,[POINT 7,u7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	popj 17,

load_char7_const_cross:
	move 1,s7
	ash 1,-35
	move 4,s7
	lsh 4,34
	ash 4,-35
	add 1,4
	move 4,s7+1
	ash 4,-35
	add 1,4
	move 4,s7+1
	lsh 4,34
	ash 4,-35
	add 1,4
	move 4,s7+2
	ash 4,-35
	add 1,4
	popj 17,

store_char7_index:
	move 4,[POINT 7,s7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	move 4,[POINT 7,u7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	addi 2,1
	dpb 2,4
	popj 17,

copy_char7:
	push 17,10
	move 10,1
	setzb 1,5
	caml 1,3
	jrst %L37
	subi 3,1
%L38:
	move 7,10
	move 4,5
	jumple 5,%L22
%L21:
	ibp 7
	sojg 4,%L21	; decrement_and_branch_until_zero
%L22:
	jumpe 4,%L24
%L23:
	subi 7,1
	ibp 7
	ibp 7
	ibp 7
	ibp 7
	aojl 4,%L23
%L24:
	move 4,2
	move 6,5
	jumple 5,%L27
%L26:
	ibp 4
	sojg 6,%L26	; decrement_and_branch_until_zero
%L27:
	jumpe 6,%L29
%L28:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 6,%L28
%L29:
	ldb 4,4
	dpb 4,7
	move 4,10
	move 6,5
	jumple 5,%L32
%L31:
	ibp 4
	sojg 6,%L31	; decrement_and_branch_until_zero
%L32:
	jumpe 6,%L34
%L33:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 6,%L33
%L34:
	ldb 4,4
	trne 4,100
	orcmi 4,177
	add 1,4
	addi 5,1
	sojge 3,%L38	; doloop_end
%L37:
	pop 17,10
	popj 17,

copy_uchar7:
	push 17,10
	move 10,1
	setzb 1,5
	caml 1,3
	jrst %L61
	subi 3,1
%L62:
	move 7,10
	move 4,5
	jumple 5,%L46
%L45:
	ibp 7
	sojg 4,%L45	; decrement_and_branch_until_zero
%L46:
	jumpe 4,%L48
%L47:
	subi 7,1
	ibp 7
	ibp 7
	ibp 7
	ibp 7
	aojl 4,%L47
%L48:
	move 4,2
	move 6,5
	jumple 5,%L51
%L50:
	ibp 4
	sojg 6,%L50	; decrement_and_branch_until_zero
%L51:
	jumpe 6,%L53
%L52:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 6,%L52
%L53:
	ldb 4,4
	dpb 4,7
	move 4,10
	move 6,5
	jumple 5,%L56
%L55:
	ibp 4
	sojg 6,%L55	; decrement_and_branch_until_zero
%L56:
	jumpe 6,%L58
%L57:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 6,%L57
%L58:
	ldb 4,4
	add 1,4
	addi 5,1
	sojge 3,%L62	; doloop_end
%L61:
	pop 17,10
	popj 17,

use_byte7:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	pushj 17,store_char7_index
	dpb 10,[POINT 7,b7,6]
	move 1,10
	addi 1,1
	dpb 1,[POINT 7,b7,13]
	move 2,10
	addi 2,2
	dpb 2,[POINT 7,b7,20]
	move 3,10
	addi 3,3
	dpb 3,[POINT 7,b7,27]
	move 4,10
	addi 4,4
	dpb 4,[POINT 7,b7,34]
	dpb 10,[POINT 7,b7+1,6]
	dpb 1,[POINT 7,b7+1,13]
	dpb 2,[POINT 7,b7+1,20]
	dpb 3,[POINT 7,b7+1,27]
	dpb 4,[POINT 7,b7+1,34]
	move 1,11
	pushj 17,load_char7_index
	move 10,1
	move 1,11
	pushj 17,load_uchar7_index
	add 10,1
	pushj 17,load_char7_const_cross
	add 10,1
	pushj 17,load7_0
	add 10,1
	pushj 17,load7_1
	add 10,1
	pushj 17,load7_2
	add 10,1
	pushj 17,load7_3
	add 10,1
	pushj 17,load7_4
	add 10,1
	pushj 17,loadu7_0
	add 10,1
	pushj 17,loadu7_1
	add 10,1
	pushj 17,loadu7_2
	add 10,1
	pushj 17,loadu7_3
	add 10,1
	pushj 17,loadu7_4
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

load_s7_0:
	move 1,s7
	ash 1,-35
	popj 17,

load_s7_1:
	move 1,s7
	lsh 1,7
	ash 1,-35
	popj 17,

load_s7_2:
	move 1,s7
	lsh 1,16
	ash 1,-35
	popj 17,

load_s7_3:
	move 1,s7
	lsh 1,25
	ash 1,-35
	popj 17,

load_s7_4:
	move 1,s7
	lsh 1,34
	ash 1,-35
	popj 17,

load_s7_5:
	move 1,s7+1
	ash 1,-35
	popj 17,

load_s7_6:
	move 1,s7+1
	lsh 1,7
	ash 1,-35
	popj 17,

load_s7_7:
	move 1,s7+1
	lsh 1,16
	ash 1,-35
	popj 17,

load_s7_8:
	move 1,s7+1
	lsh 1,25
	ash 1,-35
	popj 17,

load_s7_9:
	move 1,s7+1
	lsh 1,34
	ash 1,-35
	popj 17,

load_s7_10:
	move 1,s7+2
	ash 1,-35
	popj 17,

load_u7_0:
	move 1,u7
	lsh 1,-35
	popj 17,

load_u7_1:
	ldb 1,[POINT 7,u7,13]
	popj 17,

load_u7_2:
	ldb 1,[POINT 7,u7,20]
	popj 17,

load_u7_3:
	ldb 1,[POINT 7,u7,27]
	popj 17,

load_u7_4:
	ldb 1,[POINT 7,u7,34]
	popj 17,

load_u7_5:
	move 1,u7+1
	lsh 1,-35
	popj 17,

load_u7_6:
	ldb 1,[POINT 7,u7+1,13]
	popj 17,

load_u7_7:
	ldb 1,[POINT 7,u7+1,20]
	popj 17,

load_u7_8:
	ldb 1,[POINT 7,u7+1,27]
	popj 17,

load_u7_9:
	ldb 1,[POINT 7,u7+1,34]
	popj 17,

load_u7_10:
	move 1,u7+2
	lsh 1,-35
	popj 17,

store_s7_0:
	dpb 1,[POINT 7,s7,6]
	popj 17,

store_s7_1:
	dpb 1,[POINT 7,s7,13]
	popj 17,

store_s7_2:
	dpb 1,[POINT 7,s7,20]
	popj 17,

store_s7_3:
	dpb 1,[POINT 7,s7,27]
	popj 17,

store_s7_4:
	dpb 1,[POINT 7,s7,34]
	popj 17,

store_s7_5:
	dpb 1,[POINT 7,s7+1,6]
	popj 17,

store_s7_6:
	dpb 1,[POINT 7,s7+1,13]
	popj 17,

store_s7_7:
	dpb 1,[POINT 7,s7+1,20]
	popj 17,

store_s7_8:
	dpb 1,[POINT 7,s7+1,27]
	popj 17,

store_s7_9:
	dpb 1,[POINT 7,s7+1,34]
	popj 17,

store_s7_10:
	dpb 1,[POINT 7,s7+2,6]
	popj 17,

store_u7_0:
	dpb 1,[POINT 7,u7,6]
	popj 17,

store_u7_1:
	dpb 1,[POINT 7,u7,13]
	popj 17,

store_u7_2:
	dpb 1,[POINT 7,u7,20]
	popj 17,

store_u7_3:
	dpb 1,[POINT 7,u7,27]
	popj 17,

store_u7_4:
	dpb 1,[POINT 7,u7,34]
	popj 17,

store_u7_5:
	dpb 1,[POINT 7,u7+1,6]
	popj 17,

store_u7_6:
	dpb 1,[POINT 7,u7+1,13]
	popj 17,

store_u7_7:
	dpb 1,[POINT 7,u7+1,20]
	popj 17,

store_u7_8:
	dpb 1,[POINT 7,u7+1,27]
	popj 17,

store_u7_9:
	dpb 1,[POINT 7,u7+1,34]
	popj 17,

store_u7_10:
	dpb 1,[POINT 7,u7+2,6]
	popj 17,

store_s7_return:
	andi 1,17
	move 4,[POINT 7,s7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	lsh 2,35
	ash 2,-35
	move 1,2
	popj 17,

store_u7_return:
	andi 1,17
	move 4,[POINT 7,u7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	andi 2,177
	move 1,2
	popj 17,

store_s7_const_return:
	dpb 1,[POINT 7,s7,34]
	lsh 1,35
	ash 1,-35
	popj 17,

store_u7_const_return:
	dpb 1,[POINT 7,u7,34]
	andi 1,177
	popj 17,

load_s7_ptr_0:
	ldb 1,[POINT 7,s7,6]
	trne 1,100
	orcmi 1,177
	popj 17,

load_s7_ptr_4:
	move 4,[POINT 7,s7,6]
	ibp 4
	ibp 4
	ibp 4
	ildb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

load_s7_ptr_5:
	ldb 1,[POINT 7,s7+1,6]
	trne 1,100
	orcmi 1,177
	popj 17,

load_s7_ptr_9:
	move 4,[POINT 7,s7+1,6]
	ibp 4
	ibp 4
	ibp 4
	ildb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

load_s7_ptr_10:
	ldb 1,[POINT 7,s7+2,6]
	trne 1,100
	orcmi 1,177
	popj 17,

load_u7_ptr_0:
	ldb 1,[POINT 7,u7,6]
	popj 17,

load_u7_ptr_4:
	move 4,[POINT 7,u7,6]
	ibp 4
	ibp 4
	ibp 4
	ildb 1,4
	popj 17,

load_u7_ptr_5:
	ldb 1,[POINT 7,u7+1,6]
	popj 17,

load_u7_ptr_9:
	move 4,[POINT 7,u7+1,6]
	ibp 4
	ibp 4
	ibp 4
	ildb 1,4
	popj 17,

load_u7_ptr_10:
	ldb 1,[POINT 7,u7+2,6]
	popj 17,

store_s7_ptr_0:
	dpb 1,[POINT 7,s7,6]
	popj 17,

store_s7_ptr_4:
	move 4,[POINT 7,s7,6]
	ibp 4
	ibp 4
	ibp 4
	idpb 1,4
	popj 17,

store_s7_ptr_5:
	dpb 1,[POINT 7,s7+1,6]
	popj 17,

store_u7_ptr_0:
	dpb 1,[POINT 7,u7,6]
	popj 17,

store_u7_ptr_4:
	move 4,[POINT 7,u7,6]
	ibp 4
	ibp 4
	ibp 4
	idpb 1,4
	popj 17,

store_u7_ptr_5:
	dpb 1,[POINT 7,u7+1,6]
	popj 17,

load_b7p_c0:
	ldb 1,[POINT 7,b7,6]
	trne 1,100
	orcmi 1,177
	popj 17,

load_b7p_c1:
	ldb 1,[POINT 7,b7,6]
	trne 1,100
	orcmi 1,177
	popj 17,

load_b7p_c2:
	ldb 1,[POINT 7,b7,6]
	trne 1,100
	orcmi 1,177
	popj 17,

load_b7p_c3:
	ldb 1,[POINT 7,b7,6]
	trne 1,100
	orcmi 1,177
	popj 17,

load_b7p_c4:
	ldb 1,[POINT 7,b7,6]
	trne 1,100
	orcmi 1,177
	popj 17,

load_b7p_u0:
	ldb 1,[POINT 7,b7+1,6]
	popj 17,

load_b7p_u1:
	ldb 1,[POINT 7,b7+1,6]
	popj 17,

load_b7p_u2:
	ldb 1,[POINT 7,b7+1,6]
	popj 17,

load_b7p_u3:
	ldb 1,[POINT 7,b7+1,6]
	popj 17,

load_b7p_u4:
	ldb 1,[POINT 7,b7+1,6]
	popj 17,

store_b7p_c0:
	dpb 1,[POINT 7,b7,6]
	popj 17,

store_b7p_c1:
	dpb 1,[POINT 7,b7,6]
	popj 17,

store_b7p_c2:
	dpb 1,[POINT 7,b7,6]
	popj 17,

store_b7p_c3:
	dpb 1,[POINT 7,b7,6]
	popj 17,

store_b7p_c4:
	dpb 1,[POINT 7,b7,6]
	popj 17,

store_b7p_u0:
	dpb 1,[POINT 7,b7+1,6]
	popj 17,

store_b7p_u1:
	dpb 1,[POINT 7,b7+1,6]
	popj 17,

store_b7p_u2:
	dpb 1,[POINT 7,b7+1,6]
	popj 17,

store_b7p_u3:
	dpb 1,[POINT 7,b7+1,6]
	popj 17,

store_b7p_u4:
	dpb 1,[POINT 7,b7+1,6]
	popj 17,

load_char7_masked:
	andi 1,17
	move 4,[POINT 7,s7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

load_uchar7_masked:
	andi 1,17
	move 4,[POINT 7,u7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	popj 17,

load_char7_pointer:
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
	aojl 2,%L210
%L211:
	ldb 1,1
	trne 1,100
	orcmi 1,177
	popj 17,

load_uchar7_pointer:
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
	aojl 2,%L216
%L217:
	ldb 1,1
	popj 17,

store_char7_pointer:
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
	aojl 2,%L222
%L223:
	dpb 3,1
	popj 17,

store_uchar7_pointer:
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
	aojl 2,%L228
%L229:
	dpb 3,1
	popj 17,

load_char7_index_plus_1:
	addi 1,1
	andi 1,17
	move 4,[POINT 7,s7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

load_char7_index_plus_4:
	addi 1,4
	andi 1,17
	move 4,[POINT 7,s7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

load_char7_index_plus_5:
	addi 1,5
	andi 1,17
	move 4,[POINT 7,s7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

load_char7_index_minus_1:
	subi 1,1
	andi 1,17
	move 4,[POINT 7,s7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

load_uchar7_index_plus_1:
	addi 1,1
	andi 1,17
	move 4,[POINT 7,u7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	popj 17,

load_uchar7_index_plus_4:
	addi 1,4
	andi 1,17
	move 4,[POINT 7,u7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	popj 17,

load_uchar7_index_plus_5:
	addi 1,5
	andi 1,17
	move 4,[POINT 7,u7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	popj 17,

load_uchar7_index_minus_1:
	subi 1,1
	andi 1,17
	move 4,[POINT 7,u7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	popj 17,

store_char7_index_plus_1:
	addi 1,1
	andi 1,17
	move 4,[POINT 7,s7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

store_char7_index_plus_4:
	addi 1,4
	andi 1,17
	move 4,[POINT 7,s7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

store_char7_index_plus_5:
	addi 1,5
	andi 1,17
	move 4,[POINT 7,s7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

store_char7_index_minus_1:
	subi 1,1
	andi 1,17
	move 4,[POINT 7,s7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

store_uchar7_index_plus_1:
	addi 1,1
	andi 1,17
	move 4,[POINT 7,u7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

store_uchar7_index_plus_4:
	addi 1,4
	andi 1,17
	move 4,[POINT 7,u7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

store_uchar7_index_plus_5:
	addi 1,5
	andi 1,17
	move 4,[POINT 7,u7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

store_uchar7_index_minus_1:
	subi 1,1
	andi 1,17
	move 4,[POINT 7,u7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

addr_s7_0:
	move 1,[POINT 7,s7,6]
	popj 17,

addr_s7_4:
	move 1,[POINT 7,s7,6]
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

addr_s7_5:
	move 1,[POINT 7,s7+1,6]
	popj 17,

addr_s7_index:
	move 4,[POINT 7,s7,6]
	andi 1,17
	jumple 1,%L256
%L255:
	ibp 4
	sojg 1,%L255	; decrement_and_branch_until_zero
%L256:
	jumpe 1,%L258
%L257:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L257
%L258:
	move 1,4
	popj 17,

addr_u7_0:
	move 1,[POINT 7,u7,6]
	popj 17,

addr_u7_4:
	move 1,[POINT 7,u7,6]
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

addr_u7_5:
	move 1,[POINT 7,u7+1,6]
	popj 17,

addr_u7_index:
	move 4,[POINT 7,u7,6]
	andi 1,17
	jumple 1,%L269
%L268:
	ibp 4
	sojg 1,%L268	; decrement_and_branch_until_zero
%L269:
	jumpe 1,%L271
%L270:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L270
%L271:
	move 1,4
	popj 17,

addr_b7_c0:
	move 1,[POINT 7,b7,6]
	popj 17,

addr_b7_c4:
	move 1,[POINT 7,b7,6]
	popj 17,

addr_b7_u0:
	move 1,[POINT 7,b7+1,6]
	popj 17,

addr_b7_u4:
	move 1,[POINT 7,b7+1,6]
	popj 17,

addr_load_s7:
	move 4,[POINT 7,s7,6]
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
	aojl 1,%L289
%L290:
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

addr_load_u7:
	move 4,[POINT 7,u7,6]
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
	aojl 1,%L296
%L297:
	ldb 1,4
	popj 17,

addr_store_s7:
	move 4,[POINT 7,s7,6]
	andi 1,17
	jumple 1,%L302
%L301:
	ibp 4
	sojg 1,%L301	; decrement_and_branch_until_zero
%L302:
	jumpe 1,%L304
%L303:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L303
%L304:
	dpb 2,4
	popj 17,

addr_store_u7:
	move 4,[POINT 7,u7,6]
	andi 1,17
	jumple 1,%L309
%L308:
	ibp 4
	sojg 1,%L308	; decrement_and_branch_until_zero
%L309:
	jumpe 1,%L311
%L310:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L310
%L311:
	dpb 2,4
	popj 17,

b7_load_c0:
	move 1,b7
	ash 1,-35
	popj 17,

b7_load_c1:
	move 1,b7
	lsh 1,7
	ash 1,-35
	popj 17,

b7_load_c2:
	move 1,b7
	lsh 1,16
	ash 1,-35
	popj 17,

b7_load_c3:
	move 1,b7
	lsh 1,25
	ash 1,-35
	popj 17,

b7_load_c4:
	move 1,b7
	lsh 1,34
	ash 1,-35
	popj 17,

b7_load_u0:
	move 1,b7+1
	lsh 1,-35
	popj 17,

b7_load_u1:
	ldb 1,[POINT 7,b7+1,13]
	popj 17,

b7_load_u2:
	ldb 1,[POINT 7,b7+1,20]
	popj 17,

b7_load_u3:
	ldb 1,[POINT 7,b7+1,27]
	popj 17,

b7_load_u4:
	ldb 1,[POINT 7,b7+1,34]
	popj 17,

b7_store_c0:
	dpb 1,[POINT 7,b7,6]
	popj 17,

b7_store_c1:
	dpb 1,[POINT 7,b7,13]
	popj 17,

b7_store_c2:
	dpb 1,[POINT 7,b7,20]
	popj 17,

b7_store_c3:
	dpb 1,[POINT 7,b7,27]
	popj 17,

b7_store_c4:
	dpb 1,[POINT 7,b7,34]
	popj 17,

b7_store_u0:
	dpb 1,[POINT 7,b7+1,6]
	popj 17,

b7_store_u1:
	dpb 1,[POINT 7,b7+1,13]
	popj 17,

b7_store_u2:
	dpb 1,[POINT 7,b7+1,20]
	popj 17,

b7_store_u3:
	dpb 1,[POINT 7,b7+1,27]
	popj 17,

b7_store_u4:
	dpb 1,[POINT 7,b7+1,34]
	popj 17,

b7_sum_signed:
	move 1,b7
	ash 1,-35
	move 4,b7
	lsh 4,7
	ash 4,-35
	add 1,4
	move 4,b7
	lsh 4,16
	ash 4,-35
	add 1,4
	move 4,b7
	lsh 4,25
	ash 4,-35
	add 1,4
	move 4,b7
	lsh 4,34
	ash 4,-35
	add 1,4
	popj 17,

b7_sum_unsigned:
	move 1,b7+1
	lsh 1,-35
	ldb 4,[POINT 7,b7+1,13]
	add 1,4
	ldb 4,[POINT 7,b7+1,20]
	add 1,4
	ldb 4,[POINT 7,b7+1,27]
	add 1,4
	ldb 4,[POINT 7,b7+1,34]
	add 1,4
	popj 17,

b7_sum_mixed:
	move 1,b7
	ash 1,-35
	move 4,b7+1
	lsh 4,-35
	add 1,4
	move 4,b7
	lsh 4,34
	ash 4,-35
	add 1,4
	ldb 4,[POINT 7,b7+1,34]
	add 1,4
	popj 17,

arg7_c0:
	ash 1,-35
	popj 17,

arg7_c4:
	lsh 1,34
	ash 1,-35
	popj 17,

arg7_u0:
	move 1,2
	lsh 1,-35
	popj 17,

arg7_u4:
	ldb 1,[POINT 7,2,34]
	popj 17,

arg7_sum:
	move 3,1
	ash 3,-35
	move 4,1
	lsh 4,7
	ash 4,-35
	add 3,4
	move 4,1
	lsh 4,16
	ash 4,-35
	add 3,4
	move 4,1
	lsh 4,25
	ash 4,-35
	add 3,4
	move 4,1
	lsh 4,34
	ash 4,-35
	add 3,4
	move 4,2
	lsh 4,-35
	add 3,4
	ldb 4,[POINT 7,2,13]
	add 3,4
	ldb 4,[POINT 7,2,20]
	add 3,4
	ldb 4,[POINT 7,2,27]
	add 3,4
	ldb 4,[POINT 7,2,34]
	add 3,4
	move 1,3
	popj 17,

ptr7_c0:
	move 1,(1)
	ash 1,-35
	popj 17,

ptr7_c4:
	move 1,(1)
	lsh 1,34
	ash 1,-35
	popj 17,

ptr7_u0:
	move 1,1(1)
	lsh 1,-35
	popj 17,

ptr7_u4:
	ldb 1,[POINT 7,1(1),34]
	popj 17,

ptr7_store_c0:
	dpb 2,[POINT 7,(1),6]
	popj 17,

ptr7_store_c4:
	dpb 2,[POINT 7,(1),34]
	popj 17,

ptr7_store_u0:
	dpb 2,[POINT 7,1(1),6]
	popj 17,

ptr7_store_u4:
	dpb 2,[POINT 7,1(1),34]
	popj 17,

b7a_load_c0:
	andi 1,7
	imuli 1,24
	move 4,[POINT 7,b7a,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	move 1,(4)
	popj 17,

b7a_load_c4:
	andi 1,7
	imuli 1,24
	move 4,[POINT 7,b7a,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	move 1,(4)
	lsh 1,34
	ash 1,-35
	popj 17,

b7a_load_u0:
	andi 1,7
	imuli 1,24
	move 4,[POINT 7,b7a,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	move 1,1(4)
	popj 17,

b7a_load_u4:
	andi 1,7
	imuli 1,24
	move 4,[POINT 7,b7a,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,[POINT 7,1(4),34]
	popj 17,

b7a_store_c0:
	andi 1,7
	imuli 1,24
	move 4,[POINT 7,b7a,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

b7a_store_c4:
	andi 1,7
	imuli 1,24
	move 4,[POINT 7,b7a,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

b7a_store_u0:
	andi 1,7
	imuli 1,24
	move 4,[POINT 7,b7a,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	addi 4,1
	dpb 2,4
	popj 17,

b7a_store_u4:
	andi 1,7
	imuli 1,24
	move 4,[POINT 7,b7a,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	addi 4,1
	dpb 2,4
	popj 17,

mb7_load_c0:
	move 1,mb7+1
	ash 1,-35
	popj 17,

mb7_load_u0:
	ldb 1,[POINT 7,mb7+1,13]
	popj 17,

mb7_load_c1:
	move 1,mb7+1
	lsh 1,16
	ash 1,-35
	popj 17,

mb7_load_u1:
	ldb 1,[POINT 7,mb7+1,27]
	popj 17,

mb7_load_c2:
	move 1,mb7+3
	ash 1,-35
	popj 17,

mb7_load_u2:
	ldb 1,[POINT 7,mb7+3,13]
	popj 17,

mb7_sum:
	move 1,mb7+1
	ash 1,-35
	add 1,mb7
	ldb 4,[POINT 7,mb7+1,13]
	add 1,4
	move 4,mb7+1
	lsh 4,16
	ash 4,-35
	add 1,4
	ldb 4,[POINT 7,mb7+1,27]
	add 1,4
	add 1,mb7+2
	move 4,mb7+3
	ash 4,-35
	add 1,4
	ldb 4,[POINT 7,mb7+3,13]
	add 1,4
	popj 17,

mb7_store_all:
	dpb 1,[POINT 7,mb7+1,6]
	addi 1,1
	dpb 1,[POINT 7,mb7+1,13]
	addi 1,1
	dpb 1,[POINT 7,mb7+1,20]
	addi 1,1
	dpb 1,[POINT 7,mb7+1,27]
	addi 1,1
	dpb 1,[POINT 7,mb7+3,6]
	addi 1,1
	dpb 1,[POINT 7,mb7+3,13]
	popj 17,

vload_s7:
	andi 1,17
	move 4,[POINT 7,vs7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

vload_u7:
	andi 1,17
	move 4,[POINT 7,vu7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	popj 17,

vstore_s7:
	andi 1,17
	move 4,[POINT 7,vs7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

vstore_u7:
	andi 1,17
	move 4,[POINT 7,vu7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

vload_s7_4:
	ldb 1,[POINT 9,vs7,8]
	lsh 1,34
	ash 1,-35
	popj 17,

vload_u7_4:
	ldb 1,[POINT 7,vu7,34]
	popj 17,

vstore_s7_4:
	dpb 1,[POINT 7,vs7,34]
	popj 17,

vstore_u7_4:
	dpb 1,[POINT 7,vu7,34]
	popj 17,

extend_char7:
	ldb 1,1
	trne 1,100
	orcmi 1,177
	popj 17,

extend_uchar7:
	ldb 1,1
	popj 17,

extend_char7_array:
	andi 1,17
	move 4,[POINT 7,s7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

extend_uchar7_array:
	andi 1,17
	move 4,[POINT 7,u7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	popj 17,

trunc_store_char7:
	dpb 2,1
	popj 17,

trunc_store_uchar7:
	dpb 2,1
	popj 17,

trunc_store_char7_return:
	dpb 2,1
	lsh 2,35
	ash 2,-35
	move 1,2
	popj 17,

trunc_store_uchar7_return:
	dpb 2,1
	andi 2,177
	move 1,2
	popj 17,

char7_plus:
	andi 1,17
	move 4,[POINT 7,s7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,100
	orcmi 1,177
	add 1,2
	popj 17,

uchar7_plus:
	andi 1,17
	move 4,[POINT 7,u7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	add 1,2
	popj 17,

char7_sub:
	andi 1,17
	move 4,[POINT 7,s7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,100
	orcmi 1,177
	sub 1,2
	popj 17,

uchar7_xor:
	andi 1,17
	move 4,[POINT 7,u7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	xor 1,2
	popj 17,

char7_eq_zero:
	andi 1,17
	move 4,[POINT 7,s7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	skipe 4
	tdza 1,1
	movei 1,1
	popj 17,

char7_lt_zero:
	andi 1,17
	move 4,[POINT 7,s7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,400
	orcmi 1,777
	lsh 1,-43
	popj 17,

uchar7_eq_zero:
	andi 1,17
	move 4,[POINT 7,u7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	skipe 4
	tdza 1,1
	movei 1,1
	popj 17,

uchar7_gt_63:
	andi 1,17
	move 4,[POINT 7,u7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	tlo 1,400000
	move 6,[-377777777701]
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

char7_range:
	andi 1,17
	move 4,[POINT 7,s7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	trne 4,100
	orcmi 4,177
	seto 1,
	camge 4,[-40]
	popj 17,
	movei 6,37
	camg 4,6
	tdza 1,1
	movei 1,1
	popj 17,

uchar7_range:
	andi 1,17
	move 4,[POINT 7,u7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	tlc 4,400000
	seto 1,
	camg 4,[-377777777741]
	popj 17,
	move 6,[-377777777641]
	camg 4,6
	tdza 1,1
	movei 1,1
	popj 17,

postinc_load_char7:
	ldb 1,1
	trne 1,100
	orcmi 1,177
	popj 17,

postinc_load_uchar7:
	ldb 1,1
	popj 17,

postinc_store_char7:
	dpb 2,1
	popj 17,

postinc_store_uchar7:
	dpb 2,1
	popj 17,

walk_sum_char7:
	movei 3,0
	caml 3,2
	jrst %L405
	subi 2,1
%L406:
	ldb 4,1
	trne 4,100
	orcmi 4,177
	add 3,4
	ibp 1
	sojge 2,%L406	; doloop_end
%L405:
	move 1,3
	popj 17,

walk_sum_uchar7:
	movei 3,0
	caml 3,2
	jrst %L414
	subi 2,1
%L415:
	ldb 4,1
	add 3,4
	ibp 1
	sojge 2,%L415	; doloop_end
%L414:
	move 1,3
	popj 17,

walk_zero_char7:
	jumple 2,%L423
	movei 4,0
	subi 2,1
%L424:
	dpb 4,1
	ibp 1
	sojge 2,%L424	; doloop_end
%L423:
	popj 17,

walk_zero_uchar7:
	jumple 2,%L432
	movei 4,0
	subi 2,1
%L433:
	dpb 4,1
	ibp 1
	sojge 2,%L433	; doloop_end
%L432:
	popj 17,

sum_char7_global:
	setzb 2,3
	caml 2,1
	jrst %L441
	move 6,[POINT 7,s7,6]
	subi 1,1
%L442:
	move 4,3
	andi 4,17
	move 7,6
	move 0,4
	jumple 0,.+3
	ibp 7
	sojg 0,.-1
	ldb 4,7
	trne 4,100
	orcmi 4,177
	add 2,4
	addi 3,1
	sojge 1,%L442	; doloop_end
%L441:
	move 1,2
	popj 17,

sum_uchar7_global:
	setzb 2,3
	caml 2,1
	jrst %L450
	move 6,[POINT 7,u7,6]
	subi 1,1
%L451:
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
	sojge 1,%L451	; doloop_end
%L450:
	move 1,2
	popj 17,

zero_char7_global:
	movei 3,0
	caml 3,1
	popj 17,
	movei 2,0
	subi 1,1
%L460:
	move 4,3
	andi 4,17
	move 6,[POINT 7,s7,6]
	move 0,4
	jumple 0,.+3
	ibp 6
	sojg 0,.-1
	dpb 2,6
	addi 3,1
	sojge 1,%L460	; doloop_end
	popj 17,

zero_uchar7_global:
	movei 3,0
	caml 3,1
	popj 17,
	movei 2,0
	subi 1,1
%L469:
	move 4,3
	andi 4,17
	move 6,[POINT 7,u7,6]
	move 0,4
	jumple 0,.+3
	ibp 6
	sojg 0,.-1
	dpb 2,6
	addi 3,1
	sojge 1,%L469	; doloop_end
	popj 17,

set_char7_index_global:
	movei 3,0
	caml 3,1
	popj 17,
	subi 1,1
%L478:
	move 4,3
	andi 4,17
	move 6,[POINT 7,s7,6]
	move 0,4
	jumple 0,.+3
	ibp 6
	sojg 0,.-1
	dpb 3,6
	addi 3,1
	sojge 1,%L478	; doloop_end
	popj 17,

set_uchar7_index_global:
	movei 3,0
	caml 3,1
	popj 17,
	subi 1,1
%L487:
	move 4,3
	andi 4,17
	move 6,[POINT 7,u7,6]
	move 0,4
	jumple 0,.+3
	ibp 6
	sojg 0,.-1
	dpb 3,6
	addi 3,1
	sojge 1,%L487	; doloop_end
	popj 17,

copy_char7_global:
	push 17,10
	setzb 7,6
	caml 7,1
	jrst %L495
	move 5,[POINT 7,s7,6]
	subi 1,1
%L496:
	addi 6,17
	move 2,6
	andi 2,35
	subi 6,17
	move 3,[POINT 7,s7,6]
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
	trne 4,100
	orcmi 4,177
	add 7,4
	addi 6,1
	sojge 1,%L496	; doloop_end
%L495:
	move 1,7
	pop 17,10
	popj 17,

copy_uchar7_global:
	push 17,10
	setzb 7,6
	caml 7,1
	jrst %L504
	move 5,[POINT 7,u7,6]
	subi 1,1
%L505:
	addi 6,17
	move 2,6
	andi 2,35
	subi 6,17
	move 3,[POINT 7,u7,6]
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
	sojge 1,%L505	; doloop_end
%L504:
	move 1,7
	pop 17,10
	popj 17,

sum_b7a_signed:
	setzb 6,2
	caml 6,1
	jrst %L513
	move 7,[POINT 7,b7a,6]
	subi 1,1
%L514:
	move 4,2
	andi 4,7
	imuli 4,24
	move 3,7
	move 0,4
	jumple 0,.+3
	ibp 3
	sojg 0,.-1
	move 4,(3)
	lsh 4,34
	ash 4,-35
	add 4,(3)
	add 6,4
	addi 2,1
	sojge 1,%L514	; doloop_end
%L513:
	move 1,6
	popj 17,

sum_b7a_unsigned:
	setzb 6,2
	caml 6,1
	jrst %L522
	move 7,[POINT 7,b7a,6]
	subi 1,1
%L523:
	move 4,2
	andi 4,7
	imuli 4,24
	move 3,7
	move 0,4
	jumple 0,.+3
	ibp 3
	sojg 0,.-1
	ldb 4,[POINT 7,1(3),34]
	add 4,1(3)
	add 6,4
	addi 2,1
	sojge 1,%L523	; doloop_end
%L522:
	move 1,6
	popj 17,

zero_b7a_signed:
	movei 2,0
	caml 2,1
	popj 17,
	movei 3,0
	subi 1,1
%L532:
	move 4,2
	andi 4,7
	imuli 4,24
	move 6,[POINT 7,b7a,6]
	move 0,4
	jumple 0,.+3
	ibp 6
	sojg 0,.-1
	dpb 3,6
	addi 2,1
	sojge 1,%L532	; doloop_end
	popj 17,

zero_b7a_unsigned:
	movei 2,0
	caml 2,1
	popj 17,
	movei 3,0
	subi 1,1
%L541:
	move 4,2
	andi 4,7
	imuli 4,24
	move 6,[POINT 7,b7a,6]
	move 0,4
	jumple 0,.+3
	ibp 6
	sojg 0,.-1
	move 4,6
	addi 4,1
	dpb 3,4
	addi 2,1
	sojge 1,%L541	; doloop_end
	popj 17,

copy_b7a:
	movei 4,0
	caml 4,1
	popj 17,
	move 6,[POINT 7,b7a,6]
	subi 1,1
%L550:
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
	movem 7,b7a+pdp10.c:7954:TOOBIG:(3)
	move 4,1(4)
	movem 4,b7a+pdp10.c:7954:TOOBIG:1(3)
	move 4,2
	sojge 1,%L550	; doloop_end
	popj 17,

load_char7_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	andi 10,17
	move 4,[POINT 7,s7,6]
	move 0,10
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,100
	orcmi 1,177
	pop 17,10
	popj 17,

load_uchar7_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	andi 10,17
	move 4,[POINT 7,u7,6]
	move 0,10
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	pop 17,10
	popj 17,

store_char7_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	pushj 17,clobber
	andi 10,17
	move 4,[POINT 7,s7,6]
	move 0,10
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 11,4
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

store_uchar7_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	pushj 17,clobber
	andi 10,17
	move 4,[POINT 7,u7,6]
	move 0,10
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 11,4
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

load_char7_call_index:
	pushj 17,f
	andi 1,17
	move 4,[POINT 7,s7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

load_uchar7_call_index:
	pushj 17,f
	andi 1,17
	move 4,[POINT 7,u7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	popj 17,

store_char7_call_index:
	push 17,10
	move 10,1
	pushj 17,f
	andi 1,17
	move 4,[POINT 7,s7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 10,4
	pop 17,10
	popj 17,

store_uchar7_call_index:
	push 17,10
	move 10,1
	pushj 17,f
	andi 1,17
	move 4,[POINT 7,u7,6]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 10,4
	pop 17,10
	popj 17,

add_char7_pointer:
	jumple 2,%L562
%L561:
	ibp 1
	sojg 2,%L561	; decrement_and_branch_until_zero
%L562:
	jumpe 2,%L564
%L563:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L563
%L564:
	popj 17,

add_uchar7_pointer:
	jumple 2,%L568
%L567:
	ibp 1
	sojg 2,%L567	; decrement_and_branch_until_zero
%L568:
	jumpe 2,%L570
%L569:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L569
%L570:
	popj 17,

sub_char7_pointer:
	movn 2,2
	jumple 2,%L574
%L573:
	ibp 1
	sojg 2,%L573	; decrement_and_branch_until_zero
%L574:
	jumpe 2,%L576
%L575:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L575
%L576:
	popj 17,

sub_uchar7_pointer:
	movn 2,2
	jumple 2,%L580
%L579:
	ibp 1
	sojg 2,%L579	; decrement_and_branch_until_zero
%L580:
	jumpe 2,%L582
%L581:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L581
%L582:
	popj 17,

add_char7_pointer_const_1:
	ibp 1
	popj 17,

add_char7_pointer_const_4:
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

add_char7_pointer_const_5:
	addi 1,1
	popj 17,

add_char7_pointer_const_6:
	addi 1,1
	ibp 1
	popj 17,

add_uchar7_pointer_const_1:
	ibp 1
	popj 17,

add_uchar7_pointer_const_4:
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	popj 17,

add_uchar7_pointer_const_5:
	addi 1,1
	popj 17,

add_uchar7_pointer_const_6:
	addi 1,1
	ibp 1
	popj 17,

use_byte7_more:
	add 17,[6,,6]
	movei 0,-5(17)
	hrli 0,10
	blt 0,(17)
	move 12,1
	move 11,2
	pushj 17,store_char7_index
	move 10,11
	addi 10,1
	move 1,12
	move 2,10
	pushj 17,store_char7_index_plus_1
	move 13,11
	addi 13,4
	move 1,12
	move 2,13
	pushj 17,store_uchar7_index_plus_4
	move 1,11
	pushj 17,b7_store_c0
	move 1,10
	pushj 17,b7_store_c1
	move 15,11
	addi 15,2
	move 1,15
	pushj 17,b7_store_c2
	move 14,11
	addi 14,3
	move 1,14
	pushj 17,b7_store_c3
	move 1,13
	pushj 17,b7_store_c4
	move 1,11
	pushj 17,b7_store_u0
	move 1,10
	pushj 17,b7_store_u1
	move 1,15
	pushj 17,b7_store_u2
	move 1,14
	pushj 17,b7_store_u3
	move 1,13
	pushj 17,b7_store_u4
	move 1,12
	pushj 17,load_char7_masked
	move 10,1
	move 1,12
	pushj 17,load_uchar7_masked
	add 10,1
	pushj 17,load_char7_const_cross
	add 10,1
	pushj 17,b7_sum_signed
	add 10,1
	pushj 17,b7_sum_unsigned
	add 10,1
	move 1,12
	move 2,11
	pushj 17,char7_plus
	add 10,1
	move 1,12
	move 2,11
	pushj 17,uchar7_plus
	add 10,1
	move 1,12
	pushj 17,char7_range
	add 10,1
	move 1,12
	pushj 17,uchar7_range
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-5(17)
	blt 0,15
	add 17,[-6,,-6]
	popj 17,

	.bss
s7:
	.space	32
u7:
	.space	32
vs7:
	.space	32
vu7:
	.space	32
b7:
	.space	8
sb7:
	.space	4
ub7:
	.space	4
mb7:
	.space	16
b7a:
	.space	64
sb7a:
	.space	32
ub7a:
	.space	32
mb7a:
	.space	128
