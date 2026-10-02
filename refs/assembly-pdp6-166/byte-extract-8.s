
load8_0:
	move 1,b8
	ash 1,-34
	popj 17,

loadu8_0:
	move 1,b8+1
	lsh 1,-34
	popj 17,

load8_1:
	move 1,b8
	lsh 1,10
	ash 1,-34
	popj 17,

loadu8_1:
	ldb 1,[POINT 8,b8+1,15]
	popj 17,

load8_2:
	move 1,b8
	lsh 1,20
	ash 1,-34
	popj 17,

loadu8_2:
	ldb 1,[POINT 8,b8+1,23]
	popj 17,

load8_3:
	move 1,b8
	lsh 1,30
	ash 1,-34
	popj 17,

loadu8_3:
	ldb 1,[POINT 8,b8+1,31]
	popj 17,

load_char8_index:
	move 4,[POINT 8,s8,7]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,200
	orcmi 1,377
	popj 17,

load_uchar8_index:
	move 4,[POINT 8,u8,7]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	popj 17,

load_char8_const_cross:
	move 1,s8
	ash 1,-34
	move 4,s8
	lsh 4,30
	ash 4,-34
	add 1,4
	move 4,s8+1
	ash 4,-34
	add 1,4
	move 4,s8+1
	lsh 4,30
	ash 4,-34
	add 1,4
	move 4,s8+2
	ash 4,-34
	add 1,4
	popj 17,

store_char8_index:
	move 4,[POINT 8,s8,7]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	move 4,[POINT 8,u8,7]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	addi 2,1
	dpb 2,4
	popj 17,

copy_char8:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 11,1
	move 12,2
	setzb 10,1
	caml 10,3
	jrst %L29
	move 2,3
	subi 2,1
%L30:
	move 5,1
	andi 5,3
	move 4,5
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	move 7,11
	add 7,3
	jumpe 5,%L20
%L19:
	ibp 7
	sojn 4,%L19	; decrement_and_branch_until_zero
%L20:
	move 6,5
	move 4,12
	add 4,3
	jumpe 5,%L23
%L22:
	ibp 4
	sojn 6,%L22	; decrement_and_branch_until_zero
%L23:
	ldb 4,4
	dpb 4,7
	move 6,11
	add 6,3
	skipn 4,5
	jrst %L26
%L25:
	ibp 6
	sojn 4,%L25	; decrement_and_branch_until_zero
%L26:
	ldb 4,6
	trne 4,200
	orcmi 4,377
	add 10,4
	addi 1,1
	sojge 2,%L30	; doloop_end
%L29:
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

copy_uchar8:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 11,1
	move 12,2
	setzb 10,1
	caml 10,3
	jrst %L47
	move 2,3
	subi 2,1
%L48:
	move 5,1
	andi 5,3
	move 4,5
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	move 7,11
	add 7,3
	jumpe 5,%L38
%L37:
	ibp 7
	sojn 4,%L37	; decrement_and_branch_until_zero
%L38:
	move 6,5
	move 4,12
	add 4,3
	jumpe 5,%L41
%L40:
	ibp 4
	sojn 6,%L40	; decrement_and_branch_until_zero
%L41:
	ldb 4,4
	dpb 4,7
	move 6,11
	add 6,3
	skipn 4,5
	jrst %L44
%L43:
	ibp 6
	sojn 4,%L43	; decrement_and_branch_until_zero
%L44:
	ldb 4,6
	add 10,4
	addi 1,1
	sojge 2,%L48	; doloop_end
%L47:
	move 1,10
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

use_byte8:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	pushj 17,store_char8_index
	dpb 10,[POINT 8,b8,7]
	move 2,10
	addi 2,1
	dpb 2,[POINT 8,b8,15]
	move 3,10
	addi 3,2
	dpb 3,[POINT 8,b8,23]
	move 4,10
	addi 4,3
	dpb 4,[POINT 8,b8,31]
	dpb 10,[POINT 8,b8+1,7]
	dpb 2,[POINT 8,b8+1,15]
	dpb 3,[POINT 8,b8+1,23]
	dpb 4,[POINT 8,b8+1,31]
	move 1,11
	pushj 17,load_char8_index
	move 10,1
	move 1,11
	pushj 17,load_uchar8_index
	add 10,1
	pushj 17,load_char8_const_cross
	add 10,1
	pushj 17,load8_0
	add 10,1
	pushj 17,load8_1
	add 10,1
	pushj 17,load8_2
	add 10,1
	pushj 17,load8_3
	add 10,1
	pushj 17,loadu8_0
	add 10,1
	pushj 17,loadu8_1
	add 10,1
	pushj 17,loadu8_2
	add 10,1
	pushj 17,loadu8_3
	add 10,1
	move 1,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

