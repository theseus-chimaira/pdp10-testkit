
load1_Qint:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L4
%L3:
	ibp 1
	sojn 4,%L3	; decrement_and_branch_until_zero
%L4:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

load2_Qint:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,AQint,8]
	jumpe 4,%L7
%L6:
	ibp 3
	sojn 4,%L6	; decrement_and_branch_until_zero
%L7:
	ldb 1,3
	trne 1,400
	orcmi 1,777
	popj 17,

store1_Qint:
	andi 3,777	; zero_extendqisi2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L11
%L10:
	ibp 1
	sojn 4,%L10	; decrement_and_branch_until_zero
%L11:
	dpb 3,1
	popj 17,

store2_Qint:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,AQint,8]
	jumpe 4,%L14
%L13:
	ibp 3
	sojn 4,%L13	; decrement_and_branch_until_zero
%L14:
	dpb 2,3
	popj 17,

load1_uQint:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L18
%L17:
	ibp 1
	sojn 4,%L17	; decrement_and_branch_until_zero
%L18:
	ldb 1,1
	popj 17,

load2_uQint:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,AuQint,8]
	jumpe 4,%L21
%L20:
	ibp 3
	sojn 4,%L20	; decrement_and_branch_until_zero
%L21:
	ldb 1,3
	popj 17,

store1_uQint:
	andi 3,777	; zero_extendqisi2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L25
%L24:
	ibp 1
	sojn 4,%L24	; decrement_and_branch_until_zero
%L25:
	dpb 3,1
	popj 17,

store2_uQint:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,AuQint,8]
	jumpe 4,%L28
%L27:
	ibp 3
	sojn 4,%L27	; decrement_and_branch_until_zero
%L28:
	dpb 2,3
	popj 17,

load1_Hint:
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L32
%L31:
	ibp 1
	sojn 4,%L31	; decrement_and_branch_until_zero
%L32:
	ldb 1,1
	hrre 1,1
	popj 17,

load2_Hint:
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,AHint,17]
	jumpe 4,%L35
%L34:
	ibp 3
	sojn 4,%L34	; decrement_and_branch_until_zero
%L35:
	ldb 1,3
	hrre 1,1
	popj 17,

store1_Hint:
	hrrzi 3,(3)	; zero_extendhisi2
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L39
%L38:
	ibp 1
	sojn 4,%L38	; decrement_and_branch_until_zero
%L39:
	dpb 3,1	; movhi
	popj 17,

store2_Hint:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,AHint,17]
	jumpe 4,%L42
%L41:
	ibp 3
	sojn 4,%L41	; decrement_and_branch_until_zero
%L42:
	dpb 2,3	; movhi
	popj 17,

load1_uHint:
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L46
%L45:
	ibp 1
	sojn 4,%L45	; decrement_and_branch_until_zero
%L46:
	ldb 1,1
	popj 17,

load2_uHint:
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,AuHint,17]
	jumpe 4,%L49
%L48:
	ibp 3
	sojn 4,%L48	; decrement_and_branch_until_zero
%L49:
	ldb 1,3
	popj 17,

store1_uHint:
	hrrzi 3,(3)	; zero_extendhisi2
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L53
%L52:
	ibp 1
	sojn 4,%L52	; decrement_and_branch_until_zero
%L53:
	dpb 3,1	; movhi
	popj 17,

store2_uHint:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,AuHint,17]
	jumpe 4,%L56
%L55:
	ibp 3
	sojn 4,%L55	; decrement_and_branch_until_zero
%L56:
	dpb 2,3	; movhi
	popj 17,

load1_Sint:
	add 1,2
	move 1,(1)
	popj 17,

load2_Sint:
	move 1,ASint(1)
	popj 17,

store1_Sint:
	add 1,2
	movem 3,(1)
	popj 17,

store2_Sint:
	movem 2,ASint(1)
	popj 17,

load1_uSint:
	add 1,2
	move 1,(1)
	popj 17,

load2_uSint:
	move 1,AuSint(1)
	popj 17,

store1_uSint:
	add 1,2
	movem 3,(1)
	popj 17,

store2_uSint:
	movem 2,AuSint(1)
	popj 17,

load1_Dint:
	lsh 2,1
	add 2,1
	move 4,(2)
	move 5,1(2)
	move 1,4
	move 2,5
	popj 17,

load2_Dint:
	lsh 1,1
	move 4,ADint(1)
	move 5,ADint+1(1)
	move 1,4
	move 2,5
	popj 17,

store1_Dint:
	lsh 2,1
	add 2,1
	movem 3,(2)
	movem 4,1(2)
	popj 17,

store2_Dint:
	lsh 1,1
	movem 2,ADint(1)
	movem 3,ADint+1(1)
	popj 17,

load1_uDint:
	lsh 2,1
	add 2,1
	move 4,(2)
	move 5,1(2)
	move 1,4
	move 2,5
	popj 17,

load2_uDint:
	lsh 1,1
	move 4,AuDint(1)
	move 5,AuDint+1(1)
	move 1,4
	move 2,5
	popj 17,

store1_uDint:
	lsh 2,1
	add 2,1
	movem 3,(2)
	movem 4,1(2)
	popj 17,

store2_uDint:
	lsh 1,1
	movem 2,AuDint(1)
	movem 3,AuDint+1(1)
	popj 17,

q_load_0:
	move 1,AQint
	ash 1,-33
	popj 17,

q_load_1:
	move 1,AQint
	lsh 1,11
	ash 1,-33
	popj 17,

q_load_2:
	move 1,AQint
	lsh 1,22
	ash 1,-33
	popj 17,

q_load_3:
	move 1,AQint
	lsh 1,33
	ash 1,-33
	popj 17,

q_load_4:
	move 1,AQint+1
	ash 1,-33
	popj 17,

q_load_7:
	move 1,AQint+1
	lsh 1,33
	ash 1,-33
	popj 17,

q_load_010:
	move 1,AQint+2
	ash 1,-33
	popj 17,

q_load_077:
	move 1,AQint+17
	lsh 1,33
	ash 1,-33
	popj 17,

uq_load_077:
	move 1,AuQint+17
	andi 1,777
	popj 17,

h_load_077:
	hrre 1,AHint+37
	popj 17,

uh_load_077:
	hrrz 1,AuHint+37
	popj 17,

s_load_077:
	move 1,ASint+77
	popj 17,

us_load_077:
	move 1,AuSint+77
	popj 17,

d_load_077:
	move 1,ADint+176
	move 2,ADint+177
	popj 17,

ud_load_077:
	move 1,AuDint+176
	move 2,AuDint+177
	popj 17,

q_store_0:
	dpb 1,[POINT 9,AQint,8]
	popj 17,

q_store_1:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,AQint,17]
	popj 17,

q_store_2:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,AQint,26]
	popj 17,

q_store_3:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,AQint,35]
	popj 17,

q_store_4:
	dpb 1,[POINT 9,AQint+1,8]
	popj 17,

q_store_7:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,AQint+1,35]
	popj 17,

q_store_010:
	dpb 1,[POINT 9,AQint+2,8]
	popj 17,

q_store_077:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,AQint+17,35]
	popj 17,

uq_store_077:
	andi 1,777	; zero_extendqisi2
	dpb 1,[POINT 9,AuQint+17,35]
	popj 17,

