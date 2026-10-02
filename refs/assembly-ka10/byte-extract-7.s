
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
	jumple 1,%L13
%L12:
	ibp 4
	sojg 1,%L12	; decrement_and_branch_until_zero
%L13:
	jumpe 1,%L15
%L14:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L14
%L15:
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

load_uchar7_index:
	move 4,[POINT 7,u7,6]
	jumple 1,%L18
%L17:
	ibp 4
	sojg 1,%L17	; decrement_and_branch_until_zero
%L18:
	jumpe 1,%L20
%L19:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L19
%L20:
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
	move 3,[POINT 7,s7,6]
	move 4,1
	jumple 1,%L24
%L23:
	ibp 3
	sojg 4,%L23	; decrement_and_branch_until_zero
%L24:
	jumpe 4,%L26
%L25:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L25
%L26:
	dpb 2,3
	move 3,[POINT 7,u7,6]
	skipg 4,1
	jrst %L28
%L27:
	ibp 3
	sojg 4,%L27	; decrement_and_branch_until_zero
%L28:
	jumpe 4,%L30
%L29:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L29
%L30:
	addi 2,1
	dpb 2,3
	popj 17,

copy_char7:
	push 17,10
	move 10,1
	setzb 1,5
	caml 1,3
	jrst %L53
	subi 3,1
%L54:
	move 7,10
	move 4,5
	jumple 5,%L38
%L37:
	ibp 7
	sojg 4,%L37	; decrement_and_branch_until_zero
%L38:
	jumpe 4,%L40
%L39:
	subi 7,1
	ibp 7
	ibp 7
	ibp 7
	ibp 7
	aojl 4,%L39
%L40:
	move 4,2
	move 6,5
	jumple 5,%L43
%L42:
	ibp 4
	sojg 6,%L42	; decrement_and_branch_until_zero
%L43:
	jumpe 6,%L45
%L44:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 6,%L44
%L45:
	ldb 4,4
	dpb 4,7
	move 4,10
	move 6,5
	jumple 5,%L48
%L47:
	ibp 4
	sojg 6,%L47	; decrement_and_branch_until_zero
%L48:
	jumpe 6,%L50
%L49:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 6,%L49
%L50:
	ldb 4,4
	trne 4,100
	orcmi 4,177
	add 1,4
	addi 5,1
	sojge 3,%L54	; doloop_end
%L53:
	pop 17,10
	popj 17,

copy_uchar7:
	push 17,10
	move 10,1
	setzb 1,5
	caml 1,3
	jrst %L77
	subi 3,1
%L78:
	move 7,10
	move 4,5
	jumple 5,%L62
%L61:
	ibp 7
	sojg 4,%L61	; decrement_and_branch_until_zero
%L62:
	jumpe 4,%L64
%L63:
	subi 7,1
	ibp 7
	ibp 7
	ibp 7
	ibp 7
	aojl 4,%L63
%L64:
	move 4,2
	move 6,5
	jumple 5,%L67
%L66:
	ibp 4
	sojg 6,%L66	; decrement_and_branch_until_zero
%L67:
	jumpe 6,%L69
%L68:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 6,%L68
%L69:
	ldb 4,4
	dpb 4,7
	move 4,10
	move 6,5
	jumple 5,%L72
%L71:
	ibp 4
	sojg 6,%L71	; decrement_and_branch_until_zero
%L72:
	jumpe 6,%L74
%L73:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 6,%L73
%L74:
	ldb 4,4
	add 1,4
	addi 5,1
	sojge 3,%L78	; doloop_end
%L77:
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
	move 4,[POINT 7,s7,6]
	andi 1,17
	jumple 1,%L126
%L125:
	ibp 4
	sojg 1,%L125	; decrement_and_branch_until_zero
%L126:
	jumpe 1,%L128
%L127:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L127
%L128:
	dpb 2,4
	lsh 2,35
	ash 2,-35
	move 1,2
	popj 17,

store_u7_return:
	move 4,[POINT 7,u7,6]
	andi 1,17
	jumple 1,%L131
%L130:
	ibp 4
	sojg 1,%L130	; decrement_and_branch_until_zero
%L131:
	jumpe 1,%L133
%L132:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L132
%L133:
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
	ldb 1,[POINT 7,s7,34]
	trne 1,100
	orcmi 1,177
	popj 17,

load_s7_ptr_5:
	ldb 1,[POINT 7,s7+1,6]
	trne 1,100
	orcmi 1,177
	popj 17,

load_s7_ptr_9:
	ldb 1,[POINT 7,s7+1,34]
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
	ldb 1,[POINT 7,u7,34]
	popj 17,

load_u7_ptr_5:
	ldb 1,[POINT 7,u7+1,6]
	popj 17,

load_u7_ptr_9:
	ldb 1,[POINT 7,u7+1,34]
	popj 17,

load_u7_ptr_10:
	ldb 1,[POINT 7,u7+2,6]
	popj 17,

store_s7_ptr_0:
	dpb 1,[POINT 7,s7,6]
	popj 17,

store_s7_ptr_4:
	dpb 1,[POINT 7,s7,34]
	popj 17,

store_s7_ptr_5:
	dpb 1,[POINT 7,s7+1,6]
	popj 17,