load_s8_0:
	move 1,s8
	ash 1,-34
	popj 17,

load_s8_1:
	move 1,s8
	lsh 1,10
	ash 1,-34
	popj 17,

load_s8_2:
	move 1,s8
	lsh 1,20
	ash 1,-34
	popj 17,

load_s8_3:
	move 1,s8
	lsh 1,30
	ash 1,-34
	popj 17,

load_s8_4:
	move 1,s8+1
	ash 1,-34
	popj 17,

load_s8_5:
	move 1,s8+1
	lsh 1,10
	ash 1,-34
	popj 17,

load_s8_6:
	move 1,s8+1
	lsh 1,20
	ash 1,-34
	popj 17,

load_s8_7:
	move 1,s8+1
	lsh 1,30
	ash 1,-34
	popj 17,

load_s8_8:
	move 1,s8+2
	ash 1,-34
	popj 17,

load_u8_0:
	move 1,u8
	lsh 1,-34
	popj 17,

load_u8_1:
	ldb 1,[POINT 8,u8,15]
	popj 17,

load_u8_2:
	ldb 1,[POINT 8,u8,23]
	popj 17,

load_u8_3:
	ldb 1,[POINT 8,u8,31]
	popj 17,

load_u8_4:
	move 1,u8+1
	lsh 1,-34
	popj 17,

load_u8_5:
	ldb 1,[POINT 8,u8+1,15]
	popj 17,

load_u8_6:
	ldb 1,[POINT 8,u8+1,23]
	popj 17,

load_u8_7:
	ldb 1,[POINT 8,u8+1,31]
	popj 17,

load_u8_8:
	move 1,u8+2
	lsh 1,-34
	popj 17,

store_s8_0:
	dpb 1,[POINT 8,s8,7]
	popj 17,

store_s8_1:
	dpb 1,[POINT 8,s8,15]
	popj 17,

store_s8_2:
	dpb 1,[POINT 8,s8,23]
	popj 17,

store_s8_3:
	dpb 1,[POINT 8,s8,31]
	popj 17,

store_s8_4:
	dpb 1,[POINT 8,s8+1,7]
	popj 17,

store_s8_5:
	dpb 1,[POINT 8,s8+1,15]
	popj 17,

store_s8_6:
	dpb 1,[POINT 8,s8+1,23]
	popj 17,

store_s8_7:
	dpb 1,[POINT 8,s8+1,31]
	popj 17,

store_s8_8:
	dpb 1,[POINT 8,s8+2,7]
	popj 17,

store_u8_0:
	dpb 1,[POINT 8,u8,7]
	popj 17,

store_u8_1:
	dpb 1,[POINT 8,u8,15]
	popj 17,

store_u8_2:
	dpb 1,[POINT 8,u8,23]
	popj 17,

store_u8_3:
	dpb 1,[POINT 8,u8,31]
	popj 17,

store_u8_4:
	dpb 1,[POINT 8,u8+1,7]
	popj 17,

store_u8_5:
	dpb 1,[POINT 8,u8+1,15]
	popj 17,

store_u8_6:
	dpb 1,[POINT 8,u8+1,23]
	popj 17,

store_u8_7:
	dpb 1,[POINT 8,u8+1,31]
	popj 17,

store_u8_8:
	dpb 1,[POINT 8,u8+2,7]
	popj 17,

store_s8_return:
	andi 1,17
	move 4,[POINT 8,s8,7]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	lsh 2,34
	ash 2,-34
	move 1,2
	popj 17,

store_u8_return:
	andi 1,17
	move 4,[POINT 8,u8,7]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	andi 2,377
	move 1,2
	popj 17,

store_s8_const_return:
	dpb 1,[POINT 8,s8,31]
	lsh 1,34
	ash 1,-34
	popj 17,

store_u8_const_return:
	dpb 1,[POINT 8,u8,31]
	andi 1,377
	popj 17,

load_s8_ptr_0:
	ldb 1,[POINT 8,s8,7]
	trne 1,200
	orcmi 1,377
	popj 17,