h_store_077:
	hrrm 1,AHint+37
	popj 17,

uh_store_077:
	hrrm 1,AuHint+37
	popj 17,

s_store_077:
	movem 1,ASint+77
	popj 17,

us_store_077:
	movem 1,AuSint+77
	popj 17,

d_store_077:
	movem 1,ADint+176
	movem 2,ADint+177
	popj 17,

ud_store_077:
	movem 1,AuDint+176
	movem 2,AuDint+177
	popj 17,

q_load_i:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,AQint,8]
	jumpe 4,%L113
%L112:
	ibp 3
	sojn 4,%L112	; decrement_and_branch_until_zero
%L113:
	ldb 1,3
	trne 1,400
	orcmi 1,777
	popj 17,

uq_load_i:
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,AuQint,8]
	jumpe 4,%L116
%L115:
	ibp 3
	sojn 4,%L115	; decrement_and_branch_until_zero
%L116:
	ldb 1,3
	popj 17,

h_load_i:
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,AHint,17]
	jumpe 4,%L119
%L118:
	ibp 3
	sojn 4,%L118	; decrement_and_branch_until_zero
%L119:
	ldb 1,3
	hrre 1,1
	popj 17,

uh_load_i:
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,AuHint,17]
	jumpe 4,%L122
%L121:
	ibp 3
	sojn 4,%L121	; decrement_and_branch_until_zero
%L122:
	ldb 1,3
	popj 17,

s_load_i:
	move 1,ASint(1)
	popj 17,

us_load_i:
	move 1,AuSint(1)
	popj 17,

d_load_i:
	lsh 1,1
	move 4,ADint(1)
	move 5,ADint+1(1)
	move 1,4
	move 2,5
	popj 17,

ud_load_i:
	lsh 1,1
	move 4,AuDint(1)
	move 5,AuDint+1(1)
	move 1,4
	move 2,5
	popj 17,

q_store_i:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,AQint,8]
	jumpe 4,%L129
%L128:
	ibp 3
	sojn 4,%L128	; decrement_and_branch_until_zero
%L129:
	dpb 2,3
	popj 17,

uq_store_i:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	move 3,1
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,AuQint,8]
	jumpe 4,%L132
%L131:
	ibp 3
	sojn 4,%L131	; decrement_and_branch_until_zero
%L132:
	dpb 2,3
	popj 17,

h_store_i:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,AHint,17]
	jumpe 4,%L135
%L134:
	ibp 3
	sojn 4,%L134	; decrement_and_branch_until_zero
%L135:
	dpb 2,3	; movhi
	popj 17,

uh_store_i:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,1
	andi 4,1
	move 3,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,AuHint,17]
	jumpe 4,%L138
%L137:
	ibp 3
	sojn 4,%L137	; decrement_and_branch_until_zero
%L138:
	dpb 2,3	; movhi
	popj 17,

s_store_i:
	movem 2,ASint(1)
	popj 17,

us_store_i:
	movem 2,AuSint(1)
	popj 17,

d_store_i:
	lsh 1,1
	movem 2,ADint(1)
	movem 3,ADint+1(1)
	popj 17,

ud_store_i:
	lsh 1,1
	movem 2,AuDint(1)
	movem 3,AuDint+1(1)
	popj 17,

q_load_masked:
	move 4,1
	andi 4,3
	andi 1,77
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,AQint,8]
	jumpe 4,%L145
%L144:
	ibp 1
	sojn 4,%L144	; decrement_and_branch_until_zero
%L145:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

uq_load_masked:
	move 4,1
	andi 4,3
	andi 1,77
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,AuQint,8]
	jumpe 4,%L148
%L147:
	ibp 1
	sojn 4,%L147	; decrement_and_branch_until_zero
%L148:
	ldb 1,1
	popj 17,

h_load_masked:
	move 4,1
	andi 4,1
	andi 1,77
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,AHint,17]
	jumpe 4,%L151
%L150:
	ibp 1
	sojn 4,%L150	; decrement_and_branch_until_zero
%L151:
	ldb 1,1
	hrre 1,1
	popj 17,

uh_load_masked:
	move 4,1
	andi 4,1
	andi 1,77
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,AuHint,17]
	jumpe 4,%L154
%L153:
	ibp 1
	sojn 4,%L153	; decrement_and_branch_until_zero
%L154:
	ldb 1,1
	popj 17,

s_load_masked:
	andi 1,77
	move 1,ASint(1)
	popj 17,

us_load_masked:
	andi 1,77
	move 1,AuSint(1)
	popj 17,

d_load_masked:
	andi 1,77
	lsh 1,1
	move 4,ADint(1)
	move 5,ADint+1(1)
	move 1,4
	move 2,5
	popj 17,

ud_load_masked:
	andi 1,77
	lsh 1,1
	move 4,AuDint(1)
	move 5,AuDint+1(1)
	move 1,4
	move 2,5
	popj 17,

q_store_masked:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	andi 1,77
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,AQint,8]
	jumpe 4,%L161
%L160:
	ibp 1
	sojn 4,%L160	; decrement_and_branch_until_zero
%L161:
	dpb 2,1
	popj 17,

uq_store_masked:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	andi 1,77
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,AuQint,8]
	jumpe 4,%L164
%L163:
	ibp 1
	sojn 4,%L163	; decrement_and_branch_until_zero
%L164:
	dpb 2,1
	popj 17,

h_store_masked:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,1
	andi 4,1
	andi 1,77
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,AHint,17]
	jumpe 4,%L167
%L166:
	ibp 1
	sojn 4,%L166	; decrement_and_branch_until_zero
%L167:
	dpb 2,1	; movhi
	popj 17,

uh_store_masked:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,1
	andi 4,1
	andi 1,77
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,AuHint,17]
	jumpe 4,%L170
%L169:
	ibp 1
	sojn 4,%L169	; decrement_and_branch_until_zero
%L170:
	dpb 2,1	; movhi
	popj 17,

s_store_masked:
	andi 1,77
	movem 2,ASint(1)
	popj 17,

us_store_masked:
	andi 1,77
	movem 2,AuSint(1)
	popj 17,

d_store_masked:
	andi 1,77
	lsh 1,1
	movem 2,ADint(1)
	movem 3,ADint+1(1)
	popj 17,

ud_store_masked:
	andi 1,77
	lsh 1,1
	movem 2,AuDint(1)
	movem 3,AuDint+1(1)
	popj 17,

q_ptr_load_i:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L178
%L177:
	ibp 1
	sojn 4,%L177	; decrement_and_branch_until_zero
%L178:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

uq_ptr_load_i:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L182
%L181:
	ibp 1
	sojn 4,%L181	; decrement_and_branch_until_zero
%L182:
	ldb 1,1
	popj 17,

h_ptr_load_i:
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L186
%L185:
	ibp 1
	sojn 4,%L185	; decrement_and_branch_until_zero
%L186:
	ldb 1,1
	hrre 1,1
	popj 17,

uh_ptr_load_i:
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L190
%L189:
	ibp 1
	sojn 4,%L189	; decrement_and_branch_until_zero
%L190:
	ldb 1,1
	popj 17,

s_ptr_load_i:
	add 1,2
	move 1,(1)
	popj 17,

