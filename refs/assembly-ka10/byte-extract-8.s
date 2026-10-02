
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
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 8,s8,7]
	jumpe 4,%L11
%L10:
	ibp 3
	sojn 4,%L10	; decrement_and_branch_until_zero
%L11:
	ldb 1,3
	trne 1,200
	orcmi 1,377
	popj 17,

load_uchar8_index:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 8,u8,7]
	jumpe 4,%L14
%L13:
	ibp 3
	sojn 4,%L13	; decrement_and_branch_until_zero
%L14:
	ldb 1,3
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
	move 6,1
	move 4,1
	andi 4,3
	ash 6,-2	; ashrsi3_pointer
	move 3,6
	add 3,[POINT 8,s8,7]
	jumpe 4,%L18
%L17:
	ibp 3
	sojn 4,%L17	; decrement_and_branch_until_zero
%L18:
	dpb 2,3
	andi 1,3
	move 4,6
	add 4,[POINT 8,u8,7]
	jumpe 1,%L20
%L19:
	ibp 4
	sojn 1,%L19	; decrement_and_branch_until_zero
%L20:
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
	jrst %L37
	move 2,3
	subi 2,1
%L38:
	move 5,1
	andi 5,3
	move 4,5
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	move 7,11
	add 7,3
	jumpe 5,%L28
%L27:
	ibp 7
	sojn 4,%L27	; decrement_and_branch_until_zero
%L28:
	move 6,5
	move 4,12
	add 4,3
	jumpe 5,%L31
%L30:
	ibp 4
	sojn 6,%L30	; decrement_and_branch_until_zero
%L31:
	ldb 4,4
	dpb 4,7
	move 6,11
	add 6,3
	skipn 4,5
	jrst %L34
%L33:
	ibp 6
	sojn 4,%L33	; decrement_and_branch_until_zero
%L34:
	ldb 4,6
	trne 4,200
	orcmi 4,377
	add 10,4
	addi 1,1
	sojge 2,%L38	; doloop_end
%L37:
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
	jrst %L55
	move 2,3
	subi 2,1
%L56:
	move 5,1
	andi 5,3
	move 4,5
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	move 7,11
	add 7,3
	jumpe 5,%L46
%L45:
	ibp 7
	sojn 4,%L45	; decrement_and_branch_until_zero
%L46:
	move 6,5
	move 4,12
	add 4,3
	jumpe 5,%L49
%L48:
	ibp 4
	sojn 6,%L48	; decrement_and_branch_until_zero
%L49:
	ldb 4,4
	dpb 4,7
	move 6,11
	add 6,3
	skipn 4,5
	jrst %L52
%L51:
	ibp 6
	sojn 4,%L51	; decrement_and_branch_until_zero
%L52:
	ldb 4,6
	add 10,4
	addi 1,1
	sojge 2,%L56	; doloop_end
%L55:
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
	move 4,1
	andi 4,3
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 8,s8,7]
	jumpe 4,%L96
%L95:
	ibp 1
	sojn 4,%L95	; decrement_and_branch_until_zero
%L96:
	dpb 2,1
	lsh 2,34
	ash 2,-34
	move 1,2
	popj 17,

store_u8_return:
	move 4,1
	andi 4,3
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 8,u8,7]
	jumpe 4,%L99
%L98:
	ibp 1
	sojn 4,%L98	; decrement_and_branch_until_zero
%L99:
	dpb 2,1
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
	ldb 1,[POINT 8,s8,31]
	trne 1,200
	orcmi 1,377
	popj 17,

load_s8_ptr_4:
	ldb 1,[POINT 8,s8+1,7]
	trne 1,200
	orcmi 1,377
	popj 17,

load_s8_ptr_7:
	ldb 1,[POINT 8,s8+1,31]
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
	ldb 1,[POINT 8,u8,31]
	popj 17,

load_u8_ptr_4:
	ldb 1,[POINT 8,u8+1,7]
	popj 17,

load_u8_ptr_7:
	ldb 1,[POINT 8,u8+1,31]
	popj 17,

load_u8_ptr_8:
	ldb 1,[POINT 8,u8+2,7]
	popj 17,

store_s8_ptr_0:
	dpb 1,[POINT 8,s8,7]
	popj 17,

store_s8_ptr_3:
	dpb 1,[POINT 8,s8,31]
	popj 17,

store_s8_ptr_4:
	dpb 1,[POINT 8,s8+1,7]
	popj 17,

store_u8_ptr_0:
	dpb 1,[POINT 8,u8,7]
	popj 17,