load_s8_ptr_3:
	move 4,[POINT 8,s8,7]
	ibp 4
	ibp 4
	ildb 1,4
	trne 1,200
	orcmi 1,377
	popj 17,

load_s8_ptr_4:
	ldb 1,[POINT 8,s8+1,7]
	trne 1,200
	orcmi 1,377
	popj 17,

load_s8_ptr_7:
	move 4,[POINT 8,s8+1,7]
	ibp 4
	ibp 4
	ildb 1,4
	trne 1,200
	orcmi 1,377
	popj 17,

load_s8_ptr_8:
	ldb 1,[POINT 8,s8+2,7]
	trne 1,200
	orcmi 1,377
	popj 17,

load_u8_ptr_0:
	ldb 1,[POINT 8,u8,7]
	popj 17,

load_u8_ptr_3:
	move 4,[POINT 8,u8,7]
	ibp 4
	ibp 4
	ildb 1,4
	popj 17,

load_u8_ptr_4:
	ldb 1,[POINT 8,u8+1,7]
	popj 17,

load_u8_ptr_7:
	move 4,[POINT 8,u8+1,7]
	ibp 4
	ibp 4
	ildb 1,4
	popj 17,

load_u8_ptr_8:
	ldb 1,[POINT 8,u8+2,7]
	popj 17,

store_s8_ptr_0:
	dpb 1,[POINT 8,s8,7]
	popj 17,

store_s8_ptr_3:
	move 4,[POINT 8,s8,7]
	ibp 4
	ibp 4
	idpb 1,4
	popj 17,

store_s8_ptr_4:
	dpb 1,[POINT 8,s8+1,7]
	popj 17,

store_u8_ptr_0:
	dpb 1,[POINT 8,u8,7]
	popj 17,

store_u8_ptr_3:
	move 4,[POINT 8,u8,7]
	ibp 4
	ibp 4
	idpb 1,4
	popj 17,

store_u8_ptr_4:
	dpb 1,[POINT 8,u8+1,7]
	popj 17,

load_b8p_c0:
	ldb 1,[POINT 8,b8,7]
	trne 1,200
	orcmi 1,377
	popj 17,

load_b8p_c1:
	ldb 1,[POINT 8,b8,7]
	trne 1,200
	orcmi 1,377
	popj 17,

load_b8p_c2:
	move 4,[POINT 8,b8,7]
	ildb 1,4
	trne 1,200
	orcmi 1,377
	popj 17,

load_b8p_c3:
	move 4,[POINT 8,b8,7]
	ibp 4
	ildb 1,4
	trne 1,200
	orcmi 1,377
	popj 17,

load_b8p_u0:
	ldb 1,[POINT 8,b8+1,7]
	popj 17,

load_b8p_u1:
	ldb 1,[POINT 8,b8+1,7]
	popj 17,

load_b8p_u2:
	move 4,[POINT 8,b8+1,7]
	ildb 1,4
	popj 17,

load_b8p_u3:
	move 4,[POINT 8,b8+1,7]
	ibp 4
	ildb 1,4
	popj 17,

store_b8p_c0:
	dpb 1,[POINT 8,b8,7]
	popj 17,

store_b8p_c1:
	dpb 1,[POINT 8,b8,7]
	popj 17,

store_b8p_c2:
	move 4,[POINT 8,b8,7]
	idpb 1,4
	popj 17,

store_b8p_c3:
	move 4,[POINT 8,b8,7]
	ibp 4
	idpb 1,4
	popj 17,

store_b8p_u0:
	dpb 1,[POINT 8,b8+1,7]
	popj 17,

store_b8p_u1:
	dpb 1,[POINT 8,b8+1,7]
	popj 17,

store_b8p_u2:
	move 4,[POINT 8,b8+1,7]
	idpb 1,4
	popj 17,

store_b8p_u3:
	move 4,[POINT 8,b8+1,7]
	ibp 4
	idpb 1,4
	popj 17,

load_char8_masked:
	andi 1,17
	move 4,[POINT 8,s8,7]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,200
	orcmi 1,377
	popj 17,

load_uchar8_masked:
	andi 1,17
	move 4,[POINT 8,u8,7]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	popj 17,

load_char8_pointer:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L175
%L174:
	ibp 1
	sojn 4,%L174	; decrement_and_branch_until_zero
%L175:
	ldb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

load_uchar8_pointer:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L179
%L178:
	ibp 1
	sojn 4,%L178	; decrement_and_branch_until_zero