store_u7_ptr_0:
	dpb 1,[POINT 7,u7,6]
	popj 17,

store_u7_ptr_4:
	dpb 1,[POINT 7,u7,34]
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
	ldb 1,[POINT 7,b7,13]
	trne 1,100
	orcmi 1,177
	popj 17,

load_b7p_c2:
	ldb 1,[POINT 7,b7,20]
	trne 1,100
	orcmi 1,177
	popj 17,

load_b7p_c3:
	ldb 1,[POINT 7,b7,27]
	trne 1,100
	orcmi 1,177
	popj 17,

load_b7p_c4:
	ldb 1,[POINT 7,b7,34]
	trne 1,100
	orcmi 1,177
	popj 17,

load_b7p_u0:
	add 17,[1,,1]
	move 4,b7+1
	lsh 4,-35
	movem 4,(17)
	movei 4,(17)
	tlo 4,2200
	ldb 1,4
	add 17,[-1,,-1]
	popj 17,

load_b7p_u1:
	ldb 1,[POINT 7,b7+1,13]
	popj 17,

load_b7p_u2:
	ldb 1,[POINT 7,b7+1,20]
	popj 17,

load_b7p_u3:
	ldb 1,[POINT 7,b7+1,27]
	popj 17,

load_b7p_u4:
	ldb 1,[POINT 7,b7+1,34]
	popj 17,

store_b7p_c0:
	dpb 1,[POINT 7,b7,6]
	popj 17,

store_b7p_c1:
	dpb 1,[POINT 7,b7,13]
	popj 17,

store_b7p_c2:
	dpb 1,[POINT 7,b7,20]
	popj 17,

store_b7p_c3:
	dpb 1,[POINT 7,b7,27]
	popj 17,

store_b7p_c4:
	dpb 1,[POINT 7,b7,34]
	popj 17,

store_b7p_u0:
	add 17,[1,,1]
	movei 4,(17)
	tlo 4,2200
	dpb 1,4
	add 17,[-1,,-1]
	popj 17,

store_b7p_u1:
	dpb 1,[POINT 7,b7+1,13]
	popj 17,

store_b7p_u2:
	dpb 1,[POINT 7,b7+1,20]
	popj 17,

store_b7p_u3:
	dpb 1,[POINT 7,b7+1,27]
	popj 17,

store_b7p_u4:
	dpb 1,[POINT 7,b7+1,34]
	popj 17,

load_char7_masked:
	move 4,[POINT 7,s7,6]
	andi 1,17
	jumple 1,%L192
%L191:
	ibp 4
	sojg 1,%L191	; decrement_and_branch_until_zero
%L192:
	jumpe 1,%L194
%L193:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L193
%L194:
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

load_uchar7_masked:
	move 4,[POINT 7,u7,6]
	andi 1,17
	jumple 1,%L197
%L196:
	ibp 4
	sojg 1,%L196	; decrement_and_branch_until_zero
%L197:
	jumpe 1,%L199
%L198:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L198
%L199:
	ldb 1,4
	popj 17,

load_char7_pointer:
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
	ldb 1,1
	trne 1,100
	orcmi 1,177
	popj 17,

load_uchar7_pointer:
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
	popj 17,

store_char7_pointer:
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
	dpb 3,1
	popj 17,

store_uchar7_pointer:
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

load_char7_index_plus_1:
	addi 1,1
	move 4,[POINT 7,s7,6]
	andi 1,17
	jumple 1,%L226
%L225:
	ibp 4
	sojg 1,%L225	; decrement_and_branch_until_zero
%L226:
	jumpe 1,%L228
%L227:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L227
%L228:
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

load_char7_index_plus_4:
	addi 1,4
	move 4,[POINT 7,s7,6]
	andi 1,17
	jumple 1,%L231
%L230:
	ibp 4
	sojg 1,%L230	; decrement_and_branch_until_zero
%L231:
	jumpe 1,%L233
%L232:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L232
%L233:
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

load_char7_index_plus_5:
	addi 1,5
	move 4,[POINT 7,s7,6]
	andi 1,17
	jumple 1,%L236
%L235:
	ibp 4
	sojg 1,%L235	; decrement_and_branch_until_zero
%L236:
	jumpe 1,%L238
%L237:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L237
%L238:
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

load_char7_index_minus_1:
	subi 1,1
	move 4,[POINT 7,s7,6]
	andi 1,17
	jumple 1,%L241
%L240:
	ibp 4
	sojg 1,%L240	; decrement_and_branch_until_zero
%L241:
	jumpe 1,%L243
%L242:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L242
%L243:
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

load_uchar7_index_plus_1:
	addi 1,1
	move 4,[POINT 7,u7,6]
	andi 1,17
	jumple 1,%L246
%L245:
	ibp 4
	sojg 1,%L245	; decrement_and_branch_until_zero
%L246:
	jumpe 1,%L248
%L247:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L247
%L248:
	ldb 1,4
	popj 17,

load_uchar7_index_plus_4:
	addi 1,4
	move 4,[POINT 7,u7,6]
	andi 1,17
	jumple 1,%L251
%L250:
	ibp 4
	sojg 1,%L250	; decrement_and_branch_until_zero