store_u8_ptr_3:
	dpb 1,[POINT 8,u8,31]
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
	ldb 1,[POINT 8,b8,15]
	trne 1,200
	orcmi 1,377
	popj 17,

load_b8p_c2:
	ldb 1,[POINT 8,b8,23]
	trne 1,200
	orcmi 1,377
	popj 17,

load_b8p_c3:
	ldb 1,[POINT 8,b8,31]
	trne 1,200
	orcmi 1,377
	popj 17,

load_b8p_u0:
	add 17,[1,,1]
	move 4,b8+1
	lsh 4,-34
	movem 4,(17)
	movei 4,(17)
	tlo 4,2200
	ldb 1,4
	add 17,[-1,,-1]
	popj 17,

load_b8p_u1:
	ldb 1,[POINT 8,b8+1,15]
	popj 17,

load_b8p_u2:
	ldb 1,[POINT 8,b8+1,23]
	popj 17,

load_b8p_u3:
	ldb 1,[POINT 8,b8+1,31]
	popj 17,

store_b8p_c0:
	dpb 1,[POINT 8,b8,7]
	popj 17,

store_b8p_c1:
	dpb 1,[POINT 8,b8,15]
	popj 17,

store_b8p_c2:
	dpb 1,[POINT 8,b8,23]
	popj 17,

store_b8p_c3:
	dpb 1,[POINT 8,b8,31]
	popj 17,

store_b8p_u0:
	add 17,[1,,1]
	movei 4,(17)
	tlo 4,2200
	dpb 1,4
	add 17,[-1,,-1]
	popj 17,

store_b8p_u1:
	dpb 1,[POINT 8,b8+1,15]
	popj 17,

store_b8p_u2:
	dpb 1,[POINT 8,b8+1,23]
	popj 17,

store_b8p_u3:
	dpb 1,[POINT 8,b8+1,31]
	popj 17,

load_char8_masked:
	move 4,1
	andi 4,3
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 8,s8,7]
	jumpe 4,%L154
%L153:
	ibp 1
	sojn 4,%L153	; decrement_and_branch_until_zero
%L154:
	ldb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

load_uchar8_masked:
	move 4,1
	andi 4,3
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 8,u8,7]
	jumpe 4,%L157
%L156:
	ibp 1
	sojn 4,%L156	; decrement_and_branch_until_zero
%L157:
	ldb 1,1
	popj 17,

load_char8_pointer:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L161
%L160:
	ibp 1
	sojn 4,%L160	; decrement_and_branch_until_zero
%L161:
	ldb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

load_uchar8_pointer:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L165
%L164:
	ibp 1
	sojn 4,%L164	; decrement_and_branch_until_zero
%L165:
	ldb 1,1
	popj 17,

load_char8_pointer_plus_1:
	ibp 1
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L169
%L168:
	ibp 1
	sojn 4,%L168	; decrement_and_branch_until_zero
%L169:
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
	jumpe 4,%L173
%L172:
	ibp 1
	sojn 4,%L172	; decrement_and_branch_until_zero
%L173:
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
	jumpe 4,%L177
%L176:
	ibp 1
	sojn 4,%L176	; decrement_and_branch_until_zero
%L177:
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
	jumpe 4,%L181
%L180:
	ibp 1
	sojn 4,%L180	; decrement_and_branch_until_zero
%L181:
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
	jumpe 4,%L185
%L184:
	ibp 1
	sojn 4,%L184	; decrement_and_branch_until_zero
%L185:
	ldb 1,1
	popj 17,

load_uchar8_pointer_plus_4:
	addi 1,1
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L189
%L188:
	ibp 1
	sojn 4,%L188	; decrement_and_branch_until_zero
%L189:
	ldb 1,1
	popj 17,

store_char8_pointer:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L193
%L192:
	ibp 1
	sojn 4,%L192	; decrement_and_branch_until_zero
%L193:
	dpb 3,1
	popj 17,

store_uchar8_pointer:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L197
%L196:
	ibp 1
	sojn 4,%L196	; decrement_and_branch_until_zero
%L197:
	dpb 3,1
	popj 17,

store_char8_pointer_plus_1:
	ibp 1
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L201
%L200:
	ibp 1
	sojn 4,%L200	; decrement_and_branch_until_zero
%L201:
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
	jumpe 4,%L205
%L204:
	ibp 1
	sojn 4,%L204	; decrement_and_branch_until_zero
%L205:
	dpb 3,1
	popj 17,