%L179:
	ldb 1,1
	popj 17,

load_char8_pointer_plus_1:
	ibp 1
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L183
%L182:
	ibp 1
	sojn 4,%L182	; decrement_and_branch_until_zero
%L183:
	ldb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

load_char8_pointer_plus_3:
	ibp 1
	ibp 1
	ibp 1
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L187
%L186:
	ibp 1
	sojn 4,%L186	; decrement_and_branch_until_zero
%L187:
	ldb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

load_char8_pointer_plus_4:
	addi 1,1
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L191
%L190:
	ibp 1
	sojn 4,%L190	; decrement_and_branch_until_zero
%L191:
	ldb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

load_uchar8_pointer_plus_1:
	ibp 1
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L195
%L194:
	ibp 1
	sojn 4,%L194	; decrement_and_branch_until_zero
%L195:
	ldb 1,1
	popj 17,

load_uchar8_pointer_plus_3:
	ibp 1
	ibp 1
	ibp 1
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L199
%L198:
	ibp 1
	sojn 4,%L198	; decrement_and_branch_until_zero
%L199:
	ldb 1,1
	popj 17,

load_uchar8_pointer_plus_4:
	addi 1,1
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L203
%L202:
	ibp 1
	sojn 4,%L202	; decrement_and_branch_until_zero
%L203:
	ldb 1,1
	popj 17,

store_char8_pointer:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L207
%L206:
	ibp 1
	sojn 4,%L206	; decrement_and_branch_until_zero
%L207:
	dpb 3,1
	popj 17,

store_uchar8_pointer:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L211
%L210:
	ibp 1
	sojn 4,%L210	; decrement_and_branch_until_zero
%L211:
	dpb 3,1
	popj 17,

store_char8_pointer_plus_1:
	ibp 1
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L215
%L214:
	ibp 1
	sojn 4,%L214	; decrement_and_branch_until_zero
%L215:
	dpb 3,1
	popj 17,

store_char8_pointer_plus_3:
	ibp 1
	ibp 1
	ibp 1
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L219
%L218:
	ibp 1
	sojn 4,%L218	; decrement_and_branch_until_zero
%L219:
	dpb 3,1
	popj 17,

store_char8_pointer_plus_4:
	addi 1,1
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L223
%L222:
	ibp 1
	sojn 4,%L222	; decrement_and_branch_until_zero
%L223:
	dpb 3,1
	popj 17,

store_uchar8_pointer_plus_1:
	ibp 1
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L227
%L226:
	ibp 1
	sojn 4,%L226	; decrement_and_branch_until_zero
%L227:
	dpb 3,1
	popj 17,

store_uchar8_pointer_plus_3:
	ibp 1
	ibp 1
	ibp 1
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L231
%L230:
	ibp 1
	sojn 4,%L230	; decrement_and_branch_until_zero
%L231:
	dpb 3,1
	popj 17,

store_uchar8_pointer_plus_4:
	addi 1,1
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L235
%L234:
	ibp 1
	sojn 4,%L234	; decrement_and_branch_until_zero
%L235:
	dpb 3,1
	popj 17,

store_char8_index_plus_1:
	addi 1,1
	andi 1,17
	move 4,[POINT 8,s8,7]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

store_uchar8_index_plus_3:
	addi 1,3
	andi 1,17
	move 4,[POINT 8,u8,7]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

store_uchar8_index_plus_4:
	addi 1,4
	andi 1,17
	move 4,[POINT 8,u8,7]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

load_vchar8_index:
	andi 1,17
	move 4,[POINT 8,vs8,7]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,200
	orcmi 1,377
	popj 17,

load_vuchar8_index:
	andi 1,17
	move 4,[POINT 8,vu8,7]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	popj 17,

store_vchar8_index:
	andi 1,17
	move 4,[POINT 8,vs8,7]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

store_vuchar8_index:
	andi 1,17
	move 4,[POINT 8,vu8,7]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

sum_vchar8_pair:
	move 4,1
	andi 4,17
	move 2,[POINT 8,vs8,7]
	move 6,2
	move 0,4
	jumple 0,.+3
	ibp 6
	sojg 0,.-1
	ldb 3,6
	trne 3,200
	orcmi 3,377
	addi 1,4
	andi 1,17
	move 4,2
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	trne 4,200
	orcmi 4,377
	add 3,4
	move 1,3
	popj 17,