%L251:
	jumpe 1,%L253
%L252:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L252
%L253:
	ldb 1,4
	popj 17,

load_uchar7_index_plus_5:
	addi 1,5
	move 4,[POINT 7,u7,6]
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
	ldb 1,4
	popj 17,

load_uchar7_index_minus_1:
	subi 1,1
	move 4,[POINT 7,u7,6]
	andi 1,17
	jumple 1,%L261
%L260:
	ibp 4
	sojg 1,%L260	; decrement_and_branch_until_zero
%L261:
	jumpe 1,%L263
%L262:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L262
%L263:
	ldb 1,4
	popj 17,

store_char7_index_plus_1:
	addi 1,1
	move 4,[POINT 7,s7,6]
	andi 1,17
	jumple 1,%L266
%L265:
	ibp 4
	sojg 1,%L265	; decrement_and_branch_until_zero
%L266:
	jumpe 1,%L268
%L267:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L267
%L268:
	dpb 2,4
	popj 17,

store_char7_index_plus_4:
	addi 1,4
	move 4,[POINT 7,s7,6]
	andi 1,17
	jumple 1,%L271
%L270:
	ibp 4
	sojg 1,%L270	; decrement_and_branch_until_zero
%L271:
	jumpe 1,%L273
%L272:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L272
%L273:
	dpb 2,4
	popj 17,

store_char7_index_plus_5:
	addi 1,5
	move 4,[POINT 7,s7,6]
	andi 1,17
	jumple 1,%L276
%L275:
	ibp 4
	sojg 1,%L275	; decrement_and_branch_until_zero
%L276:
	jumpe 1,%L278
%L277:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L277
%L278:
	dpb 2,4
	popj 17,

store_char7_index_minus_1:
	subi 1,1
	move 4,[POINT 7,s7,6]
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
	aojl 1,%L282
%L283:
	dpb 2,4
	popj 17,

store_uchar7_index_plus_1:
	addi 1,1
	move 4,[POINT 7,u7,6]
	andi 1,17
	jumple 1,%L286
%L285:
	ibp 4
	sojg 1,%L285	; decrement_and_branch_until_zero
%L286:
	jumpe 1,%L288
%L287:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L287
%L288:
	dpb 2,4
	popj 17,

store_uchar7_index_plus_4:
	addi 1,4
	move 4,[POINT 7,u7,6]
	andi 1,17
	jumple 1,%L291
%L290:
	ibp 4
	sojg 1,%L290	; decrement_and_branch_until_zero
%L291:
	jumpe 1,%L293
%L292:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L292
%L293:
	dpb 2,4
	popj 17,

store_uchar7_index_plus_5:
	addi 1,5
	move 4,[POINT 7,u7,6]
	andi 1,17
	jumple 1,%L296
%L295:
	ibp 4
	sojg 1,%L295	; decrement_and_branch_until_zero
%L296:
	jumpe 1,%L298
%L297:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L297
%L298:
	dpb 2,4
	popj 17,

store_uchar7_index_minus_1:
	subi 1,1
	move 4,[POINT 7,u7,6]
	andi 1,17
	jumple 1,%L301
%L300:
	ibp 4
	sojg 1,%L300	; decrement_and_branch_until_zero
%L301:
	jumpe 1,%L303
%L302:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L302
%L303:
	dpb 2,4
	popj 17,

addr_s7_0:
	move 1,[POINT 7,s7,6]
	popj 17,

addr_s7_4:
	move 1,[POINT 7,s7,34]
	popj 17,

addr_s7_5:
	move 1,[POINT 7,s7+1,6]
	popj 17,

addr_s7_index:
	move 4,[POINT 7,s7,6]
	andi 1,17
	jumple 1,%L314
%L313:
	ibp 4
	sojg 1,%L313	; decrement_and_branch_until_zero
%L314:
	jumpe 1,%L316
%L315:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L315
%L316:
	move 1,4
	popj 17,

addr_u7_0:
	move 1,[POINT 7,u7,6]
	popj 17,

addr_u7_4:
	move 1,[POINT 7,u7,34]
	popj 17,

addr_u7_5:
	move 1,[POINT 7,u7+1,6]
	popj 17,

addr_u7_index:
	move 4,[POINT 7,u7,6]
	andi 1,17
	jumple 1,%L327
%L326:
	ibp 4
	sojg 1,%L326	; decrement_and_branch_until_zero
%L327:
	jumpe 1,%L329
%L328:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L328
%L329:
	move 1,4
	popj 17,

addr_b7_c0:
	move 1,[POINT 7,b7,6]
	popj 17,

addr_b7_c4:
	move 1,[POINT 7,b7,34]
	popj 17,

addr_b7_u0:
	add 17,[1,,1]
	movei 1,(17)
	tlo 1,2200
	add 17,[-1,,-1]
	popj 17,

addr_b7_u4:
	move 1,[POINT 7,b7+1,34]
	popj 17,

addr_load_s7:
	move 4,[POINT 7,s7,6]
	andi 1,17
	jumple 1,%L339
%L338:
	ibp 4
	sojg 1,%L338	; decrement_and_branch_until_zero
