
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
	move 4,[POINT 9,AQint,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,400
	orcmi 1,777
	popj 17,

store1_Qint:
	andi 3,777	; zero_extendqisi2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L9
%L8:
	ibp 1
	sojn 4,%L8	; decrement_and_branch_until_zero
%L9:
	dpb 3,1
	popj 17,

store2_Qint:
	move 4,[POINT 9,AQint,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

load1_uQint:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L14
%L13:
	ibp 1
	sojn 4,%L13	; decrement_and_branch_until_zero
%L14:
	ldb 1,1
	popj 17,

load2_uQint:
	move 4,[POINT 9,AuQint,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	popj 17,

store1_uQint:
	andi 3,777	; zero_extendqisi2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L19
%L18:
	ibp 1
	sojn 4,%L18	; decrement_and_branch_until_zero
%L19:
	dpb 3,1
	popj 17,

store2_uQint:
	move 4,[POINT 9,AuQint,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

load1_Hint:
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L24
%L23:
	ibp 1
	sojn 4,%L23	; decrement_and_branch_until_zero
%L24:
	ldb 1,1
	hrre 1,1
	popj 17,

load2_Hint:
	move 4,[POINT 18,AHint,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	hrre 1,1
	popj 17,

store1_Hint:
	hrrzi 3,(3)	; zero_extendhisi2
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L29
%L28:
	ibp 1
	sojn 4,%L28	; decrement_and_branch_until_zero
%L29:
	dpb 3,1	; movhi
	popj 17,

store2_Hint:
	move 4,[POINT 18,AHint,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4	; movhi
	popj 17,

load1_uHint:
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L34
%L33:
	ibp 1
	sojn 4,%L33	; decrement_and_branch_until_zero
%L34:
	ldb 1,1
	popj 17,

load2_uHint:
	move 4,[POINT 18,AuHint,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	popj 17,

store1_uHint:
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

store2_uHint:
	move 4,[POINT 18,AuHint,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4	; movhi
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
	move 4,[POINT 9,AQint,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,400
	orcmi 1,777
	popj 17,

uq_load_i:
	move 4,[POINT 9,AuQint,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	popj 17,

h_load_i:
	move 4,[POINT 18,AHint,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	hrre 1,1
	popj 17,

uh_load_i:
	move 4,[POINT 18,AuHint,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
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
	move 4,[POINT 9,AQint,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

uq_store_i:
	move 4,[POINT 9,AuQint,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

h_store_i:
	move 4,[POINT 18,AHint,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4	; movhi
	popj 17,

uh_store_i:
	move 4,[POINT 18,AuHint,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4	; movhi
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
	andi 1,77
	move 4,[POINT 9,AQint,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,400
	orcmi 1,777
	popj 17,

uq_load_masked:
	andi 1,77
	move 4,[POINT 9,AuQint,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	popj 17,

h_load_masked:
	andi 1,77
	move 4,[POINT 18,AHint,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	hrre 1,1
	popj 17,

uh_load_masked:
	andi 1,77
	move 4,[POINT 18,AuHint,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
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
	andi 1,77
	move 4,[POINT 9,AQint,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

uq_store_masked:
	andi 1,77
	move 4,[POINT 9,AuQint,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

h_store_masked:
	andi 1,77
	move 4,[POINT 18,AHint,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4	; movhi
	popj 17,

uh_store_masked:
	andi 1,77
	move 4,[POINT 18,AuHint,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4	; movhi
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
	jumpe 4,%L130
%L129:
	ibp 1
	sojn 4,%L129	; decrement_and_branch_until_zero
%L130:
	ldb 1,1
	trne 1,400
	orcmi 1,777
	popj 17,

uq_ptr_load_i:
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L134
%L133:
	ibp 1
	sojn 4,%L133	; decrement_and_branch_until_zero
%L134:
	ldb 1,1
	popj 17,

h_ptr_load_i:
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L138
%L137:
	ibp 1
	sojn 4,%L137	; decrement_and_branch_until_zero
%L138:
	ldb 1,1
	hrre 1,1
	popj 17,

uh_ptr_load_i:
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L142
%L141:
	ibp 1
	sojn 4,%L141	; decrement_and_branch_until_zero
%L142:
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
	jumpe 4,%L154
%L153:
	ibp 1
	sojn 4,%L153	; decrement_and_branch_until_zero
%L154:
	dpb 3,1
	popj 17,

uq_ptr_store_i:
	andi 3,777	; zero_extendqisi2
	move 4,2
	andi 4,3
	ash 2,-2	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L158
%L157:
	ibp 1
	sojn 4,%L157	; decrement_and_branch_until_zero
%L158:
	dpb 3,1
	popj 17,

h_ptr_store_i:
	hrrzi 3,(3)	; zero_extendhisi2
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L162
%L161:
	ibp 1
	sojn 4,%L161	; decrement_and_branch_until_zero
%L162:
	dpb 3,1	; movhi
	popj 17,

uh_ptr_store_i:
	hrrzi 3,(3)	; zero_extendhisi2
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L166
%L165:
	ibp 1
	sojn 4,%L165	; decrement_and_branch_until_zero
%L166:
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
	addi 1,1
	andi 1,77
	move 4,[POINT 9,AQint,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,400
	orcmi 1,777
	popj 17,

q_load_i_plus_2:
	addi 1,2
	andi 1,77
	move 4,[POINT 9,AQint,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,400
	orcmi 1,777
	popj 17,

q_load_i_minus_1:
	subi 1,1
	andi 1,77
	move 4,[POINT 9,AQint,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,400
	orcmi 1,777
	popj 17,

q_load_sum_index:
	add 1,2
	andi 1,77
	move 4,[POINT 9,AQint,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,400
	orcmi 1,777
	popj 17,

q_load_diff_index:
	sub 1,2
	andi 1,77
	move 4,[POINT 9,AQint,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,400
	orcmi 1,777
	popj 17,

h_load_i_plus_1:
	addi 1,1
	andi 1,77
	move 4,[POINT 18,AHint,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	hrre 1,1
	popj 17,

h_load_i_plus_2:
	addi 1,2
	andi 1,77
	move 4,[POINT 18,AHint,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	hrre 1,1
	popj 17,

h_load_i_minus_1:
	subi 1,1
	andi 1,77
	move 4,[POINT 18,AHint,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	hrre 1,1
	popj 17,

h_load_sum_index:
	add 1,2
	andi 1,77
	move 4,[POINT 18,AHint,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
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
	addi 1,1
	andi 1,77
	move 4,[POINT 9,AQint,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

q_store_i_plus_2:
	addi 1,2
	andi 1,77
	move 4,[POINT 9,AQint,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

q_store_i_minus_1:
	subi 1,1
	andi 1,77
	move 4,[POINT 9,AQint,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

q_store_sum_index:
	add 1,2
	andi 1,77
	move 4,[POINT 9,AQint,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 3,4
	popj 17,

h_store_i_plus_1:
	addi 1,1
	andi 1,77
	move 4,[POINT 18,AHint,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4	; movhi
	popj 17,

h_store_i_plus_2:
	addi 1,2
	andi 1,77
	move 4,[POINT 18,AHint,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4	; movhi
	popj 17,

h_store_i_minus_1:
	subi 1,1
	andi 1,77
	move 4,[POINT 18,AHint,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4	; movhi
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
	andi 1,77
	move 4,[POINT 9,AQint,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	lsh 2,33
	ash 2,-33
	move 1,2
	popj 17,

uq_store_i_return:
	andi 2,777	; zero_extendqisi2
	andi 1,77
	move 4,[POINT 9,AuQint,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	move 1,2
	popj 17,

h_store_i_return:
	hrrzi 2,(2)	; zero_extendhisi2
	andi 1,77
	move 4,[POINT 18,AHint,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4	; movhi
	hrre 2,2
	move 1,2
	popj 17,

uh_store_i_return:
	hrrzi 2,(2)	; zero_extendhisi2
	andi 1,77
	move 4,[POINT 18,AuHint,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4	; movhi
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
	andi 1,77
	move 4,[POINT 9,VAQint,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,400
	orcmi 1,777
	popj 17,

vuq_load_i:
	andi 1,77
	move 4,[POINT 9,VAuQint,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	popj 17,

vh_load_i:
	andi 1,77
	move 4,[POINT 18,VAHint,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	hrre 1,1
	popj 17,

vuh_load_i:
	andi 1,77
	move 4,[POINT 18,VAuHint,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
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
	andi 1,77
	move 4,[POINT 9,VAQint,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

vuq_store_i:
	andi 2,777	; zero_extendqisi2
	andi 1,77
	move 4,[POINT 9,VAuQint,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4
	popj 17,

vh_store_i:
	hrrzi 2,(2)	; zero_extendhisi2
	andi 1,77
	move 4,[POINT 18,VAHint,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4	; movhi
	popj 17,

vuh_store_i:
	hrrzi 2,(2)	; zero_extendhisi2
	andi 1,77
	move 4,[POINT 18,VAuHint,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 2,4	; movhi
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
	jumpe 4,%L231
%L230:
	ibp 1
	sojn 4,%L230	; decrement_and_branch_until_zero
%L231:
	popj 17,

uq_addr_i:
	move 4,1
	andi 4,3
	andi 1,77
	ash 1,-2	; ashrsi3_pointer
	add 1,[POINT 9,AuQint,8]
	jumpe 4,%L236
%L235:
	ibp 1
	sojn 4,%L235	; decrement_and_branch_until_zero
%L236:
	popj 17,

h_addr_i:
	move 4,1
	andi 4,1
	andi 1,77
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,AHint,17]
	jumpe 4,%L241
%L240:
	ibp 1
	sojn 4,%L240	; decrement_and_branch_until_zero
%L241:
	popj 17,

uh_addr_i:
	move 4,1
	andi 4,1
	andi 1,77
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,AuHint,17]
	jumpe 4,%L246
%L245:
	ibp 1
	sojn 4,%L245	; decrement_and_branch_until_zero
%L246:
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
	jumpe 4,%L262
%L261:
	ibp 1
	sojn 4,%L261	; decrement_and_branch_until_zero
%L262:
	popj 17,

h_ptr_addr_i:
	move 4,2
	andi 4,1
	ash 2,-1	; ashrsi3_pointer
	add 1,2
	jumpe 4,%L266
%L265:
	ibp 1
	sojn 4,%L265	; decrement_and_branch_until_zero
%L266:
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
	jumpe 4,%L275
%L274:
	ibp 1
	sojn 4,%L274	; decrement_and_branch_until_zero
%L275:
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
	jumpe 4,%L280
%L279:
	ibp 1
	sojn 4,%L279	; decrement_and_branch_until_zero
%L280:
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
	jumpe 4,%L291
%L290:
	ibp 1
	sojn 4,%L290	; decrement_and_branch_until_zero
%L291:
	dpb 2,1
	popj 17,

h_addr_store_i:
	hrrzi 2,(2)	; zero_extendhisi2
	move 4,1
	andi 4,1
	andi 1,77
	ash 1,-1	; ashrsi3_pointer
	add 1,[POINT 18,AHint,17]
	jumpe 4,%L296
%L295:
	ibp 1
	sojn 4,%L295	; decrement_and_branch_until_zero
%L296:
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
	andi 1,77
	move 3,[POINT 9,AQint,8]
	move 0,1
	jumple 0,.+3
	ibp 3
	sojg 0,.-1
	ldb 4,3
	addi 4,1
	dpb 4,3
	popj 17,

q_inc_i_return:
	andi 1,77
	move 3,[POINT 9,AQint,8]
	move 0,1
	jumple 0,.+3
	ibp 3
	sojg 0,.-1
	ldb 1,3
	addi 1,1
	dpb 1,3
	lsh 1,33
	ash 1,-33
	popj 17,

uq_inc_i:
	andi 1,77
	move 3,[POINT 9,AuQint,8]
	move 0,1
	jumple 0,.+3
	ibp 3
	sojg 0,.-1
	ldb 4,3
	addi 4,1
	dpb 4,3
	popj 17,

uq_inc_i_return:
	andi 1,77
	move 3,[POINT 9,AuQint,8]
	move 0,1
	jumple 0,.+3
	ibp 3
	sojg 0,.-1
	ldb 1,3
	addi 1,1
	dpb 1,3
	andi 1,777
	popj 17,

h_inc_i:
	andi 1,77
	move 3,[POINT 18,AHint,17]
	move 0,1
	jumple 0,.+3
	ibp 3
	sojg 0,.-1
	ldb 4,3
	addi 4,1
	dpb 4,3	; movhi
	popj 17,

h_inc_i_return:
	andi 1,77
	move 3,[POINT 18,AHint,17]
	move 0,1
	jumple 0,.+3
	ibp 3
	sojg 0,.-1
	ldb 1,3
	addi 1,1
	dpb 1,3	; movhi
	hrre 1,1
	popj 17,

uh_inc_i:
	andi 1,77
	move 3,[POINT 18,AuHint,17]
	move 0,1
	jumple 0,.+3
	ibp 3
	sojg 0,.-1
	ldb 4,3
	addi 4,1
	dpb 4,3	; movhi
	popj 17,

uh_inc_i_return:
	andi 1,77
	move 3,[POINT 18,AuHint,17]
	move 0,1
	jumple 0,.+3
	ibp 3
	sojg 0,.-1
	ldb 1,3
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
	movei 6,0
	caml 6,2
	popj 17,
	subi 2,1
%L330:
	move 4,6
	andi 4,77
	move 7,[POINT 9,AQint,8]
	move 0,4
	jumple 0,.+3
	ibp 7
	sojg 0,.-1
	move 3,6
	andi 3,3
	move 4,6
	ash 4,-2	; ashrsi3_pointer
	add 4,1
	jumpe 3,%L326
%L325:
	ibp 4
	sojn 3,%L325	; decrement_and_branch_until_zero
%L326:
	ldb 4,4
	dpb 4,7
	addi 6,1
	sojge 2,%L330	; doloop_end
	popj 17,

q_copy_out:
	movei 6,0
	caml 6,2
	popj 17,
	move 7,[POINT 9,AQint,8]
	subi 2,1
%L342:
	move 4,6
	andi 4,3
	move 3,6
	ash 3,-2	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L338
%L337:
	ibp 3
	sojn 4,%L337	; decrement_and_branch_until_zero
%L338:
	move 4,6
	andi 4,77
	move 5,7
	move 0,4
	jumple 0,.+3
	ibp 5
	sojg 0,.-1
	ldb 4,5
	dpb 4,3
	addi 6,1
	sojge 2,%L342	; doloop_end
	popj 17,

h_copy_in:
	movei 6,0
	caml 6,2
	popj 17,
	subi 2,1
%L354:
	move 4,6
	andi 4,77
	move 7,[POINT 18,AHint,17]
	move 0,4
	jumple 0,.+3
	ibp 7
	sojg 0,.-1
	move 3,6
	andi 3,1
	move 4,6
	ash 4,-1	; ashrsi3_pointer
	add 4,1
	jumpe 3,%L350
%L349:
	ibp 4
	sojn 3,%L349	; decrement_and_branch_until_zero
%L350:
	ldb 4,4
	dpb 4,7	; movhi
	addi 6,1
	sojge 2,%L354	; doloop_end
	popj 17,

h_copy_out:
	movei 6,0
	caml 6,2
	popj 17,
	move 7,[POINT 18,AHint,17]
	subi 2,1
%L366:
	move 4,6
	andi 4,1
	move 3,6
	ash 3,-1	; ashrsi3_pointer
	add 3,1
	jumpe 4,%L362
%L361:
	ibp 3
	sojn 4,%L361	; decrement_and_branch_until_zero
%L362:
	move 4,6
	andi 4,77
	move 5,7
	move 0,4
	jumple 0,.+3
	ibp 5
	sojg 0,.-1
	ldb 4,5
	dpb 4,3	; movhi
	addi 6,1
	sojge 2,%L366	; doloop_end
	popj 17,

s_copy_in:
	movei 3,0
	caml 3,2
	popj 17,
	subi 2,1
%L376:
	move 4,3
	andi 4,77
	move 6,(1)
	movem 6,ASint(4)
	addi 1,1
	addi 3,1
	sojge 2,%L376	; doloop_end
	popj 17,

s_copy_out:
	movei 3,0
	caml 3,2
	popj 17,
	subi 2,1
%L386:
	move 4,3
	andi 4,77
	move 4,ASint(4)
	movem 4,(1)
	addi 1,1
	addi 3,1
	sojge 2,%L386	; doloop_end
	popj 17,

d_copy_in:
	movei 3,0
	caml 3,2
	popj 17,
	subi 2,1
%L396:
	move 4,3
	andi 4,77
	lsh 4,1
	move 6,(1)
	movem 6,ADint(4)
	move 6,1(1)
	movem 6,ADint+1(4)
	addi 1,2
	addi 3,1
	sojge 2,%L396	; doloop_end
	popj 17,

d_copy_out:
	movei 3,0
	caml 3,2
	popj 17,
	subi 2,1
%L406:
	move 4,3
	andi 4,77
	lsh 4,1
	move 6,ADint(4)
	movem 6,(1)
	move 4,ADint+1(4)
	movem 4,1(1)
	addi 1,2
	addi 3,1
	sojge 2,%L406	; doloop_end
	popj 17,

q_if_eq_zero:
	andi 1,77
	move 4,[POINT 9,AQint,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	skipe 4
	tdza 1,1
	movei 1,1
	popj 17,

q_if_lt_zero:
	andi 1,77
	move 4,[POINT 9,AQint,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	trne 4,400
	orcmi 4,777
	seto 1,
	jumpl 4,%L409
	movei 1,1
%L409:
	popj 17,

uq_if_gt_0177:
	andi 1,77
	move 4,[POINT 9,AuQint,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	tlo 1,400000
	move 6,[-377777777601]
	camg 1,6
	tdza 1,1
	movei 1,1
	popj 17,

h_if_eq_zero:
	andi 1,77
	move 4,[POINT 18,AHint,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	skipe 4
	tdza 1,1
	movei 1,1
	popj 17,

h_if_lt_zero:
	andi 1,77
	move 4,[POINT 18,AHint,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 4,4
	hrre 4,4
	seto 1,
	jumpl 4,%L415
	movei 1,1
%L415:
	popj 17,

uh_if_gt_077777:
	andi 1,77
	move 4,[POINT 18,AuHint,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
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
	jrst %L425
%L424:
	movei 1,0
%L423:
	popj 17,
%L425:
	movei 1,1
	move 4,1(4)
	came 4,3
	jrst %L424
	popj 17,

qpair_load_a:
	andi 1,77
	move 1,Aqpair+pdp10.c:7954:TOOBIG:(1)
	ash 1,-33
	popj 17,

qpair_load_b:
	andi 1,77
	move 1,Aqpair+pdp10.c:7954:TOOBIG:(1)
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
	dpb 2,[POINT 9,Aqpair+pdp10.c:7954:TOOBIG:(1),17]
	popj 17,

hpair_load_a:
	andi 1,77
	hlre 1,Ahpair+pdp10.c:7954:TOOBIG:(1)
	popj 17,

hpair_load_b:
	andi 1,77
	hrre 1,Ahpair+pdp10.c:7954:TOOBIG:(1)
	popj 17,

hpair_store_a:
	andi 1,77
	add 1,[POINT 18,Ahpair,17]
	hrlm 2,(1)
	popj 17,

hpair_store_b:
	andi 1,77
	hrrm 2,Ahpair+pdp10.c:7954:TOOBIG:(1)
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
	setzb 2,3
	caml 2,1
	jrst %L457
	move 6,[POINT 9,AQint,8]
	subi 1,1
%L458:
	move 4,3
	andi 4,77
	move 7,6
	move 0,4
	jumple 0,.+3
	ibp 7
	sojg 0,.-1
	ldb 4,7
	trne 4,400
	orcmi 4,777
	add 2,4
	addi 3,1
	sojge 1,%L458	; doloop_end
%L457:
	move 1,2
	popj 17,

uq_sum_n:
	setzb 2,3
	caml 2,1
	jrst %L466
	move 6,[POINT 9,AuQint,8]
	subi 1,1
%L467:
	move 4,3
	andi 4,77
	move 7,6
	move 0,4
	jumple 0,.+3
	ibp 7
	sojg 0,.-1
	ldb 4,7
	add 2,4
	addi 3,1
	sojge 1,%L467	; doloop_end
%L466:
	move 1,2
	popj 17,

h_sum_n:
	setzb 2,3
	caml 2,1
	jrst %L475
	move 6,[POINT 18,AHint,17]
	subi 1,1
%L476:
	move 4,3
	andi 4,77
	move 7,6
	move 0,4
	jumple 0,.+3
	ibp 7
	sojg 0,.-1
	ldb 4,7
	hrre 4,4
	add 2,4
	addi 3,1
	sojge 1,%L476	; doloop_end
%L475:
	move 1,2
	popj 17,

uh_sum_n:
	setzb 2,3
	caml 2,1
	jrst %L484
	move 6,[POINT 18,AuHint,17]
	subi 1,1
%L485:
	move 4,3
	andi 4,77
	move 7,6
	move 0,4
	jumple 0,.+3
	ibp 7
	sojg 0,.-1
	ldb 4,7
	add 2,4
	addi 3,1
	sojge 1,%L485	; doloop_end
%L484:
	move 1,2
	popj 17,

s_sum_n:
	setzb 2,3
	caml 2,1
	jrst %L493
	subi 1,1
%L494:
	move 4,3
	andi 4,77
	add 2,ASint(4)
	addi 3,1
	sojge 1,%L494	; doloop_end
%L493:
	move 1,2
	popj 17,

us_sum_n:
	setzb 2,3
	caml 2,1
	jrst %L502
	subi 1,1
%L503:
	move 4,3
	andi 4,77
	add 2,AuSint(4)
	addi 3,1
	sojge 1,%L503	; doloop_end
%L502:
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
	jrst %L511
	subi 1,1
%L512:
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
	sojge 1,%L512	; doloop_end
%L511:
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
	jrst %L520
	subi 1,1
%L521:
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
	sojge 1,%L521	; doloop_end
%L520:
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
	andi 10,77
	move 4,[POINT 9,AQint,8]
	move 0,10
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,400
	orcmi 1,777
	pop 17,10
	popj 17,

q_store_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	andi 10,777	; zero_extendqisi2
	pushj 17,clobber
	andi 11,77
	move 4,[POINT 9,AQint,8]
	move 0,11
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 10,4
	move 10,-1(17)
	move 11,(17)
	add 17,[-2,,-2]
	popj 17,

h_load_after_call:
	push 17,10
	move 10,1
	pushj 17,clobber
	andi 10,77
	move 4,[POINT 18,AHint,17]
	move 0,10
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	hrre 1,1
	pop 17,10
	popj 17,

h_store_after_call:
	add 17,[2,,2]
	movem 10,-1(17)
	movem 11,(17)
	move 11,1
	move 10,2
	hrrzi 10,(10)	; zero_extendhisi2
	pushj 17,clobber
	andi 11,77
	move 4,[POINT 18,AHint,17]
	move 0,11
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 10,4	; movhi
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
	andi 1,77
	move 4,[POINT 9,AQint,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	trne 1,400
	orcmi 1,777
	popj 17,

q_store_call_index:
	push 17,10
	move 10,1
	andi 10,777	; zero_extendqisi2
	pushj 17,f
	andi 1,77
	move 4,[POINT 9,AQint,8]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 10,4
	pop 17,10
	popj 17,

h_load_call_index:
	pushj 17,f
	andi 1,77
	move 4,[POINT 18,AHint,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	ldb 1,4
	hrre 1,1
	popj 17,

h_store_call_index:
	push 17,10
	move 10,1
	hrrzi 10,(10)	; zero_extendhisi2
	pushj 17,f
	andi 1,77
	move 4,[POINT 18,AHint,17]
	move 0,1
	jumple 0,.+3
	ibp 4
	sojg 0,.-1
	dpb 10,4	; movhi
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