sum_vuchar8_pair:
	move 4,1
	andi 4,17
	move 2,[POINT 8,vu8,7]
	move 6,2
	move 0,4
	jumple 0,.+3
	ibp 6
	sojg 0,.-1
	ldb 3,6
	addi 1,4
	andi 1,17
	move 4,2
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	add 3,4
	move 1,3
	popj 17,

b8_load_c0:
	move 1,b8
	ash 1,-34
	popj 17,

b8_load_c1:
	move 1,b8
	lsh 1,10
	ash 1,-34
	popj 17,

b8_load_c2:
	move 1,b8
	lsh 1,20
	ash 1,-34
	popj 17,

b8_load_c3:
	move 1,b8
	lsh 1,30
	ash 1,-34
	popj 17,

b8_load_u0:
	move 1,b8+1
	lsh 1,-34
	popj 17,

b8_load_u1:
	ldb 1,[POINT 8,b8+1,15]
	popj 17,

b8_load_u2:
	ldb 1,[POINT 8,b8+1,23]
	popj 17,

b8_load_u3:
	ldb 1,[POINT 8,b8+1,31]
	popj 17,

b8_store_c0:
	dpb 1,[POINT 8,b8,7]
	popj 17,

b8_store_c1:
	dpb 1,[POINT 8,b8,15]
	popj 17,

b8_store_c2:
	dpb 1,[POINT 8,b8,23]
	popj 17,

b8_store_c3:
	dpb 1,[POINT 8,b8,31]
	popj 17,

b8_store_u0:
	dpb 1,[POINT 8,b8+1,7]
	popj 17,

b8_store_u1:
	dpb 1,[POINT 8,b8+1,15]
	popj 17,

b8_store_u2:
	dpb 1,[POINT 8,b8+1,23]
	popj 17,

b8_store_u3:
	dpb 1,[POINT 8,b8+1,31]
	popj 17,

b8_sum_signed:
	move 1,b8
	ash 1,-34
	move 4,b8
	lsh 4,10
	ash 4,-34
	add 1,4
	move 4,b8
	lsh 4,20
	ash 4,-34
	add 1,4
	move 4,b8
	lsh 4,30
	ash 4,-34
	add 1,4
	popj 17,

b8_sum_unsigned:
	move 1,b8+1
	lsh 1,-34
	ldb 4,[POINT 8,b8+1,15]
	add 1,4
	ldb 4,[POINT 8,b8+1,23]
	add 1,4
	ldb 4,[POINT 8,b8+1,31]
	add 1,4
	popj 17,

sb8_sum:
	move 1,sb8
	ash 1,-34
	move 4,sb8
	lsh 4,10
	ash 4,-34
	add 1,4
	move 4,sb8
	lsh 4,20
	ash 4,-34
	add 1,4
	move 4,sb8
	lsh 4,30
	ash 4,-34
	add 1,4
	popj 17,

ub8_sum:
	move 1,ub8
	lsh 1,-34
	ldb 4,[POINT 8,ub8,15]
	add 1,4
	ldb 4,[POINT 8,ub8,23]
	add 1,4
	ldb 4,[POINT 8,ub8,31]
	add 1,4
	popj 17,

load_b8a_signed:
	andi 1,7
	lsh 1,2
	move 3,b8a+pdp10.c:7954:TOOBIG:(1)
	ash 3,-34
	move 4,b8a+pdp10.c:7954:TOOBIG:(1)
	lsh 4,30
	ash 4,-34
	add 3,4
	move 1,3
	popj 17,

load_b8a_unsigned:
	andi 1,7
	lsh 1,2
	add 1,[POINT 8,b8a,7]
	move 3,1(1)
	lsh 3,-34
	ldb 4,[POINT 8,1(1),31]
	add 3,4
	move 1,3
	popj 17,

store_b8a_signed:
	andi 1,7
	lsh 1,2
	dpb 2,[POINT 8,b8a+pdp10.c:7954:TOOBIG:(1),7]
	addi 2,3
	dpb 2,[POINT 8,b8a+pdp10.c:7954:TOOBIG:(1),31]
	popj 17,

store_b8a_unsigned:
	andi 1,7
	lsh 1,2
	add 1,[POINT 8,b8a,7]
	dpb 2,[POINT 8,1(1),7]
	addi 2,3
	dpb 2,[POINT 8,1(1),31]
	popj 17,