%L339:
	jumpe 1,%L341
%L340:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L340
%L341:
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

addr_load_u7:
	move 4,[POINT 7,u7,6]
	andi 1,17
	jumple 1,%L346
%L345:
	ibp 4
	sojg 1,%L345	; decrement_and_branch_until_zero
%L346:
	jumpe 1,%L348
%L347:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L347
%L348:
	ldb 1,4
	popj 17,

addr_store_s7:
	move 4,[POINT 7,s7,6]
	andi 1,17
	jumple 1,%L353
%L352:
	ibp 4
	sojg 1,%L352	; decrement_and_branch_until_zero
%L353:
	jumpe 1,%L355
%L354:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L354
%L355:
	dpb 2,4
	popj 17,

addr_store_u7:
	move 4,[POINT 7,u7,6]
	andi 1,17
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
	move 4,[POINT 7,b7a,6]
	imuli 1,24
	jumple 1,%L401
%L400:
	ibp 4
	sojg 1,%L400	; decrement_and_branch_until_zero
%L401:
	jumpe 1,%L403
%L402:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L402
%L403:
	move 1,(4)
	popj 17,

b7a_load_c4:
	andi 1,7
	move 4,[POINT 7,b7a,6]
	imuli 1,24
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
	aojl 1,%L407
%L408:
	move 1,(4)
	lsh 1,34
	ash 1,-35
	popj 17,

b7a_load_u0:
	andi 1,7
	move 4,[POINT 7,b7a,6]
	imuli 1,24
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
	aojl 1,%L412
%L413:
	move 1,1(4)
	popj 17,

b7a_load_u4:
	andi 1,7
	move 4,[POINT 7,b7a,6]
	imuli 1,24
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
	aojl 1,%L417
%L418:
	ldb 1,[POINT 7,1(4),34]
	popj 17,

b7a_store_c0:
	andi 1,7
	move 4,[POINT 7,b7a,6]
	imuli 1,24
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
	aojl 1,%L422
%L423:
	dpb 2,4
	popj 17,

b7a_store_c4:
	andi 1,7
	move 4,[POINT 7,b7a,6]
	imuli 1,24
	jumple 1,%L426
%L425:
	ibp 4
	sojg 1,%L425	; decrement_and_branch_until_zero
%L426:
	jumpe 1,%L428
%L427:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L427
%L428:
	dpb 2,4
	popj 17,

b7a_store_u0:
	andi 1,7
	move 4,[POINT 7,b7a,6]
	imuli 1,24
	jumple 1,%L431
%L430:
	ibp 4
	sojg 1,%L430	; decrement_and_branch_until_zero
%L431:
	jumpe 1,%L433
%L432:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L432
%L433:
	addi 4,1
	dpb 2,4
	popj 17,

b7a_store_u4:
	andi 1,7
	move 4,[POINT 7,b7a,6]
	imuli 1,24
	jumple 1,%L436
%L435:
	ibp 4
	sojg 1,%L435	; decrement_and_branch_until_zero
%L436:
	jumpe 1,%L438
%L437:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L437
%L438:
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
	move 4,[POINT 7,vs7,6]
	andi 1,17
	jumple 1,%L449
%L448:
	ibp 4
	sojg 1,%L448	; decrement_and_branch_until_zero
%L449:
	jumpe 1,%L451
%L450:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L450
%L451:
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

vload_u7:
	move 4,[POINT 7,vu7,6]
	andi 1,17
	jumple 1,%L454
%L453:
	ibp 4
	sojg 1,%L453	; decrement_and_branch_until_zero
%L454:
	jumpe 1,%L456
%L455:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L455
%L456:
	ldb 1,4
	popj 17,

vstore_s7:
	move 4,[POINT 7,vs7,6]
	andi 1,17
	jumple 1,%L459
%L458:
	ibp 4
	sojg 1,%L458	; decrement_and_branch_until_zero
%L459:
	jumpe 1,%L461
%L460:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L460
%L461:
	dpb 2,4
	popj 17,

vstore_u7:
	move 4,[POINT 7,vu7,6]
	andi 1,17
	jumple 1,%L464
%L463:
	ibp 4
	sojg 1,%L463	; decrement_and_branch_until_zero
%L464:
	jumpe 1,%L466
%L465:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L465
%L466:
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
	move 4,[POINT 7,s7,6]
	andi 1,17
	jumple 1,%L475
%L474:
	ibp 4
	sojg 1,%L474	; decrement_and_branch_until_zero
%L475:
	jumpe 1,%L477
%L476:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L476
%L477:
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

extend_uchar7_array:
	move 4,[POINT 7,u7,6]
	andi 1,17
	jumple 1,%L480
%L479:
	ibp 4
	sojg 1,%L479	; decrement_and_branch_until_zero
%L480:
	jumpe 1,%L482
%L481:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L481
%L482:
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
	move 4,[POINT 7,s7,6]
	andi 1,17
	jumple 1,%L489
%L488:
	ibp 4
	sojg 1,%L488	; decrement_and_branch_until_zero
%L489:
	jumpe 1,%L491
%L490:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L490
%L491:
	ldb 1,4
	trne 1,100
	orcmi 1,177
	add 1,2
	popj 17,