us_ptr_load_i:
	add 1,2
	move 1,(1)
	popj 17,

d_ptr_load_i:
	lsh 2,1
	add 2,1
	move 4,(2)
	move 5,1(2)
	move 1,4
	move 2,5
	popj 17,

ud_ptr_load_i:
	lsh 2,1
	add 2,1
	move 4,(2)
	move 5,1(2)
	move 1,4
	move 2,5
	popj 17,

q_ptr_store_i:
	andi 3,777	; zero_extendqisi2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L202
%L201:
	ibp 1
	sojn 4,%L201	; decrement_and_branch_until_zero
%L202:
	dpb 3,1
	popj 17,

uq_ptr_store_i:
	andi 3,777	; zero_extendqisi2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L206
%L205:
	ibp 1
	sojn 4,%L205	; decrement_and_branch_until_zero
%L206:
	dpb 3,1
	popj 17,

h_ptr_store_i:
	hrrzi 3,(3)	; zero_extendhisi2
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L210
%L209:
	ibp 1
	sojn 4,%L209	; decrement_and_branch_until_zero
%L210:
	dpb 3,1	; movhi
	popj 17,

uh_ptr_store_i:
	hrrzi 3,(3)	; zero_extendhisi2
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L214
%L213:
	ibp 1
	sojn 4,%L213	; decrement_and_branch_until_zero
%L214:
	dpb 3,1	; movhi
	popj 17,

s_ptr_store_i:
	add 1,2
	movem 3,(1)
	popj 17,

us_ptr_store_i:
	add 1,2
	movem 3,(1)
	popj 17,

d_ptr_store_i:
	lsh 2,1
	add 2,1
	movem 3,(2)
	movem 4,1(2)
	popj 17,

ud_ptr_store_i:
	lsh 2,1
	add 2,1
	movem 3,(2)
	movem 4,1(2)
	popj 17,

q_load_i_plus_1:
	aos 4,1
	andi 4,3
	andi 1,77
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,AQint,8]
	jumpe 4,%L225
%L224:
	ibp 1
	sojn 4,%L224	; decrement_and_branch_until_zero
%L225:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

q_load_i_plus_2:
	addi 1,2
	move 4,1
	andi 4,3
	andi 1,77
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,AQint,8]
	jumpe 4,%L228
%L227:
	ibp 1
	sojn 4,%L227	; decrement_and_branch_until_zero
%L228:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

q_load_i_minus_1:
	sos 4,1
	andi 4,3
	andi 1,77
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,AQint,8]
	jumpe 4,%L231
%L230:
	ibp 1
	sojn 4,%L230	; decrement_and_branch_until_zero
%L231:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

q_load_sum_index:
	add 1,2
	move 4,1
	andi 4,3
	andi 1,77
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,AQint,8]
	jumpe 4,%L234
%L233:
	ibp 1
	sojn 4,%L233	; decrement_and_branch_until_zero
%L234:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

q_load_diff_index:
	sub 1,2
	move 4,1
	andi 4,3
	andi 1,77
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,AQint,8]
	jumpe 4,%L237
%L236:
	ibp 1
	sojn 4,%L236	; decrement_and_branch_until_zero
%L237:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

h_load_i_plus_1:
	aos 4,1
	andi 4,1
	andi 1,77
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,AHint,17]
	jumpe 4,%L240
%L239:
	ibp 1
	sojn 4,%L239	; decrement_and_branch_until_zero
%L240:
	ldb 1,1
	hrre 1,1
	popj 17,

h_load_i_plus_2:
	addi 1,2
	move 4,1
	andi 4,1
	andi 1,77
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,AHint,17]
	jumpe 4,%L243
%L242:
	ibp 1
	sojn 4,%L242	; decrement_and_branch_until_zero
%L243:
	ldb 1,1
	hrre 1,1
	popj 17,

h_load_i_minus_1:
	sos 4,1
	andi 4,1
	andi 1,77
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,AHint,17]
	jumpe 4,%L246
%L245:
	ibp 1
	sojn 4,%L245	; decrement_and_branch_until_zero
%L246:
	ldb 1,1
	hrre 1,1
	popj 17,

h_load_sum_index:
	add 1,2
	move 4,1
	andi 4,1
	andi 1,77
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,AHint,17]
	jumpe 4,%L249
%L248:
	ibp 1
	sojn 4,%L248	; decrement_and_branch_until_zero
%L249:
	ldb 1,1
	hrre 1,1
	popj 17,

s_load_i_plus_1:
	addi 1,1
	andi 1,77
	move 1,ASint(1)
	popj 17,

s_load_i_plus_2:
	addi 1,2
	andi 1,77
	move 1,ASint(1)
	popj 17,

s_load_i_minus_1:
	subi 1,1
	andi 1,77
	move 1,ASint(1)
	popj 17,

s_load_sum_index:
	add 1,2
	andi 1,77
	move 1,ASint(1)
	popj 17,

d_load_i_plus_1:
	addi 1,1
	andi 1,77
	lsh 1,1
	move 4,ADint(1)
	move 5,ADint+1(1)
	move 1,4
	move 2,5
	popj 17,

d_load_i_plus_2:
	addi 1,2
	andi 1,77
	lsh 1,1
	move 4,ADint(1)
	move 5,ADint+1(1)
	move 1,4
	move 2,5
	popj 17,

d_load_i_minus_1:
	subi 1,1
	andi 1,77
	lsh 1,1
	move 4,ADint(1)
	move 5,ADint+1(1)
	move 1,4
	move 2,5
	popj 17,

q_store_i_plus_1:
	andi 2,777	; zero_extendqisi2
	aos 4,1
	andi 4,3
	andi 1,77
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,AQint,8]
	jumpe 4,%L259
%L258:
	ibp 1
	sojn 4,%L258	; decrement_and_branch_until_zero
%L259:
	dpb 2,1
	popj 17,

q_store_i_plus_2:
	andi 2,777	; zero_extendqisi2
	addi 1,2
	move 4,1
	andi 4,3
	andi 1,77
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,AQint,8]
	jumpe 4,%L262
%L261:
	ibp 1
	sojn 4,%L261	; decrement_and_branch_until_zero
%L262:
	dpb 2,1
	popj 17,

q_store_i_minus_1:
	andi 2,777	; zero_extendqisi2
	sos 4,1
	andi 4,3
	andi 1,77
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,AQint,8]
	jumpe 4,%L265
%L264:
	ibp 1
	sojn 4,%L264	; decrement_and_branch_until_zero
%L265:
	dpb 2,1
	popj 17,

q_store_sum_index:
	andi 3,777	; zero_extendqisi2
	add 1,2
	move 4,1
	andi 4,3
	andi 1,77
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,AQint,8]
	jumpe 4,%L268
%L267:
	ibp 1
	sojn 4,%L267	; decrement_and_branch_until_zero
%L268:
	dpb 3,1
	popj 17,

h_store_i_plus_1:
	hrrzi 2,(2)	; zero_extendhisi2
	aos 4,1
	andi 4,1
	andi 1,77
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,AHint,17]
	jumpe 4,%L271
%L270:
	ibp 1
	sojn 4,%L270	; decrement_and_branch_until_zero
%L271:
	dpb 2,1	; movhi
	popj 17,