mixed8_load:
	move 3,1
	move 1,mb8+1
	ash 1,-34
	add 1,mb8+2
	ldb 4,[POINT 8,mb8+1,15]
	add 1,4
	move 4,mb8+1
	lsh 4,20
	ash 4,-34
	add 1,4
	ldb 4,[POINT 8,mb8+1,31]
	add 1,4
	move 4,mb8+3
	ash 4,-34
	add 1,4
	ldb 4,[POINT 8,mb8+3,15]
	add 1,4
	andi 3,7
	lsh 3,2
	add 1,mb8a+2(3)
	popj 17,

mixed8_store:
	movem 2,mb8+2
	dpb 2,[POINT 8,mb8+1,7]
	addi 2,1
	dpb 2,[POINT 8,mb8+1,15]
	addi 2,1
	dpb 2,[POINT 8,mb8+1,23]
	addi 2,1
	dpb 2,[POINT 8,mb8+1,31]
	addi 2,1
	dpb 2,[POINT 8,mb8+3,7]
	addi 2,1
	dpb 2,[POINT 8,mb8+3,15]
	subi 2,5
	andi 1,7
	move 4,1
	lsh 4,2
	move 6,2
	addi 6,6
	movem 6,mb8a+2(4)
	imuli 1,22
	xmovei 1,mb8a(1)
	addi 2,7
	dpb 2,[POINT 8,1(1),7]
	addi 2,1
	dpb 2,[POINT 8,3(1),15]
	popj 17,

char8_sign_extend_value:
	lsh 1,34
	ash 1,-34
	lsh 1,34
	ash 1,-34
	popj 17,

uchar8_zero_extend_value:
	andi 1,377
	andi 1,377
	popj 17,

char8_plus:
	move 3,1
	move 4,1
	andi 4,17
	move 6,[POINT 8,s8,7]
	move 0,4
	jumple 0,.+3
	ibp 6
	sojg 0,.-1
	ldb 1,6
	trne 1,200
	orcmi 1,377
	add 1,2
	lsh 1,34
	ash 1,-34
	addi 3,1
	andi 3,17
	move 4,[POINT 8,s8,7]
	move 0,3
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 1,4
	lsh 1,34
	ash 1,-34
	popj 17,

uchar8_plus:
	move 3,1
	move 4,1
	andi 4,17
	move 6,[POINT 8,u8,7]
	move 0,4
	jumple 0,.+3
	ibp 6
	sojg 0,.-1
	ldb 1,6
	add 1,2
	andi 1,377
	addi 3,1
	andi 3,17
	move 4,[POINT 8,u8,7]
	move 0,3
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 1,4
	andi 1,377
	popj 17,

char8_cmp_zero:
	andi 1,17
	move 4,[POINT 8,s8,7]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	trne 4,200
	orcmi 4,377
	lsh 4,33
	ash 4,-33
	seto 1,
	jumpl 4,%L275
	skipe 1,4
	movei 1,1
%L275:
	popj 17,

uchar8_cmp_200:
	andi 1,17
	move 4,[POINT 8,u8,7]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	seto 1,
	cail 4,0
	cail 4,200
	trna
	jrst %L278
	movei 6,200
	camn 4,6
	tdza 1,1
	movei 1,1
%L278:
	popj 17,

char8_range:
	andi 1,17
	move 4,[POINT 8,s8,7]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,200
	orcmi 1,377
	caml 1,[-200]
	cail 1,600
	tdza 1,1
	movei 1,1
	popj 17,

uchar8_range:
	andi 1,17
	move 4,[POINT 8,u8,7]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	skipl 1,1
	cail 1,400
	tdza 1,1
	movei 1,1
	popj 17,

sum_char8:
	move 7,1
	setzb 1,6
	caml 1,2
	popj 17,
	subi 2,1
%L294:
	move 4,6
	andi 4,3
	move 3,6
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L290
%L289:
	ibp 3
	sojn 4,%L289	; decrement_and_branch_until_zero
%L290:
	ldb 4,3
	trne 4,200
	orcmi 4,377
	add 1,4
	addi 6,1
	sojge 2,%L294	; doloop_end
	popj 17,

sum_uchar8:
	move 7,1
	setzb 1,6
	caml 1,2
	popj 17,
	subi 2,1
%L306:
	move 4,6
	andi 4,3
	move 3,6
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L302
%L301:
	ibp 3
	sojn 4,%L301	; decrement_and_branch_until_zero