store_char8_pointer_plus_4:
	addi 1,1
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L209
%L208:
	ibp 1
	sojn 4,%L208	; decrement_and_branch_until_zero
%L209:
	dpb 3,1
	popj 17,

store_uchar8_pointer_plus_1:
	ibp 1
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L213
%L212:
	ibp 1
	sojn 4,%L212	; decrement_and_branch_until_zero
%L213:
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
	jumpe 4,%L217
%L216:
	ibp 1
	sojn 4,%L216	; decrement_and_branch_until_zero
%L217:
	dpb 3,1
	popj 17,

store_uchar8_pointer_plus_4:
	addi 1,1
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L221
%L220:
	ibp 1
	sojn 4,%L220	; decrement_and_branch_until_zero
%L221:
	dpb 3,1
	popj 17,

store_char8_index_plus_1:
	aos 4,1
	andi 4,3
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 8,s8,7]
	jumpe 4,%L224
%L223:
	ibp 1
	sojn 4,%L223	; decrement_and_branch_until_zero
%L224:
	dpb 2,1
	popj 17,

store_uchar8_index_plus_3:
	addi 1,3
	move 4,1
	andi 4,3
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 8,u8,7]
	jumpe 4,%L227
%L226:
	ibp 1
	sojn 4,%L226	; decrement_and_branch_until_zero
%L227:
	dpb 2,1
	popj 17,

store_uchar8_index_plus_4:
	addi 1,4
	move 4,1
	andi 4,3
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 8,u8,7]
	jumpe 4,%L230
%L229:
	ibp 1
	sojn 4,%L229	; decrement_and_branch_until_zero
%L230:
	dpb 2,1
	popj 17,

load_vchar8_index:
	move 4,1
	andi 4,3
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 8,vs8,7]
	jumpe 4,%L233
%L232:
	ibp 1
	sojn 4,%L232	; decrement_and_branch_until_zero
%L233:
	ldb 1,1
	trne 1,200
	orcmi 1,377
	popj 17,

load_vuchar8_index:
	move 4,1
	andi 4,3
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 8,vu8,7]
	jumpe 4,%L236
%L235:
	ibp 1
	sojn 4,%L235	; decrement_and_branch_until_zero
%L236:
	ldb 1,1
	popj 17,

store_vchar8_index:
	move 4,1
	andi 4,3
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 8,vs8,7]
	jumpe 4,%L239
%L238:
	ibp 1
	sojn 4,%L238	; decrement_and_branch_until_zero
%L239:
	dpb 2,1
	popj 17,

store_vuchar8_index:
	move 4,1
	andi 4,3
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 8,vu8,7]
	jumpe 4,%L242
%L241:
	ibp 1
	sojn 4,%L241	; decrement_and_branch_until_zero
%L242:
	dpb 2,1
	popj 17,

sum_vchar8_pair:
	move 4,1
	andi 4,17
	move 3,1
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 4,[POINT 8,vs8,7]
	jumpe 3,%L245
%L244:
	ibp 4
	sojn 3,%L244	; decrement_and_branch_until_zero
%L245:
	ldb 4,4
	move 2,4
	trne 2,200
	orcmi 2,377
	move 4,1
	addi 4,4
	move 3,4
	andi 3,3
	move 1,4
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 8,vs8,7]
	jumpe 3,%L247
%L246:
	ibp 1
	sojn 3,%L246	; decrement_and_branch_until_zero
%L247:
	ldb 4,1
	trne 4,200
	orcmi 4,377
	add 2,4
	move 1,2
	popj 17,

sum_vuchar8_pair:
	move 4,1
	andi 4,17
	move 3,1
	andi 3,3
	ash 4,-2	; ashrsi3_pointer
	add 4,[POINT 8,vu8,7]
	jumpe 3,%L250
%L249:
	ibp 4
	sojn 3,%L249	; decrement_and_branch_until_zero
%L250:
	ldb 4,4
	move 2,4
	move 4,1
	addi 4,4
	move 3,4
	andi 3,3
	move 1,4
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 8,vu8,7]
	jumpe 3,%L252
%L251:
	ibp 1
	sojn 3,%L251	; decrement_and_branch_until_zero
%L252:
	ldb 4,1
	add 2,4
	move 1,2
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
	move 3,b8a(1)
	ash 3,-34
	move 4,b8a(1)
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
	dpb 2,[POINT 8,b8a(1),7]
	addi 2,3
	dpb 2,[POINT 8,b8a(1),31]
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
	move 7,1
	andi 1,17
	move 3,7
	andi 3,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 8,s8,7]
	jumpe 3,%L283