h_store_i_plus_2:
	hrrzi 2,(2)	; zero_extendhisi2
	addi 1,2
	move 4,1
	andi 4,1
	andi 1,77
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,AHint,17]
	jumpe 4,%L274
%L273:
	ibp 1
	sojn 4,%L273	; decrement_and_branch_until_zero
%L274:
	dpb 2,1	; movhi
	popj 17,

h_store_i_minus_1:
	hrrzi 2,(2)	; zero_extendhisi2
	sos 4,1
	andi 4,1
	andi 1,77
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,AHint,17]
	jumpe 4,%L277
%L276:
	ibp 1
	sojn 4,%L276	; decrement_and_branch_until_zero
%L277:
	dpb 2,1	; movhi
	popj 17,

s_store_i_plus_1:
	addi 1,1
	andi 1,77
	movem 2,ASint(1)
	popj 17,

s_store_i_plus_2:
	addi 1,2
	andi 1,77
	movem 2,ASint(1)
	popj 17,

s_store_i_minus_1:
	subi 1,1
	andi 1,77
	movem 2,ASint(1)
	popj 17,

d_store_i_plus_1:
	addi 1,1
	andi 1,77
	lsh 1,1
	movem 2,ADint(1)
	movem 3,ADint+1(1)
	popj 17,

d_store_i_plus_2:
	addi 1,2
	andi 1,77
	lsh 1,1
	movem 2,ADint(1)
	movem 3,ADint+1(1)
	popj 17,

q_store_i_return:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	andi 1,77
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,AQint,8]
	jumpe 4,%L285
%L284:
	ibp 1
	sojn 4,%L284	; decrement_and_branch_until_zero
%L285:
	dpb 2,1
	move 1,2
	lsh 1,33
	ash 1,-33
	popj 17,

uq_store_i_return:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	andi 1,77
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,AuQint,8]
	jumpe 4,%L288
%L287:
	ibp 1
	sojn 4,%L287	; decrement_and_branch_until_zero
%L288:
	dpb 2,1
	move 1,2
	popj 17,

h_store_i_return:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,1
	andi 4,1
	andi 1,77
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,AHint,17]
	jumpe 4,%L291
%L290:
	ibp 1
	sojn 4,%L290	; decrement_and_branch_until_zero
%L291:
	dpb 2,1	; movhi
	hrre 1,2
	popj 17,

uh_store_i_return:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,1
	andi 4,1
	andi 1,77
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,AuHint,17]
	jumpe 4,%L294
%L293:
	ibp 1
	sojn 4,%L293	; decrement_and_branch_until_zero
%L294:
	dpb 2,1	; movhi
	move 1,2
	popj 17,

s_store_i_return:
	andi 1,77
	movem 2,ASint(1)
	move 1,2
	popj 17,

us_store_i_return:
	andi 1,77
	movem 2,AuSint(1)
	move 1,2
	popj 17,

d_store_i_return:
	andi 1,77
	lsh 1,1
	movem 2,ADint(1)
	movem 3,ADint+1(1)
	move 1,2
	move 2,3
	popj 17,

ud_store_i_return:
	andi 1,77
	lsh 1,1
	movem 2,AuDint(1)
	movem 3,AuDint+1(1)
	move 1,2
	move 2,3
	popj 17,

vq_load_i:
	move 4,1
	andi 4,3
	andi 1,77
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,VAQint,8]
	jumpe 4,%L301
%L300:
	ibp 1
	sojn 4,%L300	; decrement_and_branch_until_zero
%L301:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

vuq_load_i:
	move 4,1
	andi 4,3
	andi 1,77
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,VAuQint,8]
	jumpe 4,%L304
%L303:
	ibp 1
	sojn 4,%L303	; decrement_and_branch_until_zero
%L304:
	ldb 1,1
	popj 17,

vh_load_i:
	move 4,1
	andi 4,1
	andi 1,77
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,VAHint,17]
	jumpe 4,%L307
%L306:
	ibp 1
	sojn 4,%L306	; decrement_and_branch_until_zero
%L307:
	ldb 1,1
	hrre 1,1
	popj 17,

vuh_load_i:
	move 4,1
	andi 4,1
	andi 1,77
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,VAuHint,17]
	jumpe 4,%L310
%L309:
	ibp 1
	sojn 4,%L309	; decrement_and_branch_until_zero
%L310:
	ldb 1,1
	popj 17,

vs_load_i:
	andi 1,77
	move 1,VASint(1)
	popj 17,

vus_load_i:
	andi 1,77
	move 1,VAuSint(1)
	popj 17,

vd_load_i:
	andi 1,77
	lsh 1,1
	move 4,VADint(1)
	move 5,VADint+1(1)
	move 1,4
	move 2,5
	popj 17,

vud_load_i:
	andi 1,77
	lsh 1,1
	move 4,VAuDint(1)
	move 5,VAuDint+1(1)
	move 1,4
	move 2,5
	popj 17,

vq_store_i:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	andi 1,77
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,VAQint,8]
	jumpe 4,%L317
%L316:
	ibp 1
	sojn 4,%L316	; decrement_and_branch_until_zero
%L317:
	dpb 2,1
	popj 17,

vuq_store_i:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	andi 1,77
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,VAuQint,8]
	jumpe 4,%L320
%L319:
	ibp 1
	sojn 4,%L319	; decrement_and_branch_until_zero
%L320:
	dpb 2,1
	popj 17,

vh_store_i:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,1
	andi 4,1
	andi 1,77
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,VAHint,17]
	jumpe 4,%L323
%L322:
	ibp 1
	sojn 4,%L322	; decrement_and_branch_until_zero
%L323:
	dpb 2,1	; movhi
	popj 17,

vuh_store_i:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,1
	andi 4,1
	andi 1,77
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,VAuHint,17]
	jumpe 4,%L326
%L325:
	ibp 1
	sojn 4,%L325	; decrement_and_branch_until_zero
%L326:
	dpb 2,1	; movhi
	popj 17,

vs_store_i:
	andi 1,77
	movem 2,VASint(1)
	popj 17,

vus_store_i:
	andi 1,77
	movem 2,VAuSint(1)
	popj 17,

vd_store_i:
	andi 1,77
	lsh 1,1
	movem 2,VADint(1)
	movem 3,VADint+1(1)
	popj 17,

vud_store_i:
	andi 1,77
	lsh 1,1
	movem 2,VAuDint(1)
	movem 3,VAuDint+1(1)
	popj 17,

q_addr_i:
	move 4,1
	andi 4,3
	andi 1,77
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,AQint,8]
	jumpe 4,%L335
%L334:
	ibp 1
	sojn 4,%L334	; decrement_and_branch_until_zero
%L335:
	popj 17,

uq_addr_i:
	move 4,1
	andi 4,3
	andi 1,77
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,AuQint,8]
	jumpe 4,%L340
%L339:
	ibp 1
	sojn 4,%L339	; decrement_and_branch_until_zero
%L340:
	popj 17,

h_addr_i:
	move 4,1
	andi 4,1
	andi 1,77
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,AHint,17]
	jumpe 4,%L345
%L344:
	ibp 1
	sojn 4,%L344	; decrement_and_branch_until_zero
%L345:
	popj 17,

uh_addr_i:
	move 4,1
	andi 4,1
	andi 1,77
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,AuHint,17]
	jumpe 4,%L350