%L302:
	ldb 4,3
	add 1,4
	addi 6,1
	sojge 2,%L306	; doloop_end
	popj 17,

sum_char8_walk:
	movei 3,0
	move 4,2
	subi 2,1
	jumple 4,%L313
%L311:
	ldb 4,1
	trne 4,200
	orcmi 4,377
	add 3,4
	ibp 1
	move 4,2
	subi 2,1
	jumpg 4,%L311
%L313:
	move 1,3
	popj 17,

sum_uchar8_walk:
	movei 3,0
	move 4,2
	subi 2,1
	jumple 4,%L320
%L318:
	ldb 4,1
	add 3,4
	ibp 1
	move 4,2
	subi 2,1
	jumpg 4,%L318
%L320:
	move 1,3
	popj 17,

zero_char8:
	movei 6,0
	caml 6,2
	popj 17,
	movei 7,0
	subi 2,1
%L332:
	move 4,6
	andi 4,3
	move 3,6
	ash 3,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L328
%L327:
	ibp 3
	sojn 4,%L327	; decrement_and_branch_until_zero
%L328:
	dpb 7,3
	addi 6,1
	sojge 2,%L332	; doloop_end
	popj 17,

zero_uchar8:
	movei 6,0
	caml 6,2
	popj 17,
	movei 7,0
	subi 2,1
%L344:
	move 4,6
	andi 4,3
	move 3,6
	ash 3,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L340
%L339:
	ibp 3
	sojn 4,%L339	; decrement_and_branch_until_zero
%L340:
	dpb 7,3
	addi 6,1
	sojge 2,%L344	; doloop_end
	popj 17,

fill_char8:
	movei 7,0
	caml 7,2
	popj 17,
	subi 2,1
%L356:
	move 4,7
	andi 4,3
	move 6,7
	ash 6,-2	; ashrsi3_pointer
	add 6,1
	jumpe 4,%L352
%L351:
	ibp 6
	sojn 4,%L351	; decrement_and_branch_until_zero
%L352:
	dpb 3,6
	addi 3,1
	addi 7,1
	sojge 2,%L356	; doloop_end
	popj 17,

fill_uchar8:
	movei 7,0
	caml 7,2
	popj 17,
	subi 2,1
%L368:
	move 4,7
	andi 4,3
	move 6,7
	ash 6,-2	; ashrsi3_pointer
	add 6,1
	jumpe 4,%L364
%L363:
	ibp 6
	sojn 4,%L363	; decrement_and_branch_until_zero
%L364:
	dpb 3,6
	addi 3,1
	addi 7,1
	sojge 2,%L368	; doloop_end
	popj 17,

copy_char8_reverse:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	movei 1,0
	sojl 3,%L385	; decrement_and_branch_until_zero
%L383:
	move 5,3
	andi 5,3
	move 4,5
	move 2,3
	ash 2,-2	; ashrsi3_pointer
	move 7,10
	add 7,2
	jumpe 5,%L376
%L375:
	ibp 7
	sojn 4,%L375	; decrement_and_branch_until_zero
%L376:
	move 6,5
	move 4,11
	add 4,2
	jumpe 5,%L379
%L378:
	ibp 4
	sojn 6,%L378	; decrement_and_branch_until_zero
%L379:
	ldb 4,4
	dpb 4,7
	move 6,10
	add 6,2
	skipn 4,5
	jrst %L382
%L381:
	ibp 6
	sojn 4,%L381	; decrement_and_branch_until_zero
%L382:
	ldb 4,6
	trne 4,200
	orcmi 4,377
	add 1,4
	sojge 3,%L383	; decrement_and_branch_until_zero
%L385:
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

copy_uchar8_reverse:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	movei 1,0
	sojl 3,%L402	; decrement_and_branch_until_zero
%L400:
	move 5,3
	andi 5,3
	move 4,5
	move 2,3
	ash 2,-2	; ashrsi3_pointer
	move 7,10
	add 7,2
	jumpe 5,%L393
%L392:
	ibp 7
	sojn 4,%L392	; decrement_and_branch_until_zero
%L393:
	move 6,5
	move 4,11
	add 4,2
	jumpe 5,%L396
%L395:
	ibp 4
	sojn 6,%L395	; decrement_and_branch_until_zero
%L396:
	ldb 4,4
	dpb 4,7
	move 6,10
	add 6,2
	skipn 4,5
	jrst %L399