uchar7_plus:
	move 4,[POINT 7,u7,6]
	andi 1,17
	jumple 1,%L494
%L493:
	ibp 4
	sojg 1,%L493	; decrement_and_branch_until_zero
%L494:
	jumpe 1,%L496
%L495:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L495
%L496:
	ldb 1,4
	add 1,2
	popj 17,

char7_sub:
	move 4,[POINT 7,s7,6]
	andi 1,17
	jumple 1,%L499
%L498:
	ibp 4
	sojg 1,%L498	; decrement_and_branch_until_zero
%L499:
	jumpe 1,%L501
%L500:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L500
%L501:
	ldb 1,4
	trne 1,100
	orcmi 1,177
	sub 1,2
	popj 17,

uchar7_xor:
	move 4,[POINT 7,u7,6]
	andi 1,17
	jumple 1,%L504
%L503:
	ibp 4
	sojg 1,%L503	; decrement_and_branch_until_zero
%L504:
	jumpe 1,%L506
%L505:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L505
%L506:
	ldb 1,4
	xor 1,2
	popj 17,

char7_eq_zero:
	move 4,[POINT 7,s7,6]
	andi 1,17
	jumple 1,%L509
%L508:
	ibp 4
	sojg 1,%L508	; decrement_and_branch_until_zero
%L509:
	jumpe 1,%L511
%L510:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L510
%L511:
	ldb 4,4
	skipe 4
	tdza 1,1
	movei 1,1
	popj 17,

char7_lt_zero:
	move 4,[POINT 7,s7,6]
	andi 1,17
	jumple 1,%L514
%L513:
	ibp 4
	sojg 1,%L513	; decrement_and_branch_until_zero
%L514:
	jumpe 1,%L516
%L515:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L515
%L516:
	ldb 1,4
	trne 1,400
	orcmi 1,777
	lsh 1,-43
	popj 17,

uchar7_eq_zero:
	move 4,[POINT 7,u7,6]
	andi 1,17
	jumple 1,%L519
%L518:
	ibp 4
	sojg 1,%L518	; decrement_and_branch_until_zero
%L519:
	jumpe 1,%L521
%L520:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L520
%L521:
	ldb 4,4
	skipe 4
	tdza 1,1
	movei 1,1
	popj 17,

uchar7_gt_63:
	move 4,[POINT 7,u7,6]
	andi 1,17
	jumple 1,%L524
%L523:
	ibp 4
	sojg 1,%L523	; decrement_and_branch_until_zero
%L524:
	jumpe 1,%L526
%L525:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L525
%L526:
	ldb 1,4
	tlo 1,400000
	move 6,[-377777777701]
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

char7_range:
	move 4,[POINT 7,s7,6]
	andi 1,17
	jumple 1,%L529
%L528:
	ibp 4
	sojg 1,%L528	; decrement_and_branch_until_zero
%L529:
	jumpe 1,%L531
%L530:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L530
%L531:
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
	move 4,[POINT 7,u7,6]
	andi 1,17
	jumple 1,%L536
%L535:
	ibp 4
	sojg 1,%L535	; decrement_and_branch_until_zero
%L536:
	jumpe 1,%L538
%L537:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L537
%L538:
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
	jrst %L552
	subi 2,1
%L553:
	ldb 4,1
	trne 4,100
	orcmi 4,177
	add 3,4
	ibp 1
	sojge 2,%L553	; doloop_end
%L552:
	move 1,3
	popj 17,

walk_sum_uchar7:
	movei 3,0
	caml 3,2
	jrst %L561
	subi 2,1
%L562:
	ldb 4,1
	add 3,4
	ibp 1
	sojge 2,%L562	; doloop_end
%L561:
	move 1,3
	popj 17,

walk_zero_char7:
	jumple 2,%L570
	movei 4,0
	subi 2,1
%L571:
	dpb 4,1
	ibp 1
	sojge 2,%L571	; doloop_end
%L570:
	popj 17,

walk_zero_uchar7:
	jumple 2,%L579
	movei 4,0
	subi 2,1
%L580:
	dpb 4,1
	ibp 1
	sojge 2,%L580	; doloop_end
%L579:
	popj 17,

sum_char7_global:
	setzb 6,2
	caml 6,1
	jrst %L592
	subi 1,1
%L593:
	move 3,[POINT 7,s7,6]
	move 4,2
	andi 4,17
	jumple 4,%L587
%L586:
	ibp 3
	sojg 4,%L586	; decrement_and_branch_until_zero
%L587:
	jumpe 4,%L589
%L588:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L588
%L589:
	ldb 4,3
	trne 4,100
	orcmi 4,177
	add 6,4
	addi 2,1
	sojge 1,%L593	; doloop_end
%L592:
	move 1,6
	popj 17,

sum_uchar7_global:
	setzb 6,2
	caml 6,1
	jrst %L605
	subi 1,1
%L606:
	move 3,[POINT 7,u7,6]
	move 4,2
	andi 4,17
	jumple 4,%L600
%L599:
	ibp 3
	sojg 4,%L599	; decrement_and_branch_until_zero
%L600:
	jumpe 4,%L602