%L349:
	ibp 1
	sojn 4,%L349	; decrement_and_branch_until_zero
%L350:
	popj 17,

s_addr_i:
	andi 1,77
	xmovei 1,ASint(1)
	popj 17,

us_addr_i:
	andi 1,77
	xmovei 1,AuSint(1)
	popj 17,

d_addr_i:
	andi 1,77
	lsh 1,1
	xmovei 1,ADint(1)
	popj 17,

ud_addr_i:
	andi 1,77
	lsh 1,1
	xmovei 1,AuDint(1)
	popj 17,

q_ptr_addr_i:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L366
%L365:
	ibp 1
	sojn 4,%L365	; decrement_and_branch_until_zero
%L366:
	popj 17,

h_ptr_addr_i:
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L370
%L369:
	ibp 1
	sojn 4,%L369	; decrement_and_branch_until_zero
%L370:
	popj 17,

s_ptr_addr_i:
	add 1,2
	popj 17,

d_ptr_addr_i:
	lsh 2,1
	add 1,2
	popj 17,

q_addr_load_i:
	move 4,1
	andi 4,3
	andi 1,77
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,AQint,8]
	jumpe 4,%L379
%L378:
	ibp 1
	sojn 4,%L378	; decrement_and_branch_until_zero
%L379:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

h_addr_load_i:
	move 4,1
	andi 4,1
	andi 1,77
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,AHint,17]
	jumpe 4,%L384
%L383:
	ibp 1
	sojn 4,%L383	; decrement_and_branch_until_zero
%L384:
	ldb 1,1
	hrre 1,1
	popj 17,

s_addr_load_i:
	andi 1,77
	move 1,ASint(1)
	popj 17,

d_addr_load_i:
	andi 1,77
	lsh 1,1
	move 4,ADint(1)
	move 5,ADint+1(1)
	move 1,4
	move 2,5
	popj 17,

q_addr_store_i:
	andi 2,777	; zero_extendqisi2
	move 4,1
	andi 4,3
	andi 1,77
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,AQint,8]
	jumpe 4,%L395
%L394:
	ibp 1
	sojn 4,%L394	; decrement_and_branch_until_zero
%L395:
	dpb 2,1
	popj 17,

h_addr_store_i:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,1
	andi 4,1
	andi 1,77
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,AHint,17]
	jumpe 4,%L400
%L399:
	ibp 1
	sojn 4,%L399	; decrement_and_branch_until_zero
%L400:
	dpb 2,1	; movhi
	popj 17,

s_addr_store_i:
	andi 1,77
	movem 2,ASint(1)
	popj 17,

d_addr_store_i:
	andi 1,77
	lsh 1,1
	movem 2,ADint(1)
	movem 3,ADint+1(1)
	popj 17,

q_inc_i:
	move 6,1
	andi 6,77
	move 2,1
	andi 2,3
	move 4,2
	move 3,6
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,AQint,8]
	jumpe 2,%L409
%L408:
	ibp 3
	sojn 4,%L408	; decrement_and_branch_until_zero
%L409:
	move 1,6
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,AQint,8]
	skipn 4,2
	jrst %L411
%L410:
	ibp 1
	sojn 4,%L410	; decrement_and_branch_until_zero
%L411:
	ldb 4,1
	addi 4,1
	dpb 4,3
	popj 17,

q_inc_i_return:
	move 6,1
	andi 6,77
	move 2,1
	andi 2,3
	move 4,2
	move 3,6
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,AQint,8]
	jumpe 2,%L414
%L413:
	ibp 3
	sojn 4,%L413	; decrement_and_branch_until_zero
%L414:
	move 1,6
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,AQint,8]
	skipn 4,2
	jrst %L416
%L415:
	ibp 1
	sojn 4,%L415	; decrement_and_branch_until_zero
%L416:
	ldb 1,1
	addi 1,1
	dpb 1,3
	lsh 1,33
	ash 1,-33
	popj 17,

uq_inc_i:
	move 6,1
	andi 6,77
	move 2,1
	andi 2,3
	move 4,2
	move 3,6
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,AuQint,8]
	jumpe 2,%L419
%L418:
	ibp 3
	sojn 4,%L418	; decrement_and_branch_until_zero
%L419:
	move 1,6
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,AuQint,8]
	skipn 4,2
	jrst %L421
%L420:
	ibp 1
	sojn 4,%L420	; decrement_and_branch_until_zero
%L421:
	ldb 4,1
	addi 4,1
	dpb 4,3
	popj 17,

uq_inc_i_return:
	move 6,1
	andi 6,77
	move 2,1
	andi 2,3
	move 4,2
	move 3,6
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,AuQint,8]
	jumpe 2,%L424
%L423:
	ibp 3
	sojn 4,%L423	; decrement_and_branch_until_zero
%L424:
	move 1,6
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,AuQint,8]
	skipn 4,2
	jrst %L426
%L425:
	ibp 1
	sojn 4,%L425	; decrement_and_branch_until_zero
%L426:
	ldb 1,1
	addi 1,1
	dpb 1,3
	andi 1,777
	popj 17,

h_inc_i:
	move 6,1
	andi 6,77
	move 2,1
	andi 2,1
	move 4,2
	move 3,6
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,AHint,17]
	jumpe 2,%L429
%L428:
	ibp 3
	sojn 4,%L428	; decrement_and_branch_until_zero
%L429:
	move 1,6
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,AHint,17]
	skipn 4,2
	jrst %L431
%L430:
	ibp 1
	sojn 4,%L430	; decrement_and_branch_until_zero
%L431:
	ldb 4,1
	addi 4,1
	dpb 4,3	; movhi
	popj 17,

h_inc_i_return:
	move 6,1
	andi 6,77
	move 2,1
	andi 2,1
	move 4,2
	move 3,6
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,AHint,17]
	jumpe 2,%L434
%L433:
	ibp 3
	sojn 4,%L433	; decrement_and_branch_until_zero
%L434:
	move 1,6
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,AHint,17]
	skipn 4,2
	jrst %L436
%L435:
	ibp 1
	sojn 4,%L435	; decrement_and_branch_until_zero
%L436:
	ldb 1,1
	addi 1,1
	dpb 1,3	; movhi
	hrre 1,1
	popj 17,

uh_inc_i:
	move 6,1
	andi 6,77
	move 2,1
	andi 2,1
	move 4,2
	move 3,6
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,AuHint,17]
	jumpe 2,%L439
%L438:
	ibp 3
	sojn 4,%L438	; decrement_and_branch_until_zero
%L439:
	move 1,6
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,AuHint,17]
	skipn 4,2
	jrst %L441
%L440:
	ibp 1
	sojn 4,%L440	; decrement_and_branch_until_zero
%L441:
	ldb 4,1
	addi 4,1
	dpb 4,3	; movhi
	popj 17,

uh_inc_i_return:
	move 6,1
	andi 6,77
	move 2,1
	andi 2,1
	move 4,2
	move 3,6
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,AuHint,17]
	jumpe 2,%L444
%L443:
	ibp 3
	sojn 4,%L443	; decrement_and_branch_until_zero
%L444:
	move 1,6
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,AuHint,17]
	skipn 4,2
	jrst %L446