%L398:
	ibp 6
	sojn 4,%L398	; decrement_and_branch_until_zero
%L399:
	ldb 4,6
	add 1,4
	sojge 3,%L400	; decrement_and_branch_until_zero
%L402:
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

add_char8_pointer:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L406
%L405:
	ibp 1
	sojn 4,%L405	; decrement_and_branch_until_zero
%L406:
	popj 17,

add_uchar8_pointer:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L410
%L409:
	ibp 1
	sojn 4,%L409	; decrement_and_branch_until_zero
%L410:
	popj 17,

sub_char8_pointer:
	movn 2,2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L414
%L413:
	ibp 1
	sojn 4,%L413	; decrement_and_branch_until_zero
%L414:
	popj 17,

sub_uchar8_pointer:
	movn 2,2
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

add_char8_pointer_const_1:
	ibp 1
	popj 17,

add_char8_pointer_const_3:
	ibp 1
	ibp 1
	ibp 1
	popj 17,

add_char8_pointer_const_4:
	addi 1,1
	popj 17,

add_char8_pointer_const_5:
	addi 1,1
	ibp 1
	popj 17,

add_uchar8_pointer_const_1:
	ibp 1
	popj 17,

add_uchar8_pointer_const_3:
	ibp 1
	ibp 1
	ibp 1
	popj 17,

add_uchar8_pointer_const_4:
	addi 1,1
	popj 17,

add_uchar8_pointer_const_5:
	addi 1,1
	ibp 1
	popj 17,

use_byte8_more:
	add 17,[5,,5]
	movei 0,-4(17)
	hrli 0,10
	blt 0,(17)
	move 11,1
	move 12,2
	pushj 17,store_char8_index
	move 10,12
	addi 10,1
	move 1,11
	move 2,10
	pushj 17,store_char8_index_plus_1
	move 13,12
	addi 13,3
	move 1,11
	move 2,13
	pushj 17,store_uchar8_index_plus_3
	move 2,12
	addi 2,4
	move 1,11
	pushj 17,store_uchar8_index_plus_4
	move 1,12
	pushj 17,b8_store_c0
	move 1,10
	pushj 17,b8_store_c1
	move 14,12
	addi 14,2
	move 1,14
	pushj 17,b8_store_c2
	move 1,13
	pushj 17,b8_store_c3
	move 1,12
	pushj 17,b8_store_u0
	move 1,10
	pushj 17,b8_store_u1
	move 1,14
	pushj 17,b8_store_u2
	move 1,13
	pushj 17,b8_store_u3
	move 1,11
	move 2,12
	pushj 17,mixed8_store
	move 1,11
	pushj 17,load_char8_masked
	move 10,1
	move 1,11
	pushj 17,load_uchar8_masked
	add 10,1
	pushj 17,load_char8_const_cross
	add 10,1
	pushj 17,b8_sum_signed
	add 10,1
	pushj 17,b8_sum_unsigned
	add 10,1
	pushj 17,sb8_sum
	add 10,1
	pushj 17,ub8_sum
	add 10,1
	move 1,11
	move 2,12
	pushj 17,char8_plus
	add 10,1
	move 1,11
	move 2,12
	pushj 17,uchar8_plus
	add 10,1
	move 1,11
	pushj 17,char8_cmp_zero
	add 10,1
	move 1,11
	pushj 17,uchar8_cmp_200
	add 10,1
	move 1,11
	pushj 17,char8_range
	add 10,1
	move 1,11
	pushj 17,uchar8_range
	add 10,1
	move 1,11
	pushj 17,mixed8_load
	add 10,1
	move 1,11
	pushj 17,load_vchar8_index
	add 10,1
	move 1,11
	pushj 17,load_vuchar8_index
	add 10,1
	move 1,11
	pushj 17,sum_vchar8_pair
	add 10,1
	move 1,11
	pushj 17,sum_vuchar8_pair
	add 10,1
	move 1,10
	movei 0,10
	hrli 0,-4(17)
	blt 0,14
	add 17,[-5,,-5]
	popj 17,

	.bss
s8:
	.space	32
u8:
	.space	32
vs8:
	.space	32
vu8:
	.space	32
b8:
	.space	8
sb8:
	.space	4
ub8:
	.space	4
mb8:
	.space	16
b8a:
	.space	64
sb8a:
	.space	32
ub8a:
	.space	32
mb8a:
	.space	128