%L282:
	ibp 1
	sojn 3,%L282	; decrement_and_branch_until_zero
%L283:
	ldb 6,1
	trne 6,200
	orcmi 6,377
	move 4,6
	add 4,2
	move 6,4
	lsh 6,34
	ash 6,-34
	move 4,7
	aos 3,4
	andi 3,3
	move 1,4
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 8,s8,7]
	jumpe 3,%L285
%L284:
	ibp 1
	sojn 3,%L284	; decrement_and_branch_until_zero
%L285:
	dpb 6,1
	lsh 6,34
	ash 6,-34
	move 1,6
	popj 17,

uchar8_plus:
	move 7,1
	andi 1,17
	move 3,7
	andi 3,3
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 8,u8,7]
	jumpe 3,%L288
%L287:
	ibp 1
	sojn 3,%L287	; decrement_and_branch_until_zero
%L288:
	ldb 6,1
	move 4,6
	add 4,2
	move 6,4
	andi 6,377
	move 4,7
	aos 3,4
	andi 3,3
	move 1,4
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 8,u8,7]
	jumpe 3,%L290
%L289:
	ibp 1
	sojn 3,%L289	; decrement_and_branch_until_zero
%L290:
	dpb 6,1
	andi 6,377
	move 1,6
	popj 17,

char8_cmp_zero:
	move 4,1
	andi 4,3
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 8,s8,7]
	jumpe 4,%L293
%L292:
	ibp 1
	sojn 4,%L292	; decrement_and_branch_until_zero
%L293:
	ldb 4,1
	trne 4,200
	orcmi 4,377
	move 1,4
	lsh 1,33
	ash 1,-33
	seto 4,
	jumpl 1,%L291
	skipe 4,1
	movei 4,1
%L291:
	move 1,4
	popj 17,

uchar8_cmp_200:
	move 4,1
	andi 4,3
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 8,u8,7]
	jumpe 4,%L298
%L297:
	ibp 1
	sojn 4,%L297	; decrement_and_branch_until_zero
%L298:
	ldb 1,1
	seto 4,
	cail 1,0
	cail 1,200
	trna
	jrst %L296
	movei 6,200
	camn 1,6
	tdza 4,4
	movei 4,1
%L296:
	move 1,4
	popj 17,

char8_range:
	move 4,1
	andi 4,3
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 8,s8,7]
	jumpe 4,%L303
%L302:
	ibp 1
	sojn 4,%L302	; decrement_and_branch_until_zero
%L303:
	ldb 1,1
	trne 1,200
	orcmi 1,377
	caml 1,[-200]
	cail 1,600
	tdza 1,1
	movei 1,1
	popj 17,

uchar8_range:
	move 4,1
	andi 4,3
	andi 1,17
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 8,u8,7]
	jumpe 4,%L306
%L305:
	ibp 1
	sojn 4,%L305	; decrement_and_branch_until_zero
%L306:
	ldb 1,1
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
%L318:
	move 4,6
	andi 4,3
	move 3,6
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L314
%L313:
	ibp 3
	sojn 4,%L313	; decrement_and_branch_until_zero
%L314:
	ldb 4,3
	trne 4,200
	orcmi 4,377
	add 1,4
	addi 6,1
	sojge 2,%L318	; doloop_end
	popj 17,

sum_uchar8:
	move 7,1
	setzb 1,6
	caml 1,2
	popj 17,
	subi 2,1
%L330:
	move 4,6
	andi 4,3
	move 3,6
	ash 3,-2	; ashrsi3_pointer
	add 3,7
	jumpe 4,%L326
%L325:
	ibp 3
	sojn 4,%L325	; decrement_and_branch_until_zero
%L326:
	ldb 4,3
	add 1,4
	addi 6,1
	sojge 2,%L330	; doloop_end
	popj 17,

sum_char8_walk:
	movei 3,0
	move 4,2
	subi 2,1
	jumple 4,%L337
%L335:
	ldb 4,1
	trne 4,200
	orcmi 4,377
	add 3,4
	ibp 1
	move 4,2
	subi 2,1
	jumpg 4,%L335
%L337:
	move 1,3
	popj 17,

sum_uchar8_walk:
	movei 3,0
	move 4,2
	subi 2,1
	jumple 4,%L344
%L342:
	ldb 4,1
	add 3,4
	ibp 1
	move 4,2
	subi 2,1
	jumpg 4,%L342