%L445:
	ibp 1
	sojn 4,%L445	; decrement_and_branch_until_zero
%L446:
	ldb 1,1
	addi 1,1
	dpb 1,3	; movhi
	hrrz 1,1
	popj 17,

s_inc_i:
	andi 1,77
	aos ASint(1)
	popj 17,

s_inc_i_return:
	andi 1,77
	aos 4,ASint(1)
	move 1,4
	popj 17,

us_inc_i:
	andi 1,77
	aos AuSint(1)
	popj 17,

us_inc_i_return:
	andi 1,77
	aos 4,AuSint(1)
	move 1,4
	popj 17,

d_add_i:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	andi 1,77
	lsh 1,1
	xmovei 12,ADint(1)
	move 6,ADint(1)
	move 7,1(12)
	move 5,7
	add 5,3
	move 11,5
	tlc 11,400000
	move 10,7
	tlc 10,400000
	caml 11,10
	tdza 11,11
	movei 11,1
	move 4,6
	add 4,2
	add 11,4
	movem 11,ADint(1)
	movem 5,1(12)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

d_add_i_return:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 7,1
	move 10,2
	move 11,3
	andi 7,77
	lsh 7,1
	xmovei 12,ADint(7)
	move 4,ADint(7)
	move 5,1(12)
	move 2,5
	add 2,11
	move 6,2
	tlc 6,400000
	move 3,5
	tlc 3,400000
	caml 6,3
	tdza 6,6
	movei 6,1
	move 1,4
	add 1,10
	add 6,1
	move 1,6
	movem 6,ADint(7)
	movem 2,1(12)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

ud_add_i:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	andi 1,77
	lsh 1,1
	xmovei 12,AuDint(1)
	move 6,AuDint(1)
	move 7,1(12)
	move 5,7
	add 5,3
	move 11,5
	tlc 11,400000
	move 10,7
	tlc 10,400000
	caml 11,10
	tdza 11,11
	movei 11,1
	move 4,6
	add 4,2
	add 11,4
	movem 11,AuDint(1)
	movem 5,1(12)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

ud_add_i_return:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 7,1
	move 10,2
	move 11,3
	andi 7,77
	lsh 7,1
	xmovei 12,AuDint(7)
	move 4,AuDint(7)
	move 5,1(12)
	move 2,5
	add 2,11
	move 6,2
	tlc 6,400000
	move 3,5
	tlc 3,400000
	caml 6,3
	tdza 6,6
	movei 6,1
	move 1,4
	add 1,10
	add 6,1
	move 1,6
	movem 6,AuDint(7)
	movem 2,1(12)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

q_copy_in:
	movei 7,0
	caml 7,2
	popj 17,
	subi 2,1
%L468:
	move 6,7
	andi 6,77
	move 3,7
	andi 3,3
	move 4,3
	ash 6,-2	; ashrsi3_pointer
	add 6,[POINT 9,AQint,8]
	jumpe 3,%L461
%L460:
	ibp 6
	sojn 4,%L460	; decrement_and_branch_until_zero
%L461:
	move 4,7
	ash 4,-2	; ashrsi3_pointer
	add 4,1
	jumpe 3,%L464
%L463:
	ibp 4
	sojn 3,%L463	; decrement_and_branch_until_zero
%L464:
	ldb 4,4
	dpb 4,6
	addi 7,1
	sojge 2,%L468	; doloop_end
	popj 17,

q_copy_out:
	movei 7,0
	caml 7,2
	popj 17,
	subi 2,1
%L482:
	move 3,7
	andi 3,3
	move 4,3
	move 6,7
	ash 6,-2	; ashrsi3_pointer
	add 6,1
	jumpe 3,%L476
%L475:
	ibp 6
	sojn 4,%L475	; decrement_and_branch_until_zero
%L476:
	move 4,7
	andi 4,77
	ash 4,-2	; ashrsi3_pointer
	add 4,[POINT 9,AQint,8]
	jumpe 3,%L478
%L477:
	ibp 4
	sojn 3,%L477	; decrement_and_branch_until_zero
%L478:
	ldb 4,4
	dpb 4,6
	addi 7,1
	sojge 2,%L482	; doloop_end
	popj 17,

h_copy_in:
	movei 7,0
	caml 7,2
	popj 17,
	subi 2,1
%L496:
	move 6,7
	andi 6,77
	move 3,7
	andi 3,1
	move 4,3
	ash 6,-1	; ashrsi3_pointer
	add 6,[POINT 18,AHint,17]
	jumpe 3,%L489
%L488:
	ibp 6
	sojn 4,%L488	; decrement_and_branch_until_zero
%L489:
	move 4,7
	ash 4,-1	; ashrsi3_pointer
	add 4,1
	jumpe 3,%L492
%L491:
	ibp 4
	sojn 3,%L491	; decrement_and_branch_until_zero
%L492:
	ldb 4,4
	dpb 4,6	; movhi
	addi 7,1
	sojge 2,%L496	; doloop_end
	popj 17,

h_copy_out:
	movei 7,0
	caml 7,2
	popj 17,
	subi 2,1
%L510:
	move 3,7
	andi 3,1
	move 4,3
	move 6,7
	ash 6,-1	; ashrsi3_pointer
	add 6,1
	jumpe 3,%L504
%L503:
	ibp 6
	sojn 4,%L503	; decrement_and_branch_until_zero
%L504:
	move 4,7
	andi 4,77
	ash 4,-1	; ashrsi3_pointer
	add 4,[POINT 18,AHint,17]
	jumpe 3,%L506
%L505:
	ibp 4
	sojn 3,%L505	; decrement_and_branch_until_zero
%L506:
	ldb 4,4
	dpb 4,6	; movhi
	addi 7,1
	sojge 2,%L510	; doloop_end
	popj 17,

s_copy_in:
	movei 3,0
	caml 3,2
	popj 17,
	subi 2,1
%L520:
	move 4,3
	andi 4,77
	move 6,(1)
	movem 6,ASint(4)
	addi 1,1
	addi 3,1
	sojge 2,%L520	; doloop_end
	popj 17,

s_copy_out:
	movei 3,0
	caml 3,2
	popj 17,
	subi 2,1
%L530:
	move 4,3
	andi 4,77
	move 4,ASint(4)
	movem 4,(1)
	addi 1,1
	addi 3,1
	sojge 2,%L530	; doloop_end
	popj 17,

d_copy_in:
	movei 3,0
	caml 3,2
	popj 17,
	subi 2,1
%L540:
	move 4,3
	andi 4,77
	lsh 4,1
	move 6,(1)
	movem 6,ADint(4)
	move 6,1(1)
	movem 6,ADint+1(4)
	addi 1,2
	addi 3,1
	sojge 2,%L540	; doloop_end
	popj 17,

d_copy_out:
	movei 3,0
	caml 3,2
	popj 17,
	subi 2,1
%L550:
	move 4,3
	andi 4,77
	lsh 4,1
	move 6,ADint(4)
	movem 6,(1)
	move 4,ADint+1(4)
	movem 4,1(1)
	addi 1,2
	addi 3,1
	sojge 2,%L550	; doloop_end
	popj 17,

q_if_eq_zero:
	move 4,1
	andi 4,3
	andi 1,77
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,AQint,8]
	jumpe 4,%L554