%L601:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L601
%L602:
	ldb 4,3
	add 6,4
	addi 2,1
	sojge 1,%L606	; doloop_end
%L605:
	move 1,6
	popj 17,

zero_char7_global:
	movei 2,0
	caml 2,1
	popj 17,
	movei 6,0
	subi 1,1
%L619:
	move 3,[POINT 7,s7,6]
	move 4,2
	andi 4,17
	jumple 4,%L613
%L612:
	ibp 3
	sojg 4,%L612	; decrement_and_branch_until_zero
%L613:
	jumpe 4,%L615
%L614:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L614
%L615:
	dpb 6,3
	addi 2,1
	sojge 1,%L619	; doloop_end
	popj 17,

zero_uchar7_global:
	movei 2,0
	caml 2,1
	popj 17,
	movei 6,0
	subi 1,1
%L632:
	move 3,[POINT 7,u7,6]
	move 4,2
	andi 4,17
	jumple 4,%L626
%L625:
	ibp 3
	sojg 4,%L625	; decrement_and_branch_until_zero
%L626:
	jumpe 4,%L628
%L627:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L627
%L628:
	dpb 6,3
	addi 2,1
	sojge 1,%L632	; doloop_end
	popj 17,

set_char7_index_global:
	movei 2,0
	caml 2,1
	popj 17,
	subi 1,1
%L645:
	move 3,[POINT 7,s7,6]
	move 4,2
	andi 4,17
	jumple 4,%L639
%L638:
	ibp 3
	sojg 4,%L638	; decrement_and_branch_until_zero
%L639:
	jumpe 4,%L641
%L640:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L640
%L641:
	dpb 2,3
	addi 2,1
	sojge 1,%L645	; doloop_end
	popj 17,

set_uchar7_index_global:
	movei 2,0
	caml 2,1
	popj 17,
	subi 1,1
%L658:
	move 3,[POINT 7,u7,6]
	move 4,2
	andi 4,17
	jumple 4,%L652
%L651:
	ibp 3
	sojg 4,%L651	; decrement_and_branch_until_zero
%L652:
	jumpe 4,%L654
%L653:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L653
%L654:
	dpb 2,3
	addi 2,1
	sojge 1,%L658	; doloop_end
	popj 17,

copy_char7_global:
	setzb 5,7
	caml 5,1
	jrst %L678
	subi 1,1
%L679:
	move 6,7
	addi 6,17
	move 2,[POINT 7,s7,6]
	move 4,6
	andi 4,35
	jumple 4,%L665
%L664:
	ibp 2
	sojg 4,%L664	; decrement_and_branch_until_zero
%L665:
	jumpe 4,%L667
%L666:
	subi 2,1
	ibp 2
	ibp 2
	ibp 2
	ibp 2
	aojl 4,%L666
%L667:
	move 4,[POINT 7,s7,6]
	move 3,7
	andi 3,17
	jumple 3,%L669
%L668:
	ibp 4
	sojg 3,%L668	; decrement_and_branch_until_zero
%L669:
	jumpe 3,%L671
%L670:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 3,%L670
%L671:
	ldb 4,4
	dpb 4,2
	move 3,[POINT 7,s7,6]
	move 4,6
	andi 4,35
	jumple 4,%L673
%L672:
	ibp 3
	sojg 4,%L672	; decrement_and_branch_until_zero
%L673:
	jumpe 4,%L675
%L674:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L674
%L675:
	ldb 4,3
	trne 4,100
	orcmi 4,177
	add 5,4
	addi 7,1
	sojge 1,%L679	; doloop_end
%L678:
	move 1,5
	popj 17,

copy_uchar7_global:
	setzb 5,7
	caml 5,1
	jrst %L699
	subi 1,1
%L700:
	move 6,7
	addi 6,17
	move 2,[POINT 7,u7,6]
	move 4,6
	andi 4,35
	jumple 4,%L686
%L685:
	ibp 2
	sojg 4,%L685	; decrement_and_branch_until_zero
%L686:
	jumpe 4,%L688
%L687:
	subi 2,1
	ibp 2
	ibp 2
	ibp 2
	ibp 2
	aojl 4,%L687
%L688:
	move 4,[POINT 7,u7,6]
	move 3,7
	andi 3,17
	jumple 3,%L690
%L689:
	ibp 4
	sojg 3,%L689	; decrement_and_branch_until_zero
%L690:
	jumpe 3,%L692
%L691:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 3,%L691
%L692:
	ldb 4,4
	dpb 4,2
	move 3,[POINT 7,u7,6]
	move 4,6
	andi 4,35
	jumple 4,%L694
%L693:
	ibp 3
	sojg 4,%L693	; decrement_and_branch_until_zero
%L694:
	jumpe 4,%L696
%L695:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L695
%L696:
	ldb 4,3
	add 5,4
	addi 7,1
	sojge 1,%L700	; doloop_end
%L699:
	move 1,5
	popj 17,

sum_b7a_signed:
	setzb 5,7
	caml 5,1
	jrst %L716
	subi 1,1
%L717:
	move 6,7
	andi 6,7
	move 2,[POINT 7,b7a,6]
	move 4,6
	imuli 4,24
	jumple 4,%L707