%L344:
	move 1,3
	popj 17,

zero_char8:
	movei 6,0
	caml 6,2
	popj 17,
	movei 7,0
	subi 2,1
%L356:
	move 4,6
	andi 4,3
	move 3,6
	ash 3,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L352
%L351:
	ibp 3
	sojn 4,%L351	; decrement_and_branch_until_zero
%L352:
	dpb 7,3
	addi 6,1
	sojge 2,%L356	; doloop_end
	popj 17,

zero_uchar8:
	movei 6,0
	caml 6,2
	popj 17,
	movei 7,0
	subi 2,1
%L368:
	move 4,6
	andi 4,3
	move 3,6
	ash 3,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L364
%L363:
	ibp 3
	sojn 4,%L363	; decrement_and_branch_until_zero
%L364:
	dpb 7,3
	addi 6,1
	sojge 2,%L368	; doloop_end
	popj 17,

fill_char8:
	movei 7,0
	caml 7,2
	popj 17,
	subi 2,1
%L380:
	move 4,7
	andi 4,3
	move 6,7
	ash 6,-2	; ashrsi3_pointer
	add 6,1
	jumpe 4,%L376
%L375:
	ibp 6
	sojn 4,%L375	; decrement_and_branch_until_zero
%L376:
	dpb 3,6
	addi 3,1
	addi 7,1
	sojge 2,%L380	; doloop_end
	popj 17,

fill_uchar8:
	movei 7,0
	caml 7,2
	popj 17,
	subi 2,1
%L392:
	move 4,7
	andi 4,3
	move 6,7
	ash 6,-2	; ashrsi3_pointer
	add 6,1
	jumpe 4,%L388
%L387:
	ibp 6
	sojn 4,%L387	; decrement_and_branch_until_zero
%L388:
	dpb 3,6
	addi 3,1
	addi 7,1
	sojge 2,%L392	; doloop_end
	popj 17,

copy_char8_reverse:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	movei 1,0
	sojl 3,%L409	; decrement_and_branch_until_zero
%L407:
	move 5,3
	andi 5,3
	move 4,5
	move 2,3
	ash 2,-2	; ashrsi3_pointer
	move 7,10
	add 7,2
	jumpe 5,%L400
%L399:
	ibp 7
	sojn 4,%L399	; decrement_and_branch_until_zero
%L400:
	move 6,5
	move 4,11
	add 4,2
	jumpe 5,%L403
%L402:
	ibp 4
	sojn 6,%L402	; decrement_and_branch_until_zero
%L403:
	ldb 4,4
	dpb 4,7
	move 6,10
	add 6,2
	skipn 4,5
	jrst %L406
%L405:
	ibp 6
	sojn 4,%L405	; decrement_and_branch_until_zero
%L406:
	ldb 4,6
	trne 4,200
	orcmi 4,377
	add 1,4
	sojge 3,%L407	; decrement_and_branch_until_zero
%L409:
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
	sojl 3,%L426	; decrement_and_branch_until_zero
%L424:
	move 5,3
	andi 5,3
	move 4,5
	move 2,3
	ash 2,-2	; ashrsi3_pointer
	move 7,10
	add 7,2
	jumpe 5,%L417
%L416:
	ibp 7
	sojn 4,%L416	; decrement_and_branch_until_zero
%L417:
	move 6,5
	move 4,11
	add 4,2
	jumpe 5,%L420
%L419:
	ibp 4
	sojn 6,%L419	; decrement_and_branch_until_zero
%L420:
	ldb 4,4
	dpb 4,7
	move 6,10
	add 6,2
	skipn 4,5
	jrst %L423
%L422:
	ibp 6
	sojn 4,%L422	; decrement_and_branch_until_zero
%L423:
	ldb 4,6
	add 1,4
	sojge 3,%L424	; decrement_and_branch_until_zero
%L426:
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

add_char8_pointer:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L430
%L429:
	ibp 1
	sojn 4,%L429	; decrement_and_branch_until_zero
%L430:
	popj 17,

add_uchar8_pointer:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L434
%L433:
	ibp 1
	sojn 4,%L433	; decrement_and_branch_until_zero
%L434:
	popj 17,

sub_char8_pointer:
	movn 2,2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L438
%L437:
	ibp 1
	sojn 4,%L437	; decrement_and_branch_until_zero
%L438:
	popj 17,

sub_uchar8_pointer:
	movn 2,2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L442
%L441:
	ibp 1
	sojn 4,%L441	; decrement_and_branch_until_zero
%L442:
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