%L553:
	ibp 1
	sojn 4,%L553	; decrement_and_branch_until_zero
%L554:
	ldb 1,1
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

q_if_lt_zero:
	move 4,1
	andi 4,3
	andi 1,77
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,AQint,8]
	jumpe 4,%L558
%L557:
	ibp 1
	sojn 4,%L557	; decrement_and_branch_until_zero
%L558:
	ldb 4,1
	trne 4,400
	orcmi 4,777
	seto 1,
	jumpl 4,%L555
	movei 1,1
%L555:
	popj 17,

uq_if_gt_0177:
	move 4,1
	andi 4,3
	andi 1,77
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,AuQint,8]
	jumpe 4,%L562
%L561:
	ibp 1
	sojn 4,%L561	; decrement_and_branch_until_zero
%L562:
	ldb 1,1
	tlo 1,400000
	move 6,[-377777777601]
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

h_if_eq_zero:
	move 4,1
	andi 4,1
	andi 1,77
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,AHint,17]
	jumpe 4,%L566
%L565:
	ibp 1
	sojn 4,%L565	; decrement_and_branch_until_zero
%L566:
	ldb 1,1
	skipe 1
	tdza 1,1
	movei 1,1
	popj 17,

h_if_lt_zero:
	move 4,1
	andi 4,1
	andi 1,77
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,AHint,17]
	jumpe 4,%L570
%L569:
	ibp 1
	sojn 4,%L569	; decrement_and_branch_until_zero
%L570:
	ldb 4,1
	hrre 4,4
	seto 1,
	jumpl 4,%L567
	movei 1,1
%L567:
	popj 17,

uh_if_gt_077777:
	move 4,1
	andi 4,1
	andi 1,77
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,AuHint,17]
	jumpe 4,%L574
%L573:
	ibp 1
	sojn 4,%L573	; decrement_and_branch_until_zero
%L574:
	ldb 1,1
	tlo 1,400000
	move 6,[-377777700001]
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

s_if_eq_zero:
	andi 1,77
	skipe ASint(1)
	tdza 1,1
	movei 1,1
	popj 17,

s_if_lt_zero:
	andi 1,77
	seto 4,
	skipl ASint(1)
	movei 4,1
	move 1,4
	popj 17,

d_if_eq:
	andi 1,77
	lsh 1,1
	xmovei 4,ADint(1)
	move 1,ADint(1)
	camn 1,2
	jrst %L581
%L580:
	movei 1,0
%L579:
	popj 17,
%L581:
	movei 1,1
	move 4,1(4)
	came 4,3
	jrst %L580
	popj 17,

qpair_load_a:
	andi 1,77
	move 1,Aqpair(1)
	ash 1,-33
	popj 17,

qpair_load_b:
	andi 1,77
	move 1,Aqpair(1)
	lsh 1,11
	ash 1,-33
	popj 17,

qpair_store_a:
	andi 1,77
	add 1,[POINT 9,Aqpair,8]
	dpb 2,[POINT 9,(1),8]
	popj 17,

qpair_store_b:
	andi 2,777	; zero_extendqisi2
	andi 1,77
	dpb 2,[POINT 9,Aqpair(1),17]
	popj 17,

hpair_load_a:
	andi 1,77
	hlre 1,Ahpair(1)
	popj 17,

hpair_load_b:
	andi 1,77
	hrre 1,Ahpair(1)
	popj 17,

hpair_store_a:
	andi 1,77
	add 1,[POINT 18,Ahpair,17]
	hrlm 2,(1)
	popj 17,

hpair_store_b:
	andi 1,77
	hrrm 2,Ahpair(1)
	popj 17,

spair_load_a:
	andi 1,77
	lsh 1,1
	move 1,Aspair(1)
	popj 17,

spair_load_b:
	andi 1,77
	lsh 1,1
	move 1,Aspair+1(1)
	popj 17,

spair_store_a:
	andi 1,77
	lsh 1,1
	movem 2,Aspair(1)
	popj 17,

spair_store_b:
	andi 1,77
	lsh 1,1
	movem 2,Aspair+1(1)
	popj 17,

dpair_load_a:
	andi 1,77
	lsh 1,2
	move 4,Adpair(1)
	move 5,Adpair+1(1)
	move 1,4
	move 2,5
	popj 17,

dpair_load_b:
	andi 1,77
	lsh 1,2
	move 4,Adpair+2(1)
	move 5,Adpair+3(1)
	move 1,4
	move 2,5
	popj 17,

dpair_store_a:
	andi 1,77
	lsh 1,2
	movem 2,Adpair(1)
	movem 3,Adpair+1(1)
	popj 17,

dpair_store_b:
	andi 1,77
	lsh 1,2
	movem 2,Adpair+2(1)
	movem 3,Adpair+3(1)
	popj 17,

q_postinc_load:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

q_postinc_store:
	dpb 2,1
	popj 17,

h_postinc_load:
	ldb 1,1
	hrre 1,1
	popj 17,

h_postinc_store:
	dpb 2,1	; movhi
	popj 17,

s_postinc_load:
	move 1,(1)
	popj 17,

s_postinc_store:
	movem 2,(1)
	popj 17,

d_postinc_load:
	move 4,(1)
	move 5,1(1)
	move 1,4
	move 2,5
	popj 17,

d_postinc_store:
	movem 2,(1)
	movem 3,1(1)
	popj 17,

q_sum_n:
	setzb 6,2
	caml 6,1
	jrst %L615
	subi 1,1
%L616:
	move 3,2
	andi 3,77
	move 4,2
	andi 4,3
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,AQint,8]
	jumpe 4,%L612
%L611:
	ibp 3
	sojn 4,%L611	; decrement_and_branch_until_zero
%L612:
	ldb 4,3
	trne 4,400
	orcmi 4,777
	add 6,4
	addi 2,1
	sojge 1,%L616	; doloop_end
%L615:
	move 1,6
	popj 17,

uq_sum_n:
	setzb 6,2
	caml 6,1
	jrst %L626
	subi 1,1
%L627:
	move 3,2
	andi 3,77
	move 4,2
	andi 4,3
	ash 3,-2	; ashrsi3_pointer
	add 3,[POINT 9,AuQint,8]
	jumpe 4,%L623
%L622:
	ibp 3
	sojn 4,%L622	; decrement_and_branch_until_zero
%L623:
	ldb 3,3
	add 6,3
	addi 2,1
	sojge 1,%L627	; doloop_end
%L626:
	move 1,6
	popj 17,

h_sum_n:
	setzb 6,2
	caml 6,1
	jrst %L637
	subi 1,1
%L638:
	move 3,2
	andi 3,77
	move 4,2
	andi 4,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,AHint,17]
	jumpe 4,%L634
%L633:
	ibp 3
	sojn 4,%L633	; decrement_and_branch_until_zero
%L634:
	ldb 4,3
	hrre 4,4
	add 6,4
	addi 2,1
	sojge 1,%L638	; doloop_end
%L637:
	move 1,6
	popj 17,

uh_sum_n:
	setzb 6,2
	caml 6,1
	jrst %L648
	subi 1,1
%L649:
	move 3,2
	andi 3,77
	move 4,2
	andi 4,1
	ash 3,-1	; ashrsi3_pointer
	add 3,[POINT 18,AuHint,17]
	jumpe 4,%L645