%L706:
	ibp 2
	sojg 4,%L706	; decrement_and_branch_until_zero
%L707:
	jumpe 4,%L709
%L708:
	subi 2,1
	ibp 2
	ibp 2
	ibp 2
	ibp 2
	aojl 4,%L708
%L709:
	move 3,[POINT 7,b7a,6]
	move 4,6
	imuli 4,24
	jumple 4,%L711
%L710:
	ibp 3
	sojg 4,%L710	; decrement_and_branch_until_zero
%L711:
	jumpe 4,%L713
%L712:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L712
%L713:
	move 4,(3)
	lsh 4,34
	ash 4,-35
	add 4,(2)
	add 5,4
	addi 7,1
	sojge 1,%L717	; doloop_end
%L716:
	move 1,5
	popj 17,

sum_b7a_unsigned:
	setzb 5,7
	caml 5,1
	jrst %L733
	subi 1,1
%L734:
	move 6,7
	andi 6,7
	move 2,[POINT 7,b7a,6]
	move 4,6
	imuli 4,24
	jumple 4,%L724
%L723:
	ibp 2
	sojg 4,%L723	; decrement_and_branch_until_zero
%L724:
	jumpe 4,%L726
%L725:
	subi 2,1
	ibp 2
	ibp 2
	ibp 2
	ibp 2
	aojl 4,%L725
%L726:
	move 3,[POINT 7,b7a,6]
	move 4,6
	imuli 4,24
	jumple 4,%L728
%L727:
	ibp 3
	sojg 4,%L727	; decrement_and_branch_until_zero
%L728:
	jumpe 4,%L730
%L729:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L729
%L730:
	ldb 4,[POINT 7,1(3),34]
	add 4,1(2)
	add 5,4
	addi 7,1
	sojge 1,%L734	; doloop_end
%L733:
	move 1,5
	popj 17,

zero_b7a_signed:
	movei 7,0
	caml 7,1
	popj 17,
	movei 6,0
	subi 1,1
%L763:
	move 2,7
	andi 2,7
	move 3,[POINT 7,b7a,6]
	move 4,2
	imuli 4,24
	jumple 4,%L741
%L740:
	ibp 3
	sojg 4,%L740	; decrement_and_branch_until_zero
%L741:
	jumpe 4,%L743
%L742:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L742
%L743:
	dpb 6,3
	move 3,[POINT 7,b7a,6]
	move 4,2
	imuli 4,24
	jumple 4,%L745
%L744:
	ibp 3
	sojg 4,%L744	; decrement_and_branch_until_zero
%L745:
	jumpe 4,%L747
%L746:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L746
%L747:
	dpb 6,3
	move 3,[POINT 7,b7a,6]
	move 4,2
	imuli 4,24
	jumple 4,%L749
%L748:
	ibp 3
	sojg 4,%L748	; decrement_and_branch_until_zero
%L749:
	jumpe 4,%L751
%L750:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L750
%L751:
	dpb 6,3
	move 3,[POINT 7,b7a,6]
	move 4,2
	imuli 4,24
	jumple 4,%L753
%L752:
	ibp 3
	sojg 4,%L752	; decrement_and_branch_until_zero
%L753:
	jumpe 4,%L755
%L754:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L754
%L755:
	dpb 6,3
	move 3,[POINT 7,b7a,6]
	move 4,2
	imuli 4,24
	jumple 4,%L757
%L756:
	ibp 3
	sojg 4,%L756	; decrement_and_branch_until_zero
%L757:
	jumpe 4,%L759
%L758:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L758
%L759:
	dpb 6,3
	addi 7,1
	sojge 1,%L763	; doloop_end
	popj 17,

zero_b7a_unsigned:
	movei 7,0
	caml 7,1
	popj 17,
	movei 6,0
	subi 1,1
%L792:
	move 2,7
	andi 2,7
	move 3,[POINT 7,b7a,6]
	move 4,2
	imuli 4,24
	jumple 4,%L770
%L769:
	ibp 3
	sojg 4,%L769	; decrement_and_branch_until_zero
%L770:
	jumpe 4,%L772
%L771:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L771
%L772:
	addi 3,1
	dpb 6,3
	move 3,[POINT 7,b7a,6]
	move 4,2
	imuli 4,24
	jumple 4,%L774
%L773:
	ibp 3
	sojg 4,%L773	; decrement_and_branch_until_zero
%L774:
	jumpe 4,%L776
%L775:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L775
%L776:
	addi 3,1
	dpb 6,3
	move 3,[POINT 7,b7a,6]
	move 4,2
	imuli 4,24
	jumple 4,%L778
%L777:
	ibp 3
	sojg 4,%L777	; decrement_and_branch_until_zero
%L778:
	jumpe 4,%L780
%L779:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L779
%L780:
	addi 3,1
	dpb 6,3
	move 3,[POINT 7,b7a,6]
	move 4,2
	imuli 4,24
	jumple 4,%L782
%L781:
	ibp 3
	sojg 4,%L781	; decrement_and_branch_until_zero
%L782:
	jumpe 4,%L784
%L783:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L783
%L784:
	addi 3,1
	dpb 6,3
	move 3,[POINT 7,b7a,6]
	move 4,2
	imuli 4,24
	jumple 4,%L786