%L644:
	ibp 3
	sojn 4,%L644	; decrement_and_branch_until_zero
%L645:
	ldb 3,3
	add 6,3
	addi 2,1
	sojge 1,%L649	; doloop_end
%L648:
	move 1,6
	popj 17,

s_sum_n:
	setzb 2,3
	caml 2,1
	jrst %L657
	subi 1,1
%L658:
	move 4,3
	andi 4,77
	add 2,ASint(4)
	addi 3,1
	sojge 1,%L658	; doloop_end
%L657:
	move 1,2
	popj 17,

us_sum_n:
	setzb 2,3
	caml 2,1
	jrst %L666
	subi 1,1
%L667:
	move 4,3
	andi 4,77
	add 2,AuSint(4)
	addi 3,1
	sojge 1,%L667	; doloop_end
%L666:
	move 1,2
	popj 17,

d_sum_n:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	movei 12,0
	caml 12,1
	jrst %L675
	subi 1,1
%L676:
	move 4,12
	andi 4,77
	lsh 4,1
	move 6,ADint(4)
	move 7,ADint+1(4)
	move 5,11
	add 5,7
	move 3,5
	tlc 3,400000
	move 2,11
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 4,10
	add 4,6
	add 4,3
	move 10,4
	move 11,5
	addi 12,1
	sojge 1,%L676	; doloop_end
%L675:
	move 1,10
	move 2,11
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

ud_sum_n:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	setzb 10,11
	movei 12,0
	caml 12,1
	jrst %L684
	subi 1,1
%L685:
	move 4,12
	andi 4,77
	lsh 4,1
	move 6,AuDint(4)
	move 7,AuDint+1(4)
	move 5,11
	add 5,7
	move 3,5
	tlc 3,400000
	move 2,11
	tlc 2,400000
	caml 3,2
	tdza 3,3
	movei 3,1
	move 4,10
	add 4,6
	add 4,3
	move 10,4
	move 11,5
	addi 12,1
	sojge 1,%L685	; doloop_end
%L684:
	move 1,10
	move 2,11
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

q_load_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 4,10
	andi 4,3
	andi 10,77
	ash 10,-2	; ashrsi3_pointer
	add 10,[POINT 9,AQint,8]
	jumpe 4,%L688
%L687:
	ibp 10
	sojn 4,%L687	; decrement_and_branch_until_zero
%L688:
	ldb 1,10
	trne 1,400
	orcmi 1,777
	pop 17,10
	popj 17,

q_store_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	andi 11,777	; zero_extendqisi2
	pushj 17,clobber
	move 4,10
	andi 4,3
	andi 10,77
	ash 10,-2	; ashrsi3_pointer
	add 10,[POINT 9,AQint,8]
	jumpe 4,%L691
%L690:
	ibp 10
	sojn 4,%L690	; decrement_and_branch_until_zero
%L691:
	dpb 11,10
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

h_load_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	move 4,10
	andi 4,1
	andi 10,77
	ash 10,-1	; ashrsi3_pointer
	add 10,[POINT 18,AHint,17]
	jumpe 4,%L694
%L693:
	ibp 10
	sojn 4,%L693	; decrement_and_branch_until_zero
%L694:
	ldb 1,10
	hrre 1,1
	pop 17,10
	popj 17,

h_store_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	hrrzi 11,(11)	; zero_extendhisi2
	pushj 17,clobber
	move 4,10
	andi 4,1
	andi 10,77
	ash 10,-1	; ashrsi3_pointer
	add 10,[POINT 18,AHint,17]
	jumpe 4,%L697
%L696:
	ibp 10
	sojn 4,%L696	; decrement_and_branch_until_zero
%L697:
	dpb 11,10	; movhi
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

s_load_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	andi 10,77
	move 1,ASint(10)
	pop 17,10
	popj 17,

s_store_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	pushj 17,clobber
	andi 10,77
	movem 11,ASint(10)
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

d_load_after_call:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 12,1
	pushj 17,clobber
	andi 12,77
	lsh 12,1
	move 10,ADint(12)
	move 11,ADint+1(12)
	move 1,10
	move 2,11
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

d_store_after_call:
	add 17,[3,,3]
	movem 10,-2(17)
	movem 11,-1(17)
	movem 12,(17)
	move 10,1
	move 11,2
	move 12,3
	pushj 17,clobber
	andi 10,77
	lsh 10,1
	movem 11,ADint(10)
	movem 12,ADint+1(10)
	move 10,-2(17)
	move 11,-1(17)
	move 12,(17)
	add 17,[-3,,-3]
	popj 17,

q_load_call_index:
	pushj 17,f
	move 4,1
	andi 4,3
	andi 1,77
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,AQint,8]
	jumpe 4,%L704
%L703:
	ibp 1
	sojn 4,%L703	; decrement_and_branch_until_zero
%L704:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

q_store_call_index:
	push 17,10
	move 10,1
	andi 10,777	; zero_extendqisi2
	pushj 17,f
	move 4,1
	andi 4,3
	andi 1,77
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,AQint,8]
	jumpe 4,%L707
%L706:
	ibp 1
	sojn 4,%L706	; decrement_and_branch_until_zero
%L707:
	dpb 10,1
	pop 17,10
	popj 17,

h_load_call_index:
	pushj 17,f
	move 4,1
	andi 4,1
	andi 1,77
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,AHint,17]
	jumpe 4,%L710
%L709:
	ibp 1
	sojn 4,%L709	; decrement_and_branch_until_zero
%L710:
	ldb 1,1
	hrre 1,1
	popj 17,

h_store_call_index:
	push 17,10
	move 10,1
	hrrzi 10,(10)	; zero_extendhisi2
	pushj 17,f
	move 4,1
	andi 4,1
	andi 1,77
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,AHint,17]
	jumpe 4,%L713
%L712:
	ibp 1
	sojn 4,%L712	; decrement_and_branch_until_zero
%L713:
	dpb 10,1	; movhi
	pop 17,10
	popj 17,

s_load_call_index:
	pushj 17,f
	andi 1,77
	move 1,ASint(1)
	popj 17,

s_store_call_index:
	push 17,10
	move 10,1
	pushj 17,f
	andi 1,77
	movem 10,ASint(1)
	pop 17,10
	popj 17,

d_load_call_index:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	pushj 17,f
	andi 1,77
	lsh 1,1
	move 10,ADint(1)
	move 11,ADint+1(1)
	move 1,10
	move 2,11
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

d_store_call_index:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 10,1
	move 11,2
	pushj 17,f
	andi 1,77
	lsh 1,1
	movem 10,ADint(1)
	movem 11,ADint+1(1)
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

	.bss
AQint:
	.space	64
AuQint:
	.space	64
AHint:
	.space	128
AuHint:
	.space	128
ASint:
	.space	256
AuSint:
	.space	256
ADint:
	.space	512
AuDint:
	.space	512
VAQint:
	.space	64
VAuQint:
	.space	64
VAHint:
	.space	128
VAuHint:
	.space	128
VASint:
	.space	256
VAuSint:
	.space	256
VADint:
	.space	512
VAuDint:
	.space	512
Aqpair:
	.space	256
Ahpair:
	.space	256
Aspair:
	.space	512
Adpair:
	.space	1024