%L785:
	ibp 3
	sojg 4,%L785	; decrement_and_branch_until_zero
%L786:
	jumpe 4,%L788
%L787:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L787
%L788:
	addi 3,1
	dpb 6,3
	addi 7,1
	sojge 1,%L792	; doloop_end
	popj 17,

copy_b7a:
	movei 4,0
	caml 4,1
	popj 17,
%L802:
	move 6,4
	aos 2,6
	andi 2,7
	lsh 2,1
	add 2,[POINT 7,b7a,6]
	andi 4,7
	move 3,[POINT 7,b7a,6]
	lsh 4,1
	jumple 4,%L799
%L798:
	ibp 3
	sojg 4,%L798	; decrement_and_branch_until_zero
%L799:
	jumpe 4,%L801
%L800:
	subi 3,1
	ibp 3
	ibp 3
	ibp 3
	ibp 3
	aojl 4,%L800
%L801:
	move 7,(3)
	movem 7,(2)
	move 3,1(3)
	movem 3,1(2)
	move 4,6
	camge 6,1
	jrst %L802
	popj 17,

load_char7_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 4,[POINT 7,s7,6]
	andi 10,17
	jumple 10,%L807
%L806:
	ibp 4
	sojg 10,%L806	; decrement_and_branch_until_zero
%L807:
	jumpe 10,%L809
%L808:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 10,%L808
%L809:
	ldb 1,4
	trne 1,100
	orcmi 1,177
	pop 17,10
	popj 17,

load_uchar7_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 4,[POINT 7,u7,6]
	andi 10,17
	jumple 10,%L812
%L811:
	ibp 4
	sojg 10,%L811	; decrement_and_branch_until_zero
%L812:
	jumpe 10,%L814
%L813:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 10,%L813
%L814:
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
	move 4,[POINT 7,s7,6]
	andi 10,17
	jumple 10,%L817
%L816:
	ibp 4
	sojg 10,%L816	; decrement_and_branch_until_zero
%L817:
	jumpe 10,%L819
%L818:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 10,%L818
%L819:
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
	move 4,[POINT 7,u7,6]
	andi 10,17
	jumple 10,%L822
%L821:
	ibp 4
	sojg 10,%L821	; decrement_and_branch_until_zero
%L822:
	jumpe 10,%L824
%L823:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 10,%L823
%L824:
	dpb 11,4
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

load_char7_call_index:
	pushj 17,f
	move 4,[POINT 7,s7,6]
	andi 1,17
	jumple 1,%L827
%L826:
	ibp 4
	sojg 1,%L826	; decrement_and_branch_until_zero
%L827:
	jumpe 1,%L829
%L828:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L828
%L829:
	ldb 1,4
	trne 1,100
	orcmi 1,177
	popj 17,

load_uchar7_call_index:
	pushj 17,f
	move 4,[POINT 7,u7,6]
	andi 1,17
	jumple 1,%L832
%L831:
	ibp 4
	sojg 1,%L831	; decrement_and_branch_until_zero
%L832:
	jumpe 1,%L834
%L833:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L833
%L834:
	ldb 1,4
	popj 17,

store_char7_call_index:
	push 17,10
	move 10,1
	pushj 17,f
	move 4,[POINT 7,s7,6]
	andi 1,17
	jumple 1,%L837
%L836:
	ibp 4
	sojg 1,%L836	; decrement_and_branch_until_zero
%L837:
	jumpe 1,%L839
%L838:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L838
%L839:
	dpb 10,4
	pop 17,10
	popj 17,

store_uchar7_call_index:
	push 17,10
	move 10,1
	pushj 17,f
	move 4,[POINT 7,u7,6]
	andi 1,17
	jumple 1,%L842
%L841:
	ibp 4
	sojg 1,%L841	; decrement_and_branch_until_zero
%L842:
	jumpe 1,%L844
%L843:
	subi 4,1
	ibp 4
	ibp 4
	ibp 4
	ibp 4
	aojl 1,%L843
%L844:
	dpb 10,4
	pop 17,10
	popj 17,

add_char7_pointer:
	jumple 2,%L848
%L847:
	ibp 1
	sojg 2,%L847	; decrement_and_branch_until_zero
%L848:
	jumpe 2,%L850
%L849:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L849
%L850:
	popj 17,

add_uchar7_pointer:
	jumple 2,%L854
%L853:
	ibp 1
	sojg 2,%L853	; decrement_and_branch_until_zero
%L854:
	jumpe 2,%L856
%L855:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L855
%L856:
	popj 17,

sub_char7_pointer:
	movn 2,2
	jumple 2,%L860
%L859:
	ibp 1
	sojg 2,%L859	; decrement_and_branch_until_zero
%L860:
	jumpe 2,%L862
%L861:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L861
%L862:
	popj 17,

sub_uchar7_pointer:
	movn 2,2
	jumple 2,%L866
%L865:
	ibp 1
	sojg 2,%L865	; decrement_and_branch_until_zero
%L866:
	jumpe 2,%L868
%L867:
	subi 1,1
	ibp 1
	ibp 1
	ibp 1
	ibp 1
	aojl 2,%L867
%L868:
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
